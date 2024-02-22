Return-Path: <kvm+bounces-9374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A59285F625
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BD2A1C23F28
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A47481DA;
	Thu, 22 Feb 2024 10:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="oUphH2G+"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134C41238;
	Thu, 22 Feb 2024 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599080; cv=none; b=qI6sMZViEp5pdzsw9FcdOqMBSjjJn60h8HtpXaBGMoKcBEdPvgOuKNvIPiSJfBr1JYo06yi4Xx5X3aiDEhWQjAmNccSJbYJQyfT4+1mhY3PPFzc1El9WIDdsODkOTe+SdnY2kFIn3G8t3FAfBBVZ41KeS8bETXwg7LNJppXGy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599080; c=relaxed/simple;
	bh=mIM5+uGanlPrOHLZO0tD/F5TByLX/tkNjX3Vya5rHJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJHVtc8oYkgsroqzzFRyMCaPr8CfCY4a/GELB/25eOn/zmZaFVym/M1qewVkszfsQ3UJf1xR8ffvfwFrNBH+iQ/ThaSFQBin+Ahi5rzpUmKCkz43f+YyCEys/lsHuwpYtftaOXNBkDiTbO7E1w9pciwYlVi8q2bOiElzfXGgAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=oUphH2G+; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708599076; bh=mIM5+uGanlPrOHLZO0tD/F5TByLX/tkNjX3Vya5rHJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUphH2G+rxFnKG54JbclBjdbJwbNXnlrHZHW5wp4J9UhaiXAi+ZL99kzmMlddZXoK
	 n6QG80KovrJlyq/187jU2TIOCMzN/H+DHbY3HXCRA/+JBmsEyIc8lXjZec/bDkiiy1
	 ZS4TYzIwSz77QbZ4LbjRUaDQmnY/+X5zrukUOepg=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:58fe:4c0e:8c24:2aff])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 8847960164;
	Thu, 22 Feb 2024 18:51:16 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v4 1/3] LoongArch: KVM: Fix input validation of _kvm_get_cpucfg and kvm_check_cpucfg
Date: Thu, 22 Feb 2024 18:51:07 +0800
Message-ID: <20240222105109.2042732-2-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240222105109.2042732-1-kernel@xen0n.name>
References: <20240222105109.2042732-1-kernel@xen0n.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

The range check for the CPUCFG ID is wrong (should have been a ||
instead of &&) and useless in effect, so fix the obvious mistake.

Furthermore, the juggling of the temp return value is unnecessary,
because it is semantically equivalent and more readable to just
return at every switch case's end. This is done too to avoid potential
bugs in the future related to the unwanted complexity.

Also, the return value of _kvm_get_cpucfg is meant to be checked, but
this was not done, so bad CPUCFG IDs wrongly fall back to the default
case and 0 is incorrectly returned; check the return value to fix the
UAPI behavior.

While at it, also remove the redundant range check in kvm_check_cpucfg,
because out-of-range CPUCFG IDs are already rejected by the -EINVAL
as returned by _kvm_get_cpucfg.

Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 27701991886d..7fd32de6656b 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -300,9 +300,7 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 
 static int _kvm_get_cpucfg(int id, u64 *v)
 {
-	int ret = 0;
-
-	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
+	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
 		return -EINVAL;
 
 	switch (id) {
@@ -324,32 +322,35 @@ static int _kvm_get_cpucfg(int id, u64 *v)
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
-		break;
+		return 0;
 	default:
-		ret = -EINVAL;
-		break;
+		/*
+		 * No restrictions on other valid CPUCFG IDs' values, but
+		 * CPUCFG data is limited to 32 bits as the LoongArch ISA
+		 * manual says (Volume 1, Section 2.2.10.5 "CPUCFG").
+		 */
+		*v = U32_MAX;
+		return 0;
 	}
-	return ret;
 }
 
 static int kvm_check_cpucfg(int id, u64 val)
 {
-	u64 mask;
-	int ret = 0;
-
-	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
-		return -EINVAL;
+	u64 mask = 0;
+	int ret;
 
-	if (_kvm_get_cpucfg(id, &mask))
+	ret = _kvm_get_cpucfg(id, &mask);
+	if (ret)
 		return ret;
 
+	if (val & ~mask)
+		/* Unsupported features and/or the higher 32 bits should not be set */
+		return -EINVAL;
+
 	switch (id) {
 	case 2:
 		/* CPUCFG2 features checking */
-		if (val & ~mask)
-			/* The unsupported features should not be set */
-			ret = -EINVAL;
-		else if (!(val & CPUCFG2_LLFTP))
+		if (!(val & CPUCFG2_LLFTP))
 			/* The LLFTP must be set, as guest must has a constant timer */
 			ret = -EINVAL;
 		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
-- 
2.43.2


