Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D01BD7E3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411782AbfIYFrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:47:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36410 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404442AbfIYFrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:47:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id t14so2147063pgs.3;
        Tue, 24 Sep 2019 22:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Eh8M+3jwlHqT1zqxVtZVbiy9DN02YJpr1pbJ56Y3aJw=;
        b=H3BMqCM4fpx9/r8aQmcQLoZfSDjG38Ori/JsBght9/0VcgPT6fMKJujT46xn536f3S
         gYDai1Q+094xJ6CPTlHxNccR31MfXKpYtdWnTWvoRTpqtYYARX6oXcJIsh+Cdtus/UsZ
         nl7RlKHtVBbiaaP1AejOcflL8rLCwv0Sk8i4Xo0YIiahEgpGgg2rTB528ZIdqTx2mdwM
         a1oCKGAtEIj3MVuINMM5/XAjM9Tnx70juFH6uG8/gw1KM0MzDUDdr54SwhB1/2wmZBiS
         IhfxRV1qSkekwhhOauK9dGD3+08Kn9XcA4dYBUQXenkeU0uXgw5+uiKAtqrUeX4c5iPW
         Qxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Eh8M+3jwlHqT1zqxVtZVbiy9DN02YJpr1pbJ56Y3aJw=;
        b=AUneuELG8Tj9rheBa2o9PQi+0JPBb/VbAj6CWw5pLq8tUY92BKLgp0cYFFWirRW+0E
         A9i/uOog3X/B5nNEG5u3ivtO2R2+ikEgiHjwlpYEMC/Tj118xCMvByEzXjvPOXyl+chq
         K367fc+Vh1oR54lBQ4hU+Jeseq2YNqM/TxQS4YPQrN2oJEgalgrH+hSeYnBnGzid3CVN
         I4TB+oEMg4IbUwpD4fDVmxfsOEgWmQAIKZ3IMcnGSAU65gYaMz7LzyMWCZlUPQtc0AeZ
         5EdYA949Dn+MTv81qWepWCqX214dWk8zLTAiBlLcRNsVKbagkjepT7TQraRK62aUZb9Q
         aluA==
X-Gm-Message-State: APjAAAVgzHEXz1gAfJck8ZeqG6V90REFUpu4vQF1rFt9OxdwYgaeDRH2
        z0nqBZ3AhLLB32SsPE+ekd7F9cgt
X-Google-Smtp-Source: APXvYqzal/UUKYK2deJAe8JWlIx0ed7Hs3eIeBRQF4xuySPJ+8IKqG6brcmqHMwlOGPMTnYz61DwVQ==
X-Received: by 2002:a63:e24:: with SMTP id d36mr5060897pgl.143.1569390436340;
        Tue, 24 Sep 2019 22:47:16 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k4sm1623829pjl.9.2019.09.24.22.47.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Sep 2019 22:47:15 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Loose fluctuation filter for auto tune lapic_timer_advance_ns
Date:   Wed, 25 Sep 2019 13:47:04 +0800
Message-Id: <1569390424-22031-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

5000 guest cycles delta is easy to encounter on desktop, per-vCPU 
lapic_timer_advance_ns always keeps at 1000ns initial value, lets 
loose fluctuation filter a bit to make auto tune can make some 
progress.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3a3a685..258407e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -67,7 +67,7 @@
 
 static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
-#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
+#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 10000
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
@@ -1504,7 +1504,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 		timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
 	}
 
-	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX))
+	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX/2))
 		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
-- 
2.7.4

