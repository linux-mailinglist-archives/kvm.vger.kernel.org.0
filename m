Return-Path: <kvm+bounces-31499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E9D9C42C1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B234D1F220B5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCC61A3BC8;
	Mon, 11 Nov 2024 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BB5+8ioJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ADC1A0B13;
	Mon, 11 Nov 2024 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343177; cv=none; b=NGYos0ttCALpIfaOnnEa7LX0RUKcpZZq7Ke+lVkhfiUBQtQNYkvHnUx58m8KAL2I2gUBebp3ZsYOp9DMRHlQgSMQ4eX6M5lsLv25uoQf8Cb34W/+0kxVsfxa+nXdSj2Xi83FQXr3BgXDJacUrWDJMOlPMGnhpRVBKVe/0cqYC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343177; c=relaxed/simple;
	bh=7HDQrOeHzesoq08mXwj6oE4jK5rhJKQzrH8b34Uv2k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CR45blTQ0kgn7zZ2Lxk44H02RIFFxtgGYfO5o5pw0k/ywLrjXCzr14NKWHK59NbLYZrUicc8lSEdVjUrF0tKhIiY69/ToRbiqrrgYdqsXX3m+Aqzw3f+qGjkjJZQbPWcDTfgJ885K7we7rxOlhKLZPgG8Y0OVixlxpSEUJLzcSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BB5+8ioJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C122C4CED7;
	Mon, 11 Nov 2024 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731343176;
	bh=7HDQrOeHzesoq08mXwj6oE4jK5rhJKQzrH8b34Uv2k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB5+8ioJvp+yzp8h3GJLoj/X/aCEDdrslkwehkNhxnVwIQp17Hm7Of1tA+qdosGGp
	 nd4WKni+7IDBguleEa4dPdzpwmpyxUBtblng3ITt2X2ASMMVLSq1vhT0ubeYP6H6m+
	 qVOeFANgJWoQmKPRTFr5uhWu1rMj5QNsEz6HCYFfcNizBr1G6NnV455mAq1tqp/+KJ
	 jHofPd164o6IoPytkZKX+ZKLdVHuiCK22nBzmQegCLGAZ0pqF6dEZfzxZwp8wSwX+u
	 o3/OjESIAZ+7aXuOVSjx6AId92dnrZluHkFAaV3D7uAKt0FMOjh11MCqdRV5T1kMhw
	 jKAO/gcTzLMtA==
From: Amit Shah <amit@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
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
Subject: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for AMD
Date: Mon, 11 Nov 2024 17:39:11 +0100
Message-ID: <20241111163913.36139-2-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241111163913.36139-1-amit@kernel.org>
References: <20241111163913.36139-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

AMD CPUs do not fall back to the BTB when the RSB underflows for RET
address speculation.  AMD CPUs have not needed to stuff the RSB for
underflow conditions.

The RSB poisoning case is addressed by RSB filling - clean up the FIXME
comment about it.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/kernel/cpu/bugs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..0aa629b5537d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1828,9 +1828,6 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    speculated return targets may come from the branch predictor,
 	 *    which could have a user-poisoned BTB or BHB entry.
 	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
-	 *
 	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
 	 *    scenario is mitigated by the IBRS branch prediction isolation
 	 *    properties, so the RSB buffer filling wouldn't be necessary to
@@ -1852,8 +1849,6 @@ static void __init spectre_v2_select_mitigation(void)
 	 *
 	 * So to mitigate all cases, unconditionally fill RSB on context
 	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
-- 
2.47.0


