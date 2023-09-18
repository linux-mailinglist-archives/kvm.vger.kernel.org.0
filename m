Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3267A4F71
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjIRQmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjIRQmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9B1727
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:02 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-986d8332f50so638393166b.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053058; x=1695657858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjaIM1Qc6nHbnxZLIT5jjyB717NwyoCy1EteOD4KAlE=;
        b=qqBtnTQUBVmH8Adkd4X0AhyVbVdXNfDZG7t+B+TYQZRDL7XyxOYC7aVG7vGmpOcdvw
         /dpFyQz3B+Y0CwZB2i4kA83dDutQ/8Oto2DYd57Xgys76J5f+DzuLAS052XPDDz4VVV+
         8NSAKywqDq/eAHyTJdB/QkRIdm5eCJmhNjYk8qzyBRQCx1eI33wigqXiJ6UPbH2PCIDZ
         b5wudXt3L564M5SnITjPQ6ZR1xmLX3K6pPd16gIU1LswPcQx7fgU/S2Gy4n9XJgYy1Op
         lK1XXNIwQB1/wcS/+0k+40VEhvO5qZlVQdkGr4tyr5ZKU/gC4ys46tAaE8fsIU9BZ1Mt
         Sxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053058; x=1695657858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjaIM1Qc6nHbnxZLIT5jjyB717NwyoCy1EteOD4KAlE=;
        b=CMEB55ltQnTirQG8OtO98algtqMgip/ELBtllbLbtGAd3vwwD8qLvsZDCKub2Z0bRZ
         EjXZdZtCvT3nDfdvweZGL8nrU7SA4Fc3WQ8Jsdph/zas243bRQGgXz0VcAFbbmQwoOQe
         O+xq9ThWnSqBcJN1qg7kCQrMRuJVSThcuIXVTZ8wv92xv0eZxY2L1w82qM1jNpVGbOi6
         zAJ2EHRe4EaRNwisX7KVGwbf4lZpzytt5D+RIyLLsGPeZlWTvAj2bdbGqaRwtaqEryKo
         ZnZTDQn97c0JbfD2VmSFhtkybxQfJrrM1HLIDasjbIhCKCrQSS3G/v1F8oitgliieP4y
         eW0A==
X-Gm-Message-State: AOJu0Yz2SjeI7KBl/+hDCoM72LijdjD44Aq8pLydxgjxLs5SSWX8v4nA
        Z9/e0ygANcEPyA64+qBaaAXEJg==
X-Google-Smtp-Source: AGHT+IH1BGqTiq3uZIcjIgDgFSn4hEE/bGsbSKhsdURXDBkyUNQTShuSyFgzOD2PM8QK12Z2NIlVUQ==
X-Received: by 2002:a17:907:75f1:b0:9a1:da9a:f1c2 with SMTP id jz17-20020a17090775f100b009a1da9af1c2mr7861010ejc.11.1695053058645;
        Mon, 18 Sep 2023 09:04:18 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906390d00b00982a92a849asm6628019eje.91.2023.09.18.09.04.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:18 -0700 (PDT)
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
Subject: [PATCH 15/22] exec/cpu: Introduce CPUClass::verify_accel_features()
Date:   Mon, 18 Sep 2023 18:02:48 +0200
Message-ID: <20230918160257.30127-16-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some CPUs need to check the requested features are compatible
with the requested accelerator. This has to be done *before*
the accelerator realizes a vCPU.
Introduce the verify_accel_features() handler and call it
just before accel_cpu_realizefn().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 4 ++++
 cpu.c                 | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index c90cf3a162..1e940f6bb5 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -103,6 +103,9 @@ struct SysemuCPUOps;
  * @class_by_name: Callback to map -cpu command line model name to an
  * instantiatable CPU type.
  * @parse_features: Callback to parse command line arguments.
+ * @verify_accel_features: Callback to verify if all requested CPU are
+ *        compatible with the requested accelerator. Called before the
+ *        accelerator realize a vCPU.
  * @reset_dump_flags: #CPUDumpFlags to use for reset logging.
  * @has_work: Callback for checking if there is work to do.
  * @memory_rw_debug: Callback for GDB memory access.
@@ -183,6 +186,7 @@ struct CPUClass {
      * class data that depends on the accelerator, see accel/accel-common.c.
      */
     void (*init_accel_cpu)(struct AccelCPUClass *accel_cpu, CPUClass *cc);
+    bool (*verify_accel_features)(CPUState *cs, Error **errp);
 
     /*
      * Keep non-pointer data at the end to minimize holes.
diff --git a/cpu.c b/cpu.c
index 0769b0b153..84b03c09ac 100644
--- a/cpu.c
+++ b/cpu.c
@@ -136,6 +136,11 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
     /* cache the cpu class for the hotpath */
     cpu->cc = CPU_GET_CLASS(cpu);
 
+    if (cpu->cc->verify_accel_features
+        && !cpu->cc->verify_accel_features(cpu, errp)) {
+        return false;
+    }
+
     if (!accel_cpu_realizefn(cpu, errp)) {
         return;
     }
-- 
2.41.0

