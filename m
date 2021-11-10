Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01944CB3C
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhKJVXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhKJVXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:06 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFFAC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:18 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id h35-20020a63f923000000b002d5262fdfc4so2153500pgi.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tB0hEKl2XjIx6N/+c64vQcumEGJO93RbM+u3u7eeD5U=;
        b=ZTMvjjof9Ln7Tjrwi7BesRN7JflnzlG16No0XkguMhGW4aRB1N0bXcPzz5WOgsXusu
         5TcU0/h303+fkdK+dDkNLpR0kzVIhAXMt+evlOnG2vwiQrDvX1RWUr5rGLs6a22cwJSi
         /AB1Q88Up2uFfnp2zIElcPCChnGo1YjUVTj5VC6WiAL6C/TTy7cnbO/qNt9td3Eb1KtH
         KOjRFPZBlSQ0TNgxx7DVvCXp9lNzpTkUoW0nMys2+pK8zFo36TND3EQf9HBsOycEYgSp
         4FuuuN4AlJpF9fx86TGeAMFxYpNo+JdDUlD8//xhHLn94/Z4EwTC5yLEA84QNxgLWIW2
         Xfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tB0hEKl2XjIx6N/+c64vQcumEGJO93RbM+u3u7eeD5U=;
        b=SUt9V57coIUEq0T3ENJqGs8SGSvhRY8sHLD6lpUvE8oLv9GQmANWJd/bj5gAWPp2Bh
         tzSyShf40+uK+x2ARTalso/XRJ8doBRqLIlPxY1M37TNPlKbySFQBneSBGCSxhbhH8DK
         pko5sO8XxKDfftDCdV3z47biu0OfICVq9vf7CrDdLeQ2NM9v4J0S5ascvchIBsBK/m6Q
         62MIzPfvqU4HQ/GV/2wDXHuMiAu30LoRukbeluSEC+W4R0zXAXDsUddxX94e/ZCcsYtV
         QhzfR9akxZIJFnalH7OH4Uiay/43BP5nA3E5WCJK3/R9qVSstFP/dA8JhFwIX9dB+eeh
         NV6g==
X-Gm-Message-State: AOAM530KpBhdKf4DNv86zLkRL3uJ2i/ixGmZQGGb5f+5Mlkw6dQ0CgQO
        hCMs0DnDdbbV3Ly4BeqeDhK5l2Olz+YwC66C7jaOGFjEJcSBQ3+M1P2KFzbmFlccH8gT/uNs4AY
        O4mYeotLov/M1dADveURWjYF3JnMnINHluMHe+pRinEAa2LoBey3YdAUK6t6JtrwvlxqI
X-Google-Smtp-Source: ABdhPJxOz5ateHVUv4Cqfh5Whz40Y1h8XmYkEZ/eiXhe8hVREB0cRtIt1/DFTskfJQ29070OjniLOaDekF/eONb0
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:1110:b0:13f:d1d7:fb5f with SMTP
 id n16-20020a170903111000b0013fd1d7fb5fmr2045580plh.6.1636579217579; Wed, 10
 Nov 2021 13:20:17 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:52 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 05/14] x86: Move IDT to desc.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the IDT data structures from x86/cstart.S and x86/cstart64.S to
lib/x86/desc.c, so that the follow-up UEFI support commits can reuse
these definitions, without re-defining them in UEFI's boot up assembly
code.

Extracted by a patch by Zixuan Wang <zxwang42@gmail.com> and ported
to 32-bit too.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c | 10 ++++++++++
 x86/cstart.S   | 11 -----------
 x86/cstart64.S | 14 --------------
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 94f0ddb..2ef5aad 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -3,6 +3,16 @@
 #include "processor.h"
 #include <setjmp.h>
 
+/* Boot-related data structures */
+
+/* IDT and IDT descriptor */
+idt_entry_t boot_idt[256] = {0};
+
+struct descriptor_table_ptr idt_descr = {
+	.limit = sizeof(boot_idt) - 1,
+	.base = (unsigned long)boot_idt,
+};
+
 #ifndef __x86_64__
 __attribute__((regparm(1)))
 #endif
diff --git a/x86/cstart.S b/x86/cstart.S
index bcf7218..4461c38 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -1,7 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl boot_idt
 .global online_cpus
 
 ipi_vector = 0x20
@@ -28,12 +27,6 @@ i = 0
         i = i + 1
         .endr
 
-boot_idt:
-	.rept 256
-	.quad 0
-	.endr
-end_boot_idt:
-
 .globl gdt32
 gdt32:
 	.quad 0
@@ -78,10 +71,6 @@ tss:
         .endr
 tss_end:
 
-idt_descr:
-	.word end_boot_idt - boot_idt - 1
-	.long boot_idt
-
 .section .init
 
 .code32
diff --git a/x86/cstart64.S b/x86/cstart64.S
index cf38bae..b98a0d3 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,9 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl boot_idt
-
-.globl idt_descr
 .globl gdt64_desc
 .globl online_cpus
 .globl cpu_online_count
@@ -50,13 +47,6 @@ ptl5:
 
 .align 4096
 
-boot_idt:
-	.rept 256
-	.quad 0
-	.quad 0
-	.endr
-end_boot_idt:
-
 gdt64_desc:
 	.word gdt64_end - gdt64 - 1
 	.quad gdt64
@@ -290,10 +280,6 @@ setup_5level_page_table:
 lvl5:
 	retq
 
-idt_descr:
-	.word end_boot_idt - boot_idt - 1
-	.quad boot_idt
-
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

