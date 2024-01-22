Return-Path: <kvm+bounces-6552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CCA483670C
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAD9AB2C215
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547FE47F54;
	Mon, 22 Jan 2024 14:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RafL+xqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279944645F
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935381; cv=none; b=f4CLxghDH4Wae0w9hUyQEp/2LJZWTE7ZRxUMECnjpARdsdU+MBPrzmE/87iPe6zhXlbJvbzmPErv2HlCbP7ovJJmd8YTMvhHHixYeqPdU6heI2Fu6XRgoXE+TrvzEeQ6mnBhcVmmY2ypFDMZHxqiSkAZr5VYnGLqcceq0xs3MHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935381; c=relaxed/simple;
	bh=pl6WZyhPTI8n2iYRUrU+LYYnluS72A/PnX1zYYQ2NYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJ5IOP1wgiggYNSWShg2II+OgJjTIezo9NLyRuuYV4kNLegSYkiIzBrnBH+lUH4FoSOchhdURlVIbPkSMgyikv47v32t5Rc0UU0rzoCh2o0Ni+okF394OPd7g9t3cKepktv1cSob7jPKMp0wRdF/8a/s+n6tDUAx7QQzkHDpEvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RafL+xqG; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-339261a6ec2so1863506f8f.0
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935376; x=1706540176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCQOYB+dAq+nz86hu6NKWuyjJPpru/xKOIjccnlhr/o=;
        b=RafL+xqGlS6lyCQ0/OntBert2EOdNwFC+fsrQbicE30g+6R5IAXYDXRj8EOMlDZdLW
         tKzfwwbdCP7BBlICqAynLGg8xfvfjo707paxe+SF3LPQZaykzBqCxhL5ygvdDSC88XiB
         xYlLsXctx/YOpGxggjWfiaaKtul20UeotbGdMmgTtoU+U6Dq8yXZ/V3jU4kW3pl6hTsb
         NHWRrt36WdoRUU/KancN+CT8VowM7Mx/Av7UpX6ym+etTeBfKPN7y4zTiJbxEGkcrDSX
         3P0Fu164/fTnPDWb7VQAYFADWSlaja0DQ9seLFQ0CUC2S1/rK2JKWSxpHzcGvIVH7qlm
         m77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935376; x=1706540176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pCQOYB+dAq+nz86hu6NKWuyjJPpru/xKOIjccnlhr/o=;
        b=rMFDFKD5Nyvh0d+sfMTSr7shxJ3dV9vBMCs5APDnD5+kUmmIu6+y0EqX5VZdiuC4DM
         HvFKOInGWFCgDwXOam+jqLI7Tja6RSNSYHvKUSRf643VF0bvC5Mxalid2FTG5npHd3WL
         K7rAX73m6Ih7PCOT7dwrpbYU6Hlor12F91xSaDYe3F1pkftmwBOgFgon49CkVzBeyUDD
         KIeXVxi2DChiQc9u6+vlY2Bi1pWclPUX8Rnu+WWpS1KrrLKhQLl9B0DhlARYWysgHGnD
         r352fTFA63y7fW1wcOIq9Aae67Pdidq8eUyWOE+EOV/nebCWBQBybXKJUUAGhNsobtx/
         0FCw==
X-Gm-Message-State: AOJu0YxKgyAw91e2D1McOp6iDz0we4a4yp2iMIdA3TvL0u9EF9gYphVh
	1Cqi2SiYa25QIEFyjzd/9rLHGGrl3JO1T8myCZII9Ne3bnlCbAtvFLqNZvejW+U=
X-Google-Smtp-Source: AGHT+IFGldjqKHRUVgIb6TRcnsiRSk/itCIwrd9DeRONSVAT4751bcKXSj23UnKslF3XgFwLF8YkUg==
X-Received: by 2002:a05:6000:25b:b0:333:2fd2:5d21 with SMTP id m27-20020a056000025b00b003332fd25d21mr1860360wrz.83.1705935376123;
        Mon, 22 Jan 2024 06:56:16 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id g18-20020adff3d2000000b00337f722e5ccsm9389745wrp.65.2024.01.22.06.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:14 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5084B5F8FE;
	Mon, 22 Jan 2024 14:56:11 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 05/21] target/arm: Use GDBFeature for dynamic XML
Date: Mon, 22 Jan 2024 14:55:54 +0000
Message-Id: <20240122145610.413836-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

In preparation for a change to use GDBFeature as a parameter of
gdb_register_coprocessor(), convert the internal representation of
dynamic feature from plain XML to GDBFeature.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20240103173349.398526-27-alex.bennee@linaro.org>
Message-Id: <20231213-gdb-v17-1-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/cpu.h       |  21 +++---
 target/arm/internals.h |   2 +-
 target/arm/gdbstub.c   | 142 ++++++++++++++++++++---------------------
 target/arm/gdbstub64.c |  95 +++++++++++++--------------
 4 files changed, 123 insertions(+), 137 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ec276fcd57c..65b961fb948 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -25,6 +25,7 @@
 #include "hw/registerfields.h"
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/gdbstub.h"
 #include "qapi/qapi-types-common.h"
 
 /* ARM processors have a weak memory model */
@@ -136,23 +137,21 @@ enum {
  */
 
 /**
- * DynamicGDBXMLInfo:
- * @desc: Contains the XML descriptions.
- * @num: Number of the registers in this XML seen by GDB.
+ * DynamicGDBFeatureInfo:
+ * @desc: Contains the feature descriptions.
  * @data: A union with data specific to the set of registers
  *    @cpregs_keys: Array that contains the corresponding Key of
  *                  a given cpreg with the same order of the cpreg
  *                  in the XML description.
  */
-typedef struct DynamicGDBXMLInfo {
-    char *desc;
-    int num;
+typedef struct DynamicGDBFeatureInfo {
+    GDBFeature desc;
     union {
         struct {
             uint32_t *keys;
         } cpregs;
     } data;
-} DynamicGDBXMLInfo;
+} DynamicGDBFeatureInfo;
 
 /* CPU state for each instance of a generic timer (in cp15 c14) */
 typedef struct ARMGenericTimer {
@@ -881,10 +880,10 @@ struct ArchCPU {
     uint64_t *cpreg_vmstate_values;
     int32_t cpreg_vmstate_array_len;
 
-    DynamicGDBXMLInfo dyn_sysreg_xml;
-    DynamicGDBXMLInfo dyn_svereg_xml;
-    DynamicGDBXMLInfo dyn_m_systemreg_xml;
-    DynamicGDBXMLInfo dyn_m_secextreg_xml;
+    DynamicGDBFeatureInfo dyn_sysreg_feature;
+    DynamicGDBFeatureInfo dyn_svereg_feature;
+    DynamicGDBFeatureInfo dyn_m_systemreg_feature;
+    DynamicGDBFeatureInfo dyn_m_secextreg_feature;
 
     /* Timers used by the generic (architected) timer */
     QEMUTimer *gt_timer[NUM_GTIMERS];
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 71d6c70bf38..0deb60db1a5 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1446,7 +1446,7 @@ static inline uint64_t pmu_counter_mask(CPUARMState *env)
 }
 
 #ifdef TARGET_AARCH64
-int arm_gen_dynamic_svereg_xml(CPUState *cpu, int base_reg);
+GDBFeature *arm_gen_dynamic_svereg_feature(CPUState *cpu, int base_reg);
 int aarch64_gdb_get_sve_reg(CPUARMState *env, GByteArray *buf, int reg);
 int aarch64_gdb_set_sve_reg(CPUARMState *env, uint8_t *buf, int reg);
 int aarch64_gdb_get_fpu_reg(CPUARMState *env, GByteArray *buf, int reg);
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 28f546a5ff9..5949adfb31a 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -26,11 +26,11 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 
-typedef struct RegisterSysregXmlParam {
+typedef struct RegisterSysregFeatureParam {
     CPUState *cs;
-    GString *s;
+    GDBFeatureBuilder builder;
     int n;
-} RegisterSysregXmlParam;
+} RegisterSysregFeatureParam;
 
 /* Old gdb always expect FPA registers.  Newer (xml-aware) gdb only expect
    whatever the target description contains.  Due to a historical mishap
@@ -216,7 +216,7 @@ static int arm_gdb_get_sysreg(CPUARMState *env, GByteArray *buf, int reg)
     const ARMCPRegInfo *ri;
     uint32_t key;
 
-    key = cpu->dyn_sysreg_xml.data.cpregs.keys[reg];
+    key = cpu->dyn_sysreg_feature.data.cpregs.keys[reg];
     ri = get_arm_cp_reginfo(cpu->cp_regs, key);
     if (ri) {
         if (cpreg_field_is_64bit(ri)) {
@@ -233,34 +233,32 @@ static int arm_gdb_set_sysreg(CPUARMState *env, uint8_t *buf, int reg)
     return 0;
 }
 
-static void arm_gen_one_xml_sysreg_tag(GString *s, DynamicGDBXMLInfo *dyn_xml,
+static void arm_gen_one_feature_sysreg(GDBFeatureBuilder *builder,
+                                       DynamicGDBFeatureInfo *dyn_feature,
                                        ARMCPRegInfo *ri, uint32_t ri_key,
-                                       int bitsize, int regnum)
+                                       int bitsize, int n)
 {
-    g_string_append_printf(s, "<reg name=\"%s\"", ri->name);
-    g_string_append_printf(s, " bitsize=\"%d\"", bitsize);
-    g_string_append_printf(s, " regnum=\"%d\"", regnum);
-    g_string_append_printf(s, " group=\"cp_regs\"/>");
-    dyn_xml->data.cpregs.keys[dyn_xml->num] = ri_key;
-    dyn_xml->num++;
+    gdb_feature_builder_append_reg(builder, ri->name, bitsize, n,
+                                   "int", "cp_regs");
+
+    dyn_feature->data.cpregs.keys[n] = ri_key;
 }
 
-static void arm_register_sysreg_for_xml(gpointer key, gpointer value,
-                                        gpointer p)
+static void arm_register_sysreg_for_feature(gpointer key, gpointer value,
+                                            gpointer p)
 {
     uint32_t ri_key = (uintptr_t)key;
     ARMCPRegInfo *ri = value;
-    RegisterSysregXmlParam *param = (RegisterSysregXmlParam *)p;
-    GString *s = param->s;
+    RegisterSysregFeatureParam *param = p;
     ARMCPU *cpu = ARM_CPU(param->cs);
     CPUARMState *env = &cpu->env;
-    DynamicGDBXMLInfo *dyn_xml = &cpu->dyn_sysreg_xml;
+    DynamicGDBFeatureInfo *dyn_feature = &cpu->dyn_sysreg_feature;
 
     if (!(ri->type & (ARM_CP_NO_RAW | ARM_CP_NO_GDB))) {
         if (arm_feature(env, ARM_FEATURE_AARCH64)) {
             if (ri->state == ARM_CP_STATE_AA64) {
-                arm_gen_one_xml_sysreg_tag(s , dyn_xml, ri, ri_key, 64,
-                                           param->n++);
+                arm_gen_one_feature_sysreg(&param->builder, dyn_feature,
+                                           ri, ri_key, 64, param->n++);
             }
         } else {
             if (ri->state == ARM_CP_STATE_AA32) {
@@ -269,32 +267,32 @@ static void arm_register_sysreg_for_xml(gpointer key, gpointer value,
                     return;
                 }
                 if (ri->type & ARM_CP_64BIT) {
-                    arm_gen_one_xml_sysreg_tag(s , dyn_xml, ri, ri_key, 64,
-                                               param->n++);
+                    arm_gen_one_feature_sysreg(&param->builder, dyn_feature,
+                                               ri, ri_key, 64, param->n++);
                 } else {
-                    arm_gen_one_xml_sysreg_tag(s , dyn_xml, ri, ri_key, 32,
-                                               param->n++);
+                    arm_gen_one_feature_sysreg(&param->builder, dyn_feature,
+                                               ri, ri_key, 32, param->n++);
                 }
             }
         }
     }
 }
 
-static int arm_gen_dynamic_sysreg_xml(CPUState *cs, int base_reg)
+static GDBFeature *arm_gen_dynamic_sysreg_feature(CPUState *cs, int base_reg)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-    GString *s = g_string_new(NULL);
-    RegisterSysregXmlParam param = {cs, s, base_reg};
-
-    cpu->dyn_sysreg_xml.num = 0;
-    cpu->dyn_sysreg_xml.data.cpregs.keys = g_new(uint32_t, g_hash_table_size(cpu->cp_regs));
-    g_string_printf(s, "<?xml version=\"1.0\"?>");
-    g_string_append_printf(s, "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">");
-    g_string_append_printf(s, "<feature name=\"org.qemu.gdb.arm.sys.regs\">");
-    g_hash_table_foreach(cpu->cp_regs, arm_register_sysreg_for_xml, &param);
-    g_string_append_printf(s, "</feature>");
-    cpu->dyn_sysreg_xml.desc = g_string_free(s, false);
-    return cpu->dyn_sysreg_xml.num;
+    RegisterSysregFeatureParam param = {cs};
+    gsize num_regs = g_hash_table_size(cpu->cp_regs);
+
+    gdb_feature_builder_init(&param.builder,
+                             &cpu->dyn_sysreg_feature.desc,
+                             "org.qemu.gdb.arm.sys.regs",
+                             "system-registers.xml",
+                             base_reg);
+    cpu->dyn_sysreg_feature.data.cpregs.keys = g_new(uint32_t, num_regs);
+    g_hash_table_foreach(cpu->cp_regs, arm_register_sysreg_for_feature, &param);
+    gdb_feature_builder_end(&param.builder);
+    return &cpu->dyn_sysreg_feature.desc;
 }
 
 #ifdef CONFIG_TCG
@@ -386,31 +384,29 @@ static int arm_gdb_set_m_systemreg(CPUARMState *env, uint8_t *buf, int reg)
     return 0; /* TODO */
 }
 
-static int arm_gen_dynamic_m_systemreg_xml(CPUState *cs, int orig_base_reg)
+static GDBFeature *arm_gen_dynamic_m_systemreg_feature(CPUState *cs,
+                                                       int base_reg)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    GString *s = g_string_new(NULL);
-    int base_reg = orig_base_reg;
+    GDBFeatureBuilder builder;
+    int reg = 0;
     int i;
 
-    g_string_printf(s, "<?xml version=\"1.0\"?>");
-    g_string_append_printf(s, "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">");
-    g_string_append_printf(s, "<feature name=\"org.gnu.gdb.arm.m-system\">\n");
+    gdb_feature_builder_init(&builder, &cpu->dyn_m_systemreg_feature.desc,
+                             "org.gnu.gdb.arm.m-system", "arm-m-system.xml",
+                             base_reg);
 
     for (i = 0; i < ARRAY_SIZE(m_sysreg_def); i++) {
         if (arm_feature(env, m_sysreg_def[i].feature)) {
-            g_string_append_printf(s,
-                "<reg name=\"%s\" bitsize=\"32\" regnum=\"%d\"/>\n",
-                m_sysreg_def[i].name, base_reg++);
+            gdb_feature_builder_append_reg(&builder, m_sysreg_def[i].name, 32,
+                                           reg++, "int", NULL);
         }
     }
 
-    g_string_append_printf(s, "</feature>");
-    cpu->dyn_m_systemreg_xml.desc = g_string_free(s, false);
-    cpu->dyn_m_systemreg_xml.num = base_reg - orig_base_reg;
+    gdb_feature_builder_end(&builder);
 
-    return cpu->dyn_m_systemreg_xml.num;
+    return &cpu->dyn_m_systemreg_feature.desc;
 }
 
 #ifndef CONFIG_USER_ONLY
@@ -428,31 +424,31 @@ static int arm_gdb_set_m_secextreg(CPUARMState *env, uint8_t *buf, int reg)
     return 0; /* TODO */
 }
 
-static int arm_gen_dynamic_m_secextreg_xml(CPUState *cs, int orig_base_reg)
+static GDBFeature *arm_gen_dynamic_m_secextreg_feature(CPUState *cs,
+                                                       int base_reg)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-    GString *s = g_string_new(NULL);
-    int base_reg = orig_base_reg;
+    GDBFeatureBuilder builder;
+    char *name;
+    int reg = 0;
     int i;
 
-    g_string_printf(s, "<?xml version=\"1.0\"?>");
-    g_string_append_printf(s, "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">");
-    g_string_append_printf(s, "<feature name=\"org.gnu.gdb.arm.secext\">\n");
+    gdb_feature_builder_init(&builder, &cpu->dyn_m_secextreg_feature.desc,
+                             "org.gnu.gdb.arm.secext", "arm-m-secext.xml",
+                             base_reg);
 
     for (i = 0; i < ARRAY_SIZE(m_sysreg_def); i++) {
-        g_string_append_printf(s,
-            "<reg name=\"%s_ns\" bitsize=\"32\" regnum=\"%d\"/>\n",
-            m_sysreg_def[i].name, base_reg++);
-        g_string_append_printf(s,
-            "<reg name=\"%s_s\" bitsize=\"32\" regnum=\"%d\"/>\n",
-            m_sysreg_def[i].name, base_reg++);
+        name = g_strconcat(m_sysreg_def[i].name, "_ns", NULL);
+        gdb_feature_builder_append_reg(&builder, name, 32, reg++,
+                                       "int", NULL);
+        name = g_strconcat(m_sysreg_def[i].name, "_s", NULL);
+        gdb_feature_builder_append_reg(&builder, name, 32, reg++,
+                                       "int", NULL);
     }
 
-    g_string_append_printf(s, "</feature>");
-    cpu->dyn_m_secextreg_xml.desc = g_string_free(s, false);
-    cpu->dyn_m_secextreg_xml.num = base_reg - orig_base_reg;
+    gdb_feature_builder_end(&builder);
 
-    return cpu->dyn_m_secextreg_xml.num;
+    return &cpu->dyn_m_secextreg_feature.desc;
 }
 #endif
 #endif /* CONFIG_TCG */
@@ -462,14 +458,14 @@ const char *arm_gdb_get_dynamic_xml(CPUState *cs, const char *xmlname)
     ARMCPU *cpu = ARM_CPU(cs);
 
     if (strcmp(xmlname, "system-registers.xml") == 0) {
-        return cpu->dyn_sysreg_xml.desc;
+        return cpu->dyn_sysreg_feature.desc.xml;
     } else if (strcmp(xmlname, "sve-registers.xml") == 0) {
-        return cpu->dyn_svereg_xml.desc;
+        return cpu->dyn_svereg_feature.desc.xml;
     } else if (strcmp(xmlname, "arm-m-system.xml") == 0) {
-        return cpu->dyn_m_systemreg_xml.desc;
+        return cpu->dyn_m_systemreg_feature.desc.xml;
 #ifndef CONFIG_USER_ONLY
     } else if (strcmp(xmlname, "arm-m-secext.xml") == 0) {
-        return cpu->dyn_m_secextreg_xml.desc;
+        return cpu->dyn_m_secextreg_feature.desc.xml;
 #endif
     }
     return NULL;
@@ -487,7 +483,7 @@ void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu)
          */
 #ifdef TARGET_AARCH64
         if (isar_feature_aa64_sve(&cpu->isar)) {
-            int nreg = arm_gen_dynamic_svereg_xml(cs, cs->gdb_num_regs);
+            int nreg = arm_gen_dynamic_svereg_feature(cs, cs->gdb_num_regs)->num_regs;
             gdb_register_coprocessor(cs, aarch64_gdb_get_sve_reg,
                                      aarch64_gdb_set_sve_reg, nreg,
                                      "sve-registers.xml", 0);
@@ -533,20 +529,20 @@ void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu)
                                  1, "arm-m-profile-mve.xml", 0);
     }
     gdb_register_coprocessor(cs, arm_gdb_get_sysreg, arm_gdb_set_sysreg,
-                             arm_gen_dynamic_sysreg_xml(cs, cs->gdb_num_regs),
+                             arm_gen_dynamic_sysreg_feature(cs, cs->gdb_num_regs)->num_regs,
                              "system-registers.xml", 0);
 
 #ifdef CONFIG_TCG
     if (arm_feature(env, ARM_FEATURE_M) && tcg_enabled()) {
         gdb_register_coprocessor(cs,
             arm_gdb_get_m_systemreg, arm_gdb_set_m_systemreg,
-            arm_gen_dynamic_m_systemreg_xml(cs, cs->gdb_num_regs),
+            arm_gen_dynamic_m_systemreg_feature(cs, cs->gdb_num_regs)->num_regs,
             "arm-m-system.xml", 0);
 #ifndef CONFIG_USER_ONLY
         if (arm_feature(env, ARM_FEATURE_M_SECURITY)) {
             gdb_register_coprocessor(cs,
                 arm_gdb_get_m_secextreg, arm_gdb_set_m_secextreg,
-                arm_gen_dynamic_m_secextreg_xml(cs, cs->gdb_num_regs),
+                arm_gen_dynamic_m_secextreg_feature(cs, cs->gdb_num_regs)->num_regs,
                 "arm-m-secext.xml", 0);
         }
 #endif
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index d7b79a6589b..5286d5c6043 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -247,7 +247,7 @@ int aarch64_gdb_set_pauth_reg(CPUARMState *env, uint8_t *buf, int reg)
     return 0;
 }
 
-static void output_vector_union_type(GString *s, int reg_width,
+static void output_vector_union_type(GDBFeatureBuilder *builder, int reg_width,
                                      const char *name)
 {
     struct TypeSize {
@@ -282,10 +282,10 @@ static void output_vector_union_type(GString *s, int reg_width,
 
     /* First define types and totals in a whole VL */
     for (i = 0; i < ARRAY_SIZE(vec_lanes); i++) {
-        g_string_append_printf(s,
-                               "<vector id=\"%s%c%c\" type=\"%s\" count=\"%d\"/>",
-                               name, vec_lanes[i].sz, vec_lanes[i].suffix,
-                               vec_lanes[i].gdb_type, reg_width / vec_lanes[i].size);
+        gdb_feature_builder_append_tag(
+            builder, "<vector id=\"%s%c%c\" type=\"%s\" count=\"%d\"/>",
+            name, vec_lanes[i].sz, vec_lanes[i].suffix,
+            vec_lanes[i].gdb_type, reg_width / vec_lanes[i].size);
     }
 
     /*
@@ -296,86 +296,77 @@ static void output_vector_union_type(GString *s, int reg_width,
     for (i = 0; i < ARRAY_SIZE(suf); i++) {
         int bits = 8 << i;
 
-        g_string_append_printf(s, "<union id=\"%sn%c\">", name, suf[i]);
+        gdb_feature_builder_append_tag(builder, "<union id=\"%sn%c\">",
+                                       name, suf[i]);
         for (j = 0; j < ARRAY_SIZE(vec_lanes); j++) {
             if (vec_lanes[j].size == bits) {
-                g_string_append_printf(s, "<field name=\"%c\" type=\"%s%c%c\"/>",
-                                       vec_lanes[j].suffix, name,
-                                       vec_lanes[j].sz, vec_lanes[j].suffix);
+                gdb_feature_builder_append_tag(
+                    builder, "<field name=\"%c\" type=\"%s%c%c\"/>",
+                    vec_lanes[j].suffix, name,
+                    vec_lanes[j].sz, vec_lanes[j].suffix);
             }
         }
-        g_string_append(s, "</union>");
+        gdb_feature_builder_append_tag(builder, "</union>");
     }
 
     /* And now the final union of unions */
-    g_string_append_printf(s, "<union id=\"%s\">", name);
+    gdb_feature_builder_append_tag(builder, "<union id=\"%s\">", name);
     for (i = ARRAY_SIZE(suf) - 1; i >= 0; i--) {
-        g_string_append_printf(s, "<field name=\"%c\" type=\"%sn%c\"/>",
-                               suf[i], name, suf[i]);
+        gdb_feature_builder_append_tag(builder,
+                                       "<field name=\"%c\" type=\"%sn%c\"/>",
+                                       suf[i], name, suf[i]);
     }
-    g_string_append(s, "</union>");
+    gdb_feature_builder_append_tag(builder, "</union>");
 }
 
-int arm_gen_dynamic_svereg_xml(CPUState *cs, int orig_base_reg)
+GDBFeature *arm_gen_dynamic_svereg_feature(CPUState *cs, int base_reg)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-    GString *s = g_string_new(NULL);
-    DynamicGDBXMLInfo *info = &cpu->dyn_svereg_xml;
     int reg_width = cpu->sve_max_vq * 128;
     int pred_width = cpu->sve_max_vq * 16;
-    int base_reg = orig_base_reg;
+    GDBFeatureBuilder builder;
+    char *name;
+    int reg = 0;
     int i;
 
-    g_string_printf(s, "<?xml version=\"1.0\"?>");
-    g_string_append_printf(s, "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">");
-    g_string_append_printf(s, "<feature name=\"org.gnu.gdb.aarch64.sve\">");
+    gdb_feature_builder_init(&builder, &cpu->dyn_svereg_feature.desc,
+                             "org.gnu.gdb.aarch64.sve", "sve-registers.xml",
+                             base_reg);
 
     /* Create the vector union type. */
-    output_vector_union_type(s, reg_width, "svev");
+    output_vector_union_type(&builder, reg_width, "svev");
 
     /* Create the predicate vector type. */
-    g_string_append_printf(s,
-                           "<vector id=\"svep\" type=\"uint8\" count=\"%d\"/>",
-                           pred_width / 8);
+    gdb_feature_builder_append_tag(
+        &builder, "<vector id=\"svep\" type=\"uint8\" count=\"%d\"/>",
+        pred_width / 8);
 
     /* Define the vector registers. */
     for (i = 0; i < 32; i++) {
-        g_string_append_printf(s,
-                               "<reg name=\"z%d\" bitsize=\"%d\""
-                               " regnum=\"%d\" type=\"svev\"/>",
-                               i, reg_width, base_reg++);
+        name = g_strdup_printf("z%d", i);
+        gdb_feature_builder_append_reg(&builder, name, reg_width, reg++,
+                                       "svev", NULL);
     }
 
     /* fpscr & status registers */
-    g_string_append_printf(s, "<reg name=\"fpsr\" bitsize=\"32\""
-                           " regnum=\"%d\" group=\"float\""
-                           " type=\"int\"/>", base_reg++);
-    g_string_append_printf(s, "<reg name=\"fpcr\" bitsize=\"32\""
-                           " regnum=\"%d\" group=\"float\""
-                           " type=\"int\"/>", base_reg++);
+    gdb_feature_builder_append_reg(&builder, "fpsr", 32, reg++,
+                                   "int", "float");
+    gdb_feature_builder_append_reg(&builder, "fpcr", 32, reg++,
+                                   "int", "float");
 
     /* Define the predicate registers. */
     for (i = 0; i < 16; i++) {
-        g_string_append_printf(s,
-                               "<reg name=\"p%d\" bitsize=\"%d\""
-                               " regnum=\"%d\" type=\"svep\"/>",
-                               i, pred_width, base_reg++);
+        name = g_strdup_printf("p%d", i);
+        gdb_feature_builder_append_reg(&builder, name, pred_width, reg++,
+                                       "svep", NULL);
     }
-    g_string_append_printf(s,
-                           "<reg name=\"ffr\" bitsize=\"%d\""
-                           " regnum=\"%d\" group=\"vector\""
-                           " type=\"svep\"/>",
-                           pred_width, base_reg++);
+    gdb_feature_builder_append_reg(&builder, "ffr", pred_width, reg++,
+                                   "svep", "vector");
 
     /* Define the vector length pseudo-register. */
-    g_string_append_printf(s,
-                           "<reg name=\"vg\" bitsize=\"64\""
-                           " regnum=\"%d\" type=\"int\"/>",
-                           base_reg++);
+    gdb_feature_builder_append_reg(&builder, "vg", 64, reg++, "int", NULL);
 
-    g_string_append_printf(s, "</feature>");
+    gdb_feature_builder_end(&builder);
 
-    info->desc = g_string_free(s, false);
-    info->num = base_reg - orig_base_reg;
-    return info->num;
+    return &cpu->dyn_svereg_feature.desc;
 }
-- 
2.39.2


