Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29481513F18
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353304AbiD1Xhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 19:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiD1Xhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 19:37:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F101AAAB58
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:34:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso3388760plg.23
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=5pHMEPma0oFr5+q1aO+yvgHhZ7a6IOyPSMScr6+UUVc=;
        b=VdD/vwCpVCQmuzzeiGHOQjtnPQKhgTj8VnaCOizDpYuelZytsGrrdNBH/qNgJeNXoI
         ErN9xys17CpClOm5qqyY0Po+S5wqgmwiN5KklpowCvQaV5zSsTC2pT3S6QZ9H9pTT+HS
         mU+WB7BiVzVMUQnLJTBDPIJ4hLh7DSR2MGI0V74mb2UiRqzGllmy90uIiwwH84w/IUv7
         IUCwODfZS3a7G43sn12Firxn1+02nNTw9cFIDSP3Q0IZSq9EpX0RklKp//snXiuafF1m
         Yfw7JAp8+SAI3o83AWR+RUe4t24z7bXn/y9TH/GYlZazc5wsE9CmmY50du5RfczCNyZx
         igww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=5pHMEPma0oFr5+q1aO+yvgHhZ7a6IOyPSMScr6+UUVc=;
        b=506mBwJI3fCDH0QVqbYxNU7jjPm0Cq4x8G8y3mc8u4wyBFLtpecU9mXNP8HMBGU/UY
         DSjPJm3V0Fck9F/bQg9Ooi+tIKzgd7nOBLdEf5R6+tLQWLNAunD3I5K1kz2JKVB0AM0B
         Zxv5uFrqIXSeShbRk6D5b+kgh7lptdSGWUL+5tjucvLopHaUUyMad+PX2pT7UxeBArf2
         STAM8uxAmcTAK6deAyV+lS8GMtEHVynTxRpuno/70Gan4yW9dDvjUdxjWaoofe9/qdtE
         2i/aLK56Gbm+xP8Fjh+rg6FYsoXnHJFRbyORM46DqaQVFfJ/7DO/eP54yP6Hh1DiCBal
         1p5A==
X-Gm-Message-State: AOAM530Z9/oubaFma+A/gBDfLdtMtWyAQDV0KI0QqAfKohCUrtlIaOBV
        3Duwutad+f/EUse4pUyMrLdtMQtHbJs=
X-Google-Smtp-Source: ABdhPJyP1oIGL2MjKOc17LUccRNWwj31R5OHG8G+bLaOk//awuStItppfdPfNFSZ77flropLhdrXvbEavjM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8304:b0:155:d594:5c04 with SMTP id
 bd4-20020a170902830400b00155d5945c04mr35348308plb.105.1651188862437; Thu, 28
 Apr 2022 16:34:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Apr 2022 23:34:16 +0000
Message-Id: <20220428233416.2446833-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed host.MAXPHYADDR
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disallow memslots and MMIO SPTEs whose gpa range would exceed the host's
MAXPHYADDR, i.e. don't create SPTEs for gfns that exceed host.MAXPHYADDR.
The TDP MMU bounds its zapping based on host.MAXPHYADDR, and so if the
guest, possibly with help from userspace, manages to coerce KVM into
creating a SPTE for an "impossible" gfn, KVM will leak the associated
shadow pages (page tables).

On bare metal, encountering an impossible gpa in the page fault path is
well and truly impossible, barring CPU bugs, as the CPU will signal #PF
during the gva=>gpa translation (or a similar failure when stuffing a
physical address into e.g. the VMCS/VMCB).  But if KVM is running as a VM
itself, the MAXPHYADDR enumerated to KVM may not be the actual MAXPHYADDR
of the underlying hardware, in which case the hardware will not fault on
the illegal-from-KVM's-perspective gpa.

Alternatively, KVM could continue allowing the dodgy behavior and simply
zap the max possible range.  But, for hosts with MAXPHYADDR < 52, that's
a (minor) waste of cycles, and more importantly, KVM can't reasonably
support impossible memslots when running on bare metal (or with an
accurate MAXPHYADDR as a VM).  Note, limiting the overhead by checking if
KVM is running as a guest is not a safe option as the host isn't required
to announce itself to the guest in any way, e.g. doesn't need to set the
HYPERVISOR CPUID bit.

A second alternative to disallowing the memslot behavior would be to
disallow creating a VM with guest.MAXPHYADDR > host.MAXPHYADDR.  That
restriction is undesirable as there are legitimate use cases for doing
so, e.g. using the highest host.MAXPHYADDR out of a pool of heterogeneous
systems so that VMs can be migrated between hosts with different
MAXPHYADDRs without running afoul of the allow_smaller_maxphyaddr mess.

Opportunistically make the now common kvm_mmu_max_gfn_host() inclusive
instead of exclusive.  The inclusive approach is somewhat silly as the
memslot and TDP MMU code want an exclusive value, but the name implies
the returned value is inclusive, and the MMIO path needs an inclusive
check.

  WARNING: CPU: 10 PID: 1122 at arch/x86/kvm/mmu/tdp_mmu.c:57
                                kvm_mmu_uninit_tdp_mmu+0x4b/0x60 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 10 PID: 1122 Comm: set_memory_regi Tainted: G        W         5.18.0-rc1+ #293
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x4b/0x60 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_destroy_vm+0x130/0x1b0 [kvm]
   kvm_destroy_vm+0x162/0x2d0 [kvm]
   kvm_vm_release+0x1d/0x30 [kvm]
   __fput+0x82/0x240
   task_work_run+0x5b/0x90
   exit_to_user_mode_prepare+0xd2/0xe0
   syscall_exit_to_user_mode+0x1d/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 524a1e4e381f ("KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all SPTEs")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Maxim, I didn't add you as Reported-by because I'm not confident this is
actually the cause of the bug you're hitting.  I wasn't able to reproduce
using your ipi_stress test, I found this horror via inspection and proved
it by hacking a selftest.

That said, I'm holding out hope that this does fix your issue.  Your
config doesn't specify host-phys-bits and IIUC you haven't been able to
repro on bare metal, which fits the kvm.MAXPHYADDR < cpu.MAXPHYADDR
scenario.  In theory if the test went rogue it could acccess a bad gfn and
cause KVM to insert an MMIO SPTE.  Fingers crossed :-)

If it does fix your case, a Reported-by for both you and Syzbot is
definitely in order.

 arch/x86/kvm/mmu.h         | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c     | 10 ++++++++--
 arch/x86/kvm/mmu/spte.h    |  6 ------
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++-------
 arch/x86/kvm/x86.c         |  6 +++++-
 5 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 671cfeccf04e..d291ff3065dc 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,6 +65,27 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
+/*
+ * The number of non-reserved physical address bits irrespective of features
+ * that repurpose legal bits, e.g. MKTME.
+ */
+extern u8 __read_mostly shadow_phys_bits;
+
+static inline gfn_t kvm_mmu_max_gfn_host(void)
+{
+	/*
+	 * Disallow SPTEs (via memslots or cached MMIO) whose gfn would exceed
+	 * host.MAXPHYADDR.  Assuming KVM is running on bare metal, guest
+	 * accesses beyond host.MAXPHYADDR will hit a #PF(RSVD) and never hit
+	 * an EPT Violation/Misconfig / #NPF, and so KVM will never install a
+	 * SPTE for such addresses.  That doesn't hold true if KVM is running
+	 * as a VM itself, e.g. if the MAXPHYADDR KVM sees is less than
+	 * hardware's real MAXPHYADDR, but since KVM can't honor such behavior
+	 * on bare metal, disallow it entirely to simplify e.g. the TDP MMU.
+	 */
+	return (1ULL << (shadow_phys_bits - PAGE_SHIFT)) - 1;
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 904f0faff218..c10ae25135e3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3010,9 +3010,15 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		/*
 		 * If MMIO caching is disabled, emulate immediately without
 		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.
+		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
+		 * whose gfn is greater than host.MAXPHYADDR, any guest that
+		 * generates such gfns is either malicious or in the weeds.
+		 * Note, it's possible to observe a gfn > host.MAXPHYADDR if
+		 * and only if host.MAXPHYADDR is inaccurate with respect to
+		 * hardware behavior, e.g. if KVM itself is running as a VM.
 		 */
-		if (unlikely(!enable_mmio_caching)) {
+		if (unlikely(!enable_mmio_caching) ||
+		    unlikely(fault->gfn > kvm_mmu_max_gfn_host())) {
 			*ret_val = RET_PF_EMULATE;
 			return true;
 		}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ad8ce3c5d083..43eceb821b31 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -203,12 +203,6 @@ static inline bool is_removed_spte(u64 spte)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-/*
- * The number of non-reserved physical address bits irrespective of features
- * that repurpose legal bits, e.g. MKTME.
- */
-extern u8 __read_mostly shadow_phys_bits;
-
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..a81994ad43de 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -815,14 +815,15 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_host(void)
+static inline gfn_t tdp_mmu_max_exclusive_gfn_host(void)
 {
 	/*
-	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
-	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
-	 * and so KVM will never install a SPTE for such addresses.
+	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
+	 * a gpa range that would exceed the max gfn, and KVM does not create
+	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
+	 * the slow emulation path every time.
 	 */
-	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	return kvm_mmu_max_gfn_host() + 1;
 }
 
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -830,7 +831,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_host();
+	gfn_t end = tdp_mmu_max_exclusive_gfn_host();
 	gfn_t start = 0;
 
 	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
@@ -923,7 +924,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	end = min(end, tdp_mmu_max_gfn_host());
+	end = min(end, tdp_mmu_max_exclusive_gfn_host());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccda..26ea5999d72b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12078,8 +12078,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn_host())
+			return -EINVAL;
+
 		return kvm_alloc_memslot_metadata(kvm, new);
+	}
 
 	if (change == KVM_MR_FLAGS_ONLY)
 		memcpy(&new->arch, &old->arch, sizeof(old->arch));

base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3
-- 
2.36.0.464.gb9c8b46e94-goog

