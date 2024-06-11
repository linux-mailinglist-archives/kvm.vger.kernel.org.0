Return-Path: <kvm+bounces-19291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1B7902F2F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54ABFB2205A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1E616F918;
	Tue, 11 Jun 2024 03:46:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A20F64B;
	Tue, 11 Jun 2024 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077576; cv=none; b=YO1cU+D3RWpGT72A+wKt1VHgRkUumJWH54BEtb6AntMSJN9D9uGNw5NOqAdX9q4hecPxYlhVR83IBW4KzTk5v3NAPwf6M3jO6Cj+iQzkMWb6iPQrWGUwaz19ilWEgqoJ8QlgAy/+7JjwYyStqKXHA8W0KkTe89ZJGFNZaBROF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077576; c=relaxed/simple;
	bh=0BH+fAS9ZOA6hr0JSTRf8Cs4cB23bbOhM+PVeB1ZOAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aOmSbOadJKKF+DgUtKycZetEHEJlIMthi6w/xmnVyKw2B35QlZGKAjws+46NuJZTlavT7nfirWiPbbklNuR+EUdCyYAbSjV6nrRGgCfDhpzYmpFQgEziFmKpPfKI/0PmPXMRd0DEmR159y0Rn4yPnFKgdAA19KY9zNs2UJlRJC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Ax3eqCyGdmwo0FAA--.22746S3;
	Tue, 11 Jun 2024 11:46:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxBMWCyGdme5sbAA--.57783S2;
	Tue, 11 Jun 2024 11:46:10 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Mark page accessed and dirty with mmu_lock
Date: Tue, 11 Jun 2024 11:46:09 +0800
Message-Id: <20240611034609.3442344-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxBMWCyGdme5sbAA--.57783S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_set_pfn_accessed() is somewhat complicated, originally
we want to reduce coverity range of mmu_lock, so move function
kvm_set_pfn_accessed() and kvm_set_pfn_dirty() out of mmu_lock.

However with migration test where vm has some workload, there is no
response when VM finishes migration. When mmu_lock is released, pfn page
may be replaced with other pages, it is unreasonable to set old replaced
pfn page with accessed or dirty.

Here move function kvm_set_pfn_accessed() and kvm_set_pfn_dirty() with
mmu_lock held, VM works after many times of migrations.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/mmu.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ec8c43aad724..91998e95db87 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -591,21 +591,14 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 	if (changed) {
 		kvm_set_pte(ptep, new);
 		pfn = kvm_pte_pfn(new);
-	}
-	spin_unlock(&kvm->mmu_lock);
-
-	/*
-	 * Fixme: pfn may be freed after mmu_lock
-	 * kvm_try_get_pfn(pfn)/kvm_release_pfn pair to prevent this?
-	 */
-	if (kvm_pte_young(changed))
-		kvm_set_pfn_accessed(pfn);
+		if (kvm_pte_young(changed))
+			kvm_set_pfn_accessed(pfn);
 
-	if (kvm_pte_dirty(changed)) {
-		mark_page_dirty(kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
+		if (kvm_pte_dirty(changed)) {
+			mark_page_dirty(kvm, gfn);
+			kvm_set_pfn_dirty(pfn);
+		}
 	}
-	return ret;
 out:
 	spin_unlock(&kvm->mmu_lock);
 	return ret;

base-commit: 2df0193e62cf887f373995fb8a91068562784adc
-- 
2.39.3


