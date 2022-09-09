Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E795B2DB3
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 06:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiIIErS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 00:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiIIErN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 00:47:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090CE10D729
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 21:47:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 184-20020a2507c1000000b00696056767cfso712215ybh.22
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 21:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=MbeYcUZH5rZnv7Srky0s60QQaNvSpZyXF49LSUjvDEA=;
        b=HystTyEzO0y7slgnAoyhgmwyE6//Ptny72kWSKwWDwnF/pewU2YZGmTe4aXKH4BsD9
         tOZCF/pJNqzQMbGFrADdmXjXCQP9EvzOUU4QmcRDcYj0PKa/uqArjk2L8VC51x0vCNoO
         PgY+1uxqASwNnCD/990sGSZL6aehIUh45mhAzNGV95InvmredIbbFxcU/UhevR3DlKdd
         jBZQdIU98NOmjPHQ3GG2KSDMtSP0PZmznTJKoIdfgvWTm491PoCsSbPyh2fU+AwvhvQZ
         M6vOVpJjEVujY6am0l8Vd3XInLJJ/6QY+l3Am8kVuk9XHMmoz0hEwbnH9UrjjsrJX5of
         6Rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=MbeYcUZH5rZnv7Srky0s60QQaNvSpZyXF49LSUjvDEA=;
        b=vehBnNTjwjoipPR1CHigR7v1virXdRshrXYEPevRehogF2LNOWYgllHaogTt9nCioZ
         FZ5+jint3/xFtRp5afQgivWjOqIL/6OdHlI/arulNuyiZ67+O7j7soodZnNEE97/T6gl
         UnraVALYxibOGyJEBgw9CKjVj4XNGvIu8EA7ymegMxB/Vt1JUChHwwqZJicTMqtyaInj
         BGtNL9a3YtTnwE1kWN3kGZU7w/Vi4xhthWjMjuAOWdVc47EIy7gPCSs//Xaezk+APddf
         JtUeWjK10DGDCz+tVCdbFtqdnZ5OA0Mms20MvSVc5roGmVgamtQcnP9jgpHMF/2alAdj
         dy7w==
X-Gm-Message-State: ACgBeo1zMMVsSE/jV5mazHoHZF3SHX1LWw1X5J+Psg7J9jQ96UbrXO1n
        v310aNr6moOgp1Vsojq1lcFBm+ZovLU=
X-Google-Smtp-Source: AA6agR5IWYF7xulqdDWKw4Vild+Gpo9RYX8tS1XQklBJGnd+q0eLLVs/7l2nNFWoVG/E37pxU2HqzDpQBJc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d491:0:b0:6a8:6d1d:465b with SMTP id
 m139-20020a25d491000000b006a86d1d465bmr9986451ybf.64.1662698831044; Thu, 08
 Sep 2022 21:47:11 -0700 (PDT)
Date:   Thu,  8 Sep 2022 21:46:36 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-4-reijiw@google.com>
Subject: [PATCH 3/3] KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
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

Add a test case for KVM_GUESTDBG_SINGLESTEP to the debug-exceptions test.
The test enables single-step execution from userspace, and check if the
exit to userspace occurs for each instruction that is stepped.
Set the default number of the test iterations to a number of iterations
sufficient to always reproduce the problem that the previous patch fixes
on an Ampere Altra machine.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index e6e83b895fd5..947bd201435c 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -22,6 +22,7 @@
 #define SPSR_SS		(1 << 21)
 
 extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char iter_ss_begin, iter_ss_end;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -238,6 +239,46 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
+enum single_step_op {
+	SINGLE_STEP_ENABLE = 0,
+	SINGLE_STEP_DISABLE = 1,
+};
+
+static void guest_code_ss(int test_cnt)
+{
+	uint64_t i;
+	uint64_t bvr, wvr, w_bvr, w_wvr;
+
+	for (i = 0; i < test_cnt; i++) {
+		/* Bits [1:0] of dbg{b,w}vr are RES0 */
+		w_bvr = i << 2;
+		w_wvr = i << 2;
+
+		/* Enable Single Step execution */
+		GUEST_SYNC(SINGLE_STEP_ENABLE);
+
+		/*
+		 * The userspace will veriry that the pc is as expected during
+		 * single step execution between iter_ss_begin and iter_ss_end.
+		 */
+		asm volatile("iter_ss_begin:nop\n");
+
+		write_sysreg(w_bvr, dbgbvr0_el1);
+		write_sysreg(w_wvr, dbgwvr0_el1);
+		bvr = read_sysreg(dbgbvr0_el1);
+		wvr = read_sysreg(dbgwvr0_el1);
+
+		asm volatile("iter_ss_end:\n");
+
+		/* Disable Single Step execution */
+		GUEST_SYNC(SINGLE_STEP_DISABLE);
+
+		GUEST_ASSERT(bvr == w_bvr);
+		GUEST_ASSERT(wvr == w_wvr);
+	}
+	GUEST_DONE();
+}
+
 static int debug_version(struct kvm_vcpu *vcpu)
 {
 	uint64_t id_aa64dfr0;
@@ -293,16 +334,106 @@ static void test_guest_debug_exceptions(void)
 	kvm_vm_free(vm);
 }
 
+void test_single_step_from_userspace(int test_cnt)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	struct kvm_run *run;
+	uint64_t pc, cmd;
+	uint64_t test_pc = 0;
+	bool ss_enable = false;
+	struct kvm_guest_debug debug = {};
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_ss);
+	ucall_init(vm, NULL);
+	run = vcpu->run;
+	vcpu_args_set(vcpu, 1, test_cnt);
+
+	while (1) {
+		vcpu_run(vcpu);
+		if (run->exit_reason != KVM_EXIT_DEBUG) {
+			cmd = get_ucall(vcpu, &uc);
+			if (cmd == UCALL_ABORT) {
+				REPORT_GUEST_ASSERT(uc);
+				/* NOT REACHED */
+			} else if (cmd == UCALL_DONE) {
+				break;
+			}
+
+			TEST_ASSERT(cmd == UCALL_SYNC,
+				    "Unexpected ucall cmd 0x%lx", cmd);
+
+			if (uc.args[1] == SINGLE_STEP_ENABLE) {
+				debug.control = KVM_GUESTDBG_ENABLE |
+						KVM_GUESTDBG_SINGLESTEP;
+				ss_enable = true;
+			} else {
+				debug.control = SINGLE_STEP_DISABLE;
+				ss_enable = false;
+			}
+
+			vcpu_guest_debug_set(vcpu, &debug);
+			continue;
+		}
+
+		TEST_ASSERT(ss_enable, "Unexpected KVM_EXIT_DEBUG");
+
+		/* Check if the current pc is expected. */
+		vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
+		TEST_ASSERT(!test_pc || pc == test_pc,
+			    "Unexpected pc 0x%lx (expected 0x%lx)",
+			    pc, test_pc);
+
+		/*
+		 * If the current pc is between iter_ss_bgin and
+		 * iter_ss_end, the pc for the next KVM_EXIT_DEBUG should
+		 * be the current pc + 4.
+		 */
+		if ((pc >= (uint64_t)&iter_ss_begin) &&
+		    (pc < (uint64_t)&iter_ss_end))
+			test_pc = pc + 4;
+		else
+			test_pc = 0;
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("Usage: %s [-h] [-i iterations of the single step test]\n", name);
+	puts("");
+	exit(0);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
+	int opt;
+	int ss_iteration = 10000;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	__TEST_REQUIRE(debug_version(vcpu) >= 6,
 		       "Armv8 debug architecture not supported.");
 	kvm_vm_free(vm);
+
+	while ((opt = getopt(argc, argv, "i:")) != -1) {
+		switch (opt) {
+		case 'i':
+			ss_iteration = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
 	test_guest_debug_exceptions();
+	test_single_step_from_userspace(ss_iteration);
 
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog

