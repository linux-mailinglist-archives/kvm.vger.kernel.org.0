Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0297A50D1
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjIRQeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjIRQd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:33:58 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E9176A0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9936b3d0286so628935666b.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053518; x=1695658318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJh8A0itxnh0qEmv9jrQE8icd48ukduXjwQKR8H2Trw=;
        b=OhFKFbNTncaL0FlWnpvOsuT/+oearkCPJNKMPMW0lC73rlwj0g580fuUJa0uy1arfI
         LQUSkgp0GSK5RaEwXfKwVod8Y184Om55a8Uoj2r0LR1CuPMh7e4uOEqRhrth3CvbTRZN
         2+jjC8ade+R7I2Zfq69hXxfFQ4LmJhPCptZtTPPkUWSUqpkLGS8bQ03cQ0OTmlksWLkg
         aA3c9tnTkY2AqMJ/UQ62Jc73nINyV99ndkw9LJe1spNu23WEyJUTukdkPwOq8eahOUD5
         GEm8oK+iIQeC8lWZhD744Lp96GvibrtDusJJ9a+xpKaprb4XdL0vDvcqXEyrx3q3y94K
         GF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053518; x=1695658318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJh8A0itxnh0qEmv9jrQE8icd48ukduXjwQKR8H2Trw=;
        b=tO8cn3Oj+G3/rMwIZNM4ZLEMXoxqfdVG9y1vaLYPOxVs87aLPEj58Ngw2PW4B9sHga
         B7FN5bvjjIslELNxNdvHaSsmGkckunhgbFGSlH8TftKphLUqsR3IL/QpCR7PUdRLgoEo
         LNx0jNjZhIIPGilBL+OecTkL6BiFMwJoii2yalLT34usqusyvwEj8kylDQnEKkkeGDbW
         H6jymG1+mu0Pe75u5C/EYDrAJj+JeZVlBkxJ7pMelan6RYpRYlDridnFPAWoGcFsR5rw
         GXlMccVO7yvqSVfrfw1ZWUlGfnLTN2x72g8g2GY0taMUTbMUPboFIF7epJK0cThH8Mh1
         5bOQ==
X-Gm-Message-State: AOJu0Yx6lTNSplfXzhmIPuyYBVWWe9aFpkjKSl8BXDyPgorr2j0ZtQKy
        OVLz7IV+mNOsJLa3mf9SbKi1Pjwxbm7nlzTNJyPPt+Qy
X-Google-Smtp-Source: AGHT+IENcyvi+doZG3AFC4PIQIYrRhEsNXfli8+UC+v7xx7kqnWdf8S7ahUZm+Cso8ML7TazVXsAxw==
X-Received: by 2002:a17:907:7754:b0:9ae:1b64:94c0 with SMTP id kx20-20020a170907775400b009ae1b6494c0mr1603066ejc.55.1695052989741;
        Mon, 18 Sep 2023 09:03:09 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id y16-20020a170906559000b0099b7276235esm6699286ejp.93.2023.09.18.09.03.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:09 -0700 (PDT)
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
Subject: [PATCH 02/22] hw/intc/apic: Pass CPU using QOM link property
Date:   Mon, 18 Sep 2023 18:02:35 +0200
Message-ID: <20230918160257.30127-3-philmd@linaro.org>
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

QOM objects shouldn't access each other internals fields
except using the QOM API.

Declare the 'cpu' and 'base-addr' properties, set them
using object_property_set_link() and qdev_prop_set_uint32()
respectively.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/intc/apic_common.c    |  2 ++
 target/i386/cpu-sysemu.c | 11 ++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 68ad30e2f5..e28f7402ab 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -394,6 +394,8 @@ static Property apic_properties_common[] = {
                     true),
     DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_instance_id,
                      false),
+    DEFINE_PROP_LINK("cpu", APICCommonState, cpu, TYPE_X86_CPU, X86CPU *),
+    DEFINE_PROP_UINT32("base-addr", APICCommonState, apicbase, 0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
index 6a164d3769..6edfb7e2af 100644
--- a/target/i386/cpu-sysemu.c
+++ b/target/i386/cpu-sysemu.c
@@ -269,7 +269,6 @@ APICCommonClass *apic_get_class(Error **errp)
 
 void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
 {
-    APICCommonState *apic;
     APICCommonClass *apic_class = apic_get_class(errp);
 
     assert(apic_class);
@@ -279,11 +278,13 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
                               OBJECT(cpu->apic_state));
     object_unref(OBJECT(cpu->apic_state));
 
+    if (!object_property_set_link(OBJECT(cpu->apic_state), "cpu",
+                                  OBJECT(cpu), errp)) {
+        return;
+    }
     qdev_prop_set_uint32(cpu->apic_state, "id", cpu->apic_id);
-    /* TODO: convert to link<> */
-    apic = APIC_COMMON(cpu->apic_state);
-    apic->cpu = cpu;
-    apic->apicbase = APIC_DEFAULT_ADDRESS | MSR_IA32_APICBASE_ENABLE;
+    qdev_prop_set_uint32(cpu->apic_state, "base-addr",
+                         APIC_DEFAULT_ADDRESS | MSR_IA32_APICBASE_ENABLE);
 }
 
 void x86_cpu_apic_realize(X86CPU *cpu, Error **errp)
-- 
2.41.0

