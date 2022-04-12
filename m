Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA1A4FEB12
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiDLX2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiDLX2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:28:24 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB29F3AC
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m12-20020a170902d18c00b001589ea4e0d6so144058plb.12
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hwYcoU2T52uPK6PEcvCjB7tPUpGYUUsphqOnSNnFBOk=;
        b=hQKKaDJ249DwpCsGnOKdb/qVVi8ccQX6CE6lZliP3zW8HPu6vbXDF818xLj2Ii4kyi
         C+kUYB6QHppFAw7d1zHPfTyiwG4mOXknQQhYbyn/q95Rhm8F+OB3kfe5wsVvaQzATY3o
         9YAWlNR8DtT6GCDNZS2RBQZg6VUfZiB/q1eiOfrwn1fK3OlJ1UeN6icauCyFo9VQvo2Z
         ifoW5fZPFdMkrvOxXl0lYVRVmODy6aVUZMFqGmUOwHr50p+2XM/GynzLu/CVHs+fCNkI
         Nu4210Gd41OEJd8TGnKzQHIBm2GanSbJw1LRhn/0ud7YUtL06XSS1vdez5tCbO+Jn5Qk
         YAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hwYcoU2T52uPK6PEcvCjB7tPUpGYUUsphqOnSNnFBOk=;
        b=ODc6Byyt0ikpKSEm3wZEzIO/vM3mIhHgcf2UK1EBz2MfxSMtCVdHDF4Al/Sk5+uq9s
         l3g+nNjkptAxZKNlX6tDNIQ0LtPHh515XBbzC5wxNlodiIQE2pwDyEw/l0DiVzhP6rZU
         KJQu60LK+OWtBuOFi97bP4p2Kl7o2FontTvXuODhNeeNS31n9OQVBSH6W5U3M72vXXWt
         dLT6gHxExbuqQzlaeclNvVgdIKtmlntcnihguColyVK8hiT2e6U23Z8blDsljMHKaFtF
         Ps5MUv3nxvg/Ur1wsn3tqW9OjOb/5QLkHFlTd2oXeE2jM6F+KIuu0nUv08GWwoN3XnRQ
         kpjg==
X-Gm-Message-State: AOAM533cSv/Adx3TC0ntg64y8l0UJWSwBtFtBbx/4BgtWTnbnhSsL/7S
        22y4yQPvF5yz0FbRAyfLzcylQJlA
X-Google-Smtp-Source: ABdhPJzTxm07Z5BGWAbOZH2a0+yDjjcP8iDMpGoM5xkTO22QRunkAMmHhTt6nDjzkpIuI+ajwmxZRT72
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:6315:7654:72ee:17c3])
 (user=juew job=sendgmr) by 2002:a05:6a00:2347:b0:505:b8ba:d89e with SMTP id
 j7-20020a056a00234700b00505b8bad89emr6750074pfj.5.1649802715065; Tue, 12 Apr
 2022 15:31:55 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:31:32 -0700
In-Reply-To: <20220412223134.1736547-1-juew@google.com>
Message-Id: <20220412223134.1736547-3-juew@google.com>
Mime-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v2 2/4] KVM: x86: Add LVTCMCI support.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jue Wang <juew@google.com>
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

This feature is only enabled when the vCPU has opted in to enable
MCG_CMCI_P.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 33 ++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h |  7 ++++++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2c770e4c0e6c..0b370ccd11a1 100644
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
@@ -364,9 +365,14 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
 }
 
+static inline bool kvm_is_cmci_supported(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mcg_cap & MCG_CMCI_P;
+}
+
 static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
 {
-	return KVM_APIC_MAX_NR_LVT_ENTRIES;
+	return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(vcpu);
 }
 
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
@@ -396,7 +402,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
 	[LVT_LINT0] = LINT_MASK,
 	[LVT_LINT1] = LINT_MASK,
-	[LVT_ERROR] = LVT_MASK
+	[LVT_ERROR] = LVT_MASK,
+	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
 static int find_highest_vector(void *bitmap)
@@ -1411,6 +1418,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
+	if (kvm_is_cmci_supported(apic->vcpu))
+		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+
 	/* ARBPRI is not valid on x2APIC */
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
@@ -2043,12 +2053,10 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		apic_set_spiv(apic, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
-			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
-				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+			for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic->vcpu); i++) {
 				kvm_lapic_set_reg(apic, APIC_LVTx(i),
-					     lvt_val | APIC_LVT_MASKED);
+					kvm_lapic_get_reg(apic, APIC_LVTx(i)) | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
 			atomic_set(&apic->lapic_timer.pending, 0);
@@ -2098,6 +2106,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
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
@@ -2346,7 +2365,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
+	for (i = 0; i < kvm_apic_get_nr_lvt_entries(vcpu); i++)
 		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 5666441d5d1b..9f9f74b17918 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -35,6 +35,7 @@ enum lapic_lvt_entry {
 	LVT_LINT0,
 	LVT_LINT1,
 	LVT_ERROR,
+	LVT_CMCI,
 
 	KVM_APIC_MAX_NR_LVT_ENTRIES,
 };
@@ -42,7 +43,11 @@ enum lapic_lvt_entry {
 
 #define APIC_LVTx(x)                                                    \
 ({                                                                      \
-	int __apic_reg = APIC_LVTT + 0x10 * (x);                        \
+	int __apic_reg;                                                 \
+	if ((x) == LVT_CMCI)                                            \
+		__apic_reg = APIC_LVTCMCI;				\
+	else								\
+		__apic_reg = APIC_LVTT + 0x10 * (x);                    \
 	__apic_reg;                                                     \
 })
 
-- 
2.35.1.1178.g4f1659d476-goog

