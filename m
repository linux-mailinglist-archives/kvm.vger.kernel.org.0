Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485355A085D
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiHYFKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiHYFKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:31 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956DA9E6BF
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33da75a471cso59067547b3.20
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=YHlnoTuvqCkIHNzVEvPhjo0XVRSspND21mglVFldtsg=;
        b=S4z6ByMKPaz7v0TqyBPudcw0RcL/LIRHleuf4PcPxUkw0lVnru6Bdvk/I6csdzNys9
         i95i3qO5w/JbpaEjD35NQZQta1f1kb4LdfeboJm99NQQys23YMVdjQjAJmOcZKVCXTJs
         zvVC9Nlwn5Y/iaySbFCJEiMHZSeygT7AjdovUTHx9btnsLyd4Ig2BeizYl5cOuknmKHK
         eZporwgkevI0ZITNmGKaY6gRjvJaDNEE92bHFa3GqxrBpzvLEFngo2Ak9mMDrF9pA+2S
         eoL6QPAlLOaDQfNGjRQAziKcsck0iRfSag7UeKPxS0LlE1/zPR+oQ5aUSzvHbv91ezBr
         oW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=YHlnoTuvqCkIHNzVEvPhjo0XVRSspND21mglVFldtsg=;
        b=QaM2Geh4s/X45Dq4ug0HpRu16n9208gMjSov+1QBHxKUdIH8MxzFHVNGNwV4q/fSFC
         QwGse9EHrsMYbcmOvD+KKRShq/vizsdiV0HcywZMDqsHDWCQUs0gCx0nnXJacIFg/Fej
         IcEv4EPfCazW+kzVhSiEXcmWG2DLukm295YBkeTJl+Tqcos3zPIUesfMZHT472Frxs4n
         52SrErQgB6IIjCC8fpJ3f/TRoSKswz7a81fV1/LhEfZexzHE8SCnKRdU1HUWI49asAsR
         FKMlHg2Hs1skuBqT9r9SuMC8L5Aw5dxtJ4mzEQdRDqQOqn6Dw5mfnXEreiUA5N3lBUR3
         RhBw==
X-Gm-Message-State: ACgBeo2qL5eyiDhwu4fg+C1GcvVfiHuDJhmO7EbzyppqvxJvl91RnZu0
        mAnGA3aFQQixXuIc1TvUmId01FmwtRo=
X-Google-Smtp-Source: AA6agR60smgqTg7FqVsKr00Rx1ARhb9FLWG6n/rkbAzF0Rp9rt1QNn0dvCk9m1oXln0XP7RzE1TOPpoc+8w=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:58d:0:b0:695:ea5e:5311 with SMTP id
 135-20020a25058d000000b00695ea5e5311mr2069649ybf.370.1661404227271; Wed, 24
 Aug 2022 22:10:27 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:46 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 9/9] KVM: arm64: selftests: Test with every breakpoint/watchpoint
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Currently, the debug-exceptions test always uses only
{break,watch}point#0 and the highest numbered context-aware
breakpoint. Modify the test to use all {break,watch}points and
context-aware breakpoints supported on the system.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 77 +++++++++++++++----
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index dc94c85bb383..7aeab6ae887a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -397,14 +397,12 @@ static int debug_version(uint64_t id_aa64dfr0)
 	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
-int main(int argc, char *argv[])
+void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
-	uint64_t aa64dfr0;
-	uint8_t brps;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -412,10 +410,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
-	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -427,15 +421,9 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Number of breakpoints, minus 1 */
-	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
-	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
-
-	/*
-	 * Run tests with breakpoint#0 and watchpoint#0, and the higiest
-	 * numbered (context-aware) breakpoint.
-	 */
-	vcpu_args_set(vcpu, 3, 0, 0, brps);
+	/* Specify bpn/wpn/ctx_bpn to be tested */
+	vcpu_args_set(vcpu, 3, bpn, wpn, ctx_bpn);
+	pr_debug("Use bpn#%d, wpn#%d and ctx_bpn#%d\n", bpn, wpn, ctx_bpn);
 
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
@@ -458,5 +446,62 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+/*
+ * Run debug testing using the various breakpoint#, watchpoint# and
+ * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
+ */
+void test_debug(uint64_t aa64dfr0)
+{
+	uint8_t brps, wrps, ctx_cmps;
+	uint8_t normal_brp_num, wrp_num, ctx_brp_base, ctx_brp_num;
+	int b, w, c;
+
+	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
+
+	wrps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	ctx_cmps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	pr_debug("%s brps:%d, wrps:%d, ctx_cmps:%d\n", __func__,
+		 brps, wrps, ctx_cmps);
+
+	/* Number of normal (non-context aware) breakpoints */
+	normal_brp_num = brps - ctx_cmps;
+
+	/* Number of watchpoints */
+	wrp_num = wrps + 1;
+
+	/* Number of context aware breakpoints */
+	ctx_brp_num = ctx_cmps + 1;
+
+	/* Lowest context aware breakpoint number */
+	ctx_brp_base = normal_brp_num;
+
+	/* Run tests with all supported breakpoints/watchpoints */
+	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
+		for (b = 0; b < normal_brp_num; b++) {
+			for (w = 0; w < wrp_num; w++)
+				run_test(b, w, c);
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint64_t aa64dfr0;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	kvm_vm_free(vm);
+
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
+		       "Armv8 debug architecture not supported.");
+
+	/* Run debug tests with the default configuration */
+	test_debug(aa64dfr0);
 	return 0;
 }
-- 
2.37.1.595.g718a3a8f04-goog

