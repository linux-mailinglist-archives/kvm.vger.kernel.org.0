Return-Path: <kvm+bounces-62465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 356B6C44425
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EF2F34E9D05
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810213126C4;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfDvxsOL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E573311956;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708600; cv=none; b=S/M3SZGMYiFX1DcHcYkQ5lwxR6DkxCPtEbJjJtXyeV04pGQ37J3DhR3u+LHhCE2t0cdAKl9fdom8Tn3tvSuMZUp6+K/moPqoptU3wIMTcqEqxVaR18F0fw6yH1MZUXmJOT6IZ3dK3BorZ0yERadvUktITw46VXXYcZkZZvvxyjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708600; c=relaxed/simple;
	bh=yCGc4NjwNDiVZR7+j2n7RKZ3zFae6MLydrXdq+o2Jsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTFPZQ4sUVSzb9mbATRyC/YJk1RvVA9UpxDqkwmYrlXF2VAykWAh/llfaErTnXJ1gM+SpMg62W9TybswOeZROCcluXwTjnNrKocagDf/P0nAW7934ykS3hCGRlJj+Iok86gZzS2D2XLR7cV9OVEQY6fdWz/en7TNlJmyuFUp8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfDvxsOL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78407C19423;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708600;
	bh=yCGc4NjwNDiVZR7+j2n7RKZ3zFae6MLydrXdq+o2Jsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfDvxsOLie7nQPjsPwt8mfGeoQE7c6FRFDLWuMHLfu/7UHsCWuz2iO2NYWnxEdOBn
	 PT5RnDPIdubZySmK7FcpQcmzJWDK+fs5qAHR89KsyNvSjv6/bvXDbLDwZBi0oezajG
	 cI4BWFDxXVKlYDj4xdnj3IRkXdBH4vP8yQyU9IFpqkF05kZ7Pu5Xs9rduGqHqdJkJg
	 gpLGsJRyvVC2Paigv4zE4ZI8g3xCJ/s2wx4r6HzskdgfTCXFISFiP214gifGAWBZb7
	 87XFSKPEVhtePvGjxXc493Sjn/I3yXfx9Aod6OM8ZUyavmd/z9OJAunzyQa6b/hCDv
	 xfpbb9osuLxrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91q-00000003exw-2Oel;
	Sun, 09 Nov 2025 17:16:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 42/45] KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
Date: Sun,  9 Nov 2025 17:16:16 +0000
Message-ID: <20251109171619.1507205-43-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When EOImode==1, perform the deactivation in the order of activation,
just to make things a bit worse for KVM. Yes, I'm nasty.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 9d4761f1a3204..72f7bb0d201e5 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -400,8 +400,18 @@ static void test_inject_preemption(struct test_args *args,
 			continue;
 
 		gic_set_eoi(intid);
-		if (args->eoi_split)
-			gic_set_dir(intid);
+	}
+
+	if (args->eoi_split) {
+		for (i = 0; i < num; i++) {
+			intid = i + first_intid;
+
+			if (exclude && test_bit(i, exclude))
+				continue;
+
+			if (args->eoi_split)
+				gic_set_dir(intid);
+		}
 	}
 
 	local_irq_enable();
-- 
2.47.3


