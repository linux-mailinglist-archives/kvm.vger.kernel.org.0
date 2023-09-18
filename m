Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127047A4E73
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjIRQSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjIRQR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:17:57 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193DE2D75
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-52a49a42353so5785268a12.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053483; x=1695658283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpBrxdgyPGajszRQj4tnQ2gfsy466T4SLwv71ztnz3k=;
        b=SszZNijQT/yp5ZpkflRip3fRzo82wxbzEfG6dRif3yB6LzHKUlQoqQDa977SuyoTtv
         X54RWNTtemaC0VGVOgjVv9IlQfqL7ovEw15y+NbUqI5W1ofrIl8io0hpNwYPPHN1sgmW
         Y8ntWs/UCeLIZN4X5sSDfBUxhMOOCxrElRUiB9fqkWCXTQcKnIVH3DZXTvr0lJmyBJck
         gbyNKXaDeMI27OA/PK7LEuPmzAdmMBKJ4veQFdLEpZW9b2XQxvHJk8NacQIqFQdQPsxl
         fCrcj2/6TrmhjUMbClUBvsUzkzY6o/vV1h+3s3OYuIOSejQKPM0x7dehBhpN4vumH3go
         IIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053483; x=1695658283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YpBrxdgyPGajszRQj4tnQ2gfsy466T4SLwv71ztnz3k=;
        b=VmLERxGVqm/BlwKIjeOcuK9wwoN6Z5Qr9hxSt8AWWCC0Hsi28+Aft8h1cesEj2mOOq
         vVrJT5uAOQEV/ymReDlKpZLk7ft69/Z4dB3ildjNeJeHSehcWxQsz+r6Xjx9X3LBqVdT
         jPXtUzy4q5xr45FRGrKP3W4PzKtTRaNITswpsXc54Da8ghWrM/DibWevZ722m7Nxy+8X
         3vdBpEftvCb7NGacI613EGMBKeDeJ7fsDWM4oeNg60sSXShF1FFcxQrSTWpa7gbjlIMB
         lmgNj65KSZjjopez9YbFgf9VkfC7U23fe69gzt6O3GO7wiafFb8BH7Su8s5Res++DTYJ
         Mejw==
X-Gm-Message-State: AOJu0YwrKSzSYmZFZQAoh1EMbl4ROo4nlUDZzdkqaWtL5wh0lswJfAbB
        JSCiU9bkdup1UJGZoQhY9Be/xNAvcElB4/U1HHoYU8Xg
X-Google-Smtp-Source: AGHT+IG6EnV1NPtLa02ojf1AOOFHw9u/ZZVKTH8rmKjYxc3URy3huazjFDCLq8lcPx0zxuOm3uW8nA==
X-Received: by 2002:a17:907:2cd8:b0:9a5:c9a4:ba1a with SMTP id hg24-20020a1709072cd800b009a5c9a4ba1amr8408544ejc.59.1695053048266;
        Mon, 18 Sep 2023 09:04:08 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906088400b009928b4e3b9fsm6613541eje.114.2023.09.18.09.04.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 13/22] target/xtensa: Create IRQs *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:46 +0200
Message-ID: <20230918160257.30127-14-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Architecture specific hardware doesn't have a particular dependency
on the accelerator vCPU (created with cpu_exec_realizefn), and can
be initialized *after* the vCPU is realized. Doing so allows further
generic API simplification (in few commits).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/xtensa/cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index 300d19d45c..bbfd2d42a8 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -162,10 +162,6 @@ static void xtensa_cpu_realizefn(DeviceState *dev, Error **errp)
     XtensaCPUClass *xcc = XTENSA_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
-#ifndef CONFIG_USER_ONLY
-    xtensa_irq_init(&XTENSA_CPU(dev)->env);
-#endif
-
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -174,6 +170,10 @@ static void xtensa_cpu_realizefn(DeviceState *dev, Error **errp)
 
     cs->gdb_num_regs = xcc->config->gdb_regmap.num_regs;
 
+#ifndef CONFIG_USER_ONLY
+    xtensa_irq_init(&XTENSA_CPU(dev)->env);
+#endif
+
     xcc->parent_realize(dev, errp);
 }
 
-- 
2.41.0

