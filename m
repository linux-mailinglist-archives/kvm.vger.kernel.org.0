Return-Path: <kvm+bounces-5058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB5181B441
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3592CB259CE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBE7745E6;
	Thu, 21 Dec 2023 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="giDd8T3/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13FF7318D
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40c2bb872e2so6570895e9.3
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155629; x=1703760429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyzb1060eIKZjEB6vFAQrFyjnWMUmf7w7Vsll32FTpM=;
        b=giDd8T3/ZmaQWR4thSeCHlaQTBNpKMXbG5K3aybcn5/UzqE5sb6UaIU7XStOlLC+mw
         lhco9QSbiXWzMHGknIvUEAS03dyHpARVjVzo2rLq2PQedj23CrimsBemZc+a5KnTJqff
         APsLn2/buCrtKNTdBL5tZ6j9h0+E/Zz2M2anF6oreJRSU9A3AQIWlQ1oHaBqJGIONWNd
         ujRqCVLOdoSZBOAxuFM2vrAfgHE1vYrRTh9h+xYyfNSFz/Ym0shZ5Vq0Q/RQnkLdTNsS
         /4ral+F2cE+4EiuZ9ojdpfrKrRD36YSNiYH+eS0TMRCCCIdrhtgHWdyjeA8hv7gzaBhg
         5oWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155629; x=1703760429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyzb1060eIKZjEB6vFAQrFyjnWMUmf7w7Vsll32FTpM=;
        b=qzCGM9mdRNppZFfndrCSrHYY/CrekoSNvCC0uNtJRnhCAVwVi62dT018yUom2puEYi
         BqnpFsdmeVgh44eDFHcMQwaFeP2T7bFyYD/8iR/q4hQqpTzvuqWNV1BdliECf/b35EET
         rxXuOh1ph1OnCRfr/koaempGgt7uB8CtpOPxFfh6tnZWWW2oJGfBtB0PPf1Ci1N2E1QW
         0QH5bZYNlz7398Yw4lO71E4l/5vK7B/bu+eI3km/gGlEHeGciD5x/sExr3c40e/R1tCG
         R0OmCcfYsYYeDESNhFw69UMXo3rx4Vg0cvdt6UuWEijwTJfUkx+9gEwpycPd6eXcKyxn
         EwCg==
X-Gm-Message-State: AOJu0Yx20kxHE3yGNHVdBxYWzZpgYebkq/pkVIO+E0IQVgM4B/NrNMNe
	9YaBJxzSlqD4AyFyvTwfgw5IZQ==
X-Google-Smtp-Source: AGHT+IHXTYoCjBnGzS9Cy5zzIluf7Xlk676w7mYLBZvTOL9sNv6qJfMTc5wXEReN/d0egOcwqs8SVQ==
X-Received: by 2002:a05:600c:a01b:b0:40d:382b:cc2b with SMTP id jg27-20020a05600ca01b00b0040d382bcc2bmr284795wmb.326.1703155629154;
        Thu, 21 Dec 2023 02:47:09 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h7-20020a05600c350700b0040d2e37c06dsm2796907wmq.20.2023.12.21.02.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:47:06 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B01885F8F5;
	Thu, 21 Dec 2023 10:38:21 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cleber Rosa <crosa@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-s390x@nongnu.org,
	David Woodhouse <dwmw2@infradead.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Thomas Huth <thuth@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Bin Meng <bin.meng@windriver.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 28/40] gdbstub: Use GDBFeature for gdb_register_coprocessor
Date: Thu, 21 Dec 2023 10:38:06 +0000
Message-Id: <20231221103818.1633766-29-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231221103818.1633766-1-alex.bennee@linaro.org>
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

This is a tree-wide change to introduce GDBFeature parameter to
gdb_register_coprocessor(). The new parameter just replaces num_regs
and xml parameters for now. GDBFeature will be utilized to simplify XML
lookup in a following change.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20231213-gdb-v17-4-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h     |  2 +-
 gdbstub/gdbstub.c          | 13 +++++++------
 target/arm/gdbstub.c       | 35 +++++++++++++++++++----------------
 target/hexagon/cpu.c       |  3 +--
 target/loongarch/gdbstub.c |  2 +-
 target/m68k/helper.c       |  6 +++---
 target/microblaze/cpu.c    |  5 +++--
 target/ppc/gdbstub.c       | 11 ++++++-----
 target/riscv/gdbstub.c     | 20 ++++++++++++--------
 target/s390x/gdbstub.c     | 28 +++++++---------------------
 10 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index d8a3c56fa2b..ac6fce99a64 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -38,7 +38,7 @@ typedef int (*gdb_set_reg_cb)(CPUArchState *env, uint8_t *buf, int reg);
  */
 void gdb_register_coprocessor(CPUState *cpu,
                               gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
-                              int num_regs, const char *xml, int g_pos);
+                              const GDBFeature *feature, int g_pos);
 
 /**
  * gdbserver_start: start the gdb server
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 46d752bbc2c..068180c83c7 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -544,7 +544,7 @@ static int gdb_write_register(CPUState *cpu, uint8_t *mem_buf, int reg)
 
 void gdb_register_coprocessor(CPUState *cpu,
                               gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
-                              int num_regs, const char *xml, int g_pos)
+                              const GDBFeature *feature, int g_pos)
 {
     GDBRegisterState *s;
     guint i;
@@ -553,7 +553,7 @@ void gdb_register_coprocessor(CPUState *cpu,
         for (i = 0; i < cpu->gdb_regs->len; i++) {
             /* Check for duplicates.  */
             s = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-            if (strcmp(s->xml, xml) == 0) {
+            if (strcmp(s->xml, feature->xmlname) == 0) {
                 return;
             }
         }
@@ -565,17 +565,18 @@ void gdb_register_coprocessor(CPUState *cpu,
     g_array_set_size(cpu->gdb_regs, i + 1);
     s = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
     s->base_reg = cpu->gdb_num_regs;
-    s->num_regs = num_regs;
+    s->num_regs = feature->num_regs;
     s->get_reg = get_reg;
     s->set_reg = set_reg;
-    s->xml = xml;
+    s->xml = feature->xml;
 
     /* Add to end of list.  */
-    cpu->gdb_num_regs += num_regs;
+    cpu->gdb_num_regs += feature->num_regs;
     if (g_pos) {
         if (g_pos != s->base_reg) {
             error_report("Error: Bad gdb register numbering for '%s', "
-                         "expected %d got %d", xml, g_pos, s->base_reg);
+                         "expected %d got %d", feature->xml,
+                         g_pos, s->base_reg);
         } else {
             cpu->gdb_num_g_regs = cpu->gdb_num_regs;
         }
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 5949adfb31a..f2b201d3125 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -483,14 +483,14 @@ void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu)
          */
 #ifdef TARGET_AARCH64
         if (isar_feature_aa64_sve(&cpu->isar)) {
-            int nreg = arm_gen_dynamic_svereg_feature(cs, cs->gdb_num_regs)->num_regs;
+            GDBFeature *feature = arm_gen_dynamic_svereg_feature(cs, cs->gdb_num_regs);
             gdb_register_coprocessor(cs, aarch64_gdb_get_sve_reg,
-                                     aarch64_gdb_set_sve_reg, nreg,
-                                     "sve-registers.xml", 0);
+                                     aarch64_gdb_set_sve_reg, feature, 0);
         } else {
             gdb_register_coprocessor(cs, aarch64_gdb_get_fpu_reg,
                                      aarch64_gdb_set_fpu_reg,
-                                     34, "aarch64-fpu.xml", 0);
+                                     gdb_find_static_feature("aarch64-fpu.xml"),
+                                     0);
         }
         /*
          * Note that we report pauth information via the feature name
@@ -501,19 +501,22 @@ void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu)
         if (isar_feature_aa64_pauth(&cpu->isar)) {
             gdb_register_coprocessor(cs, aarch64_gdb_get_pauth_reg,
                                      aarch64_gdb_set_pauth_reg,
-                                     4, "aarch64-pauth.xml", 0);
+                                     gdb_find_static_feature("aarch64-pauth.xml"),
+                                     0);
         }
 #endif
     } else {
         if (arm_feature(env, ARM_FEATURE_NEON)) {
             gdb_register_coprocessor(cs, vfp_gdb_get_reg, vfp_gdb_set_reg,
-                                     49, "arm-neon.xml", 0);
+                                     gdb_find_static_feature("arm-neon.xml"),
+                                     0);
         } else if (cpu_isar_feature(aa32_simd_r32, cpu)) {
             gdb_register_coprocessor(cs, vfp_gdb_get_reg, vfp_gdb_set_reg,
-                                     33, "arm-vfp3.xml", 0);
+                                     gdb_find_static_feature("arm-vfp3.xml"),
+                                     0);
         } else if (cpu_isar_feature(aa32_vfp_simd, cpu)) {
             gdb_register_coprocessor(cs, vfp_gdb_get_reg, vfp_gdb_set_reg,
-                                     17, "arm-vfp.xml", 0);
+                                     gdb_find_static_feature("arm-vfp.xml"), 0);
         }
         if (!arm_feature(env, ARM_FEATURE_M)) {
             /*
@@ -521,29 +524,29 @@ void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu)
              * expose to gdb.
              */
             gdb_register_coprocessor(cs, vfp_gdb_get_sysreg, vfp_gdb_set_sysreg,
-                                     2, "arm-vfp-sysregs.xml", 0);
+                                     gdb_find_static_feature("arm-vfp-sysregs.xml"),
+                                     0);
         }
     }
     if (cpu_isar_feature(aa32_mve, cpu) && tcg_enabled()) {
         gdb_register_coprocessor(cs, mve_gdb_get_reg, mve_gdb_set_reg,
-                                 1, "arm-m-profile-mve.xml", 0);
+                                 gdb_find_static_feature("arm-m-profile-mve.xml"),
+                                 0);
     }
     gdb_register_coprocessor(cs, arm_gdb_get_sysreg, arm_gdb_set_sysreg,
-                             arm_gen_dynamic_sysreg_feature(cs, cs->gdb_num_regs)->num_regs,
-                             "system-registers.xml", 0);
+                             arm_gen_dynamic_sysreg_feature(cs, cs->gdb_num_regs),
+                             0);
 
 #ifdef CONFIG_TCG
     if (arm_feature(env, ARM_FEATURE_M) && tcg_enabled()) {
         gdb_register_coprocessor(cs,
             arm_gdb_get_m_systemreg, arm_gdb_set_m_systemreg,
-            arm_gen_dynamic_m_systemreg_feature(cs, cs->gdb_num_regs)->num_regs,
-            "arm-m-system.xml", 0);
+            arm_gen_dynamic_m_systemreg_feature(cs, cs->gdb_num_regs), 0);
 #ifndef CONFIG_USER_ONLY
         if (arm_feature(env, ARM_FEATURE_M_SECURITY)) {
             gdb_register_coprocessor(cs,
                 arm_gdb_get_m_secextreg, arm_gdb_set_m_secextreg,
-                arm_gen_dynamic_m_secextreg_feature(cs, cs->gdb_num_regs)->num_regs,
-                "arm-m-secext.xml", 0);
+                arm_gen_dynamic_m_secextreg_feature(cs, cs->gdb_num_regs), 0);
         }
 #endif
     }
diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index 9d1ffc3b4bb..65ac9c75ad0 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -341,8 +341,7 @@ static void hexagon_cpu_realize(DeviceState *dev, Error **errp)
 
     gdb_register_coprocessor(cs, hexagon_hvx_gdb_read_register,
                              hexagon_hvx_gdb_write_register,
-                             NUM_VREGS + NUM_QREGS,
-                             "hexagon-hvx.xml", 0);
+                             gdb_find_static_feature("hexagon-hvx.xml"), 0);
 
     qemu_init_vcpu(cs);
     cpu_reset(cs);
diff --git a/target/loongarch/gdbstub.c b/target/loongarch/gdbstub.c
index 5fc2f19e965..843a869450e 100644
--- a/target/loongarch/gdbstub.c
+++ b/target/loongarch/gdbstub.c
@@ -118,5 +118,5 @@ static int loongarch_gdb_set_fpu(CPULoongArchState *env,
 void loongarch_cpu_register_gdb_regs_for_features(CPUState *cs)
 {
     gdb_register_coprocessor(cs, loongarch_gdb_get_fpu, loongarch_gdb_set_fpu,
-                             41, "loongarch-fpu.xml", 0);
+                             gdb_find_static_feature("loongarch-fpu.xml"), 0);
 }
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 0a1544cd68d..675f2dcd5ad 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -152,10 +152,10 @@ void m68k_cpu_init_gdb(M68kCPU *cpu)
 
     if (m68k_feature(env, M68K_FEATURE_CF_FPU)) {
         gdb_register_coprocessor(cs, cf_fpu_gdb_get_reg, cf_fpu_gdb_set_reg,
-                                 11, "cf-fp.xml", 18);
+                                 gdb_find_static_feature("cf-fp.xml"), 18);
     } else if (m68k_feature(env, M68K_FEATURE_FPU)) {
-        gdb_register_coprocessor(cs, m68k_fpu_gdb_get_reg,
-                                 m68k_fpu_gdb_set_reg, 11, "m68k-fp.xml", 18);
+        gdb_register_coprocessor(cs, m68k_fpu_gdb_get_reg, m68k_fpu_gdb_set_reg,
+                                 gdb_find_static_feature("m68k-fp.xml"), 18);
     }
     /* TODO: Add [E]MAC registers.  */
 }
diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
index bbb3335cadd..1998f69828f 100644
--- a/target/microblaze/cpu.c
+++ b/target/microblaze/cpu.c
@@ -297,8 +297,9 @@ static void mb_cpu_initfn(Object *obj)
     CPUMBState *env = &cpu->env;
 
     gdb_register_coprocessor(CPU(cpu), mb_cpu_gdb_read_stack_protect,
-                             mb_cpu_gdb_write_stack_protect, 2,
-                             "microblaze-stack-protect.xml", 0);
+                             mb_cpu_gdb_write_stack_protect,
+                             gdb_find_static_feature("microblaze-stack-protect.xml"),
+                             0);
 
     set_float_rounding_mode(float_round_nearest_even, &env->fp_status);
 
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index e3be3dbd109..09b852464f3 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -570,23 +570,24 @@ void ppc_gdb_init(CPUState *cs, PowerPCCPUClass *pcc)
 {
     if (pcc->insns_flags & PPC_FLOAT) {
         gdb_register_coprocessor(cs, gdb_get_float_reg, gdb_set_float_reg,
-                                 33, "power-fpu.xml", 0);
+                                 gdb_find_static_feature("power-fpu.xml"), 0);
     }
     if (pcc->insns_flags & PPC_ALTIVEC) {
         gdb_register_coprocessor(cs, gdb_get_avr_reg, gdb_set_avr_reg,
-                                 34, "power-altivec.xml", 0);
+                                 gdb_find_static_feature("power-altivec.xml"),
+                                 0);
     }
     if (pcc->insns_flags & PPC_SPE) {
         gdb_register_coprocessor(cs, gdb_get_spe_reg, gdb_set_spe_reg,
-                                 34, "power-spe.xml", 0);
+                                 gdb_find_static_feature("power-spe.xml"), 0);
     }
     if (pcc->insns_flags2 & PPC2_VSX) {
         gdb_register_coprocessor(cs, gdb_get_vsx_reg, gdb_set_vsx_reg,
-                                 32, "power-vsx.xml", 0);
+                                 gdb_find_static_feature("power-vsx.xml"), 0);
     }
 #ifndef CONFIG_USER_ONLY
     gdb_gen_spr_feature(cs);
     gdb_register_coprocessor(cs, gdb_get_spr_reg, gdb_set_spr_reg,
-                             pcc->gdb_spr.num_regs, "power-spr.xml", 0);
+                             &pcc->gdb_spr, 0);
 #endif
 }
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 76b72a95954..a879869fa1a 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -311,28 +311,32 @@ void riscv_cpu_register_gdb_regs_for_features(CPUState *cs)
     CPURISCVState *env = &cpu->env;
     if (env->misa_ext & RVD) {
         gdb_register_coprocessor(cs, riscv_gdb_get_fpu, riscv_gdb_set_fpu,
-                                 32, "riscv-64bit-fpu.xml", 0);
+                                 gdb_find_static_feature("riscv-64bit-fpu.xml"),
+                                 0);
     } else if (env->misa_ext & RVF) {
         gdb_register_coprocessor(cs, riscv_gdb_get_fpu, riscv_gdb_set_fpu,
-                                 32, "riscv-32bit-fpu.xml", 0);
+                                 gdb_find_static_feature("riscv-32bit-fpu.xml"),
+                                 0);
     }
     if (env->misa_ext & RVV) {
         gdb_register_coprocessor(cs, riscv_gdb_get_vector,
                                  riscv_gdb_set_vector,
-                                 ricsv_gen_dynamic_vector_feature(cs, cs->gdb_num_regs)->num_regs,
-                                 "riscv-vector.xml", 0);
+                                 ricsv_gen_dynamic_vector_feature(cs, cs->gdb_num_regs),
+                                 0);
     }
     switch (mcc->misa_mxl_max) {
     case MXL_RV32:
         gdb_register_coprocessor(cs, riscv_gdb_get_virtual,
                                  riscv_gdb_set_virtual,
-                                 1, "riscv-32bit-virtual.xml", 0);
+                                 gdb_find_static_feature("riscv-32bit-virtual.xml"),
+                                 0);
         break;
     case MXL_RV64:
     case MXL_RV128:
         gdb_register_coprocessor(cs, riscv_gdb_get_virtual,
                                  riscv_gdb_set_virtual,
-                                 1, "riscv-64bit-virtual.xml", 0);
+                                 gdb_find_static_feature("riscv-64bit-virtual.xml"),
+                                 0);
         break;
     default:
         g_assert_not_reached();
@@ -340,7 +344,7 @@ void riscv_cpu_register_gdb_regs_for_features(CPUState *cs)
 
     if (cpu->cfg.ext_zicsr) {
         gdb_register_coprocessor(cs, riscv_gdb_get_csr, riscv_gdb_set_csr,
-                                 riscv_gen_dynamic_csr_feature(cs, cs->gdb_num_regs)->num_regs,
-                                 "riscv-csr.xml", 0);
+                                 riscv_gen_dynamic_csr_feature(cs, cs->gdb_num_regs),
+                                 0);
     }
 }
diff --git a/target/s390x/gdbstub.c b/target/s390x/gdbstub.c
index 6fbfd41bc86..02c388dc323 100644
--- a/target/s390x/gdbstub.c
+++ b/target/s390x/gdbstub.c
@@ -69,8 +69,6 @@ int s390_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 /* the values represent the positions in s390-acr.xml */
 #define S390_A0_REGNUM 0
 #define S390_A15_REGNUM 15
-/* total number of registers in s390-acr.xml */
-#define S390_NUM_AC_REGS 16
 
 static int cpu_read_ac_reg(CPUS390XState *env, GByteArray *buf, int n)
 {
@@ -98,8 +96,6 @@ static int cpu_write_ac_reg(CPUS390XState *env, uint8_t *mem_buf, int n)
 #define S390_FPC_REGNUM 0
 #define S390_F0_REGNUM 1
 #define S390_F15_REGNUM 16
-/* total number of registers in s390-fpr.xml */
-#define S390_NUM_FP_REGS 17
 
 static int cpu_read_fp_reg(CPUS390XState *env, GByteArray *buf, int n)
 {
@@ -132,8 +128,6 @@ static int cpu_write_fp_reg(CPUS390XState *env, uint8_t *mem_buf, int n)
 #define S390_V15L_REGNUM 15
 #define S390_V16_REGNUM 16
 #define S390_V31_REGNUM 31
-/* total number of registers in s390-vx.xml */
-#define S390_NUM_VREGS 32
 
 static int cpu_read_vreg(CPUS390XState *env, GByteArray *buf, int n)
 {
@@ -172,8 +166,6 @@ static int cpu_write_vreg(CPUS390XState *env, uint8_t *mem_buf, int n)
 /* the values represent the positions in s390-cr.xml */
 #define S390_C0_REGNUM 0
 #define S390_C15_REGNUM 15
-/* total number of registers in s390-cr.xml */
-#define S390_NUM_C_REGS 16
 
 #ifndef CONFIG_USER_ONLY
 static int cpu_read_c_reg(CPUS390XState *env, GByteArray *buf, int n)
@@ -206,8 +198,6 @@ static int cpu_write_c_reg(CPUS390XState *env, uint8_t *mem_buf, int n)
 #define S390_VIRT_CPUTM_REGNUM  1
 #define S390_VIRT_BEA_REGNUM    2
 #define S390_VIRT_PREFIX_REGNUM 3
-/* total number of registers in s390-virt.xml */
-#define S390_NUM_VIRT_REGS 4
 
 static int cpu_read_virt_reg(CPUS390XState *env, GByteArray *mem_buf, int n)
 {
@@ -254,8 +244,6 @@ static int cpu_write_virt_reg(CPUS390XState *env, uint8_t *mem_buf, int n)
 #define S390_VIRT_KVM_PFT_REGNUM    1
 #define S390_VIRT_KVM_PFS_REGNUM    2
 #define S390_VIRT_KVM_PFC_REGNUM    3
-/* total number of registers in s390-virt-kvm.xml */
-#define S390_NUM_VIRT_KVM_REGS 4
 
 static int cpu_read_virt_kvm_reg(CPUS390XState *env, GByteArray *mem_buf, int n)
 {
@@ -303,8 +291,6 @@ static int cpu_write_virt_kvm_reg(CPUS390XState *env, uint8_t *mem_buf, int n)
 #define S390_GS_GSD_REGNUM      1
 #define S390_GS_GSSM_REGNUM     2
 #define S390_GS_GSEPLA_REGNUM   3
-/* total number of registers in s390-gs.xml */
-#define S390_NUM_GS_REGS 4
 
 static int cpu_read_gs_reg(CPUS390XState *env, GByteArray *buf, int n)
 {
@@ -322,33 +308,33 @@ void s390_cpu_gdb_init(CPUState *cs)
 {
     gdb_register_coprocessor(cs, cpu_read_ac_reg,
                              cpu_write_ac_reg,
-                             S390_NUM_AC_REGS, "s390-acr.xml", 0);
+                             gdb_find_static_feature("s390-acr.xml"), 0);
 
     gdb_register_coprocessor(cs, cpu_read_fp_reg,
                              cpu_write_fp_reg,
-                             S390_NUM_FP_REGS, "s390-fpr.xml", 0);
+                             gdb_find_static_feature("s390-fpr.xml"), 0);
 
     gdb_register_coprocessor(cs, cpu_read_vreg,
                              cpu_write_vreg,
-                             S390_NUM_VREGS, "s390-vx.xml", 0);
+                             gdb_find_static_feature("s390-vx.xml"), 0);
 
     gdb_register_coprocessor(cs, cpu_read_gs_reg,
                              cpu_write_gs_reg,
-                             S390_NUM_GS_REGS, "s390-gs.xml", 0);
+                             gdb_find_static_feature("s390-gs.xml"), 0);
 
 #ifndef CONFIG_USER_ONLY
     gdb_register_coprocessor(cs, cpu_read_c_reg,
                              cpu_write_c_reg,
-                             S390_NUM_C_REGS, "s390-cr.xml", 0);
+                             gdb_find_static_feature("s390-cr.xml"), 0);
 
     gdb_register_coprocessor(cs, cpu_read_virt_reg,
                              cpu_write_virt_reg,
-                             S390_NUM_VIRT_REGS, "s390-virt.xml", 0);
+                             gdb_find_static_feature("s390-virt.xml"), 0);
 
     if (kvm_enabled()) {
         gdb_register_coprocessor(cs, cpu_read_virt_kvm_reg,
                                  cpu_write_virt_kvm_reg,
-                                 S390_NUM_VIRT_KVM_REGS, "s390-virt-kvm.xml",
+                                 gdb_find_static_feature("s390-virt-kvm.xml"),
                                  0);
     }
 #endif
-- 
2.39.2


