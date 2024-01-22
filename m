Return-Path: <kvm+bounces-6557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 212F18366FC
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34C11B28AA3
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE5D482DA;
	Mon, 22 Jan 2024 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="haH9iYtr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1E5481A0
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935385; cv=none; b=kKazVI7xktGtF6O6/kMzd5rOGYeFQsk1RoJv4ebPEFNHy2EtIAsr/FOUtiotq65uhZYTUorgjXsstAnhuD6v0Vg05bSrwoDz3T4dek+FhVmjcdnVAoNnRqcQ4GbI963xaMQbS6aZOmvBH3vCf7GEcMztqzgMwPUn+jCpYnFHeYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935385; c=relaxed/simple;
	bh=aGZL0K2Mt5KHA7+LKz8uGtQ+WV3/aSj+Tu0CbbtEbKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BA0yifzK9aE6rLBzcedHEJK/ojsFzrhVMX1+k9Wa9LSWk64NzF2qqw2xooDZVkrNd3TB19DJFdi0KijhTjTLOrA4MPIDd7/BClazKJtAPUfmcexS12EW0AW9IDF+5l4dDpWCLihqGsOKKfeE3cqaunOFu2/aHxnOlNLszOh6t20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=haH9iYtr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40e9ef9853bso17512685e9.1
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935382; x=1706540182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSat6So/7LVo2AsYMRJPZUINSij4uUCglchA3ARRWTc=;
        b=haH9iYtrv/a/gDXA5/A6q8cBgLp/BAKdBXQmZYmGkt38qX+jjWxQQBKp2KYkaEf38T
         uti4/OlBo8hmqZtPsm0HtFaQl5X1RaJ0LnAMuGwTelVa2j/vMaz1GBA8DrwbtV5SxjMz
         6oWEZ4WuDZHoRwxMGzrC4IWPUGQ8y7ab3/tmh2eRZxAWSlQTfMFqZjG+iipzfFFCb64M
         IdCkSnQIvmJvIFfPrWPLE3AL3ujO6r7TRVVXH/cZ+l83L0d3cb5043y+YAwE2Er35zs6
         y8IUiLv5ji1DmwN7vnpRAmUq+0MI0VWnsix3i38SzIgL3HCJ2oxB8p7a96KzsJ/jJO3+
         lIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935382; x=1706540182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSat6So/7LVo2AsYMRJPZUINSij4uUCglchA3ARRWTc=;
        b=E9jMM8LbL0OpXjIfaTFbiZs6WDLxKka4U6MXyXr+t0y6E48NELT1sDyPKlDT39Hw/S
         4JnkmcCD8DRi0F+BLtvwvLpFc5XwBNjUFkrg7Njk1of3QDTuLghWi2iRdgotPKr/9Gsi
         y+LE/nVd0m+MziVM9WLps5kCucB+R+Oofn5zn5I9VEU0AR5yiA8JasfAAbnZdnMbhAiQ
         TgobbtmeDShjS5ojBK3LnAHnAMktFd525h3BPreJfPX/r+guse9nX+HqZMl/S9WoerMj
         54CtHJVEOJsPtvGl9uLJCJrxqLmimbrS3BvqRg/QQ/2zqpdTgOw3zeZnf84T+Edyp304
         Tbiw==
X-Gm-Message-State: AOJu0YyrmnxfNP5qaU/d6XtV/KvMpd76RIDg7xvs0wP14d2nHJ/eSKFq
	AqeYrMu4OPuMkxTaXQvHPko4xwtJqMQGPTsYLEtZDiv2hQylFiuHRcTCGymUfJs=
X-Google-Smtp-Source: AGHT+IFjRV2knLJ549LlC9SsiJxsAMTJDiandvOitn99f/HrQoyuIZxf/6M6GC5R0Ssk+4w9j0Hvjg==
X-Received: by 2002:a05:600c:20d5:b0:40e:88a8:213b with SMTP id y21-20020a05600c20d500b0040e88a8213bmr2143920wmm.142.1705935381827;
        Mon, 22 Jan 2024 06:56:21 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id bi13-20020a05600c3d8d00b0040e8800fcf3sm19386507wmb.5.2024.01.22.06.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:19 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1BCF75F926;
	Mon, 22 Jan 2024 14:56:12 +0000 (GMT)
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
Subject: [PATCH v3 11/21] gdbstub: Simplify XML lookup
Date: Mon, 22 Jan 2024 14:56:00 +0000
Message-Id: <20240122145610.413836-12-alex.bennee@linaro.org>
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

Now we know all instances of GDBFeature that is used in CPU so we can
traverse them to find XML. This removes the need for a CPU-specific
lookup function for dynamic XMLs.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240103173349.398526-33-alex.bennee@linaro.org>
Message-Id: <20231213-gdb-v17-7-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h |   6 +++
 gdbstub/gdbstub.c      | 118 +++++++++++++++++++++--------------------
 hw/core/cpu-common.c   |   5 +-
 3 files changed, 69 insertions(+), 60 deletions(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index bcaab1bc750..82a8afa237f 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -27,6 +27,12 @@ typedef struct GDBFeatureBuilder {
 typedef int (*gdb_get_reg_cb)(CPUState *cpu, GByteArray *buf, int reg);
 typedef int (*gdb_set_reg_cb)(CPUState *cpu, uint8_t *buf, int reg);
 
+/**
+ * gdb_init_cpu(): Initialize the CPU for gdbstub.
+ * @cpu: The CPU to be initialized.
+ */
+void gdb_init_cpu(CPUState *cpu);
+
 /**
  * gdb_register_coprocessor() - register a supplemental set of registers
  * @cpu - the CPU associated with registers
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 21fea7fffae..1d5c1da1b24 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -352,6 +352,7 @@ static const char *get_feature_xml(const char *p, const char **newp,
 {
     CPUState *cpu = gdb_get_first_cpu_in_process(process);
     CPUClass *cc = CPU_GET_CLASS(cpu);
+    GDBRegisterState *r;
     size_t len;
 
     /*
@@ -365,7 +366,6 @@ static const char *get_feature_xml(const char *p, const char **newp,
     /* Is it the main target xml? */
     if (strncmp(p, "target.xml", len) == 0) {
         if (!process->target_xml) {
-            GDBRegisterState *r;
             g_autoptr(GPtrArray) xml = g_ptr_array_new_with_free_func(g_free);
 
             g_ptr_array_add(
@@ -380,18 +380,12 @@ static const char *get_feature_xml(const char *p, const char **newp,
                     g_markup_printf_escaped("<architecture>%s</architecture>",
                                             cc->gdb_arch_name(cpu)));
             }
-            g_ptr_array_add(
-                xml,
-                g_markup_printf_escaped("<xi:include href=\"%s\"/>",
-                                        cc->gdb_core_xml_file));
-            if (cpu->gdb_regs) {
-                for (guint i = 0; i < cpu->gdb_regs->len; i++) {
-                    r = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-                    g_ptr_array_add(
-                        xml,
-                        g_markup_printf_escaped("<xi:include href=\"%s\"/>",
-                                                r->feature->xmlname));
-                }
+            for (guint i = 0; i < cpu->gdb_regs->len; i++) {
+                r = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
+                g_ptr_array_add(
+                    xml,
+                    g_markup_printf_escaped("<xi:include href=\"%s\"/>",
+                                            r->feature->xmlname));
             }
             g_ptr_array_add(xml, g_strdup("</target>"));
             g_ptr_array_add(xml, NULL);
@@ -400,20 +394,11 @@ static const char *get_feature_xml(const char *p, const char **newp,
         }
         return process->target_xml;
     }
-    /* Is it dynamically generated by the target? */
-    if (cc->gdb_get_dynamic_xml) {
-        g_autofree char *xmlname = g_strndup(p, len);
-        const char *xml = cc->gdb_get_dynamic_xml(cpu, xmlname);
-        if (xml) {
-            return xml;
-        }
-    }
-    /* Is it one of the encoded gdb-xml/ files? */
-    for (int i = 0; gdb_static_features[i].xmlname; i++) {
-        const char *name = gdb_static_features[i].xmlname;
-        if ((strncmp(name, p, len) == 0) &&
-            strlen(name) == len) {
-            return gdb_static_features[i].xml;
+    /* Is it one of the features? */
+    for (guint i = 0; i < cpu->gdb_regs->len; i++) {
+        r = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
+        if (strncmp(p, r->feature->xmlname, len) == 0) {
+            return r->feature->xml;
         }
     }
 
@@ -508,12 +493,10 @@ static int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg)
         return cc->gdb_read_register(cpu, buf, reg);
     }
 
-    if (cpu->gdb_regs) {
-        for (guint i = 0; i < cpu->gdb_regs->len; i++) {
-            r = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-            if (r->base_reg <= reg && reg < r->base_reg + r->feature->num_regs) {
-                return r->get_reg(cpu, buf, reg - r->base_reg);
-            }
+    for (guint i = 0; i < cpu->gdb_regs->len; i++) {
+        r = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
+        if (r->base_reg <= reg && reg < r->base_reg + r->feature->num_regs) {
+            return r->get_reg(cpu, buf, reg - r->base_reg);
         }
     }
     return 0;
@@ -528,51 +511,70 @@ static int gdb_write_register(CPUState *cpu, uint8_t *mem_buf, int reg)
         return cc->gdb_write_register(cpu, mem_buf, reg);
     }
 
-    if (cpu->gdb_regs) {
-        for (guint i = 0; i < cpu->gdb_regs->len; i++) {
-            r =  &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-            if (r->base_reg <= reg && reg < r->base_reg + r->feature->num_regs) {
-                return r->set_reg(cpu, mem_buf, reg - r->base_reg);
-            }
+    for (guint i = 0; i < cpu->gdb_regs->len; i++) {
+        r =  &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
+        if (r->base_reg <= reg && reg < r->base_reg + r->feature->num_regs) {
+            return r->set_reg(cpu, mem_buf, reg - r->base_reg);
         }
     }
     return 0;
 }
 
+static void gdb_register_feature(CPUState *cpu, int base_reg,
+                                 gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
+                                 const GDBFeature *feature)
+{
+    GDBRegisterState s = {
+        .base_reg = base_reg,
+        .get_reg = get_reg,
+        .set_reg = set_reg,
+        .feature = feature
+    };
+
+    g_array_append_val(cpu->gdb_regs, s);
+}
+
+void gdb_init_cpu(CPUState *cpu)
+{
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+    const GDBFeature *feature;
+
+    cpu->gdb_regs = g_array_new(false, false, sizeof(GDBRegisterState));
+
+    if (cc->gdb_core_xml_file) {
+        feature = gdb_find_static_feature(cc->gdb_core_xml_file);
+        gdb_register_feature(cpu, 0,
+                             cc->gdb_read_register, cc->gdb_write_register,
+                             feature);
+    }
+
+    cpu->gdb_num_regs = cpu->gdb_num_g_regs = cc->gdb_num_core_regs;
+}
+
 void gdb_register_coprocessor(CPUState *cpu,
                               gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
                               const GDBFeature *feature, int g_pos)
 {
     GDBRegisterState *s;
     guint i;
+    int base_reg = cpu->gdb_num_regs;
 
-    if (cpu->gdb_regs) {
-        for (i = 0; i < cpu->gdb_regs->len; i++) {
-            /* Check for duplicates.  */
-            s = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-            if (s->feature == feature) {
-                return;
-            }
+    for (i = 0; i < cpu->gdb_regs->len; i++) {
+        /* Check for duplicates.  */
+        s = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
+        if (s->feature == feature) {
+            return;
         }
-    } else {
-        cpu->gdb_regs = g_array_new(false, false, sizeof(GDBRegisterState));
-        i = 0;
     }
 
-    g_array_set_size(cpu->gdb_regs, i + 1);
-    s = &g_array_index(cpu->gdb_regs, GDBRegisterState, i);
-    s->base_reg = cpu->gdb_num_regs;
-    s->get_reg = get_reg;
-    s->set_reg = set_reg;
-    s->feature = feature;
+    gdb_register_feature(cpu, base_reg, get_reg, set_reg, feature);
 
     /* Add to end of list.  */
     cpu->gdb_num_regs += feature->num_regs;
     if (g_pos) {
-        if (g_pos != s->base_reg) {
+        if (g_pos != base_reg) {
             error_report("Error: Bad gdb register numbering for '%s', "
-                         "expected %d got %d", feature->xml,
-                         g_pos, s->base_reg);
+                         "expected %d got %d", feature->xml, g_pos, base_reg);
         } else {
             cpu->gdb_num_g_regs = cpu->gdb_num_regs;
         }
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 67db07741d7..fe16d0d9df8 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -27,6 +27,7 @@
 #include "qemu/main-loop.h"
 #include "exec/log.h"
 #include "exec/cpu-common.h"
+#include "exec/gdbstub.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "sysemu/tcg.h"
@@ -240,11 +241,10 @@ static void cpu_common_unrealizefn(DeviceState *dev)
 static void cpu_common_initfn(Object *obj)
 {
     CPUState *cpu = CPU(obj);
-    CPUClass *cc = CPU_GET_CLASS(obj);
 
+    gdb_init_cpu(cpu);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu->cluster_index = UNASSIGNED_CLUSTER_INDEX;
-    cpu->gdb_num_regs = cpu->gdb_num_g_regs = cc->gdb_num_core_regs;
     /* user-mode doesn't have configurable SMP topology */
     /* the default value is changed by qemu_init_vcpu() for system-mode */
     cpu->nr_cores = 1;
@@ -264,6 +264,7 @@ static void cpu_common_finalize(Object *obj)
 {
     CPUState *cpu = CPU(obj);
 
+    g_array_free(cpu->gdb_regs, TRUE);
     qemu_lockcnt_destroy(&cpu->in_ioctl_lock);
     qemu_mutex_destroy(&cpu->work_mutex);
 }
-- 
2.39.2


