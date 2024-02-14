Return-Path: <kvm+bounces-8659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD951854716
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 11:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 629C41F2A238
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 10:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214EE1AAB9;
	Wed, 14 Feb 2024 10:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="AnHykjQd"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EC0171A2;
	Wed, 14 Feb 2024 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707906252; cv=none; b=SO1olORUl7NxlbJFNsiBRkBXRFI1Jm5yE5hjRiHHukn8dni7iuQjZpC1VWuAerpTdf+VtdQxNCemNFCgrwoqYYCDuGCaPpWVPUhke+Sb5ux2Z1UrkL6iRt71hkv8YwBo8oQLj9fufSSxZ0m9W+e0eyTVlRmcCotbUYWYms2xjvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707906252; c=relaxed/simple;
	bh=qUTm7/R3ovfw0MXxK4QrZKdILlZUuBNM9kI6bR5Fxzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFgxRPbgwNYJ1qRIO8JZshUWBOO2ncGYUuoiuOIAGaE43e9iNIloXoKkHAby5qAaDAWcdOxUYLFaWbVK0gZgcF6iD6IIhh17waVrpSKdMkJZtp89e8UjLFe6EtxpF6DAM8LNhtoUD/RufE62eYkO5gyZD+pafbaFcDKzvnQFvcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=AnHykjQd; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707905765; bh=qUTm7/R3ovfw0MXxK4QrZKdILlZUuBNM9kI6bR5Fxzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnHykjQdE1CficUI8gdhrgpFjRfWTnDfdo/3pAtd8JVI8QHIsghXTdXwSjL1Fg7sz
	 jw8WvUNInaOnTLhKJuxzq29eNk0fhq9PYUwGntbZSLVCe/uMu13LjJmVOhkc8wgEPV
	 VunNPOwdUcIGAqKUPO9cRjUrvDXrZRe/bAfifxGg=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:5531:eef6:1274:cebe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 6215D6017D;
	Wed, 14 Feb 2024 18:16:05 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 1/5] KVM: LoongArch: Fix input value checking of _kvm_get_cpucfg
Date: Wed, 14 Feb 2024 18:15:53 +0800
Message-ID: <20240214101557.2900512-2-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214101557.2900512-1-kernel@xen0n.name>
References: <20240214101557.2900512-1-kernel@xen0n.name>
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


