Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E3C6DB732
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjDGXdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjDGXdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95A946BF
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:33:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p129-20020a254287000000b00aedd4305ff2so85855yba.13
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=29DoY8Y1qdOHbQr7Smx+ml+g3M6SNjpQzRfMcm5ydbU=;
        b=MiFxIUgbCYIWHfUESe4fCpAY4485JgxuhEl+NmRNHaPMr3jwbY5Nkh7AGnPbfr2dpY
         S2xIsM0P3ui5BsaMmPWushLpdF68/jofg47hR2KoOG6J8v5JD8Em6w0blIYRcV9ftfAe
         JDJb1rSklENmtsjFH0gNg+HIunh2Mt8N4twrWW2HZ1m4CM1ISVdIHd6MB2ju9lDnVnpg
         mEzaJsG6adLsBLKhJVWJ5OxeP4z1j/p1FWJwnzs0Oa2wjidMNdrNqoP0kOOUJT9gwWfJ
         nLx7cvfiTdpkl17WLgTrBj9G9KNVXfebYloujXKCJpub0aRQXdCLuhIrwiFupdU/sqOx
         k/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=29DoY8Y1qdOHbQr7Smx+ml+g3M6SNjpQzRfMcm5ydbU=;
        b=6sHJHegKMoUyTPLylqN1t9kGkniHqyd7XodWSGNu7usdN0TOvv3VIVf8naOTHLmHRK
         kWwWYqQz2WBhOQUKEP37fHp7BAxBBRxJYlH2e5FSL+oGUL/opG+jFC0gSjmklis/ASnh
         zAOnVeO3qQWicgXoc5WCJJCt2q2lIuYeSoCLKxl0Zm/gE2HyGLNwqOOI7FIjbO1Ih+CR
         Gm2SBARJ5nOFhOYmhhdK6Q9n54qeB1gyguqyblWBFGGHp5EypzDKtsXANRFKwg8NwxLh
         rkWnbR5bxb3D29q/rig9r+xhk9XWNMVgGMnRUi9cnts20H/miFHLuPlehm4LesFsGP5f
         7RGg==
X-Gm-Message-State: AAQBX9f3QgLODKF0eJUQCH56iJgCWX3Q3Fl3Qt055BCtE8PJlAPT3v5l
        mvAD11E3Ak+wJDGtu7QVMLWyNMC5G5w=
X-Google-Smtp-Source: AKy350aqL2ZMekVnvF+rIk7Pq5lInsvesMWd0PTyGqxS5bzhCQNJzMWGVCS94FaEZmTm+SHqy9ULVBJSFQM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:430d:0:b0:541:9063:8e9e with SMTP id
 q13-20020a81430d000000b0054190638e9emr1883364ywa.2.1680910381152; Fri, 07 Apr
 2023 16:33:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:50 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-3-seanjc@google.com>
Subject: [PATCH v4 2/6] KVM: selftests: Add helpers for PMC asserts in PMU
 event filter test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Add helper macros to consolidate the asserts that a PMC is/isn't counting
(branch) instructions retired.  This will make it easier to add additional
asserts related to counting instructions later on.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: add "INSTRUCTIONS", massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 52 ++++++++++---------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index a00a9d6ea41e..9b53e02a0565 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -244,14 +244,27 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
+#define ASSERT_PMC_COUNTING_INSTRUCTIONS(count)						\
+do {											\
+	if (count != NUM_BRANCHES)							\
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
+			__func__, count, NUM_BRANCHES);					\
+	TEST_ASSERT(count, "Allowed PMU event is not counting.");			\
+} while (0)
+
+#define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count)					\
+do {											\
+	if (count)									\
+		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",		\
+			__func__, count);						\
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");			\
+} while (0)
+
 static void test_without_filter(struct kvm_vcpu *vcpu)
 {
 	uint64_t count = run_vcpu_to_sync(vcpu);
 
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
 }
 
 static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
@@ -269,12 +282,9 @@ static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 
 	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
 	count = test_with_filter(vcpu, f);
-
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
 }
 
 static void test_member_deny_list(struct kvm_vcpu *vcpu)
@@ -283,10 +293,8 @@ static void test_member_deny_list(struct kvm_vcpu *vcpu)
 	uint64_t count = test_with_filter(vcpu, f);
 
 	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+
+	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count);
 }
 
 static void test_member_allow_list(struct kvm_vcpu *vcpu)
@@ -295,10 +303,8 @@ static void test_member_allow_list(struct kvm_vcpu *vcpu)
 	uint64_t count = test_with_filter(vcpu, f);
 
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
 }
 
 static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
@@ -310,10 +316,8 @@ static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	count = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
 }
 
 static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
@@ -325,10 +329,8 @@ static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	count = test_with_filter(vcpu, f);
 	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+
+	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count);
 }
 
 /*
-- 
2.40.0.577.gac1e443424-goog

