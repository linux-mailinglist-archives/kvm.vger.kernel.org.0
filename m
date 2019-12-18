Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6012560B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLRV7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:59:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:54823 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfLRVzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108030"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 06/45] KVM: SVM: Use direct vcpu pointer during vCPU create/free
Date:   Wed, 18 Dec 2019 13:54:51 -0800
Message-Id: <20191218215530.2280-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the vcpu pointer in a local varaible and replace '&svm->vcpu'
references with a direct reference to the pointer in anticipation of
moving bits of the code to common x86 and passing the vcpu pointer into
svm_create_vcpu(), i.e. eliminate unnecessary noise from future patches.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f1b715dfde8..1afa10cf365f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2146,6 +2146,7 @@ static int avic_init_vcpu(struct vcpu_svm *svm)
 
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 {
+	struct kvm_vcpu *vcpu;
 	struct vcpu_svm *svm;
 	struct page *page;
 	struct page *msrpm_pages;
@@ -2161,24 +2162,25 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 		err = -ENOMEM;
 		goto out;
 	}
+	vcpu = &svm->vcpu;
 
-	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.user_fpu) {
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
 		err = -ENOMEM;
 		goto free_partial_svm;
 	}
 
-	svm->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						     GFP_KERNEL_ACCOUNT);
-	if (!svm->vcpu.arch.guest_fpu) {
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						 GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
 		err = -ENOMEM;
 		goto free_user_fpu;
 	}
 
-	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
+	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
 		goto free_svm;
 
@@ -2222,9 +2224,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
-	svm_init_osvw(&svm->vcpu);
+	svm_init_osvw(vcpu);
 
-	return &svm->vcpu;
+	return vcpu;
 
 free_page4:
 	__free_page(hsave_page);
@@ -2235,11 +2237,11 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 free_page1:
 	__free_page(page);
 uninit:
-	kvm_vcpu_uninit(&svm->vcpu);
+	kvm_vcpu_uninit(vcpu);
 free_svm:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 free_partial_svm:
 	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
@@ -2270,8 +2272,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
 
-- 
2.24.1

