Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E4733D7D
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjFQBuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjFQBuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:50:06 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C858F3ABD
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:05 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3942c6584f0so961493b6e.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966605; x=1689558605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynKZKGuO4BrwSZJ0FNz6BaXOvj6HEfe3RCURjgJx+qM=;
        b=GZ3R+Vm33xO9SH7eHKsK6NVw/DOMl+0JCqN5rrBnjO/w0Nnxb24sfnL6Jbs48K6+WF
         xoR7hJFok8VQ3sDtldOMYpZRJRGic+z8rCZlNltsAjnlqikT2af3Vyg7iOecpaF77PkN
         trC3q+/uCVwvp3n59I3jFBjbuFs8dyI2J1zh7+BycQ8DFIOB0NIdxE1szXWYrLqfAbFc
         2FM6VxcEGnEowyw9M4wVM7MrMMFH/tm4caALAE70SbSS7snNVhPqW5+CyC9nO26Zwzde
         py7IRLyXG8ojr4T9EJzFdfaMl5wa0cR1YKeOrwrxLZ17MkgqJI4N8Z0sRqKpb0PjB66u
         pf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966605; x=1689558605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynKZKGuO4BrwSZJ0FNz6BaXOvj6HEfe3RCURjgJx+qM=;
        b=ByCKKesm4iX0EvKaulTsD/iSKC+aEdWSpB0iuZ5iWmqL13iEhwC+6iNs6Nzu1CdP96
         GdeNAnxY3THtEHYAM/fS4rMPcpgtAWrC1wdsp5XUzVvz7i0FIfjoNzgaAfxoges80Ye/
         zO+QzL4zw4NWtb9ZTlyhxjkiBYEzHprvxQ55D4eVBRiNh1lrVjCdLaed2kA25xURaAjn
         +CDAY/YhyTMW9eZ7XyQT2cPhD7t56Ze5LkrMWn5guU4CQ5jH9KNmS/eftYo6GTOJ6kPX
         4P7bzM3wH0Pr1ulRdGDFl1N6AH/Wuw3AXteaHxA2qqP7/7PZnrb9LuyikN7rdzWJ+R/q
         Jc0g==
X-Gm-Message-State: AC+VfDzUURK8yHamqNYx0kvb/h1GURWfTR35X4+96kFfRl8mdFMiU+Rv
        3sf0CU8nxjdA03WseMfc6xmW0FbbvIc=
X-Google-Smtp-Source: ACHHUZ5nmJjaEn7DDaD5ykRWaLxUj8YZdDvEvRLN0jMPi/iqg5sETahn8WzHIj6AM0EqPUbXw+IEwA==
X-Received: by 2002:a05:6808:bca:b0:39e:6c93:3d2d with SMTP id o10-20020a0568080bca00b0039e6c933d2dmr4638438oik.30.1686966604946;
        Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 6/6] arm64: dump stack on bad exception
Date:   Sat, 17 Jun 2023 01:49:30 +0000
Message-Id: <20230617014930.2070-7-namit@vmware.com>
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

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/arm64/processor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 831207c..5bcad67 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -130,6 +130,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 	printf("Vector: %d (%s)\n", v, vector_names[v]);
 	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
 	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
+	dump_stack();
 	printf("Exception frame registers:\n");
 	show_regs(regs);
 	abort();
-- 
2.34.1

