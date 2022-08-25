Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6588E5A19E7
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbiHYT7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243177AbiHYT7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:51 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CA62BE0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ng1-20020a17090b1a8100b001f4f9f69d48so3514975pjb.4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ABuMcVy29eB82eJjWGO3hD95XiPDAjXme8kjZUEgrpQ=;
        b=phgTgTuokNEUWSvf5ISE24pzZGCpAyslvy+1eB8X3x6I5Najg9WFRlDAdbSL5GH/tZ
         SifUb7HCqm5w/8fWeU5UDGKd7DP66ho4f/VdSB9r2yNX5Kq3ZOosLHaq7Ifl/HFx0ts3
         NdKuNb4RJ8UQo7XYpOj+pZoIlxWEJNpaBN/UimbKZ6WilcGhYwc6si5mxjaiA3KIOmhs
         /ZJ7G1xoa1zsyxIwVeT2cZa2JPDAnBJspq+A+SxhMB47ACLbH/S5AfmlIJ33r36ZUI6r
         BuRgoJNHW3g54FMuorUZsWhW/07Y1IkCUe2QquttkMX/AKV0AEPVBN4TlRLMi8WX2XHc
         C9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ABuMcVy29eB82eJjWGO3hD95XiPDAjXme8kjZUEgrpQ=;
        b=ZoYEWdhZFxYcG/OH8gKB3OMBQEBPEAejS16UgMu0eWKlDJOEYnZY4ipqZVtMY66+ax
         xsh9GwAfnvkMsiGH8iihhET8HxTQRQh5V4dzHJT5ENJCX8FVVhRpgCdlBiJFYKGHgwEg
         /XAEDPLoxgmQFddTltvLmCTHQ6docAs+AZ+ZXX+cbY+6nm6xNlvaKfcFdtLL484hSCzO
         ZKRQyk4zOM2yWuqzhJHQ7CMZI05Zmi+8FwQdYJ7Fk5xoGUZ8dgiu4FUmRHHfYhJVODZJ
         oxHPf3sd8rzyHnFLlCrx1iKv09/eF5bT01yUclmQujovplJzOI/K8kY0+f7EwgZWLiOC
         Yrrw==
X-Gm-Message-State: ACgBeo3BAQvrga0ovzH5jjJy2/BzbaVpnctAxOQYsBIxVl8IhDJ/tXzD
        pvnVqFZ3IklA2id2mwvZdgBqJKOVenU=
X-Google-Smtp-Source: AA6agR6hZeUCxOWsKPNccjJFb1GG09KDnJx1CbcM6slmPw1g6bmtijJUWXTq+zHjabLUzQNwXNeW62GwhFM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d0b:0:b0:42a:19dc:e76e with SMTP id
 bf11-20020a656d0b000000b0042a19dce76emr579766pgb.6.1661457589570; Thu, 25 Aug
 2022 12:59:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:38 +0000
In-Reply-To: <20220825195939.3959292-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825195939.3959292-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 4/5] x86/emulator: Test code breakpoint with
 MOV/POP-SS blocking active
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

From: Michal Luczaj <mhal@rbox.co>

Verify that code breakpoints (#DBs) are suppressed on Intel CPUs when
MOV/POP SS blocking is active, and that #DBs are _not_ suppressed on AMD
CPUs.

If forced emulation is available, verify that KVM correctly emulates both
the MOV/POP SS shadow and the resulting interaction with code breakpoints.

Note, properly testing forced emulation on Intel requires instructing KVM
to clear RFLAGS.RF prior to emulating.

Ideally this test would go in debug.c, but POP SS is disallowed in 64-bit
mode and "debug" is a 64-bit only test.  Alternatively, the debug test
could temporarily transition to 32-bit mode, but that relies on the stack
and code being addressable in 32-bit mode, which may not always hold true.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index f91f6e7..a92fc19 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -716,6 +716,79 @@ static void test_illegal_movbe(void)
 	       "Wanted #UD on MOVBE with /reg, got vector = %u", vector);
 }
 
+#ifdef __x86_64__
+#define RIP_RELATIVE "(%%rip)"
+#else
+#define RIP_RELATIVE ""
+#endif
+
+static void handle_db(struct ex_regs *regs)
+{
+	++exceptions;
+	regs->rflags |= X86_EFLAGS_RF;
+}
+
+static void test_mov_pop_ss_code_db(void)
+{
+	handler old_db_handler = handle_exception(DB_VECTOR, handle_db);
+	bool fep_available = is_fep_available();
+	/* On Intel, code #DBs are inhibited when MOV/POP SS blocking is active. */
+	int nr_expected = is_intel() ? 0 : 1;
+
+	write_dr7(DR7_FIXED_1 |
+		  DR7_GLOBAL_ENABLE_DRx(0) |
+		  DR7_EXECUTE_DRx(0) |
+		  DR7_LEN_1_DRx(0));
+
+#define MOV_POP_SS_DB(desc, fep1, fep2, insn, store_ss, load_ss)	\
+({									\
+	unsigned long r;						\
+									\
+	exceptions = 0;							\
+	asm volatile("lea 1f " RIP_RELATIVE ", %0\n\t"			\
+		     "mov %0, %%dr0\n\t"				\
+		     store_ss						\
+		     fep1 load_ss	   				\
+		     fep2 "1: xor %0, %0\n\t"				\
+		     "2:"						\
+		     : "=r" (r)						\
+		     :							\
+		     : "memory");					\
+	report(exceptions == nr_expected && !r,				\
+	       desc ": #DB %s after " insn " SS",			\
+	       nr_expected ? "occurred" : "suppressed");		\
+})
+
+#define MOV_SS_DB(desc, fep1, fep2)					\
+	MOV_POP_SS_DB(desc, fep1, fep2, "MOV",				\
+		      "mov %%ss, %0\n\t", "mov %0, %%ss\n\t")
+
+	MOV_SS_DB("no fep", "", "");
+	if (fep_available) {
+		MOV_SS_DB("fep MOV-SS", KVM_FEP, "");
+		MOV_SS_DB("fep XOR", "", KVM_FEP);
+		MOV_SS_DB("fep MOV-SS/fep XOR", KVM_FEP, KVM_FEP);
+	}
+
+/* PUSH/POP SS are invalid in 64-bit mode. */
+#ifndef __x86_64__
+#define POP_SS_DB(desc, fep1, fep2)					\
+	MOV_POP_SS_DB(desc, fep1, fep2,	"POP",				\
+		      "push %%ss\n\t", "pop %%ss\n\t")
+
+	POP_SS_DB("no fep", "", "");
+	if (fep_available) {
+		POP_SS_DB("fep POP-SS", KVM_FEP, "");
+		POP_SS_DB("fep XOR", "", KVM_FEP);
+		POP_SS_DB("fep POP-SS/fep XOR", KVM_FEP, KVM_FEP);
+	}
+#endif
+
+	write_dr7(DR7_FIXED_1);
+
+	handle_exception(DB_VECTOR, old_db_handler);
+}
+
 int main(void)
 {
 	void *mem;
@@ -762,6 +835,7 @@ int main(void)
 
 	test_string_io_mmio(mem);
 	test_illegal_movbe();
+	test_mov_pop_ss_code_db();
 
 #ifdef __x86_64__
 	test_emulator_64(mem);
-- 
2.37.2.672.g94769d06f0-goog

