Return-Path: <kvm+bounces-23959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E75950205
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182F81C21D40
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D271E19AD93;
	Tue, 13 Aug 2024 10:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltJtpxxi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4F5195B27;
	Tue, 13 Aug 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543582; cv=none; b=OlE7TXiQQiBBQzZ45gaDs+nH1Q8YzoHTeXmIgWZzE+EZzPfdqc6SkhxtYjPrHN9R4Px+rpEkDbdZvjKTMbzUqTOfu2c+eYMjK6q5bpzJQ6gzZbgIUvrbuYLvQ408mTWAb71/orSppwnM/urWLrmJukf4am6LHcCv100OXmgCsgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543582; c=relaxed/simple;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gC/ks6v9ZUE5/n7fC3mKA+n3ARvVcQA+Tbe0Qmtp47evbBiO56OpYbu8YXcwfISxX+28wc4GU+gKDJmBWHQA3ROQh0RrQ/wu/jitYuPNqHroLjM0/mzw/CvJpCawDAm/AiAiB16qWB8gtZlP6Hf7mUVyfArOMiRZJwbkUvb/nro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltJtpxxi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD7DC4AF0B;
	Tue, 13 Aug 2024 10:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543581;
	bh=Qr6b5GYd96pu0YEgbNtFYok+p4sjzjCNIQpIrSoubus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltJtpxxi+dpARjd/SYkcu0h4TcKylJqOUqFTt0IkXRTvn3MpAM3QUGlAHp3WZHKos
	 NZ3wynpap0YjoVWOKYU0yoGHzod0myHvFmxCFNz6Mk6bnMfM/DWNeqUp+U7Ri7KtpL
	 jJZh0y0C5Xd3xrj/BkUaTQ4jrFoNb0ZlIcGJMkIABBOnTdAicix0WpQL93guJigCKh
	 OHA+geiJlEo+/PdEMCH0fjmvQlwdjs7eU3Z7LMjegVbNTLpPuCUdvACJmQtBuh+RPg
	 4MgjCNq3jjz9Q0PD0u5CBVHmj44P/s0UkH2IQSPWHgUETP/dGx3OWyr9aK0tKMj0Q/
	 v/9rOvBE/uOoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoPz-003INM-Ce;
	Tue, 13 Aug 2024 11:06:19 +0100
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
Subject: [PATCH v3 04/18] arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
Date: Tue, 13 Aug 2024 11:05:26 +0100
Message-Id: <20240813100540.1955263-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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


