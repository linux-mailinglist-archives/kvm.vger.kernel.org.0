Return-Path: <kvm+bounces-24607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BFC9584C3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CD051F260DD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CDC18E050;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgxN2LX/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DE618DF99;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150286; cv=none; b=nNagXBYn+NRyGjQD8VwFAER6UD9t6aWu64LW0zlkZScE43i3qU/vs8LTafCBIZ/H9XQ6M7ZiNBIG8nfjqES5NOUk4wMNUel0o9iOcSnJc9EIZhXMuvserNQkiIHclbXjicStJDfdyIlzAZvCTxJJgbWtEBUrqboeG5S7YlkGV6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150286; c=relaxed/simple;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=txYd5QP+ra8CfEr81ag480AI2UG/gAjY3ex3Y6yEeVwjN8CW3iWIYKeadPGlx5rzsy1oFjCQvFa7v7pNrRPH9mFcCwQyH1dk/qPVkfynN+jPcgrkAZ6FyQCwnbGlud9OfnJc9TuF8T40VNsAU3E5zZg0jbnQ8VQeL7q12O3504U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgxN2LX/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BB1C4AF09;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150286;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgxN2LX/Ccpcw7L8lIIz0h4L1OxxbN7g7zs70nSoCg9o0F7Ahd+bwdQV9L70NE+/+
	 1OuOpA0mebb67pWbX6oOnOoWhtnToPCIyOb5lK6vE2y17vEO1GuX4vi0fqh3XU7XEK
	 jw7n49k3VoSDTVXPfzW0U5P9J8klr90Yl+Gw/I86dpgJlIjc3/sWOKa7LBUS9Qbezi
	 YQgUyefzKg0vhNcHx3zing4R2djRfYJ8ZaQZM0grsUZg0xM22x1/qzGoUA5IOmhJCQ
	 1lZqhPsnDz2tgBR/ZwfHELTJ98zBkGG9iMQL7WAJio/md+JOS133mDjXLAxPKxaMMS
	 Ca9gnkOs5dbfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFY-005Ea3-Ow;
	Tue, 20 Aug 2024 11:38:04 +0100
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
Subject: [PATCH v4 04/18] arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
Date: Tue, 20 Aug 2024 11:37:42 +0100
Message-Id: <20240820103756.3545976-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
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


