Return-Path: <kvm+bounces-42233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1A0A761B9
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14EF33A8193
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35821E3772;
	Mon, 31 Mar 2025 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="D7JCbMeX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F9F1D88D7;
	Mon, 31 Mar 2025 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409454; cv=none; b=RpfdXxbc4bPh4Hcsm12patcrihjZ4hfyT9nWIy83sdRDnPpkHBBvMFt3ZTopZbazJJv5ChW3kE7UGEQfJ2jBJzFDdQOjbcwoFlVOLnWMA1qpFPBBI8hatGj0X4Lkf7L6KNckDS1xGBOQXUz4jCdnRFJqLcKxhF0dpk/1+O49pbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409454; c=relaxed/simple;
	bh=gbh0m3B09/512sJ59MDydTRVOSmVcP06GMLUAWGZ7us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVV/xFBIgjkbBEuOQMPu5tN8CcrSx1LZPuT9Pf4Y5ZGjeMLglD/L2DVrhYCozktoEAKDtIJn4BQoedasytke4B4fpA+FMI/veDilGuuZGXjE9YXbMYEnyUGQ65yRYvnpAGpTQocOv3AIH6ZpZD58rH+ncAdfh5vRY5Syparxses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=D7JCbMeX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp0E3171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp0E3171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409408;
	bh=tIAU2yy9AOedAvkyMYNrk111yRXguMSruNF4FMMzeHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7JCbMeXqweNh4pJPPw3+DgPKkMbuFPHUf0gRRzqUD2N/ecx68NbyfGuhSjPaQoWY
	 mPmtnI1wTz8QnIJupt2R52o2elidYMFxQqTBQit0V10L9BDFmClZT/ppYUt5in2qs4
	 e9j2ZDUURdepMNCTtW+l4EcDMhlQH5vFCF5V7jlR9s/o3tpqLx+Hqmm4jgFgtPgYf1
	 eoMDOqWoJNnyPqToiT5yyUynx2AtKyvNZcR+n2ZUNik3Ln6pveOKPIJCouqGM6x74X
	 1pVyDGySW5ixXeseTIbyEzgsxuHGPcgoTg9cznUx900NH2wgPPUTESijAYougzG4f5
	 SiD+uPwm/kYOQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 14/15] x86/extable: Add support for the immediate form MSR instructions
Date: Mon, 31 Mar 2025 01:22:50 -0700
Message-ID: <20250331082251.3171276-15-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/mm/extable.c | 59 ++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index eb9331240a88..56138c0762b7 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -164,31 +164,54 @@ static bool ex_handler_uaccess(const struct exception_table_entry *fixup,
 	return ex_handler_default(fixup, regs);
 }
 
+#ifdef CONFIG_X86_64
+static const u8 msr_imm_insn_prefix[] = { 0xc4, 0xe7 };
+#endif
+
 static bool ex_handler_msr(const struct exception_table_entry *fixup,
-			   struct pt_regs *regs, bool wrmsr, bool safe, int reg)
+			   struct pt_regs *regs, bool wrmsr, bool safe)
 {
+	/*
+	 * To ensure consistency with the existing RDMSR and WRMSR(NS), the register
+	 * operand of the immediate form MSR access instructions is ALWAYS encoded as
+	 * RAX in <asm/msr.h> for the MSR value to be written or read.
+	 *
+	 * Full decoder for the immediate form MSR access instructions looks overkill.
+	 */
+	bool is_imm_insn;
+	u32 msr;
+	u64 msr_val;
+
+#ifdef CONFIG_X86_64
+	is_imm_insn = !memcmp((void *)regs->ip, msr_imm_insn_prefix, sizeof(msr_imm_insn_prefix));
+#else
+	is_imm_insn = false;
+#endif
+
+	if (is_imm_insn) {
+		u8 *insn = (u8 *)regs->ip;
+
+		msr = insn[5] | (insn[6] << 8) | (insn[7] << 16) | (insn[8] << 24);
+	} else {
+		msr = (u32)regs->cx;
+	}
+
 	if (__ONCE_LITE_IF(!safe && wrmsr)) {
-		pr_warn("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-			(unsigned int)regs->cx, (unsigned int)regs->dx,
-			(unsigned int)regs->ax,  regs->ip, (void *)regs->ip);
+		msr_val = regs->ax;
+		if (!is_imm_insn)
+			msr_val |= (u64)regs->dx << 32;
+
+		pr_warn("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%016llx) at rIP: 0x%lx (%pS)\n",
+			msr, msr_val, regs->ip, (void *)regs->ip);
 		show_stack_regs(regs);
 	}
 
 	if (__ONCE_LITE_IF(!safe && !wrmsr)) {
 		pr_warn("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
-			(unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+			msr, regs->ip, (void *)regs->ip);
 		show_stack_regs(regs);
 	}
 
-	if (!wrmsr) {
-		/* Pretend that the read succeeded and returned 0. */
-		regs->ax = 0;
-		regs->dx = 0;
-	}
-
-	if (safe)
-		*pt_regs_nr(regs, reg) = -EIO;
-
 	return ex_handler_default(fixup, regs);
 }
 
@@ -366,13 +389,13 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		case EX_TYPE_BPF:
 			return ex_handler_bpf(e, regs);
 		case EX_TYPE_WRMSR:
-			return ex_handler_msr(e, regs, true, false, reg);
+			return ex_handler_msr(e, regs, true, false);
 		case EX_TYPE_RDMSR:
-			return ex_handler_msr(e, regs, false, false, reg);
+			return ex_handler_msr(e, regs, false, false);
 		case EX_TYPE_WRMSR_SAFE:
-			return ex_handler_msr(e, regs, true, true, reg);
+			return ex_handler_msr(e, regs, true, true);
 		case EX_TYPE_RDMSR_SAFE:
-			return ex_handler_msr(e, regs, false, true, reg);
+			return ex_handler_msr(e, regs, false, true);
 		case EX_TYPE_WRMSR_IN_MCE:
 			ex_handler_msr_mce(regs, true);
 			break;
-- 
2.49.0


