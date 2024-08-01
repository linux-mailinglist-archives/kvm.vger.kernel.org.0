Return-Path: <kvm+bounces-22915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2142794482A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1728281E43
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98351A0737;
	Thu,  1 Aug 2024 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prNDGtfp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76D170A32;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504149; cv=none; b=Vzq0nNRa+Skpb2PNV6aGmu+cKGdILBQKt1VgR5at05zblbRh3PNq2Y4k+87p28CUi5rpK5/Mtw6hyEZD7lfQ8KoPEPzsLdZB+VqA32ocCdpPBYrFpJXOMi1gwkjtUoyi+6ApNHUrJhqWlaICRN/wWMG1L/DzgnQ3bswzo9m5XKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504149; c=relaxed/simple;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H1mW7+YJKAdXjpNoWfhIq4Flp7L1EvFq3dg4nUkxOovmZITT+TyZWotdLoF5bnBC8KCXEVki/If/MmXS8/7+1RBKqcQybf2NI4AzLdQNN8gmmLIsMoYzzSXgR4QPX2o5nYGZtK+RfxfuhF7GKSPqQJTyzDxWQPVWWFvDFKeKoks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prNDGtfp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F390C4AF0A;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504149;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prNDGtfpoIHxEeRLqY/+u8haVmSW5m3lf4BeWqdBIXrIZTcQU7AfqzLldeg9iBUuD
	 /mLB3z00EfY56P9THu7rRI/yatiM9ok1aSQ4AnKJ+om1IWTJRImTlgBqLxBssNN71T
	 X3EcPpKzpHHX0ZGUk7sQgh4kaQ598lJFZXkXYwM8/6/8xKo0s573J4nk5GHqFqehcf
	 uBrzmFbgpwKC5UV/YQBcJTkTpz/GiZSrGR6+u0/MKL/FQXDxfyHFsuzKs6yHN/htzF
	 cRXGq5M/yNZhUEf3GrFz0aXdr4Aa3uXCV+hd6TPWErkR8jeG/HDfNAfSdBsh9GEgjc
	 rqWhA+mUVi81Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRyb-00HKNZ-3l;
	Thu, 01 Aug 2024 10:20:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 6/8] KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
Date: Thu,  1 Aug 2024 10:19:53 +0100
Message-Id: <20240801091955.2066364-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64FPFR0_EL1 contains all sort of bits that contain a description
of which FP8 subfeatures are implemented.

We don't really care about them, so let's just expose that register
and allow userspace to disable subfeatures at will.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 79d67f19130d..4c2f7c0af537 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2386,7 +2386,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
+	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
 	/* CRm=5 */
 	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-- 
2.39.2


