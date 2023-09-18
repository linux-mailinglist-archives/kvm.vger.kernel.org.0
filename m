Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8129B7A4E07
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjIRQFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjIRQFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:05:10 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A03E49E6
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9adb9fa7200so949020766b.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053006; x=1695657806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rh71yvz4DZJTCq6SFL6CUf5QPqPF3br4cLaD1F+Juuo=;
        b=PQpQM4mipbPGLqFAxeL6U4c1HXIW83jmGHwm4R1nMgpJjq29HBc+INIqN4cU6FAd8w
         /3PGymzlP1/b/IpSVMP7olBZFpU5T0DssF8ZRMm8f39pyws/zjNywnm8wIwBKgasvPj3
         OcVlqfnL36ykHCgzZda7K/kwMcK19F1dConZSa1pJOWq+XPyP2UNo26phn10CsptGTdt
         VK1sAJcndbba3yy33Rfz4PqT2Xg0Y3N2qE5VEgs5XyseQPOoRuC/RBj0c6DTiK02MIyM
         uyjsXORDb6Tu2/ShoJSGYXXYml2PIJNq4UPMuk9/d8iDSFARU+bQV60W9v3szIKiB0h1
         35vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053006; x=1695657806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rh71yvz4DZJTCq6SFL6CUf5QPqPF3br4cLaD1F+Juuo=;
        b=juFoRz6mk/2FoIyH0ZU/p3fGzYlIlIGOJhmOx6YNTV1fj8VbtpkXNzphlmX2Oo9uBZ
         zOJlO4t9UeHnhir0ecLxDI/MvE+DHGOyWhRTKk8dxS1ztpMQcTgdSnsCCrboOWy+Ltpm
         ILtnXUDzRHXWL1WI865kSs7GrPh/OA2JQVJDGS6Tw7/bCgSGGSoSP8J78C9qLHCLh6wD
         unoOnpaD0NMo1I4Pn1XkenUqBWBfHkhmks8rz9QwP/20yuGOCXYxhGOT6liKDTgPvkoF
         YIRFir/YuuTQdAv7nd737Wfs+D3U7kIhr2HT2nfg/osIn+hId2o8RreF24n854FlonmX
         w7/w==
X-Gm-Message-State: AOJu0Yx1papM9r+fmi8ZN4FIRvU322SedN+fFVPPzVlGm8nVP/UKitRB
        dDRxUUD1Ro+UhQw9IOhhPvzjHg==
X-Google-Smtp-Source: AGHT+IHIXwv/SUuPL+RG4eoM3NTPC1WqPc2dc059AGReJPi585Aaau6eIEYTrSN5HoNAF0VfnJBfAg==
X-Received: by 2002:a17:907:948d:b0:9aa:1794:945b with SMTP id dm13-20020a170907948d00b009aa1794945bmr143370ejc.22.1695053005806;
        Mon, 18 Sep 2023 09:03:25 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id n8-20020a170906378800b0099cd008c1a4sm6609045ejc.136.2023.09.18.09.03.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:25 -0700 (PDT)
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
Subject: [PATCH 05/22] exec/cpu: Call qemu_init_vcpu() once in cpu_common_realize()
Date:   Mon, 18 Sep 2023 18:02:38 +0200
Message-ID: <20230918160257.30127-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

qemu_init_vcpu() is called in each ${target}_cpu_realize() before
the call to parent_realize(), which is cpu_common_realizefn().
Call it once there.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c    | 3 +++
 target/alpha/cpu.c      | 2 --
 target/arm/cpu.c        | 2 --
 target/avr/cpu.c        | 1 -
 target/cris/cpu.c       | 2 --
 target/hexagon/cpu.c    | 1 -
 target/hppa/cpu.c       | 1 -
 target/i386/cpu.c       | 4 +---
 target/loongarch/cpu.c  | 2 --
 target/m68k/cpu.c       | 2 --
 target/microblaze/cpu.c | 2 --
 target/mips/cpu.c       | 2 --
 target/nios2/cpu.c      | 1 -
 target/openrisc/cpu.c   | 2 --
 target/ppc/cpu_init.c   | 1 -
 target/riscv/cpu.c      | 2 --
 target/rx/cpu.c         | 2 --
 target/s390x/cpu.c      | 1 -
 target/sh4/cpu.c        | 2 --
 target/sparc/cpu.c      | 2 --
 target/tricore/cpu.c    | 1 -
 target/xtensa/cpu.c     | 2 --
 22 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index ced66c2b34..a3b8de7054 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -204,6 +204,9 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
+    /* Create CPU address space and vCPU thread */
+    qemu_init_vcpu(cpu);
+
     if (dev->hotplugged) {
         cpu_synchronize_post_init(cpu);
         cpu_resume(cpu);
diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index 270ae787b1..eb78318bb8 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -82,8 +82,6 @@ static void alpha_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     acc->parent_realize(dev, errp);
 }
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 6aca036b85..fc3772025c 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2277,8 +2277,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
-    qemu_init_vcpu(cs);
-
     acc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index 84d353f30e..d3460b3960 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -119,7 +119,6 @@ static void avr_cpu_realizefn(DeviceState *dev, Error **errp)
         error_propagate(errp, local_err);
         return;
     }
-    qemu_init_vcpu(cs);
 
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 079872a5cc..671693a362 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -152,8 +152,6 @@ static void cris_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     ccc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index 7edc32701f..5b9bb3fe83 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -345,7 +345,6 @@ static void hexagon_cpu_realize(DeviceState *dev, Error **errp)
                              NUM_VREGS + NUM_QREGS,
                              "hexagon-hvx.xml", 0);
 
-    qemu_init_vcpu(cs);
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index 11022f9c99..49082bd2ba 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -131,7 +131,6 @@ static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
     acc->parent_realize(dev, errp);
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7faaa6915f..cb41d30aab 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7425,15 +7425,13 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     mce_init(cpu);
 
-    qemu_init_vcpu(cs);
-
     /*
      * Most Intel and certain AMD CPUs support hyperthreading. Even though QEMU
      * fixes this issue by adjusting CPUID_0000_0001_EBX and CPUID_8000_0008_ECX
      * based on inputs (sockets,cores,threads), it is still better to give
      * users a warning.
      *
-     * NOTE: the following code has to follow qemu_init_vcpu(). Otherwise
+     * NOTE: the following code has to follow cpu_common_realize(). Otherwise
      * cs->nr_threads hasn't be populated yet and the checking is incorrect.
      */
     if (IS_AMD_CPU(env) &&
diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 8029e70e76..dc0ac39833 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -565,8 +565,6 @@ static void loongarch_cpu_realizefn(DeviceState *dev, Error **errp)
 
     loongarch_cpu_register_gdb_regs_for_features(cs);
 
-    qemu_init_vcpu(cs);
-
     lacc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 2bc0a62f0e..3da316bc30 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -321,8 +321,6 @@ static void m68k_cpu_realizefn(DeviceState *dev, Error **errp)
 
     m68k_cpu_init_gdb(cpu);
 
-    qemu_init_vcpu(cs);
-
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
index 03c2c4db1f..1f19a6e07d 100644
--- a/target/microblaze/cpu.c
+++ b/target/microblaze/cpu.c
@@ -221,8 +221,6 @@ static void mb_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     version = cpu->cfg.version ? cpu->cfg.version : DEFAULT_CPU_VERSION;
     for (i = 0; mb_cpu_lookup[i].name && version; i++) {
         if (strcmp(mb_cpu_lookup[i].name, version) == 0) {
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 8d6f633f72..0aea69aaf9 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -492,8 +492,6 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
     fpu_init(env, env->cpu_model);
     mvp_init(env);
 
-    qemu_init_vcpu(cs);
-
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index 876a6dcad2..7a92fc5f2c 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -216,7 +216,6 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
     realize_cr_status(cs);
-    qemu_init_vcpu(cs);
 
     /* We have reserved storage for cpuid; might as well use it. */
     cpu->env.ctrl[CR_CPUID] = cs->cpu_index;
diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index cd25f1e9d5..e4ec95ca7f 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -141,8 +141,6 @@ static void openrisc_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     occ->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 7ab5ee92d9..e2c06c1f32 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -6833,7 +6833,6 @@ static void ppc_cpu_realize(DeviceState *dev, Error **errp)
     init_ppc_proc(cpu);
 
     ppc_gdb_init(cs, pcc);
-    qemu_init_vcpu(cs);
 
     pcc->parent_realize(dev, errp);
 
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 7566757346..4f7ae55359 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -1531,8 +1531,6 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
     }
 #endif
 
-    qemu_init_vcpu(cs);
-
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index c9c8443cbd..089df61790 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -137,8 +137,6 @@ static void rx_cpu_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     rcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 0f0b11fd73..416ac6c4e0 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -252,7 +252,6 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
     qemu_register_reset(s390_cpu_machine_reset_cb, S390_CPU(dev));
 #endif
     s390_cpu_gdb_init(cs);
-    qemu_init_vcpu(cs);
 
     scc->parent_realize(dev, &err);
     /*
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 656d71f74a..e6690daf9a 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -228,8 +228,6 @@ static void superh_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     scc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index 130ab8f578..2fdc95eda9 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -782,8 +782,6 @@ static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    qemu_init_vcpu(cs);
-
     scc->parent_realize(dev, errp);
 }
 
diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index a3610aecca..0142cf556d 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -118,7 +118,6 @@ static void tricore_cpu_realizefn(DeviceState *dev, Error **errp)
     if (tricore_has_feature(env, TRICORE_FEATURE_131)) {
         set_feature(env, TRICORE_FEATURE_13);
     }
-    qemu_init_vcpu(cs);
 
     tcc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index acaf8c905f..300d19d45c 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -174,8 +174,6 @@ static void xtensa_cpu_realizefn(DeviceState *dev, Error **errp)
 
     cs->gdb_num_regs = xcc->config->gdb_regmap.num_regs;
 
-    qemu_init_vcpu(cs);
-
     xcc->parent_realize(dev, errp);
 }
 
-- 
2.41.0

