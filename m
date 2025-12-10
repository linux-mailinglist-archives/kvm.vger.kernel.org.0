Return-Path: <kvm+bounces-65666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA9DCB3A5A
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE1E83139099
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F3D329C48;
	Wed, 10 Dec 2025 17:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSOo5WP6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201FE329375;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387833; cv=none; b=iW1mNaGzA86R27WgMDfg81WXNNDLG/aFEvgnU1V65ocApy9UlftovMpcVAfxhrS/J/2fVXC9p48AyQ6gYlYFcKOKHZkl892cwbUTVJilIYWYNJI0SKFyU4ZJghWrI6czivTSo1/EhgvjMwn/SYDgZ6YvosSpUB7BSkVHSC7HA4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387833; c=relaxed/simple;
	bh=J8YgpBDKoIkE30i8e29RJl8Adbc8Y+aT9MBBTzbD6IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek67BpnC7cf4NbVkBfWD2b3YH1A6sMmq4QbjqN7Sx5nkm9ly8O1aDa+0hXIM+gH1J3LkxUsTHbcvKXJd8ADIULCF3oc5GBpE58/MktoxR+iDb2vnqAg77hr72/oAFCXT4AqS6SPaSjoW87tliohZgWWANVcbP1EujiULDZk6W1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSOo5WP6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EE8C19421;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765387832;
	bh=J8YgpBDKoIkE30i8e29RJl8Adbc8Y+aT9MBBTzbD6IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSOo5WP6UKC9vcbq2TY4ukoOt5KHxAYPAv6WNjyJCfIP8kSQPVRYrH0hofInGlZrf
	 7/agm4ByI8aRY/ll+k7QHdWJuzHTXTXfF0w1COYNLfZhT/T7UU5/JccB58vqIhu5cI
	 EtkyaHuVy2ng0vKa1C6XjnZZiZ4EpkySeeY7dx0l+6E8GR7lNhBm56zsSDYPohseTB
	 JgyIJy69gA6m3MAEJuTrkDHc59znOoKvRPMMt/XuTovu+C0fSPhSQt7m+xJWiokghi
	 6PZkR5M0crLR17EEc7etzCiuwcqrNTzj5Xs3R8fLldQMyHHoa4foKRLfi2VqBt0A4L
	 d2vekAW3SyUag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vTO1G-0000000BnnB-34Gm;
	Wed, 10 Dec 2025 17:30:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: [PATCH v2 2/6] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
Date: Wed, 10 Dec 2025 17:30:20 +0000
Message-ID: <20251210173024.561160-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 are currently represented as unordered
enumerations. However, the architecture treats them as Unsigned,
as hinted to by the MRS data:

(FEAT_S2TGran4K <=> (((UInt(ID_AA64MMFR0_EL1.TGran4_2) == 0) &&
		       FEAT_TGran4K) ||
		     (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 2))))

and similar descriptions exist for 16 and 64k.

This is also confirmed by D24.1.3.3 ("Alternative ID scheme used for
ID_AA64MMFR0_EL1 stage 2 granule sizes") in the L.b revision of
the ARM ARM.

Turn these fields into UnsignedEnum so that we can use the above
description more or less literally.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bba..9d388f87d9a13 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2098,18 +2098,18 @@ UnsignedEnum	47:44	EXS
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Enum	43:40	TGRAN4_2
+UnsignedEnum	43:40	TGRAN4_2
 	0b0000	TGRAN4
 	0b0001	NI
 	0b0010	IMP
 	0b0011	52_BIT
 EndEnum
-Enum	39:36	TGRAN64_2
+UnsignedEnum	39:36	TGRAN64_2
 	0b0000	TGRAN64
 	0b0001	NI
 	0b0010	IMP
 EndEnum
-Enum	35:32	TGRAN16_2
+UnsignedEnum	35:32	TGRAN16_2
 	0b0000	TGRAN16
 	0b0001	NI
 	0b0010	IMP
-- 
2.47.3


