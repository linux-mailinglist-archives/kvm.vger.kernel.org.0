Return-Path: <kvm+bounces-53395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B32B11171
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0379AE47C9
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A472ED14B;
	Thu, 24 Jul 2025 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="TW5UZUnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15EC2D5A18
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384259; cv=none; b=enezp0nTnZFLgATPbib88bdtFkJ/A/liRRbZeFiSeB88sDLBSD4zi2RyY0Psxye6K/9bRAqGRf7rbqzbQFzp5VG19bIw5oWDSeol/rewjjIkuhDw2ZDKFTA09Log840cBmrPFU/pDntTcdx6rtgyT3UniVW4ghQFouj17BXlJUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384259; c=relaxed/simple;
	bh=K2Ri62l/+JkeTF9bHXgoSBqa2bZzkw/6Y0u2TUy5038=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tKNF2rc+Hdjgrvji3RGi438Lt0aoGU9AFDkIzhfiKH6RW6LvRwDRDmQmAYnT0PMaMPRQdTegy1hjL69e0m8+PGjrhy2qDCNnoEgXUdsS3TYjYuKAG4H36JyzzOKN3DL2yUHbKEP6RTa6dQwr6Lw7+79JK7kL/lMZoLNKtC2DXXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=TW5UZUnW; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a6cdc27438so1213852f8f.2
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384256; x=1753989056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rnBBeg/qAzhOiIhdzdrBZFVad2SalWZ+dk3pQMvokg=;
        b=TW5UZUnWWtgNmMzuMEvDCUGHJMT1+CyzOytM8tuJlCC2OB6Dl3fszGxfjbqG8bMauU
         eWxC850Zo90TNnhOBG4/m5sXvJGQ1AnY7GFmFgTON3z17Id0z4N775+J3lE4zKI95t+v
         9wUcJ99cuU83lOz9R2lPxfkOa+gIXtI/DrVb+I1tuxl5Qc5svEWNE5cpF/AWyjJI3F43
         jut+0AeS6wLhWzS9Qr1RS+aXxZAlC3tDJFTWAuwgND/ciVLavQE1W/Gx8y77qDnoJT4P
         uFMZowJNXM8pbIXobcYWanWOO+pSRzETI78Z/2w+3y8l+R0s1pgAgIZowUuC+vaOokWE
         INvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384256; x=1753989056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7rnBBeg/qAzhOiIhdzdrBZFVad2SalWZ+dk3pQMvokg=;
        b=PkNacbs9AwxttDjiVRo9t3bkjpDHeAZBFPUFbGapb3qtWqCau+Zk5SxuDIDqlFR2/h
         0GHlLpqTTaClGKrRiaR2aZD3pU4Iq40ua4rd6O+MYUdd63Iv8s4BEJ6D1jP22Uybt7J4
         od0yaJ3VnWClllYCbP6N9v2kyxtrlV2aeUPbwLhx9LgtuQdaYmEAG2d/PxPZ8R3ZUoZN
         GzYy3Myj+td/NTn0EjjwOxOA1Yne9xqk2i2KQuswvTnVxsg0vivqX7pl2hbIhGr6NMnn
         c+Bmf5vBVKnhU41GKv/8RL3U9cfBihNNqcTnLJx7FCuXswOIdCZfqHTw95odEmXp9Q/8
         bcUg==
X-Forwarded-Encrypted: i=1; AJvYcCUP3BWuVUIV1NKstGbUvCK/YoHYzraHBcKOQblvyt7QshTDSr2sdg1D65Y8DknenH7dVSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWfoiHnP8xHRa4pkAdLBNGyEDyFR34bfL/VWYvy0JfXLQRN5C9
	GkLk3EcR9p76AsGQ138GiEG3N84vrMp/XdPsWb6bHyp5c8b7BgtRDOaPlrOFNJdkk8c=
X-Gm-Gg: ASbGncuSFEZUdRy54JXALWtUgWs4NAkkCjCIFsmigkuvCVrhsx410LDK0Tg8GhARerj
	l+iiKuyXDgDFSiG2YHKgybRqWK3hHqYFsBT6ZMDz5evy6SVh6btj/7hv3BZ+snB16vMMm1mZncB
	SluKubcch6KSMkGXwW9g4rI7+jgHDBB2OR3dV3YAdI+h+fANtIHFEJXlvmrFud6mnf+3S46wUMU
	CJb7sEG0Ft6pktUyaf8XhIiIlrHpriVTo+SAI6QsukyIwmh7qJyoNZhM5z1gIHa7je98+q2JL5R
	9zEs+X8h4RCQrVr8aZDa/Im+DcdvMNsjUjHdb+q9Y0GL2aGVCb2vykTyzVUAv0wOW27C5+buTUu
	aOacGrCbTGAZo8s/ug3PxcJUh5HU2sZOxnKPWv/Xmw3okO7JWsdDApUEojndY2GBuWx9EBeks02
	xjfdF4p9ZmaEUTDGuD
X-Google-Smtp-Source: AGHT+IGSy/vhcJZltDn+wpTtwnNsidOmpiNdPFwtZ6zPnbfxjWBWG9fa+zBmsvwXNpqQ4ZPLxq/z3A==
X-Received: by 2002:a05:6000:2282:b0:3aa:caea:aa7f with SMTP id ffacd0b85a97d-3b768f2fb02mr6562387f8f.56.1753384255953;
        Thu, 24 Jul 2025 12:10:55 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705378f4sm31118955e9.2.2025.07.24.12.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:10:55 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 3/3] x86/hypercall: Simplify and increase coverage
Date: Thu, 24 Jul 2025 21:10:50 +0200
Message-Id: <20250724191050.1988675-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250724191050.1988675-1-minipli@grsecurity.net>
References: <20250724191050.1988675-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the hypercall tests by always executing both variants and
handle exceptions appropriately.

If the test runs on bare metal, using the wrong instruction, the
exception will be caught and the test still passes.

If the test runs under KVM and a non-native instruction was patched to
the native one, a fitting message will be printed.

The x86-64-specific test for crossing into non-canonical space can also
greatly be simplified by making use of exception table entries.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/hypercall.c | 131 +++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 68 deletions(-)

diff --git a/x86/hypercall.c b/x86/hypercall.c
index a02ee33627a3..2d343fee3632 100644
--- a/x86/hypercall.c
+++ b/x86/hypercall.c
@@ -4,93 +4,88 @@
 #include "alloc_page.h"
 #include "fwcfg.h"
 
-#define KVM_HYPERCALL_INTEL ".byte 0x0f,0x01,0xc1"
-#define KVM_HYPERCALL_AMD ".byte 0x0f,0x01,0xd9"
+#define KVM_HYPERCALL_VMCALL	0x0f,0x01,0xc1	/* Intel */
+#define KVM_HYPERCALL_VMMCALL	0x0f,0x01,0xd9	/* AMD */
 
-static inline long kvm_hypercall0_intel(unsigned int nr)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL_INTEL
-		     : "=a"(ret)
-		     : "a"(nr));
-	return ret;
-}
+#define test_hypercall(type, may_fail) \
+	do {								\
+		const char ref_insn[] = { KVM_HYPERCALL_##type };	\
+		bool extra;						\
+		extern const char hc_##type[];				\
+									\
+		asm volatile goto(ASM_TRY("%l["xstr(fault_##type)"]")	\
+				  xstr(hc_##type) ":\n\t"		\
+				  ".byte " xstr(KVM_HYPERCALL_##type)	\
+				  : /* no outputs allowed */		\
+				  : "a"(-1)				\
+				  : "memory"				\
+				  : fault_##type);			\
+		extra = memcmp(hc_##type, ref_insn, sizeof(ref_insn));	\
+		report(true, "Hypercall via " #type ": OK%s",		\
+		       extra ? " (patched)" : "");			\
+		break;							\
+									\
+	fault_##type:							\
+		extra = exception_vector() != PF_VECTOR &&		\
+			exception_vector() != UD_VECTOR;		\
+		report((may_fail) && !extra,				\
+			"Hypercall via " #type ": %s%s(%u)",		\
+			extra ? "unexpected " : "",			\
+			exception_mnemonic(exception_vector()),		\
+			exception_error_code());			\
+	} while (0)
 
-static inline long kvm_hypercall0_amd(unsigned int nr)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL_AMD
-		     : "=a"(ret)
-		     : "a"(nr));
-	return ret;
-}
-
-
-volatile unsigned long test_rip;
 #ifdef __x86_64__
-extern void gp_tss(void);
-asm ("gp_tss: \n\t"
-	"add $8, %rsp\n\t"            // discard error code
-	"popq test_rip(%rip)\n\t"     // pop return address
-	"pushq %rsi\n\t"              // new return address
-	"iretq\n\t"
-	"jmp gp_tss\n\t"
-    );
+#define NON_CANON_START	(1UL << 47)
 
-static inline int
-test_edge(void)
+static bool test_edge(bool may_fail)
 {
-	test_rip = 0;
-	asm volatile ("movq $-1, %%rax\n\t"			// prepare for vmcall
-		      "leaq 1f(%%rip), %%rsi\n\t"		// save return address for gp_tss
-		      "movabsq $0x7ffffffffffd, %%rbx\n\t"
-		      "jmp *%%rbx; 1:" : : : "rax", "rbx", "rsi");
-	printf("Return from int 13, test_rip = %lx\n", test_rip);
-	return test_rip == (1ul << 47);
+	const char *addr = (void *)(NON_CANON_START - 3);
+	char insn[3] = { addr[0], addr[1], addr[2] };
+
+	static_assert(NON_CANON_START == 0x800000000000UL);
+	asm volatile goto("jmpq *%[addr]; 1:"
+			  ASM_EX_ENTRY("0x7ffffffffffd", "%l[insn_failed]")
+			  ASM_EX_ENTRY("0x800000000000", "1b")
+			  : /* no outputs allowed */
+			  : "a"(-1), [addr]"r"(addr)
+			  : "memory"
+			  : insn_failed);
+	printf("Return from %s(%u) with RIP = %lx%s\n",
+	       exception_mnemonic(exception_vector()), exception_error_code(),
+	       NON_CANON_START, memcmp(addr, insn, 3) ? ", patched" : "");
+	return true;
+
+insn_failed:
+	printf("KVM hypercall failed%s\n",
+	       may_fail ? ", as expected" : " unexpectedly!");
+	return may_fail;
 }
 #endif
 
 int main(int ac, char **av)
 {
-	bool test_vmcall = !no_test_device || is_intel();
-	bool test_vmmcall = !no_test_device || !is_intel();
+	/* VMCALL may be patched by KVM on AMD or fail with #UD on bare metal */
+	test_hypercall(VMCALL, !is_intel());
 
-	if (test_vmcall) {
-		kvm_hypercall0_intel(-1u);
-		printf("Hypercall via VMCALL: OK\n");
-	}
-
-	if (test_vmmcall) {
-		kvm_hypercall0_amd(-1u);
-		printf("Hypercall via VMMCALL: OK\n");
-	}
+	/* VMMCALL may be patched on Intel or fail with #UD in bare metal */
+	test_hypercall(VMMCALL, is_intel());
 
 #ifdef __x86_64__
 	setup_vm();
-	setup_alt_stack();
-	set_intr_alt_stack(13, gp_tss);
 
-	u8 *data1 = alloc_page();
-	u8 *topmost = (void *) ((1ul << 47) - PAGE_SIZE);
+	u8 *topmost = (void *) (NON_CANON_START - PAGE_SIZE);
 
-	install_pte(phys_to_virt(read_cr3()), 1, topmost,
-		    virt_to_phys(data1) | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
+	install_page(current_page_table(), virt_to_phys(alloc_page()), topmost);
 	memset(topmost, 0xcc, PAGE_SIZE);
-	topmost[4093] = 0x0f;
-	topmost[4094] = 0x01;
-	topmost[4095] = 0xc1;
 
-	if (test_vmcall) {
-		report(test_edge(),
-		       "VMCALL on edge of canonical address space (intel)");
-	}
+	memcpy(topmost + PAGE_SIZE - 3, (char []){ KVM_HYPERCALL_VMCALL }, 3);
+	report(test_edge(!is_intel()),
+	       "VMCALL on edge of canonical address space (Intel)");
 
-	topmost[4095] = 0xd9;
-
-	if (test_vmmcall) {
-		report(test_edge(),
-		       "VMMCALL on edge of canonical address space (AMD)");
-	}
+	memcpy(topmost + PAGE_SIZE - 3, (char []){ KVM_HYPERCALL_VMMCALL }, 3);
+	report(test_edge(is_intel()),
+	       "VMMCALL on edge of canonical address space (AMD)");
 #endif
 
 	return report_summary();
-- 
2.30.2


