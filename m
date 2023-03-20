Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56C16C0B0F
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCTHE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCTHEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9881B303
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id ja10so11456393plb.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqlkjyUKQxB6TQQy7KpPSlK+JSEQcfav06u1BzOX0U4=;
        b=bj4wqpwM66zXaJ3R+fyYbsI/SDBm+rnA5NQLtMlofd9eDchM1O6W90Nx9LEUvjjvrm
         KPgPf0hUjK0p1BN30u74IdWka/9xfalFHYkkhZF7Wh1KOs2MnK8QdYYpSgxCRPM9x//r
         EjFXj7LoihB74B/Do7aQF672wbipH6yvkRGqgRTKwPtvGSWkYZ8QMrjzVTyDsoXpf4II
         SFAVa9F258pctg4AJZa9/nehLLaotlA4GzzL/2IIGFj3YTYtAzFflKt5KfoiXzJ3WQ4Y
         +K+5+4yedhppz9pXFdLG9QHmp1x217LMSem4QkrU6pblnVevvgUcbms+wUNn/hjh72O7
         n7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqlkjyUKQxB6TQQy7KpPSlK+JSEQcfav06u1BzOX0U4=;
        b=1ZDc1p/h8g+sDb8OO9Wg2msllHkPI0Fw5jusirYAWNFxEm2BXWsrLF6l4CoO/rb5ac
         mLn3VL12o7onNlM0aMjTl+FumBjom6gaLNgQ+FPAZgoXVNaEiPLCGqNTGmAfBbZNw6Jz
         1G3CXuumn6EMoOYwjsLqyRXGXCAzSp7hMtQJGtjRjNigka4juTeBpnqITOkWDymMfZMs
         K1TU/RQ9XoeKjQeS//5DiqKkIIlKJkskxtQHTxJWshJCbr4KAiCtXf/+kYDELfsxdyzX
         flFzakFEq9Sd6LIloXWsyxUyEH0uI5YDxXpdyQLOfPbx5w8mpPI5Es/IbktVW8DZ9UhZ
         Zdyw==
X-Gm-Message-State: AO0yUKVeoh9cwf9hk5FtIeg0avc0rSsqK87CNskbfzt3aTgTZtmmsHHa
        sIhrHNovAd5yGsQ57Cc+XzA0YVV5Q4w=
X-Google-Smtp-Source: AK7set/KKpYGH+TEF/9H97G0b4oPND3h1P209ewvOlM7bgEWSOGOwHH5ImeRdqIV6hpMQeiLygwhUg==
X-Received: by 2002:a05:6a20:66a1:b0:d9:5bb0:5714 with SMTP id o33-20020a056a2066a100b000d95bb05714mr3472692pzh.13.1679295854177;
        Mon, 20 Mar 2023 00:04:14 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:04:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 08/10] powerpc: Discover runtime load address dynamically
Date:   Mon, 20 Mar 2023 17:03:37 +1000
Message-Id: <20230320070339.915172-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next change will load the kernels at different addresses depending
on test options, so this needs to be reverted back to dynamic
discovery.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 34e3934..069d991 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -33,9 +33,14 @@ start:
 	 * We were loaded at QEMU's kernel load address, but we're not
 	 * allowed to link there due to how QEMU deals with linker VMAs,
 	 * so we just linked at zero. This means the first thing to do is
-	 * to find our stack and toc, and then do a relocate.
+	 * to find our stack and toc, and then do a relocate. powernv and
+	 * pseries load addreses are not the same, so find the address
+	 * dynamically:
 	 */
-	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
+	bl	0f
+0:	mflr	r31
+	subi	r31, r31, 0b - start	/* QEMU's kernel load address */
+
 	ld	r1, (p_stack - start)(r31)
 	ld	r2, (p_toc - start)(r31)
 	add	r1, r1, r31
@@ -114,8 +119,11 @@ p_toc:		.llong  tocptr
 p_dyn:		.llong  dynamic_start
 
 .text
+start_text:
 .align 3
+p_toc_text:	.llong	tocptr
 
+.align 3
 .globl hcall
 hcall:
 	sc	1
@@ -193,9 +201,10 @@ call_handler:
 	std	r0, _MSR(r1)
 
 	/* restore TOC pointer */
-
-	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
-	ld	r2, (p_toc - start)(r31)
+	bl	0f
+0:	mflr	r31
+	subi	r31, r31, 0b - start_text
+	ld	r2, (p_toc_text - start_text)(r31)
 
 	/* FIXME: build stack frame */
 
-- 
2.37.2

