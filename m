Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADCE255295
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 03:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgH1BfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 21:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH1BfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 21:35:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E648C061264;
        Thu, 27 Aug 2020 18:35:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 2so3561540pjx.5;
        Thu, 27 Aug 2020 18:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rxAwjBtuOkOHsCKI2ATmMoWk7nn27DCJ9baRXRPv7gw=;
        b=fRHT5WZFbeMN+s2XVWB/NxbZCCyRDtI6J+tcc1/dyBOTnfX954wwDt3kriLkxSvyzM
         p5zo85HxXxh3wTjsQ5b57HMd4x6/sq0M8kmBRo24B5PfrwE+6rngKdYU22ZH2PmEsbYN
         tf/d/7IPgibKHH+/DjBwn8hyAZ6ccE2bFNzCoeUIrveT23AB7Dm/oPhej5AyFGNH2n1x
         vjDk6zWGOfx50Np0VhiAGPPImXpKlR48Zwo0HtQStzP7Lqll037XWBGQdX4JFpds/PZJ
         Zumtzf5UzA6ebwN2wGOVmZuYJzf6VXL9tw4eLOFGT8c7Bpo0X/aHtOGcS6ATBjvPFTta
         K5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rxAwjBtuOkOHsCKI2ATmMoWk7nn27DCJ9baRXRPv7gw=;
        b=TnW/k6GBKS+pRvUvKMK9iEc6zal91lglHa9MraFXv6/cu0YJpd2EBZvatIZi2taYVR
         fWYLbjvIhNaXk0AtR+y577OKwdymLwASTDUOaUfkVcXir7RM3dRk1C3AzQqhZmMskPJa
         ACZQSQU9oCJLfpPDISSIKzCscbNA17SuExtnGAdu0yGmQxL3W7f0TN2rY2iw4zfvdq/V
         weY7sNpX6QouuZ0VZLXXaHDsaSJaMkD7MtSJBeiY1ZSt+MkcOcT4GW6DQlQe7SCmYj5k
         YSSyL8mPHgAHeDyTUchvQfeHTIrQWBJuF/f2CemrUIIAyMSQ1MST3Dg6jC9kDf3dWtGD
         Lf6Q==
X-Gm-Message-State: AOAM530nvCC7eAeX+v2189FXXY4zEyp919nQJ9eoob+L50KPcgUNRszA
        IbfHWnx/LL1u4NHOTeG2FnT2vAdOFBQ=
X-Google-Smtp-Source: ABdhPJzariVnAqnB4Hk/D+KzhbrZIV+Xpa5zg7Et27t3/fcuC6vm7zCm93AbP6pLhCsbe69QM36Ehg==
X-Received: by 2002:a17:90a:d597:: with SMTP id v23mr352068pju.24.1598578519288;
        Thu, 27 Aug 2020 18:35:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id b6sm3309715pjz.33.2020.08.27.18.35.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 18:35:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
Date:   Fri, 28 Aug 2020 09:35:08 +0800
Message-Id: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline 
otherwise we waste cpu cycles in the function lapic_timer_int_injected(), 
especially on AMD platform which doesn't support tscdeadline mode. We can 
reset timer_advance_ns to the initial value if switch back to tscdealine 
timer mode.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 654649b..abc296d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1499,10 +1499,16 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
+			if (timer_mode == APIC_LVT_TIMER_TSCDEADLINE &&
+				lapic_timer_advance_dynamic)
+				apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
 	}
+	if (timer_mode != APIC_LVT_TIMER_TSCDEADLINE &&
+		lapic_timer_advance_dynamic)
+		apic->lapic_timer.timer_advance_ns = 0;
 }
 
 /*
-- 
2.7.4

