Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03023A2B08
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFJMIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:08:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230245AbhFJMIP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623326779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A2UDZiK1B1BG+nJJuHhQBE+ymkNJbiMVhdukooVpXDs=;
        b=XOosOUCBqYeo7D7a6LN7wJvhtnRRHoC1Eeq8Vt/h7KlAOaxNh78CKgPs2wBPzZQEBDeuZr
        CX5hziW1Y05QeVOs0lt8d38wV3diGzh5vTBeGo2+m2pG6iDrnJLa5/xdl9QOmytPgg3tpd
        Zq0U7IHBAs9QeNo3H02Ow9guWj1DOIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-bBEVSxSxOGKi1jgpt2W1SQ-1; Thu, 10 Jun 2021 08:06:17 -0400
X-MC-Unique: bBEVSxSxOGKi1jgpt2W1SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFBCC801B12;
        Thu, 10 Jun 2021 12:06:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8279B19C45;
        Thu, 10 Jun 2021 12:06:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, bgardon@google.com
Subject: [PATCH 0/2] KVM: Don't take mmu_lock for range invalidation unless necessary
Date:   Thu, 10 Jun 2021 08:06:13 -0400
Message-Id: <20210610120615.172224-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is my take on Sean's patch to restrict taking the mmu_lock in the
MMU notifiers.  The first patch includes the locking changes, while
the second is the optimization.

Paolo Bonzini (1):
  KVM: Block memslot updates across range_start() and range_end()

Sean Christopherson (1):
  KVM: Don't take mmu_lock for range invalidation unless necessary

 Documentation/virt/kvm/locking.rst |  6 +++
 include/linux/kvm_host.h           | 10 +++-
 virt/kvm/kvm_main.c                | 79 ++++++++++++++++++++++++------
 3 files changed, 78 insertions(+), 17 deletions(-)

-- 
2.27.0

