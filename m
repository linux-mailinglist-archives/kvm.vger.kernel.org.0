Return-Path: <kvm+bounces-57551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F26AEB578C9
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DAF37AEB2C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF3E3002AB;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1JNFNv1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4782FE07E;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936697; cv=none; b=qEgGeXwC3G1NYVuUQoRmhKr6Hk8O41y3UQ1/Nv4Gm9pBQIoAsJBt8G8kqRENIYT+91vIvrDm6+JnX/ca9aO78YphJZAEZqU6T82Ac3Kgy7VPpQCTnmyl2ES/Xh4ycGGBvdAaTe6JtPtQMo/EGM/Zvraszt/1sK0T82UdXHB3vFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936697; c=relaxed/simple;
	bh=mhZ8FtLw1uVJo63UYY9F46ru+KoRuwK839fahTJQtTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oa3wy89SM8szkPL8EBY3+EdvkuqdBKV4i/YAlMEvdwn4yX649Q1qqbGKxFtr4LBkhnRQRL3QN2Wjy4YqY4niqZnpB9+QEZD7G4zTpY/KLAkvsnB9enNdFGeFGdDucq3muL6RTk31XMSwelHaCgeWd99uUspolBcrytvVMv7jfFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1JNFNv1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46108C4CEFB;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=mhZ8FtLw1uVJo63UYY9F46ru+KoRuwK839fahTJQtTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1JNFNv1yOD+9Ejj0uf4Re90iikorvz5K5ZfV+zYMWsfZNMeQ5ZbJTxeZ+hW6Lgz6
	 4x1/EzPxBUjldVTa6N2bx4B8+Wanw5XAWauyxFF0DauyaMngXF9UiGJt1YRW87ZKCz
	 NCJFJubmhlAWiy8A7+5s38JtArfzZXj8TnwvAUuAYgnTpz0TxhRaxKZZdi4By7S9uS
	 V6bm/z8EnI2nHRP8nAY4U7K/AxtJ1ubIrglaMS/jKWrOgyxA+natg3Jlv8xGrOya/E
	 ts5guoJ5ggf+TAB5UgnHipT2JhcTpEmNGD1veJvHfqe8HP9h/5igsxOGM6hTLFzXwK
	 8qI1Ap1BQtx4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7df-00000006MDw-29jP;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 03/16] KVM: arm64: Compute 52bit TTBR address and alignment
Date: Mon, 15 Sep 2025 12:44:38 +0100
Message-Id: <20250915114451.660351-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

52bit addresses from TTBR need extra adjustment and alignment
checks. Implement the requirements of the architecture.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 96452fdc90e2b..e02e467fc2ccd 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -28,6 +28,8 @@ static int get_ia_size(struct s1_walk_info *wi)
 /* Return true if the IPA is out of the OA range */
 static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
 {
+	if (wi->pa52bit)
+		return wi->max_oa_bits < 52 && (ipa & GENMASK_ULL(51, wi->max_oa_bits));
 	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
 }
 
@@ -301,6 +303,16 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
 
 	wi->baddr = ttbr & TTBRx_EL1_BADDR;
+	if (wi->pa52bit) {
+		/*
+		 * Force the alignment on 64 bytes for top-level tables
+		 * smaller than 8 entries, since TTBR.BADDR[5:2] are used to
+		 * store bits [51:48] of the first level of lookup.
+		 */
+		x = max(x, 6);
+
+		wi->baddr |= FIELD_GET(GENMASK_ULL(5, 2), ttbr) << 48;
+	}
 
 	/* R_VPBBF */
 	if (check_output_size(wi->baddr, wi))
-- 
2.39.2


