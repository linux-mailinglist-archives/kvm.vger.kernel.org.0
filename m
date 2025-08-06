Return-Path: <kvm+bounces-54125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B74A9B1CA25
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6ECF218C4565
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9823829C337;
	Wed,  6 Aug 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQYGADPs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD282882CA;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499390; cv=none; b=DgOZ9qtcv7HYNg3Imx2OWwQW4x+CwtAL0YGOCZuETUn10DCajHhVKyRIoI4LbB7WBow/tpdwFjB91n6VES8Qk/A/a+u8akjhwxtN5EeUGov5W9cyD1uMnQamO7zXhft0G93bHXjvubdV4Dg9cxK6FtV22XFbDdWVH/Bb+Ra82Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499390; c=relaxed/simple;
	bh=MfOSwZwICwBMsU8dfmhBEIgDN6Hz8CPWM/oLKKORo9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hggTnr5BwyExdSD2eOu3x6xUaD+SUjQro6DCN7pQJg4jSZYNy6Issyazwzknxr7cQvJjLP6Hd1rMAz7bbCogHMJD0h6RFH3iAsXUIIrRUp/s9aQ3bc1u0QLdmGr8y+UaRJhMYtay2VfPvaxzj+KFdj2eSHE1X6MY2MbHP0eiVb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQYGADPs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77494C4CEE7;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499390;
	bh=MfOSwZwICwBMsU8dfmhBEIgDN6Hz8CPWM/oLKKORo9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQYGADPs3jfKA0uad7QIDmkXU6PyJboVW0u2FVcQU8JkWGlPOAp4EP5bE9AMOMf91
	 20LSvK6x0UNlRnvUvjdRzv5ubyYzRrOHdQXEwWxuj6Iupr9wyQDrP8HeUpub24Ox9E
	 ORqP2DlJTafoo5lvrkoSqX9AU+hQGBhQIS4i6ptm3Dw4Am5TRHBKU/SP36mv/xN6od
	 6IsiE/NXbYASIDSsOP03wOobVkbw0/TOh9wx2b0P1wYBFSRy2JXjOOB32jd9vgRDb1
	 0npILhuilir7t3Po1zral1N0+ZYL/qf44MHnOYe4Uc/J9vlWEV55FbKpsrEVnoi9as
	 4oAS7LRWrn2pw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRE-004ZQV-Hx;
	Wed, 06 Aug 2025 17:56:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 4/5] KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
Date: Wed,  6 Aug 2025 17:56:14 +0100
Message-Id: <20250806165615.1513164-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806165615.1513164-1-maz@kernel.org>
References: <20250806165615.1513164-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If we have RASv1p1 on the host, advertise it to the guest in the
"canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
the convoluted RAS+RAS_frac method.

Note that this also advertises FEAT_DoubleFault, which doesn't
affect the guest at all, as only EL3 is concerned by this.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4114790024e..66e5a733e9628 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1800,6 +1800,18 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	if (!vcpu_has_sve(vcpu))
 		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
 
+	/*
+	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
+	 * is cleared separately. Note that by advertising RASv1p1 here, we
+	 * implicitly advertise FEAT_DoubleFault. However, since that last
+	 * feature is a pure EL3 feature, this is not relevant for the
+	 * guest, and we save on the complexity.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN)) {
+		val &= ~ID_AA64PFR0_EL1_RAS;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, V1P1);
+	}
+
 	/*
 	 * The default is to expose CSV2 == 1 if the HW isn't affected.
 	 * Although this is a per-CPU feature, we make it global because
-- 
2.39.2


