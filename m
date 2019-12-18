Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECE12556F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLRV4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:56:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:16969 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfLRV4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:56:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108175"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:50 -0800
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
Subject: [PATCH v2 40/45] KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()
Date:   Wed, 18 Dec 2019 13:55:25 -0800
Message-Id: <20191218215530.2280-41-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold init() into create() now that the two are called back-to-back by
common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
immediately thereafter).  This paves the way for removing
kvm_arch_vcpu_{un}init() entirely.

Note, there is no associated unwinding in kvm_arch_vcpu_uninit() that
needs to be relocated (to kvm_arch_vcpu_destroy()).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/arm/arm.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 35eab584fb57..1d87c194a6d3 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -292,6 +292,25 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	int err;
+
+	/* Force users to call KVM_ARM_VCPU_INIT */
+	vcpu->arch.target = -1;
+	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
+
+	/* Set up the timer */
+	kvm_timer_vcpu_init(vcpu);
+
+	kvm_pmu_vcpu_init(vcpu);
+
+	kvm_arm_reset_debug_ptr(vcpu);
+
+	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
+
+	err = kvm_vgic_vcpu_init(vcpu);
+	if (err)
+		return err;
+
 	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
@@ -341,20 +360,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	/* Force users to call KVM_ARM_VCPU_INIT */
-	vcpu->arch.target = -1;
-	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
-
-	/* Set up the timer */
-	kvm_timer_vcpu_init(vcpu);
-
-	kvm_pmu_vcpu_init(vcpu);
-
-	kvm_arm_reset_debug_ptr(vcpu);
-
-	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
-
-	return kvm_vgic_vcpu_init(vcpu);
+	return 0;
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.24.1

