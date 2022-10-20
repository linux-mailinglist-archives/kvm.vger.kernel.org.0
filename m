Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77766056F5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJTFnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJTFnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:43:51 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FB612FF9E
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z9-20020a17090a468900b00202fdb32ba1so1122833pjf.1
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B5VialaYDd/5nDZq2FGZQSkkeS3yDmkJ8xITb2jtJu4=;
        b=JCQN7ZN/2N0cWyp8F8z9Q/AWQsvHJudQPiteYqEIcj7XfWugeQhVkTmnP0ARsWsoks
         ucgnIuxwkVOi6HfufXCOivOoWc0OAfMaQ5LcZ7LoJDphUF5BD661KNYr13g9b8M69Wg5
         sYWriD3ommK1rvL7wYoQei3CW09bn2tk9bumU08bD2tbJvn7h2d3n2uBe3lkScwHMXo/
         +pgtGuA2YWI5nKvdUoxnT816Q+TSg6g4SRqRLOa1HBJbbymWGCLYzRrE86VGWUgxGIhh
         fAoVU8gmlDs5BJ+XuOZSg+xtcNGDwIO9ya/KVTRPWvkUMcFeE/PKg4uoGNBwomtfA+sz
         SrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5VialaYDd/5nDZq2FGZQSkkeS3yDmkJ8xITb2jtJu4=;
        b=2da1lAGN+v3O62dp92619+DyLOWVV4rFOT388Bg9icgprDLdhns+9HoM5CA2Sj+RU+
         iwZ2oxb479SASreMnF9SKFlriZfm30uK9YY7YzhINp7/e60w8ltrSJpVmdTN+YGG86uH
         HbtovEKmuUOT39029M3xNrac1ML+Gd5yeAdDwVkCaNquk520Ua5qdaJexMTgUh8VcKci
         /4zTTwzHoeVxlqQWw1YhsbYEXZpJRGKZzTbmAi1qp1XhOGYbttXtQTtoi5T2hQ6qekzq
         creex88/Ir3sna0hDV7X1XM/JWFTCTFWwfQFI8Fr8NEXVIbetyrlAfehQiiV/8rlVhuS
         Dx0w==
X-Gm-Message-State: ACrzQf3slix4wLJVSFNAp/zRMclDc1tbJIMUOSX0O4qjIN0OAqUlcguB
        i6Som6WQTl7Ljf+cYFxI45VI30lbNYE=
X-Google-Smtp-Source: AMsMyM4nwPtJ6JpQSfu86pZslSfGKYI7Hejk4DKn49pB5qd4AvXEqW2ZJclxhcgitaqs9lCMA2XixsTUavc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:b794:b0:20a:eab5:cf39 with SMTP id
 m20-20020a17090ab79400b0020aeab5cf39mr2379113pjr.1.1666244629981; Wed, 19 Oct
 2022 22:43:49 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:42:02 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-10-reijiw@google.com>
Subject: [PATCH v2 9/9] KVM: arm64: selftests: Test with every breakpoint/watchpoint
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Currently, the debug-exceptions test always uses only
{break,watch}point#0 and the highest numbered context-aware
breakpoint. Modify the test to use all {break,watch}points and
context-aware breakpoints supported on the system.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 54 ++++++++++++++-----
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 73a95e6b345e..b30add3e7726 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -420,12 +420,11 @@ static int debug_version(uint64_t id_aa64dfr0)
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
-static void test_guest_debug_exceptions(uint64_t aa64dfr0)
+static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint8_t brp_num;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -444,15 +443,9 @@ static void test_guest_debug_exceptions(uint64_t aa64dfr0)
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Number of breakpoints */
-	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
-	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
-
-	/*
-	 * Run tests with breakpoint#0, watchpoint#0, and the higiest
-	 * numbered (context-aware) breakpoint.
-	 */
-	vcpu_args_set(vcpu, 3, 0, 0, brp_num - 1);
+	/* Specify bpn/wpn/ctx_bpn to be tested */
+	vcpu_args_set(vcpu, 3, bpn, wpn, ctx_bpn);
+	pr_debug("Use bpn#%d, wpn#%d and ctx_bpn#%d\n", bpn, wpn, ctx_bpn);
 
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
@@ -535,6 +528,43 @@ void test_single_step_from_userspace(int test_cnt)
 	kvm_vm_free(vm);
 }
 
+/*
+ * Run debug testing using the various breakpoint#, watchpoint# and
+ * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
+ */
+void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
+{
+	uint8_t brp_num, wrp_num, ctx_brp_num, normal_brp_num, ctx_brp_base;
+	int b, w, c;
+
+	/* Number of breakpoints */
+	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
+	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
+
+	/* Number of watchpoints */
+	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), aa64dfr0) + 1;
+
+	/* Number of context aware breakpoints */
+	ctx_brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_CTX_CMPS), aa64dfr0) + 1;
+
+	pr_debug("%s brp_num:%d, wrp_num:%d, ctx_brp_num:%d\n", __func__,
+		 brp_num, wrp_num, ctx_brp_num);
+
+	/* Number of normal (non-context aware) breakpoints */
+	normal_brp_num = brp_num - ctx_brp_num;
+
+	/* Lowest context aware breakpoint number */
+	ctx_brp_base = normal_brp_num;
+
+	/* Run tests with all supported breakpoints/watchpoints */
+	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
+		for (b = 0; b < normal_brp_num; b++) {
+			for (w = 0; w < wrp_num; w++)
+				test_guest_debug_exceptions(b, w, c);
+		}
+	}
+}
+
 static void help(char *name)
 {
 	puts("");
@@ -569,7 +599,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	test_guest_debug_exceptions(aa64dfr0);
+	test_guest_debug_exceptions_all(aa64dfr0);
 	test_single_step_from_userspace(ss_iteration);
 
 	return 0;
-- 
2.38.0.413.g74048e4d9e-goog

