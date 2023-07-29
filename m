Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308FB7679E6
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbjG2Ako (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbjG2AkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:40:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957D05252
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5843fed1e88so26723837b3.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591066; x=1691195866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xqj9FFp3GbJzdxodUT2xF7JQwG5o4CpUta+kXT/J/Zc=;
        b=6mRTmQ0sMBjNlnuCoCc0BasP9WSyh4U3UNy+I62mmSF7PQnu5S9L9TmW4nCeJc1yEc
         NqvtlAqSC0Q516Jk1Y9Rkwxmg3AkjhBvkZaMC4+blSIxvv8aNAf4tDwiCWdS/mz3OFyS
         484OUBkMcHObYZQp7hJuJGDR6C5dr7avJVyoJNKl8w3G72UdYYEPxOT+z9Svg5rGM0wS
         ouYYaujR5212sPk4ldidMcjlqiJEBwgSW5vHQDioiBNoBbun5DWGQmKTJ76i9vFQfE+c
         hei//58Ou40y1sKp/lzuKZ07tJ4APhkr7vVnixNLY3U8h3ZP2nDbOyvBDVAvcnxyn5kY
         c1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591066; x=1691195866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqj9FFp3GbJzdxodUT2xF7JQwG5o4CpUta+kXT/J/Zc=;
        b=OR/HlTUfemhggj0+8VtcbxShc/3I24ofNLoBR3t9U7FwWnhgY+O2Nii608NAHDMYxY
         D961lIZW8w8SmNbor6o/DuIdwgnV3DiwjeqG03su+G7vw8/l3feMOPyr+WDLGZXjB5tO
         3moao5bLGa5TA7Six6ODFiBbVvLLG3GhOtpxq4+yoOFcqyb77URRRfcvpXSo66FMyoJm
         2nDGpaL3W75B3YTgMuKm3VLODHLwVFAVUB18/Un8H4Nv4zIgEQOKwk7x0Xdn4Srp9cqr
         f4p3XX89tXcXB3efEmjF4BzQZmHrtdJvnydSQU6zQ5Bb6sD6OqxGKCjmMroEI71eAUhj
         tT8A==
X-Gm-Message-State: ABy/qLZRjc5/sad5K+RrKo36N73AkAa6EQmqoLUAbBfx09yrkFf/8oWn
        IToXDcW/ZOlxEQQVm5O7cuIRGSpc1tI=
X-Google-Smtp-Source: APBJJlGUaaiUxSD6v+uHtzJn5Bok5HEB27UnUCHcnqVc3N6UWv+PT7JG5G0++htnoOGnrQBKyXgZZKI8MMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb14:0:b0:56c:e585:8b19 with SMTP id
 n20-20020a81eb14000000b0056ce5858b19mr22779ywm.2.1690591065884; Fri, 28 Jul
 2023 17:37:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:40 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-32-seanjc@google.com>
Subject: [PATCH v4 31/34] KVM: selftests: Convert x86's XCR0 test to use
 printf-based guest asserts
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

Convert x86's XCR0 vs. CPUID test to use printf-based guest asserts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 29 ++++++++++++-------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 905bd5ae4431..5e8290797720 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2022, Google LLC.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <fcntl.h>
 #include <stdio.h>
@@ -20,13 +21,14 @@
  * Assert that architectural dependency rules are satisfied, e.g. that AVX is
  * supported if and only if SSE is supported.
  */
-#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)	  \
-do {										  \
-	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies)); \
-										  \
-	GUEST_ASSERT_3((__supported & (xfeatures)) != (xfeatures) ||		  \
-		       __supported == ((xfeatures) | (dependencies)),		  \
-		       __supported, (xfeatures), (dependencies));		  \
+#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)		\
+do {											\
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies));	\
+											\
+	__GUEST_ASSERT((__supported & (xfeatures)) != (xfeatures) ||			\
+		       __supported == ((xfeatures) | (dependencies)),			\
+		       "supported = 0x%llx, xfeatures = 0x%llx, dependencies = 0x%llx",	\
+		       __supported, (xfeatures), (dependencies));			\
 } while (0)
 
 /*
@@ -41,7 +43,8 @@ do {										  \
 do {									\
 	uint64_t __supported = (supported_xcr0) & (xfeatures);		\
 									\
-	GUEST_ASSERT_2(!__supported || __supported == (xfeatures),	\
+	__GUEST_ASSERT(!__supported || __supported == (xfeatures),	\
+		       "supported = 0x%llx, xfeatures = 0x%llx",	\
 		       __supported, (xfeatures));			\
 } while (0)
 
@@ -79,14 +82,18 @@ static void guest_code(void)
 				    XFEATURE_MASK_XTILE);
 
 	vector = xsetbv_safe(0, supported_xcr0);
-	GUEST_ASSERT_2(!vector, supported_xcr0, vector);
+	__GUEST_ASSERT(!vector,
+		       "Expected success on XSETBV(0x%llx), got vector '0x%x'",
+		       supported_xcr0, vector);
 
 	for (i = 0; i < 64; i++) {
 		if (supported_xcr0 & BIT_ULL(i))
 			continue;
 
 		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
-		GUEST_ASSERT_3(vector == GP_VECTOR, supported_xcr0, vector, BIT_ULL(i));
+		__GUEST_ASSERT(vector == GP_VECTOR,
+			       "Expected #GP on XSETBV(0x%llx), supported XCR0 = %llx, got vector '0x%x'",
+			       BIT_ULL(i), supported_xcr0, vector);
 	}
 
 	GUEST_DONE();
@@ -117,7 +124,7 @@ int main(int argc, char *argv[])
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_3(uc, "0x%lx 0x%lx 0x%lx");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

