Return-Path: <kvm+bounces-63956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF63C75BA9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BA6724EDD78
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E433A9C1F;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVRqynxq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A23A9BE0;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659566; cv=none; b=od9FRxpSpcHkJJ67+nWQn/nZKCuej2cN6VTmtD04ifk4QlWCGmjyPUG19SG6A29V8tpX2dSOiMQi6lupjHQpqVCoCRBvFuvrbaQemy8HDZnD4kljNBb0UUB6/VW+h4iztsSgfUFUeNohu+kU9zRFYsTzbd3Y7YpeW0xRnXax8x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659566; c=relaxed/simple;
	bh=UnQ/IIjw8T0EtLazTEnldrHhLchJDlIoYY39GEWerpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfZGoZyGN6f9OQQsbN8FdVqe7tNYoT3C9WRXZuFlHwyEHdI/wQWZazFGTKPMxEXbAGhcI9+pOAk5JvcRziQO2eFgMwuucss8tI3RJQrNaaKgRxZimnfQv88gbjWlqhuuGVnbLNTkbF6WhZ7dnI+eEAG2yRc1oknw4/WZgM2oQWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVRqynxq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E902C4CEF1;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659566;
	bh=UnQ/IIjw8T0EtLazTEnldrHhLchJDlIoYY39GEWerpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVRqynxq9Qj9tCrE4/SNFltdeWxkF62oxHgGl3qGE4A4AWc731CjGYePBtZ0mYpg7
	 jANLQcZFmLhFcYdDNCNcbk8bgpEV4DwZIvUEmVRT8ziVV5HHGeflqVTYso4dtqRtx4
	 ocOD2BGQPntICwTwDt03QWlMJgCIVJl54IGJ8HdbDrkJKXrkybmWiKAVBNl0p6twlJ
	 /Ij56HicvzU1DNpd81GBkY6DTySViEW5etUk4ZCJ4KeDILpdWSdK732ih5o14vCIg5
	 ppB/Ym+McJTIz8UtPpruxxf9VRfUi6zq2kk8gfdS6OaZ/Bi0KT4uCWXZTy5G+R2rGz
	 FCKyiwP1IhIDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pz-00000006y6g-3ult;
	Thu, 20 Nov 2025 17:26:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 41/49] KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
Date: Thu, 20 Nov 2025 17:25:31 +0000
Message-ID: <20251120172540.2267180-42-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make sure G0 is disabled at the point of initialising the GIC.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/lib/arm64/gic_v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 3e4e1a6a4f7c3..5b0fd95c6b48a 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -342,6 +342,8 @@ static void gicv3_cpu_init(unsigned int cpu)
 	/* Set a default priority threshold */
 	write_sysreg_s(ICC_PMR_DEF_PRIO, SYS_ICC_PMR_EL1);
 
+	/* Disable Group-0 interrupts */
+	write_sysreg_s(ICC_IGRPEN0_EL1_MASK, SYS_ICC_IGRPEN1_EL1);
 	/* Enable non-secure Group-1 interrupts */
 	write_sysreg_s(ICC_IGRPEN1_EL1_MASK, SYS_ICC_IGRPEN1_EL1);
 }
-- 
2.47.3


