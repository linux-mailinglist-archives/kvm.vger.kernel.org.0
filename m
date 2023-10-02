Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5C7B5682
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 17:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbjJBPNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbjJBPNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:13:46 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45040B8
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 08:13:43 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-406618d0992so27690395e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 08:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1696259622; x=1696864422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKlKP5/9RI4UDE4Mv9BGz18R+1865OFX4ZcGb0PXpPY=;
        b=McGLoOxdOdJdPFW2gBLOKuAsGz+Dpf+U1zf66LURHpycGoduMXYrB72MRpiKHBxQGu
         DlHRIc5JFAImkwD78dhw3xnHx6/QpqqmckZlPKmEuUBfA3VMRDYWMBnymXmq5ACrdK8p
         jMBl96IZgVSOmOFnE6c8LHxSfQlW9rcrFlSWjEuX+l6hXQByBBXduNPPuXYP1dXNbAr9
         v/s7gbppGuaP7BlPnLac2C/70PrW2nXztcNYQsL3OW1r+WXwYERdeLQET7gRw/kYfihL
         Ib/Z8ZIy2rUuyhe/9p6M8iRkzRmRPrClWpRR4li1UgBmZ8BLqFNu2SC323ZuAoGvEoGZ
         3GYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696259622; x=1696864422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKlKP5/9RI4UDE4Mv9BGz18R+1865OFX4ZcGb0PXpPY=;
        b=mLJp7kcx5oI4Kp1OtI2ffTPuuy/MAJe+fplusHNvvME87AJlt8FP0As9OKLR/PudgG
         dsJgs5ZwwZD8zgi93dpKr0RuaOv/DNwxdSWpNju3bHRa+J96grvyaRRtA/zpUZyl+HEY
         f/bErSMoSLy4V1dDsCkui13L6xstohkASRUKUKhHrAvpg0chVvUd0d7jV1B/Slmwvhtm
         qYFVnsj1CfuaAi2yEiG9fDvI+hXA3CfKrA0v3L2cC1Zg/OaKSkW4Y3dMTfm71u7cK8X9
         1+jQ+RSYstUxEA66J7/SmHQ6FcW8jalrFFZnRfliR0s9ipDDfEGhfpEUq6o1yX1+1+NU
         yjLA==
X-Gm-Message-State: AOJu0YzAes02JXvfM11dFvffP029UQDGwCBPd81Jv4/xNN86oFqSfnF8
        OjFsoPqbc0NbN/c2vf9KC4P27Q==
X-Google-Smtp-Source: AGHT+IHO+YzsPhqZFo4O8yw5o3ilb0oSA+vYnzJ8XqlEcYHitO4Hyb9F4EkPU7aucBS8UpRf+rPooA==
X-Received: by 2002:a7b:c8d6:0:b0:406:5190:7d07 with SMTP id f22-20020a7bc8d6000000b0040651907d07mr11349388wml.17.1696259621727;
        Mon, 02 Oct 2023 08:13:41 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id l5-20020a7bc445000000b003fbe791a0e8sm7509731wmi.0.2023.10.02.08.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 08:13:41 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Ryan Roberts <ryan.roberts@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 3/5] riscv: mm: Only compile pgtable.c if MMU
Date:   Mon,  2 Oct 2023 17:10:29 +0200
Message-Id: <20231002151031.110551-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231002151031.110551-1-alexghiti@rivosinc.com>
References: <20231002151031.110551-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All functions defined in there depend on MMU, so no need to compile it
for !MMU configs.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/mm/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 9c454f90fd3d..c71d4253a171 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -13,10 +13,9 @@ endif
 KCOV_INSTRUMENT_init.o := n
 
 obj-y += init.o
-obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o
+obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o pgtable.o
 obj-y += cacheflush.o
 obj-y += context.o
-obj-y += pgtable.o
 obj-y += pmem.o
 
 ifeq ($(CONFIG_MMU),y)
-- 
2.39.2

