Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084BA125531
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLRVzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:55:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:54840 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbfLRVzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108072"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:39 -0800
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
Subject: [PATCH v2 16/45] KVM: MIPS: Use kvm_vcpu_cache to allocate vCPUs
Date:   Wed, 18 Dec 2019 13:55:01 -0800
Message-Id: <20191218215530.2280-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For reasons unknown, MIPS configures the vCPU allocation cache but
allocates vCPUs via kzalloc().  Allocate from the vCPU cache in
preparation for moving vCPU allocation to common KVM code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 1109924560d8..5f985773417c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -286,7 +286,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	void *gebase, *p, *handler, *refill_start, *refill_end;
 	int i;
 
-	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
+	struct kvm_vcpu *vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 
 	if (!vcpu) {
 		err = -ENOMEM;
@@ -401,7 +401,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	kvm_vcpu_uninit(vcpu);
 
 out_free_cpu:
-	kfree(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 
 out:
 	return ERR_PTR(err);
@@ -418,7 +418,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
-	kfree(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.24.1

