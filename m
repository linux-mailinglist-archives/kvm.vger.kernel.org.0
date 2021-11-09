Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D944A41E
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 02:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhKIBnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 20:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238968AbhKIBnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 20:43:11 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB7C07926F
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 17:30:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id s16-20020a170902ea1000b00142728c2ccaso1837894plg.23
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 17:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gOvGMnXuFeZeVFJuPsZjNY0E3NePmmX+xqil6qC9rlg=;
        b=Bd5wCuWC0y1awkeI0pxl9iJ8boOnKS1JHVmG+qcT9tWNguxmEe5uokCB5i4zTgc/Vo
         OfqK5cAGIWhk6HImZiackSHaEuu6Z7xHHRiCK5x80LzYaTd/kZpHKnWQvsMP6tW0KUWA
         oN5CAcT3QYH9CQOj2hytdNU61ozVjaUADM23s2oFdy94QyydxZ+lajsCq9O3Ufw9GSjN
         HUHnBH58j4c2Xlwe8ZcWykaMUt65GHdMBvJNc7nmxuvqFE/ySJgiJnmKLlkZPkrBgu4Z
         /UWA8nr7IxOvpHtfWjicVWrfNdnSrDBWkz2sTRW8UJ/kLCqlAamtZWg+Tu52EUqGPG4x
         RYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gOvGMnXuFeZeVFJuPsZjNY0E3NePmmX+xqil6qC9rlg=;
        b=gGVaVestdVw09KfO/Ul0BzIS2ovS6G93lHO1fkheujWoRM2k1FFybCgBZLFnvnLKKD
         d/MpbhFbjZWdhq+F2nw3M9CZhEjje14jwXIfYflUNYhT3nHrXubtnAU+s7RTvuNgC6br
         zbU/YGFDA4XLCr3Qtza6U9OYedQ1GS0nbxhHMs/n+pXas3dFowUZ9z2Lz7xuFKHmbWsR
         X1oW938YYIhMkxQ2lihpJ5qEy3L3Lr+5iPVnmW1BP15B2GCBPD627ME48lez+6yRRaa0
         2lKdR8AQo7H9h7sZY9AJ3cesikBujNgYCd4ZejC2+BOR4JV8iCAWKgUvmWZdAumCcgAY
         lf7Q==
X-Gm-Message-State: AOAM530LFe5AYCnn373T7Apz6gV2hUlTMFVlRNTidajgeYDApBBn+Yko
        9puzIWX7iXJV4FXlPBh2G3rUdzmUWjg=
X-Google-Smtp-Source: ABdhPJzuUrqEB8QiFmmAqMxChcMtGsArsvKxU9JU1zecTriXtX5voSrZRARBjphwgkZAf4Wq6LOco3smazw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:18b:b0:142:12ba:8513 with SMTP id
 z11-20020a170903018b00b0014212ba8513mr3151725plg.69.1636421456909; Mon, 08
 Nov 2021 17:30:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 01:30:47 +0000
In-Reply-To: <20211109013047.2041518-1-seanjc@google.com>
Message-Id: <20211109013047.2041518-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211109013047.2041518-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 4/4] KVM: nVMX: Clean up x2APIC MSR handling for L2
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>
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
index c569a135ca48..341c50816822 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -525,44 +525,19 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 }
 
 /*
- * If a msr is allowed by L0, we should check whether it is allowed by L1.
- * The corresponding bit will be cleared unless both of L0 and L1 allow it.
+ * For x2APIC MSRs, ignore the vmcs01 bitmap.  L1 can enable x2APIC without L1
+ * itself utilizing x2APIC.  All MSRs were previously set to be intercepted,
+ * only the "disable intercept" case needs to be handled.
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
@@ -631,7 +606,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
 	 * 4-byte writes on 32-bit systems) up front to enable intercepts for
-	 * the x2APIC MSR range and selectively disable them below.
+	 * the x2APIC MSR range and selectively toggle those relevant to L2.
 	 */
 	enable_x2apic_msr_intercepts(msr_bitmap_l0);
 
@@ -650,17 +625,17 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
index 83a14b61c80f..86c093da0d63 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -400,6 +400,14 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
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
2.34.0.rc0.344.g81b53c2807-goog

