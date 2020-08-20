Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F38324C82F
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 01:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgHTXGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 19:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgHTXGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 19:06:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BD4C061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 16:06:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n19so195636ybf.0
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 16:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=TsA9eo6gus4tmwAOJeW6cMJwIWxsbvKQsdWBenQmfc8=;
        b=ZVw4lRp2WPxpzwrLYPQ0zYWa9MejRcHXz4yw3Ny9ZuSw2wukA594d5J9LRW73sepsz
         soyDdk+y5dHIFTka/pZCRhDk9DFitmVjpX8BnWSoMKwtntf5I5/LOV2FCUGBs4PzBcad
         AGO86s3IonSfEkvL5qbfuMIJVh5z5RHNeQzAI80W/glhMzSYOLe5HPezJt52iNL30QUR
         0gacfFjg7ElRimXFb+3FzQGdxcRCk3yEA0Zd8z6WfEhrFCmu1q1ObKTZ/BO10RV0bV7b
         1l9ig1ZybvI6DJLVCehieMUoEjJvgzG5t7Ki0Mug03OwdvaimRYon7iTd1/DKGDNfKSl
         //+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=TsA9eo6gus4tmwAOJeW6cMJwIWxsbvKQsdWBenQmfc8=;
        b=QMjPeTow1wMUIhW44DLnpiypwVfcaDYGnsMawhxcssLLQ221KaPQN4ovzDTAkaxdXD
         iaQM63/GQvQV/4fMebLy4G1rKBTsHWTy3hOLAZvr3xhWsXbga6A7KDMgI2FfpLztLfJm
         08SK8yZHCDfNRatO5Pv7m90ZRd50dD0AcmHwpg7s7ydTQ2kDa5zXqJpOIlAxXEtNRFop
         yUlWtFuDo4dD6z+m8M5MUKezYdOhgFhhGh3LLBfSjZoeQuYK/EGVC4C1sj4pyC4vuCXD
         VT5PzfkuWOuSMUlpR5dtBqZpvRfJn4kErtNE1RwhBFWawyI7e+/KhAS/iobucCjcRyDb
         QktQ==
X-Gm-Message-State: AOAM531A/ZXkXMAfmck76eJLy/K3Y4w+ZfzfrRMoXwn5aMsCEPbjZYCX
        qG5T3esr7QzWmPZuGp5JfZ1QfKY5kXGtUwyNsQBNqS3OT2L3GvZsYOL5BVTJSltsnLQpzKlTdDo
        FbmYu4wCRO1J4cvjUfbJldF2f1qICJYG6pG8pyl4cy4KxCqsRqO1cLaKQQw==
X-Google-Smtp-Source: ABdhPJxApaoxhQoGQMNnAMKhy7xJ6k4Mc68ZmUsGWnOwK2JJ4w7jNisP4PMnNLJ09HJpamsMsjMnsd8cb8g=
X-Received: from pshier-linuxworkstation.sea.corp.google.com
 ([2620:15c:100:202:a28c:fdff:fee1:c360]) (user=pshier job=sendgmr) by
 2002:a25:d486:: with SMTP id m128mr121838ybf.188.1597964796987; Thu, 20 Aug
 2020 16:06:36 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:05:45 -0700
Message-Id: <20200820230545.2411347-1-pshier@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v2] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates detected
From:   Peter Shier <pshier@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L2 uses PAE, L0 intercepts of L2 writes to CR0/CR3/CR4 call
load_pdptrs to read the possibly updated PDPTEs from the guest
physical address referenced by CR3.  It loads them into
vcpu->arch.walk_mmu->pdptrs and sets VCPU_EXREG_PDPTR in
vcpu->arch.regs_dirty.

At the subsequent assumed reentry into L2, the mmu will call
vmx_load_mmu_pgd which calls ept_load_pdptrs. ept_load_pdptrs sees
VCPU_EXREG_PDPTR set in vcpu->arch.regs_dirty and loads
VMCS02.GUEST_PDPTRn from vcpu->arch.walk_mmu->pdptrs[]. This all works
if the L2 CRn write intercept always resumes L2.

The resume path calls vmx_check_nested_events which checks for
exceptions, MTF, and expired VMX preemption timers. If
vmx_check_nested_events finds any of these conditions pending it will
reflect the corresponding exit into L1. Live migration at this point
would also cause a missed immediate reentry into L2.

After L1 exits, vmx_vcpu_run calls vmx_register_cache_reset which
clears VCPU_EXREG_PDPTR in vcpu->arch.regs_dirty.  When L2 next
resumes, ept_load_pdptrs finds VCPU_EXREG_PDPTR clear in
vcpu->arch.regs_dirty and does not load VMCS02.GUEST_PDPTRn from
vcpu->arch.walk_mmu->pdptrs[]. prepare_vmcs02 will then load
VMCS02.GUEST_PDPTRn from vmcs12->pdptr0/1/2/3 which contain the stale
values stored at last L2 exit. A repro of this bug showed L2 entering
triple fault immediately due to the bad VMCS02.GUEST_PDPTRn values.

When L2 is in PAE paging mode add a call to ept_load_pdptrs before
leaving L2. This will update VMCS02.GUEST_PDPTRn if they are dirty in
vcpu->arch.walk_mmu->pdptrs[].

Tested:
kvm-unit-tests with new directed test: vmx_mtf_pdpte_test.
Verified that test fails without the fix.

Also ran Google internal VMM with an Ubuntu 16.04 4.4.0-83 guest running a
custom hypervisor with a 32-bit Windows XP L2 guest using PAE. Prior to fix
would repro readily. Ran 14 simultaneous L2s for 140 iterations with no
failures.

Signed-off-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
v1 -> v2:

* Per Sean's suggestion removed the new x86 op and calling ept_load_pdptrs from
  nested_vmx_vmexit

 arch/x86/kvm/vmx/nested.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.c    | 4 ++--
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c9..4d46025213e9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4404,6 +4404,13 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
 
+	/*
+	 * Ensure that the VMCS02 PDPTR fields are up-to-date before switching
+	 * to L1.
+	 */
+	if (enable_ept && is_pae_paging(vcpu))
+		vmx_ept_load_pdptrs(vcpu);
+
 	leave_guest_mode(vcpu);
 
 	if (nested_cpu_has_preemption_timer(vmcs12))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..19a599bebd5c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2971,7 +2971,7 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(to_vmx(vcpu)->vpid);
 }
 
-static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
+void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
@@ -3114,7 +3114,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 			guest_cr3 = vcpu->arch.cr3;
 		else /* vmcs01.GUEST_CR3 is already up-to-date. */
 			update_guest_cr3 = false;
-		ept_load_pdptrs(vcpu);
+		vmx_ept_load_pdptrs(vcpu);
 	} else {
 		guest_cr3 = pgd;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 26175a4759fa..a2f82127c170 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,7 +356,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
+void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
