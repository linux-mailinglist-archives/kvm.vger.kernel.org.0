Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037915F1803
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiJABOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiJABNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE25FAF7
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-354262a27c8so57324577b3.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=OIejMZ1lDR6t5oXpG/Ccmc1XCYg+2ZD4LOTMaLAWyN4=;
        b=r3iHqPx7SCNGjuDxnCOKZfxUPbwttRJE8A2MUGTbJBuUlHSExYKeqABAFR+DZQxUfg
         /IDPb0MA7W7ydTSx5IzPSiDJE8KNiE8UpwVy39snLoHnt2zwc7FaL+7JgjInCXtPcC7f
         E8y1lmzE/f3tk3kSYYUYTd7ApS2acQsaRYZu0gPQUbWK6VBnsbILkTbsMyUvUSHBG8h4
         RDggcJ/jE+xt2S71oeKH+J5dsWVgEldreLL9OoNLSiMeRzCIZSNECShGSRBbtnrihhdq
         ePHInO17l8iFImbCjLh10alVhRuc91UWCjIDHVu118qJlcDL7ciaY2Jc6Z/FnZjYB/Wp
         UUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=OIejMZ1lDR6t5oXpG/Ccmc1XCYg+2ZD4LOTMaLAWyN4=;
        b=lUNvuwgapAQ4pdZveVh5amk8P7ZJ/vOD6Cgw7vvcM8GlYbwV4k1Q5guuiFGEF2jk/R
         /3jc01SytGgLEyJ/xNjlwMemTpGah1wjFh/rpDrcYlIRMTdfksx/e8If/9eCVC+KpA0y
         K7DNfhn/Qy5tnu+dz3NyXpSllXZIh3M3gH3UXmaNfEak+QeN247a8q+ipEPTVQvGDzln
         CcQNl/V66VI0k3tzNIQ9gJXXCBwxiS4T2fzd0J7DAYuwgPZUooTpsBTOaI1lsg3WHQRh
         4LkZQOw3PvbhvW07y2pMXNenFHOTq8EdHecw2rojEkxbWRLZqfRuJZOBXdRpGQ6ud01A
         WYmw==
X-Gm-Message-State: ACrzQf3AFrkOZz7o7Li+APbkYM7yPzaUoIGo+3jUOQvLXmYv8GqxQq2+
        dWdAQqnNcGXYOFI2IdFy+keXTt01DVg=
X-Google-Smtp-Source: AMsMyM71rqAVeHh0gm0/Bj+tj/iP0jTGYAAhETQFPMzIpzyRoNkE1DNua27+eHgpUcp654SpJpOEhy2nMTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:70d4:0:b0:355:4148:f041 with SMTP id
 l203-20020a8170d4000000b003554148f041mr9529605ywc.499.1664586793194; Fri, 30
 Sep 2022 18:13:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:58 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 6/9] x86/apic: Enable IRQs on vCPU0 for all tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Enable IRQs on vCPU0 for all APIC sub-tests.  Many sub-tests want to
generate interrupts, and leaving IRQs disabled makes writing a new test
unnecessarily frustrating (guess who forgot to enable IRQs...).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index e466a57..3c00137 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -53,7 +53,6 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
 static void __test_tsc_deadline_timer(void)
 {
 	handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
-	irq_enable();
 
 	wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
 	asm volatile ("nop");
@@ -272,7 +271,6 @@ static void __test_self_ipi(void)
 	int vec = 0xf1;
 
 	handle_irq(vec, self_ipi_isr);
-	irq_enable();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | vec,
 		       id_map[0]);
 
@@ -485,7 +483,6 @@ static void test_apic_timer_one_shot(void)
 #define APIC_LVT_TIMER_VECTOR    (0xee)
 
 	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
-	irq_enable();
 
 	/* One shot mode */
 	apic_write(APIC_LVTT, APIC_LVT_TIMER_ONESHOT |
@@ -705,6 +702,7 @@ int main(void)
 	setup_vm();
 
 	mask_pic_interrupts();
+	irq_enable();
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		tests[i]();
-- 
2.38.0.rc1.362.ged0d419d3c-goog

