Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E784944A4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357795AbiATA3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiATA3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C43C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id c9-20020a17090a8d0900b001b492630839so4973930pjo.0
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=X+D0F7r/0QGpU6311kvR8lHu9GmD3JTKgcWk10yuZeM=;
        b=RAFnOsHKAzm9aKmrMn+U3SUwIPoONsaRifssMzvttOJ/JevKGsth63tcBYZqfnBlNn
         +hMGyFXea0w57CETicPLMtiEdK7r5k3axPMxmELppa2Kwv1XErXpfOpzQIhd6FLa7GKV
         Nj1ITWjeHaaDqFLu0jKH+F+2J0kfnZwvzjd01CQOxm4GYt3ztkWAIR7Fji79rlBR8Tb6
         PrkrDMKhCkUtBO/JvLMhzG0zC4pI11fyrm9BK/cipiN5G+tFi/hPDWb0CbRnWJo2j6eG
         TCC5dWANC7ef20tcbWSbZXQuewqzrQDJW0OGmKLzu8LuKvRmBkipG8O7iwAkpmA0aHYR
         lLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=X+D0F7r/0QGpU6311kvR8lHu9GmD3JTKgcWk10yuZeM=;
        b=APNOn5bCwrzpOtprBYGsr79PPC99lKr8EWXVQMsJZND+qpVG9XqZ7anSVH2+ZuOGpl
         spvhx4iv1rYocO6ZOOnMWrWs5SbtRot8rF39CMEcG6DSZNZ4ftx5FOLvyWexoFzo1hEA
         wJHg4qMrsaAAu3i9rOYOrEXWjYLopu+iK8pRsgHqdl+VplGuVa2ruXfxbCed4QKL5ogD
         Lw7w+mWXUAiQhCc1L3uxbd81hSFk7dO9uDGxtNAaQrM5EJxTFBD9jwFDbnuxQTL1SVjF
         TgiHGJQJ1MnmwjkpPcFDFn89wJKgDhxedQynA+ov0G1u0bc2lUJCPIVTodNS9Fxopic0
         gQAw==
X-Gm-Message-State: AOAM5323pP7Uzjwe+74mMoH7A2gpL49kpg5L1GIe13qOSlgGn+CXdT8l
        XyytRolO0cmLptdQFFHN5cj151W+3H8=
X-Google-Smtp-Source: ABdhPJyyl67B2nDuokLD5zXqVA7+UsGMReDAhMd+kXY13REQhq5i7cgs7vd5OdqvV3JyudXHNRXgssTQcp8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2306:b0:4c2:83c6:8b8d with SMTP id
 h6-20020a056a00230600b004c283c68b8dmr27327363pfh.65.1642638570913; Wed, 19
 Jan 2022 16:29:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:19 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 3/7] x86/debug: Test OUT instead of RDMSR for
 single-step #DB emulation test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace RDMSR with OUT so that testing single-step #DBs on emulated
instructions can be run in userspace (by modifying IOPL).  OUT is also
more interesting in that it is guaranteed to exit to host userspace,
whereas RDMSR will do so if and only if userspace is filtering the target
MSR.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 98bdfe36..4b2fbe97 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -124,14 +124,13 @@ static unsigned long singlestep_basic(void)
 
 static void report_singlestep_emulated_instructions(unsigned long start)
 {
-	report(n == 7 &&
+	report(n == 6 &&
 	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
 	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
 	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 3 &&
 	       is_single_step_db(dr6[3]) && db_addr[3] == start + 1 + 3 + 2 &&
-	       is_single_step_db(dr6[4]) && db_addr[4] == start + 1 + 3 + 2 + 5 &&
-	       is_single_step_db(dr6[5]) && db_addr[5] == start + 1 + 3 + 2 + 5 + 2 &&
-	       is_single_step_db(dr6[6]) && db_addr[6] == start + 1 + 3 + 2 + 5 + 2 + 1,
+	       is_single_step_db(dr6[4]) && db_addr[4] == start + 1 + 3 + 2 + 2 &&
+	       is_single_step_db(dr6[5]) && db_addr[5] == start + 1 + 3 + 2 + 2 + 1,
 	       "Single-step #DB on emulated instructions");
 }
 
@@ -153,8 +152,7 @@ static unsigned long singlestep_emulated_instructions(void)
 		"1:push %%rax\n\t"
 		"xor %%rax,%%rax\n\t"
 		"cpuid\n\t"
-		"movl $0x1a0,%%ecx\n\t"
-		"rdmsr\n\t"
+		"out %%eax, $0x80\n\t"
 		"popf\n\t"
 		"lea 1b,%0\n\t"
 		: "=r" (start) : : "rax", "ebx", "ecx", "edx"
-- 
2.34.1.703.g22d0c6ccf7-goog

