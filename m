Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735F544EA90
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhKLPmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:42:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:34487 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235440AbhKLPmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:42:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093220"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093220"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182146"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:38:05 -0800
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
Subject: [PATCH 08/11] KVM: x86: Disable INIT/SIPI for TDX
Date:   Fri, 12 Nov 2021 23:37:30 +0800
Message-Id: <20211112153733.2767561-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INIT/SIPI is not supportd for TDX guest. Disallow injecting interrupt with
delivery mode of INIT/SIPI, and add a check to reject INIT/SIPI
interrupt delivery mode.

Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/irq_comm.c | 2 ++
 arch/x86/kvm/x86.h      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 705fc0dc0272..c51faa621aa4 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -130,6 +130,8 @@ static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		 msg.arch_data.is_level) ||
 		(kvm_smm_unsupported(kvm) &&
 		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_SMI) ||
+		(kvm_init_sipi_unsupported(kvm) &&
+		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_INIT) ||
 		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ab7c91ca2478..2203cc283e04 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -461,6 +461,11 @@ static __always_inline bool kvm_smm_unsupported(struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
+static __always_inline bool kvm_init_sipi_unsupported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

