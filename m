Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7369487F32
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437222AbfHIQPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:14 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437163AbfHIQPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:11 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4E4613031EB9;
        Fri,  9 Aug 2019 19:01:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 922F4305B7A9;
        Fri,  9 Aug 2019 19:01:23 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [RFC PATCH v6 56/92] kvm: x86: block any attempt to disable MSR interception if tracked by introspection
Date:   Fri,  9 Aug 2019 19:00:11 +0300
Message-Id: <20190809160047.8319-57-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

Intercept all calls that might disable the MSR interception (writes) and
do nothing if that specific MSR is currently tracked by the introspection
tool.

CC: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Jim Mattson <jmattson@google.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  6 +++
 arch/x86/kvm/kvmi.c              | 25 +++++++++++++
 arch/x86/kvm/svm.c               | 33 ++++++++++-------
 arch/x86/kvm/vmx/vmx.c           | 63 +++++++++++++++++++-------------
 4 files changed, 88 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 8285d1eb0db6..86d90b7bed84 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -12,6 +12,7 @@ struct kvmi_arch_mem_access {
 #ifdef CONFIG_KVM_INTROSPECTION
 
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
+bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 
@@ -22,6 +23,11 @@ static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return true;
 }
 
+static inline bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return false;
+}
+
 static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 				 unsigned long old_value,
 				 unsigned long *new_value)
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 5dba4f87afef..fc6956b50da2 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -136,6 +136,31 @@ bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return ret;
 }
 
+bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvmi *ikvm;
+	bool ret = false;
+
+	if (!vcpu)
+		return false;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	if (test_msr_mask(vcpu, msr)) {
+		kvmi_warn_once(ikvm,
+			       "Trying to disable write interception for MSR %x\n",
+			       msr);
+		ret = true;
+	}
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_monitored_msr);
+
 static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
 				       const struct kvmi_get_registers *req,
 				       size_t *rpl_size)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cdb315578979..e46a4c423545 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -18,6 +18,7 @@
 #define pr_fmt(fmt) "SVM: " fmt
 
 #include <linux/kvm_host.h>
+#include <asm/kvmi_host.h>
 
 #include "irq.h"
 #include "mmu.h"
@@ -1049,13 +1050,19 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(u32 *msrpm, unsigned msr,
+static void set_msr_interception(struct vcpu_svm *svm,
+				 u32 *msrpm, unsigned int msr,
 				 int read, int write)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
 	u32 offset;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (!write && kvmi_monitored_msr(&svm->vcpu, msr))
+		return;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	/*
 	 * If this warning triggers extend the direct_access_msrs list at the
 	 * beginning of the file
@@ -1085,7 +1092,7 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(NULL, msrpm, direct_access_msrs[i].index, 1, 1);
 	}
 }
 
@@ -1137,10 +1144,10 @@ static void svm_enable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
 static void svm_disable_lbrv(struct vcpu_svm *svm)
@@ -1148,10 +1155,10 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
+	set_msr_interception(svm, msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
 }
 
 static void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -4290,7 +4297,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(svm, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -4306,7 +4313,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 		if (is_guest_mode(vcpu))
 			break;
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(svm, svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -7109,7 +7116,7 @@ static void svm_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 	 * read and write. The best way will be to get here the current
 	 * bit status for read and send that value as argument.
 	 */
-	set_msr_interception(msrpm, msr, enable, enable);
+	set_msr_interception(svm, msrpm, msr, enable, enable);
 }
 
 static bool svm_nested_pagefault(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0306c7ef3158..fff41adcdffe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -21,6 +21,7 @@
 #include <linux/hrtimer.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
+#include <asm/kvmi_host.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
@@ -336,7 +337,8 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type);
 
 void vmx_vmexit(void);
@@ -1862,7 +1864,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+		vmx_disable_intercept_for_msr(vcpu, vmx->vmcs01.msr_bitmap,
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
@@ -1890,7 +1892,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
+		vmx_disable_intercept_for_msr(vcpu, vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
 					      MSR_TYPE_W);
 		break;
 	case MSR_IA32_ARCH_CAPABILITIES:
@@ -3463,7 +3465,8 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type)
 {
 	int f = sizeof(unsigned long);
@@ -3471,6 +3474,11 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & MSR_TYPE_W) && kvmi_monitored_msr(vcpu, msr))
+		return;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
@@ -3539,13 +3547,14 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+						      unsigned long *msr_bitmap,
+						      u32 msr, int type, bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
 	else
-		vmx_disable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_disable_intercept_for_msr(vcpu, msr_bitmap, msr, type);
 }
 
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
@@ -3563,7 +3572,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					 unsigned long *msr_bitmap,
 					 u8 mode)
 {
 	int msr;
@@ -3579,11 +3589,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
 		 * TPR reads and writes can be virtualized even if virtual interrupt
 		 * delivery is not in use.
 		 */
-		vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
 		if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
 			vmx_enable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+			vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
+			vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		}
 	}
 }
@@ -3599,29 +3609,30 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
 
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 {
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	bool flag = !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 	u32 i;
 
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_STATUS,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
 							MSR_TYPE_RW, flag);
 	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
-		vmx_set_intercept_for_msr(msr_bitmap,
+		vmx_set_intercept_for_msr(vcpu, msr_bitmap,
 			MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
-		vmx_set_intercept_for_msr(msr_bitmap,
+		vmx_set_intercept_for_msr(vcpu, msr_bitmap,
 			MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
 	}
 }
@@ -6823,13 +6834,13 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto free_msrs;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
 	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
@@ -7790,7 +7801,7 @@ static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 
-	vmx_set_intercept_for_msr(msr_bitmap, msr, MSR_TYPE_W, enable);
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, msr, MSR_TYPE_W, enable);
 }
 
 static void vmx_cr3_write_exiting(struct kvm_vcpu *vcpu,
