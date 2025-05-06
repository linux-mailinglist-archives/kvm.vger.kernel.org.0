Return-Path: <kvm+bounces-45624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97988AACB4C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8B043BD7F7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96BB28688F;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKaooU1v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE792857FC;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549850; cv=none; b=hPJeQ+SRxy7LEEVAAXpA/7pB3walmcmPJ7QN7jl1/IXUhOgdEj52+IxQbyf50GN2E8pVFsbivBkotZS7yagHQqEBwSy1fEpTbBsUKezTis7Qd2vAoWxwgye+X2NnHxzScDo/bRbAGpayYJHHTO9+vatLIah6D51Hik2Fees5Ypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549850; c=relaxed/simple;
	bh=9pgxiWCL9Lomr3yxaonxBwT8LnBlQFBPORiK3/1n6t8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ACIYzu/nKp2QECH5n6jVy+bWi8ppFhwh5FoEUW+E5uo7PQZdL6CMSucLhrTRkYAZU2Q6zMMULMe9KFBwo+OaJOMa/+9Ss9Oiq4xBWsEdj/5+30af1Z187cq7KNxIuJ772hylaEEB3iHT/mka/PsU29G1EBVm66g6R8sB+mSJVPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKaooU1v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4154CC4CEEF;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549850;
	bh=9pgxiWCL9Lomr3yxaonxBwT8LnBlQFBPORiK3/1n6t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKaooU1vaMH1e8FMVzAsGtVdE0doZ8eKPkepCxsD1juTxGAUO6HtZ98aHfFEFeAcb
	 bSTDy9oxcI1ihu5Ovtf26kffF1d/wkmg+RYlSYfj7HKwXRAIsExF6OmJ/dmDE2Ajzj
	 tO/QEzUq7Hc0HfhYUr6xD+8DhBgE4oYRcnsXk2aLxSEiBT9NGwRtz726qOd/O6sllS
	 pUx1EQRObS5kHs6JGg8lLRDkAoBKjKSacQXzZJHatGgxDqE2luixzvGx2PZuTZsSNI
	 cabUBsJWoARjQ/pzZrT4lrTbCLw8F34Xu9XbcEBneJ0P8U0T9xk54l5+tXnZES50aK
	 RnqtjZAVRLicg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOq-00CJkN-HR;
	Tue, 06 May 2025 17:44:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 11/43] arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
Date: Tue,  6 May 2025 17:43:16 +0100
Message-Id: <20250506164348.346001-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the new CMOs trapped by HFGITR2_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a943eac446938..8908eec48f313 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -117,6 +117,7 @@
 
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
+/* Data cache zero operations */
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
 #define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
 #define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
@@ -153,11 +154,13 @@
 #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
 #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
 
-/* Data cache zero operations */
 #define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
 #define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
 #define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
 
+#define SYS_DC_CIVAPS			sys_insn(1, 0, 7, 15, 1)
+#define SYS_DC_CIGDVAPS			sys_insn(1, 0, 7, 15, 5)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
-- 
2.39.2


