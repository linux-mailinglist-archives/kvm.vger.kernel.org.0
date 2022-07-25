Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965C5580552
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 22:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiGYUPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 16:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237126AbiGYUOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 16:14:50 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E48122B21
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:41 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s5-20020a17090a6e4500b001f25fb86516so2552757pjm.5
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yTSMINSAGLeRbYcxbuCirWnBX4rTdLH3q5UUnzFrRNw=;
        b=DawTGenuC+BZwAu62Gvsz1q/CG81tzes03ZUWZ8f1iG5AzzS632/8lWfZOB0HaaKIH
         U2/3Maq22l5b78j+pDDaJxmj1JZHRuz6m0GVA6/r0SsERVEe2trhIuha0NddU0b8U9ek
         TXfJXLgrb9fcKMH4Z8xJSiHFRaVjyTJCO1HwCHXbzlYbNXU1Q1LepY4DtYIX22wHc9MK
         IIYBYN0CaXGbXZEN9mkYAl14oJIOVsntj76RfZIlvNVJ7C317irs/MRes8CQPw3nxI/1
         f5dMIgjpXVbMzm4EE3+Uk8xZIA2AbquyJiLiuDX3uHctZ8leq2ndv+Uvd3NVJMVxtVWb
         4QZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yTSMINSAGLeRbYcxbuCirWnBX4rTdLH3q5UUnzFrRNw=;
        b=jnwxXbtVGpvOqLOb1LKbOozAW26qmKbUFG+e9V2d8bKpf0AWqQ0sO6dSkyd9o971cP
         APg/+2Ot0lcFBsrh8xvg8cIOtg1Ocp1J5cReMZ357kAz5VPNImV9VkcJTMkKvZcnvs0W
         PBIZWUiGXQrWAkd8hlJEbQONqG8Sds/kMo9SwoVoHZJ2zGCmBUH8QEQcdmT73ylOmV8B
         R1x1LrEdZhctQge4Y0fhaOUimk62e8hOOSm759hxn05BsXA8iBMJ4Yf5E89bEHg5VP9J
         MGssBu1NgvS+VhHf0OMzasIjjEJnENtZj2FLup+LSNeG3W1OuQFhavscC2V0uFgyPE9L
         t+Qw==
X-Gm-Message-State: AJIora8RC3nQ1E3Ylowqirtqv3z5Y4BhgdwmxoKcTkrN3jMJCb9e6Dz3
        P2ccax1dbQSpvmpzvgHeJfJ3JlHfnnQ=
X-Google-Smtp-Source: AGRyM1sunQTwpr85m9usBgVJdMGnK+z8TY+Wu9BiJbPsW/KglLzL0wC4POoU1nan17xtgdEm5x06oO54HF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:301f:b0:52a:ccdd:17f9 with SMTP id
 ay31-20020a056a00301f00b0052accdd17f9mr14183583pfb.82.1658780020783; Mon, 25
 Jul 2022 13:13:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 25 Jul 2022 20:13:35 +0000
In-Reply-To: <20220725201336.2158604-1-seanjc@google.com>
Message-Id: <20220725201336.2158604-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220725201336.2158604-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: apic: Play nice with x2APIC being
 enabled when getting "pre-boot" ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Retrieve the "pre-boot" APIC ID via the x2APIC interface if x2APIC is
enabled instead of assuming that the APIC is always in xAPIC mode.   EFI
has a catch-22 where it needs the APID ID to initialize the per-vCPU
GS.base, but calling reset_apic() = >disable_apic() needs GS.base to be
correctly initialized in order to set the correct APIC ops.  Play nice
with either xAPIC or x2APIC so that EFI can be used for SMP tests, in
particular the SVM INIT-SIPI tests which send APs back through the boot
sequence while x2APIC is enabled.

Alternatively, disabling x2APIC and updating the APIC ops could be split,
but there's no obvious advantage in doing so.  Retrieving the pre-boot
APIC ID isn't a hot path, i.e. the cost of the RDMSR is likely negligible,
and letting callers force xAPIC without updating the ops isn't any less
fragile.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 5d4c776..eed93fa 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -56,11 +56,6 @@ static uint32_t xapic_id(void)
 	return xapic_read(APIC_ID) >> 24;
 }
 
-uint32_t pre_boot_apic_id(void)
-{
-	return xapic_id();
-}
-
 static const struct apic_ops xapic_ops = {
 	.reg_read = xapic_read,
 	.reg_write = xapic_write,
@@ -165,6 +160,15 @@ int enable_x2apic(void)
 	}
 }
 
+uint32_t pre_boot_apic_id(void)
+{
+	u32 msr_lo, msr_hi;
+
+	asm ("rdmsr" : "=a"(msr_lo), "=d"(msr_hi) : "c"(MSR_IA32_APICBASE));
+
+	return (msr_lo & APIC_EXTD) ? x2apic_id() : xapic_id();
+}
+
 void disable_apic(void)
 {
 	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) & ~(APIC_EN | APIC_EXTD));
-- 
2.37.1.359.gd136c6c3e2-goog

