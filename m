Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7936CA46C
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjC0MqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjC0MqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:46:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D3F40F9
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:06 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id kc4so8288181plb.10
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Jy6p6ZgvLWaGCNqcDbzzpAS+I4C9QxVLtT76Pj/K4Y=;
        b=iLeMnTaMkLSU+O0HeCiBgZsLnjNNbzGQCR5AkrBB1p3WgluDTMGzP8dIhB/ZAm62OF
         dXlsvHHjr339/u1S5VtsW+UJ76f1AGUtSrwS9LhhprCgVoDi8/wEeGxQmVlKR/IIc2Yu
         BWyXjLVbmZLAgzK2EiJusqvxbXgmygwAoQs9d+HMBtDmQHGBuVQC8boZgl7SSjhyVseA
         Gfwj21zJ6prDOzj5JhqSQ67Y76KAdjTUc1VUvl4T4zqE5MUqkSyOmYhrotuSBZ6zB3uY
         XdTLVVXCQQsViz3RrqEYCCobtt+w5b3jhCUcWYVAJvdCP+WYuVBG0seA3SN9O4gLnKhd
         BJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Jy6p6ZgvLWaGCNqcDbzzpAS+I4C9QxVLtT76Pj/K4Y=;
        b=AL4KbeGa9FKXfUgU1QAtIh1YAHrMzQVnSfMbXVK/0CpTih++zUmTAFZVywKJk92R7i
         SeNOZyrprHbCRLgIbZ4E/akwMf5nZuhjivi/xM2LRPjK+drWZ3Rb2g7Wr9laD1BtUmX1
         GTFcavofrTWyTJC6TUjNZEbzRKmzltxAFZRM8fvSBljSkmbu1lPPg6m2adQ73nrUL7l4
         JBAxElb0Hkorf5IFMLMzVfqIo/410IYj7GPy7RBw97QJgtVJlcy2OP/P8EBVHsXBFiKi
         pgFDTHrFUetHLvLg8yoDDbyXfWBCzOSyqc9BK69vBveZe3697JZyn1TLM+Y4yIx2lAI7
         HuLQ==
X-Gm-Message-State: AAQBX9fyYQ/2A8swx1GPcV8HxemAHA3EtpzLJ/4vRAGSj1ej8pfnpFek
        aBrc+gRBQF4GmcA9Qg/lLtxrsjdwb9o=
X-Google-Smtp-Source: AKy350YNW2E/HGL0Q0iH2ePO7Sx11fRsProFJzpX7G9DqYcnA89sOZcNkBITL6Gv8lL6ixaDoDX6SA==
X-Received: by 2002:a17:903:41cd:b0:19a:a9d8:e47f with SMTP id u13-20020a17090341cd00b0019aa9d8e47fmr15750546ple.36.1679921164893;
        Mon, 27 Mar 2023 05:46:04 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:46:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 10/13] powerpc: Add support for more interrupts including HV interrupts
Date:   Mon, 27 Mar 2023 22:45:17 +1000
Message-Id: <20230327124520.2707537-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt vectors were not being populated for all architected
interrupt types, which could lead to crashes rather than a message for
unhandled interrupts.

0x20 sized vectors require some reworking of the code to fit. This
also adds support for HV / HSRR type interrupts which will be used in
a later change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 79 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 14 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 34e3934..1bd0437 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -184,14 +184,6 @@ call_handler:
 	mfcr	r0
 	std	r0,_CCR(r1)
 
-	/* nip and msr */
-
-	mfsrr0	r0
-	std	r0, _NIP(r1)
-
-	mfsrr1	r0
-	std	r0, _MSR(r1)
-
 	/* restore TOC pointer */
 
 	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
@@ -238,6 +230,7 @@ call_handler:
 
 .section .text.ex
 
+/* [H]VECTOR must not be more than 8 instructions to fit in 0x20 vectors */
 .macro VECTOR vec
 	. = \vec
 
@@ -246,19 +239,28 @@ call_handler:
 	subi	r1,r1, INT_FRAME_SIZE
 
 	/* save r0 and ctr to call generic handler */
-
 	SAVE_GPR(0,r1)
 
-	mfctr	r0
-	std	r0,_CTR(r1)
+	li	r0,\vec
+	std	r0,_TRAP(r1)
 
-	ld	r0, P_HANDLER(0)
-	mtctr	r0
+	b	handler_trampoline
+.endm
+
+.macro HVECTOR vec
+	. = \vec
+
+	mtsprg1	r1	/* save r1 */
+	mfsprg0	r1	/* get exception stack address */
+	subi	r1,r1, INT_FRAME_SIZE
+
+	/* save r0 and ctr to call generic handler */
+	SAVE_GPR(0,r1)
 
 	li	r0,\vec
 	std	r0,_TRAP(r1)
 
-	bctr
+	b	handler_htrampoline
 .endm
 
 	. = 0x100
@@ -268,12 +270,61 @@ __start_interrupts:
 VECTOR(0x100)
 VECTOR(0x200)
 VECTOR(0x300)
+VECTOR(0x380)
 VECTOR(0x400)
+VECTOR(0x480)
 VECTOR(0x500)
 VECTOR(0x600)
 VECTOR(0x700)
 VECTOR(0x800)
 VECTOR(0x900)
+HVECTOR(0x980)
+VECTOR(0xa00)
+VECTOR(0xc00)
+VECTOR(0xd00)
+HVECTOR(0xe00)
+HVECTOR(0xe20)
+HVECTOR(0xe40)
+HVECTOR(0xe60)
+HVECTOR(0xe80)
+HVECTOR(0xea0)
+VECTOR(0xf00)
+VECTOR(0xf20)
+VECTOR(0xf40)
+VECTOR(0xf60)
+HVECTOR(0xf80)
+
+handler_trampoline:
+	mfctr	r0
+	std	r0,_CTR(r1)
+
+	ld	r0, P_HANDLER(0)
+	mtctr	r0
+
+	/* nip and msr */
+	mfsrr0	r0
+	std	r0, _NIP(r1)
+
+	mfsrr1	r0
+	std	r0, _MSR(r1)
+
+	bctr
+
+handler_htrampoline:
+	mfctr	r0
+	std	r0,_CTR(r1)
+
+	ld	r0, P_HANDLER(0)
+	mtctr	r0
+
+	/* nip and msr */
+	mfhsrr0	r0
+	std	r0, _NIP(r1)
+
+	mfhsrr1	r0
+	std	r0, _MSR(r1)
+
+	bctr
 
 	.align 7
 	.globl __end_interrupts
-- 
2.37.2

