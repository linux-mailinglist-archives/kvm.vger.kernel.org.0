Return-Path: <kvm+bounces-17757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F398C9D26
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 795931C21F9B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67E054FA0;
	Mon, 20 May 2024 12:26:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx311.baidu.com [180.101.52.76])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24A853E25
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716207960; cv=none; b=KRdWc+L82zjzrRIGnYEo2It/JjqwD0wF9659k7v371Tx3FTm91prDeGx7LUTeS3m3dLFbknaeX98dINsjmb2vSlFy8zKS3fexXZp1B4j+7RbSCOmSzU8e5axq7YiNVaX0+xOC3jNI2CitaGPxWX8R1jXwRKjWYDOh2v45tei6sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716207960; c=relaxed/simple;
	bh=FeteuDNWyo9YgUXcFNjHzPOcPs/8C9rgXRrk0YME7Uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=qHmDC9u8krNnJxV1hbnekVfhNlBVlNrUSdWv9CwtnGd5YNpZS86QAZdtVTWRKhihKJScida8hnDRWiaBfmZsvnEfdsRmE7yGbKEZ6ug9s7V4JR3DcBhaMEEqRkkwn+xHVgUUu2l3Sxeq6z/A7jFQE8Qbvpiqp/uthxBD0DYrwis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id CB0F07F0005A;
	Mon, 20 May 2024 20:09:04 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v3 3/3] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
Date: Mon, 20 May 2024 20:08:58 +0800
Message-Id: <20240520120858.13117-4-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
In-Reply-To: <20240520120858.13117-1-lirongqing@baidu.com>
References: <20240520120858.13117-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

save_area of per-CPU svm_data are dominantly accessed from their
own local CPUs, so allocate them node-local for performance reason

so rename __snp_safe_alloc_page as snp_safe_alloc_page_node which
accepts numa node id as input parameter, svm_cpu_init call it with
node id switched from cpu id

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/svm/svm.h | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4d53478..1c55159 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3380,13 +3380,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	}
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
@@ -3397,7 +3397,7 @@ struct page *__snp_safe_alloc_page(gfp_t gfp)
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
 	 */
-	p = alloc_pages(gfp | __GFP_ZERO, 1);
+	p = alloc_pages_node(node, gfp | __GFP_ZERO, 1);
 	if (!p)
 		return NULL;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index adbd676..da5cdde 100644
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
index e0a1258..8983eab 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,11 +694,11 @@ void sev_guest_memory_reclaimed(struct kvm *kvm);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 
 /* These symbols are used in common code and are stubbed below.  */
-struct page *__snp_safe_alloc_page(gfp_t gfp);
 
+struct page *snp_safe_alloc_page_node(int node, gfp_t gfp);
 static inline struct page *snp_safe_alloc_page(void)
 {
-	return __snp_safe_alloc_page(GFP_KERNEL_ACCOUNT);
+	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
@@ -710,14 +710,14 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 #else
-static inline struct page *__snp_safe_alloc_page(gfp_t gfp)
+static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
-	return alloc_page(gfp | __GFP_ZERO);
+	return alloc_pages_node(node, gfp | __GFP_ZERO, 0);
 }
 
 static inline struct page *snp_safe_alloc_page(void)
 {
-	return __snp_safe_alloc_page(GFP_KERNEL_ACCOUNT);
+	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
 }
 
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
-- 
2.9.4


