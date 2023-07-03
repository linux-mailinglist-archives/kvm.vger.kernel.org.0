Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1F746268
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjGCScE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjGCScD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:03 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A61A2
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31434226a2eso2495450f8f.1
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409120; x=1691001120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N55U4NP3yl4GvH3dWyOKO0l2DdmIx/ff1ghfMtMlOlU=;
        b=WitXZlHOET0XeyI0S46Q/K7yteKUZtSFQ+dEETzxJvjTxIoDbA2RxizG6FhquwjEZO
         5Z1WWj07NMCsg1VdZbUMSjVm1NB9ZPNTZyWr/KIdl8cUe1zW+cqUeuVntMvGLPcko1dO
         B9bdTnuKqyJB6EorK//ZFtAClhBMwIQGps2XyWMto/r7nyJ7wDsJ8dIxY9KbQHqoGHVp
         /wYVnzqUX0hbj72jYRkWySsgUpWcN/t3UIvvuYFRvqHEvW2I2KcSWdZcmZB0kPjuLsK+
         ZN2xmc3AikkIlyngLtFxwG+M2IkeAp0XGEhOL3WW1Y+ftO0dYz132IfCNalodo+8OpPL
         QItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409120; x=1691001120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N55U4NP3yl4GvH3dWyOKO0l2DdmIx/ff1ghfMtMlOlU=;
        b=bq9KkK0DSk1ZJG5rvnsDTjWly6YrUxu/o4O6aLw48SP7ChVAMAdlW8bECqF5/VwaLa
         wt9mK+rf8DPWokK4td5cEcXu4wh6uT3jsbnsjJerfkN1+AQA6MwZIoOtABP/yqpdSCGE
         wB9sXhQvSGH8klovn+fgSqsC5UPVyZek2cdlegBArjWAb2rPBP3Em3Wh6PSMRcYH7TRo
         nPEfHA/DHXe3vd/SA4+gYg/7o9ZKM5zxvkLWsPbE2qG2aKezYyzuOZAXrVdb7jCQOOIR
         r3iptZotObRsw0VOESScex7K/zfhVmBarXq0ATVM6FNc6yax2Ol7NskvvmlcMIZCpWwz
         z0gQ==
X-Gm-Message-State: ABy/qLZJrqTLSjpvAtu2z2+Wm7WCk0W71wPw+Gr7zYb0rtec6FJaFvdW
        TYwXIfuqT3hdtVsO1mW7j7Wksw==
X-Google-Smtp-Source: APBJJlF6W9TcJobh0g4C5n7RXR5qR3/Fcvv3ZJUkmNWMCWjsCFbrGHQQGW/5pKhjSaVIUc5gsRCnTw==
X-Received: by 2002:adf:f209:0:b0:314:2bd2:9611 with SMTP id p9-20020adff209000000b003142bd29611mr9405839wro.34.1688409120602;
        Mon, 03 Jul 2023 11:32:00 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id z5-20020adfd0c5000000b003143aa0ca8asm1949291wrh.13.2023.07.03.11.31.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:00 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        kvm@vger.kernel.org, qemu-riscv@nongnu.org,
        Bin Meng <bin.meng@windriver.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [PATCH v2 02/16] target/riscv: Remove unused 'instmap.h' header in translate.c
Date:   Mon,  3 Jul 2023 20:31:31 +0200
Message-Id: <20230703183145.24779-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230703183145.24779-1-philmd@linaro.org>
References: <20230703183145.24779-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Acked-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/translate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 621dd99241..e3a6697cd8 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -30,7 +30,6 @@
 #include "exec/log.h"
 #include "semihosting/semihost.h"
 
-#include "instmap.h"
 #include "internals.h"
 
 #define HELPER_H "helper.h"
-- 
2.38.1

