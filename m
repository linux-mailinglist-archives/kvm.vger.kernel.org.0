Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9474921B800
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgGJOMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727861AbgGJOMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 10:12:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tC/RDuBXGV/0eBPfyMsRxhpj4+FXW/fTZ0b83kArGak=;
        b=i+rSYatf8DuJcr6S6MR9boPxcOpW8fI4vMGGLt6kCpibNhGHiQddatCesT6IbXb9Ifa6OU
        qJTWnJfTQqFtsPHCTQ0YMyuRZiQFDmthojnlnwRRHf4PFof6bAMMmmtcIM3BxU12k9kJmC
        S1dlwtPfYggU6N6QPD7pVKFIQOEubnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-8WEcPZc2OI29-Fy4J8_xCg-1; Fri, 10 Jul 2020 10:12:03 -0400
X-MC-Unique: 8WEcPZc2OI29-Fy4J8_xCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B2B8186A8E3;
        Fri, 10 Jul 2020 14:12:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF53774F5E;
        Fri, 10 Jul 2020 14:11:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/9] KVM: nSVM: fixes for CR3/MMU switch upon nested guest entry/exit
Date:   Fri, 10 Jul 2020 16:11:48 +0200
Message-Id: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v3:
- Swapped my "KVM: nSVM: stop dereferencing vcpu->arch.mmu to get the
 context in kvm_init_shadow{,_npt}_mmu()" with Paolo's "KVM: MMU: stop
 dereferencing vcpu->arch.mmu to get the context for MMU init".
- keeping nested_svm_init_mmu_context() in nested_prepare_vmcb_control()
 as this is also used from svm_set_nested_state() [Paolo],
 nested_svm_load_cr3() becomes a separate step in enter_svm_guest_mode().
- nested_prepare_vmcb_save() remains 'void' [Paolo]

Original description:

This is a successor of "[PATCH v2 0/3] KVM: nSVM: fix #TF from CR3 switch
when entering guest" and "[PATCH] KVM: x86: drop erroneous mmu_check_root()
from fast_pgd_switch()".

The snowball is growing fast! It all started with an intention to fix
the particular 'tripple fault' issue (now fixed by PATCH7) but now we
also get rid of unconditional kvm_mmu_reset_context() upon nested guest
entry/exit and make the code resemble nVMX. There is still a huge room
for further improvement (proper error propagation, removing unconditional
MMU sync/TLB flush,...) but at least we're making some progress.

Tested with kvm selftests/kvm-unit-tests and by running nested Hyper-V
on KVM. The series doesn't seem to introduce any new issues.

Paolo Bonzini (1):
  KVM: MMU: stop dereferencing vcpu->arch.mmu to get the context for MMU
    init

Vitaly Kuznetsov (8):
  KVM: nSVM: split kvm_init_shadow_npt_mmu() from kvm_init_shadow_mmu()
  KVM: nSVM: reset nested_run_pending upon nested_svm_vmrun_msrpm()
    failure
  KVM: nSVM: prepare to handle errors from enter_svm_guest_mode()
  KVM: nSVM: introduce nested_svm_load_cr3()/nested_npt_enabled()
  KVM: nSVM: move kvm_set_cr3() after nested_svm_uninit_mmu_context()
  KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest
    switch
  KVM: nSVM: use nested_svm_load_cr3() on guest->host switch
  KVM: x86: drop superfluous mmu_check_root() from fast_pgd_switch()

 arch/x86/kvm/mmu.h        |  3 +-
 arch/x86/kvm/mmu/mmu.c    | 45 ++++++++++++------
 arch/x86/kvm/svm/nested.c | 97 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.c    |  6 ++-
 arch/x86/kvm/svm/svm.h    |  4 +-
 5 files changed, 110 insertions(+), 45 deletions(-)

-- 
2.25.4

