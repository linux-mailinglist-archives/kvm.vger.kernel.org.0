Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA539D5DD
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 09:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhFGHXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 03:23:41 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:45921 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhFGHXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 03:23:40 -0400
Received: by mail-pl1-f169.google.com with SMTP id 11so8118757plk.12;
        Mon, 07 Jun 2021 00:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=q7iHNHYs1n4324aqHEvwnEdh6pf7YebasuoN/z4QMKo=;
        b=AmPpoDoiyKLpqVOzklXqUFTFaBJQ2LDe1AC70ynujE9fMRvPs4KKNCrHUrOzjJ3YSE
         lMhjjJWTFXCovVM93mO0HLPBomLJmJel868NvWDCzQXyH4a+RayKzo3A7pyewET7vrGW
         firnnK/p4PzvWrf5a9zFL9FJBhsg6DyGnm4i1rTPIXAii86v/Di3VnK63DQzr4QLs5/C
         DDv2spiK66wjuO2ZVQSBYCwMPKZBoo0U4Ikqr+HpcjGhS8SC3DkKsJTJu7x1QDrZjtvM
         Qqv9USU6QpG+tQi447/Sd4FhfEQE8/xc/t2bTxagkNcnnwR4ccMq6iyT+Jna03ZhG5wO
         B30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q7iHNHYs1n4324aqHEvwnEdh6pf7YebasuoN/z4QMKo=;
        b=rqPrsM+Tpap6yuA13dSVn9bnXCx7iD8f+3tJl/iHQK75JO/axghOoa86tccaSaxH1n
         j+F3TA7a122UQPhPcRRDyCJ+MAt1sxEcfsmirLSjzJ1VfwT6dkmSq2amxLYLaQPAGMj1
         Ww0iK+bEho40ahjplmIWJ1zzgtlyxZvHTgs0p6nBcX5wMUGPmw3RQag8WiCEJP8J7UvW
         LfjWMkIVeOJFZqHvTvCiR9tROXk/1TD99wlddg1MYev88jkxsi0xVlZ7KeuDrmUnq5CM
         RYbhusg0DYFWPFpRhois0iCWWrCS56O8n0Q8f32NqY+3YbKoL05DdY+BiAdLrcZ1MP85
         nxVg==
X-Gm-Message-State: AOAM530nxKmzgi2hduKpuzdMacp2n8LLWHWDYySc+XJhk1HvV91zqffi
        /+cuLSqgSe4KvkzoSxIKOPWMUITlCVM=
X-Google-Smtp-Source: ABdhPJxheeDvMX0UcGShwvAvnm5/GWjtEE+DXLEvaGwgHrxnqM6VznprnpTGFOLRg4j/g04cjPOVgQ==
X-Received: by 2002:a17:90a:5142:: with SMTP id k2mr29661360pjm.5.1623050437069;
        Mon, 07 Jun 2021 00:20:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id f3sm10797137pjo.3.2021.06.07.00.20.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jun 2021 00:20:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/3] KVM: LAPIC: Write 0 to TMICT should also cancel vmx-preemption timer
Date:   Mon,  7 Jun 2021 00:19:43 -0700
Message-Id: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

According to the SDM 10.5.4.1:

  A write of 0 to the initial-count register effectively stops the local
  APIC timer, in both one-shot and periodic mode.

However, the lapic timer oneshot/periodic mode which is emulated by vmx-preemption
timer doesn't stop by writing 0 to TMICT since vmx->hv_deadline_tsc is still
programmed and the guest will receive the spurious timer interrupt later. This
patch fixes it by also cancelling the vmx-preemption timer when writing 0 to
the initial-count register.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * rename to cancel_apic_timer 
 * update patch description

 arch/x86/kvm/lapic.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8120e86..6d72d8f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1494,6 +1494,15 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
 
 static void cancel_hv_timer(struct kvm_lapic *apic);
 
+static void cancel_apic_timer(struct kvm_lapic *apic)
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
+			cancel_apic_timer(apic);
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
@@ -2092,7 +2097,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		if (apic_lvtt_tscdeadline(apic))
 			break;
 
-		hrtimer_cancel(&apic->lapic_timer.timer);
+		cancel_apic_timer(apic);
 		kvm_lapic_set_reg(apic, APIC_TMICT, val);
 		start_apic_timer(apic);
 		break;
-- 
2.7.4

