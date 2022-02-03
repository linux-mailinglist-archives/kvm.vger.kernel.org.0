Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CD4A8A68
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353014AbiBCRmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353004AbiBCRmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:09 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B42DC06173B
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:09 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id o189-20020a6bbec6000000b00604e5f63337so2419331iof.15
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wrgfEfV14EVeGeVBLAsKjtwiGuvuEQxGhzBYOaaTqP4=;
        b=YpzyUoEg7zq/DcVh3KyeU4vERdGA8ReR59CxEznCRJob+oEp3QY3eZ0VWIBhuOBMrr
         t1Bj4upczXAJsjg23H0UQlGn7PuUMxUMi8BnCfkyRMADFajSDMHQIGaFP57BQ4wXw7G5
         GSF1ORFT9coE27YVzmUtB3ha4th1yqtzjz6KjGvoOu/Zy9PMrrOwSOjQUIFbfcuv3Urm
         fb8z8xZQ8TEtnL4YLX+tdae00N4XGnnVaeO1pnTiBfxZRmo+6zKUOYvvSyhc4D0dfjRM
         fWtZ00OZbBqz7pz1CZfMeIB6r5m99pcTN9V3MWn+XMZs+DjbS8hHQhhN6/KJ7SzQCTtW
         vO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wrgfEfV14EVeGeVBLAsKjtwiGuvuEQxGhzBYOaaTqP4=;
        b=fi+RyhVrl4qjZB74Ur4mCkn1plu7yvLOSiZVQ/TQAzCv+gptGvqyYCoH0tj4BCXQ87
         0fsAe3IinX2lzs2X4I9szgF3DKV8BKLA0awQPgH16I6qdE0axLHOVdWewlBPUQuynAoB
         KrPp1eM141Y65ycUVYUpCsKcRKXxl1X4LLe3qjyZ4H4y622TmhDvsvg/jzMKhrugdiHZ
         qJuLtpTi52xy5ELP9X6/8hOGYz5hIBRsryQIJmoHwTv2N++7jMIOcN8pk0B84NO0athY
         fogORRuhH3hcr8A2ocAcCaJxDDwfyvwHKGN4OwgaD+VAR2zQhvgMAxUkwOQ5bZBMX3fr
         y8SA==
X-Gm-Message-State: AOAM532o0UTbDJ4kQ2KK8/tr2Ig//8u4QN4BHkTMUsfqa+Idm+ZDuVIN
        lT21eJ3AiUNzQwsrhmeBl5VPwGQoz2I=
X-Google-Smtp-Source: ABdhPJy86QQxEmk8vHHLHMGD7z7jHF4YL6H2YGYKUKkBCDrOUwuinXMawx6qJjo17l9XbIu4Ypf6lAox+V4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:3045:: with SMTP id
 u5mr17309119jak.105.1643910128871; Thu, 03 Feb 2022 09:42:08 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:59 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-7-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 6/6] selftests: KVM: Test OS lock behavior
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now correctly handles the OS Lock for its guests. When set, KVM
blocks all debug exceptions originating from the guest. Add test cases
to the debug-exceptions test to assert that software breakpoint,
hardware breakpoint, watchpoint, and single-step exceptions are in fact
blocked.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index ea189d83abf7..63b2178210c4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -23,7 +23,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -47,6 +47,14 @@ static void reset_debug_state(void)
 	isb();
 }
 
+static void enable_os_lock(void)
+{
+	write_sysreg(1, oslar_el1);
+	isb();
+
+	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
+}
+
 static void install_wp(uint64_t addr)
 {
 	uint32_t wcr;
@@ -99,6 +107,7 @@ static void guest_code(void)
 	GUEST_SYNC(0);
 
 	/* Software-breakpoint */
+	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
 
@@ -152,6 +161,51 @@ static void guest_code(void)
 	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
 	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
 
+	GUEST_SYNC(6);
+
+	/* OS Lock does not block software-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	sw_bp_addr = 0;
+	asm volatile("sw_bp2: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp2));
+
+	GUEST_SYNC(7);
+
+	/* OS Lock blocking hardware-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	install_hw_bp(PC(hw_bp2));
+	hw_bp_addr = 0;
+	asm volatile("hw_bp2: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, 0);
+
+	GUEST_SYNC(8);
+
+	/* OS Lock blocking watchpoint */
+	reset_debug_state();
+	enable_os_lock();
+	write_data = '\0';
+	wp_data_addr = 0;
+	install_wp(PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, 0);
+
+	GUEST_SYNC(9);
+
+	/* OS Lock blocking single-step */
+	reset_debug_state();
+	enable_os_lock();
+	ss_addr[0] = 0;
+	install_ss();
+	ss_idx = 0;
+	asm volatile("mrs x0, esr_el1\n\t"
+		     "add x0, x0, #1\n\t"
+		     "msr daifset, #8\n\t"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], 0);
+
 	GUEST_DONE();
 }
 
@@ -223,7 +277,7 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	for (stage = 0; stage < 7; stage++) {
+	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vm, VCPU_ID);
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
-- 
2.35.0.263.gb82422642f-goog

