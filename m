Return-Path: <kvm+bounces-20364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88EF3914355
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA261C2185A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03FE3482C1;
	Mon, 24 Jun 2024 07:14:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442C43EA83;
	Mon, 24 Jun 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213268; cv=none; b=Wi0EhHtIcDGz55VgryuG1u9mFdFYJrA8lkKqrweYNIOZx/VpabVS5T7rpxgiOzQw2n8dGm/mfHaZR5KVodspdVQf9DABUMDaK6YK624xaaK/j3psiNEZknv074EINktDaNzd4cz3Mx3+qvJGBvg+3Arc+Z1BYpQq5r60UF87KNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213268; c=relaxed/simple;
	bh=HWbNIuQgn/nRTB1yXhow8PHsF0bgZs2f2FXGivWWCDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FrwOQl+5JcKKaKOGpy46wczijZBDtLnZvXwMmfwhmjO64jzlu07/dn4DqPmebFKEYw4YPikjBKe1EqGeljLFNm9xcvJhbngU30/veLKsZKSa78ivyfkJODDU7d+GQjtEq07PSyEMMX/kzeiO2Ho/rnbtgDQP/kWbhzkA0IhZZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxcPDRHHlmFnEJAA--.38408S3;
	Mon, 24 Jun 2024 15:14:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S6;
	Mon, 24 Jun 2024 15:14:24 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 4/7] LoongArch: KVM: Add memory barrier before update pmd entry
Date: Mon, 24 Jun 2024 15:14:19 +0800
Message-Id: <20240624071422.3473789-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
References: <20240624071422.3473789-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

When updating pmd entry such as allocating new pmd page or splitting
huge page into normal page, it is necessary to firstly update all pte
entries, and then update pmd entry.

It is weak order with LoongArch system, there will be problem if other
vcpus sees pmd update firstly however pte is not updated. Here smp_wmb()
is added to assure this.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 1690828bd44b..092c063e4e56 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *kvm,
 
 			child = kvm_mmu_memory_cache_alloc(cache);
 			_kvm_pte_init(child, ctx.invalid_ptes[ctx.level - 1]);
+			smp_wmb(); /* make pte visible before pmd */
 			kvm_set_pte(entry, __pa(child));
 		} else if (kvm_pte_huge(*entry)) {
 			return entry;
@@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu *vcpu, kvm_pte_t *ptep, gfn_t g
 		val += PAGE_SIZE;
 	}
 
+	smp_wmb(); /* make pte visible before pmd */
 	/* The later kvm_flush_tlb_gpa() will flush hugepage tlb */
 	kvm_set_pte(ptep, __pa(child));
 
-- 
2.39.3


