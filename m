Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0180C7679CC
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbjG2AjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjG2Aig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4562944A5
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb962ada0dso17190825ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591040; x=1691195840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=62IIfbK+fVHnQpHB0LZHeva+9zsTyACR3DAXgqGUpUY=;
        b=SjpYkHcU8DfvLPEP6EE3BSTR/2/6/dg3QI3BV6WrrOhgfT/Axj5gvHKmQEj21aynvu
         IfZBARD2/rsjLEVGbvM2z0q99N1PWdAcl7DYCxNnNaLdHcIlkyRkdk/nbDMn7F9+/a8e
         CuhyiC1DAy4v3U+R4k7YfRnm9iEAN42L+6VgqENHy+0Z6wsFjfHa7L8g5WSPsmjJnyFt
         JMTcqvgBf/Y0L040z/FF0Q6nEsDXIJggJlKlAjnI6jY0WsZnbHhBByPRE33YgvMkNqkb
         Z4gitISbvjzVi4D6FyklqEUoPL0KOcodWo1FLrcSiCq7BZ7n03kIFlkuicSVwDz5Bgxw
         MEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591040; x=1691195840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62IIfbK+fVHnQpHB0LZHeva+9zsTyACR3DAXgqGUpUY=;
        b=OdboKjBePZyKaRpqe5w5AM7kszQbxelnHEfxmA6aENAgHZXc4MMc/H3/XqMoS+Zjvu
         x2beSZpTjXPZI2QwSej2bwNlm3fDGEIRvltdaYZyMOWaxvBe2wPpbWYEeKBtbav85rld
         dmDH0knygZTP5eAqCCrGhCwoiwudb0eKPK5CEHcx5WX37YdkmV9s6oJLdQBCOI3QAP5D
         s9tDD3zGmVaSsM0W2Ye2gWeWXaIn7szr0JtMYKUXBVRIkbAJwfLIDNI6KqwZbub9RP1x
         nUNLP2uZuh2nPZWwzBrCJmedoeN5YuX56Q9EHndFVbaw74Q6GoQezP5e5Yp0WMuDfagI
         axmg==
X-Gm-Message-State: ABy/qLYACwBYlgpKOCfPY5quZ+h86yUfImTPcy7HILFixNjCxAgHPFHt
        Zwpw0DBJ0hsIQ1bIfT84Jsthb5ISsek=
X-Google-Smtp-Source: APBJJlH6iRT9Dvs1GTfRtC3q4lJnWblWrURV+JKeAmNtjrPWw6VO8hwBqRMxcLpxte+WdCjaXOyJVdz5jAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d1:b0:1b5:2496:8c0d with SMTP id
 e17-20020a17090301d100b001b524968c0dmr12013plh.3.1690591040630; Fri, 28 Jul
 2023 17:37:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:27 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-19-seanjc@google.com>
Subject: [PATCH v4 18/34] KVM: selftests: Convert set_memory_region_test to
 printf-based GUEST_ASSERT
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert set_memory_region_test to print-based GUEST_ASSERT, using a combo
of newfangled macros to report (hopefully) useful information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 23 +++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a849ce23ca97..dd8f4bac9df8 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <fcntl.h>
 #include <pthread.h>
@@ -88,7 +90,7 @@ static void *vcpu_worker(void *data)
 	}
 
 	if (run->exit_reason == KVM_EXIT_IO && cmd == UCALL_ABORT)
-		REPORT_GUEST_ASSERT_1(uc, "val = %lu");
+		REPORT_GUEST_ASSERT(uc);
 
 	return NULL;
 }
@@ -156,19 +158,22 @@ static void guest_code_move_memory_region(void)
 	 * window where the memslot is invalid is usually quite small.
 	 */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
+	__GUEST_ASSERT(val == 1 || val == MMIO_VAL,
+		       "Expected '1' or MMIO ('%llx'), got '%llx'", MMIO_VAL, val);
 
 	/* Spin until the misaligning memory region move completes. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 1 || val == 0, val);
+	__GUEST_ASSERT(val == 1 || val == 0,
+		       "Expected '0' or '1' (no MMIO), got '%llx'", val);
 
 	/* Spin until the memory region starts to get re-aligned. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
+	__GUEST_ASSERT(val == 1 || val == MMIO_VAL,
+		       "Expected '1' or MMIO ('%llx'), got '%llx'", MMIO_VAL, val);
 
 	/* Spin until the re-aligning memory region move completes. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 1, val);
+	GUEST_ASSERT_EQ(val, 1);
 
 	GUEST_DONE();
 }
@@ -224,15 +229,15 @@ static void guest_code_delete_memory_region(void)
 
 	/* Spin until the memory region is deleted. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == MMIO_VAL, val);
+	GUEST_ASSERT_EQ(val, MMIO_VAL);
 
 	/* Spin until the memory region is recreated. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 0, val);
+	GUEST_ASSERT_EQ(val, 0);
 
 	/* Spin until the memory region is deleted. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == MMIO_VAL, val);
+	GUEST_ASSERT_EQ(val, MMIO_VAL);
 
 	asm("1:\n\t"
 	    ".pushsection .rodata\n\t"
@@ -249,7 +254,7 @@ static void guest_code_delete_memory_region(void)
 	    "final_rip_end: .quad 1b\n\t"
 	    ".popsection");
 
-	GUEST_ASSERT_1(0, 0);
+	GUEST_ASSERT(0);
 }
 
 static void test_delete_memory_region(void)
-- 
2.41.0.487.g6d72f3e995-goog

