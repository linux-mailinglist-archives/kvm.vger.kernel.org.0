Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75967679E4
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbjG2Akf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbjG2AkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:40:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AADB524D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d1efa597303so5785170276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591063; x=1691195863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sEeXYbzgZRVXR5YLFfEtQVAczR2xalSf9MVNMlCNrPc=;
        b=510yqVUE3dJrmTFvMRZmUgU2asXSH3DoFW0Fghi574CxyywdgdIv8Y/diDFElXqlyf
         jU6KsQmAZf71nxPH+MSup9/mIF1uemfLZbDWceTG4BdkFGD9rcuSR2n/9/0/bk8De/N9
         25VV8tPUNlntY3Fv3oSuGTysrAQ/6Y6iPssCSdafPx304Mq6vNfG78lBD+9VDgXAqZkq
         em5cPcrt8KHlMBFm8vm0+E08hW/a6en+YbJ7ZZAKPcaON8hlum758WmUnT3f2Lw6PHXK
         Z/cAhUBz5bE1+QxdbyvOLhdn7yGVpm4px3BGKkYiY2arDrtsqFhkBbGF+doEA8uqBr8T
         5T5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591063; x=1691195863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEeXYbzgZRVXR5YLFfEtQVAczR2xalSf9MVNMlCNrPc=;
        b=guXg5Rv8bvPNrRgKbGJqtFxrbheRHj3+wJn+xZL7M2xuZYOC3y2Rnhfe9sPEOZ6uID
         KEClEpb2+HX0FepWYu7MxoXHnJ8hsHzN8r8VyWcQFr7BHseE8Xb8bSOlaSxwEHjiDqs7
         LHaLdXaekf/ZN+elfs+uPnl/1mQHYd6jCtbUZkJ4iLmX3/buGI3bfiNIDRl1BuDxkSc+
         O/X7K4ZN3zEODkc65nakd/hSV/DfyWAs++oPFRBZ+3KmiB6rYTMZxXDeudUyeD86jvy6
         n922/26Db0520AWZ4sy853tbIBiR/Y9BzsGWppX9o3NNP6/ckYp+Iw6P76blC7MtAWD0
         7KCg==
X-Gm-Message-State: ABy/qLaJxvofasfsFTi95mojcb+cZ2MrgeAQhPCo9expBtsn51sGYKnX
        kUJVggtiEnHHMP6YjlrjlRkW+x6Vq+A=
X-Google-Smtp-Source: APBJJlEwkcPph7CHbR1bEzAaGPD5/cOkJGSBy5rl0bnU2QuHcdpuQJe7rfYazvWjgBg8IHQMVGr/YJUq7Ok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cb:b0:d16:7ccc:b406 with SMTP id
 n11-20020a05690211cb00b00d167cccb406mr31838ybu.5.1690591063821; Fri, 28 Jul
 2023 17:37:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:39 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-31-seanjc@google.com>
Subject: [PATCH v4 30/34] KVM: selftests: Convert VMX's PMU capabilities test
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

Convert x86's VMX PMU capabilities test to use printf-based guest asserts.
Opportunstically add a helper to do the WRMSR+assert so as to reduce the
amount of copy+paste needed to spit out debug information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 34efd57c2b32..ba09d5a01c39 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -10,6 +10,7 @@
  * and check it can be retrieved with KVM_GET_MSR, also test
  * the invalid LBR formats are rejected.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
@@ -52,23 +53,24 @@ static const union perf_capabilities format_caps = {
 	.pebs_format = -1,
 };
 
+static void guest_test_perf_capabilities_gp(uint64_t val)
+{
+	uint8_t vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
+
+	__GUEST_ASSERT(vector == GP_VECTOR,
+		       "Expected #GP for value '0x%llx', got vector '0x%x'",
+		       val, vector);
+}
+
 static void guest_code(uint64_t current_val)
 {
-	uint8_t vector;
 	int i;
 
-	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, current_val);
-	GUEST_ASSERT_2(vector == GP_VECTOR, current_val, vector);
+	guest_test_perf_capabilities_gp(current_val);
+	guest_test_perf_capabilities_gp(0);
 
-	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, 0);
-	GUEST_ASSERT_2(vector == GP_VECTOR, 0, vector);
-
-	for (i = 0; i < 64; i++) {
-		vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES,
-				    current_val ^ BIT_ULL(i));
-		GUEST_ASSERT_2(vector == GP_VECTOR,
-			       current_val ^ BIT_ULL(i), vector);
-	}
+	for (i = 0; i < 64; i++)
+		guest_test_perf_capabilities_gp(current_val ^ BIT_ULL(i));
 
 	GUEST_DONE();
 }
@@ -95,7 +97,7 @@ static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "val = 0x%lx, vector = %lu");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.41.0.487.g6d72f3e995-goog

