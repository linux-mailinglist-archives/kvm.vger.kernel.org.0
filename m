Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6687F26CBAD
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgIPUcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:32:15 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:48584 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgIPUaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600288217; x=1631824217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dC9uTuBVNiZrYB4xHbeu12uZna+XfeantXSy8jjcnsg=;
  b=LDuSZJM8yPw6alPIPctrml4aG7HBv8ZPz/hK38h8pZYcZzrjEJ7q6RIx
   O47ameA/Ornxa0xthoXwAvA0C68MMECkXaFdHiE7ZZOIQM0eqc+Tqe55E
   5KGB+Tfp8o767nfvoieVJH7ribKaEdlloDtdEfwD+DFxcq+TYnPRbqEYS
   c=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="54452058"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Sep 2020 20:30:15 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 66B38A1DF2;
        Wed, 16 Sep 2020 20:30:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:13 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.35) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:09 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v7 3/7] KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
Date:   Wed, 16 Sep 2020 22:29:47 +0200
Message-ID: <20200916202951.23760-4-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200916202951.23760-1-graf@amazon.com>
References: <20200916202951.23760-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D42UWA002.ant.amazon.com (10.43.160.16) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Prepare vmx and svm for a subsequent change that ensures the MSR permission
bitmap is set to allow an MSR that userspace is tracking to force a vmx_vmexit
in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
[agraf: rebase, adapt SVM scheme to nested changes that came in between]
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/svm/svm.c    | 60 ++++++++++++++++------------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 83 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 4 files changed, 77 insertions(+), 70 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3da5b2f1b4a1..41aaee666751 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -564,7 +564,7 @@ static bool valid_msr_intercept(u32 index)
 	return false;
 }
 
-static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
+static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
 	unsigned long tmp;
@@ -583,7 +583,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(u32 *msrpm, unsigned msr,
+static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 				 int read, int write)
 {
 	u8 bit_read, bit_write;
@@ -609,11 +609,10 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static u32 *svm_vcpu_init_msrpm(void)
+static u32 *svm_vcpu_alloc_msrpm(void)
 {
-	int i;
-	u32 *msrpm;
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
+	u32 *msrpm;
 
 	if (!pages)
 		return NULL;
@@ -621,12 +620,18 @@ static u32 *svm_vcpu_init_msrpm(void)
 	msrpm = page_address(pages);
 	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
 
+	return msrpm;
+}
+
+static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
+{
+	int i;
+
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
 	}
-	return msrpm;
 }
 
 static void svm_vcpu_free_msrpm(u32 *msrpm)
@@ -677,26 +682,26 @@ static void init_msrpm_offsets(void)
 	}
 }
 
-static void svm_enable_lbrv(struct vcpu_svm *svm)
+static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	u32 *msrpm = svm->msrpm;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
-static void svm_disable_lbrv(struct vcpu_svm *svm)
+static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
-	u32 *msrpm = svm->msrpm;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
 }
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -1230,14 +1235,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->nested.hsave = page_address(hsave_page);
 
-	svm->msrpm = svm_vcpu_init_msrpm();
+	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm)
 		goto error_free_hsave_page;
 
-	svm->nested.msrpm = svm_vcpu_init_msrpm();
+	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+
+	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->nested.msrpm)
 		goto error_free_msrpm;
 
+	/* We only need the L1 pass-through MSR state, so leave vcpu as NULL */
+	svm_vcpu_init_msrpm(vcpu, svm->nested.msrpm);
+
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
 	svm->asid_generation = 0;
@@ -2572,7 +2582,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -2587,7 +2597,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -2651,9 +2661,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb->save.dbgctl = data;
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		if (data & (1ULL<<0))
-			svm_enable_lbrv(svm);
+			svm_enable_lbrv(vcpu);
 		else
-			svm_disable_lbrv(svm);
+			svm_disable_lbrv(vcpu);
 		break;
 	case MSR_VM_HSAVE_PA:
 		svm->nested.hsave_msr = data;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6ce9ce91029..d1cec5d71b34 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4760,7 +4760,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 
 	if (vmx_pt_mode_is_host_guest()) {
 		vmx->pt_desc.guest.ctl = 0;
-		pt_update_intercept_for_msr(vmx);
+		pt_update_intercept_for_msr(vcpu);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc5..3bb93da2a6f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -343,7 +343,7 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type);
 
 void vmx_vmexit(void);
@@ -2055,7 +2055,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
@@ -2091,8 +2091,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
-					      MSR_TYPE_W);
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
@@ -2142,7 +2141,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, data);
 		vmx->pt_desc.guest.ctl = data;
-		pt_update_intercept_for_msr(vmx);
+		pt_update_intercept_for_msr(vcpu);
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (!pt_can_write_msr(vmx))
@@ -3661,9 +3660,11 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
@@ -3699,9 +3700,11 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 	}
 }
 
-static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							 u32 msr, int type)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
@@ -3737,13 +3740,13 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+						      u32 msr, int type, bool value)
 {
 	if (value)
-		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_enable_intercept_for_msr(vcpu, msr, type);
 	else
-		vmx_disable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_disable_intercept_for_msr(vcpu, msr, type);
 }
 
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
@@ -3761,8 +3764,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
-					 u8 mode)
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					 unsigned long *msr_bitmap, u8 mode)
 {
 	int msr;
 
@@ -3777,11 +3780,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
 		 * TPR reads and writes can be virtualized even if virtual interrupt
 		 * delivery is not in use.
 		 */
-		vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
 		if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-			vmx_enable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+			vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		}
 	}
 }
@@ -3797,30 +3800,24 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
 
-void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
+void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 {
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool flag = !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 	u32 i;
 
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
-							MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_STATUS, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_BASE, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_MASK, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_CR3_MATCH, MSR_TYPE_RW, flag);
 	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
-		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
-		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
 	}
 }
 
@@ -6886,18 +6883,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		goto free_pml;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
 	if (kvm_cstate_in_guest(vcpu->kvm)) {
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
 	vmx->msr_bitmap_mode = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d7ec66db5eb8..c964358b2fb0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,7 +351,7 @@ bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
-void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
+void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



