Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71628746282
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjGCSdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjGCSdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:33:52 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA45210E5
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:33:37 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbc244d39dso61088875e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409216; x=1691001216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ckg/85qiN6gI5pyiRTX4xzKyUkymMYXNoWwRj2IvYvQ=;
        b=rZq4AVOmPly186wO8fVY9rb7E+75gT1CaBAZ5pLcZ9zFVP9+r7eKj929w0iJRYl1nh
         mK+ZeU4SVogjL/yaq7XXtuTiMTML1e0XLQhEyTSWBtFnzAXK1/7cmsfX4VUomBGzWTz5
         eACMkTC8miiWXovkzrpq9irqj8VqnUF8MxUU+wp/sg39MVfM/Z/nWF8EAyiUW/SNDS1X
         RlBMojFJG2HjwKINFjZUAaNdTLKbuaoKAsQBTVHVbPwzy8Bop8LD5vUf27I39RCaFRnh
         HHvppzM5q17r5amEmiTAQfMNMRV1sOKgXgBp6zM5AptZSygF5lemQENWqzQUSXPkrU4/
         8LzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409216; x=1691001216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ckg/85qiN6gI5pyiRTX4xzKyUkymMYXNoWwRj2IvYvQ=;
        b=luF+IAim9XaZlBAmQ2LYX+65leRCc5a1fJvTlzoBxNdWd80UvTvVcnTwTXa7J6cXiT
         fQaevwwNLzfD08D7OIQVJn5i0DTwyh/iDGe8dK/GurkzZ4iD0bl7CO9XlENYZHDMB7lq
         YSo7wOiwCL5ClXVtbZhc4ApuLMXt38kHlJCy9MAvZbjsSofL/s0HyYHd/FMCtx4qHhBq
         aqolSHNY3IepJOpi/Pyz3dPD/NZ8ZksKHZK6zb7QHLny+p1mpsiUpoL73Fbo99UotGQs
         4BcHd2KzSRoT0w6bk9cpH8OYOs+A0H5gJCpohc4rRK8AaIZLNvFvCLzrZW8WB9QoX6KT
         HfpA==
X-Gm-Message-State: AC+VfDy4UXpZBMgoj6LHLun3sAYAUqczJSWrYrY2rpUTUvIEFCkw4+AD
        +1McBtU8/HC22TwzBOR4t3D9SA==
X-Google-Smtp-Source: ACHHUZ73wihO7mepuWylWzji6mQoWD6CbwMkFLZ/C/6C43GThLV/R0+WGKdMwtw9c1hR1bVu3kVc8w==
X-Received: by 2002:a05:600c:22d4:b0:3fa:fe34:f80 with SMTP id 20-20020a05600c22d400b003fafe340f80mr13892838wmg.39.1688409216342;
        Mon, 03 Jul 2023 11:33:36 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003fbdd9c72aasm1201327wmc.21.2023.07.03.11.33.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:33:36 -0700 (PDT)
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
Subject: [PATCH v2 16/16] gitlab-ci.d/crossbuilds: Add KVM riscv64 cross-build jobs
Date:   Mon,  3 Jul 2023 20:31:45 +0200
Message-Id: <20230703183145.24779-17-philmd@linaro.org>
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

Add a new job to cross-build the riscv64 target without
the TCG accelerator (IOW: only KVM accelerator enabled).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 .gitlab-ci.d/crossbuilds.yml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index b6ec99ecd1..588ef4ebcb 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -129,6 +129,14 @@ cross-riscv64-user:
   variables:
     IMAGE: debian-riscv64-cross
 
+cross-riscv64-kvm-only:
+  extends: .cross_accel_build_job
+  needs:
+    job: riscv64-debian-cross-container
+  variables:
+    IMAGE: debian-riscv64-cross
+    EXTRA_CONFIGURE_OPTS: --disable-tcg --without-default-features
+
 cross-s390x-system:
   extends: .cross_system_build_job
   needs:
-- 
2.38.1

