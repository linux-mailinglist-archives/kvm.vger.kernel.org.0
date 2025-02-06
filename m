Return-Path: <kvm+bounces-37507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE404A2AD08
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A0D87A18C4
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAFE151989;
	Thu,  6 Feb 2025 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kw0aGGmR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFB11F417D;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856985; cv=none; b=iOntVhkXpbAkGi/D8MORvb8YMFKBgnfYLMHk64jWjOiam4f/qA7dcjQWm1HNr/iAnlHmQWzujRgS64WqfzrKepe6PLwmXWLRg74QViyWHKO6nVjJm5Rcz9ul20ChdnwxcAnOissXWtXRUQrAylkM5f7KISkcw5+QyMjs97BqR3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856985; c=relaxed/simple;
	bh=PiAJmk/+rhSy611nT7kwN3d7mOQKY+zFOQfapGlrhW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PrQhVpFFBFRL1XJWdJp/Bv0McVyyikRgAzPlFFXRUtv1aGi+YC01fe5vu7ZHgNiLShl+kEiPihyM7kGbunhntSHM+jFEuS5drnDjc5p/fW9yhwBxtJlLUwL3sHhj2CDLkOxNB8CgBzFU8aM3JacQAV4jp+0WGEbFAKT8xy07dsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kw0aGGmR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5741C4CEE6;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856984;
	bh=PiAJmk/+rhSy611nT7kwN3d7mOQKY+zFOQfapGlrhW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw0aGGmR1PfFstL+vOOc+1zpeDQSMSe3uV+95H+W9KPhritjD6buvClM7jXnh5Snt
	 SyF7x4Qs6b5keXG0kQ9yUMAnBBhcxgI8JbZ/yZ9wC+zADuzNnr33n5qNfFxyiLraM/
	 jAsJb4L4uYj/MKvf0F/zWIcjkJ9Qjiw0Q4mqesnF+Pheim1uGDiPEbSk8dEytD7cMr
	 U1cTEunVMzuRA8jKHPaeRivd/1Q7jNK4BMTQa0kgtRYV8+7CW4hWutpyG11nMxuZ0a
	 tJCFfxKFiQ7TwWKz+1gfd1mCQgv471jAr2uU1q9jKAZ3hYpDTDH6GmJXjt17M0tywx
	 E/9CCfWODw2IQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48N-001BOX-2k;
	Thu, 06 Feb 2025 15:49:43 +0000
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
Subject: [PATCH v3 16/16] KVM: arm64: nv: Fail KVM init if asking for NV without GICv3
Date: Thu,  6 Feb 2025 15:49:25 +0000
Message-Id: <20250206154925.1109065-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
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
index 6063131f84426..fa429b3fd4ac2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2308,6 +2308,13 @@ static int __init init_subsystems(void)
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


