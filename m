Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFEA34EEA2
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhC3RAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:00:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232190AbhC3RAG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617123606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=boHgOYjxaOQQWEyS/lxfTaWYnwFmFjR45ql5WkUeRs0=;
        b=ECguLRZ9lu/FlKspCWuuHjTIUPBkB2y2ZDMbqJ8kU9sCAcV4NOg53vw4tf8jovpJsym/jJ
        QA5xLdXWdoia+39PnXbn0O3+ir6QwQbA+nivBncZ2+Ms2iI7JZY3je8/9Ss5z8A01v/8FG
        5VNqPeQKpSgXo/AnW+3Xcdz5Z9yhL00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-N-5MNFv9N-Sw4gxVlCypDA-1; Tue, 30 Mar 2021 13:00:02 -0400
X-MC-Unique: N-5MNFv9N-Sw4gxVlCypDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 907D4107ACCD;
        Tue, 30 Mar 2021 16:59:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FF4C59442;
        Tue, 30 Mar 2021 16:59:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com, dwmw@amazon.co.uk
Subject: [PATCH 0/2] KVM: x86: fix lockdep splat due to Xen runstate update
Date:   Tue, 30 Mar 2021 12:59:56 -0400
Message-Id: <20210330165958.3094759-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pvclock_gtod_sync_lock can be taken with interrupts disabled if the
preempt notifier calls get_kvmclock_ns to update the Xen
runstate information:

   spin_lock include/linux/spinlock.h:354 [inline]
   get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
   kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
   kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
   kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
   kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062

So change the users of the spinlock to spin_lock_irqsave and
spin_unlock_irqrestore.  Before doing that, patch 1 just makes
the pvclock_gtod_sync_lock critical sections as small as possible
so that the resulting irq-disabled sections are easier to review.

Paolo

Paolo Bonzini (2):
  KVM: x86: reduce pvclock_gtod_sync_lock critical sections
  KVM: x86: disable interrupts while pvclock_gtod_sync_lock is taken

 arch/x86/kvm/x86.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

-- 
2.26.2

