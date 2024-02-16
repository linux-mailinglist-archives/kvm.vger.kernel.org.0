Return-Path: <kvm+bounces-8862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82BD98578FD
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 10:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 363581F24EE4
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 09:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCA61C691;
	Fri, 16 Feb 2024 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="NQ1/7q7u"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781411BF40;
	Fri, 16 Feb 2024 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708076296; cv=none; b=kQJ6gKTe/p/Zf3suVwapeVIv3BrAiP5ZOtEqZ8p8xsLs07Rpw3UCOlJjI3YcW88EAHMlX7xZcEB79XOBSi81YMHt85Nqp8TXzRPaPMhfRlLk5mW66tUL6Pd8zqqo29PYEwFn59YHIaggS2Q7Tz5QvLfShj6T5rUGnhpR3rmZPvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708076296; c=relaxed/simple;
	bh=KEo5ilDJKrGL6duLt4MyGNOdrIywH1ExG4tjw1tnX/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjtFcfe5/+KsClkEFeZ6Xa5p7UaX9PH6Mo53amdmiV6hhiOfqmvDghF5K5XZetctc9A9JeTqWTNqSMz0AimN1Qtlaebm5T50yusHRJSe0a7BIVWuRyD6Be5L8Q//LaO8rjIEKga+Nkxl504gfMX75LZnkBufZtf3iQnsqCpecLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=NQ1/7q7u; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708076291; bh=KEo5ilDJKrGL6duLt4MyGNOdrIywH1ExG4tjw1tnX/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ1/7q7uSGVHU4We9uGyGdzhLq/3K1/JU3w/6E52uIgPcCumeo6VJCq/QkwmHJviz
	 HBIW1zDjUEFBcjXrXOsFDvwFk7ARQZ8dDH6k9EF2cDuu8h5Z1szne7EiakOVmCtEqg
	 e7XG3oCgOwM8HwQJydv/Vf6rdfv48x3H7ZsYGExc=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:cda4:aa27:b0f6:1748])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 76E1560114;
	Fri, 16 Feb 2024 17:38:11 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH RESEND for-6.8 v3 1/3] LoongArch: KVM: Fix input validation of _kvm_get_cpucfg and kvm_check_cpucfg
Date: Fri, 16 Feb 2024 17:37:57 +0800
Message-ID: <20240216093759.3038760-2-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240216093759.3038760-1-kernel@xen0n.name>
References: <20240216093759.3038760-1-kernel@xen0n.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

The range check for the CPUCFG ID is wrong (should have been a ||
instead of &&); it is conceptually simpler to just express the check
as another case of the switch statement on the ID. As it turns out to be
the case, the userland (currently only the QEMU/KVM target code) expects
to set CPUCFG IDs 0 to 20 inclusive, but only CPUCFG2 values are being
validated.

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
 arch/loongarch/kvm/vcpu.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 27701991886d..124cd7a75061 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -300,11 +300,6 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 
 static int _kvm_get_cpucfg(int id, u64 *v)
 {
-	int ret = 0;
-
-	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
-		return -EINVAL;
-
 	switch (id) {
 	case 2:
 		/* Return CPUCFG2 features which have been supported by KVM */
@@ -324,32 +319,34 @@ static int _kvm_get_cpucfg(int id, u64 *v)
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
-		break;
+		return 0;
+	case 0 ... 1:
+	case 3 ... KVM_MAX_CPUCFG_REGS - 1:
+		/* no restrictions on other CPUCFG IDs' values */
+		*v = U64_MAX;
+		return 0;
 	default:
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
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
+		/* Unsupported features should not be set */
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
2.43.0


