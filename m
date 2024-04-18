Return-Path: <kvm+bounces-15051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1258A916A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 05:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35D08B2151A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 03:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B014F606;
	Thu, 18 Apr 2024 03:07:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8993433BC
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 03:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713409639; cv=none; b=chmLB6ABe0Fo/bhknHo25DK33Aei+oxCuJy5zDnj98qtBY+y/mKQ7+3Yc515gpYnmFOkfbL6cx0+jGsb3EY/VUs6tg+Dl+Br2qFE2+bujSWj4LOGHmdnRlJ0aWU9fZKAPNA4+7ZxWvEZLTnv4VD/A4hHYEO4aHzb62S0Rz1/+AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713409639; c=relaxed/simple;
	bh=eLGYf9+4xKjaA3w9rXH6UWaMDq+2OZIUXroleEk31Ko=;
	h=From:To:Cc:Subject:Date:Message-Id; b=LCtd/nRvLd/FX5ftip1GBooOVeDI4RDI+FlnBNnusFl2mek5pHv/0y2GW7/Rya1g04jgi6NjPFsMXV2yETfqVEwJNxXwrBKgCKqNDo8bOLpnZAPW+wybyTz1xUSZAIHKs+pxQABCcoEADMq9goJX3X+KYmhC+d9WSAfZ5CWffBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 171CA7F0005E;
	Thu, 18 Apr 2024 11:07:06 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
Date: Thu, 18 Apr 2024 11:07:03 +0800
Message-Id: <20240418030703.38628-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

save_area of per-CPU svm_data are dominantly accessed from their
own local CPUs, so allocate them node-local for performance reason

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/svm/svm.h | 6 +++++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 61a7531..cce8ec7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3179,13 +3179,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
 
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+struct page *snp_safe_alloc_page_node(struct kvm_vcpu *vcpu, int node)
 {
 	unsigned long pfn;
 	struct page *p;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		return alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0);
 
 	/*
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
@@ -3196,7 +3196,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
 	 */
-	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	p = alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
 	if (!p)
 		return NULL;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1a9f995..69fc809 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = snp_safe_alloc_page(NULL);
+	sd->save_area = snp_safe_alloc_page_node(NULL, cpu_to_node(cpu));
 	if (!sd->save_area)
 		return ret;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f1fbd8..3bbf638 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,8 +694,12 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+struct page *snp_safe_alloc_page_node(struct kvm_vcpu *vcpu, int node);
 
+static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+{
+	return snp_safe_alloc_page_node(vcpu, NUMA_NO_NODE);
+}
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
-- 
2.9.4


