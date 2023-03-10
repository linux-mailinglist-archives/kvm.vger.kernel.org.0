Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812BF6B3CDD
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCJKyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCJKyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6850E34B1;
        Fri, 10 Mar 2023 02:54:06 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i5so5149454pla.2;
        Fri, 10 Mar 2023 02:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8Hr3QtIgBczYQFBm2I7OLr4pniDkf51aghVy6gKg5k=;
        b=DEtHjBAdk+4Ao8ILVr17mBoLdOTmMBfX95K/sEkKsjA1mMSQkbhefJH838YtAqHSZF
         lm2VOPMYBKHibdK5A1y/S/rO39ah85Mt1fK/TMYpV5OlXehyihRnKrgI7ljcWtc32+fQ
         4oN135uBZPPgRJhnw76rGxH/9MtHM13G0LPWbmtspEqtjze349O62oVwF70O5tTo+HnF
         O+ftDtFH+yR1odivSVCcX+yGzuSoq/3AIefgMypbKG1eXOZb8kc6cLV6ypYdFFtuSAJo
         3r3VwfSQpLKYQRtuW6L8B8eu6iTFTwFNkgBpicGk0aWaIF2a0f4Wqgtb2ujc/h7ejHRR
         00eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r8Hr3QtIgBczYQFBm2I7OLr4pniDkf51aghVy6gKg5k=;
        b=l18hLU7bmgThKa4cS+Ie+Fq7JkhkiIiBoy1KoC6VTHiHsoWj8DUAKYubwwhedbx14Z
         69SXfK2s++wvEmoAa8OCopxxbY6Fu2CCxqamLSJNW6nnj4BQ9dCEx8g4gYcS6JbUmVhC
         iu50+vFlPojuAtZA7uAhHETynp7DO1Z6NB/Kj1RiNxvV9ee3g1NSVjtqn2rOduq+LMok
         xANF2e6jpcz7rQmTZSinE7GCWWA2FCT23gFDtdZ7SoD1BS9XIFzC39ZMoEiPXzQ0oBVd
         QjRFY+T5HUvu+PMjaCNbMaQTJthim9lbcpU+mF0yP3DUVTqWN6oe+9A0Cc3Z6tBmaeTW
         Y09g==
X-Gm-Message-State: AO0yUKV5PD/Q/Z7tl/t8lHi1LXEVM41aqWSjUeL6YXVdJ3zsuU02K5Vq
        eyA0y4628VyZ7I9Bznbv8as=
X-Google-Smtp-Source: AK7set8tpau27kjKDretfW4tbQZtFglfLd0Zw3mMwaYjvCLpxZWX6npZ54l7yPHHme9tuAcnKnCgcQ==
X-Received: by 2002:a17:903:283:b0:19e:b9f8:1fca with SMTP id j3-20020a170903028300b0019eb9f81fcamr20596720plr.10.1678445646322;
        Fri, 10 Mar 2023 02:54:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ks3-20020a170903084300b0019cbabf127dsm1174167plb.182.2023.03.10.02.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:06 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: x86/pmu: Emulate CTR overflow directly in kvm_pmu_handle_event()
Date:   Fri, 10 Mar 2023 18:53:42 +0800
Message-Id: <20230310105346.12302-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310105346.12302-1-likexu@tencent.com>
References: <20230310105346.12302-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

More and more vPMU emulations are deferred to kvm_pmu_handle_event()
as it reduces the overhead of repeated execution. The reprogram_counter()
is only responsible for creating the required perf_event, and naturally
doesn't include the counter overflow part from emulated instruction events.

Prior to this change, the assignment of pmc->prev_counter always occurred
after pmc was enabled, and to keep the same semantics, pmc->prev_counter
always needed to be reset after it has taken effect.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a1a79b5f49d7..d1c89a6625a0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -418,9 +418,6 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (!event_is_allowed(pmc))
 		goto reprogram_complete;
 
-	if (pmc->counter < pmc->prev_counter)
-		__kvm_perf_overflow(pmc, false);
-
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
@@ -458,6 +455,13 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 reprogram_complete:
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
+}
+
+static inline void kvm_pmu_handle_pmc_overflow(struct kvm_pmc *pmc)
+{
+	if (pmc->counter < pmc->prev_counter)
+		__kvm_perf_overflow(pmc, false);
+
 	pmc->prev_counter = 0;
 }
 
@@ -475,6 +479,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 		}
 
 		reprogram_counter(pmc);
+		kvm_pmu_handle_pmc_overflow(pmc);
 	}
 
 	/*
-- 
2.39.2

