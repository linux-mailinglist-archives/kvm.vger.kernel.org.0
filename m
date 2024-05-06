Return-Path: <kvm+bounces-16608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C998BC628
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F19F2818EE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC1242073;
	Mon,  6 May 2024 03:19:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9B338DFB
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 03:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714965550; cv=none; b=kuwBkFX6rk8cP4yPLU8wRfVCUUO9BmzsqjKItwBygTyXQ0Jge5G+aGZ3NivY2xsllMZLFtKt9gVm6fzw2VNOXC80C0mnrVO4nQvwO1i/8B+wj1Im5TpGP/kzfSnvpqfX4jhamucaV/oI4/zLTTrOFs90fGiws8bSjXRr+twtSss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714965550; c=relaxed/simple;
	bh=6i9dKdkzd1XUYVGG44haxEErePBysu8/ttJswrKDBdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aU/eZrSvodN8Un+scA9WpNVZua+6ZUglZgjcHb+91l8x/yTDnO3f8j4FrkYis3ZuJKIFX8nOZhy+MNEhddoaycMuk30IFEHOTwReoOcTs5jeErdcZGc8SWCqTf6onY6tgOdvEq/6Fxh9lwBBjLwaQ+Rg3QzVFfoQCn9DSsSMONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id D53697F0005E;
	Mon,  6 May 2024 11:11:12 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH 3/3] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
Date: Mon,  6 May 2024 11:11:06 +0800
Message-Id: <20240506031106.3894-4-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
In-Reply-To: <20240506031106.3894-1-lirongqing@baidu.com>
References: <20240506031106.3894-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

save_area of per-CPU svm_data is dominantly accessed from their
own local CPUs, allocate them node-local for performance reason

so rename __snp_safe_alloc_page as snp_safe_alloc_page_node which
accepts numa node id as input parameter, svm_cpu_init calls it with
node id switched from cpu id

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/svm/svm.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 24608a2..8a19dd8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3179,13 +3179,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
 
-struct page *__snp_safe_alloc_page(gfp_t gfp)
+struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
 	unsigned long pfn;
 	struct page *p;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return alloc_page(gfp | __GFP_ZERO);
+		return alloc_pages_node(node, gfp | __GFP_ZERO, 0);
 
 	/*
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
@@ -3196,7 +3196,7 @@ struct page *__snp_safe_alloc_page(gfp_t gfp)
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
 	 */
-	p = alloc_pages(gfp | __GFP_ZERO, 1);
+	p = alloc_pages_node(node, gfp | __GFP_ZERO, 1);
 	if (!p)
 		return NULL;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c01dc9b..8df05f2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = __snp_safe_alloc_page(GFP_KERNEL);
+	sd->save_area = snp_safe_alloc_page_node(cpu_to_node(cpu), GFP_KERNEL);
 	if (!sd->save_area)
 		return ret;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bbea3ee..982e42b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -695,11 +695,11 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
-struct page *__snp_safe_alloc_page(gfp_t gfp);
+struct page *snp_safe_alloc_page_node(int node, gfp_t gfp);
 
 static inline struct page *snp_safe_alloc_page(void)
 {
-	return __snp_safe_alloc_page(GFP_KERNEL_ACCOUNT);
+	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
 }
 /* vmenter.S */
 
-- 
2.9.4


