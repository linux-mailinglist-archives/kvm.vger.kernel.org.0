Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7088A1D610A
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgEPMyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:47574 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgEPMyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:14 -0400
IronPort-SDR: WG8as31hZQJdJO7hr+n0IenH56lOM3wh8WzGUiu4JlYGxbj3XUwCusspMBuIDlcfnkVHAbKTe2
 i7Eftaokk8dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:13 -0700
IronPort-SDR: m6N8sCZVunmN/J7N1+fwKOMZ6H2simaWjAuPPTE4mFKWktGwngoxtfAAe0+S7hVkaAqof0zZ/6
 TB/mGH5p7FTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076622"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:54:10 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 10/11] vmx: spp: Initialize SPP bitmap and SPP protection
Date:   Sat, 16 May 2020 20:55:06 +0800
Message-Id: <20200516125507.5277-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For each memoryslot, there's a SPP bitmap buffer allocated,
every 4Byte corresponds to subpages within a 4KB page. The
original default value for each 4byte is all 1s, meaning
the whole 4KB page is not SPP protected, this eases following
SPP protection check.

To support SPP enablement on-demand, SPP initialization can be
done via KVM_ENABLE_CAP with subcode KVM_CAP_X86_SPP.
KVM_SUBPAGE_MAX_PAGES is set to 512 to reduce the impact to EPT
page_fault() handling because when SPP protection is configured,
mmu-lock is held.

All vcpus share the same SPPT, a KVM_REQ_LOAD_CR3 request is issued
to each vcpu after SPP is initialized, in handling of the request,
SPPTP and VMX SPP execution control bit are configured in VMCS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/kvm/mmu/mmu.c             | 21 +++++++
 arch/x86/kvm/mmu/spp.c             | 99 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h             |  8 ++-
 arch/x86/kvm/vmx/capabilities.h    |  5 ++
 arch/x86/kvm/vmx/vmx.c             | 36 +++++++++++
 arch/x86/kvm/x86.c                 |  7 +++
 include/uapi/linux/kvm.h           |  1 +
 10 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d34c0b91d427..a6730cc409b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1262,6 +1262,7 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	int (*get_insn_len)(struct kvm_vcpu *vcpu);
+	u32 (*get_spp_status)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 93000497ddd9..0eb18750ff6e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -70,6 +70,7 @@
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
 #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
+#define SECONDARY_EXEC_SPP	                VMCS_CONTROL_BIT(SPP)
 #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 9915990fd8cf..8895ddb5766b 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -79,6 +79,7 @@
 #define VMX_FEATURE_PT_CONCEAL_VMX	( 2*32+ 19) /* "" Suppress VMX indicators in Processor Trace */
 #define VMX_FEATURE_XSAVES		( 2*32+ 20) /* "" Enable XSAVES and XRSTORS in guest */
 #define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
+#define VMX_FEATURE_SPP	                ( 2*32+ 23) /* "spp" Enable Sub-page Permission feature */
 #define VMX_FEATURE_PT_USE_GPA		( 2*32+ 24) /* "" Processor Trace logs GPAs */
 #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1cf25752e37c..941c164f8312 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3680,6 +3680,11 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
+				mmu_free_root_page(vcpu->kvm,
+						   &vcpu->kvm->arch.sppt_root,
+						   &invalid_list);
+			}
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -3747,6 +3752,19 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 	/* root_cr3 is ignored for direct MMUs. */
 	vcpu->arch.mmu->root_cr3 = 0;
+	/*
+	 * If spp_init() is called too early, in some cases, e.g., CR0 paging
+	 * bit changes from disable to enable, this causes mmu root page to
+	 * be freed together with sppt root page, then here need to re-allocate
+	 * it.
+	 */
+	if (vcpu->kvm->arch.spp_active &&
+	    !VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
+		sp = kvm_spp_get_page(vcpu, 0,
+				      vcpu->arch.mmu->shadow_root_level);
+		vcpu->kvm->arch.sppt_root = __pa(sp->spt);
+		++sp->root_count;
+	}
 
 	return 0;
 }
@@ -5163,6 +5181,9 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		if (!vcpu->kvm->arch.spp_active)
+			vcpu->kvm->arch.sppt_root = INVALID_PAGE;
+
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 	}
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 8f89df57da7c..5e6e603bc27f 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -266,6 +266,105 @@ int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
 	return 0;
 }
 
+static int kvm_spp_create_bitmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int i, j, ret;
+	u32 *buff;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			buff = kvzalloc(memslot->npages *
+				sizeof(*memslot->arch.subpage_wp_info),
+				GFP_KERNEL);
+
+			if (!buff) {
+				ret = -ENOMEM;
+				goto out_free;
+			}
+			memslot->arch.subpage_wp_info = buff;
+
+			for (j = 0; j < memslot->npages; j++)
+				buff[j] = FULL_SPP_ACCESS;
+		}
+	}
+
+	return 0;
+out_free:
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			if (memslot->arch.subpage_wp_info) {
+				kvfree(memslot->arch.subpage_wp_info);
+				memslot->arch.subpage_wp_info = NULL;
+			}
+		}
+	}
+
+	return ret;
+}
+
+void kvm_spp_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (slot && slot->arch.subpage_wp_info) {
+		kvfree(slot->arch.subpage_wp_info);
+		slot->arch.subpage_wp_info = NULL;
+		vcpu = kvm_get_vcpu(kvm, 0);
+		if (vcpu)
+			vcpu->kvm->arch.spp_active = false;
+	}
+}
+
+int spp_init(struct kvm *kvm)
+{
+	bool first_root = true;
+	int i, ret;
+	int root_level;
+	u32 status;
+	struct kvm_vcpu *vcpu;
+	struct kvm_mmu_page *ssp_sp;
+
+	/* SPP feature is exclusive with nested VM.*/
+	if (kvm_x86_ops.get_nested_state)
+		return -EPERM;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	status = kvm_x86_ops.get_spp_status(vcpu);
+
+	if ((status & (SPP_STATUS_VMX_SUPPORT | SPP_STATUS_EPT_SUPPORT)) !=
+	    (SPP_STATUS_VMX_SUPPORT | SPP_STATUS_EPT_SUPPORT))
+		return -ENODEV;
+
+	if (kvm->arch.spp_active)
+		return 0;
+
+	ret = kvm_spp_create_bitmaps(kvm);
+
+	if (ret)
+		return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (first_root) {
+			/* prepare caches for SPP setup.*/
+			mmu_topup_memory_caches(vcpu);
+			root_level = vcpu->arch.mmu->shadow_root_level;
+			ssp_sp = kvm_spp_get_page(vcpu, 0, root_level);
+			first_root = false;
+			vcpu->kvm->arch.sppt_root = __pa(ssp_sp->spt);
+		}
+		vcpu->arch.spp_pending = true;
+		++ssp_sp->root_count;
+		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+	}
+
+	kvm->arch.spp_active = true;
+	return 0;
+}
+
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map)
 {
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index e0541901ec41..e9b5fd44c215 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -5,7 +5,11 @@
 #define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
 #define KVM_SUBPAGE_MAX_PAGES   512
 #define MAX_ENTRIES_PER_MMUPAGE BIT(9)
+#define SPP_STATUS_VMX_SUPPORT   0x1
+#define SPP_STATUS_EPT_SUPPORT   0x2
 
+int spp_init(struct kvm *kvm);
+void kvm_spp_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
@@ -29,5 +33,7 @@ void save_spp_bit(u64 *spte);
 void restore_spp_bit(u64 *spte);
 bool was_spp_armed(u64 spte);
 u64 construct_spptp(unsigned long root_hpa);
-
+struct kvm_mmu_page *kvm_spp_get_page(struct kvm_vcpu *vcpu,
+				      gfn_t gfn,
+				      unsigned int level);
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..e5ccc1f11d87 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -248,6 +248,11 @@ static inline bool vmx_xsaves_supported(void)
 		SECONDARY_EXEC_XSAVES;
 }
 
+static inline bool cpu_has_vmx_ept_spp(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_SPP;
+}
+
 static inline bool vmx_waitpkg_supported(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 452c93c296a0..89045a7f9d4b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -117,6 +117,9 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
+/* SPP is disabled by default unless it's enabled via KVM_ENABLE_CAP. */
+static bool __read_mostly enable_spp = 0;
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -1408,6 +1411,17 @@ static int vmx_get_insn_len(struct kvm_vcpu *vcpu)
 	return vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 }
 
+static u32 vmx_get_spp_status(struct kvm_vcpu *vcpu)
+{
+	u32 status = 0;
+
+	if (cpu_has_vmx_ept_spp())
+		status |= SPP_STATUS_VMX_SUPPORT;
+	if (enable_ept)
+		status |= SPP_STATUS_EPT_SUPPORT;
+	return status;
+}
+
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -2394,6 +2408,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDSEED_EXITING |
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
+			SECONDARY_EXEC_SPP |
 			SECONDARY_EXEC_TSC_SCALING |
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
@@ -2998,6 +3013,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
+	u64 spptp;
 
 	guest_cr3 = cr3;
 	if (enable_ept) {
@@ -3026,6 +3042,20 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	if (update_guest_cr3)
 		vmcs_writel(GUEST_CR3, guest_cr3);
+
+	if (kvm->arch.spp_active && VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
+		spptp = construct_spptp(vcpu->kvm->arch.sppt_root);
+		vmcs_write64(SPPT_POINTER, spptp);
+
+		if (vcpu->arch.spp_pending && cpu_has_secondary_exec_ctrls()) {
+			struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+			secondary_exec_controls_setbit(vmx,
+						       SECONDARY_EXEC_SPP);
+			enable_spp = 1;
+			vcpu->arch.spp_pending = false;
+		}
+	}
 }
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -4042,6 +4072,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
+	if (!enable_spp)
+		exec_control &= ~SECONDARY_EXEC_SPP;
+
 	if (vmx_xsaves_supported()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
@@ -5900,6 +5933,8 @@ void dump_vmcs(void)
 		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
 		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
+	if ((secondary_exec_control & SECONDARY_EXEC_SPP))
+		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
 	n = vmcs_read32(CR3_TARGET_COUNT);
 	for (i = 0; i + 1 < n; i += 4)
 		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
@@ -7912,6 +7947,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 
 	.get_insn_len = vmx_get_insn_len,
+	.get_spp_status = vmx_get_spp_status,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3999a3ab911..a96463f9f33b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3436,6 +3436,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_enable_evmcs != NULL;
 		break;
+	case KVM_CAP_X86_SPP:
+		r = KVM_SUBPAGE_MAX_PAGES;
+		break;
 	default:
 		break;
 	}
@@ -4884,6 +4887,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_SPP:
+		r =  spp_init(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -10047,6 +10053,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	}
 
 	kvm_page_track_free_memslot(slot);
+	kvm_spp_free_memslot(kvm, slot);
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b81094e1e1c7..7a2a2eaa5704 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_X86_SPP 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.2

