Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68C258CC55
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbiHHQrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiHHQrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA802101DA
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v20-20020aa78514000000b0052dbe80d632so4052752pfn.23
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=4lFLZlh9JeLDXYfo5F4rtQ5w1EoxuDdnNMWwds7AxOA=;
        b=CLsyg2KBD15nY3iaPGbnaVmmO9SkjIIwYvNF3hOTUDNwIHC4fXzbfxGqLTuMH/i2kb
         eyaBXdRm1QropFQKtr6/Y7ZzjPDdlq+ax/2z7ObRcfzmY5l5H3KDjL2RFYjxVmwnbRVB
         vuOh0NZY04JvIkqYHFbPTjFTXRrQ7UmxstU30qQmRN88Zy2fYtij+WgcjtvxlgWz4w9Q
         GasdRBSYlSNjrNfXI+x2mX3j388SAQu6sE/UZwlqx32juIxKxig/YEsLKvuZp5BhjtVt
         BdeU7wbeIN95Tc0Itjzt56sc6FzgClSbvrY27QC8FP+xZacweW7Vs1EJv3zSzWmN+S+o
         IcnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=4lFLZlh9JeLDXYfo5F4rtQ5w1EoxuDdnNMWwds7AxOA=;
        b=D5fdvpSywIdGQIEXpUcaaGR9Dx6rj59PWJU/YdUqeZR4sNY+/ltcsg5eS+A6rylLRj
         qvEgl+ufyo0bw/RwEX6Wf72F5NIm7eX//zjKJrCGavmnfF3Y/NjV/2JghI1ghzNqZ4we
         Gk1fXleewuLUSlE+tSuQYfwpLlYYy9pem2W/7sQ0B6E/OYPoIkgN61tQTG+mm+StXfJ3
         97SSD2u1pL7OMtttxx79DqcpfOoV6M42Z2Lyo352QQ4/FMVEJHCj/Z5Cp2LvK1Xa1Zdm
         UNl6vHo7xrc2ykS4YDgfg4g5B4stRBlUjIvYMq62dmLONIRGqI8vcY9AZktgu0yGsTpx
         GpKA==
X-Gm-Message-State: ACgBeo2TmJokppeo4UoIEY4SG7xGHHWK581XlWre39vmfoxNYGlVxkPN
        vpAk0VU2sjMhqjnIIQwXXMjUA7Nxz0s=
X-Google-Smtp-Source: AA6agR63xy56w3xtvtMKcc/TtOhF4qGo5LgDcG7H+BvweIEMjdpjBb9jlD/xcVYv7007GXIid7lK3v9EKH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2294:b0:52e:2371:8bb with SMTP id
 f20-20020a056a00229400b0052e237108bbmr19045559pfe.42.1659977232211; Mon, 08
 Aug 2022 09:47:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:01 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 1/7] x86: emulator.c: Save and restore
 exception handlers
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

Users of handle_exception() should always save and restore the handlers.
Leave the #UD cases alone, they will be handled separately by converting
them to ASM_TRY().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 72 ++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index cd78e3c..769a049 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -710,6 +710,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	void *page2 = (void *)(&bytes[4096]);
 	struct pte_search search;
 	pteval_t orig_pte;
+	handler old;
 
 	// setup memory for unaligned access
 	mem = (uint32_t *)(&bytes[8]);
@@ -725,10 +726,10 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	asm("movupd %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
 	report(sseeq(v, mem), "movupd unaligned");
 	exceptions = 0;
-	handle_exception(GP_VECTOR, unaligned_movaps_handler);
+	old = handle_exception(GP_VECTOR, unaligned_movaps_handler);
 	asm("movaps %1, %0\n\t unaligned_movaps_cont:"
 			: "=m"(*mem) : "x"(vv));
-	handle_exception(GP_VECTOR, 0);
+	handle_exception(GP_VECTOR, old);
 	report(exceptions == 1, "unaligned movaps exception");
 
 	// setup memory for cross page access
@@ -746,10 +747,10 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	invlpg(page2);
 
 	exceptions = 0;
-	handle_exception(PF_VECTOR, cross_movups_handler);
+	old = handle_exception(PF_VECTOR, cross_movups_handler);
 	asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(vv) :
 			"memory");
-	handle_exception(PF_VECTOR, 0);
+	handle_exception(PF_VECTOR, old);
 	report(exceptions == 1, "movups crosspage exception");
 
 	// restore invalidated page
@@ -817,36 +818,38 @@ static void advance_rip_and_note_exception(struct ex_regs *regs)
 
 static void test_mmx_movq_mf(uint64_t *mem)
 {
-    /* movq %mm0, (%rax) */
-    extern char movq_start, movq_end;
+	/* movq %mm0, (%rax) */
+	extern char movq_start, movq_end;
+	handler old;
 
-    uint16_t fcw = 0;  /* all exceptions unmasked */
-    write_cr0(read_cr0() & ~6);  /* TS, EM */
-    exceptions = 0;
-    handle_exception(MF_VECTOR, advance_rip_and_note_exception);
-    asm volatile("fninit; fldcw %0" : : "m"(fcw));
-    asm volatile("fldz; fldz; fdivp"); /* generate exception */
+	uint16_t fcw = 0;  /* all exceptions unmasked */
+	write_cr0(read_cr0() & ~6);  /* TS, EM */
+	exceptions = 0;
+	old = handle_exception(MF_VECTOR, advance_rip_and_note_exception);
+	asm volatile("fninit; fldcw %0" : : "m"(fcw));
+	asm volatile("fldz; fldz; fdivp"); /* generate exception */
 
-    rip_advance = &movq_end - &movq_start;
-    asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
-    /* exit MMX mode */
-    asm volatile("fnclex; emms");
-    report(exceptions == 1, "movq mmx generates #MF");
-    handle_exception(MF_VECTOR, 0);
+	rip_advance = &movq_end - &movq_start;
+	asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
+	/* exit MMX mode */
+	asm volatile("fnclex; emms");
+	report(exceptions == 1, "movq mmx generates #MF");
+	handle_exception(MF_VECTOR, old);
 }
 
 static void test_jmp_noncanonical(uint64_t *mem)
 {
 	extern char nc_jmp_start, nc_jmp_end;
+	handler old;
 
 	*mem = 0x1111111111111111ul;
 
 	exceptions = 0;
 	rip_advance = &nc_jmp_end - &nc_jmp_start;
-	handle_exception(GP_VECTOR, advance_rip_and_note_exception);
+	old = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
 	asm volatile ("nc_jmp_start: jmp *%0; nc_jmp_end:" : : "m"(*mem));
 	report(exceptions == 1, "jump to non-canonical address");
-	handle_exception(GP_VECTOR, 0);
+	handle_exception(GP_VECTOR, old);
 }
 
 static void test_movabs(uint64_t *mem)
@@ -979,22 +982,23 @@ static void ss_bad_rpl(struct ex_regs *regs)
 
 static void test_sreg(volatile uint16_t *mem)
 {
-    u16 ss = read_ss();
+	u16 ss = read_ss();
+	handler old;
 
-    // check for null segment load
-    *mem = 0;
-    asm volatile("mov %0, %%ss" : : "m"(*mem));
-    report(read_ss() == 0, "mov null, %%ss");
+	// check for null segment load
+	*mem = 0;
+	asm volatile("mov %0, %%ss" : : "m"(*mem));
+	report(read_ss() == 0, "mov null, %%ss");
 
-    // check for exception when ss.rpl != cpl on null segment load
-    exceptions = 0;
-    handle_exception(GP_VECTOR, ss_bad_rpl);
-    *mem = 3;
-    asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
-    report(exceptions == 1 && read_ss() == 0,
-           "mov null, %%ss (with ss.rpl != cpl)");
-    handle_exception(GP_VECTOR, 0);
-    write_ss(ss);
+	// check for exception when ss.rpl != cpl on null segment load
+	exceptions = 0;
+	old = handle_exception(GP_VECTOR, ss_bad_rpl);
+	*mem = 3;
+	asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
+	report(exceptions == 1 && read_ss() == 0,
+	       "mov null, %%ss (with ss.rpl != cpl)");
+	handle_exception(GP_VECTOR, old);
+	write_ss(ss);
 }
 
 static uint64_t usr_gs_mov(void)
-- 
2.37.1.559.g78731f0fdb-goog

