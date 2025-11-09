Return-Path: <kvm+bounces-62460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E052C4443D
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9AFD3B7647
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D253112B2;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="on/FfC/5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3DE30FF03;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708599; cv=none; b=o7AJw8bL+GVCoGSIaVTCmTjNmmKwJubhKqBKeqym4uy99alpWBKhGyXfoaoAOdb3955YsGDxrG2YvcRXCzSjV69x+qI4RxT2rNUZdb1U45gGdqLHzfuLI6sPHwvPOJMstcXBzTD1WidqlZ8/dL+fOpy1VEXiT2gDZkR2DRsK5u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708599; c=relaxed/simple;
	bh=Y2YjeqWLlbOpUJdMaswzmZChqewck/ZmHDILc7SWEwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm/AD9LZirsayEb4sgM5EW6MGhX86Zaq8qL3HN5emipV6VOyoyvgrBYPtelqplXkpMK0mEZfrujsVtBduIRvqFoDTK/FxCaZvYgkkUa/Yg5684HlGgsytwV88B2DJSFPgtdnLIm87k8+Fps4p3nwQzTl+UwoUb0hYAVW5RHu5to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=on/FfC/5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD62C4CEFB;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708599;
	bh=Y2YjeqWLlbOpUJdMaswzmZChqewck/ZmHDILc7SWEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on/FfC/5iuinafoBjgBCmiGRg73s4UnnwGG6EG8FaovQnlhs0lLL4OgXHjvMVCqwS
	 sPidGoIXvhz4NHpcCWULw6uPBezDdhOv/lmYvCVAyRwNgeKrDVdF7rsNnB8WWrT78w
	 ehpdn/iEn7bQ6I1Wp1LkzJ9NtintNXixkAZ86YtJIAczpUHzeTQYIneeJ5M6LWNPr9
	 MqxVf9eVCJe1tzhBPLVcQR5JKfeLwI7maIdC0m5wYcID2QKG7JrelE6crlmOki4rFO
	 f8b8qQx4xYq/pPnJUSm7YUgwG/FMIycZaiJnxQLbNCrh/gVB1iR4x9BlqJ40vkkWqf
	 Nd9Tj/sYbsNTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91p-00000003exw-0O4D;
	Sun, 09 Nov 2025 17:16:37 +0000
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
Subject: [PATCH v2 37/45] KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
Date: Sun,  9 Nov 2025 17:16:11 +0000
Message-ID: <20251109171619.1507205-38-maz@kernel.org>
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

Make sure G0 is disabled at the point of initialising the GIC.

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


