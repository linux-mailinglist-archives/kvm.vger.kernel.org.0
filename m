Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114F4399D57
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFCJES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 05:04:18 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:45690 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFCJES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 05:04:18 -0400
Received: by mail-pj1-f54.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso42255pjb.4;
        Thu, 03 Jun 2021 02:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QohK85Va24247n8VfPeSE1UKGpQDl0MtTdqghurawaw=;
        b=NVSK7yX3uDBqhDx8NqEJEp2LOoOYME5zBCIVowkpm+fbGa0ImKZ+nc7eHiesLQlvp0
         LXuBXshuvGkscJ7aY5VSSfu2EpQH6Tm6kR+a6hNH7bnd/7coMWyayehRn+4bKQbnSPD+
         79Bd9GLCtJDVwTMw7NlygRYCb73tYi4oeOjYMvjDbCuBsrwlyrHEucrXc6zKvJFoCaFq
         wkJJ9NS/xwj+m0uPT84+bYebhLD2eGWVXicsuej6UdtD0GW2GT9t2/xgxMFK2IVOpMjG
         Mq+JkqqDlQYMdOcXNs5H9XgZxnaw0X+23b4xBqJwBI+8K86eu2XEl2ORf/cmj744kyJr
         QQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QohK85Va24247n8VfPeSE1UKGpQDl0MtTdqghurawaw=;
        b=LYycXM98S4EYgoBiLM34wJfd9kWrNVwtEd4oSUmQPX0aVo5w2crvHddntRPJhVJhe0
         wUGcJx8UtVuLYYf6vo//r90OedsAq2A7jSj6pMEJMeA30YgtBfuJYbmipOQ3Zb8de6XZ
         PflFYQJi5D0jhia3cM7KwEXVElTUmaH+VHus6V9PXsSItFvwwJbcO35CL6teadhK4pRt
         VjD+y9CiBGnpx2Rwsx9oe283OT3ukgwFVilKDkugpidjdJvhnKBsJmBHUjsZm2nslYCt
         Cw7WmvOsM1zwHk5CZNlT5d+9S4h/nruJ8w9Nsi8rXCHzuFlBFdIFZUz8MEkRApX1OdsP
         ABZw==
X-Gm-Message-State: AOAM530r0x98b1Xf3JtLf0wEMv67YfZpXmTx85PCmGEzpwYyAKW+Zm79
        DJLm4B0UoXiHG98Iym/aPP1qeJ91rS0=
X-Google-Smtp-Source: ABdhPJxScFnFbZkegYnkVZ67+YV9F3nzs/3ZXx2RjtTifFCpD3r3ui1fDgltSNsGA+0aDIQnefMPWA==
X-Received: by 2002:a17:90a:5d8e:: with SMTP id t14mr34878104pji.85.1622710893638;
        Thu, 03 Jun 2021 02:01:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id gg22sm1625668pjb.17.2021.06.03.02.01.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jun 2021 02:01:32 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: LAPIC: write 0 to TMICT should also cancel vmx-preemption timer
Date:   Thu,  3 Jun 2021 02:00:40 -0700
Message-Id: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>
 
According to the SDM 10.5.4.1:

  A write of 0 to the initial-count register effectively stops the local
  APIC timer, in both one-shot and periodic mode.

The lapic timer oneshot/periodic mode which is emulated by vmx-preemption 
timer doesn't stop since vmx->hv_deadline_tsc is still set. This patch 
fixes it by also cancel vmx-preemption timer when writing 0 to initial-count 
register.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8120e86..20dd2ae 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1494,6 +1494,15 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
 
 static void cancel_hv_timer(struct kvm_lapic *apic);
 
+static void cancel_timer(struct kvm_lapic *apic)
+{
+	hrtimer_cancel(&apic->lapic_timer.timer);
+	preempt_disable();
+	if (apic->lapic_timer.hv_timer_in_use)
+		cancel_hv_timer(apic);
+	preempt_enable();
+}
+
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
 	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
@@ -1502,11 +1511,7 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 	if (apic->lapic_timer.timer_mode != timer_mode) {
 		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
 				APIC_LVT_TIMER_TSCDEADLINE)) {
-			hrtimer_cancel(&apic->lapic_timer.timer);
-			preempt_disable();
-			if (apic->lapic_timer.hv_timer_in_use)
-				cancel_hv_timer(apic);
-			preempt_enable();
+			cancel_timer(apic);
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
@@ -2092,7 +2097,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		if (apic_lvtt_tscdeadline(apic))
 			break;
 
-		hrtimer_cancel(&apic->lapic_timer.timer);
+		cancel_timer(apic);
 		kvm_lapic_set_reg(apic, APIC_TMICT, val);
 		start_apic_timer(apic);
 		break;
-- 
2.7.4

