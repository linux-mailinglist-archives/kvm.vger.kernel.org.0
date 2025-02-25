Return-Path: <kvm+bounces-39156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C19FA448CB
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C6E883D53
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163C421770D;
	Tue, 25 Feb 2025 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s26eJsZ4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F3320F079;
	Tue, 25 Feb 2025 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504588; cv=none; b=K0qZXKEsSSHlKpO5vTW89MIFRg4oWRX6wqQOl5adliGdAAhoHunABpjscl9G+Q5zs/zE7xaddzDGGjzGhoDFqbxMPvhwaUKCczVBZz4xy6pN85bqAVkbuVBH3sV80/FRKXy/7QGHRDPxnoeYwzfbHLswBUjRB0JMWPIOqjULmUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504588; c=relaxed/simple;
	bh=EcrOufC+9HluOly/HaFks9e5qYg1mD0Q7YaQCzKYfj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rw9Lrg5DTgyzfc52bubGG+G9ayOUfos3WAGBXXogDvxEEI/cb0Vz/Zf5K5UfaloC5TwNRwxd0+jv00eyVd5qT7NF6H05sBJJE26W7o7C4BGhsknWizPTOk1rJbVGj/IWiagLG8VSCltyK4iWyCUVlnYdNsZMU2sCJsrc6wkT8t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s26eJsZ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECAC4CEE8;
	Tue, 25 Feb 2025 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504588;
	bh=EcrOufC+9HluOly/HaFks9e5qYg1mD0Q7YaQCzKYfj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s26eJsZ4ZCkUr40JDqjXSQMziL3UsOHOVQ1WIuizgLPCCHPydJaq+ImDk7P25+99M
	 RmVA4tATAqADohH0lvgld1cpUd9UVhhbkcKo+/tRnzxj6JrSl2C4LvPLcUA6dBvSLB
	 rpRwDNFFME4tffYzvNENvm4Vnm6y98isqRBY3HHO+ultJHcIqgehxvhv+pEUzkpnKZ
	 +y0GRXw5YbRdJGv6v6rZEI2GGCJro/gDMfjEBiGwN3SFNi6wWOehbwToC7FgpkVj7k
	 Fb53GYm6pHdMaH4ipVI4l0E55hYZO1WedMutCe4IjppDq7rsY3UWTz30nSlsgkq8bF
	 hDj7mZ0BARaLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmykc-007rKs-TI;
	Tue, 25 Feb 2025 17:29:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 16/16] KVM: arm64: nv: Fail KVM init if asking for NV without GICv3
Date: Tue, 25 Feb 2025 17:29:30 +0000
Message-Id: <20250225172930.1850838-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although there is nothing in NV that is fundamentally incompatible
with the lack of GICv3, there is no HW implementation without one,
at least on the virtual side (yes, even fruits have some form of
vGICv3).

We therefore make the decision to require GICv3, which will only
affect models such as QEMU. Booting with a GICv2 or something
even more exotic while asking for NV will result in KVM being
disabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index dc27eb66d4e90..cae93fac60703 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2321,6 +2321,13 @@ static int __init init_subsystems(void)
 		goto out;
 	}
 
+	if (kvm_mode == KVM_MODE_NV &&
+	   !(vgic_present && kvm_vgic_global_state.type == VGIC_V3)) {
+		kvm_err("NV support requires GICv3, giving up\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Init HYP architected timer support
 	 */
-- 
2.39.2


