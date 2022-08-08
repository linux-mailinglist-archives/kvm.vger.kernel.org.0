Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27A858CC57
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiHHQrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbiHHQrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B46B13F85
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p8-20020a63e648000000b0041d8ca4939dso1010893pgj.8
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ESRtOl/PFPrPJMlMbMpUz4WH8ydEni6gyWl+42u6F8g=;
        b=tBk9PygMyHusbykohQuAbJdP9jUwhn8Kvj78IOntbsBNMSm7W2PDpbgaEs1Pccap25
         YYR39QMBWERiDVTNvEZGZeiAfEpF1MgMYIPu90aFtBFt821yAwruGmnC9fWE2AMlcQrW
         pLhSBlh6lt7EmTXee5DQ90IKYazFFhYv5Z/0Ojid26wr6l+PiQkLJethq8U/rPJNbd9g
         SYD3O3AmZiwymp8C9CNkfrYdHJhXU5XKwSkqGqeCWZNkEs/CDgJjU5hJNNCZzHi/x+kx
         C3u6EOnd/asIAZJsFj0gEZT+C9RTJanlwerMmMVRn+khM8Dnnybktw4G7WTslGpr6d7Y
         VzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ESRtOl/PFPrPJMlMbMpUz4WH8ydEni6gyWl+42u6F8g=;
        b=v8Pi19Kxmou/4jzt6rJywNfss7A33hawWJh8celQsFS3G1tmbF71brNK70MVGsTOil
         LNKVd6PGdE70r8IaeTdmhKdHQd63WwHPWbxbCiwGqcDKwUJTGrkE5yQm9NsGlKHThFTR
         qOvvKjoQ9m6frUfLZVMImie9UPhCxiZCXcADBGSn9S4quxrG1hGZiy2yANEgsR9F2Ibu
         hzYSv91iQYoyzpJNBO5L1cQ2imNidoZB0qoIuZz37M+fLm6KeuHY0q9KuApQMGQhUOdy
         H68Mlj4C+JhdqxZUFTv7GNOqrHHtyp3PeaSGyRzdj85CIWtM1GPpVfOKe34qelT5S/nk
         d8+A==
X-Gm-Message-State: ACgBeo3LEpv2dV/JNE+8FteRxFmx6GpPl/M8jnO6iYLadujA7sddZNYv
        6GTHi7U1IT6ffVAeu5wmTwpRWa5RE4A=
X-Google-Smtp-Source: AA6agR5uoVEOMo5cTjayCLC+mnJpHL3rP7ADVqOV+P/bzannnpLEjhYLPS7mwmipPsZ41RS06XajiBhinkQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9157:0:b0:52f:20d6:e4f6 with SMTP id
 23-20020aa79157000000b0052f20d6e4f6mr8049637pfi.40.1659977235193; Mon, 08 Aug
 2022 09:47:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:03 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 3/7] x86: Introduce ASM_TRY_FEP() to handle
 exceptions on forced emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

From: Michal Luczaj <mhal@rbox.co>

Introduce ASM_TRY_FEP() to allow using the try-catch method to handle
exceptions that occur on forced emulation.  ASM_TRY() mishandles
exceptions thrown by the forced-emulation-triggered emulator. While the
faulting address stored in the exception table points at forced emulation
prefix, when an exceptions comes, RIP is 5 bytes (size of KVM_FEP) ahead
due to KVM advancing RIP to skip the prefix and the exception ends up
unhandled.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h | 13 ++++++++++---
 x86/emulator.c |  1 -
 x86/pmu.c      |  1 -
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 10ba8cb..8f708fd 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -92,13 +92,20 @@ typedef struct  __attribute__((packed)) {
 	u16 iomap_base;
 } tss64_t;
 
-#define ASM_TRY(catch)						\
-	"movl $0, %%gs:4 \n\t"					\
-	".pushsection .data.ex \n\t"				\
+#define __ASM_TRY(prefix, catch)				\
+	"movl $0, %%gs:4\n\t"					\
+	".pushsection .data.ex\n\t"				\
 	__ASM_SEL(.long, .quad) " 1111f,  " catch "\n\t"	\
 	".popsection \n\t"					\
+	prefix "\n\t"						\
 	"1111:"
 
+#define ASM_TRY(catch) __ASM_TRY("", catch)
+
+/* Forced emulation prefix, used to invoke the emulator unconditionally. */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define ASM_TRY_FEP(catch) __ASM_TRY(KVM_FEP, catch)
+
 /*
  * selector     32-bit                        64-bit
  * 0x00         NULL descriptor               NULL descriptor
diff --git a/x86/emulator.c b/x86/emulator.c
index 769a049..6dc88f1 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -18,7 +18,6 @@
 static int exceptions;
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally.  */
-#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define KVM_FEP_LENGTH 5
 static int fep_available = 1;
 
diff --git a/x86/pmu.c b/x86/pmu.c
index 01be1e9..457c5b9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -33,7 +33,6 @@
 
 #define N 1000000
 
-#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 // These values match the number of instructions and branches in the
 // assembly block in check_emulated_instr().
 #define EXPECTED_INSTR 17
-- 
2.37.1.559.g78731f0fdb-goog

