Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42087A4E75
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjIRQSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjIRQSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:18:02 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133CDCF4
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:15 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-5031426b626so2063493e87.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053031; x=1695657831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCQpcHiGYl2b5PMw9sHU7Xzs4il9aZ3go8echWC+OUY=;
        b=TLTCmuWT1Byc58c/W3YshvclXkn1rzKiKOc71GGQ5Bk2pT7sf8FEJsyF0SIs+IMVfb
         qRUQUEkta7xOl0Ih4pJ/U1bC+NG8G8qBM1KW1mXOT/e1QntSODpCut/TbyHPBXCKSe6B
         uLiND/bIvmbu2dlFy2dQTdnKC1FZd8YMnODI9eOFSN8o8h9TtiptpuJXGtgF+PRwo19d
         UuZojQVJhowHgTiB0D5YeybyUpjVHvzXCevl5mK51Jnokr0XdwjPYc5MCdQwjCtMS3Uh
         msfjLT/clsWaBk3E84+l2sS9yQBuSTM9tBMTnqJzVa1123z8tvP0hzFFHzxMY8j+ygZD
         xxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053031; x=1695657831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCQpcHiGYl2b5PMw9sHU7Xzs4il9aZ3go8echWC+OUY=;
        b=XnmDfMnY82A0roHiBO8suwy6ZxuV81Z3omG9C4l8mCuk9iRW1CEEuJ0L+Ku8rq2Seb
         Wy87t2QxV5tCMdFlMa7u0rFum0dPR44loBX1rQiWa/Nob8IXvyzI7AC1L8t3GEETwTq9
         jVlUfCH8yTosvufkEg9MBh7vaeL9fE8XSsL0IY10hY9kwbQ6DTjfeWIhQGCDTHbmvbCe
         2D+qrxdJi2DY/CJ2H5JSaM4FETBDZPhcpoPqnes5k6eFxl7Uv9EN1u7sOoiw+sMUKPsy
         4vIYNOXCcXZZ+hIciln6DRYlugcztc3IVwRz51vT/Hheus2SHTUwr7LNMa3FV3RKmqTh
         Ck/w==
X-Gm-Message-State: AOJu0YyGfyt2Eov3fGjk2GMmT1qJmgEjz6CUjY6EIi7QFfcI7qffgoIV
        oPE5Y0SNnaA8Aok3HVADTgrNdg==
X-Google-Smtp-Source: AGHT+IGy+sW3/rMWVgA+iQsVUNjPLRtt/VMoay0ZFOuWvfTpfSlLeQiHWwG9NxI8+yiSPP5hV5k4jw==
X-Received: by 2002:a05:6512:3a9:b0:4fe:5860:7abf with SMTP id v9-20020a05651203a900b004fe58607abfmr6929316lfp.13.1695053031505;
        Mon, 18 Sep 2023 09:03:51 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id n3-20020a50cc43000000b0053132e5ea61sm913803edi.30.2023.09.18.09.03.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:51 -0700 (PDT)
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
Subject: [PATCH 10/22] target/hppa: Create timer *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:43 +0200
Message-ID: <20230918160257.30127-11-philmd@linaro.org>
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
 target/hppa/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index 49082bd2ba..b0d106b6c7 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -131,8 +131,6 @@ static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    acc->parent_realize(dev, errp);
-
 #ifndef CONFIG_USER_ONLY
     {
         HPPACPU *cpu = HPPA_CPU(cs);
@@ -140,6 +138,8 @@ static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
                                         hppa_cpu_alarm_timer, cpu);
     }
 #endif
+
+    acc->parent_realize(dev, errp);
 }
 
 static void hppa_cpu_initfn(Object *obj)
-- 
2.41.0

