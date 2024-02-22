Return-Path: <kvm+bounces-9376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC9785F629
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0698D1F264A0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E821F4BA88;
	Thu, 22 Feb 2024 10:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="t0TbktWh"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2853EA7B;
	Thu, 22 Feb 2024 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599081; cv=none; b=RyhqdIWGnlnM/1a+vqydvrpkoK0eq0jmI257uwaJq0vVtLU7v6D2c312YYhs9lzp9ecoOr+GdHBV33GZZvKq6MQ2Jc2U+eRCRaV3ly+eetNGKewhzHgeS3a3P4nxF2/YWp50zQtygDKd0qq0tbUavIMOLycr/YQClC52/yWmWEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599081; c=relaxed/simple;
	bh=+kB69uQHwSK7H63LamYjOdOPcWFCgJ8ZtDGfI9wdO64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWwIyr7zo3L4R28al2xAOaGBKNZJVhoX70PLZjrZZALM8i7uhLzs4VEPGrmaKbCl+tQvvte0AOjQO650QVPcnhAmtrgaKZ/f5h4ENXbkjeybcc9K4A+x/QRZDMJM2kBI8r/BRBX4WOm4lDEOCubMt01wjE07KORRkzuHjtEWruU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=t0TbktWh; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708599077; bh=+kB69uQHwSK7H63LamYjOdOPcWFCgJ8ZtDGfI9wdO64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0TbktWhrWL0jXKnKQgj+Dhjo1VjhW4k5oVFbL7zAudpKZrF/6OC0li9EW+HZpDuk
	 wyIvd9efy4trVP3UvrVOWOZStSgss21zDa/QyXneVl0UKZBftaYgcJqM8UoZaF3RY5
	 8MllbF/de0Ks0vQRFQ7vdhDJpJKVS1fyF51+Bqrc=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:58fe:4c0e:8c24:2aff])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 78495601C8;
	Thu, 22 Feb 2024 18:51:17 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v4 2/3] LoongArch: KVM: Rename _kvm_get_cpucfg to _kvm_get_cpucfg_mask
Date: Thu, 22 Feb 2024 18:51:08 +0800
Message-ID: <20240222105109.2042732-3-kernel@xen0n.name>
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

The function is not actually a getter of guest CPUCFG, but rather
validation of the input CPUCFG ID plus information about the supported
bit flags of that CPUCFG leaf. So rename it to avoid confusion.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 7fd32de6656b..9f63bbaf19c1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -298,7 +298,7 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 	return ret;
 }
 
-static int _kvm_get_cpucfg(int id, u64 *v)
+static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
 	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
 		return -EINVAL;
@@ -339,7 +339,7 @@ static int kvm_check_cpucfg(int id, u64 val)
 	u64 mask = 0;
 	int ret;
 
-	ret = _kvm_get_cpucfg(id, &mask);
+	ret = _kvm_get_cpucfg_mask(id, &mask);
 	if (ret)
 		return ret;
 
@@ -567,7 +567,7 @@ static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
 	uint64_t val;
 	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
 
-	ret = _kvm_get_cpucfg(attr->attr, &val);
+	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
 	if (ret)
 		return ret;
 
-- 
2.43.2


