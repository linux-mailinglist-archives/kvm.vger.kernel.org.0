Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE58125536
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfLRVzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:55:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:54840 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfLRVzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108112"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:43 -0800
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
Subject: [PATCH v2 25/45] KVM: s390: Move guts of kvm_arch_vcpu_init() into kvm_arch_vcpu_create()
Date:   Wed, 18 Dec 2019 13:55:10 -0800
Message-Id: <20191218215530.2280-26-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move all of kvm_arch_vcpu_init(), which is invoked at the very end of
kvm_vcpu_init(), into kvm_arch_vcpu_create() in preparation of moving
the call to kvm_vcpu_init().  Moving kvm_vcpu_init() is itself a
preparatory step for moving allocation and initialization to common KVM
code.

No functional change inteded.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 62 ++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 57c6838dff37..0049b621e56a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2705,34 +2705,6 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
-	kvm_clear_async_pf_completion_queue(vcpu);
-	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
-				    KVM_SYNC_GPRS |
-				    KVM_SYNC_ACRS |
-				    KVM_SYNC_CRS |
-				    KVM_SYNC_ARCH0 |
-				    KVM_SYNC_PFAULT;
-	kvm_s390_set_prefix(vcpu, 0);
-	if (test_kvm_facility(vcpu->kvm, 64))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
-	if (test_kvm_facility(vcpu->kvm, 82))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_BPBC;
-	if (test_kvm_facility(vcpu->kvm, 133))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_GSCB;
-	if (test_kvm_facility(vcpu->kvm, 156))
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_ETOKEN;
-	/* fprs can be synchronized via vrs, even if the guest has no vx. With
-	 * MACHINE_HAS_VX, (load|store)_fpu_regs() will work with vrs format.
-	 */
-	if (MACHINE_HAS_VX)
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_VRS;
-	else
-		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
-
-	if (kvm_is_ucontrol(vcpu->kvm))
-		return __kvm_ucontrol_vcpu_init(vcpu);
-
 	return 0;
 }
 
@@ -3077,11 +3049,45 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
 		goto out_free_sie_block;
+
+	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
+	kvm_clear_async_pf_completion_queue(vcpu);
+	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
+				    KVM_SYNC_GPRS |
+				    KVM_SYNC_ACRS |
+				    KVM_SYNC_CRS |
+				    KVM_SYNC_ARCH0 |
+				    KVM_SYNC_PFAULT;
+	kvm_s390_set_prefix(vcpu, 0);
+	if (test_kvm_facility(vcpu->kvm, 64))
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
+	if (test_kvm_facility(vcpu->kvm, 82))
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_BPBC;
+	if (test_kvm_facility(vcpu->kvm, 133))
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_GSCB;
+	if (test_kvm_facility(vcpu->kvm, 156))
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_ETOKEN;
+	/* fprs can be synchronized via vrs, even if the guest has no vx. With
+	 * MACHINE_HAS_VX, (load|store)_fpu_regs() will work with vrs format.
+	 */
+	if (MACHINE_HAS_VX)
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_VRS;
+	else
+		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
+
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		rc = __kvm_ucontrol_vcpu_init(vcpu);
+		if (rc)
+			goto out_uninit_vcpu;
+	}
+
 	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
 		 vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
 	return vcpu;
+out_uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 out_free_cpu:
-- 
2.24.1

