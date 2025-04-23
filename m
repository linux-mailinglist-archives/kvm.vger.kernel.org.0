Return-Path: <kvm+bounces-43952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B6AA991A9
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93B931890FC1
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBC6294A19;
	Wed, 23 Apr 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqbujAKa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2E528EA71;
	Wed, 23 Apr 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421316; cv=none; b=Uyonhii5wRmmsf0dBAOoFhi75d+UHkgW5PU0/JJuQwztL+nILJe8Cd2kl+IjmRVJoQUXPcm7LRr+vg+fbXxVWsHrDuqRgocAfnT2I+AQNcx9yStxl9oRM4tp4xsWSK4hTbM+dLHKj0Tc+93RNlgYaolAvDuHS2l5l/UVmXlejgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421316; c=relaxed/simple;
	bh=jSgGzdta8ZXQcXWfdhPT721GAmbclZgONOJn80ZUs0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p+bLdAi3LugXdepcusH9I9+rlJBF3hYJCtGQX8TW9uUbvuLt7D7OGCR25DwL44AsRWNYodk4lgLpqYOv4kxTZhdmGhiBH1w+axR7dM3JrSt70pDiduaPnVJM3wl7a/noGj7teXdo5PXnSR/rXoU1WXOkS/gtYEWXxxeEBYoZ8H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqbujAKa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47299C4CEE3;
	Wed, 23 Apr 2025 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421315;
	bh=jSgGzdta8ZXQcXWfdhPT721GAmbclZgONOJn80ZUs0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqbujAKao6FJpNETiegwWfOtF+N1gmKeHmzjG90UnP8FbXup3AGAKon2b8CjwQWdZ
	 UzCLgLK9HAo6LvnunhIyvxVsq+557nreN9sRaJ6NhYqWYsqZAzQxY3onXsy8BGEmUI
	 BukT4dLd/ikpVV+ZhD2L3fp4HAL3BwvfTaWYfY9NX7Znh6EmeXMB9rpNt2SfTfx75l
	 V+Z9UCuEFIREscSS5myP3PDdumwARP0ftXnhIbrnqVJcHMDV+00Xw0Op9FKtyHPkwu
	 5lr21KiMk3/OyeTOBQnQoK8CbWcrgQES39JXBjrC2PUJqYCcO6Hm+L9lloMfU/P67I
	 O6hahSk23jWPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7bof-0082xr-6r;
	Wed, 23 Apr 2025 16:15:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 01/17] arm64: sysreg: Add layout for VNCR_EL2
Date: Wed, 23 Apr 2025 16:14:52 +0100
Message-Id: <20250423151508.2961768-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we're about to emulate VNCR_EL2, we need its full layout.
Add it to the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 -
 arch/arm64/tools/sysreg         | 6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..b8842e092014a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -521,7 +521,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bdf044c5d11b6..5a3190600a0b3 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2971,6 +2971,12 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	VNCR_EL2	3	4	2	2	0
+Field	63:57	RESS
+Field	56:12	BADDR
+Res0	11:0
+EndSysreg
+
 Sysreg	GCSCR_EL2	3	4	2	5	0
 Fields	GCSCR_ELx
 EndSysreg
-- 
2.39.2


