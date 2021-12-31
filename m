Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9648247F
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhLaO7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:8181 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhLaO7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962777; x=1672498777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=T9lZstSgT64E1WfAYsIVUx9bWf4gyoY3EbMk1/GBfFk=;
  b=ekAgyMjXzX7Rxk6PX9awTN12In19UTTDLMTPaCFG/pI45wgKX7wURFuh
   Qneafsgs+yknYT9fJinGg8WxIK0YPAIZRZHLthivOERkaohkZbhwtxl1n
   UJ4TnmNy2+7hJqKakWRiSTm3H5zVm+5vu/YYvREHGXbYtX8a0iaSgHjJ+
   Ok/AFvpINIas8cGLnXLBk8TKUCvaVRD9VltE+i+LApo7UbZK97mUUpT2x
   UOSL+VZKa2qokkg7fJxs7JCy5XVLo6VfA9uvTpICwaJzXLuizGr+0Hxkr
   5hCbbdyaQ+sMeNAFB2DZM7Bl6MN3RJ11rNQpeq/YZMg35V4vgCrXlO3sg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="241618910"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="241618910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758501"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:31 -0800
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v5 8/8] KVM: VMX: Resize PID-ponter table on demand for IPI virtualization
Date:   Fri, 31 Dec 2021 22:28:49 +0800
Message-Id: <20211231142849.611-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current kvm allocates 8 pages in advance for Posted Interrupt
Descriptor pointer (PID-pointer) table to accommodate vCPUs
with APIC ID up to KVM_MAX_VCPU_IDS - 1. This policy wastes
some memory because most of VMs have less than 512 vCPUs and
then just need one page.

To reduce the memory consumption of most of VMs, KVM initially
allocates one page for PID-pointer table for each VM and bumps
up the table on demand according to the maximum APIC ID of all
vCPUs of a VM. Bumping up PID-pointer table involves allocating
a new table, requesting all vCPUs to update related VMCS fields
and freeing the old table.

In worst case that new memory allocation fails, KVM keep using
the present PID-pointer table. Thus IPI virtualization won't
take effect to those vCPUs not set in the table without impact
on others.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 ++
 arch/x86/kvm/vmx/vmx.c             | 77 +++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h             |  6 +++
 arch/x86/kvm/x86.c                 |  2 +
 5 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..847246f2537d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -121,6 +121,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(update_ipiv_pid_table)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 753bf2a7cebc..24990d4e94c4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -102,6 +102,8 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_PID_TABLE_UPDATE \
+	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1494,6 +1496,7 @@ struct kvm_x86_ops {
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void (*update_ipiv_pid_entry)(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id);
+	void (*update_ipiv_pid_table)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f21ce15c5eb8..fb8e2b52b5f7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -228,8 +228,9 @@ static const struct {
 
 #define L1D_CACHE_ORDER 4
 
-/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
-#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
+/* Each entry in PID(Posted-Interrupt Descriptor)-pointer table is 8 bytes */
+#define table_index_to_size(index) ((index) << 3)
+#define table_size_to_index(size) ((size) >> 3)
 #define PID_TABLE_ENTRY_VALID 1
 
 static void *vmx_l1d_flush_pages;
@@ -4332,6 +4333,42 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+static int vmx_alloc_pid_table(struct kvm_vmx *kvm_vmx, int order)
+{
+	u64 *pid_table;
+
+	pid_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!pid_table)
+		return -ENOMEM;
+
+	kvm_vmx->pid_table = pid_table;
+	kvm_vmx->pid_last_index = table_size_to_index(PAGE_SIZE << order) - 1;
+	return 0;
+}
+
+static int vmx_expand_pid_table(struct kvm_vmx *kvm_vmx, int entry_idx)
+{
+	u64 *last_pid_table;
+	int last_table_size, new_order;
+
+	if (entry_idx <= kvm_vmx->pid_last_index)
+		return 0;
+
+	last_pid_table = kvm_vmx->pid_table;
+	last_table_size = table_index_to_size(kvm_vmx->pid_last_index + 1);
+	new_order = get_order(table_index_to_size(entry_idx + 1));
+
+	if (vmx_alloc_pid_table(kvm_vmx, new_order))
+		return -ENOMEM;
+
+	memcpy(kvm_vmx->pid_table, last_pid_table, last_table_size);
+	kvm_make_all_cpus_request(&kvm_vmx->kvm, KVM_REQ_PID_TABLE_UPDATE);
+
+	/* Now old PID table can be freed safely as no vCPU is using it. */
+	free_pages((unsigned long)last_pid_table, get_order(last_table_size));
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 static void init_vmcs(struct vcpu_vmx *vmx)
@@ -4370,10 +4407,19 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 
 		if (enable_ipiv) {
-			WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
-				__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
+			down_write(&kvm_vmx->pid_table_lock);
+
+			/*
+			 * In case new memory allocation for PID table fails,
+			 * skip setting Posted-Interrupt descriptor of current
+			 * vCPU which index is beyond present table limit.
+			 */
+			if (!vmx_expand_pid_table(kvm_vmx, vcpu->vcpu_id))
+				WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
+					__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
 			vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
 			vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
+			up_write(&kvm_vmx->pid_table_lock);
 		}
 	}
 
@@ -7001,14 +7047,11 @@ static int vmx_vm_init(struct kvm *kvm)
 	}
 
 	if (enable_ipiv) {
-		struct page *pages;
+		struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
-		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, MAX_PID_TABLE_ORDER);
-		if (!pages)
+		if (vmx_alloc_pid_table(kvm_vmx, 0))
 			return -ENOMEM;
-
-		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
-		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_IDS - 1;
+		init_rwsem(&kvm_vmx->pid_table_lock);
 	}
 
 	return 0;
@@ -7630,7 +7673,18 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
 	if (kvm_vmx->pid_table)
-		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
+		free_pages((unsigned long)kvm_vmx->pid_table,
+			get_order(table_index_to_size(kvm_vmx->pid_last_index)));
+}
+
+static void vmx_update_ipiv_pid_table(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
+	down_read(&kvm_vmx->pid_table_lock);
+	vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
+	vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
+	up_read(&kvm_vmx->pid_table_lock);
 }
 
 static void vmx_update_ipiv_pid_entry(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id)
@@ -7782,6 +7836,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 	.update_ipiv_pid_entry = vmx_update_ipiv_pid_entry,
+	.update_ipiv_pid_table = vmx_update_ipiv_pid_table,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c8ae1458eb9e..8c437a7be08a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,6 +356,12 @@ struct kvm_vmx {
 	/* PID table for IPI virtualization */
 	u64 *pid_table;
 	u16 pid_last_index;
+	/*
+	 * Protects accesses to pid_table and pid_last_index.
+	 * Request to reallocate and update PID table could
+	 * happen on multiple vCPUs simultaneously.
+	 */
+	struct rw_semaphore pid_table_lock;
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a2972fdae82..97ec2adb76bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9783,6 +9783,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+		if (kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu))
+			static_call(kvm_x86_update_ipiv_pid_table)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
-- 
2.27.0

