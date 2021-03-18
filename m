Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C206534107B
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 23:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhCRWn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 18:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhCRWnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 18:43:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37866C06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 15:43:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 127so50046110ybc.19
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1L+9lJpNp7J82u8N+nWZfaJrNB467GIkhUgouUBgX1A=;
        b=Ns4hn+Cm38G8KktGdmCcDEaDZhKu9bZZgQazz7PyEoR+V0VC0jn/T4UDFfOv0jp6cK
         HKTUehDXiabOIJEmov51KsVzGhfp2GKVr9zO7Gh12AeCKXtaqHYirkfljTEqjNjFY1EB
         lQorNY8gkhM135aIIyWOE1zq3YzkZo3i79CNPyyCPoQrTc09WZ5he3RHFGWiwY6xLqw/
         5TyfbMXEmatfms8d2T8yLBs/L1QkqPjCIMy+I1qSa7uQgtAWmEFUQmGGS7LV2N1Wu6M4
         XtSDl3piXlaiss6qL2n0zIgMgcmjHfoSXQZJ/RozpsW4MWFp88oPn8NLesQBoVabmk8O
         BEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1L+9lJpNp7J82u8N+nWZfaJrNB467GIkhUgouUBgX1A=;
        b=jgOctqts3PKfwJ/GGim+koToNn//sxDSedKL24URhqGXj5VEWp0aUJkM9g5NTMKrmc
         6Qah9k3HUh02o8VVfUP2d/2dgNZbnWTM9c+KfsMlOiQuqtx0aaQ131nb4nt7nuw5B6Ge
         L5dbrSggwMBt4ncpN/cFFxO2+VjNTIFIjXKmBQOdJNdofoYhzQSaON+EnHNMC96INu1K
         32Ku6Nju9n5aO2qwvPAOg5ydKbnhi1qDnQwXz3Z0jBO2IAn53xn8FQ+lI9GQxL/iXGYt
         n1O8ClKr8B60cAooAVcPwIMeJzHUp6hhwH2taI33SRaqQgick6JtyTOboIdO++BDR75t
         dgHQ==
X-Gm-Message-State: AOAM530jIVw1ldfoMX0iDznvr/Aag/bX7v01l3ZOE81GFbsqWjZFpj2X
        tHX/I/c+la88LDYRPYXs1/Uey4dD+qI=
X-Google-Smtp-Source: ABdhPJwwTJRd0BuDJ+GgYU89A4UQxSdfhSeDOq9f7SOu95IyLgNBPSJ3LyU+VylpQ/EPLpXHWDXsGv+QqoE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:25e0:6b8b:f878:23d1])
 (user=seanjc job=sendgmr) by 2002:a25:accd:: with SMTP id x13mr2417534ybd.88.1616107402509;
 Thu, 18 Mar 2021 15:43:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 18 Mar 2021 15:43:10 -0700
In-Reply-To: <20210318224310.3274160-1-seanjc@google.com>
Message-Id: <20210318224310.3274160-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210318224310.3274160-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 4/4] KVM: nVMX: Clean up x2APIC MSR handling for L2
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

Clean up the x2APIC MSR bitmap intereption code for L2, which is the last
holdout of open coded bitmap manipulations.  Freshen up the SDM/PRM
comment, rename the function to make it abundantly clear the funky
behavior is x2APIC specific, and explain _why_ vmcs01's bitmap is ignored
(the previous comment was flat out wrong for x2APIC behavior).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 53 +++++++++++----------------------------
 arch/x86/kvm/vmx/vmx.h    |  8 ++++++
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aff41a432a56..49eeffb79823 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -476,44 +476,19 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 }
 
 /*
- * If a msr is allowed by L0, we should check whether it is allowed by L1.
- * The corresponding bit will be cleared unless both of L0 and L1 allow it.
+ * For x2APIC MSRs, ignore the vmcs01 bitmap.  L1 can enable x2APIC without L1
+ * itself utilizing x2APIC.  All MSRs were previously set to be intercepted,
+ * only the disable intercept case needs to be handled.
  */
-static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
-					       unsigned long *msr_bitmap_nested,
-					       u32 msr, int type)
+static void nested_vmx_disable_intercept_for_x2apic_msr(unsigned long *msr_bitmap_l1,
+							unsigned long *msr_bitmap_l0,
+							u32 msr, int type)
 {
-	int f = sizeof(unsigned long);
+	if (type & MSR_TYPE_R && !vmx_test_msr_bitmap_read(msr_bitmap_l1, msr))
+		vmx_clear_msr_bitmap_read(msr_bitmap_l0, msr);
 
-	/*
-	 * See Intel PRM Vol. 3, 20.6.9 (MSR-Bitmap Address). Early manuals
-	 * have the write-low and read-high bitmap offsets the wrong way round.
-	 * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
-	 */
-	if (msr <= 0x1fff) {
-		if (type & MSR_TYPE_R &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x000 / f))
-			/* read-low */
-			__clear_bit(msr, msr_bitmap_nested + 0x000 / f);
-
-		if (type & MSR_TYPE_W &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x800 / f))
-			/* write-low */
-			__clear_bit(msr, msr_bitmap_nested + 0x800 / f);
-
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		if (type & MSR_TYPE_R &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x400 / f))
-			/* read-high */
-			__clear_bit(msr, msr_bitmap_nested + 0x400 / f);
-
-		if (type & MSR_TYPE_W &&
-		   !test_bit(msr, msr_bitmap_l1 + 0xc00 / f))
-			/* write-high */
-			__clear_bit(msr, msr_bitmap_nested + 0xc00 / f);
-
-	}
+	if (type & MSR_TYPE_W && !vmx_test_msr_bitmap_write(msr_bitmap_l1, msr))
+		vmx_clear_msr_bitmap_write(msr_bitmap_l0, msr);
 }
 
 static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
@@ -582,7 +557,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
 	 * 4-byte writes on 32-bit systems) up front to enable intercepts for
-	 * the x2APIC MSR range and selectively disable them below.
+	 * the x2APIC MSR range and selectively toggle those relevant to L2.
 	 */
 	enable_x2apic_msr_intercepts(msr_bitmap_l0);
 
@@ -601,17 +576,17 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			}
 		}
 
-		nested_vmx_disable_intercept_for_msr(
+		nested_vmx_disable_intercept_for_x2apic_msr(
 			msr_bitmap_l1, msr_bitmap_l0,
 			X2APIC_MSR(APIC_TASKPRI),
 			MSR_TYPE_R | MSR_TYPE_W);
 
 		if (nested_cpu_has_vid(vmcs12)) {
-			nested_vmx_disable_intercept_for_msr(
+			nested_vmx_disable_intercept_for_x2apic_msr(
 				msr_bitmap_l1, msr_bitmap_l0,
 				X2APIC_MSR(APIC_EOI),
 				MSR_TYPE_W);
-			nested_vmx_disable_intercept_for_msr(
+			nested_vmx_disable_intercept_for_x2apic_msr(
 				msr_bitmap_l1, msr_bitmap_l0,
 				X2APIC_MSR(APIC_SELF_IPI),
 				MSR_TYPE_W);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 42c25fc79427..03ab9ccd95d2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -393,6 +393,14 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 	u32 msr, int type, bool value);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+/*
+ * Note, early Intel manuals have the write-low and read-high bitmap offsets
+ * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
+ * 0xc0000000-0xc0001fff.  The former (low) uses bytes 0-0x3ff for reads and
+ * 0x800-0xbff for writes.  The latter (high) uses 0x400-0x7ff for reads and
+ * 0xc00-0xfff for writes.  MSRs not covered by either of the ranges always
+ * VM-Exit.
+ */
 #define __BUILD_VMX_MSR_BITMAP_HELPER(rtype, action, bitop, access, base)      \
 static inline rtype vmx_##action##_msr_bitmap_##access(unsigned long *bitmap,  \
 						       u32 msr)		       \
-- 
2.31.0.rc2.261.g7f71774620-goog

