Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9659200E
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiHNOND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 10:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbiHNOM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 10:12:57 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF79FCE
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:56 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z16so6335560wrh.12
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Jpi+qYPVkjjgLSftDLRCVgzhzYoBkPjkNBatqeFjYP4=;
        b=Qq8AUk/9AWVqplZnZsraolgAwvvs+PIe6EeGfq6jN5MM2n6AruvuyymJsCkvpb+OzP
         DYg/NMqHsO6QTHRAmrKsuXtxegQV5ArT1zwjqST2UY7tF7wobikGXu8YTrZv50Ep0Ae3
         kQ6O0X7afhbpbhHnOfxIltiwZLRErrqF5lam6sIXJu4xMzzliWzprfPqRkgZB1tMXU1/
         R7yHX1sH3JLUhkX3H1H84GsxsU9S9kdPrpHmC8xt1v98s+gs4HLrQJ3K/kl6UABKJ4Rr
         uV7ZKh1Ouv6RetM5zMnnJz7UfMlbuOU52TAUum4YqqIrYAQSjRgz7dY13Phg2BCkc3lq
         qL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Jpi+qYPVkjjgLSftDLRCVgzhzYoBkPjkNBatqeFjYP4=;
        b=yrg3QQTLnv2FZvfWsUVrMKlLhlI9oRhT4qjCGPQHxcQHYQxQH0yJTkXsW7saKOf48C
         cujgu9n433OFVTSovEzFZOc4APHEt4f5Ax7o7FQcSf6ZlIGyV3XBaslgYbOIwVIeq2ln
         onUWnGFkIWsF7NiPMH3b6UrWLEapiDJSE0Fpx+d6XOr7M+PGT2QrzRdHnvMy2mKm1ygN
         1CMcA4PRq1e7C6wCcn7wSethW3Jq9xxSZbfAbeqYh7PFwpjEC3OGcC02OF7dxLvRBifm
         esQCt+H5bBggrOpUNkXOIju3NC6VP7hxaYNH1bx6RMJmG4A+EtVAIj8t8aAGi+O/zCtH
         9DXw==
X-Gm-Message-State: ACgBeo0A+RrHIYzxDgeEJRecBlzd8El3m22XavyadABhq0FNzkE18iDx
        JWQi04z7abuV1c/SLy9Lo5VOmQ==
X-Google-Smtp-Source: AA6agR6FYk+iY85iu6ZNNhqlEqAtS2htyInEPS/oNlnm6Idei+lVhLdGdUcw2QokwFea/pPKDyVQbg==
X-Received: by 2002:adf:f90e:0:b0:21e:417b:dbd with SMTP id b14-20020adff90e000000b0021e417b0dbdmr6282420wrr.425.1660486375541;
        Sun, 14 Aug 2022 07:12:55 -0700 (PDT)
Received: from henark71.. ([109.76.58.63])
        by smtp.gmail.com with ESMTPSA id b8-20020adfde08000000b0021db7b0162esm4625419wrm.105.2022.08.14.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 07:12:55 -0700 (PDT)
From:   Conor Dooley <mail@conchuod.ie>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] riscv: traps: add missing prototype
Date:   Sun, 14 Aug 2022 15:12:38 +0100
Message-Id: <20220814141237.493457-5-mail@conchuod.ie>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220814141237.493457-1-mail@conchuod.ie>
References: <20220814141237.493457-1-mail@conchuod.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Sparse complains:
arch/riscv/kernel/traps.c:213:6: warning: symbol 'shadow_stack' was not declared. Should it be static?

The variable is used in entry.S, so declare shadow_stack there
alongside SHADOW_OVERFLOW_STACK_SIZE.

Fixes: 31da94c25aea ("riscv: add VMAP_STACK overflow detection")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/thread_info.h | 2 ++
 arch/riscv/kernel/traps.c            | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 78933ac04995..67322f878e0d 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -42,6 +42,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+
 #include <asm/processor.h>
 #include <asm/csr.h>
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 39d0f8bba4b4..635e6ec26938 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -20,9 +20,10 @@
 
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
+#include <asm/csr.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/csr.h>
+#include <asm/thread_info.h>
 
 int show_unhandled_signals = 1;
 
-- 
2.37.1

