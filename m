Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6627A4E08
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjIRQFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjIRQFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:05:13 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E5170E
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c012232792so14663941fa.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053080; x=1695657880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikcGGGCIJyFk0iGLkDvtO0LMxTWmhw6kUdLFh+619DA=;
        b=E+x5SBB0lz8rH3HI5p89VaIovH2KYbmYY/mn6sDrUSaJz5JGOcESbPt5FCmgS1ho++
         hVFXegbA1enPJS7e10JRsHQWsVgQQcSNR9XfJkMmjM26UzCDMgD1Y5nhTjaRZhVC1o/c
         3Q57+ner0vetyE+HW1Lh4zE7SG/mGeYvptbxqxog60SkjRIpBXJbn47Wi+19+yBynmTi
         hzTKQq252o1hnX+RLBa8d2T3EdkTIXEUkN357NvJNGylnw0NuEdV3DCFy4GhGZIX1tyj
         iOR0cG0l7HxMhL4vJr+wvUkq3GYDhkLtRnkjsaBIcSisynhDHwReVRhjpH7uxoHYwI3o
         jaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053080; x=1695657880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikcGGGCIJyFk0iGLkDvtO0LMxTWmhw6kUdLFh+619DA=;
        b=jX/9U05DhpuGfrGwVU5cr7/geF3U3GlT+GXqFCRmhNXw4cc0gcwSqYKhSdTusrnh6x
         FsjOb0H5DldrP5UfBqIhW0G3XdlxqDQoTs771x26F5/NmRE2t4p4WgIYkhTrqozoiZOf
         HdGn9+qp6sSPH+iALlmS3YA01iNZ9kF36peNu++P3dNqyFT8XhFBfOD+JzdTkvSGVN2k
         DkIaK53lHsS8IAl1c4zTGCFxq4z7QSsZy5FinazkrgC9Vd+kB0eQkuQaWzmooRBmr+W+
         g9B0LbLYyaBQTcMyW+MS5dQNLJmp23RGel9AEvgYv3tZPBSV615ApGeT8uXN1W9s3LJ1
         WMTw==
X-Gm-Message-State: AOJu0YyfGe7nfFvO3U/PCDSTXcnsFv9NjeQgWL77k7Z1A9sLVsljkOC2
        5ObeRn1Thvj2i73JfnINjBULcg==
X-Google-Smtp-Source: AGHT+IHPFOPTiS8G0DN7xrPnBYP1slspvTMlXj8JaMLUiuGi38+IN9Um/ZAXVcnl3VSwqkREENA1iw==
X-Received: by 2002:a2e:9d42:0:b0:2b9:e53f:e1fd with SMTP id y2-20020a2e9d42000000b002b9e53fe1fdmr7980710ljj.34.1695053080249;
        Mon, 18 Sep 2023 09:04:40 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id v24-20020a1709060b5800b0098951bb4dc3sm6599465ejg.184.2023.09.18.09.04.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:39 -0700 (PDT)
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
Subject: [PATCH 19/22] target/s390x: Have s390_realize_cpu_model() return a boolean
Date:   Mon, 18 Sep 2023 18:02:52 +0200
Message-ID: <20230918160257.30127-20-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the example documented since commit e3fe3988d7 ("error:
Document Error API usage rules"), have s390_realize_cpu_model()
return a boolean indicating whether an error is set or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/s390x-internal.h |  2 +-
 target/s390x/cpu.c            |  3 +--
 target/s390x/cpu_models.c     | 12 +++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/target/s390x/s390x-internal.h b/target/s390x/s390x-internal.h
index 781ac08458..67f21f53a9 100644
--- a/target/s390x/s390x-internal.h
+++ b/target/s390x/s390x-internal.h
@@ -260,7 +260,7 @@ static inline void s390_cpu_unhalt(S390CPU *cpu)
 
 /* cpu_models.c */
 void s390_cpu_model_class_register_props(ObjectClass *oc);
-void s390_realize_cpu_model(CPUState *cs, Error **errp);
+bool s390_realize_cpu_model(CPUState *cs, Error **errp);
 S390CPUModel *get_max_cpu_model(Error **errp);
 void apply_cpu_model(const S390CPUModel *model, Error **errp);
 ObjectClass *s390_cpu_class_by_name(const char *name);
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 7257d4bc19..1a44a6d2b2 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -232,8 +232,7 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *err = NULL;
 
     /* the model has to be realized before qemu_init_vcpu() due to kvm */
-    s390_realize_cpu_model(cs, &err);
-    if (err) {
+    if (!s390_realize_cpu_model(cs, &err)) {
         goto out;
     }
 
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index f030be0d55..0605073dc3 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -567,7 +567,7 @@ S390CPUModel *get_max_cpu_model(Error **errp)
     return &max_model;
 }
 
-void s390_realize_cpu_model(CPUState *cs, Error **errp)
+bool s390_realize_cpu_model(CPUState *cs, Error **errp)
 {
     Error *err = NULL;
     S390CPUClass *xcc = S390_CPU_GET_CLASS(cs);
@@ -576,19 +576,19 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
 
     if (xcc->kvm_required && !kvm_enabled()) {
         error_setg(errp, "CPU definition requires KVM");
-        return;
+        return false;
     }
 
     if (!cpu->model) {
         /* no host model support -> perform compatibility stuff */
         apply_cpu_model(NULL, errp);
-        return;
+        return false;
     }
 
     max_model = get_max_cpu_model(errp);
     if (!max_model) {
         error_prepend(errp, "CPU models are not available: ");
-        return;
+        return false;
     }
 
     /* copy over properties that can vary */
@@ -601,7 +601,7 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
     check_compatibility(max_model, cpu->model, &err);
     if (err) {
         error_propagate(errp, err);
-        return;
+        return false;
     }
 
     apply_cpu_model(cpu->model, errp);
@@ -617,6 +617,8 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
         return;
     }
 #endif
+
+    return true;
 }
 
 static void get_feature(Object *obj, Visitor *v, const char *name,
-- 
2.41.0

