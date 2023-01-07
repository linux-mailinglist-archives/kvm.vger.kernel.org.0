Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01064660B61
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbjAGBRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbjAGBRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:17:47 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB1F3727D
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:17:43 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id s14-20020a17090302ce00b00192d831a155so2246809plk.11
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qO8mfhsVSPdL0T8eFEvGtRbjwTJsBRQylFIVnEAzo5U=;
        b=ZQHvMSnq45ADnfSSFjVX29v2zZktAJGGMshYAevgX2+TW2R2fOdXHEGcdjq5QLSuBm
         uNBWi0YCc9UHIwddvxqoYqGUXRsN3Sf/Y8c0JzPB3jwylTfm2H9pFR/BL/rhutuRw0be
         kcMV5YgdyIOpFpceVn9NNjiHFSHD3s46tmz5B7neqppI4atv9gR5MfJxk7yU/HfCyOKz
         ha74g+YE44erXcPcE9WEKFpXB8nyL4vGWTzkt2zTWGwu8kMBWHBtvZ3nmrxoQjLq3A32
         DtFnEJ8tVO3jiI7Ym2oW6c6TJpjFqqwforTei/ui/WLMez4pnZdKCC3WpcIXZxkK9b5q
         eHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qO8mfhsVSPdL0T8eFEvGtRbjwTJsBRQylFIVnEAzo5U=;
        b=N9VKpVW1YMhDeJxXvovJxwyy16zkF7Xgl+h8+zg176UxGCpU9r3QuFVA3a6y610mJG
         yPdoyHDtSCiNhTKkucpwH8TrAvsYR3rugGiFnZba6kn+H/PfIhaLuEQyAdWWphVlEmk1
         ivT2w28Xyg/RBq+aqXeuCsRXcrifit5kyDd9x5e1r1tChYHI5vxRXdh+hYRTsP3qVYCU
         dalddB+nFG2INGVRVxrz/xT6odQJmrHT+eKW8BLlKSfXYdbL+gXphooEhYTWFLoIKm8X
         FPN1ZIhAwH79RKPm/rAPtfsMuwUPt92nGUxY32Ef38AqnY/8jqaMmvmxiRtztilf4mNX
         kDCg==
X-Gm-Message-State: AFqh2kp43Vra6uyxOGwaOF+Fbn0aKUdWIC+QTqahcn5rcHqZM/8QtLYf
        R2kjh1HHz+/nmNryLq+bTfMudyNsps4=
X-Google-Smtp-Source: AMrXdXv0W1d41lKbSU9q43HImDECcCGWzyawhWGMQQcL0K1r6+lDAT0utSBaF/xN9ETEkctBA9WbeCeRQ8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a589:b0:17c:9a37:72fb with SMTP id
 az9-20020a170902a58900b0017c9a3772fbmr3497461plb.82.1673054263045; Fri, 06
 Jan 2023 17:17:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:17:36 +0000
In-Reply-To: <20230107011737.577244-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011737.577244-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011737.577244-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86/apic: Refactor x2APIC reg helper to
 provide exact semantics
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor x2apic_reg_reserved() into get_x2apic_reg_semantics() and have
it provide the semantics for all registers.  The full semantics will be
used by the MSR test to verify KVM correctly emulates all x2APIC MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.h  | 59 ++++++++++++++++++++++++++++++++++++++-----------
 x86/vmx_tests.c |  6 ++---
 2 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 6d27f047..023dff0d 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -1,6 +1,7 @@
 #ifndef _X86_APIC_H_
 #define _X86_APIC_H_
 
+#include <bitops.h>
 #include <stdint.h>
 #include "apic-defs.h"
 
@@ -74,24 +75,56 @@ static inline bool apic_lvt_entry_supported(int idx)
 	return GET_APIC_MAXLVT(apic_read(APIC_LVR)) >= idx;
 }
 
-static inline bool x2apic_reg_reserved(u32 reg)
+enum x2apic_reg_semantics {
+	X2APIC_INVALID	= 0,
+	X2APIC_READABLE	= BIT(0),
+	X2APIC_WRITABLE	= BIT(1),
+	X2APIC_RO	= X2APIC_READABLE,
+	X2APIC_WO	= X2APIC_WRITABLE,
+	X2APIC_RW	= X2APIC_READABLE | X2APIC_WRITABLE,
+};
+
+static inline enum x2apic_reg_semantics get_x2apic_reg_semantics(u32 reg)
 {
+	assert(!(reg & 0xf));
+
 	switch (reg) {
-	case 0x000 ... 0x010:
-	case 0x040 ... 0x070:
-	case 0x090:
-	case 0x0c0:
-	case 0x0e0:
-	case 0x290 ... 0x2e0:
-	case 0x310:
-	case 0x3a0 ... 0x3d0:
-	case 0x3f0:
-		return true;
+	case APIC_ID:
+	case APIC_LVR:
+	case APIC_PROCPRI:
+	case APIC_LDR:
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+	case APIC_IRR ... APIC_IRR + 0x70:
+	case APIC_TMCCT:
+		return X2APIC_RO;
+	case APIC_TASKPRI:
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
+		return X2APIC_RW;
+	case APIC_EOI:
+	case APIC_SELF_IPI:
+		return X2APIC_WO;
 	case APIC_CMCI:
-		return !apic_lvt_entry_supported(6);
+		if (apic_lvt_entry_supported(6))
+			return X2APIC_RW;
+		break;
+	case APIC_RRR:
+	case APIC_DFR:
+	case APIC_ICR2:
 	default:
-		return false;
+		break;
 	}
+	return X2APIC_INVALID;
 }
 
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7bba8165..59dfe6a5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6191,9 +6191,7 @@ static void virt_x2apic_mode_rd_expectation(
 	bool apic_register_virtualization, bool virtual_interrupt_delivery,
 	struct virt_x2apic_mode_expectation *expectation)
 {
-	bool readable =
-		!x2apic_reg_reserved(reg) &&
-		reg != APIC_EOI;
+	enum x2apic_reg_semantics semantics = get_x2apic_reg_semantics(reg);
 
 	expectation->rd_exit_reason = VMX_VMCALL;
 	expectation->virt_fn = virt_x2apic_mode_identity;
@@ -6209,7 +6207,7 @@ static void virt_x2apic_mode_rd_expectation(
 		expectation->rd_val = MAGIC_VAL_1;
 		expectation->virt_fn = virt_x2apic_mode_nibble1;
 		expectation->rd_behavior = X2APIC_ACCESS_VIRTUALIZED;
-	} else if (!disable_x2apic && readable) {
+	} else if (!disable_x2apic && (semantics & X2APIC_READABLE)) {
 		expectation->rd_val = apic_read(reg);
 		expectation->rd_behavior = X2APIC_ACCESS_PASSED_THROUGH;
 	} else {
-- 
2.39.0.314.g84b9a713c41-goog

