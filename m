Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079F6543F5E
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiFHWpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbiFHWp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:45:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4018A250E5A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 15:45:26 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x29-20020a056a000bdd00b0051c0902c1f3so6097895pfu.20
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 15:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=odWASXlloDi60XXoBrlzFlyWsT1m7IgRF4ZHI9ifXSg=;
        b=SUBOFoIgf90Txf8Nz+beruQQ7cYKBDZ5tsjoZOqGJh1/Q0jvMXGaS4vpnsOIZz8VxJ
         gT9pu9+SO4R/r0xtsSmlALrI7SKB3YIKrPA/PT49ihp/SB8mXiw4pCO92iJronG3x2FU
         qljTMX9E1Jalg3CUVPFGkprKD5TqpksWSKRWBGet0tVbkz5tqrleQ+KXrAxwmKIiCzrr
         MiVGCGdQxQk60JH9TNj6SvKUJVdhGDW1S5puZEPmpp3LyRFfmkwOHd5pRVlnbT9GR3+D
         fRyzFzZaFM935hzwsARKC/2VdWqPSK2DjuXovvDDsuGgcUulyEa5Y7qXFpAw2QZCpJ/Q
         Y4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=odWASXlloDi60XXoBrlzFlyWsT1m7IgRF4ZHI9ifXSg=;
        b=l6gOPhAavqtnaWaDIj3qNagGU1haSLBXowsvq0KuE5hthZrtjmrpstmetN38/5L5fC
         Pvr+MukQ6j+oHwSvvdpscWE4lvihReF9UOgyWiHAa2eXXwODWZCLlErwrvSKpLfFUFYT
         Via3DmA24DaJp1KBFuFzepYnhRIqUGTTahvl4nTXI9QtzzdYjVLTaUB8d4tT4LVabo1e
         9Ukk8pp6BZtQQhtgxRq5xDDVdy/8MKXSqYqDuX5fn6mZQ51mZ6UB60CX/PDVeZjoUVLC
         8hm7K73TcQcl4kI312I2f+T718WpgpTpBKGd4x9HbbdREQuSntzV4QqtrmVyitRQ2TIj
         Pj6Q==
X-Gm-Message-State: AOAM530K32J6YACz4lyIUa5o+0a7yWiq0y6S3xcpkYgWTY6jx9+7H2w6
        dGlMkEfsekgnVPi+kdrlnA1gGzS/2ac=
X-Google-Smtp-Source: ABdhPJzQaZNHK6o2xZ0ojhjwS0+2ugBghUe638w9x98DctunKZduCh6I6F4eCzJI9Q7xdgEtohDcq89DJSw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:594c:0:b0:3fd:9b8b:863d with SMTP id
 j12-20020a63594c000000b003fd9b8b863dmr18078697pgm.250.1654728325763; Wed, 08
 Jun 2022 15:45:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 22:45:15 +0000
In-Reply-To: <20220608224516.3788274-1-seanjc@google.com>
Message-Id: <20220608224516.3788274-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220608224516.3788274-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 4/5] KVM: selftests: Use exception fixup for #UD/#GP Hyper-V
 MSR/hcall tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use exception fixup to verify VMCALL/RDMSR/WRMSR fault as expected in the
Hyper-V Features test.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 117 +++++-------------
 1 file changed, 33 insertions(+), 84 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 5ec40422d72a..0de13ab38e8b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -15,75 +15,20 @@
 
 #define LINUX_OS_ID ((u64)0x8100 << 48)
 
-extern unsigned char rdmsr_start;
-extern unsigned char rdmsr_end;
-
-static u64 do_rdmsr(u32 idx)
-{
-	u32 lo, hi;
-
-	asm volatile("rdmsr_start: rdmsr;"
-		     "rdmsr_end:"
-		     : "=a"(lo), "=c"(hi)
-		     : "c"(idx));
-
-	return (((u64) hi) << 32) | lo;
-}
-
-extern unsigned char wrmsr_start;
-extern unsigned char wrmsr_end;
-
-static void do_wrmsr(u32 idx, u64 val)
-{
-	u32 lo, hi;
-
-	lo = val;
-	hi = val >> 32;
-
-	asm volatile("wrmsr_start: wrmsr;"
-		     "wrmsr_end:"
-		     : : "a"(lo), "c"(idx), "d"(hi));
-}
-
-static int nr_gp;
-static int nr_ud;
-
-static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
-			    vm_vaddr_t output_address)
-{
-	u64 hv_status;
-
-	asm volatile("mov %3, %%r8\n"
-		     "vmcall"
-		     : "=a" (hv_status),
-		       "+c" (control), "+d" (input_address)
-		     :  "r" (output_address)
-		     : "cc", "memory", "r8", "r9", "r10", "r11");
-
-	return hv_status;
-}
-
-static void guest_gp_handler(struct ex_regs *regs)
-{
-	unsigned char *rip = (unsigned char *)regs->rip;
-	bool r, w;
-
-	r = rip == &rdmsr_start;
-	w = rip == &wrmsr_start;
-	GUEST_ASSERT(r || w);
-
-	nr_gp++;
-
-	if (r)
-		regs->rip = (uint64_t)&rdmsr_end;
-	else
-		regs->rip = (uint64_t)&wrmsr_end;
-}
-
-static void guest_ud_handler(struct ex_regs *regs)
-{
-	nr_ud++;
-	regs->rip += 3;
+static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
+				vm_vaddr_t output_address, uint64_t *hv_status)
+{
+	uint8_t vector;
+
+	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
+	asm volatile("mov %[output_address], %%r8\n\t"
+		     KVM_ASM_SAFE("vmcall")
+		     : "=a" (*hv_status),
+		       "+c" (control), "+d" (input_address),
+		       KVM_ASM_SAFE_OUTPUTS(vector)
+		     : [output_address] "r"(output_address)
+		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
+	return vector;
 }
 
 struct msr_data {
@@ -101,31 +46,33 @@ struct hcall_data {
 
 static void guest_msr(struct msr_data *msr)
 {
+	uint64_t ignored;
+	uint8_t vector;
+
 	GUEST_ASSERT(msr->idx);
 
-	WRITE_ONCE(nr_gp, 0);
 	if (!msr->write)
-		do_rdmsr(msr->idx);
+		vector = rdmsr_safe(msr->idx, &ignored);
 	else
-		do_wrmsr(msr->idx, msr->write_val);
+		vector = wrmsr_safe(msr->idx, msr->write_val);
 
 	if (msr->available)
-		GUEST_ASSERT(READ_ONCE(nr_gp) == 0);
+		GUEST_ASSERT_2(!vector, msr->idx, vector);
 	else
-		GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
+		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
 	GUEST_DONE();
 }
 
 static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
+	uint8_t vector;
 
 	GUEST_ASSERT(hcall->control);
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
-	nr_ud = 0;
 	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
 		input = pgs_gpa;
 		output = pgs_gpa + 4096;
@@ -133,12 +80,14 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 		input = output = 0;
 	}
 
-	res = hypercall(hcall->control, input, output);
+	vector = hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected)
-		GUEST_ASSERT(nr_ud == 1);
+		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
 	else
-		GUEST_ASSERT(res == hcall->expect);
+		GUEST_ASSERT_2(!vector, hcall->control, vector);
 
+	GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
+			hcall->expect, res);
 	GUEST_DONE();
 }
 
@@ -190,7 +139,6 @@ static void guest_test_msrs_access(void)
 
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
-		vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 		run = vcpu->run;
 
@@ -499,8 +447,9 @@ static void guest_test_msrs_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
-				  __FILE__, uc.args[1]);
+			TEST_FAIL("%s at %s:%ld, MSR = %lx, vector = %lx",
+				  (const char *)uc.args[0], __FILE__,
+				  uc.args[1], uc.args[2], uc.args[3]);
 			return;
 		case UCALL_DONE:
 			break;
@@ -531,7 +480,6 @@ static void guest_test_hcalls_access(void)
 
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
-		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 
 		/* Hypercall input/output */
 		hcall_page = vm_vaddr_alloc_pages(vm, 2);
@@ -672,8 +620,9 @@ static void guest_test_hcalls_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
-				  __FILE__, uc.args[1]);
+			TEST_FAIL("%s at %s:%ld, arg1 = %lx, arg2 = %lx",
+				  (const char *)uc.args[0], __FILE__,
+				  uc.args[1], uc.args[2], uc.args[3]);
 			return;
 		case UCALL_DONE:
 			break;
-- 
2.36.1.255.ge46751e96f-goog

