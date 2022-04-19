Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B0506539
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349191AbiDSHBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349168AbiDSHBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:01:17 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215012F03D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t12-20020a170902a5cc00b001590717a080so2523496plq.10
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q/YanX6EPfx+u+3OMqrYAFeJvrZlkb0TikNUTqVME1Y=;
        b=A9RjQxSTslkChFxxKJBdhdGh7KoE8jdKMtCpxERX/tBbu9UdykN6mkSjBGbvrYe0yp
         xBFHJ43ZJf4RR+MEhIlZ7ADb8RRTxk9EjoI4axpGew5mfnR/CZ+7Qc08BTxvdSIhMnEL
         S0VoLAtGwG0N9/MEUw8RgUNNusNRqxJ2rnhriVmUw0Daui4T115Gk7aB5kAT/K7Dy5ln
         Sqz+L0yKZ5Fwv8xGNj0xOmz6XDBQvxHX8WWsVY9iNm2YwZF/W72gKnWRD+fPNYWpGwuL
         Z7r0lVt6DSqTfiRLp6FxJ/jy9xJU8u1FN9hBZqz308wPv0h3JB04kzgRohXhz+W+dL4+
         fwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q/YanX6EPfx+u+3OMqrYAFeJvrZlkb0TikNUTqVME1Y=;
        b=1RmuQHjLoF4gcew9DCoRJhCuE3oo54nw9KOPEmH92ybgruWPcR6vsH+5pe58NTqeMN
         sRkktFYhy2MStz35bNjxYJkHi9shyt5nmxNF9sH+Pq1m4Y1N/k4VGLRgUJj7yIuxaw6R
         NpErdM2WhLoBgfp8qdEI95t47EQKYcVWPU+8cuYRpkOo/sjaKSEV2ZJPeFtELHR+4iMA
         ifhaczwbxWNFl7z3i8i9n3BumkI0UbS+ARp0ZyHYaNvoVaLOSNonWaIyrUeGRlkQixuj
         Dbq1Knk+dPVzUNi7UmCTp8Az+Iwncgb0jGD1ELJhKmOX3AjZZQF8mBaxzu8BXT/QSVc7
         MMXg==
X-Gm-Message-State: AOAM533u16a4Vvopek749NET5E1ctNayLYBn6D9pmZK//2XGptoz0F1K
        v8n0aekZxjiKaSbYRrx6hALVnlJdQGE=
X-Google-Smtp-Source: ABdhPJwE2z7KVThLseGHNOhepGcvcWOJLfCs0hdmn9Is1cTsX8Yz9n5jIjhtaxYpBfwuDusFcqDN9vQu4DQ=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:685:0:b0:50a:5870:10b1 with SMTP id
 127-20020a620685000000b0050a587010b1mr13751101pfg.61.1650351485348; Mon, 18
 Apr 2022 23:58:05 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:43 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-38-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 37/38] KVM: arm64: selftests: Test with every breakpoint/watchpoint
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
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

Add test cases that uses every breakpoint/watchpoint to the
debug-exceptions test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 70 ++++++++++++++++---
 1 file changed, 59 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 4e00100b9aa1..829fad6c7d58 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -701,7 +701,7 @@ static void check_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
 	}
 }
 
-int main(int argc, char *argv[])
+void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -710,6 +710,8 @@ int main(int argc, char *argv[])
 	uint8_t nbps, nwps;
 	bool debug_reg_test = false;
 
+	pr_debug("%s bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__, bpn, wpn, ctx_bpn);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
@@ -717,11 +719,6 @@ int main(int argc, char *argv[])
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
 	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
-	if (cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT) < 6) {
-		print_skip("Armv8 debug architecture not supported.");
-		kvm_vm_free(vm);
-		exit(KSFT_SKIP);
-	}
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
@@ -742,11 +739,7 @@ int main(int argc, char *argv[])
 	nwps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT) + 1;
 	TEST_ASSERT(nwps >= 2, "Number of watchpoints must be >= 2");
 
-	/*
-	 * Test with breakpoint#0 and watchpoint#0, and the higiest
-	 * numbered breakpoint (the context aware breakpoint).
-	 */
-	vcpu_args_set(vm, VCPU_ID, 4, &debug_regs, 0, 0, nbps - 1);
+	vcpu_args_set(vm, VCPU_ID, 4, &debug_regs, bpn, wpn, ctx_bpn);
 
 	for (stage = 0; stage < 13; stage++) {
 		/* First two stages are sanity debug regs read/write check */
@@ -783,5 +776,60 @@ int main(int argc, char *argv[])
 
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
+	brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	wrps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	ctx_cmps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
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
+	uint64_t aa64dfr0;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	kvm_vm_free(vm);
+
+	if (cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT) < 6) {
+		print_skip("Armv8 debug architecture not supported.");
+		exit(KSFT_SKIP);
+	}
+
+	/* Run debug tests with the default configuration */
+	test_debug(aa64dfr0);
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

