Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1145D1E2
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245421AbhKYA0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352832AbhKYAYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649689"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649689"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:10 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042179"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:10 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v3 22/59] KVM: x86: add per-VM flags to disable SMI/INIT/SIPI
Date:   Wed, 24 Nov 2021 16:20:05 -0800
Message-Id: <5567bad1a9c3dcc91d66d2552cb872dd68cd5bc4.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a flag to let TDX disallow to inject interrupt with delivery
mode of SMI/INIT/SIPI. add a check to reject SMI/INIT interrupt
delivery mode.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/irq_comm.c         | 4 ++++
 arch/x86/kvm/x86.c              | 3 +--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 545b556e420c..5ed07f31459e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1133,6 +1133,8 @@ struct kvm_arch {
 	enum kvm_irqchip_mode irqchip_mode;
 	u8 nr_reserved_ioapic_pins;
 	bool eoi_intercept_unsupported;
+	bool smm_unsupported;
+	bool init_sipi_unsupported;
 
 	bool disabled_lapic_found;
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index bcfac99db579..396ccf086bdd 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -128,6 +128,10 @@ static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 			       .data = e->msi.data };
 	return  (kvm->arch.eoi_intercept_unsupported &&
 		 msg.arch_data.is_level) ||
+		(kvm->arch.smm_unsupported &&
+		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_SMI) ||
+		(kvm->arch.init_sipi_unsupported &&
+		 msg.arch_data.delivery_mode == APIC_DELIVERY_MODE_INIT) ||
 		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1573dddd1e43..f2b6a3f89e9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4553,8 +4553,7 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
-	/* TODO: use more precise flag */
-	if (vcpu->arch.guest_state_protected)
+	if (vcpu->kvm->arch.smm_unsupported)
 		return -EINVAL;
 
 	kvm_make_request(KVM_REQ_SMI, vcpu);
-- 
2.25.1

