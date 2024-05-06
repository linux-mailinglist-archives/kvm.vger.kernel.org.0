Return-Path: <kvm+bounces-16609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8064F8BC629
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CD2D1F218AF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2581643AD2;
	Mon,  6 May 2024 03:19:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx311.baidu.com [180.101.52.76])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A61338384
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 03:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714965552; cv=none; b=LmTE6TQl2QyBR81t0rBZ8wkTrKU0HxjlWhlh9U3voXOfjaZ97Pmo7MxmA/lwVsDrgshORr2+ywv0RzNkvls+fDvZZUC3eKKG4Opniy/ifwYCTxdBytictCZsWgUvQ8aFH2uTyLyomdAcVmYr43G+yv2YTGtdoeGRs/bgfKAq2Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714965552; c=relaxed/simple;
	bh=fr2/HoE1E1U4ffytpEpBB40r7FzqncyNbI1Qw+0LsBU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ntjyobK7t4+v+R6RD98P3js7kw0o3OMt7gtuvdmpKRHB2AbQr9+n29EqOJKllrn2S4B8+m5idSRGS0w8+kHQx4ZbwDlW0aFO1z7esSxPs65YzEiaakmmGPwMohBYiuK8ClohUGI5+F9bMP5qwLHIlR2lHt+jX8d9zLgNeFq3SS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id CFBEE7F0005D;
	Mon,  6 May 2024 11:11:10 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH 1/3] KVM: SVM: remove useless input parameter in snp_safe_alloc_page
Date: Mon,  6 May 2024 11:11:04 +0800
Message-Id: <20240506031106.3894-2-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
In-Reply-To: <20240506031106.3894-1-lirongqing@baidu.com>
References: <20240506031106.3894-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The input parameter 'vcpu' in snp_safe_alloc_page is not used.
Therefore, remove it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/sev.c    | 2 +-
 arch/x86/kvm/svm/svm.c    | 8 ++++----
 arch/x86/kvm/svm/svm.h    | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 55b9a6d..6f704c1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1181,7 +1181,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (svm->nested.initialized)
 		return 0;
 
-	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
+	vmcb02_page = snp_safe_alloc_page();
 	if (!vmcb02_page)
 		return -ENOMEM;
 	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 759581b..ec4f6f2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3179,7 +3179,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
 
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+struct page *snp_safe_alloc_page(void)
 {
 	unsigned long pfn;
 	struct page *p;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8..a887a2f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = snp_safe_alloc_page(NULL);
+	sd->save_area = snp_safe_alloc_page();
 	if (!sd->save_area)
 		return ret;
 
@@ -1421,7 +1421,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = snp_safe_alloc_page(vcpu);
+	vmcb01_page = snp_safe_alloc_page();
 	if (!vmcb01_page)
 		goto out;
 
@@ -1430,7 +1430,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = snp_safe_alloc_page(vcpu);
+		vmsa_page = snp_safe_alloc_page();
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4906,7 +4906,7 @@ static int svm_vm_init(struct kvm *kvm)
 
 static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
 {
-	struct page *page = snp_safe_alloc_page(vcpu);
+	struct page *page = snp_safe_alloc_page();
 
 	if (!page)
 		return NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 33878ef..79b76de 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,7 +694,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+struct page *snp_safe_alloc_page(void);
 
 /* vmenter.S */
 
-- 
2.9.4


