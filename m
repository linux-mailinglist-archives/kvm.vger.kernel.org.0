Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09ED5BB535
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIQBGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIQBGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:06:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7779DB9FA0
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-345188a7247so205679897b3.22
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=vSAVyhq4u4ked+75RMxOFmz9hyvsFzcpaxbyEdlNhRQ=;
        b=j/kC+EPcJBYntAqBP0Aqrkt6xDFsegaWD/ZmXCa3VDTCGnpYhKJKJLwhPo0rT+lLx9
         iYtU2c7fq2cww7WGpLeyTGjevYtklyKjkbe1+Hvuc4c+k77LxH0skV39S5hRT8e9PGbf
         drudQXuKnq/bfJWjM6sdxH232YCZrhHyCLHGSy+DGnb8r9J5a+NKw/C2BzrUU5myUFbc
         jqGRayAtTRihLPd+qKsRUMDaE8fdSyyMyUWeaSoFHQv5pjboIHGmIGB2J8KhB00Qfz2C
         2Gml7/SoLEy8rVQoqV/RZDAJDf+a77Z8EADQoBJYpQnVsg9DhgoSECZhKSSC8RSALhLl
         VEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=vSAVyhq4u4ked+75RMxOFmz9hyvsFzcpaxbyEdlNhRQ=;
        b=7z+TZCa+GG1JLeGjme9x6Z0Ew8LSLWWLjdMQMm8KMdIjDGjdgq2R6AKUPfDArYjsyy
         o6PSyxrutcY7e1/SFMryrSOh0eIvXjMCGau3K69NxOmGq8FnshSnJ5kCOdhFYYqSaHOR
         dGG3/TAQxnKT4nZlatUWdTCGrwhU5CHXvCfe95cGOFtrckR7RnTR+Xv8KBgElXC9kHSv
         gq78gBH5Vl5QD2gF3jBrv003qSXFlj5ZKmuZbo6CidOTnmx3b8NeeJ0zDdV0NaJhPJnV
         bST5+jq+LFY6Td4r5KANpHsntcj1wT1t+rkxDMu62vESUE4D+HQ3OyJyqgiW756Auqfk
         9Iag==
X-Gm-Message-State: ACrzQf394yMhGAtevJ/63E5vuTXwvqT3rTsM1P9DLIcGOzBXkKePhBk3
        9ZBDyinXNtDkczY4017UL945MDkYI3U=
X-Google-Smtp-Source: AMsMyM6KDY96ug0OSKbbC3uFEUYKiw4o02BdQW8tmh3ooObxt8Azn6qGZMMdvxeh69GBQLRHrPi4iSC2wH0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:63c4:0:b0:349:543f:99f3 with SMTP id
 x187-20020a8163c4000000b00349543f99f3mr6570759ywb.392.1663376777646; Fri, 16
 Sep 2022 18:06:17 -0700 (PDT)
Date:   Fri, 16 Sep 2022 18:06:00 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-5-reijiw@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
2.37.3.968.ga6b4b080e4-goog

