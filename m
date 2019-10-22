Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEF5DFB2E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbfJVCDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:03:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730863AbfJVB7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293778"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:37 -0700
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
Subject: [PATCH 09/45] KVM: x86: Move allocation of pio_data page down a few lines
Date:   Mon, 21 Oct 2019 18:58:49 -0700
Message-Id: <20191022015925.31916-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the pio_data page after creating the MMU and local APIC so that
all direct memory allocations are grouped together.  This allows setting
the return value to -ENOMEM prior to starting the allocations instead of
setting it in the fail path for every allocation.

The pio_data page is only consumed when KVM_RUN is invoked, i.e. moving
its allocation has no real functional impact.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 777a29b3c38b..b33ca472ff4f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9338,18 +9338,11 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
-		goto fail;
-	}
-	vcpu->arch.pio_data = page_address(page);
-
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
-		goto fail_free_pio_data;
+		return r;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
@@ -9359,25 +9352,27 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	} else
 		static_key_slow_inc(&kvm_no_apic_vcpu);
 
+	r = -ENOMEM;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto fail_free_lapic;
+	vcpu->arch.pio_data = page_address(page);
+
 	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks) {
-		r = -ENOMEM;
-		goto fail_free_lapic;
-	}
+	if (!vcpu->arch.mce_banks)
+		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
-				GFP_KERNEL_ACCOUNT)) {
-		r = -ENOMEM;
+				GFP_KERNEL_ACCOUNT))
 		goto fail_free_mce_banks;
-	}
 
 	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.user_fpu) {
 		pr_err("kvm: failed to allocate userspace's fpu\n");
-		r = -ENOMEM;
 		goto free_wbinvd_dirty_mask;
 	}
 
@@ -9385,7 +9380,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 						 GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.guest_fpu) {
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
-		r = -ENOMEM;
 		goto free_user_fpu;
 	}
 	fx_init(vcpu);
@@ -9412,13 +9406,12 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
 	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
-fail_free_pio_data:
-	free_page((unsigned long)vcpu->arch.pio_data);
-fail:
 	return r;
 }
 
-- 
2.22.0

