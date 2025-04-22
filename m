Return-Path: <kvm+bounces-43775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25193A96181
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2467D17650B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E56E266576;
	Tue, 22 Apr 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="foWRBYLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3A25F986;
	Tue, 22 Apr 2025 08:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310237; cv=none; b=X+dC2kN8GrCOHXGNn2dZH0yYyZUhw1DOwO+FCUhXwoseB+bex7RD6DvXufi2eE/nPzxDscBauax+VH3nQXYEEyOE8NSYT4eivroND83OCXLxaeVv1T4TWijfG6V14dwmBa4rUULlUV4UAJ3oDqpUKqBgFv/J0Sl7oYO0AmnOaLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310237; c=relaxed/simple;
	bh=4I/xnjAU8J5chjPtC3vwg3jYwfZ1NUQyd6ht2XY7zQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8R0vExJQY72MCOjVF15tOlQXo3yoYS8tW5rEUamp7rNBw3XIQ4ppY32XuVtpgOO5CO3Aw/C/3+XykcRJT8lHzrYoBk60molbD1pV6ODHDklHUBTevM8zRdncSK3m4UBpc9C7S/NnViLhAZWL2QrJKDrxAlJ29zsjpWIUjFMGFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=foWRBYLs; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9c1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9c1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310191;
	bh=sK7SiEcLnDzK1DJz1rvdwY9xA/sqvcg2VrbN9TcPHbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foWRBYLsKAd18ivlovmpAbGclkDRxT1gihjkFNepAQkuXKH79JRP4ulwlbvMqwqjP
	 suJQ6v0PsxMNzpKDmTjfE93RTV8V4gdoIR1d3JcQCSVVdKiFQhtivKD6EKhIDH+GvA
	 pmr4R679vcjmvWNhbOk9b+590Omb7eLnU3x+Um/wSBr4mUnyhDNssmAuPp5adjEKNR
	 oZMbEABpZ3jLduPbsg/STQMgOMmdpaBwCIu1MuDUpjSPvSNdVKRkzoakFpe/Lso2Ci
	 xcBEorcc04dH7iKh95hVNKLSN78H46XgSqj4+4Nrve/RjaXkyN82gMV1u86fsqhsvJ
	 +LDnx8McRaOiw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 24/34] x86/mce: Use native MSR API __native_{wr,rd}msrq()
Date: Tue, 22 Apr 2025 01:22:05 -0700
Message-ID: <20250422082216.1954310-25-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use native MSR API __native_{wr,rd}msrq() instead of MSR assemely.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kernel/cpu/mce/core.c | 55 +++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 32286bad75e6..b854a60238de 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -370,13 +370,40 @@ static int msr_to_offset(u32 msr)
 
 void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr)
 {
+	bool imm_insn = is_msr_imm_insn((void *)regs->ip);
+	u32 msr;
+
+	if (imm_insn)
+		/*
+		 * The 32-bit immediate specifying a MSR is encoded into
+		 * byte 5 ~ 8 of an immediate form MSR instruction.
+		 */
+		msr = *(u32 *)(regs->ip + 5);
+	else
+		msr = (u32)regs->cx;
+
 	if (wrmsr) {
-		pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-			 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
-			 regs->ip, (void *)regs->ip);
+		/*
+		 * To maintain consistency with existing RDMSR and WRMSR(NS) instructions,
+		 * the register operand for immediate form MSR instructions is ALWAYS
+		 * encoded as RAX in <asm/msr.h> for reading or writing the MSR value.
+		 */
+		u64 msr_val = regs->ax;
+
+		if (!imm_insn) {
+			/*
+			 * On processors that support the Intel 64 architecture, the
+			 * high-order 32 bits of each of RAX and RDX are ignored.
+			 */
+			msr_val &= 0xffffffff;
+			msr_val |= (u64)regs->dx << 32;
+		}
+
+		pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%016llx) at rIP: 0x%lx (%pS)\n",
+			 msr, msr_val, regs->ip, (void *)regs->ip);
 	} else {
 		pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
-			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+			 msr, regs->ip, (void *)regs->ip);
 	}
 
 	show_stack_regs(regs);
@@ -390,7 +417,7 @@ void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr)
 /* MSR access wrappers used for error injection */
 noinstr u64 mce_rdmsrq(u32 msr)
 {
-	DECLARE_ARGS(val, low, high);
+	u64 val;
 
 	if (__this_cpu_read(injectm.finished)) {
 		int offset;
@@ -414,19 +441,13 @@ noinstr u64 mce_rdmsrq(u32 msr)
 	 * architectural violation and needs to be reported to hw vendor. Panic
 	 * the box to not allow any further progress.
 	 */
-	asm volatile("1: rdmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_RDMSR_IN_MCE)
-		     : EAX_EDX_RET(val, low, high) : "c" (msr));
+	__native_rdmsrq(msr, &val, EX_TYPE_RDMSR_IN_MCE);
 
-
-	return EAX_EDX_VAL(val, low, high);
+	return val;
 }
 
 static noinstr void mce_wrmsrq(u32 msr, u64 v)
 {
-	u32 low, high;
-
 	if (__this_cpu_read(injectm.finished)) {
 		int offset;
 
@@ -441,14 +462,8 @@ static noinstr void mce_wrmsrq(u32 msr, u64 v)
 		return;
 	}
 
-	low  = (u32)v;
-	high = (u32)(v >> 32);
-
 	/* See comment in mce_rdmsrq() */
-	asm volatile("1: wrmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR_IN_MCE)
-		     : : "c" (msr), "a"(low), "d" (high) : "memory");
+	__native_wrmsrq(msr, v, EX_TYPE_WRMSR_IN_MCE);
 }
 
 /*
-- 
2.49.0


