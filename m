Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33EA4FEAD8
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiDLX2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiDLX2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:28:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661317246E
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q10-20020a17090a2dca00b001cb87691fbaso44491pjm.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GDBlx35DXx2ecS+UsmF7cBG9iao+sQEew43vP5ZeYn0=;
        b=r/XBgooEEvQ9GmPFxNUjZO8wuXfTEKem27lhvRTVULlMnlMup31j9Y4MxGBFxLYBML
         6Bp5+FikgokJkSY8iQfjibhovllGAXBaInUVMxhU+MoIUZ6XjJpP8nrZi7moKDfiri7w
         Eg3x5AJles5lEpucfCKOBNyKmAAV0luksaDqdy/oUuGgL6Xxrtuf38ONvBC3cjAa+uIC
         8SxZ8JXXif3W3lbjI5d7KPT+cIO3ta4z3d4w5nYsD7V3bIWB+akbTi/PckagE07TlRwh
         uPJDJ9zvY9oEOTgI8kNWS9bsy2dnUynwWmjKogF9NMjlEe5EDXNGCtzr9aH7v3nVirt3
         Onlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GDBlx35DXx2ecS+UsmF7cBG9iao+sQEew43vP5ZeYn0=;
        b=T8YVZrmEE13H/zKts2XaHv640ERxF9QQedEjNYn1wQEhdUTeRXQ1k0lmJAfoLm4grB
         qxgiDaMZLMrm23zXwphnDxE8tBtMyR/teosPCtRZosAI52WTpixsBXVOEUi/iRrg5ixy
         B+WXFIV/ltJ6a+7GoUbp+zi/ILclI15Km21MtUsQyKOCQWohDIWY+20s7wASjoqfTtaH
         h+TwNpS1qY0HSkzoSL/sDJhpVdX/25gihBvZVa4ijTUH7IpY3yjTaGhkNXHwFpPb/1it
         IY6P9PJeGbQhQrKFSjCV3MMT/b3A8O1nAU19/vP1TUrocRnAq4JbB75ouJf87+blZiBA
         ILDg==
X-Gm-Message-State: AOAM531AyUnEgtcJhBMZ/89avG2Lu8DBOhT8a3UDOMD5FaG+3koWliuC
        EkXs0ZCs9Wo3VtWzhUn66nDXDxdb
X-Google-Smtp-Source: ABdhPJymkdHTYeGPNJFOG6EQpvD3WxGMxtlswH02FlDddSEYCJaH1xiTAP9eBk+cUXUO3owcAO3mZcN1
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:6315:7654:72ee:17c3])
 (user=juew job=sendgmr) by 2002:a17:902:c94e:b0:156:498c:f02b with SMTP id
 i14-20020a170902c94e00b00156498cf02bmr40300282pla.49.1649802705872; Tue, 12
 Apr 2022 15:31:45 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:31:31 -0700
In-Reply-To: <20220412223134.1736547-1-juew@google.com>
Message-Id: <20220412223134.1736547-2-juew@google.com>
Mime-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v2 1/4] KVM: x86: Clean up KVM APIC LVT logic.
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

This is in preparation to add APIC_LVTCMCI support.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 33 +++++++++++++++++++--------------
 arch/x86/kvm/lapic.h | 19 ++++++++++++++++++-
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9322e6340a74..2c770e4c0e6c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,7 +54,7 @@
 #define PRIo64 "o"
 
 /* 14 is the version for Xeon and Pentium 8.4.8*/
-#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
+#define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
 #define MAX_APIC_VECTOR			256
@@ -364,10 +364,15 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
 }
 
+static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
+{
+	return KVM_APIC_MAX_NR_LVT_ENTRIES;
+}
+
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION;
+	u32 v = APIC_VERSION | ((kvm_apic_get_nr_lvt_entries(vcpu) - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
@@ -385,12 +390,13 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
 }
 
-static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
-	LVT_MASK ,      /* part LVTT mask, timer mode mask added at runtime */
-	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
-	LVT_MASK | APIC_MODE_MASK,	/* LVTPC */
-	LINT_MASK, LINT_MASK,	/* LVT0-1 */
-	LVT_MASK		/* LVTERR */
+static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
+	[LVT_TIMER] = LVT_MASK,      /* timer mode mask added at runtime */
+	[LVT_THERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,
+	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
+	[LVT_LINT0] = LINT_MASK,
+	[LVT_LINT1] = LINT_MASK,
+	[LVT_ERROR] = LVT_MASK
 };
 
 static int find_highest_vector(void *bitmap)
@@ -2039,10 +2045,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			int i;
 			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
-				lvt_val = kvm_lapic_get_reg(apic,
-						       APIC_LVTT + 0x10 * i);
-				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
+			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
+				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+				kvm_lapic_set_reg(apic, APIC_LVTx(i),
 					     lvt_val | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
@@ -2341,8 +2346,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
-		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
+		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
 	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..5666441d5d1b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,7 +10,6 @@
 
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
-#define KVM_APIC_LVT_NUM	6
 
 #define APIC_SHORT_MASK			0xc0000
 #define APIC_DEST_NOSHORT		0x0
@@ -29,6 +28,24 @@ enum lapic_mode {
 	LAPIC_MODE_X2APIC = MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE,
 };
 
+enum lapic_lvt_entry {
+	LVT_TIMER,
+	LVT_THERMAL_MONITOR,
+	LVT_PERFORMANCE_COUNTER,
+	LVT_LINT0,
+	LVT_LINT1,
+	LVT_ERROR,
+
+	KVM_APIC_MAX_NR_LVT_ENTRIES,
+};
+
+
+#define APIC_LVTx(x)                                                    \
+({                                                                      \
+	int __apic_reg = APIC_LVTT + 0x10 * (x);                        \
+	__apic_reg;                                                     \
+})
+
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
-- 
2.35.1.1178.g4f1659d476-goog

