Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D73387850
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349003AbhERMDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348997AbhERMDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:03:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E400C061761;
        Tue, 18 May 2021 05:01:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b13so3477992pfv.4;
        Tue, 18 May 2021 05:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=soOUzbLJHd79dLzXUneFH08UM8yTlNutja4acLt0+qU=;
        b=hIdVLuZbbk0swz4hpVBO5hP1ydSkuNP4SwlXYVJ4f2xrIqZy7KGaH9grl6v6LlNJLY
         bDirjnkwMnbG96k6JaFACCjjPV3taK7feKB/DCqVY8eq4jpnFPXi3V5pOs3ZevSSzdaj
         qXSii3s1GknciQzSYzAYHIsP951Uzqo6egApt9F8IVg0MfgNjio+FwycWiJSDO7nCHOv
         08n40f/UU7WaAZY5IPClwkxtiRyiFD4z2Mh3id4MXy4nuKcyMZIqm0jl1uMxa4uYv0p1
         ljY1NyOs1CbzGigFkjqB2GHMVfqaiPTF8oB7984LCCzOTS/8795Ug1xMRoddTNoyU2BW
         K+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=soOUzbLJHd79dLzXUneFH08UM8yTlNutja4acLt0+qU=;
        b=ncurSObIRNDrVewa6ONUlxk1LzWx1mCvkmL6Opcn9ytT/LM3eUi7WJCW3/lnBlnHz5
         uMf5BRmw/a+FjG45hFa4gb06RoabrO1yM/FLGHEbafSyV+YkUN0LVEVxS4J3nW4xxdPc
         Opq3lCK+Lpsf9imhArM6mSEUAlzr/LgWhMu/7h3XJmQ1Fze+bGnqkaCHaY5diD2usIHA
         l7ojQ120r+Y5jUMN029Rn4PmPAsIrktN/SA5lOKQ2NLBuC0lMM+WABKFL8oUNm/P3E1I
         z0KYAZPjhvcUPghWhidaVhJQobSZvN/GXbpZWKvTOrKi0H1GBV7pEzzr5WB8uVDRWBFH
         YQMQ==
X-Gm-Message-State: AOAM533lD7Rec7V1kmH4RXBlvIPz5AYZWGkMufDTgfiXRdusPkLUOxIW
        uNlHJwburaF8y3sY3oBLabvkjfGc0tw=
X-Google-Smtp-Source: ABdhPJztev0nvWB7p2r+uTPVQkH9uSr4620Rogko2ex6afamBnUY4Y+8h39mp42uX4FtDw+3fhQjsQ==
X-Received: by 2002:a63:d744:: with SMTP id w4mr4791316pgi.76.1621339303764;
        Tue, 18 May 2021 05:01:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id l20sm12757394pjq.38.2021.05.18.05.01.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 05:01:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 5/5] KVM: LAPIC: Narrow the timer latency between wait_lapic_expire and world switch
Date:   Tue, 18 May 2021 05:00:35 -0700
Message-Id: <1621339235-11131-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Let's treat lapic_timer_advance_ns automatic tuning logic as hypervisor
overhead, move it before wait_lapic_expire instead of between wait_lapic_expire 
and the world switch, the wait duration should be calculated by the 
up-to-date guest_tsc after the overhead of automatic tuning logic. This 
patch reduces ~30+ cycles for kvm-unit-tests/tscdeadline-latency when testing 
busy waits.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * consider automatic tuning is disabled and timer did not arrive early
 * add a code comment

 arch/x86/kvm/lapic.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..5d91f2367c31 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1598,11 +1598,19 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
+	if (lapic_timer_advance_dynamic) {
+		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
+		/*
+		 * If the timer fired early, reread the TSC to account for the
+		 * overhead of the above adjustment to avoid waiting longer
+		 * than is necessary.
+		 */
+		if (guest_tsc < tsc_deadline)
+			guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	}
+
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
-
-	if (lapic_timer_advance_dynamic)
-		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
-- 
2.25.1

