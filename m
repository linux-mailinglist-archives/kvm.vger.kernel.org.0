Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286BF43749A
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 11:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhJVJUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 05:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhJVJUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 05:20:22 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC7CC061766;
        Fri, 22 Oct 2021 02:18:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m14so3063026pfc.9;
        Fri, 22 Oct 2021 02:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=uXJhrAAv1FP9QRnnF2HBXQsNcMdCBmC40Y6v1NS6JcU=;
        b=iNi6AaxCGz3PZYncKLpn8gEJA1SLaUE7IJYoVsbkK8C+45L/Hdd4wHVGkBAhUQ8gRR
         vQrLyDbt2oOfI/Z+M4h7JYSJ3guKYfLWWjoEZLo9poF5BLooREa+ltdx2nzIZ1ObuxSm
         rWXSH0s4KtMDQ2ggqeduPHcmQlc2MrxNtIqOhWKeIxuCI1qlxNyeqi7ioUjH8GswZOqY
         Of6mDF8JvEBO1A//C2FhX0q+py4wh3Ejrcxxu95i0EUoa0ZfAGn3yVXHNq3Vtuc+LU6J
         TMOHKc/wn2F1vbrsDaOqJioTzGKcOYQ0ZjfnfaCeKNuRhbbkxitSW6rL4IbJcssR5+Ga
         CVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uXJhrAAv1FP9QRnnF2HBXQsNcMdCBmC40Y6v1NS6JcU=;
        b=DzxqE7HTcX8VxiB0bW3m6ktVt3r6GGDn0sab4CbKpO9y7RjLrbXEWZscvxn46RwImB
         S6w5OTDu0FEkoRd0DQPEBuygnPBbCzIcTJFC9lBR1uyH2phvkKlmyYY9AQIr/GjWTRUt
         bXRbuh+co9rdj6Q/3kjNeeubka6rLA/5LY+KlDCpTeHWD3r527HvGr1t3v6K7/S2gkV3
         l92s07m3PTW3gtKl61P82uDelaCDKg/zbQ1IvYyEPC3jYh8cZRSVVWfKLiJa3/Uf0ugO
         /r+uiEpGlosnzTzuWEHNxZrAARPCKb/zHVzlpHviM9M17pCLB6vPwT17aYpiN4T1GVep
         22mw==
X-Gm-Message-State: AOAM532wKiUKei5s769mr6jScVnJRw7x92uVdq+X+2xGm0kS2z8Pnyht
        /rhPc4b0b5/fWbEzTe7v0nH3071ryRs9Ng==
X-Google-Smtp-Source: ABdhPJyvckNBgCllhXnljM37p4JmPIJKvGgbp40REcabIFyPCBwa72VDfcTMdkRMB1HnxOlDUo/C9Q==
X-Received: by 2002:a05:6a00:c8a:b0:44d:8985:ff4f with SMTP id a10-20020a056a000c8a00b0044d8985ff4fmr11507244pfv.1.1634894284407;
        Fri, 22 Oct 2021 02:18:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.googlemail.com with ESMTPSA id z2sm5798779pfe.119.2021.10.22.02.18.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Oct 2021 02:18:03 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: vPMU: Don't program counter for interrupt-based event sampling w/o lapic_in_kernel
Date:   Fri, 22 Oct 2021 02:17:13 -0700
Message-Id: <1634894233-84041-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

vPMU depends on in-kernel lapic to deliver pmi interrupt, there is a
lot of overhead when creating/maintaining perf_event object, 
locking/unlocking perf_event_ctx etc for vPMU. It silently fails to 
deliver pmi interrupt if w/o in-kernel lapic currently. Let's not 
program counter for interrupt-based event sampling w/o in-kernel 
lapic support to avoid the whole bothering. 

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/pmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..fa5cd33af10d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -179,6 +179,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	struct kvm_pmu_event_filter *filter;
 	int i;
 	bool allow_event = true;
+	bool intr = eventsel & ARCH_PERFMON_EVENTSEL_INT;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -187,7 +188,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	pmc_pause_counter(pmc);
 
-	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
+	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc)
+	    || (intr && !lapic_in_kernel(pmc->vcpu)))
 		return;
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
@@ -233,7 +235,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	pmc_reprogram_counter(pmc, type, config,
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			      intr,
 			      (eventsel & HSW_IN_TX),
 			      (eventsel & HSW_IN_TX_CHECKPOINTED));
 }
@@ -248,7 +250,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc_pause_counter(pmc);
 
-	if (!en_field || !pmc_is_enabled(pmc))
+	if (!en_field || !pmc_is_enabled(pmc) || (pmi && !lapic_in_kernel(pmc->vcpu)))
 		return;
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
-- 
2.25.1

