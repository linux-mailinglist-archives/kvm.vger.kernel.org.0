Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267E7141BD8
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgASEAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:62807 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgASEAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910523"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:39 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 09/10] vmx: spp: Initialize SPP bitmap and SPP protection
Date:   Sun, 19 Jan 2020 12:05:06 +0800
Message-Id: <20200119040507.23113-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200119040507.23113-1-weijiang.yang@intel.com>
References: <20200119040507.23113-1-weijiang.yang@intel.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/mmu/mmu.c          |  9 ++++
 arch/x86/kvm/mmu/spp.c          | 96 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h          |  5 ++
 arch/x86/kvm/vmx/capabilities.h |  5 ++
 arch/x86/kvm/vmx/vmx.c          | 36 +++++++++++++
 arch/x86/kvm/x86.c              |  7 +++
 include/uapi/linux/kvm.h        |  1 +
 9 files changed, 161 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0cf886e58004..977bfedf3a1a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1241,6 +1241,7 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	int (*get_insn_len)(struct kvm_vcpu *vcpu);
+	u32 (*get_spp_status)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index fc69ea8035fb..51eef174b8c1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -68,6 +68,7 @@
 #define SECONDARY_EXEC_XSAVES			0x00100000
 #define SECONDARY_EXEC_PT_USE_GPA		0x01000000
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	0x00400000
+#define SECONDARY_EXEC_SPP		        0x00800000
 #define SECONDARY_EXEC_TSC_SCALING              0x02000000
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	0x04000000
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 099f92f0c42a..a8b0c3849c4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3821,6 +3821,12 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (vcpu->kvm->arch.spp_active) {
+				vcpu->kvm->arch.spp_active = false;
+				mmu_free_root_page(vcpu->kvm,
+						   &vcpu->kvm->arch.sppt_root,
+						   &invalid_list);
+			}
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -5307,6 +5313,9 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		if (!vcpu->kvm->arch.spp_active)
+			vcpu->kvm->arch.sppt_root = INVALID_PAGE;
+
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 	}
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index eb540e1b5133..55a39c787827 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -262,6 +262,102 @@ int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
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
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont)
+{
+	if (!dont || free->arch.subpage_wp_info !=
+	    dont->arch.subpage_wp_info) {
+		kvfree(free->arch.subpage_wp_info);
+		free->arch.subpage_wp_info = NULL;
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
+	if (kvm_x86_ops->get_nested_state)
+		return -EPERM;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	status = kvm_x86_ops->get_spp_status(vcpu);
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
+		kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
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
index 51a209a04863..ad37221bb306 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -5,7 +5,12 @@
 #define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
 #define KVM_SUBPAGE_MAX_PAGES   512
 #define MAX_ENTRIES_PER_MMUPAGE BIT(9)
+#define SPP_STATUS_VMX_SUPPORT   0x1
+#define SPP_STATUS_EPT_SUPPORT   0x2
 
+int spp_init(struct kvm *kvm);
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont);
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7aa69716d516..78be4390180a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -247,6 +247,11 @@ static inline bool vmx_xsaves_supported(void)
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
index 4032e615ca85..e54bafa8b887 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -113,6 +113,9 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
+/* SPP is disabled by default unless it's enabled via KVM_ENABLE_CAP. */
+static bool __read_mostly enable_spp = 0;
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -1428,6 +1431,17 @@ static int vmx_get_insn_len(struct kvm_vcpu *vcpu)
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
@@ -2397,6 +2411,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDSEED_EXITING |
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
+			SECONDARY_EXEC_SPP |
 			SECONDARY_EXEC_TSC_SCALING |
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
@@ -2997,6 +3012,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
+	u64 spptp;
 
 	guest_cr3 = cr3;
 	if (enable_ept) {
@@ -3025,6 +3041,20 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
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
@@ -4045,6 +4075,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
+	if (!enable_spp)
+		exec_control &= ~SECONDARY_EXEC_SPP;
+
 	if (vmx_xsaves_supported()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
@@ -5866,6 +5899,8 @@ void dump_vmcs(void)
 		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
 		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
+	if ((secondary_exec_control & SECONDARY_EXEC_SPP))
+		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
 	n = vmcs_read32(CR3_TARGET_COUNT);
 	for (i = 0; i + 1 < n; i += 4)
 		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
@@ -7980,6 +8015,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 
 	.get_insn_len = vmx_get_insn_len,
+	.get_spp_status = vmx_get_spp_status,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 102a3ff8f690..8ed67f91947b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3336,6 +3336,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops->nested_enable_evmcs != NULL;
 		break;
+	case KVM_CAP_X86_SPP:
+		r = KVM_SUBPAGE_MAX_PAGES;
+		break;
 	default:
 		break;
 	}
@@ -4831,6 +4834,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_SPP:
+		r =  spp_init(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -9814,6 +9820,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	}
 
 	kvm_page_track_free_memslot(free, dont);
+	kvm_spp_free_memslot(free, dont);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 280a6d52e5ff..e595a233a9fa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1023,6 +1023,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_X86_SPP 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.2

