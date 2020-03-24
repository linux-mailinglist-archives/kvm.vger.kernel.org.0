Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30191905C9
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 07:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgCXGcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 02:32:23 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37158 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgCXGcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 02:32:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id a32so8528282pga.4;
        Mon, 23 Mar 2020 23:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RYToHZ+7iNfBZeY3Gu14A1/8MKyc2I2S/2zaDgB0iI4=;
        b=BWEZI2jNvHEI+JUf+q2P+lK3tp7I3a+94lbqrWJ27HAtiosf4mOvGIOSnCq1t2zdX8
         0g954KZ5LWp9K8cQmWUCzE+kQosb0Zs9FuRBxfCegYIxFpxZhSGAw93TPS9ybyN4ThQ9
         qL3OA1haaeFN9HGsJ1eaOZYdcGii2xGhhn4EWzKnSLPD89WKtvphXCMWUlMVqP0LSDb+
         UjSRh/Gqt/MOi4FKIaNRplHzg1dAnIUj8J562uAZUtrjr2dE7wkarIdLM45QzQi+sdfT
         9gLAdYZ/HV8Tl92pn+6Hnb9EEG/2wLRn3czZSNLhJIiK0Gx9jo7n6P03K+TkQ+tDfzTK
         nP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RYToHZ+7iNfBZeY3Gu14A1/8MKyc2I2S/2zaDgB0iI4=;
        b=fh8h6OFAfZax4lT2twGKYl0MQpME6Y2E7b5JuG7gJOHbRinJsSsCsmRGwCQySgl5yH
         d5TW1OGKsinJA4aKiHVmk776L+a/HAEz1wkzyGXDIWvd3jt5ic33hDgQWS4h6QzUnFTT
         nqbeHacoi59X7Q9ZAImS/aprIk7npjDviGe82zGznVWoxU2r7Jar2/qo76NRDXsyMRDd
         SIDL0DYfF25y0MYHRzvm22LUt0ZQ1ylCyr81zPU8roo+uJ+p+z9C9Q6jI5iJJn7jMjCi
         XiwOxnT4F+jNCy8wEAcQxmcO3GqC0crGsDH2tm8a0kIcqV43hRmfVWk6bS1/L+FpgtfP
         DFLg==
X-Gm-Message-State: ANhLgQ3sVYcFQd9xk6E5KuWbpjBNsiWBuewhZuLBtQ5FkZZWK96QUAnL
        e9KCBhRUokobCK6j3wW3E1RU1tIQ
X-Google-Smtp-Source: ADFU+vtA2k85dAcZkXdqs1gdZC5f7Y3C2ohwOPAYYZpbATGivbbwvStOrdBdFFfCYZDGQ2Ymr1KizA==
X-Received: by 2002:a62:8343:: with SMTP id h64mr29451711pfe.166.1585031541385;
        Mon, 23 Mar 2020 23:32:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id a15sm15136975pfg.77.2020.03.23.23.32.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 23 Mar 2020 23:32:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm LAPIC timer
Date:   Tue, 24 Mar 2020 14:32:10 +0800
Message-Id: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The timer is disarmed when switching between TSC deadline and other modes, 
we should set everything to disarmed state, however, LAPIC timer can be 
emulated by preemption timer, it still works if vmx->hv_deadline_timer is 
not -1. This patch also cancels preemption timer when disarm LAPIC timer.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 338de38..a38f1a8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1445,6 +1445,8 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
 	}
 }
 
+static void cancel_hv_timer(struct kvm_lapic *apic);
+
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
 	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
@@ -1454,6 +1456,10 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
 				APIC_LVT_TIMER_TSCDEADLINE)) {
 			hrtimer_cancel(&apic->lapic_timer.timer);
+			preempt_disable();
+			if (apic->lapic_timer.hv_timer_in_use)
+				cancel_hv_timer(apic);
+			preempt_enable();
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
-- 
1.8.3.1

