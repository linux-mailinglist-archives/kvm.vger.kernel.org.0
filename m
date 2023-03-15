Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AF56BBB50
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCORtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCORte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBE72D63
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id ay8so7868144wmb.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ftomCMN9D7t/TUiloNrLyUYQ5fiuNqGTG1HcraBz2M=;
        b=v7vvvpLKuTVpAv8ps0Pq5QZaS+C/K2Uzyy9Kd6A4+ihyL3N/1JJjYNSBZX1ycukERb
         pzkJE41/Wmw+JG7EXuGc6a/1wIxEyLt1aaQE9yoI2DkJwYs8LZRNJXWC5yq1FAvDAV+O
         sBqPXOMx4lGGFNGlrtJ54AiimM7+1gfDjheacUJLzuvhR+G/ru6tIsq3SXerh3MvtZ7h
         nwtNXrBQejuD7vBhdIzyceekpMqTpqbUdZPYYnLjeItExVL7ThO6fD9v2jBp4rzwrvaQ
         BVUOt2P8vzX53Mnj7E+vRXdiGWZQuYHcntDQiFtMsPp3ooJAlPckNZGCH2qooPfqSaTy
         isFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ftomCMN9D7t/TUiloNrLyUYQ5fiuNqGTG1HcraBz2M=;
        b=IzBoDYh3yZqiwH+6Z3kCPPHsFLs8r0Je/WjzCI5wjbW0h4pScn7gRKRt7a/TElxf9g
         R/amjO3whu1U3l7aRStr0HaLTdHDZz8cuVwkR9Y4loS9lcb2202zu0HRd4AwMeiFs7+H
         imSOMGS+3qQ8dREEQjpXob1ipku5HdJgWHxoHKqJgtxgv+tSutlmZ79bkzGFEdh9nxFm
         KXJs/1B7NXbCJ0mlvzTwg+NoXVZxKdqrcjZ3tptg229JKjuc+24x81C1Uu3M/ra9Kqwo
         6pYMMItSbtxrhGxXWx4ItiAdvLABARgTogPXO2XP2MgxdQMs91cYRXYruoHkBFXx9Qrl
         H6Mw==
X-Gm-Message-State: AO0yUKVBj8alGMvlNWpZ9go7Zf/dnF4iXlEnpIxGohzr6077kGcyxJFn
        Or7KENxdJwATBBUcyi43oGbiSg==
X-Google-Smtp-Source: AK7set8JtIuEx//jAiNhlJj0XnNqFx04qTek68RZ7RgO6gQQhIO0Ms5ttVe/kgRLquaXuy8XAcWOBA==
X-Received: by 2002:a05:600c:46c6:b0:3eb:13d2:c32c with SMTP id q6-20020a05600c46c600b003eb13d2c32cmr18415937wmo.40.1678902559792;
        Wed, 15 Mar 2023 10:49:19 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x2-20020a05600c21c200b003e1f2e43a1csm2491206wmj.48.2023.03.15.10.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:19 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9D4761FFC3;
        Wed, 15 Mar 2023 17:43:32 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 12/32] tcg: Drop plugin_gen_disable_mem_helpers from tcg_gen_exit_tb
Date:   Wed, 15 Mar 2023 17:43:11 +0000
Message-Id: <20230315174331.2959-13-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

Now that we call qemu_plugin_disable_mem_helpers in cpu_tb_exec,
we don't need to do this in generated code as well.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230310195252.210956-3-richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tcg/tcg-op.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tcg/tcg-op.c b/tcg/tcg-op.c
index ddab20a6a6..3136cef81a 100644
--- a/tcg/tcg-op.c
+++ b/tcg/tcg-op.c
@@ -2808,7 +2808,6 @@ void tcg_gen_exit_tb(const TranslationBlock *tb, unsigned idx)
         tcg_debug_assert(idx == TB_EXIT_REQUESTED);
     }
 
-    plugin_gen_disable_mem_helpers();
     tcg_gen_op1i(INDEX_op_exit_tb, val);
 }
 
-- 
2.39.2

