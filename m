Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4531EDFAC7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387885AbfJVCBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:01:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:61609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387624AbfJVB76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293894"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:57 -0700
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
Subject: [PATCH 36/45] KVM: PPC: BookE: Setup vcpu during kvmppc_core_vcpu_create()
Date:   Mon, 21 Oct 2019 18:59:16 -0700
Message-Id: <20191022015925.31916-37-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold setup() into create() now that the two are called back-to-back by
common KVM code.  This paves the way for removing kvm_arch_vcpu_setup().
Note, BookE directly implements kvm_arch_vcpu_setup() and PPC's common
kvm_arch_vcpu_create() is responsible for its own cleanup, thus the only
cleanup required when directly invoking kvmppc_core_vcpu_setup() is to
call .vcpu_free(), which is the BookE specific portion of PPC's
kvm_arch_vcpu_destroy() by way of kvmppc_core_vcpu_free().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/booke.c | 60 ++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index dd7440e50c7a..b1b5073a22b1 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1377,34 +1377,9 @@ static void kvmppc_set_tsr(struct kvm_vcpu *vcpu, u32 new_tsr)
 	update_timer_ints(vcpu);
 }
 
-/* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	int i;
-	int r;
-
-	vcpu->arch.regs.nip = 0;
-	vcpu->arch.shared->pir = vcpu->vcpu_id;
-	kvmppc_set_gpr(vcpu, 1, (16<<20) - 8); /* -8 for the callee-save LR slot */
-	kvmppc_set_msr(vcpu, 0);
-
-#ifndef CONFIG_KVM_BOOKE_HV
-	vcpu->arch.shadow_msr = MSR_USER | MSR_IS | MSR_DS;
-	vcpu->arch.shadow_pid = 1;
-	vcpu->arch.shared->msr = 0;
-#endif
-
-	/* Eye-catching numbers so we know if the guest takes an interrupt
-	 * before it's programmed its own IVPR/IVORs. */
-	vcpu->arch.ivpr = 0x55550000;
-	for (i = 0; i < BOOKE_IRQPRIO_MAX; i++)
-		vcpu->arch.ivor[i] = 0x7700 | i * 4;
-
-	kvmppc_init_timing_stats(vcpu);
-
-	r = kvmppc_core_vcpu_setup(vcpu);
-	kvmppc_sanity_check(vcpu);
-	return r;
+	return 0;
 }
 
 int kvmppc_subarch_vcpu_init(struct kvm_vcpu *vcpu)
@@ -2116,7 +2091,38 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 
 int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.kvm_ops->vcpu_create(vcpu);
+	int i;
+	int r;
+
+	r = kvm->arch.kvm_ops->vcpu_create(vcpu);
+	if (r)
+		return r;
+
+	/* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
+	vcpu->arch.regs.nip = 0;
+	vcpu->arch.shared->pir = vcpu->vcpu_id;
+	kvmppc_set_gpr(vcpu, 1, (16<<20) - 8); /* -8 for the callee-save LR slot */
+	kvmppc_set_msr(vcpu, 0);
+
+#ifndef CONFIG_KVM_BOOKE_HV
+	vcpu->arch.shadow_msr = MSR_USER | MSR_IS | MSR_DS;
+	vcpu->arch.shadow_pid = 1;
+	vcpu->arch.shared->msr = 0;
+#endif
+
+	/* Eye-catching numbers so we know if the guest takes an interrupt
+	 * before it's programmed its own IVPR/IVORs. */
+	vcpu->arch.ivpr = 0x55550000;
+	for (i = 0; i < BOOKE_IRQPRIO_MAX; i++)
+		vcpu->arch.ivor[i] = 0x7700 | i * 4;
+
+	kvmppc_init_timing_stats(vcpu);
+
+	r = kvmppc_core_vcpu_setup(vcpu);
+	if (r)
+		vcpu->kvm->arch.kvm_ops->vcpu_free(vcpu);
+	kvmppc_sanity_check(vcpu);
+	return r;
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
-- 
2.22.0

