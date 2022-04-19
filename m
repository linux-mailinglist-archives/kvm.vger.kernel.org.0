Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4131F50653C
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349163AbiDSHBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbiDSHBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:01:15 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12C231DDD
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a4-20020a17090acb8400b001d1d9a6a9f1so5394819pju.5
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kXAUMCFpJ2FSikaWOMOMMVh2xgNlrGhggw5TBv+ypng=;
        b=dOXWqp1IXFvQ5hWm0ELCzHEX1gpvRgjeGAdThxRYIpfqfc997MFB1zkZG8YL59ZBoC
         d9UsOo1qalRiDg7DNheF9RwXIoUFeHGOwj/Znu7oLMD3aUa1QaHsLM5PGGLm/wR3YJIr
         7d+lsvxH8RnTuzg/WbsaWxhNWGFYEsnqv7BDkcxKT60lE1xtPu5pxeGqagUv7J0X8qNU
         6AMv7blXuYpbths6WG0B+OCavNULycBsv3CCgSpipHK543TcXxlzFw+AT0aGIaJPXl/P
         4kokSIXPT3jlr8tRVwnID4hq/n82/sJTZf+LBLYVpLvAvayWrCidsh2fSRoi0n0qwku9
         DuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kXAUMCFpJ2FSikaWOMOMMVh2xgNlrGhggw5TBv+ypng=;
        b=GqmJ3dXBkrLVo17Fwq0FUrxz3oAgyUpB2Bfw+9b4JV5bBoJ9ArM+nvsFhGOycM0BTA
         YWSyTv6VEnUPjT/tyLwylszLcG6wNoZSPo9kWWjzg+AUsA5tmMjgWOGz4gl5DPYJfpxy
         ZUIg0TzyIdfPKwsKVd/g6DgsnCmFZN2uMIs+pT0lNYmtbUftT83ZwzTYQWPOs5bytuy2
         5xAcrUiQuJkVi+XjgKIGIIzdXxIX+HMoYeTqRbnWiFxoQeWa+doIDDckd57l/tWyhfu1
         v+DQBtGbYrrZPZpvX5cL6J7G49xi0kuF5JnKXg6XVsdRcf6vQ0TAvLCY2Kkqo32tJWuI
         xfJg==
X-Gm-Message-State: AOAM531lIOzJAucGy9TjOgaBDm9h2lXVxkexJhVG1kXaLsKzFjSyRfJ+
        qg+MGr1kkJlrKYCvTU2uPUgAOkWfQ2A=
X-Google-Smtp-Source: ABdhPJxa5Wc/c0aBN0VsTih5eeSbcaDGz7OargYMgM2VlUR4Aihe2pGWd+HYKfruhi+RJtilemTj8wdlm8w=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ab43:b0:156:6f38:52b3 with SMTP id
 ij3-20020a170902ab4300b001566f3852b3mr14255343plb.135.1650351482084; Mon, 18
 Apr 2022 23:58:02 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:41 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-36-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 35/38] KVM: arm64: selftests: Test linked breakpoint and watchpoint
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

Add test cases for a linkted breakpoint and watchpoint to the
debug-exceptions test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 225 +++++++++++++++---
 1 file changed, 197 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 63b2178210c4..876257be5960 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -13,25 +13,99 @@
 #define DBGBCR_EXEC	(0x0 << 3)
 #define DBGBCR_EL1	(0x1 << 1)
 #define DBGBCR_E	(0x1 << 0)
+#define DBGBCR_LBN_SHIFT	16
+#define DBGBCR_BT_SHIFT		20
+#define DBGBCR_BT_ADDR_LINK_CTX	(0x1 << DBGBCR_BT_SHIFT)
+#define DBGBCR_BT_CTX_LINK	(0x3 << DBGBCR_BT_SHIFT)
 
 #define DBGWCR_LEN8	(0xff << 5)
 #define DBGWCR_RD	(0x1 << 3)
 #define DBGWCR_WR	(0x2 << 3)
 #define DBGWCR_EL1	(0x1 << 1)
 #define DBGWCR_E	(0x1 << 0)
+#define DBGWCR_LBN_SHIFT	16
+#define DBGWCR_WT_SHIFT		20
+#define DBGWCR_WT_LINK		(0x1 << DBGWCR_WT_SHIFT)
 
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
 static volatile uint64_t ss_addr[4], ss_idx;
 #define  PC(v)  ((uint64_t)&(v))
 
+#define GEN_DEBUG_WRITE_REG(reg_name)			\
+static void write_##reg_name(int num, uint64_t val)	\
+{							\
+	switch (num) {					\
+	case 0:						\
+		write_sysreg(val, reg_name##0_el1);	\
+		break;					\
+	case 1:						\
+		write_sysreg(val, reg_name##1_el1);	\
+		break;					\
+	case 2:						\
+		write_sysreg(val, reg_name##2_el1);	\
+		break;					\
+	case 3:						\
+		write_sysreg(val, reg_name##3_el1);	\
+		break;					\
+	case 4:						\
+		write_sysreg(val, reg_name##4_el1);	\
+		break;					\
+	case 5:						\
+		write_sysreg(val, reg_name##5_el1);	\
+		break;					\
+	case 6:						\
+		write_sysreg(val, reg_name##6_el1);	\
+		break;					\
+	case 7:						\
+		write_sysreg(val, reg_name##7_el1);	\
+		break;					\
+	case 8:						\
+		write_sysreg(val, reg_name##8_el1);	\
+		break;					\
+	case 9:						\
+		write_sysreg(val, reg_name##9_el1);	\
+		break;					\
+	case 10:					\
+		write_sysreg(val, reg_name##10_el1);	\
+		break;					\
+	case 11:					\
+		write_sysreg(val, reg_name##11_el1);	\
+		break;					\
+	case 12:					\
+		write_sysreg(val, reg_name##12_el1);	\
+		break;					\
+	case 13:					\
+		write_sysreg(val, reg_name##13_el1);	\
+		break;					\
+	case 14:					\
+		write_sysreg(val, reg_name##14_el1);	\
+		break;					\
+	case 15:					\
+		write_sysreg(val, reg_name##15_el1);	\
+		break;					\
+	default:					\
+		GUEST_ASSERT(0);			\
+	}						\
+}
+
+/* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
+GEN_DEBUG_WRITE_REG(dbgbcr)
+GEN_DEBUG_WRITE_REG(dbgbvr)
+GEN_DEBUG_WRITE_REG(dbgwcr)
+GEN_DEBUG_WRITE_REG(dbgwvr)
+
+
 static void reset_debug_state(void)
 {
+	uint64_t dfr0 = read_sysreg(id_aa64dfr0_el1);
+	uint8_t brps, wrps, i;
+
 	asm volatile("msr daifset, #8");
 
 	write_sysreg(0, osdlr_el1);
@@ -39,11 +113,19 @@ static void reset_debug_state(void)
 	isb();
 
 	write_sysreg(0, mdscr_el1);
-	/* This test only uses the first bp and wp slot. */
-	write_sysreg(0, dbgbvr0_el1);
-	write_sysreg(0, dbgbcr0_el1);
-	write_sysreg(0, dbgwcr0_el1);
-	write_sysreg(0, dbgwvr0_el1);
+	write_sysreg(0, contextidr_el1);
+
+	/* Reset bcr/bvr/wcr/wvr registers */
+	brps = cpuid_extract_uftr(dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	wrps = cpuid_extract_uftr(dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	for (i = 0; i <= brps; i++) {
+		write_dbgbcr(i, 0);
+		write_dbgbvr(i, 0);
+	}
+	for (i = 0; i <= wrps; i++) {
+		write_dbgwcr(i, 0);
+		write_dbgwvr(i, 0);
+	}
 	isb();
 }
 
@@ -55,14 +137,15 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
-static void install_wp(uint64_t addr)
+static void install_wp(uint8_t wpn, uint64_t addr)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(wcr, dbgwcr0_el1);
-	write_sysreg(addr, dbgwvr0_el1);
+	write_dbgwcr(wpn, wcr);
+	write_dbgwvr(wpn, addr);
+
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -72,14 +155,69 @@ static void install_wp(uint64_t addr)
 	isb();
 }
 
-static void install_hw_bp(uint64_t addr)
+static void install_hw_bp(uint8_t bpn, uint64_t addr)
 {
 	uint32_t bcr;
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(bcr, dbgbcr0_el1);
-	write_sysreg(addr, dbgbvr0_el1);
+	write_dbgbcr(bpn, bcr);
+	write_dbgbvr(bpn, addr);
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+}
+
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
+			   uint64_t ctx)
+{
+	uint32_t wcr;
+	uint64_t ctx_bcr;
+	uint32_t mdscr;
+
+	/* Setup a context-aware breakpoint to be linked by watchpoint */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked watchpoint  */
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E |
+	      DBGWCR_WT_LINK | ((uint32_t)ctx_bp << DBGWCR_LBN_SHIFT);
+	write_dbgwcr(addr_wp, wcr);
+	write_dbgwvr(addr_wp, addr);
+
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+}
+
+void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
+		       uint64_t ctx)
+{
+	uint32_t addr_bcr, ctx_bcr;
+	uint32_t mdscr;
+
+	/* Setup a context-aware breakpoint to be linked by breakpoint */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked breakpoint  */
+	addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		   DBGBCR_BT_ADDR_LINK_CTX |
+		   ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
+	write_dbgbcr(addr_bp, addr_bcr);
+	write_dbgbvr(addr_bp, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -102,8 +240,10 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(void)
+static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
+	uint64_t ctx = 0xc;	/* a random context number */
+
 	GUEST_SYNC(0);
 
 	/* Software-breakpoint */
@@ -115,7 +255,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(hw_bp));
+	install_hw_bp(bpn, PC(hw_bp));
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
@@ -123,7 +263,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
-	install_hw_bp(PC(bp_svc));
+	install_hw_bp(bpn, PC(bp_svc));
 	asm volatile("bp_svc: svc #0");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
@@ -132,7 +272,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(bp_brk));
+	install_hw_bp(bpn, PC(bp_brk));
 	asm volatile("bp_brk: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
@@ -141,7 +281,7 @@ static void guest_code(void)
 
 	/* Watchpoint */
 	reset_debug_state();
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
@@ -175,7 +315,7 @@ static void guest_code(void)
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
-	install_hw_bp(PC(hw_bp2));
+	install_hw_bp(bpn, PC(hw_bp2));
 	hw_bp_addr = 0;
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
@@ -187,7 +327,7 @@ static void guest_code(void)
 	enable_os_lock();
 	write_data = '\0';
 	wp_data_addr = 0;
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
@@ -206,6 +346,28 @@ static void guest_code(void)
 		     : : : "x0");
 	GUEST_ASSERT_EQ(ss_addr[0], 0);
 
+	/* Linked hardware-breakpoint */
+	hw_bp_addr = 0;
+	reset_debug_state();
+	install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	asm volatile("hw_bp_ctx: nop");
+	write_sysreg(0, contextidr_el1);
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
+	GUEST_SYNC(10);
+
+	/* Linked watchpoint */
+	reset_debug_state();
+	install_wp_ctx(wpn, ctx_bpn, PC(write_data), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
 	GUEST_DONE();
 }
 
@@ -240,19 +402,13 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-static int debug_version(struct kvm_vm *vm)
-{
-	uint64_t id_aa64dfr0;
-
-	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
-	return id_aa64dfr0 & 0xf;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
+	uint64_t aa64dfr0;
+	uint8_t max_brps;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
@@ -260,7 +416,8 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	if (debug_version(vm) < 6) {
+	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	if (cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT) < 6) {
 		print_skip("Armv8 debug architecture not supported.");
 		kvm_vm_free(vm);
 		exit(KSFT_SKIP);
@@ -277,6 +434,18 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
+	/* Number of breakpoints, minus 1 */
+	max_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+
+	/* The value of 0x0 is reserved */
+	TEST_ASSERT(max_brps > 0, "ID_AA64DFR0_EL1.BRPS must be > 0");
+
+	/*
+	 * Test with breakpoint#0 and watchpoint#0, and the higiest
+	 * numbered breakpoint (the context aware breakpoint).
+	 */
+	vcpu_args_set(vm, VCPU_ID, 3, 0, 0, max_brps);
+
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vm, VCPU_ID);
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

