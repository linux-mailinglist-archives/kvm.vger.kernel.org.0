Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BAA73D52B
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjFYXH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFYXHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB911A
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:53 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-666ecf9a081so2533965b3a.2
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734473; x=1690326473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBy1+s5+1bIZxGdZDUFvFfxmlLpG2meXbQVky29avoY=;
        b=G/FpgPODODp9mcQcSfDie54CU2ZqB6gIZ3CSo/h7Fv69axSgfZuNvgVUd7/7FgCjfU
         hfWMQpS0uVcv0U3IG0odySZ9l0urUV2kGFd41tZtxI+DWHK47DPHLavDaWIPGl8fy7fv
         ck6ndoWc26joVkr3hx3MLvMggCDPv1AH7NHbUX4nVRo7cw1xTef5Hl9PwpC4WENrXMsJ
         7WtNpbEiAPZSDyiLV+x44i+v24CqJcsEFYAa97ocfMMuN2QBCtFRSs/fw410/OHpvhlp
         9jJSBj6iq6PpLp/g1DkUhDlp2SarcflfuOt+SNNFE8zP7QcnlMvcOVEkpOIN9UXPbcB3
         5HpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734473; x=1690326473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZBy1+s5+1bIZxGdZDUFvFfxmlLpG2meXbQVky29avoY=;
        b=E0qjm5v+2IMPereeTFmatKvOSm6ozmOPFsPK3lPDaFU8d9MyiPiyrOqveLdXH5huKp
         xFpZMysZgAb3K8Kj9YFrdNRwfj0uP1HyAbFvrc6g9aLd8JRsyPqcydAvypKC8aNVymRe
         79mGtzw+AMryrvff/PdjmRYNkbpw9Y4AzMMcSAIHY1JJww93XoAJfB6thuj7EcDt2Bar
         j7DkbVvk+vxEkWOkRycicFMBx2xguz/gPxPBp+ddMrXxLeE++30y2DdQ9CQ7NIj/tvgv
         NFWMgJecw7NdyN5jjPDPkMDv3dH2qlNoT/VapdAzqm0gFRMRGVOJjzqGKekHiU4T0IWO
         d3Cw==
X-Gm-Message-State: AC+VfDwhRBxrgSbnEirukpFggTJtsc4Iu1bWdy6x+cRfagzH8ilxLC8f
        Np2JGZxaic7agh6gwm6WsITG9/SZMn4=
X-Google-Smtp-Source: ACHHUZ4x2qSpG9IBvl8L3NEad+JX+3ufu1ezTQHpdRotTSivpeCHXX1ZaOBT3uFQ1NKhHAc16/WAAQ==
X-Received: by 2002:a05:6a00:1595:b0:666:e8e1:bc8d with SMTP id u21-20020a056a00159500b00666e8e1bc8dmr36877858pfk.11.1687734473111;
        Sun, 25 Jun 2023 16:07:53 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:52 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 4/6] arm64: stack: update trace stack on exception
Date:   Sun, 25 Jun 2023 23:07:14 +0000
Message-Id: <20230625230716.2922-5-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
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

