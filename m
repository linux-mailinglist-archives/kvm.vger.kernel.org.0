Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8149164FB44
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLQRaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLQRaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:30:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD0010B79
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:06 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r26so7638834edc.10
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwpytACtFTUC/RCCVxszHsHayCwwETpi4mznRsrQqmo=;
        b=q9rpfkmthKxxuW6rHaOnqVfiWvFgzK5PGeSUipRJV1QIqa3u0MAGQ6Qys66xPuxSZP
         H0jh1q15h+bWSfZwgb4+vFgyvIXMP5e1+Sx0AxjMXwC6XQKvSUQP+kSvHDLbDwFBTPk2
         3uU4lrSfWgQDRruRUcXgqquQzX4ufy3j1G6VBgt2xLdFuSv1Mm16od+7dcY9mhaiMmvV
         fz8BIpLUgjpLhtX1hCH0Otw5vSwRKxQMHlklmuRya8uZpRAjlSNeYfcCzFRpkq8ttg/V
         bIuWdRqlN3oJaxJstWjnMCTFiA2Op5aV4ywl1vd35ovRTML772QLPUywQ3vJ4wqywWK4
         SPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwpytACtFTUC/RCCVxszHsHayCwwETpi4mznRsrQqmo=;
        b=qZHmZnPOoieXFMBTlPQbTYZ8Ouop5PXM5d0BCop9tjhbAhW+BHNt+Q+fY1nO4GRDAr
         Zx3rSKgJsV9byufyGREPe5Ev1n77wuNw+2J5y7N8du6i9U9H5GkAoVPzNadWzyZ01qGZ
         xAopo9POTTLbOUQsIgNNk3ufDLcgwl2aoUdkhGzbTWz63w6urLLCF4vOQ4QBkhrBnVIZ
         iVYQDpr4X3XwMagIPr8wbfjZsTKY72sCay/q/AaoHvWYZNUjz4OdDEkWC/6fygv/KT5i
         jg1JhrUpDSWOlrpz2o7ziDfTI1IL1iEKGAb7PQ8oTHQUXtWup2ontd2I8uVbm+Oew3sg
         mSzg==
X-Gm-Message-State: AFqh2kqMwEpTWCYN7teR47PX4WqjTqEhjF+n5b5pTCw8Yc3HcX8Cv6uD
        iXAAnzWsuoAhgu7uPUDUY3SXMxdVOeyh8ID3dn8=
X-Google-Smtp-Source: AMrXdXuD74hen3gOMG0Mtx6HB8RJMosagqHCbiCmQb2DlBS8zHc7n0GDAt0b22b8j5MZRNaRaVx3Xw==
X-Received: by 2002:a05:6402:5299:b0:45c:835b:9461 with SMTP id en25-20020a056402529900b0045c835b9461mr8740204edb.29.1671298204723;
        Sat, 17 Dec 2022 09:30:04 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id q9-20020aa7d449000000b004677b1b1a70sm2161497edr.61.2022.12.17.09.30.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:30:04 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>, qemu-riscv@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 6/9] target/riscv/cpu: Move Floating-Point fields closer
Date:   Sat, 17 Dec 2022 18:29:04 +0100
Message-Id: <20221217172907.8364-7-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217172907.8364-1-philmd@linaro.org>
References: <20221217172907.8364-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/cpu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index fc1f72e5c3..05fafebff7 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -143,7 +143,6 @@ typedef struct PMUCTRState {
 struct CPUArchState {
     target_ulong gpr[32];
     target_ulong gprh[32]; /* 64 top bits of the 128-bit registers */
-    uint64_t fpr[32]; /* assume both F and D extensions */
 
     /* vector coprocessor state. */
     uint64_t vreg[32 * RV_VLEN_MAX / 64] QEMU_ALIGNED(16);
@@ -158,7 +157,10 @@ struct CPUArchState {
     target_ulong load_res;
     target_ulong load_val;
 
+    /* Floating-Point state */
+    uint64_t fpr[32]; /* assume both F and D extensions */
     target_ulong frm;
+    float_status fp_status;
 
     target_ulong badaddr;
     target_ulong bins;
@@ -372,8 +374,6 @@ struct CPUArchState {
     target_ulong cur_pmmask;
     target_ulong cur_pmbase;
 
-    float_status fp_status;
-
     /* Fields from here on are preserved across CPU reset. */
     QEMUTimer *stimer; /* Internal timer for S-mode interrupt */
     QEMUTimer *vstimer; /* Internal timer for VS-mode interrupt */
-- 
2.38.1

