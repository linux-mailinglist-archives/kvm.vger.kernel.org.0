Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89B26170ED
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiKBWwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiKBWv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC9DEC7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368e6c449f2so431047b3.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vNDqVG3Wn+Hqhcho5hUNj1dVoaoItbsTAV/xGKb0Ghc=;
        b=OQoZkzf8HwZAzqfqLGHN+76d9luTDTRf8dZfquU7tau6yi9UVsFTTtv7Euycr006G0
         iFSROOlGXKpkXnq8w+G29umsyW+82Y/Xgujq/VXQ5oP6c/sjpqs4R3RY0FPWgQVXtGgc
         V8MAHofvmmiK8LnWPVT+JYAb4LpjCbziplu/Pw7yULUDjL4ZVKB+MkeHpTnbRg+B9rvy
         e7IWWfg9cnQiQLWEK7h2aCGosioRumoIB1MYkt4fEa8QakgrHHVKVY5MpdAESOZ1ymLP
         1RaadOCtORCSjt32ehXgjUUciVPwgFWXWWr+z4mYa+KwGfTiv3aC77lmO831bPCU7esz
         +h+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vNDqVG3Wn+Hqhcho5hUNj1dVoaoItbsTAV/xGKb0Ghc=;
        b=BipKiRFWNC0pc22XFbJJzCPW4g5qtPQMjtHAbQoMAQ8N2QhVCj+jxLpqAct64zqqQa
         yymGx/KvAsr3OBV7zIu+BHRcSRVB4G1phnVpq72TFLE0VirgPLNe19fZaneOdLoxxp/X
         cqLbq0gFo28ABoz2IseInL40ibi6krrfDTzLJ76Qu7o/L6d9oVw98aTAy4qGvd/4jVWJ
         pfGhl0xwlmv3HBoZiBD6sq8OGULewpxHZSAHZ6uvkEr9lUajLb0oX/fEt5PWyXZJfk33
         sNmsluH6qfK2/yc+GJ4bbiZ1X1vTg6uBoKxUiAPG1zLVqfNUIHpOB7LOoGCcmfQFByyS
         AiNA==
X-Gm-Message-State: ACrzQf3F3IAbWWuiaoc2TwsmfWQM7flWDcZGmb0K/yHDV4qwSTB0kpSR
        KlXtv8C+NM2vI27KJdOeU4df3oKU3r4=
X-Google-Smtp-Source: AMsMyM5OsSK+BjpqIUac72EzHWHOJEpXoxR4DZ89jWEKVj24Sd2JvDEG6KZfpJRD/Fm+E3oG4nGC7vFB8Tk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:be17:0:b0:367:69b4:dce9 with SMTP id
 i23-20020a81be17000000b0036769b4dce9mr189028ywn.482.1667429498988; Wed, 02
 Nov 2022 15:51:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:57 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 14/27] x86: Add a helper for the BSP's final
 init sequence common to all flavors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

Add bsp_rest_init() to dedup bringing up APs and doing SMP initialization
across 32-bit, 64-bit, and EFI flavors of KVM-unit-tests.  The common
bucket will also be used in future to patches to init things that aren't
SMP related and thus don't fit in smp_init(), e.g. PMU setup.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/asm/setup.h |  1 +
 lib/x86/setup.c     | 11 ++++++++---
 x86/cstart.S        |  4 +---
 x86/cstart64.S      |  4 +---
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 8502e7d9..1f384274 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -17,6 +17,7 @@ void setup_5level_page_table(void);
 #endif /* CONFIG_EFI */
 
 void save_id(void);
+void bsp_rest_init(void);
 void ap_start64(void);
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7df0256e..a7b3edbe 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -356,9 +356,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	setup_page_table();
 	enable_apic();
 	save_id();
-	bringup_aps();
-	enable_x2apic();
-	smp_init();
+	bsp_rest_init();
 
 	return EFI_SUCCESS;
 }
@@ -394,3 +392,10 @@ void ap_start64(void)
 	enable_x2apic();
 	ap_online();
 }
+
+void bsp_rest_init(void)
+{
+	bringup_aps();
+	enable_x2apic();
+	smp_init();
+}
diff --git a/x86/cstart.S b/x86/cstart.S
index e82bed7b..ceee58f9 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -112,9 +112,7 @@ start32:
 	call save_id
 	call mask_pic_interrupts
 	call enable_apic
-	call bringup_aps
-	call enable_x2apic
-	call smp_init
+	call bsp_rest_init
         push $__environ
         push $__argv
         push __argc
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 570ed2ed..4dff1102 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -118,9 +118,7 @@ start64:
 	mov %rax, __args(%rip)
 	call __setup_args
 
-	call bringup_aps
-	call enable_x2apic
-	call smp_init
+	call bsp_rest_init
 
 	mov __argc(%rip), %edi
 	lea __argv(%rip), %rsi
-- 
2.38.1.431.g37b22c650d-goog

