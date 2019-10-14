Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5658D677F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbfJNQhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 12:37:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:2181 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732550AbfJNQhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 12:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 09:37:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="198343502"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by orsmga003.jf.intel.com with ESMTP; 14 Oct 2019 09:37:50 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: X86: Make fpu allocation a common function
Date:   Tue, 15 Oct 2019 00:22:47 +0800
Message-Id: <20191014162247.61461-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
and SVM. Make them common functions.

No functional change intended.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/svm.c     | 20 +++-----------------
 arch/x86/kvm/vmx/vmx.c | 20 +++-----------------
 arch/x86/kvm/x86.h     | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e479ea9bc9da..0116a3c37a07 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2156,21 +2156,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto out;
 	}
 
-	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
+	err = kvm_vcpu_create_fpu(&svm->vcpu);
+	if (err)
 		goto free_partial_svm;
-	}
-
-	svm->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
-		goto free_user_fpu;
-	}
 
 	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
 	if (err)
@@ -2231,9 +2219,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 uninit:
 	kvm_vcpu_uninit(&svm->vcpu);
 free_svm:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
+	kvm_vcpu_free_fpu(&svm->vcpu);
 free_partial_svm:
 	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e660e28e9ae0..53d9298ff648 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6710,21 +6710,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
 
-	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
+	err = kvm_vcpu_create_fpu(&vmx->vcpu);
+	if (err)
 		goto free_partial_vcpu;
-	}
-
-	vmx->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
-		goto free_user_fpu;
-	}
 
 	vmx->vpid = allocate_vpid();
 
@@ -6825,9 +6813,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	kvm_vcpu_uninit(&vmx->vcpu);
 free_vcpu:
 	free_vpid(vmx->vpid);
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
+	kvm_vcpu_free_fpu(&vmx->vcpu);
 free_partial_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 45d82b8277e5..c27e7ac91337 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,4 +367,30 @@ static inline bool kvm_pat_valid(u64 data)
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 
+static inline int kvm_vcpu_create_fpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+			GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
+		return -ENOMEM;
+	}
+
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+			GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
+		kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline void kvm_vcpu_free_fpu(struct kvm_vcpu *vcpu)
+{
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+}
+
 #endif
-- 
2.19.1

