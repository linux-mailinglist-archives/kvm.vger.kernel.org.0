Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D15733D7B
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjFQBuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjFQBuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:50:03 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92053AB7
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:02 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-bcde2b13fe2so1397521276.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966602; x=1689558602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSvXobSoaavkoo0EQIpP6Ohf0EY4dYmdzuAgaaNQ/8A=;
        b=MskxMH2DIVt0ErXSC2QT1D0CQgBnWMLtgV6E0CZAyk+Jw2kbgYMKyhcn0z5xqtHebF
         kymU0af+q8QsP46pGHgCWE+8HPVbTL58adGBSv2IgFGuRV+izKnmQsxlsHoD8v+4tfVP
         /WJ8yXgPnrC1IVFJTgHgIznV1OtbDLrPttKadkiAhUZE9p47jfP1cu92ZSDOYeEoLKIQ
         o19pwiYmQdC6B2T8hhqPIgxgcGZOH/tsLxDGVyi4QKe9SJhk36Jz5qVDqMaOvBuE5+Ia
         Hr8DNj9V80YPM+rDgro93TlhF06e9sNfyhrIEfAnKLes2+ubPD2EnzFELyTSn1jjqRjU
         pmfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966602; x=1689558602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XSvXobSoaavkoo0EQIpP6Ohf0EY4dYmdzuAgaaNQ/8A=;
        b=WN8Sz5nViQFqSp8hcsfhYVEzoW4/NUiuVtLREUf+h5e1CuXDseKGBhnyN3HnFTyFel
         Kxa1swGihMieNYY1dwaLDpn5CHWWZrB15SnZo3GtMdjS5lLNDLwzgwGMBgXj9ZCfFs9u
         5PjbzgXWNd5BHYbi1tz/puqgPd1FarF5+kVpnphVwj1L5lcoyD3yUzdpLXDaqCeSi4vD
         hvlFgYOd3IBrjcHIOVzQpA15CwxLrQINJNYLfsrVBboypw5RWscQR+pUOO81+Li+G8An
         6GrJ0RVXtTlv9QJby+o8ILnqu3Xh4qV8ClQSYqdcMW76HWJ6BR0VJ+Y8DtWSRrLCDWf9
         31pw==
X-Gm-Message-State: AC+VfDxyCL9OfiBZVaxDI0GlQ9EgYMCuUeGK5bm2C6gvivb2nFC+OjRW
        nAqxsG2J21pUauHgIL7i23AkZKGg6HE=
X-Google-Smtp-Source: ACHHUZ5ciMoS39Hk2c0d4HgqO8dxhCed6O8XPpEt/zt5WtejJiANiOevuOxSqeQIUnJi20d49wnoHA==
X-Received: by 2002:a25:d297:0:b0:ba8:199b:9ec2 with SMTP id j145-20020a25d297000000b00ba8199b9ec2mr856339ybg.31.1686966601568;
        Fri, 16 Jun 2023 18:50:01 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:50:01 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 4/6] arm64: stack: update trace stack on exception
Date:   Sat, 17 Jun 2023 01:49:28 +0000
Message-Id: <20230617014930.2070-5-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Using gdb for backtracing or dumping the stack following an exception is
not very helpful as the exact location of the exception is not saved.

Add an additional frame to save the location of the exception.

One delicate point is dealing with the pretty_print_stacks script. When
the stack is dumped, the script would not print the right address for
the exception address: for every return address it deducts "1" before
looking for the instruction location in the code (using addr2line). As a
somewhat hacky solution add "1" for the exception address when dumping
the stack.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arm/cstart64.S          | 13 +++++++++++++
 lib/arm64/asm-offsets.c |  3 ++-
 lib/arm64/stack.c       | 16 ++++++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index cbd6b51..61e27d3 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -314,6 +314,13 @@ exceptions_init:
 	mrs	x2, spsr_el1
 	stp	x1, x2, [sp, #S_PC]
 
+	/*
+	 * Save a frame pointer using the link to allow unwinding of
+	 * exceptions.
+	 */
+	stp	x29, x1, [sp, #S_FP]
+	add 	x29, sp, #S_FP
+
 	mov	x0, \vec
 	mov	x1, sp
 	mrs	x2, esr_el1
@@ -349,6 +356,9 @@ exceptions_init:
 	eret
 .endm
 
+vector_stub_start:
+.globl vector_stub_start
+
 vector_stub	el1t_sync,     0
 vector_stub	el1t_irq,      1
 vector_stub	el1t_fiq,      2
@@ -369,6 +379,9 @@ vector_stub	el0_irq_32,   13
 vector_stub	el0_fiq_32,   14
 vector_stub	el0_error_32, 15
 
+vector_stub_end:
+.globl vector_stub_end
+
 .section .text.ex
 
 .macro ventry, label
diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index 53a1277..7b8bffb 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -25,6 +25,7 @@ int main(void)
 	OFFSET(S_PSTATE, pt_regs, pstate);
 	OFFSET(S_ORIG_X0, pt_regs, orig_x0);
 	OFFSET(S_SYSCALLNO, pt_regs, syscallno);
-	DEFINE(S_FRAME_SIZE, sizeof(struct pt_regs));
+	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
+	DEFINE(S_FP, sizeof(struct pt_regs));
 	return 0;
 }
diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
index 1e2568a..a48ecbb 100644
--- a/lib/arm64/stack.c
+++ b/lib/arm64/stack.c
@@ -12,6 +12,8 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	const void *fp = frame;
 	void *lr;
 	int depth;
+	bool is_exception = false;
+	unsigned long addr;
 
 	/*
 	 * ARM64 stack grows down. fp points to the previous fp on the stack,
@@ -25,6 +27,20 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 				  : );
 
 		return_addrs[depth] = lr;
+
+		/*
+		 * If this is an exception, add 1 to the pointer so when the
+		 * pretty_print_stacks script is run it would get the right
+		 * address (it deducts 1 to find the call address, but we want
+		 * the actual address).
+		 */
+		if (is_exception)
+			return_addrs[depth] += 1;
+
+		/* Check if we are in the exception handlers for the next entry */
+		addr = (unsigned long)lr;
+		is_exception = (addr >= (unsigned long)&vector_stub_start &&
+				addr < (unsigned long)&vector_stub_end);
 	}
 
 	return depth;
-- 
2.34.1

