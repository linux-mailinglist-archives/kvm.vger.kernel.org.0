Return-Path: <kvm+bounces-53728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B563B15DF9
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 12:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4BDC7AFAF8
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13819283C9E;
	Wed, 30 Jul 2025 10:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijKPT/Fj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489F28313D;
	Wed, 30 Jul 2025 10:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753870715; cv=none; b=AJtclp9PZCRu08mM9DCSZvRYnUp11hzVOnXJPYlCu/MjX5rastl1uQVS9rPRp3Ky/Bvg7pEzWQmi4MoIgxTOKrcaQU+xkDLH6pkul8QI7fhHzQEGZBkwZzzfGCKNGLG8XY966rhANYwe77tcFAk0otS6M9l8pnNW6+WSTXNTRiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753870715; c=relaxed/simple;
	bh=h+BCO8YJEkpsRKWc/4ALILpB64xdaLoyxakMSh2vtGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VhlIyYQXUOcZ6uIUETRBt96wa5rEJ8+mY0Em4DYLg9VC3aou26SI75Q1QUwhaAuzt5mlbLfUy1WI4d0XRCk/C7992kNzhscxMBPBOiLCfwx78YpqoqPHurbnUASQE6f9RwRHpoY7AtXuGL2eAEogDoaZBSqzJHQ1suqm+0aP7us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijKPT/Fj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986EFC4CEF5;
	Wed, 30 Jul 2025 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753870713;
	bh=h+BCO8YJEkpsRKWc/4ALILpB64xdaLoyxakMSh2vtGI=;
	h=From:To:Cc:Subject:Date:From;
	b=ijKPT/FjvCPMwW2xvWRvp3ml4Xudq1JnOITdsuv4UGHZGWUZh6+WXhPFbZ6eqOGlH
	 aozcZd5fn6+SbDtO8vaRQI7LGuWWLnrVAVNLye9x6RbsvJQkREQSDVsurLFYweZR+Z
	 9eWU0wJhe4YTF5G/vlu9RuDhtHZPr06YTVpncL+BWQ5Yq1xFglzXVMKl3DpDFMwIxy
	 Hd0uoto8dArixjDNdLCv4jOh+gk2toHnyqW0DYdSzUff3Hr7E01hFe+61qYBBXZAUa
	 DCvFhhL70AFI0ohbVEn+Y4adzWZFn28aIqdglM37p/BcnSoesnn1qJutQD/wrYb1z5
	 2SCgZAzls3jWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uh3tH-002aJD-IH;
	Wed, 30 Jul 2025 11:18:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
Date: Wed, 30 Jul 2025 11:18:28 +0100
Message-Id: <20250730101828.1168707-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of checking for the ESR_EL2.VNCR bit being set (the only case
we should be here), we are actually testing random bits in ESR_EL2.DFSC.

13 obviously being a lucky number, it matches both permission and
translation fault status codes, which explains why we never saw it
failing. This was found by inspection, while reviewing a vaguely
related patch.

Whilst we're at it, turn the BUG_ON() into a WARN_ON_ONCE(), as
exploding here is just silly.

Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c6a4e8f384ac6..046dcfc8bf76b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1287,7 +1287,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 
-	BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
+	WARN_ON_ONCE(!(esr & ESR_ELx_VNCR));
 
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
-- 
2.39.2


