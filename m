Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A152F1BD
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352294AbiETRgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352211AbiETRgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:48 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6924981999
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bj12-20020a056a02018c00b003a9eebaad34so4433773pgb.10
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4cDWfCwmCOKbHFB0IhxZNuHaEjb2PhpPJoHO1NQ3cko=;
        b=IIwVZxJEQ0U2YAqdYGbV7g2xNvT6/zvfWJtEXu/pC2+yzK2pvCrs/TG3OoaLNazycE
         5vOOZQMRqFtw8mGjegNItUTKayt3QBHtan4vbMWX4wUPzD+7ip7ldIerxGXE5nBzUK44
         TMa/FDlr0j5499nJQLKmFMQfQcW5i4QHFJLwdzQ9Z/u32YuxZx4gHvI87x5pM4GMPTyn
         qyVT2Tc5MiIMck761QpfXWOLe1UZv7eirGwQvOInZbi9rGSZQSH06R/hZRq9bl4uqg2c
         5IkayQ+fguKUYwRC2+e9aQikFAZJhpySxukHgSIppAxw7QPsdiMToq8v1QNVV9ihDPkq
         oTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4cDWfCwmCOKbHFB0IhxZNuHaEjb2PhpPJoHO1NQ3cko=;
        b=P/b6Rok8IbK4SZsoR1iAsRV9DHLCAsEgl5dDrHbBljKivgpCdKqancNLObdIXjuVh8
         W8zs1CjAf8eyPWnprpNMVpqa43NotP7VR9Adf7rxm54jOcd5mRi1UksKJpTFtJOVP5N5
         A69UIub9pa2ZSNY9/JCIzcqgho7zFeTJwj7eAm4EMNR6B/AZ7AiLtYO4KSOkT+YOwFjh
         /K4DDujQfZPp17REFrIrkrMAk40oV9Ec3egOujBikzfW+aB11Y4uEoyYV94iIh5XutVH
         lVKSjvaI9KSwqK8azmeYrmYydwT4mgIjKpYG9NSvgsvcJL7S1aISa9S1dT4mCkUcSRRT
         VOCA==
X-Gm-Message-State: AOAM532Jf2wUoXUFVnOXQjy9bTm/xgurtkPt3SXSjCdKpJu8bSiNW+53
        ATwd/V0jgogpcrLnIKC4jIEp90/G
X-Google-Smtp-Source: ABdhPJxZhI7upGz/mVmJfn0bCUNEPk5Z59JFVA9gIqkFVYzEdZ4S/CaHhLaIDwWhPbc9L2mr1XrjWF30
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a17:902:6846:b0:161:5b6f:8995 with SMTP id
 f6-20020a170902684600b001615b6f8995mr10765465pln.66.1653068206752; Fri, 20
 May 2022 10:36:46 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:32 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-3-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 2/8] KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
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

To implement Corrected Machine Check Interrupt (CMCI) as an additional
LVT vector, the apic_lvt_mask array needs to handle LVT_CMCI
transparently when LVT_CMCI is added.

This patch defines a lapic_lvt_entry enum and use its elements as
explicit indices to the apic_lvt_mask array, naturally extensible to
support an additional LVT_CMCI enum hence apic_lvt_mask element in the
future.

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
2.36.1.124.g0e6072fb45-goog

