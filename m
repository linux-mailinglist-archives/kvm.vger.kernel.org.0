Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A95A085B
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiHYFKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiHYFK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FB09E699
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:23 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33580e26058so325518627b3.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=kxLW5pptbGK2qbSRXgRbfDO7jFprojIfxGB+rGiWcTI=;
        b=TTmEHdzamfoOJUzNzm8Oy4Aow3rD92Al5+1R2DqMO26AK3Iz4grwp1RtDbumrf8xkW
         vsT7LLxK98H4odQgelDUKsgICKCya5ytR7QT6h/NtaLeuyjITnTzHzt1i7NCa/YrNPg+
         XOGQ4TkDWJSNJDvJEFcTNGBVtFVRbuCzwm8V//Hgy1+FwzbTR0JjN5lBhfwJZ8sr7qKF
         H1IErCcBG3gH3cAIkMekez3RKhqDctBKkPP2XKe3uhDpz1NVml3OXTukWPqrUW/W0iaC
         8ZTIMJwuOP2mnGj/aKyLUV7FldBwW0xDJY5oWw07wg9ObBsK9Mqahy5glh4Z3NcIMECO
         tEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=kxLW5pptbGK2qbSRXgRbfDO7jFprojIfxGB+rGiWcTI=;
        b=zbbTHqr6sF4ulELVZ1dJQIyb6dwUcNrF3OZ0R1yNAqoZc40sUSBgQlwJ99FZqKnF+H
         I9UntiXk+008ABIaO9maO5ek+dhCfKlKFJNN0vIKuq8n4ngE1SCV3Y5BxbhCC7oW88yf
         7Em/R2wnSL3QZ6pyLZG8c5kg0nNR8Th1sTWfM4eax7YBzbZ80AUL/sPfGKwlwmQVoges
         xFbu0vkYDDxGHdMA1I1NB0C3fv6xoC50W8qoE606sb7wDYZbTGJ4qnXwdGvvWb06W7In
         7yUBtXGv8UBM/sWHqmte2iBA24+2qca9f4Cp3VeDtt7oNWwhdORNvR8YY2WUfd9Kw0D+
         km4g==
X-Gm-Message-State: ACgBeo1bPvZBAlICcUQ0ol5IxQAtPUGXzOyBItOzyUqS9A7/o4ukwpkz
        5dQ4GyRyPsrzVBz///Srssch5wEUDiM=
X-Google-Smtp-Source: AA6agR4v58RhDrq7Qj6EPYCwT6qLMkj11qqXbbiW+fQsLer7Qtwo+aBr5+w+lCO4r/ZJHQlHtnOL8Wya50c=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:349:0:b0:324:d932:1362 with SMTP id
 70-20020a810349000000b00324d9321362mr2226472ywd.281.1661404223276; Wed, 24
 Aug 2022 22:10:23 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:44 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-8-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked breakpoint
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

Currently, the debug-exceptions test doesn't have a test case for
a linked breakpoint. Add a test case for the linked breakpoint to
the test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index ab8860e3a9fa..9fccfeebccd3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -11,6 +11,10 @@
 #define DBGBCR_EXEC	(0x0 << 3)
 #define DBGBCR_EL1	(0x1 << 1)
 #define DBGBCR_E	(0x1 << 0)
+#define DBGBCR_LBN_SHIFT	16
+#define DBGBCR_BT_SHIFT		20
+#define DBGBCR_BT_ADDR_LINK_CTX	(0x1 << DBGBCR_BT_SHIFT)
+#define DBGBCR_BT_CTX_LINK	(0x3 << DBGBCR_BT_SHIFT)
 
 #define DBGWCR_LEN8	(0xff << 5)
 #define DBGWCR_RD	(0x1 << 3)
@@ -21,7 +25,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -103,6 +107,7 @@ static void reset_debug_state(void)
 	isb();
 
 	write_sysreg(0, mdscr_el1);
+	write_sysreg(0, contextidr_el1);
 
 	/* Reset all bcr/bvr/wcr/wvr registers */
 	dfr0 = read_sysreg(id_aa64dfr0_el1);
@@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_debug_bwp_exception();
 }
 
+void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
+		       uint64_t ctx)
+{
+	uint32_t addr_bcr, ctx_bcr;
+
+	/* Setup a context-aware breakpoint */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked breakpoint (linked to the context-aware breakpoint) */
+	addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		   DBGBCR_BT_ADDR_LINK_CTX |
+		   ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
+	write_dbgbcr(addr_bp, addr_bcr);
+	write_dbgbvr(addr_bp, addr);
+	isb();
+
+	enable_debug_bwp_exception();
+}
+
 static void install_ss(void)
 {
 	uint32_t mdscr;
@@ -177,8 +204,10 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(uint8_t bpn, uint8_t wpn)
+static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
+	uint64_t ctx = 0x1;	/* a random context number */
+
 	GUEST_SYNC(0);
 
 	/* Software-breakpoint */
@@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
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
+
+	GUEST_SYNC(10);
+
 	GUEST_DONE();
 }
 
@@ -327,6 +369,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 	uint64_t aa64dfr0;
+	uint8_t brps;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -349,8 +392,16 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Run tests with breakpoint#0 and watchpoint#0. */
-	vcpu_args_set(vcpu, 2, 0, 0);
+	/* Number of breakpoints, minus 1 */
+	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
+
+	/*
+	 * Run tests with breakpoint#0 and watchpoint#0, and the higiest
+	 * numbered (context-aware) breakpoint.
+	 */
+	vcpu_args_set(vcpu, 3, 0, 0, brps);
+
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
 
-- 
2.37.1.595.g718a3a8f04-goog

