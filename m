Return-Path: <kvm+bounces-3346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A838036FA
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 554461C20B42
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1365E2942E;
	Mon,  4 Dec 2023 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScMQMzZK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD6C28E1F;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D2EC433D9;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701700579;
	bh=FZ+C+EnF3vOVUHA+MrHs3acC5vLhu/lGMjJjrpw9QJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScMQMzZKP8/OjkFjjv4Z0k1wxHg4T5fVTvM492DJz721iOKteKom6s+I9q9RF/cW2
	 9VlusoUXX5MexfgoHC7T8+sM8ASSnmNSaK9f3M9A2pwuZVPASly5gp6mXawqhn2EJ/
	 vhjdggrYacgDqDbHAvKaRbJJxbQ3ito/BHuRytslfdzlXflMId+CHtY1pSqwMcZ0qo
	 bYcwMHdlcz6NxbV0GmqOErXgNct9TTn1KCHX68MWgHYL+3evO/YbXLtlbhSk1cPijA
	 vChQxn329IY5hAfWHfnZhR1zRVIQPhs79lNslIn4cNeWvZzM/A3WD8YD8P4tNzXoXW
	 64Pn5lgNHEZog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rAA3V-001GN2-Gp;
	Mon, 04 Dec 2023 14:36:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
Date: Mon,  4 Dec 2023 14:36:06 +0000
Message-Id: <20231204143606.1806432-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204143606.1806432-1-maz@kernel.org>
References: <20231204143606.1806432-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ardb@kernel.org, anshuman.khandual@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We now have *two* values for CTR_EL0.L1Ip that are reserved.
Which makes things a bit awkward. In order to lift the ambiguity,
rename RESERVED (0b01) to RESERVED_AIVIVT, and VPIPT (0b00) to
RESERVED_VPIPT.

This makes it clear which of these meant what, and I'm sure
archeologists will find it useful...

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 96cbeeab4eec..c5af75b23187 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2004,9 +2004,10 @@ Field	27:24	CWG
 Field	23:20	ERG
 Field	19:16	DminLine
 Enum	15:14	L1Ip
-	0b00	VPIPT
+	# This was named as VPIPT in the ARM but now documented as reserved
+	0b00	RESERVED_VPIPT
 	# This is named as AIVIVT in the ARM but documented as reserved
-	0b01	RESERVED
+	0b01	RESERVED_AIVIVT
 	0b10	VIPT
 	0b11	PIPT
 EndEnum
-- 
2.39.2


