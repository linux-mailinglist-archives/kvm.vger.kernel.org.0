Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F720546B8A
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350165AbiFJRLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiFJRLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:53 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C640C1F7D91
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b0016363cdfe84so14748163plq.10
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZVN9xmXJu3lPlYehufq1nXOmIxI9I7rYgQopG60D5Wo=;
        b=QPvwvqlP8vOMXjPWoCrGMZiG7tNIMNlskRQCmef3L9aNsV1MBRF80MeIqTGQfrP02y
         UTYrTiU8I2wZi8u8h4Rt+gz5tq79tGedANn1sqbi2U0LwTU2tx0kSsf+Fh8gkJ2czzmU
         LTvNjCkW1Pe5i/spabPrgSZHTkEGNT4wpjXK/HkhemBGz28Vgo6pc9eDd0DgJc5holEw
         Hvis+moqYrBOn3H63W/agZpa3WDpDSzkiJ3jB7UJ5+ej9ZxnB7UYJhTJLyg4QzHnw9mC
         3YT24L23kd02zxXovGblt9tcaDsg8CzRa3EobaFKraw5gKU4OkerF3NWJNndBYQwFL3G
         319g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZVN9xmXJu3lPlYehufq1nXOmIxI9I7rYgQopG60D5Wo=;
        b=xx0Y9EO8SpdzxViYr022M4m38SASFOql0ydx8YYn8k5+o6smteblw96hxSyuYqCrqJ
         vS+f1XnCZ2vvjL0KPftyV6LBEyBQD1fFVHiuY6QBVkMh2NXhmto1NSCsaEYHrEX3cmuA
         DB5Uu4z08gFeTQowkorlq6bxyeD739+ruWbxDf99d6W1TXEHzQx0TFlLAeXDYY9NIW8n
         WNBPByJQrfKELB53j6gPSq8QW+/RtxyqskFOJXbPBWLn4TpEaBAiwTfDLlgSKgLKSdgS
         5+OLOYiKiwLhn7ti6KEIoddDf+86MF8HRqi+tW7jVMh8q6OAW0yq2H1z7dVL168djejY
         vHvA==
X-Gm-Message-State: AOAM530LKCV42cQ/CLgFyab0zS4eSnCWj+EhaDeI0o395XrdivSZZmMJ
        YjAnEtr+Zex9CWkRREdVFkh6wfNe
X-Google-Smtp-Source: ABdhPJybytF24sDKyBdyxKECSl+30P3q/4hTWpUC+HAcWcvZtdMkW9q4Zq+H/72WabA8CiOeB4xyOPGk
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a17:90a:854b:b0:1ea:7bbb:e0b6 with SMTP id
 a11-20020a17090a854b00b001ea7bbbe0b6mr732111pjw.184.1654881110235; Fri, 10
 Jun 2022 10:11:50 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:30 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-5-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 4/8] KVM: x86: Add Corrected Machine Check Interrupt (CMCI)
 emulation to lapic.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
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

This patch calculates the number of lvt entries as part of
KVM_X86_MCE_SETUP conditioned on the presence of MCG_CMCI_P bit in
MCG_CAP and stores result in kvm_lapic. It translats from APIC_LVTx
register to index in lapic_lvt_entry enum. It extends the APIC_LVTx
macro as well as other lapic write/reset handling etc to support
Corrected Machine Check Interrupt.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 48 ++++++++++++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h |  4 +++-
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index db12d2ef1aef..8537b66cc646 100644
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
@@ -398,14 +399,21 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
 }
 
+static inline bool kvm_lapic_lvt_supported(struct kvm_lapic *apic, int lvt_index)
+{
+	return apic->nr_lvt_entries > lvt_index;
+}
+
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION | ((KVM_APIC_MAX_NR_LVT_ENTRIES - 1) << 16);
+	u32 v = 0;
 
 	if (!lapic_in_kernel(vcpu))
 		return;
 
+	v = APIC_VERSION | ((apic->nr_lvt_entries - 1) << 16);
+
 	/*
 	 * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
 	 * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
@@ -425,7 +433,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
 	[LVT_LINT0] = LINT_MASK,
 	[LVT_LINT1] = LINT_MASK,
-	[LVT_ERROR] = LVT_MASK
+	[LVT_ERROR] = LVT_MASK,
+	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
 static int find_highest_vector(void *bitmap)
@@ -1445,6 +1454,9 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
+	if (kvm_lapic_lvt_supported(apic, LVT_CMCI))
+		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+
 	/*
 	 * ARBPRI and ICR2 are not valid in x2APIC mode.  WARN if KVM reads ICR
 	 * in x2APIC mode as it's an 8-byte register in x2APIC and needs to be
@@ -2039,6 +2051,15 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
+static int get_lvt_index(u32 reg) {
+	if (reg == APIC_LVTCMCI)
+		return LVT_CMCI;
+	if (reg < APIC_LVTT || reg > APIC_LVTERR)
+		return -1;
+	return array_index_nospec(
+			(reg - APIC_LVTT) >> 4, KVM_APIC_MAX_NR_LVT_ENTRIES);
+}
+
 static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2083,12 +2104,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		apic_set_spiv(apic, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
-			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
-				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+			for (i = 0; i < apic->nr_lvt_entries; i++) {
 				kvm_lapic_set_reg(apic, APIC_LVTx(i),
-					     lvt_val | APIC_LVT_MASKED);
+					kvm_lapic_get_reg(apic, APIC_LVTx(i)) | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
 			atomic_set(&apic->lapic_timer.pending, 0);
@@ -2117,16 +2136,15 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR: {
-		/* TODO: Check vector */
-		size_t size;
-		u32 index;
-
+	case APIC_LVTERR:
+	case APIC_LVTCMCI: {
+		u32 index = get_lvt_index(reg);
+		if (!kvm_lapic_lvt_supported(apic, index)) {
+			ret = 1;
+			break;
+		}
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
-		size = ARRAY_SIZE(apic_lvt_mask);
-		index = array_index_nospec(
-				(reg - APIC_LVTT) >> 4, size);
 		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
 		break;
@@ -2383,7 +2401,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
+	for (i = 0; i < apic->nr_lvt_entries; i++)
 		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2d197ed0b8ce..0fcafc76a3ce 100644
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
@@ -78,6 +79,7 @@ struct kvm_lapic {
 	struct gfn_to_hva_cache vapic_cache;
 	unsigned long pending_events;
 	unsigned int sipi_vector;
+	int nr_lvt_entries;
 };
 
 struct dest_map;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..a08693808729 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4772,6 +4772,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	/* Init IA32_MCi_CTL to all 1s */
 	for (bank = 0; bank < bank_num; bank++)
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
+	vcpu->arch.apic->nr_lvt_entries =
+		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
-- 
2.36.1.255.ge46751e96f-goog

