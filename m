Return-Path: <kvm+bounces-36612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C48ECA1C95B
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 15:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DA541888929
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 14:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E0A1D8DE0;
	Sun, 26 Jan 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfgLN1n/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7261917E7;
	Sun, 26 Jan 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737903037; cv=none; b=cOoWO3cLmTei94sUiPprwj96BdgvG0Fs20bt/orRhIAMtqME/HcHOBO8M38tDGWutJblUdCZ9hwPrNw8gl5Ru4oPPThH/ncPWb4wDAqgMpVw6UfeaelvsYGkkma16jjmjz9YZr3nrPQRvOWfmeKiN0gz4z0vJMO8JVTx+1gFmWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737903037; c=relaxed/simple;
	bh=ZFmvYh3LLqvbDHuT5p9WQdjk62No+mnTGlmqkjr2jXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dO5iQF9euPx2tsH28RCuPwtz12CvcYoPadg4qB+EuKWJ9YqehpsSp47x27LB4nxObXJBkVkz7xr+ZvwWWNoB6/2lFMxJGa5XWtofacON87eueGJda9gLb6Mpmx0cT8pRi/dTj582ZAOk10ILhYw/lwHUI6FyVk9BLkhdzdpGkGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfgLN1n/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5352C4CEE3;
	Sun, 26 Jan 2025 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737903036;
	bh=ZFmvYh3LLqvbDHuT5p9WQdjk62No+mnTGlmqkjr2jXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfgLN1n/NmxAnLaemK5AoMVbnvrSdwlOlIeer411s7V86rWB0aUpbJrcldH8meir7
	 0FlwU952v1gKqkT/V2eoigNE+ipP6vupN3V6gB+4HhJFaqfXBMFw7OMXzegKP6zMtE
	 9UXTVU43B63FtGmPcNX0FKCQWdRhg5myi/BImKWFXSRh2NxFiOvMrdzbxqDqDXmkWo
	 r9ljWkkutdMD2jzsoH7jkxAYLGs0kOu8sX4YSZwt8RyTBainLwLj8ZXb0MkX8Urxl/
	 qkucfabcAbiz1Wnd5YqDMWz7Rg0auXa8Xd0sgePbwrCVpAVTHeDscMW6c9LmfPzV+g
	 vqfw9Jm2LqIVA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.jiang@intel.com,
	kees@kernel.org,
	jgross@suse.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	bhe@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 4/7] x86: Convert unreachable() to BUG()
Date: Sun, 26 Jan 2025 09:50:23 -0500
Message-Id: <20250126145027.925851-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250126145027.925851-1-sashal@kernel.org>
References: <20250126145027.925851-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.11
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2190966fbc14ca2cd4ea76eefeb96a47d8e390df ]

Avoid unreachable() as it can (and will in the absence of UBSAN)
generate fallthrough code. Use BUG() so we get a UD2 trap (with
unreachable annotation).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20241128094312.028316261@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 2 +-
 arch/x86/kernel/reboot.c  | 2 +-
 arch/x86/kvm/svm/sev.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f63f8fd00a91f..15507e739c255 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -838,7 +838,7 @@ void __noreturn stop_this_cpu(void *dummy)
 #ifdef CONFIG_SMP
 	if (smp_ops.stop_this_cpu) {
 		smp_ops.stop_this_cpu();
-		unreachable();
+		BUG();
 	}
 #endif
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 615922838c510..dc1dd3f3e67fc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -883,7 +883,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	if (smp_ops.stop_this_cpu) {
 		smp_ops.stop_this_cpu();
-		unreachable();
+		BUG();
 	}
 
 	/* Assume hlt works */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fb854cf20ac3b..e9af87b128140 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3833,7 +3833,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 		goto next_range;
 	}
 
-	unreachable();
+	BUG();
 }
 
 static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
-- 
2.39.5


