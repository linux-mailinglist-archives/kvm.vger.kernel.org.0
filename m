Return-Path: <kvm+bounces-23982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9278F9502B5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C62D91C21AE5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505E919B3C7;
	Tue, 13 Aug 2024 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BfC/dzN/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF019AA43;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545851; cv=none; b=ncw0EVwjLKqReuqUEbpeXBHcLpLunSICvi5Z23Dm/r4xkXzE+Vz+wRRqvHWel3T6fRtQoQ5pyiTeTIOXnJvqjOfe5HPYfIm0+ZxHX85SEILkcrwuW8I1q8kacc3v/TSexpubB0zgxuXbKRj7aVMLuEtFfEJi604IwLzZDsmLolM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545851; c=relaxed/simple;
	bh=mcDksh3U4KLI5FYXHkvHzDVOLwp0prVY32Ojy0Do63s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CDZ2uUluIEVfAjujlglvHp2kYoe8y3Zq2Zn1W6uzHNxRx7c5uxg5Jf9UWBFh0ONqQu3YHFQwJ+ziBp6Abqsz5kd7ah6xpCpll/cS4gqAFVTNN4b3TTjFxJmgBlua0Y99Msmjv+h1vYv3ZUq9R7FcFjHg6kMOQC17JIsXBxCzwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BfC/dzN/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FF0C4AF18;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545850;
	bh=mcDksh3U4KLI5FYXHkvHzDVOLwp0prVY32Ojy0Do63s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfC/dzN/e+su9MZ88MNp39yik96svabW4uzOQhzH5ld/K23H/8iUeLI56Zx+PgOYn
	 ipaNi44Hn+N5LlaqQv3Gl6a5apTpcXTR2UTeFs7f3RU7/0O68eEIWQsBoDM/ld8z7s
	 eKEZxnoa9utQudtYOXYuch9w15gg9GJzxRQupbCE/oLTFafAGrjojgH5Yl3YwR6Rog
	 p15MhntB5QoHGQUzTNQjyBbWeu7UYfnZqguaOxCQbaw2NSkbE0cLh6mqb8ZVPCeRq/
	 8qfNohFygoe3//LfpZGp45zhAv5nO2b/tmaDigarvbdiNr9yh3X3Nd5qedF6aRa4Bq
	 stu3jL3x2qw2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0a-003JD1-UN;
	Tue, 13 Aug 2024 11:44:08 +0100
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
Subject: [PATCH v3 5/8] KVM: arm64: Honor trap routing for FPMR
Date: Tue, 13 Aug 2024 11:43:57 +0100
Message-Id: <20240813104400.1956132-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
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

HCRX_EL2.EnFPM controls the trapping of FPMR (as well as the validity
of any FP8 instruction, but we don't really care about this last part).

Describe the trap bit so that the exception can be reinjected in a
NV guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..ee280239f14f 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -83,6 +83,7 @@ enum cgt_group_id {
 	CGT_CPTR_TAM,
 	CGT_CPTR_TCPAC,
 
+	CGT_HCRX_EnFPM,
 	CGT_HCRX_TCR2En,
 
 	/*
@@ -372,6 +373,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= CPTR_EL2_TCPAC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_HCRX_EnFPM] = {
+		.index		= HCRX_EL2,
+		.value 		= 0,
+		.mask		= HCRX_EL2_EnFPM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 	[CGT_HCRX_TCR2En] = {
 		.index		= HCRX_EL2,
 		.value 		= 0,
@@ -1108,6 +1115,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
 	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
+	SR_TRAP(SYS_FPMR,		CGT_HCRX_EnFPM),
 };
 
 static DEFINE_XARRAY(sr_forward_xa);
-- 
2.39.2


