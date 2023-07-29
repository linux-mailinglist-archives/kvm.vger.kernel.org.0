Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343807679C0
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbjG2Aij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbjG2AiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724F244A2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5847479b559so21521657b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591029; x=1691195829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wu4FIC3h9waVlshrR9u15d0CHMaQIDGVSbYx3EG04CA=;
        b=Q04Mf0el0lj42W5CyQit+deYtJ8QhAiSTuhlHtHpss5X9mHsFREv9pAjkA8Umzzpec
         z2MZTBlNwMlYWVVc7jlHkM0CgDBhYSqKk80RWVzksAIdRWMzevbW1mKyru4oBtXSj5H4
         m6Y/c47W8GxbL3qevPjkSSP7Fvl4k1vbdy6jI1X6Mu6B/+sTNRMI9LsAHW+sZ3/Cjtna
         KYEmzp1hmEEjPQVxCmUas0BEGE4lj8arVq+7r3PN0H6HoRmfvsyDiXkfqpnkvZEIMNS8
         xc0Ohhn24LAbCMmrkVsDurMlVKgVNxcSVlsTO0MATuz98mHcaBk17CNAUEHGB1MtfxGX
         D+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591029; x=1691195829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wu4FIC3h9waVlshrR9u15d0CHMaQIDGVSbYx3EG04CA=;
        b=eRmwXwNOdH/OdntoQ68C5bh/Vc5GG70+jgAwGWQW0OLDpdKwYVAdHIWb0ZzV9LIwl3
         Ijy+e4sFKis+Toxuqzl8EedP9pZZRqxcrPCfggCNFmIn9mMzvoUTmVFMqjrFvFZIdhrl
         lJyiQsC1r8eQS6frsBkZpY84M4dZtUXSjPOaPvf15HybBmyYMsiaP9cSDlfWYK53SeS6
         lpvaHpkNfS1wLXeXWAPHf3bvy1QJzr/hv9N56L0x4/mV2DNYNYnlwEA3UeDHfPXHYOyu
         BL5kJr7biEateK2zechvqsqpVrbhMdH2KRGO8hn4VoxoSYOddBI/cGxLroZCzKc4o2Ww
         9Ycw==
X-Gm-Message-State: ABy/qLYtq+yk0H1xo5Kca55SAMIr3JtRkL83ZSKSuImIM4/ZPlAPd/Xj
        4IOILB9Ts06w6ZmZSC7tuGq0ryQB5GQ=
X-Google-Smtp-Source: APBJJlGzWzIiwoRLp4Z8GC3Y2NOo6GBZ+PY3Wo7QtnMh9LciT0gmn3cUuXWNKJuT0Aj+FA3/xsDneSWd6xU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b645:0:b0:577:4540:905a with SMTP id
 h5-20020a81b645000000b005774540905amr24915ywk.7.1690591029333; Fri, 28 Jul
 2023 17:37:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:21 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-13-seanjc@google.com>
Subject: [PATCH v4 12/34] KVM: selftests: Convert ARM's hypercalls test to
 printf style GUEST_ASSERT
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

Convert ARM's hypercalls test to use printf-based GUEST_ASSERT().
Opportunistically use GUEST_FAIL() to complain about an unexpected stage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/hypercalls.c        | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index bef1499fb465..94555a7d3c7e 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -8,6 +8,7 @@
  * hypercalls are properly masked or unmasked to the guest when disabled or
  * enabled from the KVM userspace, respectively.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <errno.h>
 #include <linux/arm-smccc.h>
@@ -105,15 +106,17 @@ static void guest_test_hvc(const struct test_hvc_info *hc_info)
 		switch (stage) {
 		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		case TEST_STAGE_HVC_IFACE_FALSE_INFO:
-			GUEST_ASSERT_3(res.a0 == SMCCC_RET_NOT_SUPPORTED,
-					res.a0, hc_info->func_id, hc_info->arg1);
+			__GUEST_ASSERT(res.a0 == SMCCC_RET_NOT_SUPPORTED,
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
-			GUEST_ASSERT_3(res.a0 != SMCCC_RET_NOT_SUPPORTED,
-					res.a0, hc_info->func_id, hc_info->arg1);
+			__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED,
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		default:
-			GUEST_ASSERT_1(0, stage);
+			GUEST_FAIL("Unexpected stage = %u", stage);
 		}
 	}
 }
@@ -132,7 +135,7 @@ static void guest_code(void)
 			guest_test_hvc(false_hvc_info);
 			break;
 		default:
-			GUEST_ASSERT_1(0, stage);
+			GUEST_FAIL("Unexpected stage = %u", stage);
 		}
 
 		GUEST_SYNC(stage);
@@ -290,10 +293,7 @@ static void test_run(void)
 			guest_done = true;
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_N(uc, "values: 0x%lx, 0x%lx; 0x%lx, stage: %u",
-					      GUEST_ASSERT_ARG(uc, 0),
-					      GUEST_ASSERT_ARG(uc, 1),
-					      GUEST_ASSERT_ARG(uc, 2), stage);
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		default:
 			TEST_FAIL("Unexpected guest exit\n");
-- 
2.41.0.487.g6d72f3e995-goog

