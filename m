Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897FDD7C76
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388363AbfJOQzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:55:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:46855 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfJOQzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:55:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:55:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201811368"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 09:55:34 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: X86: Make vcpu's FPU allocation a common function
Date:   Wed, 16 Oct 2019 00:40:33 +0800
Message-Id: <20191015164033.87276-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191015164033.87276-1-xiaoyao.li@intel.com>
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
and SVM. Make them common functions and delay it a little bit later
after .create_vcpu.

No functional change intended.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/svm.c     | 18 ------------------
 arch/x86/kvm/vmx/vmx.c | 18 ------------------
 arch/x86/kvm/x86.c     | 24 ++++++++++++++++++++++++
 3 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d35ef5456462..cbb5f5b9a9e7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2181,20 +2181,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!svm)
 		goto out;
 
-	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		goto free_partial_svm;
-	}
-
-	svm->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		goto free_user_fpu;
-	}
-
 	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
 		goto free_svm;
@@ -2228,10 +2214,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 free_page1:
 	__free_page(page);
 free_svm:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
-free_partial_svm:
 	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
 	return ERR_PTR(err);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f54a3bcb6a5..183112604f04 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6773,20 +6773,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx)
 		goto out;
 
-	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		goto free_partial_vcpu;
-	}
-
-	vmx->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		goto free_user_fpu;
-	}
-
 	vmx->vpid = allocate_vpid();
 
 	/*
@@ -6822,10 +6808,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	vmx_destroy_pml_buffer(vmx);
 free_vcpu:
 	free_vpid(vmx->vpid);
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
-free_partial_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 out:
 	return ERR_PTR(err);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd9f1a1f0f01..c4b477a9c7f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9021,6 +9021,26 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	free_cpumask_var(wbinvd_dirty_mask);
 }
 
+static int kvm_vcpu_create_fpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+			GFP_KERNEL_ACCOUNT);
+	if (vcpu->arch.user_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
+		return -ENOMEM;
+	}
+
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+			GFP_KERNEL_ACCOUNT);
+	if (vcpu->arch.guest_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
+		kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
@@ -9036,6 +9056,10 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (IS_ERR(vcpu))
 		return vcpu;
 
+	err = kvm_vcpu_create_fpu(vcpu);
+	if (err)
+		return ERR_PTR(err);
+
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err) {
 		kvm_x86_ops->vcpu_free(vcpu);
-- 
2.19.1

