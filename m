Return-Path: <kvm+bounces-29531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4291E9ACDE7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6E2DB25C7F
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107DA201102;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIB96ixS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D527D1D015E;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695233; cv=none; b=P9jTtn++yF8ycOk/zjN19c7Kn/zjkhUB06MYttKyUeaNtuktudYQhinY3a25HFIFdShqrL5XM6+TX+3qg2ufiC5JXYyJmIqlqqFnZpkQbSH2ChL/wxAP3tBneN0dcElPAofFrwhids6w3uVzcSaUICljifwvaGbAwHSFz8/G3r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695233; c=relaxed/simple;
	bh=+Mi+ChfY8Q2QN7X3Fm7RfJa/0ezUgsD5Bs2HZBlFNkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M7MkY7oQQG8u9pS4ixoKkhBT1PF48nsgge4ZUZhiPCj7vneuSSUqPJCsY/uSI7lUmS7xHmG8T5Wai6p2swSkjzcIqSRDwTrmqSAHDs8PLgpXwuBr6AMAWSguaMPiX5nTiRrz/m04xWQqpHvlJinleCFegGmlgwZM921RDHrcaNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIB96ixS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5619CC4CEF1;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695233;
	bh=+Mi+ChfY8Q2QN7X3Fm7RfJa/0ezUgsD5Bs2HZBlFNkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIB96ixSHSSM0tdvFnXb8249wKGJkZ3TRIu9QVw54vzFAfRKDmUgMFLtnMS9wFyIP
	 399w8CqiQRzfpcqfwVJ3afQcr5HxkJR1S6EfIXDOm5wkSYz8pd2WVpvxpy8fMw3a4W
	 DCrx19mAfrpFl5ES6ad8ngbe65tM8f16SIGUMASc+DE0k/3vRca09zVn2W1AXySsdb
	 /UXh0OvRmAm00rhVi1uxFARVF9HnRBRm8PFJulmqzDjdqYcsrNhoxb6G/6K+62AgVJ
	 qijWgi9qOVu/xLmb2yhr4jnbI95g4IlngtWoIWzDeEYgFdFT3Dhr472x/D9MScwQQT
	 uwdYc0oY18ZtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckB-0068vz-Fs;
	Wed, 23 Oct 2024 15:53:51 +0100
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
Subject: [PATCH v5 10/37] arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
Date: Wed, 23 Oct 2024 15:53:18 +0100
Message-Id: <20241023145345.1613824-11-maz@kernel.org>
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

This definition is missing, and we are going to need it to sanitise
TCR2_ELx.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 3c812fd28eca2..8db4431093b26 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1688,6 +1688,7 @@ UnsignedEnum	3:0	HAFDBS
 	0b0000	NI
 	0b0001	AF
 	0b0010	DBM
+	0b0011	HAFT
 EndEnum
 EndSysreg
 
-- 
2.39.2


