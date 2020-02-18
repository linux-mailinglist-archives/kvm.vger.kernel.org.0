Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48B71637A4
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgBRXy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:54:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:40044 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbgBRXyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:54:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:54:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="224313174"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 15:54:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/9] KVM: x86: Drop __exit from kvm_x86_ops' hardware_unsetup()
Date:   Tue, 18 Feb 2020 15:54:35 -0800
Message-Id: <20200218235437.20533-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218235437.20533-1-sean.j.christopherson@intel.com>
References: <20200218235437.20533-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the __exit annotation from VMX/SVM's hardware_unsetup(), the hook
can be reached during kvm_init() by way of kvm_arch_hardware_unsetup()
if failure occurs at various points during initialization.

Note, there is no known functional issue with the __exit annotation, the
above is merely justification for its removal.  The real motivation is
to be able to annotate vmx_x86_ops and svm_x86_ops with __initdata,
which makes objtool complain because objtool doesn't understand that the
vendor specific __initdata is being copied by value to a non-__initdata
instance.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0c2431f8374..5f379a2d5e15 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1044,7 +1044,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
-	void (*hardware_unsetup)(void);            /* __exit */
+	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 83b12928d709..59af4f5386de 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1468,7 +1468,7 @@ static __init int svm_hardware_setup(void)
 	return r;
 }
 
-static __exit void svm_hardware_unsetup(void)
+static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c7dea508dcb..813dfbbfe98b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7548,7 +7548,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.vmxon;
 }
 
-static __exit void hardware_unsetup(void)
+static void hardware_unsetup(void)
 {
 	if (nested)
 		nested_vmx_hardware_unsetup();
-- 
2.24.1

