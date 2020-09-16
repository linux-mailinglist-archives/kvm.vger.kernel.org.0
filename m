Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2342F26CBA4
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgIPUaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:30:39 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:49984 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgIPUab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600288229; x=1631824229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ygA4vhzxNJY8N00FtKAMjefE6UgnzFyE8IPkAY4NjM=;
  b=jQ3dfnyxfjS3u+tFxoDHh0SdUpnaq2xmdD9s7sHN0a6Xm2skXrRgUjCo
   /ZRTN4jW36Ab17PVtPt32LANhupFqOTV1WJg1RtV2YWkrMEgwBhs5d40I
   xwoN++XQA8fIgrY8C6uyYN/kQkGOrr7aKrlnofMZ9l/UJkt2531ljcgRA
   M=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="76817996"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Sep 2020 20:30:29 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id BD0C6A26D9;
        Wed, 16 Sep 2020 20:30:27 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:27 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:23 +0000
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
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 5/7] KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied
Date:   Wed, 16 Sep 2020 22:29:49 +0200
Message-ID: <20200916202951.23760-6-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200916202951.23760-1-graf@amazon.com>
References: <20200916202951.23760-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D01UWA004.ant.amazon.com (10.43.160.99) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will introduce the concept of MSRs that may not be handled in kernel
space soon. Some MSRs are directly passed through to the guest, effectively
making them handled by KVM from user space's point of view.

This patch introduces all logic required to ensure that MSRs that
user space wants trapped are not marked as direct access for guests.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v6 -> v7:

  - s/MAX_POSSIBLE_PASSGHROUGH_MSRS/MAX_POSSIBLE_PASSTHROUGH_MSRS/g
---
 arch/x86/kvm/vmx/vmx.c | 226 +++++++++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h |   7 ++
 2 files changed, 181 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3bb93da2a6f1..30b924c36914 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -149,6 +149,26 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #define MSR_IA32_RTIT_OUTPUT_BASE_MASK \
 	(~((1UL << cpuid_query_maxphyaddr(vcpu)) - 1) | 0x7f)
 
+/*
+ * List of MSRs that can be directly passed to the guest.
+ * In addition to these x2apic and PT MSRs are handled specially.
+ */
+static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
+	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_PRED_CMD,
+	MSR_IA32_TSC,
+	MSR_FS_BASE,
+	MSR_GS_BASE,
+	MSR_KERNEL_GS_BASE,
+	MSR_IA32_SYSENTER_CS,
+	MSR_IA32_SYSENTER_ESP,
+	MSR_IA32_SYSENTER_EIP,
+	MSR_CORE_C1_RES,
+	MSR_CORE_C3_RESIDENCY,
+	MSR_CORE_C6_RESIDENCY,
+	MSR_CORE_C7_RESIDENCY,
+};
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
@@ -623,6 +643,41 @@ static inline bool report_flexpriority(void)
 	return flexpriority_enabled;
 }
 
+static int possible_passthrough_msr_idx(u32 msr)
+{
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
+		if (vmx_possible_passthrough_msrs[i] == msr)
+			return i;
+
+	return -ENOENT;
+}
+
+static bool is_valid_passthrough_msr(u32 msr)
+{
+	bool r;
+
+	switch (msr) {
+	case 0x800 ... 0x8ff:
+		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
+		return true;
+	case MSR_IA32_RTIT_STATUS:
+	case MSR_IA32_RTIT_OUTPUT_BASE:
+	case MSR_IA32_RTIT_OUTPUT_MASK:
+	case MSR_IA32_RTIT_CR3_MATCH:
+	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
+		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
+		return true;
+	}
+
+	r = possible_passthrough_msr_idx(msr) != -ENOENT;
+
+	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+
+	return r;
+}
+
 static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -3660,12 +3715,51 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
+static void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
+static void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
 static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -3674,30 +3768,37 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		evmcs_touch_msr_bitmap();
 
 	/*
-	 * See Intel PRM Vol. 3, 20.6.9 (MSR-Bitmap Address). Early manuals
-	 * have the write-low and read-high bitmap offsets the wrong way round.
-	 * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
-	 */
-	if (msr <= 0x1fff) {
-		if (type & MSR_TYPE_R)
-			/* read-low */
-			__clear_bit(msr, msr_bitmap + 0x000 / f);
+	 * Mark the desired intercept state in shadow bitmap, this is needed
+	 * for resync when the MSR filters change.
+	*/
+	if (is_valid_passthrough_msr(msr)) {
+		int idx = possible_passthrough_msr_idx(msr);
+
+		if (idx != -ENOENT) {
+			if (type & MSR_TYPE_R)
+				clear_bit(idx, vmx->shadow_msr_intercept.read);
+			if (type & MSR_TYPE_W)
+				clear_bit(idx, vmx->shadow_msr_intercept.write);
+		}
+	}
 
-		if (type & MSR_TYPE_W)
-			/* write-low */
-			__clear_bit(msr, msr_bitmap + 0x800 / f);
+	if ((type & MSR_TYPE_R) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
+		vmx_set_msr_bitmap_read(msr_bitmap, msr);
+		type &= ~MSR_TYPE_R;
+	}
 
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		if (type & MSR_TYPE_R)
-			/* read-high */
-			__clear_bit(msr, msr_bitmap + 0x400 / f);
+	if ((type & MSR_TYPE_W) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
+		vmx_set_msr_bitmap_write(msr_bitmap, msr);
+		type &= ~MSR_TYPE_W;
+	}
 
-		if (type & MSR_TYPE_W)
-			/* write-high */
-			__clear_bit(msr, msr_bitmap + 0xc00 / f);
+	if (type & MSR_TYPE_R)
+		vmx_clear_msr_bitmap_read(msr_bitmap, msr);
 
-	}
+	if (type & MSR_TYPE_W)
+		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
 }
 
 static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
@@ -3705,7 +3806,6 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -3714,30 +3814,25 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		evmcs_touch_msr_bitmap();
 
 	/*
-	 * See Intel PRM Vol. 3, 20.6.9 (MSR-Bitmap Address). Early manuals
-	 * have the write-low and read-high bitmap offsets the wrong way round.
-	 * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
-	 */
-	if (msr <= 0x1fff) {
-		if (type & MSR_TYPE_R)
-			/* read-low */
-			__set_bit(msr, msr_bitmap + 0x000 / f);
-
-		if (type & MSR_TYPE_W)
-			/* write-low */
-			__set_bit(msr, msr_bitmap + 0x800 / f);
-
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		if (type & MSR_TYPE_R)
-			/* read-high */
-			__set_bit(msr, msr_bitmap + 0x400 / f);
+	 * Mark the desired intercept state in shadow bitmap, this is needed
+	 * for resync when the MSR filter changes.
+	*/
+	if (is_valid_passthrough_msr(msr)) {
+		int idx = possible_passthrough_msr_idx(msr);
+
+		if (idx != -ENOENT) {
+			if (type & MSR_TYPE_R)
+				set_bit(idx, vmx->shadow_msr_intercept.read);
+			if (type & MSR_TYPE_W)
+				set_bit(idx, vmx->shadow_msr_intercept.write);
+		}
+	}
 
-		if (type & MSR_TYPE_W)
-			/* write-high */
-			__set_bit(msr, msr_bitmap + 0xc00 / f);
+	if (type & MSR_TYPE_R)
+		vmx_set_msr_bitmap_read(msr_bitmap, msr);
 
-	}
+	if (type & MSR_TYPE_W)
+		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
 static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
@@ -3764,15 +3859,14 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
-					 unsigned long *msr_bitmap, u8 mode)
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
 {
 	int msr;
 
-	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
-		unsigned word = msr / BITS_PER_LONG;
-		msr_bitmap[word] = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
-		msr_bitmap[word + (0x800 / sizeof(long))] = ~0;
+	for (msr = 0x800; msr <= 0x8ff; msr++) {
+		bool intercepted = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
+
+		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_RW, intercepted);
 	}
 
 	if (mode & MSR_BITMAP_MODE_X2APIC) {
@@ -3792,7 +3886,6 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	u8 mode = vmx_msr_bitmap_mode(vcpu);
 	u8 changed = mode ^ vmx->msr_bitmap_mode;
 
@@ -3800,7 +3893,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
@@ -3841,6 +3934,29 @@ static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
 
+static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 i;
+
+	/*
+	 * Set intercept permissions for all potentially passed through MSRs
+	 * again. They will automatically get filtered through the MSR filter,
+	 * so we are back in sync after this.
+	 */
+	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
+		u32 msr = vmx_possible_passthrough_msrs[i];
+		bool read = test_bit(i, vmx->shadow_msr_intercept.read);
+		bool write = test_bit(i, vmx->shadow_msr_intercept.write);
+
+		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, read);
+		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, write);
+	}
+
+	pt_update_intercept_for_msr(vcpu);
+	vmx_update_msr_bitmap_x2apic(vcpu, vmx_msr_bitmap_mode(vcpu));
+}
+
 static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     bool nested)
 {
@@ -6882,6 +6998,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err < 0)
 		goto free_pml;
 
+	/* The MSR bitmap starts with all ones */
+	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
+	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
+
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
 	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
@@ -7907,6 +8027,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+
+	.msr_filter_changed = vmx_msr_filter_changed,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c964358b2fb0..cc49506c9351 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -301,6 +301,13 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+
+	/* Save desired MSR intercept (read: pass-through) state */
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
+	struct {
+		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
+		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
+	} shadow_msr_intercept;
 };
 
 enum ept_pointers_status {
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



