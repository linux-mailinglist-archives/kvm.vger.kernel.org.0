Return-Path: <kvm+bounces-8689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B894854EA9
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27DA028D497
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 16:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C55627F3;
	Wed, 14 Feb 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="ZNU0AkXX"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1735E5FF16;
	Wed, 14 Feb 2024 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707928446; cv=none; b=q1EwQBKVY6r96i/t+W7IY4pUAQ0+UhauC2/73kdOrT8bfztsLGyT2yCdLe6iEXpj+hbKgi3LHY/P+ByIYzuPlnazlbnCLUI3txPbKzEfAA9jKdMjfbrCjZETUuBDSuRGwgpNqt0KMwhZBoEKn1cq7SSvXFye6uzQSl5M2YDFVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707928446; c=relaxed/simple;
	bh=qUTm7/R3ovfw0MXxK4QrZKdILlZUuBNM9kI6bR5Fxzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSUWscURgajYnaoqIkekL4T6/dNX4eVpgmSPJymoGU3jyWsTLydIx2JJnpDaI7Kz7uyiJob3p/OX2iX8z9SNhN3qh7X71hRZKhTJHyIETeUsyeCJmZxhDA1ebOHkAJdEpRaXHV6q1ZhFKSm6oelQgmg3IUYTDF+EtHUP3T8Cw5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=ZNU0AkXX; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707928441; bh=qUTm7/R3ovfw0MXxK4QrZKdILlZUuBNM9kI6bR5Fxzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNU0AkXX04CwM3rMQCCubKT7skrrj0VQW66Is5+V1MQyNxnY5LDUUe1L4voIFJ1vH
	 NoEbvYoF9cKwr6ofnBvYlg2hkbMBUnEsHOxaDuSohruYvUH45ZJarDyHMElfK6rli4
	 yTIfRvmdTBaROi9uTRmpVLZnSkX14DLrLQfnty54=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:42e8:c06f:a0dc:12f8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 90E38601A7;
	Thu, 15 Feb 2024 00:34:01 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v2 1/4] KVM: LoongArch: Fix input value checking of _kvm_get_cpucfg
Date: Thu, 15 Feb 2024 00:33:54 +0800
Message-ID: <20240214163358.2913090-2-kernel@xen0n.name>
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

The range check for the CPUCFG ID is wrong (should have been a ||
instead of &&), and pointless, because the default case a few lines
below already serves to deny all unhandled cases.

Furthermore, the juggling of the temp return value is unnecessary,
because it is semantically equivalent and more readable to just
return at every switch case's end. This is done too to avoid potential
bugs in the future related to the unwanted complexity.

Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 27701991886d..c4a592623da6 100644
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
@@ -324,12 +319,10 @@ static int _kvm_get_cpucfg(int id, u64 *v)
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
-		break;
+		return 0;
 	default:
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
-	return ret;
 }
 
 static int kvm_check_cpucfg(int id, u64 val)
-- 
2.43.0


