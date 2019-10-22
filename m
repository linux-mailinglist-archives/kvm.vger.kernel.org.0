Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BAEDFA70
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbfJVB7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730778AbfJVB7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293757"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/45] KVM: VMX: Use direct vcpu pointer during vCPU create/free
Date:   Mon, 21 Oct 2019 18:58:45 -0700
Message-Id: <20191022015925.31916-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the vcpu pointer in a local varaible and replace '&vmx->vcpu'
references with a direct reference to the pointer in anticipation of
moving bits of the code to common x86 and passing the vcpu pointer into
vmx_create_vcpu(), i.e. eliminate unnecessary noise from future patches.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 501e88bd6204..70b8d15eb2c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6691,17 +6691,17 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
 static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
-	int err;
+	struct kvm_vcpu *vcpu;
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
-	int cpu;
+	int cpu, err;
 
 	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
 		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
@@ -6710,23 +6710,25 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
 
-	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.user_fpu) {
+	vcpu = &vmx->vcpu;
+
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
 		err = -ENOMEM;
 		goto free_partial_vcpu;
 	}
 
-	vmx->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-			GFP_KERNEL_ACCOUNT);
-	if (!vmx->vcpu.arch.guest_fpu) {
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						 GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
 		err = -ENOMEM;
 		goto free_user_fpu;
 	}
 
-	err = kvm_vcpu_init(&vmx->vcpu, kvm, id);
+	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
 		goto free_vcpu;
 
@@ -6775,12 +6777,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
 	cpu = get_cpu();
-	vmx_vcpu_load(&vmx->vcpu, cpu);
-	vmx->vcpu.cpu = cpu;
+	vmx_vcpu_load(vcpu, cpu);
+	vcpu->cpu = cpu;
 	vmx_vcpu_setup(vmx);
-	vmx_vcpu_put(&vmx->vcpu);
+	vmx_vcpu_put(vcpu);
 	put_cpu();
-	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {
+	if (cpu_need_virtualize_apic_accesses(vcpu)) {
 		err = alloc_apic_access_page(kvm);
 		if (err)
 			goto free_vmcs;
@@ -6795,7 +6797,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
 					   vmx_capability.ept,
-					   kvm_vcpu_apicv_active(&vmx->vcpu));
+					   kvm_vcpu_apicv_active(vcpu));
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
@@ -6813,7 +6815,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	vmx->ept_pointer = INVALID_PAGE;
 
-	return &vmx->vcpu;
+	return vcpu;
 
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -6822,12 +6824,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 uninit_vcpu:
-	kvm_vcpu_uninit(&vmx->vcpu);
+	kvm_vcpu_uninit(vcpu);
 	free_vpid(vmx->vpid);
 free_vcpu:
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 free_partial_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
-- 
2.22.0

