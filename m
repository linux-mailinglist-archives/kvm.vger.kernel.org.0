Return-Path: <kvm+bounces-40626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B312A5943D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 095BB3A9705
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8395229B16;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFo+pTKP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214F227E99;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609513; cv=none; b=dscTdq1vU53YsF28UJuWHmpzZYURseymRMss5okoJcKcZH1jGqfo36ADRhVPzXO84M9wpIcAeRbTKG4HonvWqUXtkM7I8Xwa2BgX2UgncFuNQFoQjmbmFIQ2P0vFG4q7pzp5R4HeACR+cghIGEh3tebjkxTCrUAFDevNG8snFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609513; c=relaxed/simple;
	bh=mNrZXrOFxAD4Z5DMKCnS/i5RqN2sl0u4OwioMTMgDQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=br6hRof31iv02Eyw4yOCkXmoJOSQSgGpeAvxxaG6A5oBN7mqauuXQS99AjINo6gPOWAN8bEEyMTdrvfmH/se+21TsL423QE0jsUSXIehvK4vP5o/YBpLTp4fcdzPioBEDooe0sJy1iQIsQ14nEqwBdhbpH3ydkgN76O2JsM2Xh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFo+pTKP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70094C4CEEF;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609513;
	bh=mNrZXrOFxAD4Z5DMKCnS/i5RqN2sl0u4OwioMTMgDQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFo+pTKPU+5a3Bv1p1X7f/NU55wTW8a2akMZ6VYXs6M5ZESz2/GeiZZV+5an59Rz+
	 x0g263V8WfkomM0kKVDqvZSvmD9g4o+ss+pLmC7cfQuZIn15aKLDHN7zG1WliPECNX
	 G/WYFTX9ntPldZXIHMURYEpsc7ko5O+K9FKF+lpLC7akA1GELhQF5SC3cizm0/cXLY
	 /HqUEJ2PwulwLHqmphtisyCM80LM7Fc02gVYMkw8k1leVc8pLQPMTxDAI/pDOzEhNV
	 I7pu5qGFnCzIQwlNnXwTNbAu6xNuoo3aXuGRSUw51YLE+ndLMK6+wZ+TeSouFlZVVz
	 88aznrCAkTqDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBz-00CAea-Kx;
	Mon, 10 Mar 2025 12:25:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 07/23] KVM: arm64: Don't treat HCRX_EL2 as a FGT register
Date: Mon, 10 Mar 2025 12:24:49 +0000
Message-Id: <20250310122505.2857610-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Treating HCRX_EL2 as yet another FGT register seems excessive, and
gets in a way of further improvements. It is actually simpler to
just be explicit about the masking, so just to that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 23bbe28eaaf95..927f27badf758 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -261,12 +261,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		u64 hcrx = vcpu->arch.hcrx_el2;
 		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
-			u64 clr = 0, set = 0;
-
-			compute_clr_set(vcpu, HCRX_EL2, clr, set);
-
-			hcrx |= set;
-			hcrx &= ~clr;
+			u64 val = __vcpu_sys_reg(vcpu, HCRX_EL2);
+			hcrx |= val & __HCRX_EL2_MASK;
+			hcrx &= ~(~val & __HCRX_EL2_nMASK);
 		}
 
 		write_sysreg_s(hcrx, SYS_HCRX_EL2);
-- 
2.39.2


