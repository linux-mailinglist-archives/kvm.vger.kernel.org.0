Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A067F52EEE7
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350708AbiETPTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350719AbiETPTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:19:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A220D17854B;
        Fri, 20 May 2022 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653059952; x=1684595952;
  h=from:to:cc:subject:date:message-id;
  bh=ggI0zjJAeQsvLKu8qoqdZgXQDCVdtGRNti5Pwgtk2Pg=;
  b=QD85PLqT+Eom2lSVukcu6KKA7BCnbo69lgEp5hDboUYHiqAg8tFWpVn9
   5Ry3hGoFF4ZtIiYj2R1hn4J1mcWmh2uumNsClor9wXlsoXd5rP1SXuMx1
   aA/EjqSoindClxTZQcJ5FHzveh6XwhQNQTqtllW+xoqPdUHcVChAWxgs3
   RpvE0pWSmCbYOTmke8OH/HjjTj9wg3UCXYNFcq/6Wc648uyC+5j/LOWnQ
   h+ayR/92El+wFbb658WCsr5CBt8n/km39GgB98OB9kuYGHv//rqkPzqzG
   iQ4zQDgOalLy/dG0mIdCxW06FyL4aJ4hyGUeArsBuDiPvx25H8HYFsqJ3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272339367"
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="272339367"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 08:19:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="599266525"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 08:19:07 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH] KVM: x86: Inhibit APICv/AVIC when changing apic id/base from the defaults
Date:   Fri, 20 May 2022 22:46:56 +0800
Message-Id: <20220520144656.25579-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

Neither of these settings should be changed by the guest and it is a burden
to support it in the acceleration code, so just inhibit APICv/AVIC in case
such rare cases happen.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 25 +++++++++++++++++++++----
 arch/x86/kvm/lapic.h            |  8 ++++++++
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ff36610af6a..408cf88351dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1051,6 +1051,7 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 	APICV_INHIBIT_REASON_ABSENT,
 	APICV_INHIBIT_REASON_SEV,
+	APICV_INHIBIT_REASON_RO_SETTINGS,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..f256fa974ea3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2038,6 +2038,17 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
+static void kvm_lapic_check_initial_apic_id(struct kvm_lapic *apic)
+{
+	if (kvm_apic_has_initial_apic_id(apic))
+		return;
+
+	pr_warn_once("APIC ID change is unexpected by KVM");
+
+	kvm_set_apicv_inhibit(apic->vcpu->kvm,
+			      APICV_INHIBIT_REASON_RO_SETTINGS);
+}
+
 static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2046,9 +2057,11 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(apic)) {
+
 			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+			kvm_lapic_check_initial_apic_id(apic);
+		} else
 			ret = 1;
 		break;
 
@@ -2335,8 +2348,11 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			     MSR_IA32_APICBASE_BASE;
 
 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
-	     apic->base_address != APIC_DEFAULT_PHYS_BASE)
-		pr_warn_once("APIC base relocation is unsupported by KVM");
+	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
+		kvm_set_apicv_inhibit(apic->vcpu->kvm,
+				      APICV_INHIBIT_REASON_RO_SETTINGS);
+		pr_warn_once("APIC base relocation is unexpected by KVM");
+	}
 }
 
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
@@ -2649,6 +2665,7 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	kvm_lapic_check_initial_apic_id(vcpu->arch.apic);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4e4f8a22754f..b9c406d38308 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -252,4 +252,12 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+static inline bool kvm_apic_has_initial_apic_id(struct kvm_lapic *apic)
+{
+	if (apic_x2apic_mode(apic))
+		return true;
+
+	return kvm_xapic_id(apic) == apic->vcpu->vcpu_id;
+}
+
 #endif
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 421619540ff9..04a07b82b1a4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -838,7 +838,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_SEV);
+			  BIT(APICV_INHIBIT_REASON_SEV) |
+			  BIT(APICV_INHIBIT_REASON_RO_SETTINGS);
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..b31f858cacf2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7710,7 +7710,8 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_RO_SETTINGS);
 
 	return supported & BIT(reason);
 }
-- 
2.27.0

