Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CB535008A
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhCaMll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 08:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235607AbhCaMlj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 08:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617194499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IdSm0cCmMirXzthvLuhUlAlHbcDycfb8nBgHo5E0Cf8=;
        b=YMekVIpMuaZdSQbHi7WlfpZvDnyIbzaiC+hctC+X2WLd2LUPLaEtXlxcoIESoTSGw7xDai
        SwGhp/yLEvy+B+rrAZmDpkFtANqE3FczRNnlwcSBnpz3MoE3Ee6W4rHFss0vFHgUTTFfMp
        v6KOxRfm0sI75Er/fOyY5/Q9wNMLvPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502--Y7f6qVWM6mOYwQULFFmgQ-1; Wed, 31 Mar 2021 08:41:36 -0400
X-MC-Unique: -Y7f6qVWM6mOYwQULFFmgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 069DE807907;
        Wed, 31 Mar 2021 12:41:35 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBC0D60861;
        Wed, 31 Mar 2021 12:41:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] KVM: x86: hyper-v: Fix TSC page update after KVM_SET_CLOCK(0) call
Date:   Wed, 31 Mar 2021 14:41:28 +0200
Message-Id: <20210331124130.337992-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- Fix the issue by using master_kernel_ns/get_kvmclock_base_ns() instead of
 get_kvmclock_ns() when handling KVM_SET_CLOCK.
- Rebase on Paolo's "KVM: x86: fix lockdep splat due to Xen runstate
 update" series and use spin_lock_irq()/spin_unlock_irq() [Paolo]

Original description:

I discovered that after KVM_SET_CLOCK(0) TSC page value in the guest can
go through the roof and apparently we have a signedness issue when the
update is performed. Fix the issue and add a selftest.

Vitaly Kuznetsov (2):
  KVM: x86: Prevent 'hv_clock->system_time' from going negative in
    kvm_guest_time_update()
  selftests: kvm: Check that TSC page value is small after
    KVM_SET_CLOCK(0)

 arch/x86/kvm/x86.c                            | 19 +++++++++++++++++--
 .../selftests/kvm/x86_64/hyperv_clock.c       | 13 +++++++++++--
 2 files changed, 28 insertions(+), 4 deletions(-)

-- 
2.30.2

