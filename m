Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468FA4C5413
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 07:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiBZGB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 01:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBZGBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 01:01:25 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078342B3246
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 22:00:52 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id ay5so3676915plb.1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 22:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ws3FkWECbhJWqTHycYGB/6y0W+j/K26F4CyULMS/598=;
        b=Hn/h4++pAUKtffwAT2nlFNiLUZAemunHc1T7m9zPG1cEQ3OOTCywjf0FqhFXaDZ9GF
         WmwUpRTozYsvfMm1K7JueOrRxv8monSym9OdVL+U7Hy83MHE//nyli5OqpqNFURCfk34
         vTl56+xdOiFm2CnAxYS01Bfnh205Eu9IKdjtj9hWLN8JAmtbusLj4jWoYVgcV/fpPEyV
         aCJyUPPlkRn5BsV6VBgW7RAvPfdUWDl1W14Sd/6d23pdT0z1SrE5D1+3jDqM61tG65YW
         0yat1Skf9Vd1mcUz7D6Sy0cDA8y9qSNXsPS9z4jry/skegfTCfSoXKBpTJUg0OzNixt7
         bvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ws3FkWECbhJWqTHycYGB/6y0W+j/K26F4CyULMS/598=;
        b=55GM0aoxrq326Icyh3cHt/ed0AcrDkN6l8n4NrYHl1ZW0+DPLOMlMwVd0EL00giCGT
         PGJYiHY9riu81s9GuBEEPVM/0wS3jKjup75GHNF0ma+pt6m4k3fyazipj8VFaGUQKVos
         VQIYjEy/Upw5v3iPYf08YKM03FuIiX/GH6kofBf7zCONxae2/0CacKdEmqAo0l3i3K2m
         Qiwub0b+Vk3F3cIdYELdc1Gn7246iX1qIWpzq0yrEFH/eVPVZ/9JdG6Siw7XAOgafAAq
         oNE/0KOuLGEnMJX5Z6Gbpqf4x4n6YNfkr7DIaiSuB0KzR7boe6OM0ULi1vKUq/SjYteR
         iO5w==
X-Gm-Message-State: AOAM530UwPabwQ6Tu1BqfpIMaVG9n8fnR5HxyXkgt70sZKZjjYgc92Q4
        lifSZp07o/GW49Hq6HiYs9Zm3o+Hl6lQNhOK
X-Google-Smtp-Source: ABdhPJy603a6shRy2cUU/JE+hshFQWDkkpswwoQYtN0JHQ6jQ0hxvzTNvCLBjc7SkF8FNt2gv0ydTA==
X-Received: by 2002:a17:902:db0b:b0:150:2a0:189c with SMTP id m11-20020a170902db0b00b0015002a0189cmr10518200plx.128.1645855251341;
        Fri, 25 Feb 2022 22:00:51 -0800 (PST)
Received: from localhost.localdomain ([103.149.162.121])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm4297142pgj.85.2022.02.25.22.00.50
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 22:00:51 -0800 (PST)
From:   Dongli Si <sidongli1997@gmail.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvmtool] x86: Fixed Unable to execute init process since glibc version 2.33
Date:   Sat, 26 Feb 2022 14:00:48 +0800
Message-Id: <20220226060048.3-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongli Si <sidongli1997@gmail.com>

glibc detected invalid CPU Vendor name will cause an error:

[    0.450127] Run /sbin/init as init process
/lib64/libc.so.6: CPU ISA level is lower than required
[    0.451931] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00
[    0.452117] CPU: 0 PID: 1 Comm: init Not tainted 5.17.0-rc1 #72

Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/cpuid.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index c3b67d9..d58a027 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -2,6 +2,7 @@
 
 #include "kvm/kvm.h"
 #include "kvm/util.h"
+#include "kvm/cpufeature.h"
 
 #include <sys/ioctl.h>
 #include <stdlib.h>
@@ -10,7 +11,7 @@
 
 static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
 {
-	unsigned int signature[3];
+	struct cpuid_regs regs;
 	unsigned int i;
 
 	/*
@@ -22,10 +23,13 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
 		switch (entry->function) {
 		case 0:
 			/* Vendor name */
-			memcpy(signature, "LKVMLKVMLKVM", 12);
-			entry->ebx = signature[0];
-			entry->ecx = signature[1];
-			entry->edx = signature[2];
+			regs = (struct cpuid_regs) {
+				.eax		= 0x00,
+			};
+			host_cpuid(&regs);
+			entry->ebx = regs.ebx;
+			entry->ecx = regs.ecx;
+			entry->edx = regs.edx;
 			break;
 		case 1:
 			/* Set X86_FEATURE_HYPERVISOR */
-- 
2.32.0

