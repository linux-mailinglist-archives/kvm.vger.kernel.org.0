Return-Path: <kvm+bounces-8692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0440C854EE7
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66BDCB2D904
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 16:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A0264CC9;
	Wed, 14 Feb 2024 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="Jnf8OFkq"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B762158;
	Wed, 14 Feb 2024 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707928448; cv=none; b=nA0NK+qZi8gywYfOFCQtVQn7PgvIaUiXrw+h6KO42LX1AGPPlGbYvRDtHom+ZkCz6mQ44E/NGNd8hGEWTniZfCZ8qlkLSiRnimvHA1ma8gzUqgbxehwa59D5hZWwLdyxLSZdHTJYytNQxJu7iGWlHw14s6bhBsvGI4dpaHpBscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707928448; c=relaxed/simple;
	bh=PcrXxYoGFClCitVwkysGKdmr3Nu5wkP9upQVqRlzsuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJcQRd1OhZs5Do8xqTfYBw9qJoafwBv0bYGMkIuO1Zsnmp7ze+dNLMuiRD1xcWGv88fg4RQIe3HRI6wQWdxw3nXEwrg6A7jVrm/mk6Ff4NjGdYjmFy0r6PJjFZcZy1QCt4Vu5wE0YiMTYS8TwMGpniM2aYAN2Kx0h2vt9PBcmCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=Jnf8OFkq; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707928443; bh=PcrXxYoGFClCitVwkysGKdmr3Nu5wkP9upQVqRlzsuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jnf8OFkqtVlmQbPloTxNCJMJsQq5QNPAnVRqPabXSB43Whlxp1YmtdU/jbD4S+vkl
	 HrAa37q3eBKxbJD2mOYrm7x3gELhFslp8k1/Mb6FI5uP7dUC5jAGRt4WnJ1Zu3JE05
	 sU06Y5IQ5LoRTkJoOE8X8heQBpWmokFLBM0m74xw=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:42e8:c06f:a0dc:12f8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 995CA60562;
	Thu, 15 Feb 2024 00:34:03 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v2 4/4] KVM: LoongArch: Streamline kvm_check_cpucfg and improve comments
Date: Thu, 15 Feb 2024 00:33:57 +0800
Message-ID: <20240214163358.2913090-5-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214163358.2913090-1-kernel@xen0n.name>
References: <20240214163358.2913090-1-kernel@xen0n.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

All the checks currently done in kvm_check_cpucfg can be realized with
early returns, so just do that to avoid extra cognitive burden related
to the return value handling.

The default branch should be unreachable because of the earlier
validation by _kvm_get_cpucfg_mask, so we warn in case it is actually
reached and return -EINVAL in that case too.

While at it, clean up comments of _kvm_get_cpucfg_mask and
kvm_check_cpucfg, by removing comments that are merely restatement of
the code nearby, and paraphrasing the rest so they read more natural
for English speakers (that likely are not familiar with the actual
Chinese-influenced grammar).

No functional changes intended.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 45 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index e973500611b4..b467a44e670a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -302,20 +302,16 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
 	switch (id) {
 	case 2:
-		/* Return CPUCFG2 features which have been supported by KVM */
+		/* CPUCFG2 features unconditionally supported by KVM */
 		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
 		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
 		     CPUCFG2_LAM;
 		/*
-		 * If LSX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
+		 * For the ISA extensions listed below, if one is supported
+		 * by the host, then it is also supported by KVM.
 		 */
 		if (cpu_has_lsx)
 			*v |= CPUCFG2_LSX;
-		/*
-		 * if LASX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
-		 */
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
@@ -336,27 +332,26 @@ static int kvm_check_cpucfg(int id, u64 val)
 
 	switch (id) {
 	case 2:
-		/* CPUCFG2 features checking */
 		if (val & ~mask)
-			/* The unsupported features should not be set */
-			ret = -EINVAL;
-		else if (!(val & CPUCFG2_LLFTP))
-			/* The LLFTP must be set, as guest must has a constant timer */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
-			/* Single and double float point must both be set when enable FP */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
-			/* FP should be set when enable LSX */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
-			/* LSX, FP should be set when enable LASX, and FP has been checked before. */
-			ret = -EINVAL;
-		break;
+			/* Unsupported features should not be set */
+			return -EINVAL;
+		if (!(val & CPUCFG2_LLFTP))
+			/* Guests must have a constant timer */
+			return -EINVAL;
+		if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
+			/* Single and double float point must both be set when FP is enabled */
+			return -EINVAL;
+		if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
+			/* LSX architecturally implies FP but val does not satisfy that */
+			return -EINVAL;
+		if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
+			/* LASX architecturally implies LSX and FP but val does not satisfy that */
+			return -EINVAL;
+		return 0;
 	default:
-		break;
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
-	return ret;
 }
 
 static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
-- 
2.43.0


