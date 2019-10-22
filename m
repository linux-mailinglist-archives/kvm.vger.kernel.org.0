Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480D8DFB0F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbfJVB7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:61591 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbfJVB7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293825"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:45 -0700
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
Subject: [PATCH 19/45] KVM: arm: Drop kvm_arch_vcpu_free()
Date:   Mon, 21 Oct 2019 18:58:59 -0700
Message-Id: <20191022015925.31916-20-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
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
 virt/kvm/arm/arm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..266d78fbc86c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -170,7 +170,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_free(kvm->vcpus[i]);
+			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
 			kvm->vcpus[i] = NULL;
 		}
 	}
@@ -295,7 +295,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 }
 
-void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
@@ -307,11 +307,6 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
-void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-{
-	kvm_arch_vcpu_free(vcpu);
-}
-
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return kvm_timer_is_pending(vcpu);
-- 
2.22.0

