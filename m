Return-Path: <kvm+bounces-69885-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCaTFPPwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69885-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E64D9D0474
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0417B304D264
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BD3385514;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VO78txqj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C062F361E;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057821; cv=none; b=F73yHZDur8i1Rmow/h6/uNkbKf2046rWNx2omR4KoDHO6N/o+nImLCYjeFwLbfPO4ICcgHmvLlioJmHfUqq/xabTWXvL5XyXcIBW80r+wecSKuitkBpeqXHSvnSUie3B1vNBiShnXIaqkG4CFNGnosomYeiKZQ4J2qDtf2lPS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057821; c=relaxed/simple;
	bh=cUnL9eI2TSfY3RnxpVHdkNXGQe+TOBMqJnePql0UexQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgImmt7bcoHrmWAODs6I+trh6/SY5cfdZKelFeTcGCVRifxx1rh9l6HJb1yp9+hDf2b1StlQi50CkaJRzuWAb28zFVuBeksAONR8vUj13Jcu7XXToFIIE4D9wnBeBSqA+HTWIGQkfcjFjmNGv3FSyQn3lWk7jOmuMnuxJ+/7OvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VO78txqj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EBEC4AF09;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057821;
	bh=cUnL9eI2TSfY3RnxpVHdkNXGQe+TOBMqJnePql0UexQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VO78txqjV6lePEwq8COso/WXxK2jYKEMnsM87fTD+kYoIzL0fw/eiy3TbF4rKyrFK
	 RU2nJnDL7GBIn7YNn3YEmOn2d9kHcgFyhM6Z9Uwy50w7a3QLq4zotaGLA3d8u1qMQE
	 2TItg7sn3ki1Fk6Pf8F2et2J0EE503gV4VJdMIBGgsuBFtyDrCi+XekiyzT0opPhcQ
	 GLXqnxjU88Zxv5UFD/Q4OvyQdwQhRuxNQ6LpqdNFtbh440Z1s4HeAn6bTQXC1xYPS4
	 4vaHhf9Rt09MY4k5DvpECR8DzlzmEg35/bX9pNMKxai7VmEsR/XqTuZsRhh5n5CwH/
	 xclZx5fb0Hxpw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytf-00000007sAy-1e3n;
	Mon, 02 Feb 2026 18:43:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 03/20] KVM: arm64: Introduce standalone FGU computing primitive
Date: Mon,  2 Feb 2026 18:43:12 +0000
Message-ID: <20260202184329.2724080-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69885-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E64D9D0474
X-Rspamd-Action: no action

Computing the FGU bits is made oddly complicated, as we use the RES0
helper instead of using a specific abstraction.

Introduce such an abstraction, which is going to make things significantly
simpler in the future.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 57 ++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0bcdb39885734..2122599f7cbbd 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1335,26 +1335,30 @@ static u64 compute_res0_bits(struct kvm *kvm,
 static u64 compute_reg_res0_bits(struct kvm *kvm,
 				 const struct reg_feat_map_desc *r,
 				 unsigned long require, unsigned long exclude)
-
 {
 	u64 res0;
 
 	res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
 				 require, exclude);
 
-	/*
-	 * If computing FGUs, don't take RES0 or register existence
-	 * into account -- we're not computing bits for the register
-	 * itself.
-	 */
-	if (!(exclude & NEVER_FGU)) {
-		res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
-		res0 |= ~reg_feat_map_bits(&r->feat_map);
-	}
+	res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
+	res0 |= ~reg_feat_map_bits(&r->feat_map);
 
 	return res0;
 }
 
+static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
+{
+	/*
+	 * If computing FGUs, we collect the unsupported feature bits as
+	 * RES0 bits, but don't take the actual RES0 bits or register
+	 * existence into account -- we're not computing bits for the
+	 * register itself.
+	 */
+	return compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+				 0, NEVER_FGU);
+}
+
 static u64 compute_reg_fixed_bits(struct kvm *kvm,
 				  const struct reg_feat_map_desc *r,
 				  u64 *fixed_bits, unsigned long require,
@@ -1370,40 +1374,29 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 
 	switch (fgt) {
 	case HFGRTR_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hfgrtr_desc,
-					     0, NEVER_FGU);
-		val |= compute_reg_res0_bits(kvm, &hfgwtr_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hfgrtr_desc);
+		val |= compute_fgu_bits(kvm, &hfgwtr_desc);
 		break;
 	case HFGITR_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hfgitr_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hfgitr_desc);
 		break;
 	case HDFGRTR_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hdfgrtr_desc,
-					     0, NEVER_FGU);
-		val |= compute_reg_res0_bits(kvm, &hdfgwtr_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hdfgrtr_desc);
+		val |= compute_fgu_bits(kvm, &hdfgwtr_desc);
 		break;
 	case HAFGRTR_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hafgrtr_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hafgrtr_desc);
 		break;
 	case HFGRTR2_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hfgrtr2_desc,
-					     0, NEVER_FGU);
-		val |= compute_reg_res0_bits(kvm, &hfgwtr2_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hfgrtr2_desc);
+		val |= compute_fgu_bits(kvm, &hfgwtr2_desc);
 		break;
 	case HFGITR2_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hfgitr2_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hfgitr2_desc);
 		break;
 	case HDFGRTR2_GROUP:
-		val |= compute_reg_res0_bits(kvm, &hdfgrtr2_desc,
-					     0, NEVER_FGU);
-		val |= compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
-					     0, NEVER_FGU);
+		val |= compute_fgu_bits(kvm, &hdfgrtr2_desc);
+		val |= compute_fgu_bits(kvm, &hdfgwtr2_desc);
 		break;
 	default:
 		BUG();
-- 
2.47.3


