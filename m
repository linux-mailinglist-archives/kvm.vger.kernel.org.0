Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555407679D7
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbjG2Ajv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbjG2Aiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F84949F6
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583b256faf5so45066967b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591052; x=1691195852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x4HKEzKPUNSBzX9E0pO5Q/S6phjiWeOhLiSfPQ8QooI=;
        b=3J4eqVLdR3ykoPJRa1CUqiAo7FXGwSPiLo4xvH7nk6TpWaa/JGpNhmBWPw3KGYxRL0
         9qMYcdR0/u6TUawhaqgYIaxBi5b32u3oPLpRlG7qWlPPXPZunewy09jWcWhC5Cl19DL7
         zBgBnw4cSdRNiEkbsjo5Gcp2bAEBX0lBRSqsq7y6cBmpf20gsU/X+fWwZZk0O0I+ym7u
         pJ0NqE4APMBHTdZkdJxn5Xpo8lTIwyoI4uNBVqd4epT2ornrp+APUS9uMhgYVKkxnoLv
         zYejQkImQ3xyT5zUPKO72TgnNFsAd3LxTmVwJsnOtP65P8WX4nYqjQ+E8aENux/RDqvj
         E9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591052; x=1691195852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4HKEzKPUNSBzX9E0pO5Q/S6phjiWeOhLiSfPQ8QooI=;
        b=SLMs+98VKKLPvUwKq6v/GImlJwGDJMcz4xVPZQ8sonMVWJlJh8t3Eh1tWL6GrmBJLh
         W3nsj8ZbT+pES9s70jt6KtBZ96T0b7MTIU5G6DyDYT2tG6v81v40rA4wfyR3j4Tlbg0Z
         AROeixmg76s4bWupfQP4/Uj0cpos00OXIPHX8KmdVaIoFPdKy5RA4Bw1OZEREvwMTMoG
         ktaz23pyO0C1EtxUCkS6sP8IY/MtMhusoo2yrveVxvQyIUOU3f6MaEK+Fs3rB06eIFm4
         VP9VARVuTgG777wh/TOgVXWyzNcMWLzCG3jr0IZlRR0BPBQ0pMoxDmAIUcgpoYC/yGGB
         wxlQ==
X-Gm-Message-State: ABy/qLbOme4fqeSWQrlkCdAmziod385lbNTw6rfD56zfDmk1N9QY9Efh
        NX9ossVHmKJfRlPrGLV3PvJAX1C9AUE=
X-Google-Smtp-Source: APBJJlEzrltnG1bwndm5pPHC3kHPtaj+RzjLvULD33K65TOP6Fq4kMafYhL6vJSstsfRiau2YYzr8Mp1Vdw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b665:0:b0:56c:f903:8678 with SMTP id
 h37-20020a81b665000000b0056cf9038678mr39663ywk.2.1690591052589; Fri, 28 Jul
 2023 17:37:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:33 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-25-seanjc@google.com>
Subject: [PATCH v4 24/34] KVM: selftests: Convert the MONITOR/MWAIT test to
 use printf guest asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert x86's MONITOR/MWAIT test to use printf-based guest asserts.  Add a
macro to handle reporting failures to reduce the amount of copy+paste
needed for MONITOR vs. MWAIT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/monitor_mwait_test.c | 37 +++++++++++--------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 72812644d7f5..960fecab3742 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -16,14 +18,25 @@ enum monitor_mwait_testcases {
 	MWAIT_DISABLED = BIT(2),
 };
 
+/*
+ * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD, in all
+ * other scenarios KVM should emulate them as nops.
+ */
+#define GUEST_ASSERT_MONITOR_MWAIT(insn, testcase, vector)		\
+do {									\
+	bool fault_wanted = ((testcase) & MWAIT_QUIRK_DISABLED) &&	\
+			    ((testcase) & MWAIT_DISABLED);		\
+									\
+	if (fault_wanted)						\
+		__GUEST_ASSERT((vector) == UD_VECTOR,			\
+			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
+	else								\
+		__GUEST_ASSERT(!(vector),				\
+			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
+} while (0)
+
 static void guest_monitor_wait(int testcase)
 {
-	/*
-	 * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD,
-	 * in all other scenarios KVM should emulate them as nops.
-	 */
-	bool fault_wanted = (testcase & MWAIT_QUIRK_DISABLED) &&
-			    (testcase & MWAIT_DISABLED);
 	u8 vector;
 
 	GUEST_SYNC(testcase);
@@ -33,16 +46,10 @@ static void guest_monitor_wait(int testcase)
 	 * intercept checks, so the inputs for MONITOR and MWAIT must be valid.
 	 */
 	vector = kvm_asm_safe("monitor", "a"(guest_monitor_wait), "c"(0), "d"(0));
-	if (fault_wanted)
-		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
-	else
-		GUEST_ASSERT_2(!vector, testcase, vector);
+	GUEST_ASSERT_MONITOR_MWAIT("MONITOR", testcase, vector);
 
 	vector = kvm_asm_safe("mwait", "a"(guest_monitor_wait), "c"(0), "d"(0));
-	if (fault_wanted)
-		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
-	else
-		GUEST_ASSERT_2(!vector, testcase, vector);
+	GUEST_ASSERT_MONITOR_MWAIT("MWAIT", testcase, vector);
 }
 
 static void guest_code(void)
@@ -85,7 +92,7 @@ int main(int argc, char *argv[])
 			testcase = uc.args[1];
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "testcase = %lx, vector = %ld");
+			REPORT_GUEST_ASSERT(uc);
 			goto done;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

