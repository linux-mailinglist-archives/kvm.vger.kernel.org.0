Return-Path: <kvm+bounces-20901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 602CF92653F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B70928328C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4128B17A5A3;
	Wed,  3 Jul 2024 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHWG6Lho"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68059173336;
	Wed,  3 Jul 2024 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720021674; cv=none; b=FjF3zH/3qEoXaMbkMFvr+YSn2bVVn1zgNB1YihDjzG1gCjueUEd5nCc2QJndiHfszqPrfLwH9iAxYTQ1zFh72Kf7ZnL3EqtTV/RDdTeOjonZdZ9T8W1Ug6J59rzh7LZAum50sj0WNXaUsQFXwhf/vPppvEn7Radgez7zrawgd/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720021674; c=relaxed/simple;
	bh=xVi9E4QQ7Ky8LoYasCK2VdMivLv1/qqg53/SZnL6ZHg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QYT4/k0Jd50LWlludemqAxs+GOLDobP8HTtkPplIHVvBWXaYZ2+m4M59wZaZQdVn4hBbDyou/OK9gMVeSzN+ZhqfWlUOP5fWbLA5uc/Hy7iXBDaIAm7HsAWjbZzHZH1w9xnjLLhxhBq901qLQr/D0Xh7uxDtFKT9hnwFO3bYq5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHWG6Lho; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14FEC2BD10;
	Wed,  3 Jul 2024 15:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720021674;
	bh=xVi9E4QQ7Ky8LoYasCK2VdMivLv1/qqg53/SZnL6ZHg=;
	h=From:To:Cc:Subject:Date:From;
	b=OHWG6LhouNPAcWCL7cidRjn4i+wELfViRrIopsZRrwK/sMVHEghk4ZrH8qnHB5xWS
	 kroT6Pi/jj4A2a+b8s6M9QzhGt2W6sTBOjI1redKn+Y5dURZtsTgPkuaRjo8Rp3Ri8
	 OtrnmZwgmuYYocSNyhyMa3rN4asQ5fs4GQZVFp66tZvAwqAWxHAA26n68SvYzjHbar
	 p0qlBIjOZzgNYxRV3rLy2SWGloUHeBtXXEkO0WhIOeNYXGfx/vQ/BqnXyXxR6b8VC5
	 +Zg8XkepunccVSKbQ41EGJD/792DapCEo0qwdgsUiZxo1GXqCaNeMffvTViv1zNrKd
	 SDHDNyCNPIo+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sP2D1-009V00-P0;
	Wed, 03 Jul 2024 16:47:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Truely enable nXS TLBI operations
Date: Wed,  3 Jul 2024 16:47:43 +0100
Message-Id: <20240703154743.824824-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we now have support for nXS-flavoured TLBI instructions,
we still don't expose the feature to the guest thanks to a mixture
of misleading comment and use of a bunch of magic values.

Fix the comment and correctly express the masking of LS64, which
is enough to expose nXS to the world. Not that anyone cares...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 81e0374a4a45b..b3c8d8e04a547 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -810,8 +810,8 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		break;
 
 	case SYS_ID_AA64ISAR1_EL1:
-		/* Support everything but Spec Invalidation */
-		val &= ~(GENMASK_ULL(63, 56)	|
+		/* Support everything but Spec Invalidation and LS64 */
+		val &= ~(NV_FTR(ISAR1, LS64)	|
 			 NV_FTR(ISAR1, SPECRES));
 		break;
 
-- 
2.39.2


