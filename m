Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A539D52F1BF
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352290AbiETRg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352292AbiETRgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:52 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5DB80221
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:50 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso4558280pjd.6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WfQVdpk3KC0ZrKW0uOOMpSnVFPF0oApLtFRNK/IW/54=;
        b=jl9x8sHu3l+6astnzShzJE5hVWme/+zuCxpnKR9kTiB7o9kJFwoNXZ1TDDXSAs1eik
         dURXZJfLXxPKswZXNFfJDFwqnSXl4bMhJvSd2cHNS/1hbW1LRJFI0US0VMqMvvXr6Ly0
         lr34Ri7NZZMq9l9woAgG+Z5d928QUps/f1HOrcVy6GeQ6wfLTI3bYeJMQHMJj9tNOqvh
         rb4WBIKXSh2uQt7nsxsgQJPGYxs79JfSXgtr+uVLE6yfLmTZ4d+dB1kRTBw4/pUPRkPC
         eHhUjL800IxsPTs4GauYByCovtT/ZG0vYYs+p+b1VJ+KpBsGiZ5z7IafYRL7yfg8OP37
         YuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WfQVdpk3KC0ZrKW0uOOMpSnVFPF0oApLtFRNK/IW/54=;
        b=PL5QCy7c6Q8q0a+rNLilVMTZ4iwPgmYYepoc3Cey8uqrBq8xvoPJnxx9Sbrch8/CyS
         /mQ6A9N1uYM+ljS10guffs69o+lx2+hyRlZnixVPbaIotvyPvPRctUooiAghp/7+NMGB
         enlU1X5nCdrQY2Z/eAt7I8sim3/rgINHEy5wIjjGMOy81oLQRPY7ofAGYODxvyhkEsCx
         YKzOGBL1hQArzEzRMMh6RyGLsPC2YpApgI39YZENoC5OopgH3JNf6MwHmTQcA7ECnW8+
         wYqCUuW+xIC3FAAZ6bie65LbM/0q/m52tQetuIHovwSaR1U2CkIn/i3Ajmku5gw4ki6T
         z5Ug==
X-Gm-Message-State: AOAM530TKbrLJMp69kNB5QN2X9FOwip7gOIHrpCq0m/RUsozFItvcdee
        /uGMiyYtvEeLYicyQIeVPj4hBBBN
X-Google-Smtp-Source: ABdhPJxbzbYd1i+dndeXTNOGvIP/tAZfeW4D00c79VNIkJGIY0714UqdPXvzZvpzjYurgczyn+o6ecoC
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a62:cd0b:0:b0:518:11b3:c9f with SMTP id
 o11-20020a62cd0b000000b0051811b30c9fmr11238387pfg.46.1653068210183; Fri, 20
 May 2022 10:36:50 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:34 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-5-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 4/8] KVM: x86: Add Corrected Machine Check Interrupt (CMCI)
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

This patch adds the handling of APIC_LVTCMCI, conditioned on whether the
vCPU has set MCG_CMCI_P in MCG_CAP register.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 40 +++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h |  3 ++-
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index db12d2ef1aef..e2186a7c0eed 100644
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
@@ -398,14 +399,26 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
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
@@ -425,7 +438,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
 	[LVT_LINT0] = LINT_MASK,
 	[LVT_LINT1] = LINT_MASK,
-	[LVT_ERROR] = LVT_MASK
+	[LVT_ERROR] = LVT_MASK,
+	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
 static int find_highest_vector(void *bitmap)
@@ -1445,6 +1459,9 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
+	if (kvm_is_cmci_supported(apic->vcpu))
+		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+
 	/*
 	 * ARBPRI and ICR2 are not valid in x2APIC mode.  WARN if KVM reads ICR
 	 * in x2APIC mode as it's an 8-byte register in x2APIC and needs to be
@@ -2083,12 +2100,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
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
@@ -2140,6 +2155,17 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
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
@@ -2383,7 +2409,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
+	for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic); i++)
 		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2d197ed0b8ce..16298bcb2abf 100644
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
2.36.1.124.g0e6072fb45-goog

