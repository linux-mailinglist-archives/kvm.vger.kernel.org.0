Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F88417C85
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 22:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348458AbhIXUu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 16:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346038AbhIXUuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 16:50:50 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D1C06161E
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:49:17 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id bm12-20020a05620a198c00b00432e14ddb99so40182961qkb.21
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cDsL24c7rwVQ963btj/13XS20KNdv5/SFxypjU/Ga9Q=;
        b=g6aWDZhHqscrv2TWNNDwPGZiUSFXGvIElYpPphAC4mZbQGhGzbZ1FZV7oK0Okkm6sJ
         ABRQvkmwiawNiWDk4iJ1Vu7DwzmcoMF5LhgnivBI6MX43cDIluiYYw0Z/ZZqBfr7Ns02
         jofrY9SIcDKgKhbT/Ap46cuvDtqSrCsXGSXTj7sNEmpyYyX6AXrqmJKxXlR5nJZv4ojH
         LEE21alJG6f/z61bErFl4AAvlUEQoO4puZgVNqdQxntTA0l6ip37qPwEwNDKcuBr3tab
         rMzII9HIGDOaESlcZ+W3W1PttKiboZvW0qOGjtYvqV1NJKTenuSUnZwspSDLhvbmT/mk
         xVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cDsL24c7rwVQ963btj/13XS20KNdv5/SFxypjU/Ga9Q=;
        b=76uqEk4Yme+wtV3boXYA3Q21TN+pVoE9Wp+qer/HFU9kljccYrT89GRjVc9mMqNPan
         K4WizASYL87m/HI1LVntlOMKj3y6WiPjLRcCZ45iY8N2khrNRMmp+W29nCWBP+S0gGjF
         m6XpRrIJGTl7fwRHOmcfe7h1hVle2/dOeXUBmGc7QNX6sZDZx9g/nbkmW2+fqkdcXX+k
         N0QFk46LWjL9lScB7m5RjiPU55tcWd0VggKDfwnVu1QUVrpu/EOGYi5ciLRpOI+7sEis
         hDKt7GrGMh4SgZ5MbOywAjfxrX/sk3YkaMSaS+ikt011fxPrCJ+uQGYMQZd17wdOpbqI
         N09A==
X-Gm-Message-State: AOAM532wKqqBvSxRSB8Ot7KE4ioIMeCbxMAqOvoVrExFcVSkZn/trhFl
        dsxvAxXWhNfa6qQHaAnyk1H1PqU9AIE=
X-Google-Smtp-Source: ABdhPJxoVGA1B/SHrgcXT2PW/5X/l7/skLXk3PNkSWZaNMb7spVQ9vwhd/RIYM9If1UPMW/CzjUiHJRK1IY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:54f:: with SMTP id
 ci15mr12055800qvb.29.1632516556236; Fri, 24 Sep 2021 13:49:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 13:49:07 -0700
In-Reply-To: <20210924204907.1111817-1-seanjc@google.com>
Message-Id: <20210924204907.1111817-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210924204907.1111817-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 3/3] KVM: nVMX: Clean up x2APIC MSR handling for L2
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
index 3c9657f6923e..57af4984774e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -524,44 +524,19 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
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
@@ -630,7 +605,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
 	 * 4-byte writes on 32-bit systems) up front to enable intercepts for
-	 * the x2APIC MSR range and selectively disable them below.
+	 * the x2APIC MSR range and selectively toggle those relevant to L2.
 	 */
 	enable_x2apic_msr_intercepts(msr_bitmap_l0);
 
@@ -649,17 +624,17 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
index c5735aa8b32c..5489ee9268ee 100644
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
2.33.0.685.g46640cef36-goog

