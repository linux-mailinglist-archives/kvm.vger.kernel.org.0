Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A25C1909C0
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCXJmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:42:13 -0400
Received: from 8bytes.org ([81.169.241.247]:55386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgCXJmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 05:42:01 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 90A3A477; Tue, 24 Mar 2020 10:41:59 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/4] KVM: SVM: Move AVIC code to separate file
Date:   Tue, 24 Mar 2020 10:41:53 +0100
Message-Id: <20200324094154.32352-4-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324094154.32352-1-joro@8bytes.org>
References: <20200324094154.32352-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Move the AVIC related functions from svm.c to the new avic.c file.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/Makefile   |    2 +-
 arch/x86/kvm/svm/avic.c | 1025 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c  | 1049 +--------------------------------------
 arch/x86/kvm/svm/svm.h  |   62 +++
 4 files changed, 1089 insertions(+), 1049 deletions(-)
 create mode 100644 arch/x86/kvm/svm/avic.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 63ae654f7f97..9d7f9ba10f51 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
-kvm-amd-y		+= svm/svm.o svm/pmu.o svm/nested.o
+kvm-amd-y		+= svm/svm.o svm/pmu.o svm/nested.o svm/avic.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
new file mode 100644
index 000000000000..8bd32c74128c
--- /dev/null
+++ b/arch/x86/kvm/svm/avic.c
@@ -0,0 +1,1025 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * AMD SVM support
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
+ *
+ * Authors:
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Avi Kivity   <avi@qumranet.com>
+ */
+
+#define pr_fmt(fmt) "SVM: " fmt
+
+#include <linux/kvm_types.h>
+#include <linux/hashtable.h>
+#include <linux/amd-iommu.h>
+#include <linux/kvm_host.h>
+
+#include <asm/irq_remapping.h>
+
+#include "trace.h"
+#include "lapic.h"
+#include "x86.h"
+#include "svm.h"
+
+/* enable / disable AVIC */
+int avic;
+#ifdef CONFIG_X86_LOCAL_APIC
+module_param(avic, int, S_IRUGO);
+#endif
+
+#define SVM_AVIC_DOORBELL	0xc001011b
+
+#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
+
+/*
+ * 0xff is broadcast, so the max index allowed for physical APIC ID
+ * table is 0xfe.  APIC IDs above 0xff are reserved.
+ */
+#define AVIC_MAX_PHYSICAL_ID_COUNT	255
+
+#define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
+#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
+#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
+
+/* AVIC GATAG is encoded using VM and VCPU IDs */
+#define AVIC_VCPU_ID_BITS		8
+#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
+
+#define AVIC_VM_ID_BITS			24
+#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
+#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
+
+#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+						(y & AVIC_VCPU_ID_MASK))
+#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
+
+/* Note:
+ * This hash table is used to map VM_ID to a struct kvm_svm,
+ * when handling AMD IOMMU GALOG notification to schedule in
+ * a particular vCPU.
+ */
+#define SVM_VM_DATA_HASH_BITS	8
+static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
+static u32 next_vm_id = 0;
+static bool next_vm_id_wrapped = 0;
+static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+
+/*
+ * This is a wrapper of struct amd_iommu_ir_data.
+ */
+struct amd_svm_iommu_ir {
+	struct list_head node;	/* Used by SVM for per-vcpu ir_list */
+	void *data;		/* Storing pointer to struct amd_ir_data */
+};
+
+enum avic_ipi_failure_cause {
+	AVIC_IPI_FAILURE_INVALID_INT_TYPE,
+	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
+	AVIC_IPI_FAILURE_INVALID_TARGET,
+	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
+};
+
+/* Note:
+ * This function is called from IOMMU driver to notify
+ * SVM to schedule in a particular vCPU of a particular VM.
+ */
+int avic_ga_log_notifier(u32 ga_tag)
+{
+	unsigned long flags;
+	struct kvm_svm *kvm_svm;
+	struct kvm_vcpu *vcpu = NULL;
+	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
+	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
+
+	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
+	trace_kvm_avic_ga_log(vm_id, vcpu_id);
+
+	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
+	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
+		if (kvm_svm->avic_vm_id != vm_id)
+			continue;
+		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
+		break;
+	}
+	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
+
+	/* Note:
+	 * At this point, the IOMMU should have already set the pending
+	 * bit in the vAPIC backing page. So, we just need to schedule
+	 * in the vcpu.
+	 */
+	if (vcpu)
+		kvm_vcpu_wake_up(vcpu);
+
+	return 0;
+}
+
+void avic_vm_destroy(struct kvm *kvm)
+{
+	unsigned long flags;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
+	if (!avic)
+		return;
+
+	if (kvm_svm->avic_logical_id_table_page)
+		__free_page(kvm_svm->avic_logical_id_table_page);
+	if (kvm_svm->avic_physical_id_table_page)
+		__free_page(kvm_svm->avic_physical_id_table_page);
+
+	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
+	hash_del(&kvm_svm->hnode);
+	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
+}
+
+int avic_vm_init(struct kvm *kvm)
+{
+	unsigned long flags;
+	int err = -ENOMEM;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	struct kvm_svm *k2;
+	struct page *p_page;
+	struct page *l_page;
+	u32 vm_id;
+
+	if (!avic)
+		return 0;
+
+	/* Allocating physical APIC ID table (4KB) */
+	p_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!p_page)
+		goto free_avic;
+
+	kvm_svm->avic_physical_id_table_page = p_page;
+	clear_page(page_address(p_page));
+
+	/* Allocating logical APIC ID table (4KB) */
+	l_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!l_page)
+		goto free_avic;
+
+	kvm_svm->avic_logical_id_table_page = l_page;
+	clear_page(page_address(l_page));
+
+	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
+ again:
+	vm_id = next_vm_id = (next_vm_id + 1) & AVIC_VM_ID_MASK;
+	if (vm_id == 0) { /* id is 1-based, zero is not okay */
+		next_vm_id_wrapped = 1;
+		goto again;
+	}
+	/* Is it still in use? Only possible if wrapped at least once */
+	if (next_vm_id_wrapped) {
+		hash_for_each_possible(svm_vm_data_hash, k2, hnode, vm_id) {
+			if (k2->avic_vm_id == vm_id)
+				goto again;
+		}
+	}
+	kvm_svm->avic_vm_id = vm_id;
+	hash_add(svm_vm_data_hash, &kvm_svm->hnode, kvm_svm->avic_vm_id);
+	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
+
+	return 0;
+
+free_avic:
+	avic_vm_destroy(kvm);
+	return err;
+}
+
+void avic_init_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb;
+	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
+	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
+	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
+	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
+
+	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
+	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
+	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	if (kvm_apicv_activated(svm->vcpu.kvm))
+		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	else
+		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+}
+
+static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
+				       unsigned int index)
+{
+	u64 *avic_physical_id_table;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+
+	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+		return NULL;
+
+	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
+
+	return &avic_physical_id_table[index];
+}
+
+/**
+ * Note:
+ * AVIC hardware walks the nested page table to check permissions,
+ * but does not use the SPA address specified in the leaf page
+ * table entry since it uses  address in the AVIC_BACKING_PAGE pointer
+ * field of the VMCB. Therefore, we set up the
+ * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
+ */
+static int avic_update_access_page(struct kvm *kvm, bool activate)
+{
+	int ret = 0;
+
+	mutex_lock(&kvm->slots_lock);
+	/*
+	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
+	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
+	 * memory region. So, we need to ensure that kvm->mm == current->mm.
+	 */
+	if ((kvm->arch.apic_access_page_done == activate) ||
+	    (kvm->mm != current->mm))
+		goto out;
+
+	ret = __x86_set_memory_region(kvm,
+				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+				      APIC_DEFAULT_PHYS_BASE,
+				      activate ? PAGE_SIZE : 0);
+	if (ret)
+		goto out;
+
+	kvm->arch.apic_access_page_done = activate;
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+
+static int avic_init_backing_page(struct kvm_vcpu *vcpu)
+{
+	u64 *entry, new_entry;
+	int id = vcpu->vcpu_id;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+		return -EINVAL;
+
+	if (!svm->vcpu.arch.apic->regs)
+		return -EINVAL;
+
+	if (kvm_apicv_activated(vcpu->kvm)) {
+		int ret;
+
+		ret = avic_update_access_page(vcpu->kvm, true);
+		if (ret)
+			return ret;
+	}
+
+	svm->avic_backing_page = virt_to_page(svm->vcpu.arch.apic->regs);
+
+	/* Setting AVIC backing page address in the phy APIC ID table */
+	entry = avic_get_physical_id_entry(vcpu, id);
+	if (!entry)
+		return -EINVAL;
+
+	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
+			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
+			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
+	WRITE_ONCE(*entry, new_entry);
+
+	svm->avic_physical_id_cache = entry;
+
+	return 0;
+}
+
+int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
+{
+	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
+	u32 icrl = svm->vmcb->control.exit_info_1;
+	u32 id = svm->vmcb->control.exit_info_2 >> 32;
+	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
+	struct kvm_lapic *apic = svm->vcpu.arch.apic;
+
+	trace_kvm_avic_incomplete_ipi(svm->vcpu.vcpu_id, icrh, icrl, id, index);
+
+	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
+		/*
+		 * AVIC hardware handles the generation of
+		 * IPIs when the specified Message Type is Fixed
+		 * (also known as fixed delivery mode) and
+		 * the Trigger Mode is edge-triggered. The hardware
+		 * also supports self and broadcast delivery modes
+		 * specified via the Destination Shorthand(DSH)
+		 * field of the ICRL. Logical and physical APIC ID
+		 * formats are supported. All other IPI types cause
+		 * a #VMEXIT, which needs to emulated.
+		 */
+		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
+		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
+		break;
+	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING: {
+		int i;
+		struct kvm_vcpu *vcpu;
+		struct kvm *kvm = svm->vcpu.kvm;
+		struct kvm_lapic *apic = svm->vcpu.arch.apic;
+
+		/*
+		 * At this point, we expect that the AVIC HW has already
+		 * set the appropriate IRR bits on the valid target
+		 * vcpus. So, we just need to kick the appropriate vcpu.
+		 */
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			bool m = kvm_apic_match_dest(vcpu, apic,
+						     icrl & APIC_SHORT_MASK,
+						     GET_APIC_DEST_FIELD(icrh),
+						     icrl & APIC_DEST_MASK);
+
+			if (m && !avic_vcpu_is_running(vcpu))
+				kvm_vcpu_wake_up(vcpu);
+		}
+		break;
+	}
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
+		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
+			  index, svm->vcpu.vcpu_id, icrh, icrl);
+		break;
+	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
+		WARN_ONCE(1, "Invalid backing page\n");
+		break;
+	default:
+		pr_err("Unknown IPI interception\n");
+	}
+
+	return 1;
+}
+
+static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+	int index;
+	u32 *logical_apic_id_table;
+	int dlid = GET_APIC_LOGICAL_ID(ldr);
+
+	if (!dlid)
+		return NULL;
+
+	if (flat) { /* flat */
+		index = ffs(dlid) - 1;
+		if (index > 7)
+			return NULL;
+	} else { /* cluster */
+		int cluster = (dlid & 0xf0) >> 4;
+		int apic = ffs(dlid & 0x0f) - 1;
+
+		if ((apic < 0) || (apic > 7) ||
+		    (cluster >= 0xf))
+			return NULL;
+		index = (cluster << 2) + apic;
+	}
+
+	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
+
+	return &logical_apic_id_table[index];
+}
+
+static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
+{
+	bool flat;
+	u32 *entry, new_entry;
+
+	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
+	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
+	if (!entry)
+		return -EINVAL;
+
+	new_entry = READ_ONCE(*entry);
+	new_entry &= ~AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
+	new_entry |= (g_physical_id & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK);
+	new_entry |= AVIC_LOGICAL_ID_ENTRY_VALID_MASK;
+	WRITE_ONCE(*entry, new_entry);
+
+	return 0;
+}
+
+static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
+	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+
+	if (entry)
+		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
+}
+
+static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
+{
+	int ret = 0;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
+	u32 id = kvm_xapic_id(vcpu->arch.apic);
+
+	if (ldr == svm->ldr_reg)
+		return 0;
+
+	avic_invalidate_logical_id_entry(vcpu);
+
+	if (ldr)
+		ret = avic_ldr_write(vcpu, id, ldr);
+
+	if (!ret)
+		svm->ldr_reg = ldr;
+
+	return ret;
+}
+
+static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
+{
+	u64 *old, *new;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 id = kvm_xapic_id(vcpu->arch.apic);
+
+	if (vcpu->vcpu_id == id)
+		return 0;
+
+	old = avic_get_physical_id_entry(vcpu, vcpu->vcpu_id);
+	new = avic_get_physical_id_entry(vcpu, id);
+	if (!new || !old)
+		return 1;
+
+	/* We need to move physical_id_entry to new offset */
+	*new = *old;
+	*old = 0ULL;
+	to_svm(vcpu)->avic_physical_id_cache = new;
+
+	/*
+	 * Also update the guest physical APIC ID in the logical
+	 * APIC ID table entry if already setup the LDR.
+	 */
+	if (svm->ldr_reg)
+		avic_handle_ldr_update(vcpu);
+
+	return 0;
+}
+
+static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 dfr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR);
+
+	if (svm->dfr_reg == dfr)
+		return;
+
+	avic_invalidate_logical_id_entry(vcpu);
+	svm->dfr_reg = dfr;
+}
+
+static int avic_unaccel_trap_write(struct vcpu_svm *svm)
+{
+	struct kvm_lapic *apic = svm->vcpu.arch.apic;
+	u32 offset = svm->vmcb->control.exit_info_1 &
+				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
+
+	switch (offset) {
+	case APIC_ID:
+		if (avic_handle_apic_id_update(&svm->vcpu))
+			return 0;
+		break;
+	case APIC_LDR:
+		if (avic_handle_ldr_update(&svm->vcpu))
+			return 0;
+		break;
+	case APIC_DFR:
+		avic_handle_dfr_update(&svm->vcpu);
+		break;
+	default:
+		break;
+	}
+
+	kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
+
+	return 1;
+}
+
+static bool is_avic_unaccelerated_access_trap(u32 offset)
+{
+	bool ret = false;
+
+	switch (offset) {
+	case APIC_ID:
+	case APIC_EOI:
+	case APIC_RRR:
+	case APIC_LDR:
+	case APIC_DFR:
+	case APIC_SPIV:
+	case APIC_ESR:
+	case APIC_ICR:
+	case APIC_LVTT:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
+	case APIC_TMICT:
+	case APIC_TDCR:
+		ret = true;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
+{
+	int ret = 0;
+	u32 offset = svm->vmcb->control.exit_info_1 &
+		     AVIC_UNACCEL_ACCESS_OFFSET_MASK;
+	u32 vector = svm->vmcb->control.exit_info_2 &
+		     AVIC_UNACCEL_ACCESS_VECTOR_MASK;
+	bool write = (svm->vmcb->control.exit_info_1 >> 32) &
+		     AVIC_UNACCEL_ACCESS_WRITE_MASK;
+	bool trap = is_avic_unaccelerated_access_trap(offset);
+
+	trace_kvm_avic_unaccelerated_access(svm->vcpu.vcpu_id, offset,
+					    trap, write, vector);
+	if (trap) {
+		/* Handling Trap */
+		WARN_ONCE(!write, "svm: Handling trap read.\n");
+		ret = avic_unaccel_trap_write(svm);
+	} else {
+		/* Handling Fault */
+		ret = kvm_emulate_instruction(&svm->vcpu, 0);
+	}
+
+	return ret;
+}
+
+int avic_init_vcpu(struct vcpu_svm *svm)
+{
+	int ret;
+
+	if (!kvm_vcpu_apicv_active(&svm->vcpu))
+		return 0;
+
+	ret = avic_init_backing_page(&svm->vcpu);
+	if (ret)
+		return ret;
+
+	INIT_LIST_HEAD(&svm->ir_list);
+	spin_lock_init(&svm->ir_list_lock);
+	svm->dfr_reg = APIC_DFR_FLAT;
+
+	return ret;
+}
+
+void avic_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	if (avic_handle_apic_id_update(vcpu) != 0)
+		return;
+	avic_handle_dfr_update(vcpu);
+	avic_handle_ldr_update(vcpu);
+}
+
+void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
+{
+	if (!avic || !lapic_in_kernel(vcpu))
+		return;
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_request_apicv_update(vcpu->kvm, activate,
+				 APICV_INHIBIT_REASON_IRQWIN);
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+}
+
+void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return;
+}
+
+void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+{
+}
+
+void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+{
+}
+
+static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (activate)
+			ret = amd_iommu_activate_guest_mode(ir->data);
+		else
+			ret = amd_iommu_deactivate_guest_mode(ir->data);
+		if (ret)
+			break;
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	return ret;
+}
+
+void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
+	bool activated = kvm_vcpu_apicv_active(vcpu);
+
+	if (!avic)
+		return;
+
+	if (activated) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_access_interception(). In this case,
+		 * we need to check and update the AVIC logical APIC ID table
+		 * accordingly before re-activating.
+		 */
+		avic_post_state_restore(vcpu);
+		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	} else {
+		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+	}
+	mark_dirty(vmcb, VMCB_AVIC);
+
+	svm_set_pi_irte_mode(vcpu, activated);
+}
+
+void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+{
+	return;
+}
+
+int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
+{
+	if (!vcpu->arch.apicv_active)
+		return -1;
+
+	kvm_lapic_set_irr(vec, vcpu->arch.apic);
+	smp_mb__after_atomic();
+
+	if (avic_vcpu_is_running(vcpu)) {
+		int cpuid = vcpu->cpu;
+
+		if (cpuid != get_cpu())
+			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpuid));
+		put_cpu();
+	} else
+		kvm_vcpu_wake_up(vcpu);
+
+	return 0;
+}
+
+bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
+{
+	unsigned long flags;
+	struct amd_svm_iommu_ir *cur;
+
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+	list_for_each_entry(cur, &svm->ir_list, node) {
+		if (cur->data != pi->ir_data)
+			continue;
+		list_del(&cur->node);
+		kfree(cur);
+		break;
+	}
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+}
+
+static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+
+	/**
+	 * In some cases, the existing irte is updaed and re-set,
+	 * so we need to check here if it's already been * added
+	 * to the ir_list.
+	 */
+	if (pi->ir_data && (pi->prev_ga_tag != 0)) {
+		struct kvm *kvm = svm->vcpu.kvm;
+		u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
+		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
+		struct vcpu_svm *prev_svm;
+
+		if (!prev_vcpu) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		prev_svm = to_svm(prev_vcpu);
+		svm_ir_list_del(prev_svm, pi);
+	}
+
+	/**
+	 * Allocating new amd_iommu_pi_data, which will get
+	 * add to the per-vcpu ir_list.
+	 */
+	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
+	if (!ir) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ir->data = pi->ir_data;
+
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+	list_add(&ir->node, &svm->ir_list);
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+out:
+	return ret;
+}
+
+/**
+ * Note:
+ * The HW cannot support posting multicast/broadcast
+ * interrupts to a vCPU. So, we still use legacy interrupt
+ * remapping for these kind of interrupts.
+ *
+ * For lowest-priority interrupts, we only support
+ * those with single CPU as the destination, e.g. user
+ * configures the interrupts via /proc/irq or uses
+ * irqbalance to make the interrupts single-CPU.
+ */
+static int
+get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
+		 struct vcpu_data *vcpu_info, struct vcpu_svm **svm)
+{
+	struct kvm_lapic_irq irq;
+	struct kvm_vcpu *vcpu = NULL;
+
+	kvm_set_msi_irq(kvm, e, &irq);
+
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq)) {
+		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
+			 __func__, irq.vector);
+		return -1;
+	}
+
+	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
+		 irq.vector);
+	*svm = to_svm(vcpu);
+	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
+	vcpu_info->vector = irq.vector;
+
+	return 0;
+}
+
+/*
+ * svm_update_pi_irte - set IRTE for Posted-Interrupts
+ *
+ * @kvm: kvm
+ * @host_irq: host irq of the interrupt
+ * @guest_irq: gsi of the interrupt
+ * @set: set or unset PI
+ * returns 0 on success, < 0 on failure
+ */
+int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
+		       uint32_t guest_irq, bool set)
+{
+	struct kvm_kernel_irq_routing_entry *e;
+	struct kvm_irq_routing_table *irq_rt;
+	int idx, ret = -EINVAL;
+
+	if (!kvm_arch_has_assigned_device(kvm) ||
+	    !irq_remapping_cap(IRQ_POSTING_CAP))
+		return 0;
+
+	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
+		 __func__, host_irq, guest_irq, set);
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	WARN_ON(guest_irq >= irq_rt->nr_rt_entries);
+
+	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
+		struct vcpu_data vcpu_info;
+		struct vcpu_svm *svm = NULL;
+
+		if (e->type != KVM_IRQ_ROUTING_MSI)
+			continue;
+
+		/**
+		 * Here, we setup with legacy mode in the following cases:
+		 * 1. When cannot target interrupt to a specific vcpu.
+		 * 2. Unsetting posted interrupt.
+		 * 3. APIC virtialization is disabled for the vcpu.
+		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
+		 */
+		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
+		    kvm_vcpu_apicv_active(&svm->vcpu)) {
+			struct amd_iommu_pi_data pi;
+
+			/* Try to enable guest_mode in IRTE */
+			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
+					    AVIC_HPA_MASK);
+			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
+						     svm->vcpu.vcpu_id);
+			pi.is_guest_mode = true;
+			pi.vcpu_data = &vcpu_info;
+			ret = irq_set_vcpu_affinity(host_irq, &pi);
+
+			/**
+			 * Here, we successfully setting up vcpu affinity in
+			 * IOMMU guest mode. Now, we need to store the posted
+			 * interrupt information in a per-vcpu ir_list so that
+			 * we can reference to them directly when we update vcpu
+			 * scheduling information in IOMMU irte.
+			 */
+			if (!ret && pi.is_guest_mode)
+				svm_ir_list_add(svm, &pi);
+		} else {
+			/* Use legacy mode in IRTE */
+			struct amd_iommu_pi_data pi;
+
+			/**
+			 * Here, pi is used to:
+			 * - Tell IOMMU to use legacy mode for this interrupt.
+			 * - Retrieve ga_tag of prior interrupt remapping data.
+			 */
+			pi.is_guest_mode = false;
+			ret = irq_set_vcpu_affinity(host_irq, &pi);
+
+			/**
+			 * Check if the posted interrupt was previously
+			 * setup with the guest_mode by checking if the ga_tag
+			 * was cached. If so, we need to clean up the per-vcpu
+			 * ir_list.
+			 */
+			if (!ret && pi.prev_ga_tag) {
+				int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
+				struct kvm_vcpu *vcpu;
+
+				vcpu = kvm_get_vcpu_by_id(kvm, id);
+				if (vcpu)
+					svm_ir_list_del(to_svm(vcpu), &pi);
+			}
+		}
+
+		if (!ret && svm) {
+			trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
+						 e->gsi, vcpu_info.vector,
+						 vcpu_info.pi_desc_addr, set);
+		}
+
+		if (ret < 0) {
+			pr_err("%s: failed to update PI IRTE\n", __func__);
+			goto out;
+		}
+	}
+
+	ret = 0;
+out:
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+	return ret;
+}
+
+bool svm_check_apicv_inhibit_reasons(ulong bit)
+{
+	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
+			  BIT(APICV_INHIBIT_REASON_HYPERV) |
+			  BIT(APICV_INHIBIT_REASON_NESTED) |
+			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
+			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
+
+	return supported & BIT(bit);
+}
+
+void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
+{
+	avic_update_access_page(kvm, activate);
+}
+
+static inline int
+avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		ret = amd_iommu_update_ga(cpu, r, ir->data);
+		if (ret)
+			break;
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	return ret;
+}
+
+void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	u64 entry;
+	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
+	int h_physical_id = kvm_cpu_get_apicid(cpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
+	/*
+	 * Since the host physical APIC id is 8 bits,
+	 * we can support host APIC ID upto 255.
+	 */
+	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+		return;
+
+	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+
+	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+
+	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	if (svm->avic_is_running)
+		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+
+	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
+					svm->avic_is_running);
+}
+
+void avic_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	u64 entry;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
+	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
+		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+
+	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+}
+
+/**
+ * This function is called during VCPU halt/unhalt.
+ */
+static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->avic_is_running = is_run;
+	if (is_run)
+		avic_vcpu_load(vcpu, vcpu->cpu);
+	else
+		avic_vcpu_put(vcpu);
+}
+
+void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+	avic_set_running(vcpu, false);
+}
+
+void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+		kvm_vcpu_update_apicv(vcpu);
+	avic_set_running(vcpu, true);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b74ebc19e1f6..19622c777a90 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1,17 +1,3 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Kernel-based Virtual Machine driver for Linux
- *
- * AMD SVM support
- *
- * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affiliates.
- *
- * Authors:
- *   Yaniv Kamay  <yaniv@qumranet.com>
- *   Avi Kivity   <avi@qumranet.com>
- */
-
 #define pr_fmt(fmt) "SVM: " fmt
 
 #include <linux/kvm_host.h>
@@ -28,10 +14,10 @@
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
+#include <linux/amd-iommu.h>
 #include <linux/sched.h>
 #include <linux/trace_events.h>
 #include <linux/slab.h>
-#include <linux/amd-iommu.h>
 #include <linux/hashtable.h>
 #include <linux/frame.h>
 #include <linux/psp-sev.h>
@@ -79,39 +65,12 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 #define SVM_FEATURE_DECODE_ASSIST  (1 <<  7)
 #define SVM_FEATURE_PAUSE_FILTER   (1 << 10)
 
-#define SVM_AVIC_DOORBELL	0xc001011b
-
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
 #define TSC_RATIO_RSVD          0xffffff0000000000ULL
 #define TSC_RATIO_MIN		0x0000000000000001ULL
 #define TSC_RATIO_MAX		0x000000ffffffffffULL
 
-#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-
-/*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
- */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	255
-
-#define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
-#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
-#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
-
-/* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS		8
-#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
-
-#define AVIC_VM_ID_BITS			24
-#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
-#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
-
-#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
-						(y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
-#define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
-
 static bool erratum_383_found __read_mostly;
 
 u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
@@ -122,23 +81,6 @@ u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
  */
 static uint64_t osvw_len = 4, osvw_status;
 
-/*
- * This is a wrapper of struct amd_iommu_ir_data.
- */
-struct amd_svm_iommu_ir {
-	struct list_head node;	/* Used by SVM for per-vcpu ir_list */
-	void *data;		/* Storing pointer to struct amd_ir_data */
-};
-
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
-#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
-
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 #define TSC_RATIO_DEFAULT	0x0100000000ULL
 
@@ -228,12 +170,6 @@ module_param(npt, int, S_IRUGO);
 static int nested = true;
 module_param(nested, int, S_IRUGO);
 
-/* enable / disable AVIC */
-static int avic;
-#ifdef CONFIG_X86_LOCAL_APIC
-module_param(avic, int, S_IRUGO);
-#endif
-
 /* enable/disable Next RIP Save */
 static int nrips = true;
 module_param(nrips, int, 0444);
@@ -256,10 +192,6 @@ module_param(dump_invalid_vmcb, bool, 0644);
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_complete_interrupts(struct vcpu_svm *svm);
-static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
-static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
-
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -279,11 +211,6 @@ struct enc_region {
 };
 
 
-static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
-{
-	return container_of(kvm, struct kvm_svm, kvm);
-}
-
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
@@ -307,23 +234,6 @@ static inline int sev_get_asid(struct kvm *kvm)
 	return sev->asid;
 }
 
-static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
-{
-	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
-	mark_dirty(svm->vmcb, VMCB_AVIC);
-}
-
-static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u64 *entry = svm->avic_physical_id_cache;
-
-	if (!entry)
-		return false;
-
-	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
-}
-
 static unsigned long iopm_base;
 
 struct kvm_ldttss_desc {
@@ -850,52 +760,6 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 	}
 }
 
-/* Note:
- * This hash table is used to map VM_ID to a struct kvm_svm,
- * when handling AMD IOMMU GALOG notification to schedule in
- * a particular vCPU.
- */
-#define SVM_VM_DATA_HASH_BITS	8
-static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
-static u32 next_vm_id = 0;
-static bool next_vm_id_wrapped = 0;
-static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
-
-/* Note:
- * This function is called from IOMMU driver to notify
- * SVM to schedule in a particular vCPU of a particular VM.
- */
-static int avic_ga_log_notifier(u32 ga_tag)
-{
-	unsigned long flags;
-	struct kvm_svm *kvm_svm;
-	struct kvm_vcpu *vcpu = NULL;
-	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
-	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
-
-	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
-	trace_kvm_avic_ga_log(vm_id, vcpu_id);
-
-	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
-	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
-		if (kvm_svm->avic_vm_id != vm_id)
-			continue;
-		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
-		break;
-	}
-	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
-
-	/* Note:
-	 * At this point, the IOMMU should have already set the pending
-	 * bit in the vAPIC backing page. So, we just need to schedule
-	 * in the vcpu.
-	 */
-	if (vcpu)
-		kvm_vcpu_wake_up(vcpu);
-
-	return 0;
-}
-
 static __init int sev_hardware_setup(void)
 {
 	struct sev_user_data_status *status;
@@ -1224,24 +1088,6 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	return svm->vmcb->control.tsc_offset;
 }
 
-static void avic_init_vmcb(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb;
-	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
-	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
-	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
-	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
-
-	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
-	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
-	if (kvm_apicv_activated(svm->vcpu.kvm))
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	else
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
-}
-
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1401,92 +1247,6 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 }
 
-static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
-				       unsigned int index)
-{
-	u64 *avic_physical_id_table;
-	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
-		return NULL;
-
-	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
-
-	return &avic_physical_id_table[index];
-}
-
-/**
- * Note:
- * AVIC hardware walks the nested page table to check permissions,
- * but does not use the SPA address specified in the leaf page
- * table entry since it uses  address in the AVIC_BACKING_PAGE pointer
- * field of the VMCB. Therefore, we set up the
- * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
- */
-static int avic_update_access_page(struct kvm *kvm, bool activate)
-{
-	int ret = 0;
-
-	mutex_lock(&kvm->slots_lock);
-	/*
-	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
-	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
-	 * memory region. So, we need to ensure that kvm->mm == current->mm.
-	 */
-	if ((kvm->arch.apic_access_page_done == activate) ||
-	    (kvm->mm != current->mm))
-		goto out;
-
-	ret = __x86_set_memory_region(kvm,
-				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
-				      APIC_DEFAULT_PHYS_BASE,
-				      activate ? PAGE_SIZE : 0);
-	if (ret)
-		goto out;
-
-	kvm->arch.apic_access_page_done = activate;
-out:
-	mutex_unlock(&kvm->slots_lock);
-	return ret;
-}
-
-static int avic_init_backing_page(struct kvm_vcpu *vcpu)
-{
-	u64 *entry, new_entry;
-	int id = vcpu->vcpu_id;
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
-		return -EINVAL;
-
-	if (!svm->vcpu.arch.apic->regs)
-		return -EINVAL;
-
-	if (kvm_apicv_activated(vcpu->kvm)) {
-		int ret;
-
-		ret = avic_update_access_page(vcpu->kvm, true);
-		if (ret)
-			return ret;
-	}
-
-	svm->avic_backing_page = virt_to_page(svm->vcpu.arch.apic->regs);
-
-	/* Setting AVIC backing page address in the phy APIC ID table */
-	entry = avic_get_physical_id_entry(vcpu, id);
-	if (!entry)
-		return -EINVAL;
-
-	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
-			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
-			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
-	WRITE_ONCE(*entry, new_entry);
-
-	svm->avic_physical_id_cache = entry;
-
-	return 0;
-}
-
 static void sev_asid_free(int asid)
 {
 	struct svm_cpu_data *sd;
@@ -1663,84 +1423,12 @@ static void sev_vm_destroy(struct kvm *kvm)
 	sev_asid_free(sev->asid);
 }
 
-static void avic_vm_destroy(struct kvm *kvm)
-{
-	unsigned long flags;
-	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
-
-	if (!avic)
-		return;
-
-	if (kvm_svm->avic_logical_id_table_page)
-		__free_page(kvm_svm->avic_logical_id_table_page);
-	if (kvm_svm->avic_physical_id_table_page)
-		__free_page(kvm_svm->avic_physical_id_table_page);
-
-	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
-	hash_del(&kvm_svm->hnode);
-	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
-}
-
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
 }
 
-static int avic_vm_init(struct kvm *kvm)
-{
-	unsigned long flags;
-	int err = -ENOMEM;
-	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
-	struct kvm_svm *k2;
-	struct page *p_page;
-	struct page *l_page;
-	u32 vm_id;
-
-	if (!avic)
-		return 0;
-
-	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!p_page)
-		goto free_avic;
-
-	kvm_svm->avic_physical_id_table_page = p_page;
-	clear_page(page_address(p_page));
-
-	/* Allocating logical APIC ID table (4KB) */
-	l_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!l_page)
-		goto free_avic;
-
-	kvm_svm->avic_logical_id_table_page = l_page;
-	clear_page(page_address(l_page));
-
-	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
- again:
-	vm_id = next_vm_id = (next_vm_id + 1) & AVIC_VM_ID_MASK;
-	if (vm_id == 0) { /* id is 1-based, zero is not okay */
-		next_vm_id_wrapped = 1;
-		goto again;
-	}
-	/* Is it still in use? Only possible if wrapped at least once */
-	if (next_vm_id_wrapped) {
-		hash_for_each_possible(svm_vm_data_hash, k2, hnode, vm_id) {
-			if (k2->avic_vm_id == vm_id)
-				goto again;
-		}
-	}
-	kvm_svm->avic_vm_id = vm_id;
-	hash_add(svm_vm_data_hash, &kvm_svm->hnode, kvm_svm->avic_vm_id);
-	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
-
-	return 0;
-
-free_avic:
-	avic_vm_destroy(kvm);
-	return err;
-}
-
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (avic) {
@@ -1753,98 +1441,6 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static inline int
-avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
-{
-	int ret = 0;
-	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
-	/*
-	 * Here, we go through the per-vcpu ir_list to update all existing
-	 * interrupt remapping table entry targeting this vcpu.
-	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	if (list_empty(&svm->ir_list))
-		goto out;
-
-	list_for_each_entry(ir, &svm->ir_list, node) {
-		ret = amd_iommu_update_ga(cpu, r, ir->data);
-		if (ret)
-			break;
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
-}
-
-static void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-{
-	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
-	int h_physical_id = kvm_cpu_get_apicid(cpu);
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
-		return;
-
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	if (svm->avic_is_running)
-		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
-					svm->avic_is_running);
-}
-
-static void avic_vcpu_put(struct kvm_vcpu *vcpu)
-{
-	u64 entry;
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-}
-
-/**
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->avic_is_running = is_run;
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-}
-
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1869,24 +1465,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
-static int avic_init_vcpu(struct vcpu_svm *svm)
-{
-	int ret;
-
-	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		return 0;
-
-	ret = avic_init_backing_page(&svm->vcpu);
-	if (ret)
-		return ret;
-
-	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
-	svm->dfr_reg = APIC_DFR_FLAT;
-
-	return ret;
-}
-
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
@@ -2043,18 +1621,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
 
-static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-	avic_set_running(vcpu, false);
-}
-
-static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
-		kvm_vcpu_update_apicv(vcpu);
-	avic_set_running(vcpu, true);
-}
-
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3434,276 +3000,6 @@ static int mwait_interception(struct vcpu_svm *svm)
 	return nop_interception(svm);
 }
 
-enum avic_ipi_failure_cause {
-	AVIC_IPI_FAILURE_INVALID_INT_TYPE,
-	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
-	AVIC_IPI_FAILURE_INVALID_TARGET,
-	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
-};
-
-static int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
-{
-	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
-	u32 icrl = svm->vmcb->control.exit_info_1;
-	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
-	struct kvm_lapic *apic = svm->vcpu.arch.apic;
-
-	trace_kvm_avic_incomplete_ipi(svm->vcpu.vcpu_id, icrh, icrl, id, index);
-
-	switch (id) {
-	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
-		/*
-		 * AVIC hardware handles the generation of
-		 * IPIs when the specified Message Type is Fixed
-		 * (also known as fixed delivery mode) and
-		 * the Trigger Mode is edge-triggered. The hardware
-		 * also supports self and broadcast delivery modes
-		 * specified via the Destination Shorthand(DSH)
-		 * field of the ICRL. Logical and physical APIC ID
-		 * formats are supported. All other IPI types cause
-		 * a #VMEXIT, which needs to emulated.
-		 */
-		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
-		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
-		break;
-	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING: {
-		int i;
-		struct kvm_vcpu *vcpu;
-		struct kvm *kvm = svm->vcpu.kvm;
-		struct kvm_lapic *apic = svm->vcpu.arch.apic;
-
-		/*
-		 * At this point, we expect that the AVIC HW has already
-		 * set the appropriate IRR bits on the valid target
-		 * vcpus. So, we just need to kick the appropriate vcpu.
-		 */
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			bool m = kvm_apic_match_dest(vcpu, apic,
-						     icrl & APIC_SHORT_MASK,
-						     GET_APIC_DEST_FIELD(icrh),
-						     icrl & APIC_DEST_MASK);
-
-			if (m && !avic_vcpu_is_running(vcpu))
-				kvm_vcpu_wake_up(vcpu);
-		}
-		break;
-	}
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
-			  index, svm->vcpu.vcpu_id, icrh, icrl);
-		break;
-	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
-		WARN_ONCE(1, "Invalid backing page\n");
-		break;
-	default:
-		pr_err("Unknown IPI interception\n");
-	}
-
-	return 1;
-}
-
-static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
-{
-	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-	int index;
-	u32 *logical_apic_id_table;
-	int dlid = GET_APIC_LOGICAL_ID(ldr);
-
-	if (!dlid)
-		return NULL;
-
-	if (flat) { /* flat */
-		index = ffs(dlid) - 1;
-		if (index > 7)
-			return NULL;
-	} else { /* cluster */
-		int cluster = (dlid & 0xf0) >> 4;
-		int apic = ffs(dlid & 0x0f) - 1;
-
-		if ((apic < 0) || (apic > 7) ||
-		    (cluster >= 0xf))
-			return NULL;
-		index = (cluster << 2) + apic;
-	}
-
-	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
-
-	return &logical_apic_id_table[index];
-}
-
-static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
-{
-	bool flat;
-	u32 *entry, new_entry;
-
-	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
-	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
-	if (!entry)
-		return -EINVAL;
-
-	new_entry = READ_ONCE(*entry);
-	new_entry &= ~AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
-	new_entry |= (g_physical_id & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK);
-	new_entry |= AVIC_LOGICAL_ID_ENTRY_VALID_MASK;
-	WRITE_ONCE(*entry, new_entry);
-
-	return 0;
-}
-
-static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
-
-	if (entry)
-		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
-}
-
-static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
-{
-	int ret = 0;
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
-
-	if (ldr == svm->ldr_reg)
-		return 0;
-
-	avic_invalidate_logical_id_entry(vcpu);
-
-	if (ldr)
-		ret = avic_ldr_write(vcpu, id, ldr);
-
-	if (!ret)
-		svm->ldr_reg = ldr;
-
-	return ret;
-}
-
-static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
-{
-	u64 *old, *new;
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
-
-	if (vcpu->vcpu_id == id)
-		return 0;
-
-	old = avic_get_physical_id_entry(vcpu, vcpu->vcpu_id);
-	new = avic_get_physical_id_entry(vcpu, id);
-	if (!new || !old)
-		return 1;
-
-	/* We need to move physical_id_entry to new offset */
-	*new = *old;
-	*old = 0ULL;
-	to_svm(vcpu)->avic_physical_id_cache = new;
-
-	/*
-	 * Also update the guest physical APIC ID in the logical
-	 * APIC ID table entry if already setup the LDR.
-	 */
-	if (svm->ldr_reg)
-		avic_handle_ldr_update(vcpu);
-
-	return 0;
-}
-
-static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 dfr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR);
-
-	if (svm->dfr_reg == dfr)
-		return;
-
-	avic_invalidate_logical_id_entry(vcpu);
-	svm->dfr_reg = dfr;
-}
-
-static int avic_unaccel_trap_write(struct vcpu_svm *svm)
-{
-	struct kvm_lapic *apic = svm->vcpu.arch.apic;
-	u32 offset = svm->vmcb->control.exit_info_1 &
-				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
-
-	switch (offset) {
-	case APIC_ID:
-		if (avic_handle_apic_id_update(&svm->vcpu))
-			return 0;
-		break;
-	case APIC_LDR:
-		if (avic_handle_ldr_update(&svm->vcpu))
-			return 0;
-		break;
-	case APIC_DFR:
-		avic_handle_dfr_update(&svm->vcpu);
-		break;
-	default:
-		break;
-	}
-
-	kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
-
-	return 1;
-}
-
-static bool is_avic_unaccelerated_access_trap(u32 offset)
-{
-	bool ret = false;
-
-	switch (offset) {
-	case APIC_ID:
-	case APIC_EOI:
-	case APIC_RRR:
-	case APIC_LDR:
-	case APIC_DFR:
-	case APIC_SPIV:
-	case APIC_ESR:
-	case APIC_ICR:
-	case APIC_LVTT:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
-	case APIC_TMICT:
-	case APIC_TDCR:
-		ret = true;
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-static int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
-{
-	int ret = 0;
-	u32 offset = svm->vmcb->control.exit_info_1 &
-		     AVIC_UNACCEL_ACCESS_OFFSET_MASK;
-	u32 vector = svm->vmcb->control.exit_info_2 &
-		     AVIC_UNACCEL_ACCESS_VECTOR_MASK;
-	bool write = (svm->vmcb->control.exit_info_1 >> 32) &
-		     AVIC_UNACCEL_ACCESS_WRITE_MASK;
-	bool trap = is_avic_unaccelerated_access_trap(offset);
-
-	trace_kvm_avic_unaccelerated_access(svm->vcpu.vcpu_id, offset,
-					    trap, write, vector);
-	if (trap) {
-		/* Handling Trap */
-		WARN_ONCE(!write, "svm: Handling trap read.\n");
-		ret = avic_unaccel_trap_write(svm);
-	} else {
-		/* Handling Fault */
-		ret = kvm_emulate_instruction(&svm->vcpu, 0);
-	}
-
-	return ret;
-}
-
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -4071,324 +3367,6 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
-static void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
-{
-	return;
-}
-
-static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-{
-}
-
-static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
-{
-}
-
-static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
-{
-	if (!avic || !lapic_in_kernel(vcpu))
-		return;
-
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	kvm_request_apicv_update(vcpu->kvm, activate,
-				 APICV_INHIBIT_REASON_IRQWIN);
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-}
-
-static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
-{
-	int ret = 0;
-	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
-	/*
-	 * Here, we go through the per-vcpu ir_list to update all existing
-	 * interrupt remapping table entry targeting this vcpu.
-	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	if (list_empty(&svm->ir_list))
-		goto out;
-
-	list_for_each_entry(ir, &svm->ir_list, node) {
-		if (activate)
-			ret = amd_iommu_activate_guest_mode(ir->data);
-		else
-			ret = amd_iommu_deactivate_guest_mode(ir->data);
-		if (ret)
-			break;
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
-}
-
-static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb;
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-
-	if (!avic)
-		return;
-
-	if (activated) {
-		/**
-		 * During AVIC temporary deactivation, guest could update
-		 * APIC ID, DFR and LDR registers, which would not be trapped
-		 * by avic_unaccelerated_access_interception(). In this case,
-		 * we need to check and update the AVIC logical APIC ID table
-		 * accordingly before re-activating.
-		 */
-		avic_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
-	}
-	mark_dirty(vmcb, VMCB_AVIC);
-
-	svm_set_pi_irte_mode(vcpu, activated);
-}
-
-static void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-{
-	return;
-}
-
-static int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
-{
-	if (!vcpu->arch.apicv_active)
-		return -1;
-
-	kvm_lapic_set_irr(vec, vcpu->arch.apic);
-	smp_mb__after_atomic();
-
-	if (avic_vcpu_is_running(vcpu)) {
-		int cpuid = vcpu->cpu;
-
-		if (cpuid != get_cpu())
-			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpuid));
-		put_cpu();
-	} else
-		kvm_vcpu_wake_up(vcpu);
-
-	return 0;
-}
-
-static bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-
-static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
-{
-	unsigned long flags;
-	struct amd_svm_iommu_ir *cur;
-
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-	list_for_each_entry(cur, &svm->ir_list, node) {
-		if (cur->data != pi->ir_data)
-			continue;
-		list_del(&cur->node);
-		kfree(cur);
-		break;
-	}
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-}
-
-static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
-{
-	int ret = 0;
-	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
-
-	/**
-	 * In some cases, the existing irte is updaed and re-set,
-	 * so we need to check here if it's already been * added
-	 * to the ir_list.
-	 */
-	if (pi->ir_data && (pi->prev_ga_tag != 0)) {
-		struct kvm *kvm = svm->vcpu.kvm;
-		u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
-		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
-		struct vcpu_svm *prev_svm;
-
-		if (!prev_vcpu) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		prev_svm = to_svm(prev_vcpu);
-		svm_ir_list_del(prev_svm, pi);
-	}
-
-	/**
-	 * Allocating new amd_iommu_pi_data, which will get
-	 * add to the per-vcpu ir_list.
-	 */
-	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
-	if (!ir) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ir->data = pi->ir_data;
-
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-	list_add(&ir->node, &svm->ir_list);
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-out:
-	return ret;
-}
-
-/**
- * Note:
- * The HW cannot support posting multicast/broadcast
- * interrupts to a vCPU. So, we still use legacy interrupt
- * remapping for these kind of interrupts.
- *
- * For lowest-priority interrupts, we only support
- * those with single CPU as the destination, e.g. user
- * configures the interrupts via /proc/irq or uses
- * irqbalance to make the interrupts single-CPU.
- */
-static int
-get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		 struct vcpu_data *vcpu_info, struct vcpu_svm **svm)
-{
-	struct kvm_lapic_irq irq;
-	struct kvm_vcpu *vcpu = NULL;
-
-	kvm_set_msi_irq(kvm, e, &irq);
-
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-	    !kvm_irq_is_postable(&irq)) {
-		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
-			 __func__, irq.vector);
-		return -1;
-	}
-
-	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
-		 irq.vector);
-	*svm = to_svm(vcpu);
-	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
-	vcpu_info->vector = irq.vector;
-
-	return 0;
-}
-
-/*
- * svm_update_pi_irte - set IRTE for Posted-Interrupts
- *
- * @kvm: kvm
- * @host_irq: host irq of the interrupt
- * @guest_irq: gsi of the interrupt
- * @set: set or unset PI
- * returns 0 on success, < 0 on failure
- */
-static int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
-			      uint32_t guest_irq, bool set)
-{
-	struct kvm_kernel_irq_routing_entry *e;
-	struct kvm_irq_routing_table *irq_rt;
-	int idx, ret = -EINVAL;
-
-	if (!kvm_arch_has_assigned_device(kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP))
-		return 0;
-
-	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, set);
-
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	WARN_ON(guest_irq >= irq_rt->nr_rt_entries);
-
-	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
-		struct vcpu_data vcpu_info;
-		struct vcpu_svm *svm = NULL;
-
-		if (e->type != KVM_IRQ_ROUTING_MSI)
-			continue;
-
-		/**
-		 * Here, we setup with legacy mode in the following cases:
-		 * 1. When cannot target interrupt to a specific vcpu.
-		 * 2. Unsetting posted interrupt.
-		 * 3. APIC virtialization is disabled for the vcpu.
-		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
-		 */
-		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
-		    kvm_vcpu_apicv_active(&svm->vcpu)) {
-			struct amd_iommu_pi_data pi;
-
-			/* Try to enable guest_mode in IRTE */
-			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
-					    AVIC_HPA_MASK);
-			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-						     svm->vcpu.vcpu_id);
-			pi.is_guest_mode = true;
-			pi.vcpu_data = &vcpu_info;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Here, we successfully setting up vcpu affinity in
-			 * IOMMU guest mode. Now, we need to store the posted
-			 * interrupt information in a per-vcpu ir_list so that
-			 * we can reference to them directly when we update vcpu
-			 * scheduling information in IOMMU irte.
-			 */
-			if (!ret && pi.is_guest_mode)
-				svm_ir_list_add(svm, &pi);
-		} else {
-			/* Use legacy mode in IRTE */
-			struct amd_iommu_pi_data pi;
-
-			/**
-			 * Here, pi is used to:
-			 * - Tell IOMMU to use legacy mode for this interrupt.
-			 * - Retrieve ga_tag of prior interrupt remapping data.
-			 */
-			pi.is_guest_mode = false;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Check if the posted interrupt was previously
-			 * setup with the guest_mode by checking if the ga_tag
-			 * was cached. If so, we need to clean up the per-vcpu
-			 * ir_list.
-			 */
-			if (!ret && pi.prev_ga_tag) {
-				int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
-				struct kvm_vcpu *vcpu;
-
-				vcpu = kvm_get_vcpu_by_id(kvm, id);
-				if (vcpu)
-					svm_ir_list_del(to_svm(vcpu), &pi);
-			}
-		}
-
-		if (!ret && svm) {
-			trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
-						 e->gsi, vcpu_info.vector,
-						 vcpu_info.pi_desc_addr, set);
-		}
-
-		if (ret < 0) {
-			pr_err("%s: failed to update PI IRTE\n", __func__);
-			goto out;
-		}
-	}
-
-	ret = 0;
-out:
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-	return ret;
-}
-
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5155,14 +4133,6 @@ static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		shrink_ple_window(vcpu);
 }
 
-static inline void avic_post_state_restore(struct kvm_vcpu *vcpu)
-{
-	if (avic_handle_apic_id_update(vcpu) != 0)
-		return;
-	avic_handle_dfr_update(vcpu);
-	avic_handle_ldr_update(vcpu);
-}
-
 static void svm_setup_mce(struct kvm_vcpu *vcpu)
 {
 	/* [63:9] are reserved. */
@@ -6200,23 +5170,6 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
-static bool svm_check_apicv_inhibit_reasons(ulong bit)
-{
-	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED) |
-			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
-			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC);
-
-	return supported & BIT(bit);
-}
-
-static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
-{
-	avic_update_access_page(kvm, activate);
-}
-
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f4c446d7a31e..c7abc1fede97 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -173,6 +173,11 @@ struct vcpu_svm {
 
 void recalc_intercepts(struct vcpu_svm *svm);
 
+static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
+{
+	return container_of(kvm, struct kvm_svm, kvm);
+}
+
 static inline void mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -378,4 +383,61 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int svm_check_nested_events(struct kvm_vcpu *vcpu);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 
+/* avic.c */
+
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
+#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
+#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
+
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
+#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
+#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
+
+#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
+
+extern int avic;
+
+static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
+{
+	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
+	mark_dirty(svm->vmcb, VMCB_AVIC);
+}
+
+static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 *entry = svm->avic_physical_id_cache;
+
+	if (!entry)
+		return false;
+
+	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+}
+
+int avic_ga_log_notifier(u32 ga_tag);
+void avic_vm_destroy(struct kvm *kvm);
+int avic_vm_init(struct kvm *kvm);
+void avic_init_vmcb(struct vcpu_svm *svm);
+void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
+int avic_incomplete_ipi_interception(struct vcpu_svm *svm);
+int avic_unaccelerated_access_interception(struct vcpu_svm *svm);
+int avic_init_vcpu(struct vcpu_svm *svm);
+void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void avic_vcpu_put(struct kvm_vcpu *vcpu);
+void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
+bool svm_check_apicv_inhibit_reasons(ulong bit);
+void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate);
+void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
+void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
+void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
+int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
+bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
+int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
+		       uint32_t guest_irq, bool set);
+void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
+void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.17.1

