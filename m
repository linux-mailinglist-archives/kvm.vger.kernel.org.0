Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEEB6FC8AC
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbjEIOSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbjEIOSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:18:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E119B0;
        Tue,  9 May 2023 07:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641879; x=1715177879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=hOnmgLSUwhd8cHoAlejpvBtggpnVHk9PPddNjVrC55A=;
  b=HStxl9IWdLudi/PQ1gTaR3DKx2Yv1IvkBL1EoMUuzvUfyu33Q6LSlR5+
   tSwvHlejXseeHNVDi3TdllWvi0UeDjCPt22o2F+KvXfsKXx7vTxwcWwv5
   BV2e1t1tDHZGQtCLUsD1cq6hGKR3j988zi9Zu5gR9h4/FNCLweHjk6GDq
   24r79pvr6ullmElTzlqq70VIfePQfT/EpSCoBaQdo3nbgM7izLkECz6+J
   6MwVYvOUAu9WyLUb5TdXk33RrH0gl5AAh7cThRklNoaS8+C/9NYPZIKIe
   P+TszVlLV2ZX8+9IIUM4A+Im3cPxk9wojCVrzZCAUN89HlyHqwh9iozLf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="330300038"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="330300038"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:17:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788546070"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="788546070"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:17:57 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Date:   Tue,  9 May 2023 21:53:00 +0800
Message-Id: <20230509135300.1855-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509134825.1523-1-yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep a per-VM MTRR state and point it to the MTRR state of vCPU 0.

This is a preparation patch for KVM to reference a per-VM guest MTRR
to decide memory type of EPT leaf entries when noncoherent DMA is present.

Though each vCPU has its own MTRR state, MTRR states should be
consistent across each VM, which is demanded as in Intel's SDM
"In a multiprocessor system using a processor in the P6 family or a more
recent family, each processor MUST use the identical MTRR memory map so
that software will have a consistent view of memory."

Therefore, when memory type of EPT leaf entry needs to honor guest MTRR,
a per-VM version of guest MTRR can be referenced.

Each vCPU still has its own MTRR state field to keep guest rdmsr()
returning the right value when there's lag of MTRR update for each vCPU.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mtrr.c             | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  2 ++
 arch/x86/kvm/x86.h              |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2865c3cb3501..a2b6b1e1548f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,6 +1444,9 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	struct kvm_mtrr *mtrr_state;
+	bool has_mtrr;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 62ebb9978156..1ae80c756797 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -438,6 +438,28 @@ void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&vcpu->arch.mtrr_state.head);
 }
 
+void kvm_mtrr_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (vcpu->vcpu_id)
+		return;
+
+	rcu_assign_pointer(kvm->arch.mtrr_state, &vcpu->arch.mtrr_state);
+	kvm->arch.has_mtrr = guest_cpuid_has(vcpu, X86_FEATURE_MTRR);
+}
+
+void kvm_mtrr_destroy(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (vcpu->vcpu_id)
+		return;
+
+	rcu_assign_pointer(kvm->arch.mtrr_state, NULL);
+	synchronize_srcu_expedited(&kvm->srcu);
+}
+
 struct mtrr_iter {
 	/* input fields. */
 	struct kvm_mtrr *mtrr_state;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48b683a305b3..b8aa18031877 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11879,6 +11879,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
+	kvm_mtrr_init(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
@@ -11948,6 +11949,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvfree(vcpu->arch.cpuid_entries);
 	if (!lapic_in_kernel(vcpu))
 		static_branch_dec(&kvm_has_noapic_vcpu);
+	kvm_mtrr_destroy(vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..d0a7e50de739 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -308,6 +308,8 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 				   struct kvm_queued_exception *ex);
 
 void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu);
+void kvm_mtrr_init(struct kvm_vcpu *vcpu);
+void kvm_mtrr_destroy(struct kvm_vcpu *vcpu);
 u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
-- 
2.17.1

