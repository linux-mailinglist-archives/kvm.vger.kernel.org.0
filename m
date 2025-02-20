Return-Path: <kvm+bounces-38694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53913A3DBA7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40EB619C1816
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256E01FBC84;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqca1ZjH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474D91F6679;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059354; cv=none; b=JOxgMkykWq0N+oiZ9GhvHcZFZKW3aJvIxHMrwM0+M9xDf2MRSeZszx4RcR3vfB/GT+p2om563X47P7KVwR+35j+RL9gEO85IdfpjqcXJvmpREys1mfm7ZFZGum0rwuzztK/3QnMaltVYAGiV2308+r4j7OjOP798HD/ulDEVjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059354; c=relaxed/simple;
	bh=rjDmx4d677pB7gUG89fk/kXGjM99BsbpDijy6LWcIC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SbEjG/C63cqFkcKHVGlnTsFFYV1YHwqJ40E0pb/xWx1oBIB0QzyDfxsp7RQ35W2gdcMdaKD2ZOmyvYQNlxMm8ei4fS2gRZpOWTzRKswZCtaUEFf9z9jMZb9xQ4m7v7ZFLZYr9UTkk32jBiTwBtHgOO5Q5sZbNSaO43+Nmpdlmmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqca1ZjH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E586FC4CEE2;
	Thu, 20 Feb 2025 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059353;
	bh=rjDmx4d677pB7gUG89fk/kXGjM99BsbpDijy6LWcIC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqca1ZjHJifQeRCdQUfJPKSWSC/EHI+DwZr8d2fZR61uuU6s68jwiXODVuxmaU0Ic
	 Wo4lxsmveNR/wmwPA0wnirNV4sx9xaatrSlFPpHYWWXR7bZdHUEt76DnRVeJ58avJi
	 Q/GlDb9GhYjQzUC9OII+dypsmKIdiDjRFQcXJDu+Sa1n6WiZSSeF4qJ0EQvMki9IoH
	 d6CJqzyD35f3tGYUZoq80Q7DriUX1RSGX34fuaM4VnsTUeAjNk7ghAnl5XMk55K/9y
	 BVDmtdwxpaqORtN3p5g6jhLaHACVX8IATZNuYUQV1CDE5DadzbvNJpf2lG3gxFuLJq
	 6FwtFDMd833bQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vQ-006DXp-1P;
	Thu, 20 Feb 2025 13:49:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
Date: Thu, 20 Feb 2025 13:48:55 +0000
Message-Id: <20250220134907.554085-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since our take on FEAT_NV is to only support FEAT_NV2, we should
never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.

Make sure we mask this field for good.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd02..9f10dbd26e348 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		val &= ~ID_AA64MMFR2_EL1_NV;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
 		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
-- 
2.39.2


