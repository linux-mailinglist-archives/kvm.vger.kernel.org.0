Return-Path: <kvm+bounces-17759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E1C8C9D29
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 177331F2282A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4623C55E51;
	Mon, 20 May 2024 12:26:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0D954675
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716207960; cv=none; b=dAoZI9n02ZTs7VbYnljv5Tz9w/lSt5MwAxHWkG7jYwKqFxUom86Y5gLF9TeodoPr6alQW1wrew2V1anUC53WwflUNqgKxgu/56m10cdFKPWwizbbc5BMCMDo9jip/B16/2CMvrsmkYniyhKZTe3svdvsEUkSxxJjORFHj6IE43k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716207960; c=relaxed/simple;
	bh=pQXuMN1J+NW0fVHrV6UqwA+UkRsMzsfN5rm2DQ8kPHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ubUPxlsi8lzlqfWdnWa5IDyjGCqA2tto/BXdHzvInpME81izFSVBp4QNVIoOSU9JEluKXZ/qwbtVhjYN22JPZNBMfTYoy0bG9EvcqMAKmFAJVnQxJ2qmiiLuQcbx9PuQ5vDbunSpNJPk/bZ1iPzQhrex7SwpSTXB8cS8X6Nd0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id CF0687F00053;
	Mon, 20 May 2024 20:09:03 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v3 2/3] KVM: SVM: not account memory allocation for per-CPU svm_data
Date: Mon, 20 May 2024 20:08:57 +0800
Message-Id: <20240520120858.13117-3-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
In-Reply-To: <20240520120858.13117-1-lirongqing@baidu.com>
References: <20240520120858.13117-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The allocation for the per-CPU save area in svm_cpu_init shouldn't
be accounted, So introduce  __snp_safe_alloc_page helper, which has
gfp flag as input, svm_cpu_init calls __snp_safe_alloc_page with
GFP_KERNEL, snp_safe_alloc_page calls __snp_safe_alloc_page with
GFP_KERNEL_ACCOUNT as input

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/svm/svm.h | 15 +++++++++++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ac8a324..4d53478 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3380,13 +3380,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	}
 }
 
-struct page *snp_safe_alloc_page(void)
+struct page *__snp_safe_alloc_page(gfp_t gfp)
 {
 	unsigned long pfn;
 	struct page *p;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		return alloc_page(gfp | __GFP_ZERO);
 
 	/*
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
@@ -3397,7 +3397,7 @@ struct page *snp_safe_alloc_page(void)
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
 	 */
-	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	p = alloc_pages(gfp | __GFP_ZERO, 1);
 	if (!p)
 		return NULL;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e6eb225..adbd676 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = snp_safe_alloc_page();
+	sd->save_area = __snp_safe_alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
 		return ret;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 80fa458..e0a1258 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,7 +694,13 @@ void sev_guest_memory_reclaimed(struct kvm *kvm);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 
 /* These symbols are used in common code and are stubbed below.  */
-struct page *snp_safe_alloc_page(void);
+struct page *__snp_safe_alloc_page(gfp_t gfp);
+
+static inline struct page *snp_safe_alloc_page(void)
+{
+	return __snp_safe_alloc_page(GFP_KERNEL_ACCOUNT);
+}
+
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
@@ -704,9 +710,14 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 #else
+static inline struct page *__snp_safe_alloc_page(gfp_t gfp)
+{
+	return alloc_page(gfp | __GFP_ZERO);
+}
+
 static inline struct page *snp_safe_alloc_page(void)
 {
-	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return __snp_safe_alloc_page(GFP_KERNEL_ACCOUNT);
 }
 
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
-- 
2.9.4


