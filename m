Return-Path: <kvm+bounces-8658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB75854714
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 11:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A158286F27
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 10:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4777818E14;
	Wed, 14 Feb 2024 10:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="cOXRPrNH"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31C17580;
	Wed, 14 Feb 2024 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707906251; cv=none; b=Qf1eM5pBlmM4diWjd0xnMZTc3II49uzoy/QGSwRmoUXPwncFQHXJoFl/PS9RwVShM5dhrZAn19tHmVAmdMFjD6fbyPzle5SCEiM4Skv09G3vC2hXhreYsUK8b4dIXiGQkUu0fNMISBms+8AefoDuOkS712vBZr9FMgyJVkld0cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707906251; c=relaxed/simple;
	bh=UEF3EtzASKcetwcq4bXXyQ5NmYXr4KVcBieRDjHk7ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmF+v2zuuLJ+cZXvpiGtgGFjtsOdQ3BrWdjiYCtA4X3BKb6Dhuth1CaUnnzfxtsYpApDVILM/9nMkCaLHMWi1YLa5neZSkVHz/fgldzO9dQWPeKdQ7vl4eOzbVsoQnsQrkL/EdSDCwN8QMrWUSiB1HSbMhBu2k5pKdH6+I9h1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=cOXRPrNH; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707905768; bh=UEF3EtzASKcetwcq4bXXyQ5NmYXr4KVcBieRDjHk7ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOXRPrNHUvE8DHxSgDP4KOW6f/OrLuGnwlp5dJvrkprvNZtiBseCBWzy34+S2cOTV
	 dKjfN/r4Z98QKBWNK3waITUgB5aV9t5UEheqlf46SUTbg2tDX5NboTSAp6G3iaD3Xv
	 rGeZl+8u96PemsRIQ8TRmwxJnF7t4DD5z+er+/dM=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:5531:eef6:1274:cebe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id A1FE5601C6;
	Wed, 14 Feb 2024 18:16:08 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 4/5] KVM: LoongArch: Streamline control flow of kvm_check_cpucfg
Date: Wed, 14 Feb 2024 18:15:56 +0800
Message-ID: <20240214101557.2900512-5-kernel@xen0n.name>
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

All the checks currently done in kvm_check_cpucfg can be realized with
early returns, so just do that to avoid extra cognitive burden related
to the return value handling.

The default branch is unreachable because of the earlier validation by
_kvm_get_cpucfg_mask, so mark it as such too to make things clearer.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index e973500611b4..9e108ffaba30 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -339,24 +339,23 @@ static int kvm_check_cpucfg(int id, u64 val)
 		/* CPUCFG2 features checking */
 		if (val & ~mask)
 			/* The unsupported features should not be set */
-			ret = -EINVAL;
-		else if (!(val & CPUCFG2_LLFTP))
+			return -EINVAL;
+		if (!(val & CPUCFG2_LLFTP))
 			/* The LLFTP must be set, as guest must has a constant timer */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
+			return -EINVAL;
+		if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
 			/* Single and double float point must both be set when enable FP */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
+			return -EINVAL;
+		if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
 			/* FP should be set when enable LSX */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
+			return -EINVAL;
+		if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
 			/* LSX, FP should be set when enable LASX, and FP has been checked before. */
-			ret = -EINVAL;
-		break;
+			return -EINVAL;
+		return 0;
 	default:
-		break;
+		unreachable();
 	}
-	return ret;
 }
 
 static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
-- 
2.43.0


