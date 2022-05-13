Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49E526925
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383286AbiEMSVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383292AbiEMSVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:08 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC323BB7D
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso4390604pfo.9
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xApqz8Ypu31pnHHgYJaxSOu2A3YrJ3i6dxVYf2MjjuQ=;
        b=Ufg7I+imo33HnbzHCZAgqF93+s37/0h7gQ8mU7PU64gwHiSXbWLGsFcfbWxMM2ITT9
         mdfGqOaLKvXmjs7DyewanLvRmXSH2vQv43jkvbUADiKxWW0Kl+OJvP300RqdV4WwlRRp
         QPSvcPXK6FpM8MrfVzYHkng51NquXKi5azq0d8QX2oaQzkvLa6XbsrgX1SyRMyDGsMh7
         HR2EDq8R3gEhd10O2ZXl3nQUsJDj8goSkfsHeeCvrUKRKGK406em+DBlTzMarUvlMQdG
         lPEqh2Nu3s4uzNWWc1hEqsHtLkDGgVU9sKYte3+OhK//hKK9Zrp45Q9cPj5UHRLs62ri
         SN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xApqz8Ypu31pnHHgYJaxSOu2A3YrJ3i6dxVYf2MjjuQ=;
        b=nmPnPzr9OR4A/wNeSpEeKyX5DRikiIgM2RXJ6IBrH3DpMqABflU5FYqnj4/TMi8YYZ
         KPobVCCH+IwQSrnaR7rInRa0WcOWWpuErMfzLaivPjuURsQ07YKMtWxtPoRLpT5Izxov
         Cyung1Fq1mCjLEmpUE7jrfNB3rT52dKIiV19G1VzQCDto9oJdx785vNG6r1pVxDYTtuk
         +pMvJ6HBZ/lXpvqlKbDFdQyAstJvM5rXSU9FDp8fjpRzkBx88IVoLto6GmwfQ45s85qx
         iCVm2tVMLNhOO7ZYgjbw8x3aBf0adt/F90Golp0yJUjl5Cn3oB1UONAtR7fwD7d88qRa
         e6qg==
X-Gm-Message-State: AOAM533j49v3EJePaK/uYA2Ok8+2S7C8dgzfHzoqzc0d3LB6zU4gJoSG
        j/SCSMnL1RPpmj8CdldJ6nak85ei
X-Google-Smtp-Source: ABdhPJyW5BQVCwL+rt7iilS8tf++f7clgIS9NkK2RsGS7M2ekf/CqRWfZ8Xa3k1S1qu9apujuljHz5U3
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:902:d4ce:b0:15e:90f8:216c with SMTP id
 o14-20020a170902d4ce00b0015e90f8216cmr6126875plg.65.1652466063483; Fri, 13
 May 2022 11:21:03 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:35 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-5-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 4/7] KVM: x86: Add Corrected Machine Check Interrupt (CMCI)
 emulation to lapic.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds the Corrected Machine Check Interrupt (CMCI) and
Uncorrectable Error No Action required (UCNA) emulation to KVM. The
former is implemented as a LVT CMCI vector. The emulation of UCNA share
the MCE emulation infrastructure.

CMCI emulation is only enabled when user space has opted in to enable
MCG_CMCI_P bit in MCG_CAP via KVM_X86_SETUP_MCE.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 40 +++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h |  3 ++-
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c01f6ecb3d12..b451fbe8b394 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include <asm/processor.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/current.h>
@@ -364,14 +365,26 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
 }
 
+static inline bool kvm_is_cmci_supported(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mcg_cap & MCG_CMCI_P;
+}
+
+static inline int kvm_apic_get_nr_lvt_entries(struct kvm_lapic *apic)
+{
+	return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(apic->vcpu);
+}
+
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION | ((KVM_APIC_MAX_NR_LVT_ENTRIES - 1) << 16);
+	u32 v = 0;
 
 	if (!lapic_in_kernel(vcpu))
 		return;
 
+	v = APIC_VERSION | ((kvm_apic_get_nr_lvt_entries(apic) - 1) << 16);
+
 	/*
 	 * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
 	 * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
@@ -391,7 +404,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
 	[LVT_LINT0] = LINT_MASK,
 	[LVT_LINT1] = LINT_MASK,
-	[LVT_ERROR] = LVT_MASK
+	[LVT_ERROR] = LVT_MASK,
+	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
 static int find_highest_vector(void *bitmap)
@@ -1406,6 +1420,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
+	if (kvm_is_cmci_supported(apic->vcpu))
+		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+
 	/* ARBPRI is not valid on x2APIC */
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
@@ -2038,12 +2055,10 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		apic_set_spiv(apic, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
-			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
-				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+			for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic); i++) {
 				kvm_lapic_set_reg(apic, APIC_LVTx(i),
-					     lvt_val | APIC_LVT_MASKED);
+					kvm_lapic_get_reg(apic, APIC_LVTx(i)) | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
 			atomic_set(&apic->lapic_timer.pending, 0);
@@ -2093,6 +2108,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		apic_update_lvtt(apic);
 		break;
 
+	case APIC_LVTCMCI:
+		if (!kvm_is_cmci_supported(apic->vcpu)) {
+			ret = 1;
+			break;
+		}
+		if (!kvm_apic_sw_enabled(apic))
+			val |= APIC_LVT_MASKED;
+		val &= apic_lvt_mask[LVT_CMCI];
+		kvm_lapic_set_reg(apic, APIC_LVTCMCI, val);
+		break;
+
 	case APIC_TMICT:
 		if (apic_lvtt_tscdeadline(apic))
 			break;
@@ -2341,7 +2367,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
+	for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic); i++)
 		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ba4c548853e..64ed18fe0fb4 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -35,11 +35,12 @@ enum lapic_lvt_entry {
 	LVT_LINT0,
 	LVT_LINT1,
 	LVT_ERROR,
+	LVT_CMCI,
 
 	KVM_APIC_MAX_NR_LVT_ENTRIES,
 };
 
-#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
+#define APIC_LVTx(x) ((x) == LVT_CMCI ? APIC_LVTCMCI : APIC_LVTT + 0x10 * (x))
 
 struct kvm_timer {
 	struct hrtimer timer;
-- 
2.36.0.550.gb090851708-goog

