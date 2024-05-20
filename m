Return-Path: <kvm+bounces-17758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8A88C9D28
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7093D1F229E8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4617855E45;
	Mon, 20 May 2024 12:26:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx313.baidu.com [180.101.52.140])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FA652F74
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716207960; cv=none; b=lUb3X12qiTnUQefU7ojCoNtb3CkWG2ph+iKnL8yUSYIbzJyQnhiKyMzE2t5q1XwjJ6bDlkg0uyGJJxmlJz5zgotPjLCuKII6E2zyNedpI+MleVJ22LsHVbHF3wkDbaaEKR3etX8E1YZEfdS5dsnGEtZ9otJO1zidnOUmXyekvMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716207960; c=relaxed/simple;
	bh=4itVVppZz371PbgKgpLu7U2V9GU6roTHpNOjJLevAmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=FZcszxUu2jFk77ZIBarR+LZG/CMjQf/s+PNnVC/30Aek8vL8IWHGmpqJ664ja1vDJnQ1qkrEeMsMdAgx029FK6+/4eCu/SPQ1yRkKNp9Anv2vFzAsyRRo6TK/2ZBK05YZz+H29uEzAoxVG48WEnI0klXHOy/FP8LIBus5VXp/jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id C45EB7F0003D;
	Mon, 20 May 2024 20:09:02 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v3 1/3] KVM: SVM: remove useless input parameter in snp_safe_alloc_page
Date: Mon, 20 May 2024 20:08:56 +0800
Message-Id: <20240520120858.13117-2-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
In-Reply-To: <20240520120858.13117-1-lirongqing@baidu.com>
References: <20240520120858.13117-1-lirongqing@baidu.com>
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
 arch/x86/kvm/svm/svm.h    | 5 +++--
 4 files changed, 9 insertions(+), 8 deletions(-)

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
index 0623cfa..ac8a324 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3380,7 +3380,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	}
 }
 
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+struct page *snp_safe_alloc_page(void)
 {
 	unsigned long pfn;
 	struct page *p;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8dc258..e6eb225 100644
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
 	}
@@ -4920,7 +4920,7 @@ static int svm_vm_init(struct kvm *kvm)
 
 static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
 {
-	struct page *page = snp_safe_alloc_page(vcpu);
+	struct page *page = snp_safe_alloc_page();
 
 	if (!page)
 		return NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be57213..80fa458 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,7 +694,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 
 /* These symbols are used in common code and are stubbed below.  */
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+struct page *snp_safe_alloc_page(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
@@ -704,7 +704,8 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 #else
-static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
+static inline struct page *snp_safe_alloc_page(void)
+{
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
-- 
2.9.4


