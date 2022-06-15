Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3747854D54A
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349950AbiFOXaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349985AbiFOXaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EAB13E88
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:12 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c10-20020a170903234a00b00168b5f7661bso7256115plh.6
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7CwJCbreWYpS4Innbw2RHi3QnMM6ZGfGIsloC5ovSos=;
        b=ngFJDUCwkYmcGXWL5u7McBm+kYib3zYul7iv3T8pMeOZaP6nBszeggDJvUphoagpQi
         hiC4T3fWJAMdCJazapkIjf3FJW0D81eUmWLeRlOnuxj5WJLRV8B9mAleutSyD9Kb694M
         By7jh5o0pOFoPTbiJVEu9r1xODYw/BuyNtfN+x77WW0FnLUjoPAXwr92A1B1x9sJdw/d
         XhBaNVSaeXWHMKx6y06HJVul9hFtMVxeWrvW3yfl87BbbU/UeazGqL2S/2nUFvbD8ZH6
         CKQVVe3qoHYHpTrR0GLkcNIlfkRJV5GSUiWbA4rJiH1cKe1/hnSRZwuoCLXBqbTkOERw
         3u5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7CwJCbreWYpS4Innbw2RHi3QnMM6ZGfGIsloC5ovSos=;
        b=TxRF4LwxmW8Pt4PXMWPpMhAwnhqI1h37HEKsc8Z5YjZAZX0CO6SKLcTzmIiWUg0V3r
         eEznKPOHVkgbluqF3KBhaAonp0lpudt8vUjFWzqEWnvuXp2CsbARDDAEXAIfETt4pLi9
         GzzstTH+J7NAZtmMBP4AwszgvhLPSofwRkIV+YVwHJZiMY2qmZtDLM2eTGPR+dUXuCaS
         XzPvqTnr+pxQVHc/cIqyHE6KeV2Q+p1ao+vf6sVnZhVT9V7YlwN2YTRIoq4gwzmX9A+O
         XWcugx8TxJLhUoXqJjrXhWaIuCW9czHLZE4Etw4l8JkwIpNMD1NSk1NqbF4h7gIjCVKR
         +FZg==
X-Gm-Message-State: AJIora9+igbIUbNSHcfOYgyXmVKGTvR+sHKomXXlssQRBSLqgpzFN1pb
        HO/E7nWVeHrwR/5Y9OwZ9reSfpKH0CU=
X-Google-Smtp-Source: AGRyM1vTkfl+Cwg70VTuKnAf9Q8XuxNNVYz30z8wrJKLw5DHBl+YN0HHXckxjkrtEx9Rl73au1IEpiFm21w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id
 b5-20020a056a00114500b004f63ebca79bmr1853616pfm.41.1655335811546; Wed, 15 Jun
 2022 16:30:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:43 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 13/13] x86: Add ap_online() to consolidate
 final "AP is alive!" code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ap_online() to consolidate the last stage of onlining an AP CPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/setup.c |  9 +--------
 lib/x86/smp.c   | 12 ++++++++++++
 lib/x86/smp.h   |  1 +
 x86/cstart.S    |  8 +++-----
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d9fd9e7..65c0fbf 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -393,12 +393,5 @@ void ap_start64(void)
 	save_id();
 	enable_apic();
 	enable_x2apic();
-	sti();
-	asm volatile ("nop");
-	printf("setup: AP %d online\n", apic_id());
-	atomic_inc(&cpu_online_count);
-
-	/* Only the BSP runs the test's main(), APs are given work via IPIs. */
-	for (;;)
-		asm volatile("hlt");
+	ap_online();
 }
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index dd4eb8c..feaab7a 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -82,6 +82,18 @@ static void setup_smp_id(void *data)
 	this_cpu_write_smp_id(apic_id());
 }
 
+void ap_online(void)
+{
+	irq_enable();
+
+	printf("setup: CPU %d online\n", apic_id());
+	atomic_inc(&cpu_online_count);
+
+	/* Only the BSP runs the test's main(), APs are given work via IPIs. */
+	for (;;)
+		asm volatile("hlt");
+}
+
 static void __on_cpu(int cpu, void (*function)(void *data), void *data, int wait)
 {
 	const u32 ipi_icr = APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR;
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index 3ddc39e..08a440b 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -85,6 +85,7 @@ void on_cpu_async(int cpu, void (*function)(void *data), void *data);
 void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
 void bringup_aps(void);
+void ap_online(void);
 
 extern atomic_t cpu_online_count;
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
diff --git a/x86/cstart.S b/x86/cstart.S
index fdbe343..e82bed7 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -101,12 +101,10 @@ ap_start32:
 	call save_id
 	call enable_apic
 	call enable_x2apic
-	sti
-	nop
-	lock incw cpu_online_count
+	call ap_online
 
-1:	hlt
-	jmp 1b
+	/* ap_online() should never return */
+	ud2
 
 start32:
 	setup_tr_and_percpu
-- 
2.36.1.476.g0c4daa206d-goog

