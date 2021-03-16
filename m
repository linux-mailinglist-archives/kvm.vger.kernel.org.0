Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5988B33DCC3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbhCPSpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbhCPSow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:44:52 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBABFC061763
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:50 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h126so27456504qkd.4
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lGajVs0kXZYHmUj9xW2LMSeGkPza7CDc5dRmihYG7X4=;
        b=l4YLqfWDvsXm4rhOWomSGUjGsV5NrTiAp9p7Klnq11lzkA+O024uApvFUBowiId3gL
         2yThoALdBZX+eM37UbAJP+T7ml8aa0THvQPvy6UynjymLUX5tgs4EIQ32su/u4h98OXd
         RvU/+B+WShuKe7dyQVct1DG6a+wONvmT/ZUqOcdbj1MjUNcVMyMZDX06UW2NdXkC8MXh
         LrCHYpXPYxhitw4X8u/IPUQa1brKP6NuUzoi7YL3zfUwqzCbrxQRh6tdr5N8MQTeRrj3
         BuNA0rWTpUI3ZkgDJrOMy3JUhZ8BXz7qwqMpXhQNthv8+DLQQscXZKjSlWk1RMqTncqJ
         +p1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lGajVs0kXZYHmUj9xW2LMSeGkPza7CDc5dRmihYG7X4=;
        b=h4J3r1sWzH6V+wXNlUZYKyShnUTwRbOLddv2IiXbAJ1/HJQAFlvSST0vdgY6SKKHfq
         aspBBfpnCH2GYLzCYPa5GbLRATH1R046Ljsy31zVEKtNp8A8l6siuDWmMeACnecRZPHW
         Vmm2DSuldE5jimRFCL994j8iymFZOsZeR7b3iVd8mMlCySbjNBvlXNAO9+jBuX/5X03B
         bP2ye6CEq1yRbn8Yb0+7yekpmdJF5ueTcAe8+hFBAh6JOaI+nRAA3LYGbgMn2VY5myF9
         qG2TclaKjRKIGpnQOUcuDQ1B63yDVVEvJKOJyw1WDQeHZFJl1pdWAZpQ+qXGL6BnAlL8
         xgFQ==
X-Gm-Message-State: AOAM533lX2XW1IE9/TlqXmI1i4KE3fchT1Pqaly18wqi36PwFbD1ySEz
        iALdJ+Eh/R86yIVtooJIt90KjhIgf7A=
X-Google-Smtp-Source: ABdhPJx+wiN33KpTaKPbZwCafpONS37r19xosvARW3U9whqEJfZdA745iK6EAzy7UJ5PKO/bpqrvjHTYjes=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
 (user=seanjc job=sendgmr) by 2002:a0c:bd2f:: with SMTP id m47mr1156375qvg.53.1615920290037;
 Tue, 16 Mar 2021 11:44:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Mar 2021 11:44:34 -0700
In-Reply-To: <20210316184436.2544875-1-seanjc@google.com>
Message-Id: <20210316184436.2544875-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210316184436.2544875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 2/4] KVM: nVMX: Handle dynamic MSR intercept toggling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always check vmcs01's MSR bitmap when merging L0 and L1 bitmaps for L2,
and always update the relevant bits in vmcs02.  This fixes two distinct,
but intertwined bugs related to dynamic MSR bitmap modifications.

The first issue is that KVM fails to enable MSR interception in vmcs02
for the FS/GS base MSRs if L1 first runs L2 with interception disabled,
and later enables interception.

The second issue is that KVM fails to honor userspace MSR filtering when
preparing vmcs02.

Fix both issues simultaneous as fixing only one of the issues (doesn't
matter which) would create a mess that no one should have to bisect.
Fixing only the first bug would exacerbate the MSR filtering issue as
userspace would see inconsistent behavior depending on the whims of L1.
Fixing only the second bug (MSR filtering) effectively requires fixing
the first, as the nVMX code only knows how to transition vmcs02's
bitmap from 1->0.

Move the various accessor/mutators buried in vmx.c into vmx.h so that
they can be shared by the nested code.

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Fixes: d69129b4e46a ("KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible")
Cc: stable@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 108 +++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.c    |  67 ++---------------------
 arch/x86/kvm/vmx/vmx.h    |  63 ++++++++++++++++++++++
 3 files changed, 115 insertions(+), 123 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd334e4aa6db..aff41a432a56 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -475,29 +475,6 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/*
- * Check if MSR is intercepted for L01 MSR bitmap.
- */
-static bool msr_write_intercepted_l01(struct kvm_vcpu *vcpu, u32 msr)
-{
-	unsigned long *msr_bitmap;
-	int f = sizeof(unsigned long);
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return true;
-
-	msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
-
-	if (msr <= 0x1fff) {
-		return !!test_bit(msr, msr_bitmap + 0x800 / f);
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
-	}
-
-	return true;
-}
-
 /*
  * If a msr is allowed by L0, we should check whether it is allowed by L1.
  * The corresponding bit will be cleared unless both of L0 and L1 allow it.
@@ -551,6 +528,34 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 	}
 }
 
+#define BUILD_NVMX_MSR_INTERCEPT_HELPER(rw)					\
+static inline									\
+void nested_vmx_set_msr_##rw##_intercept(struct vcpu_vmx *vmx,			\
+					 unsigned long *msr_bitmap_l1,		\
+					 unsigned long *msr_bitmap_l0, u32 msr)	\
+{										\
+	if (vmx_test_msr_bitmap_##rw(vmx->vmcs01.msr_bitmap, msr) ||		\
+	    vmx_test_msr_bitmap_##rw(msr_bitmap_l1, msr))			\
+		vmx_set_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
+	else									\
+		vmx_clear_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
+}
+BUILD_NVMX_MSR_INTERCEPT_HELPER(read)
+BUILD_NVMX_MSR_INTERCEPT_HELPER(write)
+
+static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
+						    unsigned long *msr_bitmap_l1,
+						    unsigned long *msr_bitmap_l0,
+						    u32 msr, int types)
+{
+	if (types & MSR_TYPE_R)
+		nested_vmx_set_msr_read_intercept(vmx, msr_bitmap_l1,
+						  msr_bitmap_l0, msr);
+	if (types & MSR_TYPE_W)
+		nested_vmx_set_msr_write_intercept(vmx, msr_bitmap_l1,
+						   msr_bitmap_l0, msr);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -558,10 +563,11 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int msr;
 	unsigned long *msr_bitmap_l1;
-	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
+	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
+	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -612,42 +618,26 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_FS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_GS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-
 	/*
-	 * Checking the L0->L1 bitmap is trying to verify two things:
-	 *
-	 * 1. L0 gave a permission to L1 to actually passthrough the MSR. This
-	 *    ensures that we do not accidentally generate an L02 MSR bitmap
-	 *    from the L12 MSR bitmap that is too permissive.
-	 * 2. That L1 or L2s have actually used the MSR. This avoids
-	 *    unnecessarily merging of the bitmap if the MSR is unused. This
-	 *    works properly because we only update the L01 MSR bitmap lazily.
-	 *    So even if L0 should pass L1 these MSRs, the L01 bitmap is only
-	 *    updated to reflect this when L1 (or its L2s) actually write to
-	 *    the MSR.
+	 * Always check vmcs01's bitmap to honor userspace MSR filters and any
+	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
 	 */
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_SPEC_CTRL,
-					MSR_TYPE_R | MSR_TYPE_W);
-
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_PRED_CMD,
-					MSR_TYPE_W);
-
-	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_FS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_GS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
+
+	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	return true;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8a4a548e96b..9972e5d1c44e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -879,29 +879,6 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
 
-/*
- * Check if MSR is intercepted for currently loaded MSR bitmap.
- */
-static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
-{
-	unsigned long *msr_bitmap;
-	int f = sizeof(unsigned long);
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return true;
-
-	msr_bitmap = to_vmx(vcpu)->loaded_vmcs->msr_bitmap;
-
-	if (msr <= 0x1fff) {
-		return !!test_bit(msr, msr_bitmap + 0x800 / f);
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
-	}
-
-	return true;
-}
-
 static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
@@ -3709,46 +3686,6 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-}
-
-static void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-}
-
 static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
@@ -6722,7 +6659,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (unlikely(cpu_has_vmx_msr_bitmap() &&
+		     vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
+					       MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0fb3236b0283..a6000c91b897 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -393,6 +393,69 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 	u32 msr, int type, bool value);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+static inline bool vmx_test_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		return test_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		return test_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+	return true;
+}
+
+static inline bool vmx_test_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		return test_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		return test_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+	return true;
+}
+
+static inline void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static inline void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
+static inline void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static inline void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
+
 static inline u8 vmx_get_rvi(void)
 {
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
-- 
2.31.0.rc2.261.g7f71774620-goog

