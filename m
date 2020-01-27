Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7B149E03
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 01:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgA0AlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 19:41:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:63120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0AlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 19:41:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 16:41:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="223116780"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2020 16:41:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Directly return __vmalloc() result in ->vm_alloc()
Date:   Sun, 26 Jan 2020 16:41:12 -0800
Message-Id: <20200127004113.25615-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127004113.25615-1-sean.j.christopherson@intel.com>
References: <20200127004113.25615-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly return the __vmalloc() result in {svm,vmx}_vm_alloc() to pave
the way for handling VM alloc/free in common x86 code, and to obviate
the need to check the result of __vmalloc() in vendor specific code.
Add a build-time assertion to ensure each structs' "kvm" field stays at
offset 0, which allows interpreting a "struct kvm_{svm,vmx}" as a
"struct kvm".

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 12 ++++--------
 arch/x86/kvm/vmx/vmx.c | 12 ++++--------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6565257dea39..4fff99722487 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1948,19 +1948,15 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 
 static struct kvm *svm_vm_alloc(void)
 {
-	struct kvm_svm *kvm_svm = __vmalloc(sizeof(struct kvm_svm),
-					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-					    PAGE_KERNEL);
+	BUILD_BUG_ON(offsetof(struct kvm_svm, kvm) != 0);
 
-	if (!kvm_svm)
-		return NULL;
-
-	return &kvm_svm->kvm;
+	return __vmalloc(sizeof(struct kvm_svm),
+			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
 }
 
 static void svm_vm_free(struct kvm *kvm)
 {
-	vfree(to_kvm_svm(kvm));
+	vfree(kvm);
 }
 
 static void sev_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 45f3f215e9df..17e449330c8a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6659,20 +6659,16 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 static struct kvm *vmx_vm_alloc(void)
 {
-	struct kvm_vmx *kvm_vmx = __vmalloc(sizeof(struct kvm_vmx),
-					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-					    PAGE_KERNEL);
+	BUILD_BUG_ON(offsetof(struct kvm_vmx, kvm) != 0);
 
-	if (!kvm_vmx)
-		return NULL;
-
-	return &kvm_vmx->kvm;
+	return __vmalloc(sizeof(struct kvm_vmx),
+			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
 }
 
 static void vmx_vm_free(struct kvm *kvm)
 {
 	kfree(kvm->arch.hyperv.hv_pa_pg);
-	vfree(to_kvm_vmx(kvm));
+	vfree(kvm);
 }
 
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
-- 
2.24.1

