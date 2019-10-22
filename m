Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB751DFA81
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387598AbfJVB7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:61596 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfJVB7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293851"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:49 -0700
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
Subject: [PATCH 25/45] KVM: s390: Move guts of kvm_arch_vcpu_init() into kvm_arch_vcpu_create()
Date:   Mon, 21 Oct 2019 18:59:05 -0700
Message-Id: <20191022015925.31916-26-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
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
index ddc90fa6abfd..43be136682bb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2708,34 +2708,6 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 
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
 
@@ -3080,11 +3052,45 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
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
2.22.0

