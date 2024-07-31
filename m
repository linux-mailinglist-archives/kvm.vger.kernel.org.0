Return-Path: <kvm+bounces-22810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D67943694
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6541DB20AF1
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86FE716C6BC;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTuTHEnU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D7414D70E;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454856; cv=none; b=CnSKhxf+lINLvBszZoRzB5ggOBu2i6Nwn56mXBffv6sQNFHIe+VB8a+CWes2I4TxrcnOiyxqf9glVvDfyaKF6VXkX0DJSp4msqxbDb09MlzLi8EV8KkIoWskH7C6KYeV91EouIWvAIf6yEE+fPT+0NJcY63Uzx1fnv77TwE1MJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454856; c=relaxed/simple;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R3AW90wf4YdgIzAdPMd7SeJVi+HLgxWItygBpFUYJ/VpMTxj+sj4ud9V29k2PM0v2ALz6DuFTMwVvS+b7U+3AKpOIn7G/3rAsPqC0ZELLecmHmNOdSJ2gKD7rS359/oWEAUcuCtABLtbGyxMvdZwqDnUgOH/tst2pmUJt0pu3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTuTHEnU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C09C4AF0F;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454855;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTuTHEnUCHgUt6542ySKsnmOJuF8O2osw7lyBsaNCS/TKpfxspIHc4ZVSEo4jy76J
	 CjuTtq4f1tJDz3T9LCbLQgp53C91kGtkUxlOqMI8UPArc9m5mjmZiv+K42ZMSGw7Oh
	 Y3nYl1/10LkjU/2lyhXmkUU/8agkhE25QCzcwviTQ7kXos7K+LHmNDO0Jflq4k/Kcp
	 t+PshWo15onUxiI+9T/AvFkTUuiF3lgLjqvu6oZnT2cr7FeJPp6YM0UZ5WUSsu+i0C
	 NdytqvDfjsonWn00wE0l16BtmLDGCf5R9U6q/0ioWA6l5inD83M71Hp02eMmMDhcuK
	 noiSjdMttd38Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBt-00H6Gh-PU;
	Wed, 31 Jul 2024 20:40:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 04/17] arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
Date: Wed, 31 Jul 2024 20:40:17 +0100
Message-Id: <20240731194030.1991237-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we have helpers that encode the level of a given fault
type, the Address Size fault type is missing it.

While we're at it, fix the bracketting for ESR_ELx_FSC_ACCESS_L()
and ESR_ELx_FSC_PERM_L().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 56c148890daf..d79308c23ddb 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -122,8 +122,8 @@
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
 
 /* Status codes for individual page table levels */
-#define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + n)
-#define ESR_ELx_FSC_PERM_L(n)	(ESR_ELx_FSC_PERM + n)
+#define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
+#define ESR_ELx_FSC_PERM_L(n)	(ESR_ELx_FSC_PERM + (n))
 
 #define ESR_ELx_FSC_FAULT_nL	(0x2C)
 #define ESR_ELx_FSC_FAULT_L(n)	(((n) < 0 ? ESR_ELx_FSC_FAULT_nL : \
@@ -161,6 +161,7 @@
 
 /* ISS field definitions for exceptions taken in to Hyp */
 #define ESR_ELx_FSC_ADDRSZ	(0x00)
+#define ESR_ELx_FSC_ADDRSZ_L(n)	(ESR_ELx_FSC_ADDRSZ + (n))
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
-- 
2.39.2


