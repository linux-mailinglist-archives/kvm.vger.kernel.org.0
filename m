Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8229962D65F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbiKQJUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiKQJUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:20:17 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4690697C8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:16 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r126-20020a632b84000000b004393806c06eso974674pgr.4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OEx+CtOxCtFheca0DI/d6/tJ93MBH7oPBlG+gTxiGA4=;
        b=ENCG4/PPyCTTlvAP8/VyEdFS80a8xiXXguEJ7wHCnyRlMxTM8phDEWgT++FSJpxysA
         sN3LmSWFj6lCQH78NHqSyRgOutMSV8omm3Q1x9RdHr56D6VNwXBl4cE+TA1lTgrQDg6D
         aEGPTHOOXqOAhcAUAegi031fbcF4VRgPwyVxeCTw+DgqpAhlpz3a+8yUANx/qU5qGB4u
         te21Gq8YzYKdb2hPwSdsa8YWU2I5Zlww6SboDUzeL2YiX7OxmdSfGHPHB3CXEwORcGCc
         Ea9UC7sIwbzJjFyRVeg2BP7Nj3aA0SGPlzLjaWpsD6COfohnu9+IXAA8qUf+zQAMkzrN
         I43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OEx+CtOxCtFheca0DI/d6/tJ93MBH7oPBlG+gTxiGA4=;
        b=TVIlzUqVLyhD4g/YNolv1EzCmVVs+zMFPajpjU2tsi6OtevIpUsBXjCmUgUX7ZPQTb
         jQ4ZuB1s5Jq8o4/v1L0HwNbYUcUpBc3ru+eoYJlF7uUH7iHQ4EUPwSGjIer+hZnchH1i
         Wou6zn6W709Fa2zLqMG8PRGZE5boQHWX8NqvYyrOQugpw/uMtpBclwST+Bg7iD33TbzX
         n5uypTdylTWrlBh16u1nmEdkPvdu8bW0pPga31sYaF+IKwfCHn17RWP5puxmXlr0da/O
         PTzQNyEWcmkMd9ZAnw9iuLnEDBnlg2QndVcKB04MWXMQPa+TIWgrwUH8StmGNfxZXf3E
         j4mg==
X-Gm-Message-State: ANoB5pkeSjMEbSqHuc1LgxXviUUdSCw+zWkToUa+w+pJ9s1EeA9RtY4R
        lIEtF2Bh0V4y54zS6tDkglQpFdZD6FGlLg==
X-Google-Smtp-Source: AA0mqf4oKQpzv5V9BsRFY4Sy+mT84cxEiqYkBnBUagxZydB6+8JlVo3jEw02xIpFF2PVVjgOGfzVdiF7VEDjqg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:902:eb92:b0:186:5f86:da41 with SMTP
 id q18-20020a170902eb9200b001865f86da41mr1944674plg.73.1668676816121; Thu, 17
 Nov 2022 01:20:16 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:22 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-5-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 04/34] x86/cpufeature: Fix various quality problems in
 the <asm/cpu_device_hd.h> header
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Thomas noticed that the new arch/x86/include/asm/cpu_device_id.h header is
a train-wreck that didn't incorporate review feedback like not using __u8
in kernel-only headers.

While at it also fix all the *other* problems this header has:

 - Use canonical names for the header guards. It's inexplicable why a non-standard
   guard was used.

 - Don't define the header guard to 1. Plus annotate the closing #endif as done
   absolutely every other header. Again, an inexplicable source of noise.

 - Move the kernel API calls provided by this header next to each other, there's
   absolutely no reason to have them spread apart in the header.

 - Align the INTEL_CPU_DESC() macro initializations vertically, this is easier to
   read and it's also the canonical style.

 - Actually name the macro arguments properly: instead of 'mod, step, rev',
   spell out 'model, stepping, revision' - it's not like we have a lack of
   characters in this header.

 - Actually make arguments macro-safe - again it's inexplicable why it wasn't
   done properly to begin with.

Quite amazing how many problems a 41 lines header can contain.

This kind of code quality is unacceptable, and it slipped through the
review net of 2 developers and 2 maintainers, including myself, until
Thomas noticed it. :-/

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpu_device_id.h | 31 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 3417110574c1..31c379c1da41 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CPU_DEVICE_ID
-#define _CPU_DEVICE_ID 1
+#ifndef _ASM_X86_CPU_DEVICE_ID
+#define _ASM_X86_CPU_DEVICE_ID
 
 /*
  * Declare drivers belonging to specific x86 CPUs
@@ -9,8 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
-
 /*
  * Match specific microcode revisions.
  *
@@ -22,21 +20,22 @@ extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
  */
 
 struct x86_cpu_desc {
-	__u8	x86_family;
-	__u8	x86_vendor;
-	__u8	x86_model;
-	__u8	x86_stepping;
-	__u32	x86_microcode_rev;
+	u8	x86_family;
+	u8	x86_vendor;
+	u8	x86_model;
+	u8	x86_stepping;
+	u32	x86_microcode_rev;
 };
 
-#define INTEL_CPU_DESC(mod, step, rev) {			\
-	.x86_family = 6,					\
-	.x86_vendor = X86_VENDOR_INTEL,				\
-	.x86_model = mod,					\
-	.x86_stepping = step,					\
-	.x86_microcode_rev = rev,				\
+#define INTEL_CPU_DESC(model, stepping, revision) {		\
+	.x86_family		= 6,				\
+	.x86_vendor		= X86_VENDOR_INTEL,		\
+	.x86_model		= (model),			\
+	.x86_stepping		= (stepping),			\
+	.x86_microcode_rev	= (revision),			\
 }
 
+extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
-#endif
+#endif /* _ASM_X86_CPU_DEVICE_ID */
-- 
2.38.1.431.g37b22c650d-goog

