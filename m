Return-Path: <kvm+bounces-38300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1993AA36FD3
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7A8E3B0798
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ABF1F3D45;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvE8lp76"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343041E5B94;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=Hdxje1lLw35TcTrHKBwAyO4UnwxJQ1FINHK2dj+jQ+LIV/XOOkkW0cEggGrzeO29ulRQL9ihGY5Y2dR4nS9cPusaz69HCdtbv3qFYAohHGXqR9hf3jGrc8uIVr3yj3CGRvdZdmoan3inOOS+Rgp8SRzIT9pgDnyPfD9dl28Y190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=RvUSEhI6cySQmIz8ZQ/36MwcnMPJHyHB8RpivDDZCT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TH8bn+wPY1cAciaj8bs05y+MsVg0lFZ7bJ0jqgzdR7SG52zehS1w9bxvlx7FwVBtUCkiDsOhjWfIM4FSqGzHPRxQhyPAaLiotNosO9ZqRKjry7tV78XjD08qn7MG1/gVIW+cw9hKYW7n6Wg583LjrulW4qcspb9X5rkR2/tWzBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvE8lp76; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79FDC4CEE9;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641102;
	bh=RvUSEhI6cySQmIz8ZQ/36MwcnMPJHyHB8RpivDDZCT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvE8lp76JHWDIZ+YoLeqobRmcKQlBxX+5GAAEV0eA3N+VacgrFup8o4/C4a9Wq+dn
	 T1VwXkeSPx2m3zIl/q+eoKCvCcFx8kPE7zWXnEzDp++uHS4oAgZiyin3glu7MFhyS5
	 76t2Yhzi2uYpfo8Th87d5PfVKv7rzGbQgHV7KUTtrUlBzYgwnrZ2o28i+DVoUx62+H
	 I5JxNMWeiCF6bMKayAjVDiSRnNW4cybBYoMoKpvfsKz42LYlde189rsTK8ezCvk3R7
	 fY4vdq0X21OWE9Clx4zkY7LXosg6TziYJ+82CD3jnrj9JRo5AgGLyeUSZvzdPHJq/a
	 jRpt5606qc6tA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7Q-004Pqp-Sc;
	Sat, 15 Feb 2025 17:38:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 03/14] KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
Date: Sat, 15 Feb 2025 17:38:05 +0000
Message-Id: <20250215173816.3767330-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Enforce HCR_EL2.E2H being RES0 when VHE is disabled, so that we can
actually rely on that bit never being flipped behind our back.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0c9387d2f5070..ed3add7d32f66 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1034,6 +1034,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= (HCR_TEA | HCR_TERR);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
 		res0 |= HCR_TLOR;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
+		res0 |= HCR_E2H;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
 		res1 |= HCR_E2H;
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
-- 
2.39.2


