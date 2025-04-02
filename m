Return-Path: <kvm+bounces-42498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C36A794FF
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 357141892F88
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6FC1EA7E3;
	Wed,  2 Apr 2025 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsKbkz9l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3BA1E47B3;
	Wed,  2 Apr 2025 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617999; cv=none; b=pPvkiYhnkoFzykrbgP7d3QXtEaCkD/jQC5l2AQaaXoF/FyU0pDUi2pdD0bzVsIeyqBIj/UPDB8+IASMWPorzCTpwAKLNJLf6DGsLmp2ux2AddBRrelSTipgIKE1uERB94Eu8dRh7oQMBtcjGzMfy6F9lO/xms3aM08Wj6jSw2eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617999; c=relaxed/simple;
	bh=64pVMOmaZt9USwQNf+DBb/Pu9LUbJImpmZtbb4tK2zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYYY76Fm/1dlaQ/rYRzBXNTB+IxN10Mjn+ZNvmYgPDGZc9Z14sXHz9H4WB4flVkQgnvu8AFPVtXaGKBS5SzyX6jTjb9kRdCOy0siccuSr2HdIP1ATrmd7kf1E4sZo0OIetTGr2XFLYRZrSJTxNVHOV8ZrMpaPXjju0TzgE5pOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsKbkz9l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE7AC4CEE5;
	Wed,  2 Apr 2025 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743617999;
	bh=64pVMOmaZt9USwQNf+DBb/Pu9LUbJImpmZtbb4tK2zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsKbkz9lz7e46GeGgim4vuzQSKT8jOrS9WzcnLdqW+tuUDtV2rO7Qx3D+6zgODxMn
	 6Ylg7jKfWabo4nTAe1nXk3EuEeAHoENcnQSBb4Yk0ILDOGiIWSYpuW3cj2kVVbhySR
	 tPxKv0QHDGH4otrxYinQVaRAg0iDCIxzA50aKMejYG2TfydFvHvz/IoVrXtt5FVvzg
	 XlGjwnuVNEzj/IMWGPmc7nWOQZLWHXxEN5DS9+A2gFSCBq2FQI+TQZ7dDet3R/MJAV
	 iEHCbnypwrBfM59ThVmWyPjmwA+JIhvWsdtG9iZy4zRA8ab8aSu/BTmTac8EwSzYky
	 2vqDMw32EAv8w==
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
	andrew.cooper3@citrix.com
Subject: [PATCH v3 3/6] x86/bugs: Fix RSB clearing in indirect_branch_prediction_barrier()
Date: Wed,  2 Apr 2025 11:19:20 -0700
Message-ID: <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743617897.git.jpoimboe@kernel.org>
References: <cover.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
set, that doesn't happen.  Make indirect_branch_prediction_barrier()
take that into account by calling __write_ibpb() which already does the
right thing.

Fixes: 50e4b3b94090 ("x86/entry: Have entry_ibpb() invalidate return predictions")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 6 +++---
 arch/x86/kernel/cpu/bugs.c           | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index bbac79cad04c..f99b32f014ec 100644
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
+	asm_inline volatile(ALTERNATIVE("", "call __write_ibpb", X86_FEATURE_IBPB)
+			    : ASM_CALL_CONSTRAINT
+			    :: "rax", "rcx", "rdx", "memory");
 }
 
 /* The Intel SPEC CTRL MSR base value cache */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c8b8dc829046..9f9637cff7a3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,6 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 u32 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
-EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static u64 __ro_after_init x86_arch_cap_msr;
 
-- 
2.48.1


