Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D076809AF
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbjA3JiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbjA3Jhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:37:47 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D94591166A;
        Mon, 30 Jan 2023 01:37:19 -0800 (PST)
Received: from cap.home.8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 5CFF8223E53;
        Mon, 30 Jan 2023 10:37:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1675071438;
        bh=+oAA9MfHhwDJC0rP2bpO4Xv2wTnRt8z2HxFngauyjCI=;
        h=From:To:Cc:Subject:Date:From;
        b=xlgWJyHOEx2dz8S8NCfvVRYSsLU12EjLQS1F4GnQaAWhCn/T/JaIb7Y+ACWSjb3+a
         3YxbhOY1LN/A2n/XjN4VqYwlDE5sQ6PcFBFX0cUZNTfjk5Y/wQDk8phK2g9Jccp2X7
         /PlMPXhi/cBzE8d6+5oIIWv5ELmGhh45CaoEro7rD5+6U+64EOAS8hkdiZcMK+Lfb/
         +wcJsHxfnl3HAa5vegjVJ6q3Tg8yM9SRubdYgsWccoP8QZ1l2teUty5YkbJPAvrsdj
         PCXSi0OSjlc9Y0SxTYDHUphqrEH1ct1RPZJlxic2zVNbbwcZm+n03OjUoaVmWWe0if
         QfTGmNSvVCPSA==
From:   Joerg Roedel <joro@8bytes.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     x86@kernel.org, hpa@zytor.com,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH] x86/debug: Fix stack recursion caused by DR7 accesses
Date:   Mon, 30 Jan 2023 10:37:17 +0100
Message-Id: <20230130093717.460-1-joro@8bytes.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

In kernels compiled with CONFIG_PARAVIRT=n the compiler re-orders the
DR7 read in exc_nmi() to happen before the call to sev_es_ist_enter().

This is problematic when running as an SEV-ES guest because in this
environemnt the DR7 read might cause a #VC exception, and taking #VC
exceptions is not safe in exc_nmi() before sev_es_ist_enter() has run.

The result is stack recursion if the NMI was caused on the #VC IST
stack, because a subsequent #VC exception in the NMI handler will
overwrite the stack frame of the interrupted #VC handler.

As there are no compiler barriers affecting the ordering of DR7
reads/writes, make the accesses to this register volatile, forbidding
the compiler to re-order them.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/debugreg.h | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d950612f..eb6238a5f60c 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -39,7 +39,18 @@ static __always_inline unsigned long native_get_debugreg(int regno)
 		asm("mov %%db6, %0" :"=r" (val));
 		break;
 	case 7:
-		asm("mov %%db7, %0" :"=r" (val));
+		/*
+		 * Make DR7 reads volatile to forbid re-ordering them with other
+		 * code. This is needed because a DR7 access can cause a #VC
+		 * exception when running under SEV-ES. But taking a #VC
+		 * exception is not safe at everywhere in the code-flow and
+		 * re-ordering might place the access into an unsafe place.
+		 *
+		 * This happened in the NMI handler, where the DR7 read was
+		 * re-ordered to happen before the call to sev_es_ist_enter(),
+		 * causing stack recursion.
+		 */
+		asm volatile ("mov %%db7, %0" : "=r" (val));
 		break;
 	default:
 		BUG();
@@ -66,7 +77,21 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 		asm("mov %0, %%db6"	::"r" (value));
 		break;
 	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
+		/*
+		 * Make DR7 writes volatile to forbid re-ordering them with
+		 * other code. This is needed because a DR7 access can cause a
+		 * #VC exception when running under SEV-ES.  But taking a #VC
+		 * exception is not safe at everywhere in the code-flow and
+		 * re-ordering might place the access into an unsafe place.
+		 *
+		 * This happened in the NMI handler, where the DR7 read was
+		 * re-ordered to happen before the call to sev_es_ist_enter(),
+		 * causing stack recursion.
+		 *
+		 * While is didn't happen with a DR7 write, add the volatile
+		 * here too to avoid similar problems in the future.
+		 */
+		asm volatile ("mov %0, %%db7"	::"r" (value));
 		break;
 	default:
 		BUG();
-- 
2.39.0

