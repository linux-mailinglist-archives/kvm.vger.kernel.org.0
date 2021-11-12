Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AB44EA89
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhKLPlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:41:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:34523 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235294AbhKLPlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:41:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093200"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093200"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182134"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:38:01 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 07/11] KVM: x86: Disable SMM for TDX
Date:   Fri, 12 Nov 2021 23:37:29 +0800
Message-Id: <20211112153733.2767561-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SMM is not supported for TDX VM, nor can KVM emulate it for TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/irq_comm.c | 2 ++
 arch/x86/kvm/x86.c      | 6 ++++++
 arch/x86/kvm/x86.h      | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index f9f643e31893..705fc0dc0272 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -128,6 +128,8 @@ static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 			       .data = e->msi.data };
 	return  (kvm_eoi_intercept_disallowed(kvm) &&
 		 msg.arch_data.is_level) ||
+		(kvm_smm_unsupported(kvm) &&
+		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_SMI) ||
 		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 113ed9aa5c82..1f3cc2a2d844 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4132,6 +4132,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 		break;
 	case KVM_CAP_X86_SMM:
+		if (kvm && kvm_smm_unsupported(kvm))
+			break;
+
 		/* SMBASE is usually relocated above 1M on modern chipsets,
 		 * and SMM handlers might indeed rely on 4G segment limits,
 		 * so do not report SMM to be available if real mode is
@@ -4500,6 +4503,9 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
+	if (kvm_smm_unsupported(vcpu->kvm))
+		return -EINVAL;
+
 	kvm_make_request(KVM_REQ_SMI, vcpu);
 
 	return 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 65c8c77e507b..ab7c91ca2478 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -456,6 +456,11 @@ static __always_inline bool kvm_eoi_intercept_disallowed(struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
+static __always_inline bool kvm_smm_unsupported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

