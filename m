Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC50D53ED94
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiFFSJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiFFSIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:08:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B80922FE64
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9umq7ZLyfA//0JRA0NlxNtC/RFJORU4rQhFUvO9ESZk=;
        b=DLWswQO93wihlixafCX+Cvzfv5XQE/wJN9GW9ePDB52if3VOF8iDPm+HEcNjlLajXtgSzz
        mt9I7MbVfnTSengZvhyU97ugZMRuNBn9lqF2dIfp7ZT0/RKJ+vUkZooxkBHdi4In3c/a+v
        cf229Jfw6s4uNxPRCg0a/ACSFISbxMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-6bOGLsxEOoC4IVTutCC1Xw-1; Mon, 06 Jun 2022 14:08:42 -0400
X-MC-Unique: 6bOGLsxEOoC4IVTutCC1Xw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23114858EED;
        Mon,  6 Jun 2022 18:08:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B07C81121314;
        Mon,  6 Jun 2022 18:08:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/7] KVM: x86: inhibit APICv/AVIC when the guest and/or host changes either apic id or the apic base from their default values.
Date:   Mon,  6 Jun 2022 21:08:24 +0300
Message-Id: <20220606180829.102503-3-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Neither of these settings should be changed by the guest and it is
a burden to support it in the acceleration code, so just inhibit
this code instead.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/lapic.c            | 27 +++++++++++++++++++++++----
 arch/x86/kvm/svm/avic.c         |  4 +++-
 arch/x86/kvm/vmx/vmx.c          |  4 +++-
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7fb3ade44501..971db02e8ed86 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1094,6 +1094,15 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 
+	/*
+	 * For simplicity, the APIC acceleration is inhibited
+	 * first time either APIC ID or APIC base are changed by the guest
+	 * from their reset values.
+	 */
+	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
+	APICV_INHIBIT_REASON_APIC_BASE_MODIFIED,
+
+
 	/******************************************************/
 	/* INHIBITs that are relevant only to the AMD's AVIC. */
 	/******************************************************/
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e69b83708f050..a413a1d8df4c1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2040,6 +2040,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
+static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
+{
+	struct kvm *kvm = apic->vcpu->kvm;
+
+	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
+		return;
+
+	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+		return;
+
+	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+}
+
 static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2048,10 +2061,12 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+			kvm_lapic_xapic_id_updated(apic);
+		} else {
 			ret = 1;
+		}
 		break;
 
 	case APIC_TASKPRI:
@@ -2354,8 +2369,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			     MSR_IA32_APICBASE_BASE;
 
 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
-	     apic->base_address != APIC_DEFAULT_PHYS_BASE)
-		pr_warn_once("APIC base relocation is unsupported by KVM");
+	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
+		kvm_set_apicv_inhibit(apic->vcpu->kvm,
+				      APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
+	}
 }
 
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
@@ -2666,6 +2683,8 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
+	} else {
+		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 54fe03714f8a6..8dffd67f60862 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -910,7 +910,9 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_SEV);
+			  BIT(APICV_INHIBIT_REASON_SEV      |
+			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd2e707faf2bf..48440f73c3352 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7860,7 +7860,9 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 
 	return supported & BIT(reason);
 }
-- 
2.26.3

