Return-Path: <kvm+bounces-22819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 797FC94369C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E01B3B22510
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE7616D4D2;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVxlmT2V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EBC16C87E;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454858; cv=none; b=s2INIfuyOhv3inmnSdGU4T4nNMunYH55hJW8nCG1ydq4xSRth7KsztQrSmXsUGw7zbgBwhm5xJ0+pq33CqBo6rvKqtxrzGg3x81Ps9+zfXeGtOqNMf+0FMFjPjwIVtNGw3q1diwhceKJazWcTTCh736o7JK+R9ny5FpLnNTii1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454858; c=relaxed/simple;
	bh=uc/Qe35gZW02M6/sXnL0DztYlbiBUpvo0PQh5rguJxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VWXN1vCvsI3Lb5gLnpKF4sDD38pst6cj14RxqtrlJh811W0xHpd1CnlzF6+kUPu3Hz5WcDMqB5uqrkIcGZOJUqaprxLBp2Q5Ov48y7RV9XUNft4VUHl5DlSttvOeTyhYv7cFJa2ruwwziYUcOkDO3wWFnbHqk0X9xKUjMkzBjVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVxlmT2V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60FBC4AF0C;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454857;
	bh=uc/Qe35gZW02M6/sXnL0DztYlbiBUpvo0PQh5rguJxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVxlmT2VuQHXliEJP3UfQazQ7yt7tpLRgKTkPAJNIVHzsdCaz2lfrwflS+habEhkm
	 fp7xz9DPexmrzuXPT49IDi8z2qlJPVRW1zSgM89gTao2XSiSXnCQoBuEegsv4gllVj
	 9ZA9U8Gyo/uSlCN+YKk5oFibYMuzUEFKAs9gc03jZ3ihcUC2OEvSDOt05+fVzpSwUF
	 wM9Su7egNVZ9+bSCOBY2J+75w3JE8uKE8sjZ0Vm8g+9I4A4sOIdpO3JgzptoTlzWMd
	 GaQB1qU1TvIqZXz3IXAZFPyzAXrwON9qHC+6UI7prbYm3AZsO7Ll+g0iRaEQ/22wck
	 Mo8grdcS5Js4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBv-00H6Gh-Vz;
	Wed, 31 Jul 2024 20:40:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 14/17] KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
Date: Wed, 31 Jul 2024 20:40:27 +0100
Message-Id: <20240731194030.1991237-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Ensure that SCTLR_EL1.EPAN is RES0 when FEAT_PAN3 isn't supported.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 695a1b774250..0c70104c0d1a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1181,6 +1181,14 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
+
+	/* SCTLR_EL1 */
+	res0 = SCTLR_EL1_RES0;
+	res1 = SCTLR_EL1_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
+		res0 |= SCTLR_EL1_EPAN;
+	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
+
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.39.2


