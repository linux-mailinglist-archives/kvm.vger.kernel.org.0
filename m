Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDFC6CA46E
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjC0MqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjC0MqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:46:18 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB034680
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k2so8300310pll.8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGvXnBWeVAPA+YvFBPv6t4bCGTRX/pABDiDPF8FC0Js=;
        b=kfETIGrfuV3d8Y6aAjlRXgB5WE+WnHhIBTddC0oEYBOPPINJSKcxtfUTmXtRscVBlL
         DMCROekv7FHcwy/fmFy92iXxKJoVDPxaF8WGwOKzbGfkWE9p6rVt4O4XOysnJQDb5Hy1
         khTPtqi8J2Jw0+WrdYEk2qS/dDGLmocSGuIR/rc3t9/befrOupovz4V2WmBpFbR9PImN
         y1d5s2Q8vJEDLOnXrNdf12YHcWvAsZyxmuEjjRIzh9Oh0x4KKz/KOqMUlIfc1gPjrlLY
         ZHSjJ94x04U5SsRqmmdJEhtvdhQMEXQpU5J0d8xNwTRiLufgcWTgR5HefAqJAiajJRgW
         5L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGvXnBWeVAPA+YvFBPv6t4bCGTRX/pABDiDPF8FC0Js=;
        b=T4H3aLwU6qEg73Yf6OKHE/K4EgiTbPpgD/5sGbOHgBWR7LtDlTrQ9cZAmgKIKDwMHq
         V6AHRAZMFsMATVa01r7VabHbtN0ANjuEpkHe1zQuwAhYgNysr2VpKzSxUiQwxrjU2Btv
         tXap0AhLlQne45to7oMpW1ZM+pQpQQ9+dHrXxiJ7xJOj1vSC4oM2+r0vqHmLy5Ys90/U
         4MucaClJOj1oD7RQDS1OMu3dy4WzfETdK/QPllTF4uIi4RzNjnfYTVJgx7Z8TKWf6/DH
         OfFHVaUUe4FeVOThi6rK2p/Eag0EppYJpMNNJlrL29JjdJ1090hWsCG3hEozgs409+n1
         hf/g==
X-Gm-Message-State: AAQBX9eAxTOFq0gFj3zgKYF8BAm06yOzzC/aliv+Dgevf3aZph+Qjh4s
        Al8p2Ju4rfRex93K8c8N/mXqyeHus0Q=
X-Google-Smtp-Source: AKy350ZYLBwh3J8d7Z6a4Xlkx6jIFEg7PR4hxhwenxcI6D3NmC2DmteNwcYn4LDpPrV1ffAMlYuecQ==
X-Received: by 2002:a17:902:ebcf:b0:19f:7977:c9d6 with SMTP id p15-20020a170902ebcf00b0019f7977c9d6mr9997127plg.28.1679921168042;
        Mon, 27 Mar 2023 05:46:08 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:46:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 11/13] powerpc: Discover runtime load address dynamically
Date:   Mon, 27 Mar 2023 22:45:18 +1000
Message-Id: <20230327124520.2707537-12-npiggin@gmail.com>
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

The next change will load the kernels at different addresses depending
on test options, so this needs to be reverted back to dynamic
discovery.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 1bd0437..0592e03 100644
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
@@ -185,9 +193,10 @@ call_handler:
 	std	r0,_CCR(r1)
 
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

