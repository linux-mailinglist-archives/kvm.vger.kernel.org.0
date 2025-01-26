Return-Path: <kvm+bounces-36611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6284A1C928
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 15:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50C91887870
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 14:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D691ACEBD;
	Sun, 26 Jan 2025 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c50Q+6Gq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2091618FDD2;
	Sun, 26 Jan 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737903021; cv=none; b=LAG7dGsiU1S1Se/OMf8UCiAjkNMk7o7J/qBegJ4DhnGp6wxDyrwCrLEmp77bSSWueqaMPBZVa3yW1qbVZ4fQR0mrxL4d0Fo/pv1xhICOepO+Uk89u4IjWAk9IPA2o0BOM9uK793nXV74evLyGeAjSwOlMCNgw6M3Z/Xy9cg1xsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737903021; c=relaxed/simple;
	bh=P7q6vAj/OHBWhRravSdmg+xO1osCi9tXqmcn+W8GvIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iXcjG28FeaI8jusxBrv/FakO7an2DUgVECKy7XO73c3+at2H6+4ETzqQZPIGs9nrp0dVGLiiZIy44fAltakXfk2emqpnN4u0tFhtM2E9itfPlP3bh+s2nDY7HmZR9cS/kZuZTEzrsiegZwq4/aLygS9Uou+SN+ZcxlkR8URqd+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c50Q+6Gq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990BEC4CEE2;
	Sun, 26 Jan 2025 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737903020;
	bh=P7q6vAj/OHBWhRravSdmg+xO1osCi9tXqmcn+W8GvIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c50Q+6GqaqZ+rAQgHYplA0O1J+efNm3dcQHRpJBOe5xOodi5jK5IKNoYdqHVFcZLy
	 PZXNlsq5bIQ08jlyuJm86TZTeZ2W/3nvO7HkKvWGYuE6CdVomBJqV+RuJw2NZO89MD
	 e/Pwmp3QYK5FROWZpaGbWwAoqEWoSoqPwiRCUN1jnfZnURFy42vs+X7ABiqWvOSUgP
	 bp6B+CSIxPiDwB+T5rtNKUJ0B3XnqBBhCCfQMlyJZ0UR7H1fCPKiyw2tPmHumqMYV2
	 f1nRi3mLZ4pJHN1w31Ysdi2E8EJ55yWmrYOA2NbepVpwz4YnBFJrJX8ucV2RvKBBKe
	 xVR5q4O+b00mQ==
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
	jikos@kernel.org,
	kirill.shutemov@linux.intel.com,
	jgross@suse.com,
	kees@kernel.org,
	kai.huang@intel.com,
	bhe@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 4/7] x86: Convert unreachable() to BUG()
Date: Sun, 26 Jan 2025 09:50:07 -0500
Message-Id: <20250126145011.925720-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250126145011.925720-1-sashal@kernel.org>
References: <20250126145011.925720-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13
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
index 943bd074a5d37..fe6cc763fd518 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3820,7 +3820,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 		goto next_range;
 	}
 
-	unreachable();
+	BUG();
 }
 
 static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
-- 
2.39.5


