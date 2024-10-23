Return-Path: <kvm+bounces-29548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C9D9ACDF8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0BA81F2354E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E24209664;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIcCfvRZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C6F1D0418;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=o6MjJmaDqjywYwpAXt6nU2NZMek/qpjfEbyvxGwi5T2ixOGpNEI8pl2irEmvUXfh1EfjV2rN85pmGiDo9vnbOIHhbqCCxM7nsyKC1yE4ZunTUGeCyMIIRfu8AVfHV82PeGbzvsOj0LC9wHTfD8pvEiIZQ0RkkRSwWeejjVwLRZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=x3OVdblfjzLAzOMuHusK8FnNF3oPWJdEbQW/T6p0YP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A6S08j/CkGUo1ahrZ4WSXmmyA+ceFENgAokKg8wl8dZosanYj/VnPThNk8lhyhlTrsMZZxBJd2xQQ4yWUb9sRDOdpdL1trlh4t1kwHAKbQTHMZP6+xFJHUBS0/QIQCl/jErO19JOz8D8G/x/TowIKnhU4HcPkifLbQx1ZnWwSWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIcCfvRZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD14C4CEE4;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695236;
	bh=x3OVdblfjzLAzOMuHusK8FnNF3oPWJdEbQW/T6p0YP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIcCfvRZ16kidnKEtlzLvLsL/AK0Ak7nHXBzVBp6R+KWjksn6DmF+ztQ2j6v/hAER
	 uDoU44UbqYf3aY8lhNr6ThGFwXR8qVcwTGTb7l8kvQEjzZjGVerVWmaEZKzh0IXWqZ
	 8KN/e8PnmW33tfcX5F8SCzSyuOeix44wYP2qwhy4nHxcKjBepfzZ89iHNKj7m//bAv
	 K6McNt4J/L5W3WJpF2NHDg1oGWpk8um1KZtTZRPkt3DLr9grK3PWYtACdPBw81k1nY
	 QOj/maPrkKiRo61/YBPnc68fB0Y63PHQEOXusICVV31OJferpe2MopFXwJ4hqoVydV
	 FkZGCC6i74k4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckF-0068vz-3V;
	Wed, 23 Oct 2024 15:53:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 27/37] arm64: Add encoding for POR_EL2
Date: Wed, 23 Oct 2024 15:53:35 +0100
Message-Id: <20241023145345.1613824-28-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

POR_EL2 is the equivalent of POR_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8db4431093b26..a33136243bdf2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2907,6 +2907,10 @@ Sysreg	POR_EL1		3	0	10	2	4
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	POR_EL2		3	4	10	2	4
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	POR_EL12	3	5	10	2	4
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2


