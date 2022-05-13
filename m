Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2747B526921
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383260AbiEMSVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383276AbiEMSVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6733C6EC7D
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u8-20020a170903124800b0015195a5826cso4729415plh.4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xJ9UZUzFDqxyn2pM0S6+OihA/OUr6/F8jHX0Qjy6Ij4=;
        b=PTTEq3bkW1AH6d/SFqPx2Uqp7eK/ME3RDOd3JBtCrOxt8NVfKzHoXDJX9PmmOEJsja
         6JKSZ/ljH7OLBiPXU+VDI9qRDmehAC30mUeqarDoUtsMCPLWTioaofIYrM/wmrMjzLkf
         hVsq6U0iH+k+XDGU3n9DHZO67bY8KmcTYQiuA3yA4pxnlctca/4DOB2HONHFkBXcUta7
         qcen0CPW+WBC/MJrqdtyCsOBhdM5j4GqFg8uIbkeatR5xWkBWvznoNfICLrRp2+JKY2S
         8LwSeTwzNlUSVhMPzcmOOe1JVzEq57NUICXn9uq59pMacWfAlpnwhP/NZQVU05nKGDsh
         CYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xJ9UZUzFDqxyn2pM0S6+OihA/OUr6/F8jHX0Qjy6Ij4=;
        b=qor9eIBhvb/TucteaEmtzA6ICSlxvKFHAnE3U2lrd2N3lWcCWZKv08e51jVe23ESLE
         ZK4fE1aH3kLZsKXhr4BXyxGJgPUrHnuLvfyz6Y+b/EPH3OzOUj0rrCHBEYEZZ62IAaeN
         sMFoIqj03bmHQkRRLKgMxDIbumZAb5QS/lqjhHoiUBXK/1MRoq8Ml7/J3T0r2p6nFUpq
         Ih/qZvW8CggAGFZbtAmT4d1RPHD+NJxU27Rnxm9Aqi48G0kb+gY2tMPPZXeRPHKWtXRF
         0528F1cc8/G2ul8BAiCeYvpIAmGipTI9S+vyJFH295eWCTXfll2WF4qC2piCJ2JsZk+s
         TxLQ==
X-Gm-Message-State: AOAM531nX52tJT1bdknynyN5j6oIJFqO6EUdU8eZLIr1f80gg6fDGRgt
        PiKHEHQ21o2G4IwhGNejgV4VYG03
X-Google-Smtp-Source: ABdhPJyEqIK2mcD8BluKcAzioA+zUcqni66IMWPLkxQZ0SGr+LqOqBDkNw387HYbD2zEr5fLS9ozbekL
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:903:240a:b0:14e:dad4:5ce4 with SMTP id
 e10-20020a170903240a00b0014edad45ce4mr6032750plo.125.1652466056915; Fri, 13
 May 2022 11:20:56 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:33 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-3-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 2/7] KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
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

This is the second of 3 patches that clean up KVM APIC LVT logic.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>enums
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 19 ++++++++++---------
 arch/x86/kvm/lapic.h | 12 +++++++++++-
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73b94e312f97..0886fb6adbcd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -367,7 +367,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
+	u32 v = APIC_VERSION | ((KVM_APIC_MAX_NR_LVT_ENTRIES - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
@@ -385,12 +385,13 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
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
@@ -2039,7 +2040,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			int i;
 			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
+			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
 				lvt_val = kvm_lapic_get_reg(apic,
 						       APIC_LVTT + 0x10 * i);
 				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
@@ -2341,7 +2342,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
+	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
 		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..f8368dca177a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,7 +10,6 @@
 
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
-#define KVM_APIC_LVT_NUM	6
 
 #define APIC_SHORT_MASK			0xc0000
 #define APIC_DEST_NOSHORT		0x0
@@ -29,6 +28,17 @@ enum lapic_mode {
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
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
-- 
2.36.0.550.gb090851708-goog

