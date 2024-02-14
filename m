Return-Path: <kvm+bounces-8656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 235DE854710
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 11:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D27FB282A2B
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 10:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F7E182DF;
	Wed, 14 Feb 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="QOQHz9Rr"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1861755E;
	Wed, 14 Feb 2024 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707906250; cv=none; b=F/p/WBT7O3d7jQJipQ87nqPrTzOP9LSSO8bTgEYRnJVIrDtWjWc7y8mfIU/Xm/H1pmFjys+224+eTdjggrVZKIpmb8JUIj0Ax5XlMl6wJVGy8n3J1yBPznCCvXrEcGaU6G4M9BiF1ZG26kqpdRMsiSgfeThpelFNuh4QlU7Fj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707906250; c=relaxed/simple;
	bh=RLw0Ke+gAZcjvLomlJhUe4+W8YYZZSg0ARVq9aMVCrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8bhutAgH7F7xeQxo0Cn7WyCzuZGTIVMes8SOkay54g7qsFrVoADFIpVd+cN/jQXNc2jpoLG5SW1pUFCt7u1cWuipyT/dzKWIcPxIOz7zwUvf23BVyuQEj71wup+ePPv80p0LOmUn3amGfJn1Rxppr7mo1f16iI/E7hHgvxnRK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=QOQHz9Rr; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707905766; bh=RLw0Ke+gAZcjvLomlJhUe4+W8YYZZSg0ARVq9aMVCrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOQHz9RrVavX6BeKFy7gBmTGpqvwBepZ7fDQO0dBCdOduCsqYJLFvZR1npngVfOZo
	 euevnVDYHQHw0+mIjO6IUmsqD1OAMkmRUs4wVTAdK5f2AWFIKDAKD0m4MBRnCb+dnm
	 ChKaWPTjcX54Vvg8n3XGSFoDOoSzsdBmc6iqHL/8=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:5531:eef6:1274:cebe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 7B052601A7;
	Wed, 14 Feb 2024 18:16:06 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 2/5] KVM: LoongArch: Fix kvm_check_cpucfg incorrectly accepting bad CPUCFG IDs
Date: Wed, 14 Feb 2024 18:15:54 +0800
Message-ID: <20240214101557.2900512-3-kernel@xen0n.name>
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

The return value of _kvm_get_cpucfg is meant to be checked, but this
was not done, so bad CPUCFG IDs wrongly fall back to the default case
and 0 is returned.

Check the return value to fix the UAPI behavior.

While at it, also remove the redundant range check, because
_kvm_get_cpucfg already rejects all unrecognized input CPUCFG IDs.
It was also wrong and no-op, in the same way as the former identical
check in _kvm_get_cpucfg.

Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index c4a592623da6..cc2332b056ba 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -328,12 +328,10 @@ static int _kvm_get_cpucfg(int id, u64 *v)
 static int kvm_check_cpucfg(int id, u64 val)
 {
 	u64 mask;
-	int ret = 0;
-
-	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
-		return -EINVAL;
+	int ret;
 
-	if (_kvm_get_cpucfg(id, &mask))
+	ret = _kvm_get_cpucfg(id, &mask);
+	if (ret)
 		return ret;
 
 	switch (id) {
-- 
2.43.0


