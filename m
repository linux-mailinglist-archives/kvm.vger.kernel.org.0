Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1917A4F31
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjIRQfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjIRQfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:35:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3357DBB
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:29 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40476ce8b2fso40864245e9.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053548; x=1695658348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7slh/pNTWelLfh1FzXsOutH1+zxCT/FLHdOf8nTB6I=;
        b=q0KcQo2KVWnKZDombc6Jx6vXOjJ0S4RVxmLvSf7KN8Ej5/rjHLk1JjIegT6TQ67xPr
         +YBD9iADYzlVmF9tDkYp6hqlkKPmtmKS/d4Rpx68Z5Nx6n0hvPS1s47L6GsileLFvXHj
         rbaHG3HBTbeCTbPQXKFF/ebujU1ywy1UpLF8ScvX70f0Pd++AZt+bO9AawAb/hdUsA2C
         lK09ewdbTwHS9t8aImPtH9+E4ieyxOJ1A0yPP17b+3DKnIjC4uSe7R7cbpcXg3jHR6ZX
         tiJu9DobWPaCKOmVP375GLnJImOdIogdqZ61t1od1P+X1PK6x5Fl7xG4xRU7/pUlO5uk
         NL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053548; x=1695658348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7slh/pNTWelLfh1FzXsOutH1+zxCT/FLHdOf8nTB6I=;
        b=OnXdnRllB8r69DVEdEsPKbdtcpjp531CE9CDg6rrhVPXk3hP5OI2++ER8cBMhKBSdG
         IVIBuJ2xI84/VdMOmoaP0jAHyu8rU6jEDIQg8HXONSh/kiLngERbA16Pjm3Smj24wwrx
         E1mNAjKxZfv2IaPJhQQtAHwMhpVna+vX0zU8/0w0CjHaDbFGpje+k7kx9hZgjtwQh15J
         tWmW/ipzvguvWjZhZiT1KKX3v5dvLkBkzqguuthBxDtAjMGKA1XiqGwrona0pDR/w9CM
         eTNQjzDXg+gYKg2Qe3G5pq1ttVKFblw2QQpNmmBX18X5N7EVCq06OULD1m5DjOxTnFe0
         srmw==
X-Gm-Message-State: AOJu0YxSqFT9R/2v9kL9YhUqxOxPguwlVIU7y1ZFdXlc0QKUBw2EnksE
        /D6t7+Rn5SkB335AuR5fmSoN+zDEww3NSBgtrRS8kZ5I
X-Google-Smtp-Source: AGHT+IF1uzqoMGcGEAlyaETsh01GEqG5TP+8vhZBqOT31xYKgtT4aKTdO73/67eFYWfUVkYSZ8Rjqw==
X-Received: by 2002:a17:907:75f1:b0:9a5:cc73:a2a5 with SMTP id jz17-20020a17090775f100b009a5cc73a2a5mr6784701ejc.1.1695053085243;
        Mon, 18 Sep 2023 09:04:45 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id lt10-20020a170906fa8a00b009737b8d47b6sm6568567ejb.203.2023.09.18.09.04.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:44 -0700 (PDT)
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
Subject: [PATCH 20/22] target/s390x: Use s390_realize_cpu_model() as verify_accel_features()
Date:   Mon, 18 Sep 2023 18:02:53 +0200
Message-ID: <20230918160257.30127-21-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390_realize_cpu_model() checks if CPU model and definitions
are compatible with the KVM / TCG accelerators, before realizing
the vCPU. Use it directly as CPUClass::verify_accel_features()
handler (called from cpu_exec_realizefn()).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/cpu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 1a44a6d2b2..983dbfe563 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -231,11 +231,6 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
     S390CPUClass *scc = S390_CPU_GET_CLASS(dev);
     Error *err = NULL;
 
-    /* the model has to be realized before qemu_init_vcpu() due to kvm */
-    if (!s390_realize_cpu_model(cs, &err)) {
-        goto out;
-    }
-
     cpu_exec_realizefn(cs, &err);
     if (err != NULL) {
         goto out;
@@ -329,6 +324,7 @@ static void s390_cpu_class_init(ObjectClass *oc, void *data)
 
     scc->reset = s390_cpu_reset;
     cc->class_by_name = s390_cpu_class_by_name,
+    cc->verify_accel_features = s390_realize_cpu_model;
     cc->has_work = s390_cpu_has_work;
     cc->dump_state = s390_cpu_dump_state;
     cc->query_cpu_fast = s390_query_cpu_fast;
-- 
2.41.0

