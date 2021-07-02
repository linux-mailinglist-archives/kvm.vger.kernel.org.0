Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B23BA5AA
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhGBWJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:50200 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhGBWH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472737"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472737"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814773"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v2 31/69] KVM: x86: add per-VM flags to disable SMI/INIT/SIPI
Date:   Fri,  2 Jul 2021 15:04:37 -0700
Message-Id: <f0d016794615a513e242bb059494623eb55606eb.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index f373d672b4ac..00333af724d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1055,6 +1055,8 @@ struct kvm_arch {
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
index 92204bbc7ea5..3407870b6f44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4311,8 +4311,7 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
-	/* TODO: use more precise flag */
-	if (vcpu->arch.guest_state_protected)
+	if (vcpu->kvm->arch.smm_unsupported)
 		return -EINVAL;
 
 	kvm_make_request(KVM_REQ_SMI, vcpu);
-- 
2.25.1

