Return-Path: <kvm+bounces-8691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F0F854F02
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14947B2D7B9
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 16:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B916351C;
	Wed, 14 Feb 2024 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="naMmfsy+"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C126166F;
	Wed, 14 Feb 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707928448; cv=none; b=ED2qFXpLXmtNmHpzKJQRHCglvrb7vplCFjWIJsxpOuDsOJZ2UQYqlCC8Ew1NYwsWsKGYumkFXuBCobyayDEEAWxt/pBmeR7jcuFKvlvFP7Qtro2z32wPSdRtQ5+M8nqLpakvQpJuTFxMSa7kneNMDBfXyXtApHYgkgSNmB3Jq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707928448; c=relaxed/simple;
	bh=VP6OWLTFU7Iwj95xAdgUR/i01Q0SJTbE9ZgKz6xmu84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbT7imKRk50jMsLAbR8c3XFuaqzi5t7/M3ga/WpP7yY66Wfw6L84QYhuVwa15KxdCSULcvKSGfYGjca3fmLU4hxNUZL6c73OIOojQpcGOpfwdfkK8I7LiJgc3JgV/7j+nNOb3+70femSLTOQicVthEzpZgqM5rEvzPmM3vV0CH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=naMmfsy+; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707928443; bh=VP6OWLTFU7Iwj95xAdgUR/i01Q0SJTbE9ZgKz6xmu84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naMmfsy+ntQ5Ahxt+D9gh8gQ4S3XLqAraQ3mSDPFsjwvXQyaXRn4eExZ2KSiUnnmX
	 X55S4dnrrdhApVmlUj8J8GCA6AqWyTsSwo7T+9hT8doo57WHXTLjK+wCtf+AaZQ7Ry
	 eCGBSKZ5vA4v3sNWgNOyyxQJ+Ei0nQebeaC0F4EM=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:42e8:c06f:a0dc:12f8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id EA013601C6;
	Thu, 15 Feb 2024 00:34:02 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v2 3/4] KVM: LoongArch: Rename _kvm_get_cpucfg to _kvm_get_cpucfg_mask
Date: Thu, 15 Feb 2024 00:33:56 +0800
Message-ID: <20240214163358.2913090-4-kernel@xen0n.name>
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

The function is not actually a getter of guest CPUCFG, but rather
validation of the input CPUCFG ID plus information about the supported
bit flags of that CPUCFG leaf. So rename it to avoid confusion.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index cc2332b056ba..e973500611b4 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -298,7 +298,7 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 	return ret;
 }
 
-static int _kvm_get_cpucfg(int id, u64 *v)
+static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
 	switch (id) {
 	case 2:
@@ -330,7 +330,7 @@ static int kvm_check_cpucfg(int id, u64 val)
 	u64 mask;
 	int ret;
 
-	ret = _kvm_get_cpucfg(id, &mask);
+	ret = _kvm_get_cpucfg_mask(id, &mask);
 	if (ret)
 		return ret;
 
@@ -557,7 +557,7 @@ static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
 	uint64_t val;
 	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
 
-	ret = _kvm_get_cpucfg(attr->attr, &val);
+	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
 	if (ret)
 		return ret;
 
-- 
2.43.0


