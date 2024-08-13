Return-Path: <kvm+bounces-24008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD92950821
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A8B61C226F6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E471A073B;
	Tue, 13 Aug 2024 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOXWQ/uu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A31A01A6;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=JIeKJGd/rG5avjwFugsYRJjA6+xA7REwnwSj27AMsFhF54FNOO8TQLTngjHyNN+DLcCbIglCc9A7rpufm/i36eM901hp6oKylrbsq8uh3aezGisTVsMhV3gZ5CxIVja2FPbmTw2+S3ZP7Zr+0wz3k54qQkr1rW9nJH0ftD/nDsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=gWUfxT4H7N3nyM/fDaVuQppiX/holJhsvKWB8A/mp8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VqWn9dMGO0UBtDSN+uqzw3bUj7pXX0zFlVJcmwLuV4E7wRNIYboXaRpbK/QxmwE8bcSzzGZZlNZ/S3YYuJaWCTprESMBZgxjLXZCHhOBwyk1EHnptBwm+9S9UyhBmXc60dPn+ODx2DlIEGoLWbtGyYXy/TiZiElOWHDjb/L/QE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOXWQ/uu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB3C4AF09;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560479;
	bh=gWUfxT4H7N3nyM/fDaVuQppiX/holJhsvKWB8A/mp8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOXWQ/uuhtreZiZYd+UdimB/6W8H0FkqRHy+e17ixlOYrRx5S495mnibSOOPkUeVW
	 cnubOdxT81UtKCI4DFQcdcUt8+TFrX3/L0GfpY/a555YKGadJH4lnsS3357TZ3icpd
	 3duwoc/mArirUwLADcl+Xa0y9PsP8qtv5Fpgqo5mRzjYNDLp0Bf39dcJfb4J+EmSJs
	 sG9XzUueNAMdHaYXljpj3Sy/3hw3xI3Q4+XbxddjFiNJXCkYfjfgDL4dpC/jFCAK3f
	 geqC0f0ZDRtj+41E4wYAxGaRhz3P4Z8beM04uOexmnMC+yq/3L/l/kHVlxjs0EifVI
	 Z1GMF4yag9jlg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoX-003O27-HY;
	Tue, 13 Aug 2024 15:47:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 07/10] KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
Date: Tue, 13 Aug 2024 15:47:35 +0100
Message-Id: <20240813144738.2048302-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the FEAT_S1PIE EL2 registers to the per-vcpu sysreg register
array.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5a9e0ad35580..ab4c675b491d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -463,6 +463,8 @@ enum vcpu_sysreg {
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
+	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
+	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
-- 
2.39.2


