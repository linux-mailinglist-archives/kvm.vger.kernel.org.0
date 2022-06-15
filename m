Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F254D550
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346410AbiFOXaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348823AbiFOXaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E1713F56
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:10 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id ay37-20020a056a00302500b00522c7c03ec2so1248428pfb.23
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Hji5rLar6hC8nJeVQcxHNe6m4Bfcq2CVcARfc14NcsM=;
        b=HbKtYQwnnFqLxlfjHAASNg8FqRGEmiURIh99On2HLk2CoyaS3n6q70cq2XQ31j6J7g
         4ukN3IwvLr199G1RFIAOWoL306vKoe0cF4jQbII9HtPUumXh+eD5Gu7kVBmuaFOahi0l
         Q5v7scQG11OiuZvja5OZ7TSdtBWDQDWSDoJK9vBMKOjfN5Udp5Bigk8zDrNLUXdRnU/x
         wcekPxnMBxgLp4xCztEXL4uHMoy9fneUgY7iYq1IJng4uO6QBPptPZvgR/fkpuhaY/ZM
         qsmrC65oxERfIbNpaLXEtz0mgIfLw4rDONLP3iLP527k/luEtsTlNyhvEfVBy/G5eUYR
         tfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Hji5rLar6hC8nJeVQcxHNe6m4Bfcq2CVcARfc14NcsM=;
        b=YkCj+5j3PLXrXk2+i1EMfsx5Ech673GORfoiQZDCyumKFqPPiYTRjOGACCNuqhkaRV
         Gk170i2IghECmJrSvldweX1OAPC8tC6hJYZ+BTQtRINUO2fAvOz2XZA8z42PUF1dasQI
         wEAG5BYk/A5M4rcnIuY5IvVTeyCRilHq3IBCIChI8f03+mvPckEr1+cdzDOWAG4A09Zg
         Qc9wgI0f3D1eYFbWuQDAuwECpw36ZZRHSchgOIWfyFTjnaIso0E4dTPWg1+rhQXdrgUA
         Mw83tM+CosKsb3iP9YL639qDIlLqRgpt+EbqamVGQR8AIZUbKH2a5SuEqzutO4VOUbXv
         V11w==
X-Gm-Message-State: AJIora8Le8FoidL5lUd0a4ylLOc2KpE5uxsSENOHF8UV8npHjCu9i2w+
        Z2rhrO6mEfHgP1OzUCHSrhW4nf3TbrI=
X-Google-Smtp-Source: AGRyM1ul6vPtFozMpDxROUHAhbLR/6FgnOSh4v3fnIlEF8Z1PDSgWjoJFxofXPOZ2K+yEyvcKy3IY8uQVTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec2:b0:166:4277:e0c0 with SMTP id
 d2-20020a170902cec200b001664277e0c0mr1900548plg.107.1655335809702; Wed, 15
 Jun 2022 16:30:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:42 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 12/13] x86: Rename ap_init() to bringup_aps()
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

Rename the helper that wakes and waits for APs to bringup_aps(), ap_init()
is terribly confusing because it's called from the BSP, not APs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/setup.c | 2 +-
 lib/x86/smp.c   | 2 +-
 lib/x86/smp.h   | 2 +-
 x86/cstart.S    | 2 +-
 x86/cstart64.S  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 2f60a58..d9fd9e7 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -357,7 +357,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	setup_page_table();
 	enable_apic();
 	save_id();
-	ap_init();
+	bringup_aps();
 	enable_x2apic();
 	smp_init();
 
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index e056181..dd4eb8c 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -242,7 +242,7 @@ static void setup_rm_gdt(void)
 #endif
 }
 
-void ap_init(void)
+void bringup_aps(void)
 {
 	void *rm_trampoline_dst = RM_TRAMPOLINE_ADDR;
 	size_t rm_trampoline_size = (&rm_trampoline_end - &rm_trampoline) + 1;
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index 3a5ad1b..3ddc39e 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -84,7 +84,7 @@ void on_cpu(int cpu, void (*function)(void *data), void *data);
 void on_cpu_async(int cpu, void (*function)(void *data), void *data);
 void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
-void ap_init(void);
+void bringup_aps(void);
 
 extern atomic_t cpu_online_count;
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
diff --git a/x86/cstart.S b/x86/cstart.S
index 0707985..fdbe343 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -114,7 +114,7 @@ start32:
 	call save_id
 	call mask_pic_interrupts
 	call enable_apic
-	call ap_init
+	call bringup_aps
 	call enable_x2apic
 	call smp_init
         push $__environ
diff --git a/x86/cstart64.S b/x86/cstart64.S
index e44d46c..80b3552 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -118,7 +118,7 @@ start64:
 	mov %rax, __args(%rip)
 	call __setup_args
 
-	call ap_init
+	call bringup_aps
 	call enable_x2apic
 	call smp_init
 
-- 
2.36.1.476.g0c4daa206d-goog

