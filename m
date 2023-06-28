Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35C4740717
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjF1AOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjF1AOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:38 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB3526BF
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-553b2979fceso1875827a12.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911274; x=1690503274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBy1+s5+1bIZxGdZDUFvFfxmlLpG2meXbQVky29avoY=;
        b=ME2yZ5v9engYXuakH/xkWSNpuDotyvZhJ2RAvGD6Phbl8exTwTHA1fNfMd2R8WrIc0
         2jARdXArqde2FcNVEU3YD5UBir3iALIMnIAlmse0VEHd9IxKSXfyT4b3JmVxHS0aqh4c
         PupRRnBINz5mxRbk5JAojUfo4+cDugVhjlZS54+n2nT55wfeocGAGEx9KRVT+/pz3pvN
         qwWg5t9b+TIkBr4xLnuPFiGDa6IHnErgw8R5jk+UuiAhR4tS+65npigD/11uCfAf5n2C
         GONXgT1E2uEwo+nU3UNEszV0HHGiaivV1RBTZoAIxY7A3XEnZg1CVv7iBQ+aq4Hm/Wt3
         3CWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911274; x=1690503274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZBy1+s5+1bIZxGdZDUFvFfxmlLpG2meXbQVky29avoY=;
        b=VSJF6HRHGQHGdMFUATnlMuCg9Eb1+la46tbnybvc9j9VMrloZ9oElZxi0elZxztxzt
         PMArUsyL2//jPSPTtKBpwZefelMHxBGUY44FcTfS0SIseUnp6I2k8ww8L8IDp3E6ZjbA
         mzzClNK6jtRi7l1WK1pWKxsGOvLV4AyHA070vOermmkaJBsiwD5pcWI+UAm3OCqS8229
         B1asxk5RvdFd9CdePJtVLoFY+tZrfVXaEDVECAXx7875MzIjVp/hOvl3AzSGhMfVExir
         9ZTBx/TkSp1AI0wVHC5GwWiKJhFea6AA7Pm5avjkaH5513N7lavYsQMhYjC7d/huRnnW
         1FwQ==
X-Gm-Message-State: AC+VfDyeDN0fun+mJRzAZEM7Lob3RAx7i6JRU9ziCAYDvhQI4WZsOI+P
        qBHLksc6IDMt1nb2sLN4GYJGaBk4QKA=
X-Google-Smtp-Source: ACHHUZ7pIvBspewQylA7vvhANwJKaB7OJyudL7l3ZA2ns4WE7tQcz7fiyIKPhAghpJLNHtXnR0dZYA==
X-Received: by 2002:a17:90a:2b0e:b0:263:a37:fcc3 with SMTP id x14-20020a17090a2b0e00b002630a37fcc3mr4071354pjc.5.1687911274375;
        Tue, 27 Jun 2023 17:14:34 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:33 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 4/6] arm64: stack: update trace stack on exception
Date:   Wed, 28 Jun 2023 00:13:53 +0000
Message-Id: <20230628001356.2706-6-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
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
v1->v2:
* .globl before label [Andrew]
* Some comments [Andrew]
---
 arm/cstart64.S          | 13 +++++++++++++
 lib/arm64/asm-offsets.c |  6 +++++-
 lib/arm64/stack.c       | 18 ++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index cbd6b51..865a96d 100644
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
 
+.globl vector_stub_start
+vector_stub_start:
+
 vector_stub	el1t_sync,     0
 vector_stub	el1t_irq,      1
 vector_stub	el1t_fiq,      2
@@ -369,6 +379,9 @@ vector_stub	el0_irq_32,   13
 vector_stub	el0_fiq_32,   14
 vector_stub	el0_error_32, 15
 
+.globl vector_stub_end
+vector_stub_end:
+
 .section .text.ex
 
 .macro ventry, label
diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index 53a1277..80de023 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -25,6 +25,10 @@ int main(void)
 	OFFSET(S_PSTATE, pt_regs, pstate);
 	OFFSET(S_ORIG_X0, pt_regs, orig_x0);
 	OFFSET(S_SYSCALLNO, pt_regs, syscallno);
-	DEFINE(S_FRAME_SIZE, sizeof(struct pt_regs));
+
+	/* FP and LR (16 bytes) go on the frame above pt_regs */
+	DEFINE(S_FP, sizeof(struct pt_regs));
+	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
+
 	return 0;
 }
diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
index a2024e8..82611f4 100644
--- a/lib/arm64/stack.c
+++ b/lib/arm64/stack.c
@@ -6,12 +6,16 @@
 #include <stdbool.h>
 #include <stack.h>
 
+extern char vector_stub_start, vector_stub_end;
+
 int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 {
 	const void *fp = frame;
 	static bool walking;
 	void *lr;
 	int depth;
+	bool is_exception = false;
+	unsigned long addr;
 
 	if (walking) {
 		printf("RECURSIVE STACK WALK!!!\n");
@@ -31,6 +35,20 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
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
 
 	walking = false;
-- 
2.34.1

