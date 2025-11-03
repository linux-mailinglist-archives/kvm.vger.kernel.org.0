Return-Path: <kvm+bounces-61859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB0CC2D49C
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7303018975DE
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B3131AF1B;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9VpH4Tc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE7731987E;
	Mon,  3 Nov 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188927; cv=none; b=sziXnRqUJPI5+UA1kj5GPiz639kCMkpFe+SPpTeI+MT06XKX4qLyOAyxzk0Z1zW7IpT7ltEPBOfOTkBh3VkPOhbwSii290TUKVMG7Tn3DFpkPSFLYoGPoCsXfxJI1DSdDOEkfbxUmjlP5NMwPAx64pmPqhKNElkmSjo1rj4WI/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188927; c=relaxed/simple;
	bh=/GSt2XVw5TKgrkgRLW7hTqPErYsbM430CGm8iWI4aZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssepZtwNePOxWrdI5pGW18uYdTr10RcBxUWjHbH5RtHgz4UkfbNxl4MZgbJ+tZxuwkyeS2s3F0U6advzwCmuM7KK84EIVfDpeJcM5uo8IErTyU+hUD4lSVJGOmkWZ0w6RvQ3uZSn7nmg610ZyzV4dwAvOBrFuPSVjDk0URjALqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9VpH4Tc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCC2C4CEE7;
	Mon,  3 Nov 2025 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188927;
	bh=/GSt2XVw5TKgrkgRLW7hTqPErYsbM430CGm8iWI4aZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9VpH4Tc1GofJU3nn5WlkM6DwqZoHs1qLob6kjcmmwB1GyBjdNn8fPbxU4NPFuadv
	 NOL217IqwR7cC7uucW+SF6HOmB7ZiF777dDm5ysQP3U++141I3mSPpIGBWlsUm19U1
	 5NNepzgr+7sF1ZB0EeQV30+9lrSCQUUVpT+MdY2qo5/x4U0cdUM3SSQqSt0lg5V8Jh
	 /hK8eKhpeOkzM8A/4TTshOwpFODQMFav2nQMIL5fb2BO7z5xLg4sixLNiLsn2c06f4
	 lu5on9tR0Llh3M0xj6nc6VZ6/xecQApqc/HC+ED3EbZVluCsWrHhklaqoZlJiDnzGm
	 fuhleDjZrloZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq0-000000021VN-3l0L;
	Mon, 03 Nov 2025 16:55:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 01/33] irqchip/gic: Add missing GICH_HCR control bits
Date: Mon,  3 Nov 2025 16:54:45 +0000
Message-ID: <20251103165517.2960148-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The GICH_HCR description is missing a bunch of additional control
bits for the maintenance interrupt. Add them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/irqchip/arm-gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 2223f95079ce8..d45fa19f9e470 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -86,7 +86,13 @@
 
 #define GICH_HCR_EN			(1 << 0)
 #define GICH_HCR_UIE			(1 << 1)
+#define GICH_HCR_LRENPIE		(1 << 2)
 #define GICH_HCR_NPIE			(1 << 3)
+#define GICH_HCR_VGrp0EIE		(1 << 4)
+#define GICH_HCR_VGrp0DIE		(1 << 5)
+#define GICH_HCR_VGrp1EIE		(1 << 6)
+#define GICH_HCR_VGrp1DIE		(1 << 7)
+#define GICH_HCR_EOICOUNT		GENMASK(31, 27)
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
-- 
2.47.3


