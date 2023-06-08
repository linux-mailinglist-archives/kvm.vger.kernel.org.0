Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EF727962
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjFHH7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbjFHH7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:59:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A024C26B1
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:59:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-65131e85be4so243848b3a.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211155; x=1688803155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHQqCBJ3vPZXVRp8sk7/Voq35H3ezkKDIoLrDymwHvA=;
        b=Syx/hBEvLem7J8x7MIylndX2yn6ETOT6bCSpoaTrM+CiiVvPOJhkmr1pyKeiBuzdfS
         Ze+3DgvfVXSpwY11hBporubRV0JzdZPHC9W88Z00o4FVQeCpgGRdWTe0RQsiG50shVqd
         Z+H6ipWTjKbiYX8RuNayDjv1zCJcUs1ovs5crYoZ56RnrRsSnlqYSedwWmeBeQg57Zhg
         p3SMc6jNHazx12kaFtRoJiWKIkV6hmAKIrymqIrjRlu+c7Yh6VeNKyazYkWW+w2ONCTN
         Bunaz5d6tT6RYC5xIU4fCRsY3rIVjmaKRWMu4SlIY/dN02NKqztvOY49zK5MECmmretk
         4hQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211155; x=1688803155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHQqCBJ3vPZXVRp8sk7/Voq35H3ezkKDIoLrDymwHvA=;
        b=ZRMuhFv+W5hrK7asTXAoPYY3WEookat6nrhTsNKPkXJ6Mi0m96qgE5/PvRFdtZowtE
         5XtNYRinHwx1A/2zauV7ooOpiJ9Yj6hm22/4URvdMkxqqLG+mnKBcBFCVdBPRMCoBrYL
         EVaGWQqMXWXrk3Gmr2E+6cqpD/mZy7ZK+OvsoHQV+cGUguS6k4bEWNx8QfunzyiHhmUB
         G+aOvdzYd4HHYWoRwTmcwwz/i5lcuWwX3ofg0cG3i6REUR0dfDVt3UPyGe8BrWX1JEeT
         URuZiL+/KLCDFd0RN9LixHaRIIh7FXMHWCnxlsBSDSKYPJ2k/t4oqinSDD4nB60DFOAx
         DnEA==
X-Gm-Message-State: AC+VfDwP1rxjYKO/yrGgXAGzEI9fpSBU0S8RqFHGTVP7OjVAaoR7vRcz
        qga64xALc0Tso5prvXZeyhMtyyN+kMw=
X-Google-Smtp-Source: ACHHUZ6UTQ8tKBxpG8TetSBYlJj7oGL9tVasYjhgNgg/UD8gpKF2Jex+9C6NxPVoPBolUAUOJEnXtQ==
X-Received: by 2002:a05:6a20:4c8:b0:110:9b0b:71b6 with SMTP id 8-20020a056a2004c800b001109b0b71b6mr4391703pzd.37.1686211154836;
        Thu, 08 Jun 2023 00:59:14 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:59:14 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 10/12] powerpc: Discover runtime load address dynamically
Date:   Thu,  8 Jun 2023 17:58:24 +1000
Message-Id: <20230608075826.86217-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next change will load the kernels at different addresses depending
on test options, so this needs to be reverted back to dynamic
discovery.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index b7514100..e18ae9a2 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -33,9 +33,14 @@ start:
 	 * We were loaded at QEMU's kernel load address, but we're not
 	 * allowed to link there due to how QEMU deals with linker VMAs,
 	 * so we just linked at zero. This means the first thing to do is
-	 * to find our stack and toc, and then do a relocate.
+	 * to find our stack and toc, and then do a relocate. powernv and
+	 * pseries load addresses are not the same, so find the address
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
2.40.1

