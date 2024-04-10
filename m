Return-Path: <kvm+bounces-14166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD73C8A02EA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D10A61C22485
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5AC1A38E0;
	Wed, 10 Apr 2024 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpQq5G6D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6E9199EB5;
	Wed, 10 Apr 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786883; cv=none; b=UTo9okvtAprV0UHf8QZDM7oU1QUUbAbDgX2zR/zmX3zQpYKWG6HZjSw1BJblgrBcaleqTH93gywqDf++aZqKYOQ6ReAfVksVWXRsg75dvH0d9DLHVOUknjqF0hItSH3et7NqDSw3+cEKCfCnpCgnS3ZEtKXQor394adP9fz7tzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786883; c=relaxed/simple;
	bh=xiqSchLKUGvT4Pg7trp63x+D9biwzzQVpK0rEXgPkZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIIEH6Om8cwsNqCR0gnsPqeFqLUagnrxUKGXnZjcSVJzC1HQvOQ7YDaf/nma8nJPWDPpQq02LIQNuJQb9zLuEZZ6gcbKA6Zt5MWPlDTMj+lGc9QR8dLB6UaDjB5crkPtH1Ia9Qg20gqSY6aGXp1+Zy5cUPS3ItB3BIBVKFU85DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpQq5G6D; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786881; x=1744322881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xiqSchLKUGvT4Pg7trp63x+D9biwzzQVpK0rEXgPkZE=;
  b=BpQq5G6DC7EPKxEFHkTmEXit5uuudvg3+MmLrBVDDzTOM75NATj+UBxK
   hWKcgpHAART9U4QjYu5MY+g1iZULsLXhPFT6OTKJ3HOHRBtlzTdyX6HyA
   9Gd20mjEpyHd4TImAtpdRvq2qQSYIfK26+FHusQ3n4swmoMAwZtZ3VvEm
   IcAkZ52wOlg2DijhTvInV+6OAgAG1A37hGw3NxCwJtXB4T5bsz9gQSR36
   JkSVwtDKLtA/zxYAe2rDjlF4ecKSAteD/amXUAgPNivERMkG2jc3V0389
   GqYleeSaTXjVs4l4Gvn9RY/MhH3e//5zwtlsltuckjN1sZn1sUfb7hag9
   A==;
X-CSE-ConnectionGUID: uTgpQImxSvyzO0DlXWoL+A==
X-CSE-MsgGUID: qWiimKMySqqqiDzMtbmH/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041160"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041160"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:59 -0700
X-CSE-ConnectionGUID: MKlNuO+tR+S5qiNhUcI9VQ==
X-CSE-MsgGUID: qr8pHCQgRICCdo9EoSj7xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476330"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:59 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 10/10] KVM: selftests: x86: Add test for KVM_MAP_MEMORY
Date: Wed, 10 Apr 2024 15:07:36 -0700
Message-ID: <32427791ef42e5efaafb05d2ac37fa4372715f47.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to exercise KVM_MAP_MEMORY and run the guest to access the
pre-populated area.  It tests KVM_MAP_MEMORY ioctl for KVM_X86_DEFAULT_VM
and KVM_X86_SW_PROTECTED_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Catch up for uAPI change.
- Added smm mode test case.
- Added guest mode test case.
---
 tools/include/uapi/linux/kvm.h                |   8 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/map_memory_test.c    | 479 ++++++++++++++++++
 3 files changed, 488 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/map_memory_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..c742c403256a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -2227,4 +2227,12 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
+
+struct kvm_memory_mapping {
+	__u64 base_address;
+	__u64 size;
+	__u64 flags;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 871e2de3eb05..2b097b6ec267 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += x86_64/map_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/x86_64/map_memory_test.c b/tools/testing/selftests/kvm/x86_64/map_memory_test.c
new file mode 100644
index 000000000000..d5728439542e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/map_memory_test.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024, Intel, Inc
+ *
+ * Author:
+ * Isaku Yamahata <isaku.yamahata at gmail.com>
+ */
+#include <linux/sizes.h>
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+/* Arbitrarily chosen value. Pick 3G */
+#define TEST_GVA		0xc0000000
+#define TEST_GPA		TEST_GVA
+#define TEST_SIZE		(SZ_2M + PAGE_SIZE)
+#define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
+#define TEST_SLOT		10
+
+/* Nested: VMXON and VMCS12 for VMX or VMCB for XVM */
+/* Arbitrarily chosen value. Pick 128MB after TEST_GVA. */
+#define NESTED_GVA		(TEST_GVA + 128 * 1024 * 1024)
+#define NESTED_GPA		(TEST_GPA + 128 * 1024 * 1024)
+#define NESTED_NPAGES		2
+#define NESTED_SIZE		(NESTED_NPAGES * PAGE_SIZE)
+#define NESTED_SLOT		11
+
+static void guest_code(uint64_t base_gpa)
+{
+	volatile uint64_t val __used;
+	int i;
+
+	for (i = 0; i < TEST_NPAGES; i++) {
+		uint64_t *src = (uint64_t *)(base_gpa + i * PAGE_SIZE);
+
+		val = *src;
+	}
+
+	GUEST_DONE();
+}
+
+static void map_memory(struct kvm_vcpu *vcpu, u64 base_address, u64 size,
+		       bool should_success)
+{
+	struct kvm_memory_mapping mapping = {
+		.base_address = base_address,
+		.size = size,
+		.flags = 0,
+	};
+	int ret;
+
+	do {
+		ret = __vcpu_ioctl(vcpu, KVM_MAP_MEMORY, &mapping);
+	} while (ret && (errno == EAGAIN || errno == EINTR));
+
+	if (should_success)
+		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_MAP_MEMORY", ret, vcpu->vm);
+	else
+		/* No memory slot causes RET_PF_EMULATE. it results in -EINVAL. */
+		__TEST_ASSERT_VM_VCPU_IOCTL(ret && errno == EINVAL,
+					    "KVM_MAP_MEMORY", ret, vcpu->vm);
+}
+
+static void set_smm(struct kvm_vcpu *vcpu, bool enter_or_leave)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vcpu, &events);
+
+	events.smi.smm = !!enter_or_leave;
+	events.smi.pending = 0;
+	events.flags |= KVM_VCPUEVENT_VALID_SMM;
+
+	vcpu_events_set(vcpu, &events);
+}
+
+/* Copied from arch/x86/kvm/vmx/vmcs12.h */
+#define VMCS12_REVISION	0x11e57ed0
+
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
+typedef u64 natural_width;
+
+struct __packed vmcs12 {
+	struct vmcs_hdr hdr;
+	u32 abort;
+
+	u32 launch_state;
+	u32 padding[7];
+
+	u64 io_bitmap_a;
+	u64 io_bitmap_b;
+	u64 msr_bitmap;
+	u64 vm_exit_msr_store_addr;
+	u64 vm_exit_msr_load_addr;
+	u64 vm_entry_msr_load_addr;
+	u64 tsc_offset;
+	u64 virtual_apic_page_addr;
+	u64 apic_access_addr;
+	u64 posted_intr_desc_addr;
+	u64 ept_pointer;
+	u64 eoi_exit_bitmap0;
+	u64 eoi_exit_bitmap1;
+	u64 eoi_exit_bitmap2;
+	u64 eoi_exit_bitmap3;
+	u64 xss_exit_bitmap;
+	u64 guest_physical_address;
+	u64 vmcs_link_pointer;
+	u64 guest_ia32_debugctl;
+	u64 guest_ia32_pat;
+	u64 guest_ia32_efer;
+	u64 guest_ia32_perf_global_ctrl;
+	u64 guest_pdptr0;
+	u64 guest_pdptr1;
+	u64 guest_pdptr2;
+	u64 guest_pdptr3;
+	u64 guest_bndcfgs;
+	u64 host_ia32_pat;
+	u64 host_ia32_efer;
+	u64 host_ia32_perf_global_ctrl;
+	u64 vmread_bitmap;
+	u64 vmwrite_bitmap;
+	u64 vm_function_control;
+	u64 eptp_list_address;
+	u64 pml_address;
+	u64 encls_exiting_bitmap;
+	u64 tsc_multiplier;
+	u64 padding64[1];
+
+	natural_width cr0_guest_host_mask;
+	natural_width cr4_guest_host_mask;
+	natural_width cr0_read_shadow;
+	natural_width cr4_read_shadow;
+	natural_width dead_space[4];
+	natural_width exit_qualification;
+	natural_width guest_linear_address;
+	natural_width guest_cr0;
+	natural_width guest_cr3;
+	natural_width guest_cr4;
+	natural_width guest_es_base;
+	natural_width guest_cs_base;
+	natural_width guest_ss_base;
+	natural_width guest_ds_base;
+	natural_width guest_fs_base;
+	natural_width guest_gs_base;
+	natural_width guest_ldtr_base;
+	natural_width guest_tr_base;
+	natural_width guest_gdtr_base;
+	natural_width guest_idtr_base;
+	natural_width guest_dr7;
+	natural_width guest_rsp;
+	natural_width guest_rip;
+	natural_width guest_rflags;
+	natural_width guest_pending_dbg_exceptions;
+	natural_width guest_sysenter_esp;
+	natural_width guest_sysenter_eip;
+	natural_width host_cr0;
+	natural_width host_cr3;
+	natural_width host_cr4;
+	natural_width host_fs_base;
+	natural_width host_gs_base;
+	natural_width host_tr_base;
+	natural_width host_gdtr_base;
+	natural_width host_idtr_base;
+	natural_width host_ia32_sysenter_esp;
+	natural_width host_ia32_sysenter_eip;
+	natural_width host_rsp;
+	natural_width host_rip;
+	natural_width paddingl[8];
+
+	u32 pin_based_vm_exec_control;
+	u32 cpu_based_vm_exec_control;
+	u32 exception_bitmap;
+	u32 page_fault_error_code_mask;
+	u32 page_fault_error_code_match;
+	u32 cr3_target_count;
+	u32 vm_exit_controls;
+	u32 vm_exit_msr_store_count;
+	u32 vm_exit_msr_load_count;
+	u32 vm_entry_controls;
+	u32 vm_entry_msr_load_count;
+	u32 vm_entry_intr_info_field;
+	u32 vm_entry_exception_error_code;
+	u32 vm_entry_instruction_len;
+	u32 tpr_threshold;
+	u32 secondary_vm_exec_control;
+	u32 vm_instruction_error;
+	u32 vm_exit_reason;
+	u32 vm_exit_intr_info;
+	u32 vm_exit_intr_error_code;
+	u32 idt_vectoring_info_field;
+	u32 idt_vectoring_error_code;
+	u32 vm_exit_instruction_len;
+	u32 vmx_instruction_info;
+	u32 guest_es_limit;
+	u32 guest_cs_limit;
+	u32 guest_ss_limit;
+	u32 guest_ds_limit;
+	u32 guest_fs_limit;
+	u32 guest_gs_limit;
+	u32 guest_ldtr_limit;
+	u32 guest_tr_limit;
+	u32 guest_gdtr_limit;
+	u32 guest_idtr_limit;
+	u32 guest_es_ar_bytes;
+	u32 guest_cs_ar_bytes;
+	u32 guest_ss_ar_bytes;
+	u32 guest_ds_ar_bytes;
+	u32 guest_fs_ar_bytes;
+	u32 guest_gs_ar_bytes;
+	u32 guest_ldtr_ar_bytes;
+	u32 guest_tr_ar_bytes;
+	u32 guest_interruptibility_info;
+	u32 guest_activity_state;
+	u32 guest_sysenter_cs;
+	u32 host_ia32_sysenter_cs;
+	u32 vmx_preemption_timer_value;
+	u32 padding32[7];
+
+	u16 virtual_processor_id;
+	u16 posted_intr_nv;
+	u16 guest_es_selector;
+	u16 guest_cs_selector;
+	u16 guest_ss_selector;
+	u16 guest_ds_selector;
+	u16 guest_fs_selector;
+	u16 guest_gs_selector;
+	u16 guest_ldtr_selector;
+	u16 guest_tr_selector;
+	u16 guest_intr_status;
+	u16 host_es_selector;
+	u16 host_cs_selector;
+	u16 host_ss_selector;
+	u16 host_ds_selector;
+	u16 host_fs_selector;
+	u16 host_gs_selector;
+	u16 host_tr_selector;
+	u16 guest_pml_index;
+};
+
+/* Fill values to make KVM vmx_set_nested_state() pass. */
+void vmx_vmcs12_init(struct vmcs12 *vmcs12)
+{
+	*(__u32*)(vmcs12) = VMCS12_REVISION;
+
+	vmcs12->vmcs_link_pointer = -1;
+
+#define PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x00000016
+	vmcs12->pin_based_vm_exec_control = PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+#define CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x0401e172
+	vmcs12->cpu_based_vm_exec_control = CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	vmcs12->secondary_vm_exec_control = 0;
+
+#define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
+	vmcs12->vm_exit_controls = VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
+
+#define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
+	vmcs12->vm_entry_controls = VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+
+#define VMXON_CR0_ALWAYSON     (X86_CR0_PE | X86_CR0_PG | X86_CR0_NE)
+#define VMXON_CR4_ALWAYSON     X86_CR4_VMXE
+
+	/* host */
+	vmcs12->host_cr0 = VMXON_CR0_ALWAYSON;
+	vmcs12->host_cr3 = TEST_GPA;
+	vmcs12->host_cr4 = VMXON_CR4_ALWAYSON;;
+
+	/* Non-zero to make KVM vmx check pass */
+	vmcs12->host_cs_selector = 8;
+	vmcs12->host_ss_selector = 8;
+	vmcs12->host_ds_selector = 8;
+	vmcs12->host_es_selector = 8;
+	vmcs12->host_fs_selector = 8;
+	vmcs12->host_gs_selector = 8;
+	vmcs12->host_tr_selector = 8;
+
+	/* guest */
+	vmcs12->guest_cr0 = VMXON_CR0_ALWAYSON;
+	vmcs12->guest_cr4 = VMXON_CR4_ALWAYSON;
+
+	vmcs12->guest_cs_selector = 0xf000;
+	vmcs12->guest_cs_base = 0xffff0000UL;
+	vmcs12->guest_cs_limit = 0xffff;
+	vmcs12->guest_cs_ar_bytes = 0x93 | 0x08;
+
+	vmcs12->guest_ds_selector = 0;
+	vmcs12->guest_ds_base = 0;
+	vmcs12->guest_ds_limit = 0xffff;
+	vmcs12->guest_ds_ar_bytes = 0x93;
+
+	vmcs12->guest_es_selector = 0;
+	vmcs12->guest_es_base = 0;
+	vmcs12->guest_es_limit = 0xffff;
+	vmcs12->guest_es_ar_bytes = 0x93;
+
+	vmcs12->guest_fs_selector = 0;
+	vmcs12->guest_fs_base = 0;
+	vmcs12->guest_fs_limit = 0xffff;
+	vmcs12->guest_fs_ar_bytes = 0x93;
+
+	vmcs12->guest_gs_selector = 0;
+	vmcs12->guest_gs_base = 0;
+	vmcs12->guest_gs_limit = 0xffff;
+	vmcs12->guest_gs_ar_bytes = 0x93;
+
+	vmcs12->guest_ss_selector = 0;
+	vmcs12->guest_ss_base = 0;
+	vmcs12->guest_ss_limit = 0xffff;
+	vmcs12->guest_ss_ar_bytes = 0x93;
+
+	vmcs12->guest_ldtr_selector = 0;
+	vmcs12->guest_ldtr_base = 0;
+	vmcs12->guest_ldtr_limit = 0xfff;
+	vmcs12->guest_ldtr_ar_bytes = 0x008b;
+
+	vmcs12->guest_gdtr_base = 0;
+	vmcs12->guest_gdtr_limit = 0xffff;
+
+	vmcs12->guest_idtr_base = 0;
+	vmcs12->guest_idtr_limit = 0xffff;
+
+	/* ACTIVE = 0 */
+	vmcs12->guest_activity_state = 0;
+
+	vmcs12->guest_interruptibility_info = 0;
+	vmcs12->guest_pending_dbg_exceptions = 0;
+
+	vmcs12->vm_entry_intr_info_field = 0;
+}
+
+void vmx_state_set(struct kvm_vcpu *vcpu, struct kvm_nested_state *state,
+		   __u16 flags, __u64 vmxon_pa, __u64 vmcs12_pa)
+{
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)state->data.vmx->vmcs12;
+
+	memset(state, 0, sizeof(*state) + KVM_STATE_NESTED_VMX_VMCS_SIZE);
+
+	state->flags = flags;
+	state->format = KVM_STATE_NESTED_FORMAT_VMX;
+	state->size = KVM_STATE_NESTED_VMX_VMCS_SIZE;
+
+	state->hdr.vmx.vmxon_pa = vmxon_pa;
+	state->hdr.vmx.vmcs12_pa = vmcs12_pa;
+	state->hdr.vmx.smm.flags = 0;
+	state->hdr.vmx.pad = 0;
+	state->hdr.vmx.flags = 0;
+	state->hdr.vmx.preemption_timer_deadline = 0;
+
+	vmx_vmcs12_init(vmcs12);
+
+	vcpu_nested_state_set(vcpu, state);
+}
+
+static void __test_map_memory(unsigned long vm_type, bool private,
+			      bool smm, bool nested)
+{
+	struct kvm_nested_state *state = NULL;
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = vm_type,
+	};
+	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
+	struct kvm_regs regs;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TEST_GPA, TEST_SLOT, TEST_NPAGES,
+				    private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, TEST_GVA, TEST_GPA, TEST_NPAGES);
+
+	if (private)
+		vm_mem_set_private(vm, TEST_GPA, TEST_SIZE);
+	if (nested) {
+		size_t size = sizeof(*state);
+
+		if (kvm_cpu_has(X86_FEATURE_VMX)) {
+			size += KVM_STATE_NESTED_VMX_VMCS_SIZE;
+			vcpu_set_cpuid_feature(vcpu, X86_FEATURE_VMX);
+		}
+
+		state = malloc(size);
+		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, NESTED_GPA,
+					    NESTED_SLOT, NESTED_NPAGES, 0);
+		virt_map(vm, NESTED_GVA, NESTED_GPA, NESTED_NPAGES);
+	}
+
+	if (smm)
+		set_smm(vcpu, true);
+	if (nested) {
+		vcpu_regs_get(vcpu, &regs);
+		vcpu_sregs_get(vcpu, &sregs);
+		vmx_state_set(vcpu, state, KVM_STATE_NESTED_RUN_PENDING |
+			      KVM_STATE_NESTED_GUEST_MODE,
+			      NESTED_GPA, NESTED_GPA + PAGE_SIZE);
+	}
+	map_memory(vcpu, TEST_GPA, SZ_2M, true);
+	map_memory(vcpu, TEST_GPA + SZ_2M, PAGE_SIZE, true);
+	map_memory(vcpu, TEST_GPA + TEST_SIZE, PAGE_SIZE, false);
+	if (nested) {
+		vmx_state_set(vcpu, state, 0, -1, -1);
+		free(state);
+		vcpu_sregs_set(vcpu, &sregs);
+		vcpu_regs_set(vcpu, &regs);
+	}
+	if (smm)
+		set_smm(vcpu, false);
+
+	vcpu_args_set(vcpu, 1, TEST_GVA);
+	vcpu_run(vcpu);
+
+	run = vcpu->run;
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Wanted KVM_EXIT_IO, got exit reason: %u (%s)",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		break;
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_map_memory(unsigned long vm_type, bool private)
+{
+	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
+		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
+		return;
+	}
+
+	__test_map_memory(vm_type, private, false, false);
+
+	if (kvm_has_cap(KVM_CAP_VCPU_EVENTS) && kvm_has_cap(KVM_CAP_X86_SMM))
+		__test_map_memory(vm_type, private, true, false);
+	else
+		pr_info("skipping test for vm_type 0x%lx with smm\n", vm_type);
+
+	if (!kvm_has_cap(KVM_CAP_NESTED_STATE)) {
+		pr_info("Skipping test for vm_type 0x%lx with nesting\n", vm_type);
+		return;
+	}
+
+	if (kvm_cpu_has(X86_FEATURE_SVM)) {
+		pr_info("Implement nested SVM case\n");
+		return;
+	}
+	if (!kvm_cpu_has(X86_FEATURE_VMX)) {
+		pr_info("Skipping test for vm_type 0x%lx with nested VMX\n",
+			vm_type);
+		return;
+	}
+	__test_map_memory(vm_type, private, false, true);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_MAP_MEMORY));
+
+	test_map_memory(KVM_X86_DEFAULT_VM, false);
+	test_map_memory(KVM_X86_SW_PROTECTED_VM, false);
+	test_map_memory(KVM_X86_SW_PROTECTED_VM, true);
+	return 0;
+}
-- 
2.43.2


