Return-Path: <kvm+bounces-42497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D46CA794FD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6277D7A4A17
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DE71E3DC9;
	Wed,  2 Apr 2025 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUR80Qwv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854491DDC00;
	Wed,  2 Apr 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617998; cv=none; b=B/CrqBpCWRnXnTLC0XIW4t6YX8bYdGvMKFuusByArC3JKXfzuVxnH7NB4kEDIBuEL/IXux1Ej8/UZaVtiFDaJwbfvdYUt3VrTVfVqAlZHxakdOM+W4rzheSbpBGks4xFulkNiWM0RhY+tW2aExmKynSnmjLNJF4NiCaSZiSi+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617998; c=relaxed/simple;
	bh=2sKV+LntbszUSApWuWeLszgKjAuXSnWw3sW9BSNSr88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmtBClFAfWCG9L5GGY/vdOMaF8U3XHjj1YgsmBf1NFdbL+KQuHt2F/FFsslJ4/lUqzreYYIcNCl5Kr5ILZZq/yZL1Hot1B7PH00ppqjS6KfNl3lqF3pkn6+QS+sKhR1Ev3xrWx0NTg8VAm4THYG/+JDsjQwmGx8JX1Euq29eKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUR80Qwv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B01C4CEED;
	Wed,  2 Apr 2025 18:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743617998;
	bh=2sKV+LntbszUSApWuWeLszgKjAuXSnWw3sW9BSNSr88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUR80Qwv0QUa4PTWjnJLr+XzXm4FC/c98oUILv9lMPZdXhp6jBWeb6y1VpaqfRYO8
	 mJl3gZUj6vbCoJyEZeR/SOIk1R1BS5f5OOZiEhxb8j4Z1eVwWXDKj/6FAGPyzrMLI6
	 bWwbjs2SYF8GMzKDQ2+TdTLa4oS1aS5+l4PouWjiwOZego01LL8cNr0hvsogthDert
	 Dg+C1CeUYt+y/B4Ze3ppCTtYO+gds3pOqlcwlT3xrV3MHdc75YiHDtjc1RDxAa7iwl
	 Quq5GLnWeA96EiflC1sE/QtVOMyl038IG4UdKY3N3nrIXj2Cd0Lzv89XWwYhLjxf6p
	 dLPjZinLyMaEg==
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
Subject: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
Date: Wed,  2 Apr 2025 11:19:19 -0700
Message-ID: <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
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

__write_ibpb() does IBPB, which (among other things) flushes branch type
predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
has been disabled, branch type flushing isn't needed, in which case the
lighter-weight SBPB can be used.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/entry/entry.S     | 2 +-
 arch/x86/kernel/cpu/bugs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 3a53319988b9..a5b421ec19c0 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -21,7 +21,7 @@
 SYM_FUNC_START(__write_ibpb)
 	ANNOTATE_NOENDBR
 	movl	$MSR_IA32_PRED_CMD, %ecx
-	movl	$PRED_CMD_IBPB, %eax
+	movl	_ASM_RIP(x86_pred_cmd), %eax
 	xorl	%edx, %edx
 	wrmsr
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 310cb3f7139c..c8b8dc829046 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
 DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
-u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
+u32 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
 EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static u64 __ro_after_init x86_arch_cap_msr;
-- 
2.48.1


