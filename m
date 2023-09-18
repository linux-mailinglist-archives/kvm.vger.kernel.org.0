Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75777A4F70
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjIRQme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjIRQmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:18 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BFB1731
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bcb50e194dso74354761fa.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053075; x=1695657875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLYCBr4NSqb4Srk/T+P7jn9AmbCAT10Txre246ezJ94=;
        b=HSf8yjt+bOEHTC6NTjwv+GgSjKmm2P2WIHZxcE+NB6tWgKVoLUa7xZoHQAkFGoOGF5
         Q/9L20OSiVwS52pn8lA3XnA2L76kXOtnSP3+dWErpWjOofbboanjUsElPOEOdzWehtUw
         SaOlYj3kTOSdgTxj3KfxbhMYUQmmSNVNwzsa9HtoQmhhinVq5ptynNYrmK2OCOx9Ilrh
         +ADqGU7FM+UEfbKoIxullyZX43SruP38qLJoHJIGISuJhcUJfdBvLfh6yf8z/zuFW5SY
         7Csu/fiqqwEaVMPfxNVnPc7FxHGyeJbBTvPoZ+/Z7s6yHUXaNvUJTjAgXDNatqkU3o1F
         D/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053075; x=1695657875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CLYCBr4NSqb4Srk/T+P7jn9AmbCAT10Txre246ezJ94=;
        b=wdsgV5qoI0DdUImXTPnLnYXCZja/YUoUV7BIJpGNhYWhjnAyyLjpY0LKGqy/lGiYn7
         QvWjjxbNw3t65RXyTVErNMKInTXdwK/wr0ZRxgK4BS9Fb0EjWvXpr1ITBC0x2orm9g2e
         C86JPASzFPAdV+8A1vmgSgSdNTjka5pNoFTf1SPRhs7MvB1WMDzFr/7qPhfdE/8x70+f
         UmwQYDDgBQdlJ0xwXxxQ9n4RT0ppeJIsd+XOR1kitnifsa3UQ7dzfOqmjc6Q/8Q8T1m/
         XYBkxodXNn22pNqeJQlrscRA6wIMPN0npCMPS1lHqf1hiVOAHYt799coYRxKwBHWMql5
         lB9Q==
X-Gm-Message-State: AOJu0YwspqAzyh0WDc+9p8RnnlS7tr0WWvoI5k8P+DndsP+0KkL/HIjn
        J/gPYWvPoiSdproF5lEGLJLang==
X-Google-Smtp-Source: AGHT+IEszpq6z0T8KHVLe1aYl3TXIxtDx0wMS/QiHJe0YDjbBZ7toGFiwcuS0GxUEQgehFRPXlIxjg==
X-Received: by 2002:a2e:8046:0:b0:2bc:b821:84ad with SMTP id p6-20020a2e8046000000b002bcb82184admr8047755ljg.16.1695053075234;
        Mon, 18 Sep 2023 09:04:35 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id f10-20020a170906560a00b0099d0c0bb92bsm6569110ejq.80.2023.09.18.09.04.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:34 -0700 (PDT)
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
Subject: [PATCH 18/22] target/s390x: Call s390_cpu_realize_sysemu from s390_realize_cpu_model
Date:   Mon, 18 Sep 2023 18:02:51 +0200
Message-ID: <20230918160257.30127-19-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390_cpu_realize_sysemu() runs some checks for the TCG accelerator,
previous to creating the vCPU. s390_realize_cpu_model() also does
run some checks for KVM.
Move the sysemu call to s390_realize_cpu_model(). Having a single
call before cpu_exec_realizefn() will allow us to factor a
verify_accel_features() handler out in a pair of commits.

Directly pass a S390CPU* to s390_cpu_realize_sysemu() to simplify.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/s390x-internal.h | 2 +-
 target/s390x/cpu-sysemu.c     | 3 +--
 target/s390x/cpu.c            | 6 ------
 target/s390x/cpu_models.c     | 4 ++++
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/target/s390x/s390x-internal.h b/target/s390x/s390x-internal.h
index 825252d728..781ac08458 100644
--- a/target/s390x/s390x-internal.h
+++ b/target/s390x/s390x-internal.h
@@ -241,7 +241,7 @@ uint32_t calc_cc(CPUS390XState *env, uint32_t cc_op, uint64_t src, uint64_t dst,
 unsigned int s390_cpu_halt(S390CPU *cpu);
 void s390_cpu_unhalt(S390CPU *cpu);
 void s390_cpu_init_sysemu(Object *obj);
-bool s390_cpu_realize_sysemu(DeviceState *dev, Error **errp);
+bool s390_cpu_realize_sysemu(S390CPU *cpu, Error **errp);
 void s390_cpu_finalize(Object *obj);
 void s390_cpu_class_init_sysemu(CPUClass *cc);
 void s390_cpu_machine_reset_cb(void *opaque);
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 8112561e5e..5178736c46 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -122,9 +122,8 @@ void s390_cpu_init_sysemu(Object *obj)
     s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu);
 }
 
-bool s390_cpu_realize_sysemu(DeviceState *dev, Error **errp)
+bool s390_cpu_realize_sysemu(S390CPU *cpu, Error **errp)
 {
-    S390CPU *cpu = S390_CPU(dev);
     MachineState *ms = MACHINE(qdev_get_machine());
     unsigned int max_cpus = ms->smp.max_cpus;
 
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 416ac6c4e0..7257d4bc19 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -237,12 +237,6 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
         goto out;
     }
 
-#if !defined(CONFIG_USER_ONLY)
-    if (!s390_cpu_realize_sysemu(dev, &err)) {
-        goto out;
-    }
-#endif
-
     cpu_exec_realizefn(cs, &err);
     if (err != NULL) {
         goto out;
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 98f14c09c2..f030be0d55 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -612,6 +612,10 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
         cpu->env.cpuid = deposit64(cpu->env.cpuid, CPU_PHYS_ADDR_SHIFT,
                                    CPU_PHYS_ADDR_BITS, cpu->env.core_id);
     }
+
+    if (!s390_cpu_realize_sysemu(cpu, &err)) {
+        return;
+    }
 #endif
 }
 
-- 
2.41.0

