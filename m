Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1A546B80
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350145AbiFJRLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346765AbiFJRLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:47 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC541F5E1C
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:45 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so1730005pjb.3
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vdyp/lIplKGL5QbZNVdEhHWSmxyd9Tq09BS7PksJiNc=;
        b=L5p0TSLR1J1rqisQB3nAow0rZ6r7tKjU6Xt1PZx1BAn4llS6dCKKHNDAy7FdCIc+3T
         gFi+EdbmlaGMvYv9Uom3AwSPNRA+qC7VdMuFoUWYkPCIWAq6KU7bpya+8j2q9sgWR6To
         Px7bIkV/3E+VMSTOYT/mYRbnuS6sywInh5aEGf1osfOfkoGYLG4W2IV05IxWnNGh4z0s
         hu6NXmEWmRKaHyyzoQbQnXLrOf/hx01bgLE6JVwdj11/cjff2RFIQrS3lslP2BmVFYe4
         pSRpYYJHwdxp6gSMBuEW4M6adW8tVVtUpPVmYsqkRD/7mfW4kGV9aAUpF6G8Bm6iypS5
         OFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vdyp/lIplKGL5QbZNVdEhHWSmxyd9Tq09BS7PksJiNc=;
        b=g1NsxTx8fptAMsq/jbrDUvR7wR4hAsWJwDd/ffPiOJN0MXbmrVrGRNAH2cTzwf57Sw
         pSej38jYnvUoeyEN5RtQlIGbeypJFfwd2Lxy8F9s+jU6fzTkmXzNW9zUdaTemZQL+4Lu
         Kp9dZo5DgwHgKOxjcba7QvtJ7H6pINSQYvTNnKlxvxSzu7d3PJ5scsI6ZvmnsCQAOpiP
         xE02fRaY/BikPIXMRMOT4xeLSNJyz1QMnmFaRcDNLN4PeeHcPVtk9IT40dsqAIH2rPDX
         KNq8yst89L+BPdAc//jxDtmi1KEk61We2UdYs1PwsEvVMQES5TPaVNy8MbEfutD9EoKS
         j4vQ==
X-Gm-Message-State: AOAM5324qV9oCRTckyfG5yU4C1XN8uAw8+wI3wQK3idtuCXT9ihmUFl3
        HXtbLJjDmfnEJLgHa6MVLBdKicR2
X-Google-Smtp-Source: ABdhPJwAspSAmPEQ0sP7pPcv430+v75VDunJC3twbbOzqA7uU68rz3JYS5vsaxcaHouEVJD/vO7wcQCh
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a05:6a00:1306:b0:512:ca3d:392f with SMTP id
 j6-20020a056a00130600b00512ca3d392fmr114772794pfu.79.1654881105252; Fri, 10
 Jun 2022 10:11:45 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:28 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-3-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 2/8] KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
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

This patch defines a lapic_lvt_entry enum used as explicit indices to
the apic_lvt_mask array. In later patches a LVT_CMCI will be added to
implement the Corrected Machine Check Interrupt signaling.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 19 ++++++++++---------
 arch/x86/kvm/lapic.h | 12 +++++++++++-
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a5caa77e279f..73f5cd248a63 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -401,7 +401,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
+	u32 v = APIC_VERSION | ((KVM_APIC_MAX_NR_LVT_ENTRIES - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
@@ -419,12 +419,13 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
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
@@ -2084,7 +2085,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			int i;
 			u32 lvt_val;
 
-			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
+			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
 				lvt_val = kvm_lapic_get_reg(apic,
 						       APIC_LVTT + 0x10 * i);
 				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
@@ -2383,7 +2384,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
+	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
 		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4e4f8a22754f..4990793c2034 100644
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
2.36.1.255.ge46751e96f-goog

