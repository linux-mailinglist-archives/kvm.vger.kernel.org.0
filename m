Return-Path: <kvm+bounces-42966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23280A817DB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DD8D166BCA
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80CA2566EE;
	Tue,  8 Apr 2025 21:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tByGsQBS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CBB2561AE;
	Tue,  8 Apr 2025 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148884; cv=none; b=f4prFI1BYrgmieqSWJzcNfX+8YDLVSln5u77p1M2A2wRuGRqZSO3wqZoigjjdHMOM9uPxAg0X5nqY9eO2HwUpJwiFfid35Helue5BbrVncPxwc1A7BE+OIflbqUqdasEnnPR8YyXeVO9FwDwaYs54JPuVwLfzBtSBo56dabiSxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148884; c=relaxed/simple;
	bh=jtDn5lvMdPKcaILPMUvjPxidtTLj5M8OyY+mn2giY+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLbaRNQJ0rj/LqsHSKyaMIFmfuWa5LJK2eS6FdO0N6zsLHvlb5J0kBRgHKto7VQBiWkysb3A89aB+S91zxvjuDWUAKdmZIcPdi4L+xS1+on4I582sCJenI5bg9nxUpD4UOvXwLX23xQMB7dme7wSderyUrVozrBAYtrttRHCb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tByGsQBS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5842C4CEEE;
	Tue,  8 Apr 2025 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744148884;
	bh=jtDn5lvMdPKcaILPMUvjPxidtTLj5M8OyY+mn2giY+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tByGsQBS3VqYkhhHTiA/L5hIqpro4Df2oDemWXuxyQts+DiwPTay1Gv3jxYJ0bXQf
	 zWulpJEEXFjEt46REjrBxb+8H02zqgAur0Ej+GAdmjiCJNJDCp0aQmagR8LDsuwAXT
	 F4Nq9rp7le5fc3ZxpNq3SHZNTdCU6pJfX/pR86AYJ9OYE0KvvGLGFG/nVbafecadyW
	 e7zXNuKbCG71tBFmk5uVHo8Qa3dPBuYA1YovNszuDxuA5a6HvIaWNWbv4QxXz4i3Dl
	 YiKvx9cF/QwfUZLZ/ahGHyGDEr2ST1Qdd8cBRi2OATjSmtYeK90n6kQK1TY+ePQI0j
	 whYEmoa3CE9NQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.comm,
	nik.borisov@suse.com
Subject: [PATCH v4 3/6] x86/bugs: Fix RSB clearing in indirect_branch_prediction_barrier()
Date: Tue,  8 Apr 2025 14:47:32 -0700
Message-ID: <bba68888c511743d4cd65564d1fc41438907523f.1744148254.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744148254.git.jpoimboe@kernel.org>
References: <cover.1744148254.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
set, that doesn't happen.  Make indirect_branch_prediction_barrier()
take that into account by calling write_ibpb() which clears RSB on
X86_BUG_IBPB_NO_RET:

 	/* Make sure IBPB clears return stack preductions too. */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET

Note that, as of the previous patch, write_ibpb() also reads
'x86_pred_cmd' in order to use SBPB when applicable:

	movl	_ASM_RIP(x86_pred_cmd), %eax

Therefore that existing behavior in indirect_branch_prediction_barrier()
is not lost.

Fixes: 50e4b3b94090 ("x86/entry: Have entry_ibpb() invalidate return predictions")
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 6 +++---
 arch/x86/kernel/cpu/bugs.c           | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 591d1dbca60a..5c43f145454d 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -514,11 +514,11 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
 		: "memory");
 }
 
-extern u64 x86_pred_cmd;
-
 static inline void indirect_branch_prediction_barrier(void)
 {
-	alternative_msr_write(MSR_IA32_PRED_CMD, x86_pred_cmd, X86_FEATURE_IBPB);
+	asm_inline volatile(ALTERNATIVE("", "call write_ibpb", X86_FEATURE_IBPB)
+			    : ASM_CALL_CONSTRAINT
+			    :: "rax", "rcx", "rdx", "memory");
 }
 
 /* The Intel SPEC CTRL MSR base value cache */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 608bbe6cf730..99265098d045 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,6 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
-EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static u64 __ro_after_init x86_arch_cap_msr;
 
-- 
2.49.0


