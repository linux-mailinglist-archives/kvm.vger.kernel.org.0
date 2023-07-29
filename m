Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D194F7679D9
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbjG2Ajx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbjG2Ai5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7404ED9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56942442eb0so29272937b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591054; x=1691195854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HaBkctuCpzeNsmYq2ZMyhzuleSw3w1r0yLS5/ARfwFU=;
        b=0BjQf8mxVqLf9olUxXGMC1K/Q8Umy+UDlIwiZvN5AhzF5GaReKUy2Smdqy+iC5mqmM
         ddDy5dpIo98KTcMschBba1bUW0oSSa5ow8PFtOdZWlvKFfDHrcvUc/hSjwq40Te0l75V
         Jeo8+Q6V4F9oYBmvmUeWeDX3lXivT5TjTHwjtbtfK2clS4pfKJuUWfRg4l8sqNbXSV/C
         G1DPyKNYjO22H4sI7oX2eTOF8JqH+iK8F/uA89XJwOSL2AkvzC/C6/GN8GBo7JvDLMkM
         CWDHxcTfxWUbMrn4oFs1vnjHlFD3MOa0DBObIs3gjiXioSIH1IiFBp0AUYsF6OdcW031
         WYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591054; x=1691195854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HaBkctuCpzeNsmYq2ZMyhzuleSw3w1r0yLS5/ARfwFU=;
        b=Pn5jhXZAKsK7GROfyop5zJyB3q64E0svaOPcZ0b/rAlUUHDNMxFaGqjDBBATwuheDC
         /wHomUNIrosBMcTF/nO0fKbQdZnp20lT/DTli840Jh3eY4eDhnivCfzfR+qbDFr592Tc
         qeDILlRD02i5egETaoXfWx+fLQXKp/Fki4rBCTz/iwVq8iyazk31JBNHT8/Kka30E9wB
         DTjm/28JbDd7ez9wJQCrrDBRgtoH5biPW5ohMLDoR/5fFNu7Z3JpAljKVRhAIohTwUoR
         6/NJVP5bC6y6OZv05tRkehda5pjFb8B4lGnGs6gW8XkeSS2dr2X2+V+LMAas3ey6Fw0p
         Wrug==
X-Gm-Message-State: ABy/qLYHlPuAZnC+qEzazIz0N9XyDCI6hQvQ8NVVl2cxJSmQlXmAN93C
        xEET7KRKtJYEPu/p0WFh0BIztsW/nK4=
X-Google-Smtp-Source: APBJJlGJseaUzNmHDQp72UkoB0v5EChLeNnkGTMKsOKAgx227d/kK9tEZTDaSnghq3o8QtMG4vQKRKA0Bx0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae68:0:b0:577:3b0c:5b85 with SMTP id
 g40-20020a81ae68000000b005773b0c5b85mr25198ywk.0.1690591054389; Fri, 28 Jul
 2023 17:37:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:34 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-26-seanjc@google.com>
Subject: [PATCH v4 25/34] KVM: selftests: Convert x86's nested exceptions test
 to printf guest asserts
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

Convert x86's nested exceptions test to printf-based guest asserts, and
use REPORT_GUEST_ASSERT() instead of TEST_FAIL() so that output is
formatted correctly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
index 5f074a6da90c..4a29f59a76be 100644
--- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE /* for program_invocation_short_name */
 
 #include "test_util.h"
@@ -180,9 +182,7 @@ static void assert_ucall_vector(struct kvm_vcpu *vcpu, int vector)
 			    "Expected L2 to ask for %d, L2 says it's done", vector);
 		break;
 	case UCALL_ABORT:
-		TEST_FAIL("%s at %s:%ld (0x%lx != 0x%lx)",
-			  (const char *)uc.args[0], __FILE__, uc.args[1],
-			  uc.args[2], uc.args[3]);
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	default:
 		TEST_FAIL("Expected L2 to ask for %d, got unexpected ucall %lu", vector, uc.cmd);
-- 
2.41.0.487.g6d72f3e995-goog

