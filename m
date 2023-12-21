Return-Path: <kvm+bounces-5051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDE381B435
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A618B25050
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279746EB71;
	Thu, 21 Dec 2023 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yc07EwN8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4B46D1D2
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40c41b43e1eso7702705e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155625; x=1703760425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ha0YdQiAm0Sb5o4T4mCAdJBoZ8w/bFrJlrZ9NOmRtI=;
        b=Yc07EwN8S1VhBwi1+s5VQnDrDC6+eyb21Vdnnn2Pab/cIeCS8Tn42ae9RjrWALIqs3
         jsjb80oN2w7IbQpMUs69pEYGRy+7wOG1VVkpUJ17HA/MU1KK9gkmaAMpQz4/co8l7ZRA
         Y3eniHlF/BDL98Vki7PVUHFGciaJq7iND/RIFthpGaFEDaoGaJZKZ73hbTpN5AfJcM8x
         PZiOh95VCKlq2TlqgBzf69PcP6cF0HOY9t/N8qJ/74qH46m8gumZjIAzYwJWpkA2Rmtk
         +IQDc/AaNciM0so9bfbPaoU+Y5ULrWT3G3l/xiC/V4x8jKmojr8s3wWBQX7ejnvOYM0C
         aPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155625; x=1703760425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Ha0YdQiAm0Sb5o4T4mCAdJBoZ8w/bFrJlrZ9NOmRtI=;
        b=JjZTHqo3nq6zdeLejFh9jV+RicS3xE7LxUWwiKp2iucoACD6uSqGpClzgMyoT8OQPr
         OMtQYm6DM7VS9pKeVhv704Jsd2lbONz8HnsLHz94d4GTCTN4sYy4qAWEhvt4N6AGj9pg
         EoDQkRuDhUdbXKyDs03fFOPIGnyteMbQapAMphf3EMCba8ONwziu/OZ5J3xa9hhHEheb
         YmqdwE945lUMLXboIm/J7j/jvOu9uv/3y4n0+MBbne8svakt2C/hVDFrwMIIoNTDrCDr
         /jnsPggM4usbpRlVT5YbFXCaGWM2JV7GCZAr1uKHGNGRnpgealUgPIY/VFMN73FIxBCx
         v9LA==
X-Gm-Message-State: AOJu0Yx0r1j6YVH441O9TClXV14Umh+RR5sGO4wQMeteBo28YDDaU63S
	IB0gJs2vcKNvSYoNFrscT2mzoQ==
X-Google-Smtp-Source: AGHT+IGUTVKhDUmyAgZ6+bhARaeHcRLqpq4xPHd/kAhW+Y9B+RlN417aCKsMB3wWJykPGxE2PFmR+Q==
X-Received: by 2002:a05:600c:3786:b0:40d:3bdc:3752 with SMTP id o6-20020a05600c378600b0040d3bdc3752mr520912wmr.191.1703155624651;
        Thu, 21 Dec 2023 02:47:04 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b2-20020a05600c4e0200b0040c440f9393sm3526366wmq.42.2023.12.21.02.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:47:01 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 149675F8FC;
	Thu, 21 Dec 2023 10:38:22 +0000 (GMT)
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
Subject: [PATCH 31/40] gdbstub: Simplify XML lookup
Date: Thu, 21 Dec 2023 10:38:09 +0000
Message-Id: <20231221103818.1633766-32-alex.bennee@linaro.org>
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

Now we know all instances of GDBFeature that is used in CPU so we can
traverse them to find XML. This removes the need for a CPU-specific
lookup function for dynamic XMLs.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
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
index 82dae51a550..cd7903ba6e7 100644
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
@@ -238,11 +239,10 @@ static void cpu_common_unrealizefn(DeviceState *dev)
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
@@ -262,6 +262,7 @@ static void cpu_common_finalize(Object *obj)
 {
     CPUState *cpu = CPU(obj);
 
+    g_array_free(cpu->gdb_regs, TRUE);
     qemu_lockcnt_destroy(&cpu->in_ioctl_lock);
     qemu_mutex_destroy(&cpu->work_mutex);
 }
-- 
2.39.2


