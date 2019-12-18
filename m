Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004D41255C8
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLRV6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:58:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:54840 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfLRVzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108102"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:42 -0800
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
Subject: [PATCH v2 22/45] KVM: x86: Drop kvm_arch_vcpu_free()
Date:   Wed, 18 Dec 2019 13:55:07 -0800
Message-Id: <20191218215530.2280-23-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the superfluous kvm_arch_vcpu_free() as it is no longer called
from commmon KVM code.  Note, kvm_arch_vcpu_destroy() *is* called from
common code, i.e. choosing which function to whack is not completely
arbitrary.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46626b52a4da..cf35169733cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9089,20 +9089,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
-void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
-{
-	kvmclock_reset(vcpu);
-
-	kvm_x86_ops->vcpu_free(vcpu);
-
-	kvm_vcpu_uninit(vcpu);
-
-	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-}
-
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
@@ -9176,7 +9162,16 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_vcpu_free(vcpu);
+	kvmclock_reset(vcpu);
+
+	kvm_x86_ops->vcpu_free(vcpu);
+
+	kvm_vcpu_uninit(vcpu);
+
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -9591,7 +9586,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 		kvm_unload_vcpu_mmu(vcpu);
 	}
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_free(vcpu);
+		kvm_arch_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->lock);
 	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-- 
2.24.1

