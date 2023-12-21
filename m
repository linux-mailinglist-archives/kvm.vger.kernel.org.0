Return-Path: <kvm+bounces-5038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 526D281B3D9
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7730E1C218E7
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA6774E05;
	Thu, 21 Dec 2023 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yiMIfwho"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096D6745DA
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-336746a545fso348456f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155116; x=1703759916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tni7Imx3Pjpb/P2RaecCTAhCw0hkxgjQ9otB8cA5Yw=;
        b=yiMIfwhoAfNsa94cU1vpVdd/f8MygsX4CtpMpu2nGDu4G7uHaJnsuL3vmj/Ri4PHJO
         7NoaSYbnAwKRJkr2xIfLsPknNorFbOlXiTJoHrXA6Z41Vxhsyo/3VJ3fStwJ3uT3sBCD
         vP+rijmVegWlAqYlfcDC8+Pe/HzflRRSz0KR3gxloGquVY/pfztAi/lIU4mdmzXrmKtY
         s63n1NJtSMs8vaSr6yAMpV3BHOL5FTwM+w/9E75chV7+hvUymysDV/IlX7VcMzXqbBMK
         ZbHUswg9HGQ3CqX7jkA43IQotKOoGDUx8x5bS7tUkv99AfTnAno4L6CNIb1bKOM1Vhvu
         y6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155116; x=1703759916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tni7Imx3Pjpb/P2RaecCTAhCw0hkxgjQ9otB8cA5Yw=;
        b=WjJJ0ebllaHqLMQtDFZudkZJ5d6519sv4O1e9tH+zBZN2edZHt6OBEISc0HlKP7PrT
         dsYZ5XFCO/8bog8LXy9tpvZ1TdQKGU5PyuAKITYDE/h/Ck9ysEeA/UOOmAYwrEfJbOUQ
         IbeZeMXtIn4DLTFvfwEFQxWqpqnGZ6iWWwC3znpFTb5LLntHUTjaGYWq3GAxJgE/PDWS
         38XjOG4Aylui/tUoEgQxeaqi4050EPAQQDyCfUi/yWgE/Vi4JfGv2r06KXmGaxXwm9Jq
         khqJIwYrCLHRB6sZjxjGZudol3zVg/WSytu1LyLfzrBWeFIIpGRvCyDa2De9N+MGMkko
         NllQ==
X-Gm-Message-State: AOJu0Yzvpe2+fOLI1oWxGej6PyykNedFcFcw7KA4N9NU4NHG+U56lCTx
	eadWR+WME1L+O9jIbIY6Fze5xQ==
X-Google-Smtp-Source: AGHT+IEmgwUrQGItU/kS8QE6ER+3oacN4swsxweU2syrhsw7IrOweX++Kl6ab1wF0c4GvewPaeKx/g==
X-Received: by 2002:a5d:6a4e:0:b0:336:8d2e:77a1 with SMTP id t14-20020a5d6a4e000000b003368d2e77a1mr19167wrw.47.1703155116350;
        Thu, 21 Dec 2023 02:38:36 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e25-20020adfa459000000b003365951cef9sm1737078wra.55.2023.12.21.02.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:34 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id EE6705F8C5;
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
Subject: [PATCH 39/40] contrib/plugins: extend execlog to track register changes
Date: Thu, 21 Dec 2023 10:38:17 +0000
Message-Id: <20231221103818.1633766-40-alex.bennee@linaro.org>
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

With the new plugin register API we can now track changes to register
values. Currently the implementation is fairly dumb which will slow
down if a large number of register values are being tracked. This
could be improved by only instrumenting instructions which mention
registers we are interested in tracking.

Example usage:

  ./qemu-aarch64 -D plugin.log -d plugin \
     -cpu max,sve256=on \
     -plugin contrib/plugins/libexeclog.so,reg=sp,reg=z\* \
     ./tests/tcg/aarch64-linux-user/sha512-sve

will display in the execlog any changes to the stack pointer (sp) and
the SVE Z registers.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Based-On: <20231025093128.33116-19-akihiko.odaki@daynix.com>

---
v2
  - we now do the glob-like search in the plugin itself.
  - fix some erroneous cpus->cpu

vAJB:

Changes for the new API with a simpler glob based "reg" specifier
which can be specified multiple times.
---
 docs/devel/tcg-plugins.rst |   9 +-
 contrib/plugins/execlog.c  | 189 ++++++++++++++++++++++++++++---------
 2 files changed, 153 insertions(+), 45 deletions(-)

diff --git a/docs/devel/tcg-plugins.rst b/docs/devel/tcg-plugins.rst
index 81dcd43a612..3a0962723d7 100644
--- a/docs/devel/tcg-plugins.rst
+++ b/docs/devel/tcg-plugins.rst
@@ -497,6 +497,14 @@ arguments if required::
   $ qemu-system-arm $(QEMU_ARGS) \
     -plugin ./contrib/plugins/libexeclog.so,ifilter=st1w,afilter=0x40001808 -d plugin
 
+This plugin can also dump registers when they change value. Specify the name of the
+registers with multiple ``reg`` options. You can also use glob style matching if you wish::
+
+  $ qemu-system-arm $(QEMU_ARGS) \
+    -plugin ./contrib/plugins/libexeclog.so,reg=\*_el2,reg=sp -d plugin
+
+Be aware that each additional register to check will slow down execution quite considerably.
+
 - contrib/plugins/cache.c
 
 Cache modelling plugin that measures the performance of a given L1 cache
@@ -583,4 +591,3 @@ The following API is generated from the inline documentation in
 include the full kernel-doc annotations.
 
 .. kernel-doc:: include/qemu/qemu-plugin.h
-
diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
index f262e5555eb..74fbf7c0e60 100644
--- a/contrib/plugins/execlog.c
+++ b/contrib/plugins/execlog.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2021, Alexandre Iooss <erdnaxe@crans.org>
  *
- * Log instruction execution with memory access.
+ * Log instruction execution with memory access and register changes
  *
  * License: GNU GPL, version 2 or later.
  *   See the COPYING file in the top-level directory.
@@ -15,30 +15,29 @@
 
 #include <qemu-plugin.h>
 
+typedef struct {
+    struct qemu_plugin_register *handle;
+    GByteArray *last;
+    GByteArray *new;
+    const char *name;
+} Register;
+
+typedef struct CPU {
+    /* Store last executed instruction on each vCPU as a GString */
+    GString *last_exec;
+    /* Ptr array of Register */
+    GPtrArray *registers;
+} CPU;
+
 QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
 
-/* Store last executed instruction on each vCPU as a GString */
-static GPtrArray *last_exec;
+static CPU *cpus;
+static int num_cpus;
 static GRWLock expand_array_lock;
 
 static GPtrArray *imatches;
 static GArray *amatches;
-
-/*
- * Expand last_exec array.
- *
- * As we could have multiple threads trying to do this we need to
- * serialise the expansion under a lock.
- */
-static void expand_last_exec(int cpu_index)
-{
-    g_rw_lock_writer_lock(&expand_array_lock);
-    while (cpu_index >= last_exec->len) {
-        GString *s = g_string_new(NULL);
-        g_ptr_array_add(last_exec, s);
-    }
-    g_rw_lock_writer_unlock(&expand_array_lock);
-}
+static GPtrArray *rmatches;
 
 /**
  * Add memory read or write information to current instruction log
@@ -50,8 +49,8 @@ static void vcpu_mem(unsigned int cpu_index, qemu_plugin_meminfo_t info,
 
     /* Find vCPU in array */
     g_rw_lock_reader_lock(&expand_array_lock);
-    g_assert(cpu_index < last_exec->len);
-    s = g_ptr_array_index(last_exec, cpu_index);
+    g_assert(cpu_index < num_cpus);
+    s = cpus[cpu_index].last_exec;
     g_rw_lock_reader_unlock(&expand_array_lock);
 
     /* Indicate type of memory access */
@@ -77,28 +76,46 @@ static void vcpu_mem(unsigned int cpu_index, qemu_plugin_meminfo_t info,
  */
 static void vcpu_insn_exec(unsigned int cpu_index, void *udata)
 {
-    GString *s;
+    CPU *cpu;
 
-    /* Find or create vCPU in array */
     g_rw_lock_reader_lock(&expand_array_lock);
-    if (cpu_index >= last_exec->len) {
-        g_rw_lock_reader_unlock(&expand_array_lock);
-        expand_last_exec(cpu_index);
-        g_rw_lock_reader_lock(&expand_array_lock);
-    }
-    s = g_ptr_array_index(last_exec, cpu_index);
+    g_assert(cpu_index < num_cpus);
+    cpu = &cpus[cpu_index];
     g_rw_lock_reader_unlock(&expand_array_lock);
 
     /* Print previous instruction in cache */
-    if (s->len) {
-        qemu_plugin_outs(s->str);
+    if (cpu->last_exec->len) {
+        if (cpu->registers) {
+            for (int n = 0; n < cpu->registers->len; n++) {
+                Register *reg = cpu->registers->pdata[n];
+                int sz;
+
+                g_byte_array_set_size(reg->new, 0);
+                sz = qemu_plugin_read_register(cpu_index, reg->handle, reg->new);
+                g_assert(sz == reg->last->len);
+
+                if (memcmp(reg->last->data, reg->new->data, sz)) {
+                    GByteArray *temp = reg->last;
+                    g_string_append_printf(cpu->last_exec, ", %s -> ", reg->name);
+                    /* TODO: handle BE properly */
+                    for (int i = sz; i >= 0; i--) {
+                        g_string_append_printf(cpu->last_exec, "%02x",
+                                               reg->new->data[i]);
+                    }
+                    reg->last = reg->new;
+                    reg->new = temp;
+                }
+            }
+        }
+
+        qemu_plugin_outs(cpu->last_exec->str);
         qemu_plugin_outs("\n");
     }
 
     /* Store new instruction in cache */
     /* vcpu_mem will add memory access information to last_exec */
-    g_string_printf(s, "%u, ", cpu_index);
-    g_string_append(s, (char *)udata);
+    g_string_printf(cpus[cpu_index].last_exec, "%u, ", cpu_index);
+    g_string_append(cpus[cpu_index].last_exec, (char *)udata);
 }
 
 /**
@@ -167,8 +184,10 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
                                              QEMU_PLUGIN_MEM_RW, NULL);
 
             /* Register callback on instruction */
-            qemu_plugin_register_vcpu_insn_exec_cb(insn, vcpu_insn_exec,
-                                                   QEMU_PLUGIN_CB_NO_REGS, output);
+            qemu_plugin_register_vcpu_insn_exec_cb(
+                insn, vcpu_insn_exec,
+                rmatches ? QEMU_PLUGIN_CB_R_REGS : QEMU_PLUGIN_CB_NO_REGS,
+                output);
 
             /* reset skip */
             skip = (imatches || amatches);
@@ -177,17 +196,86 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
     }
 }
 
+static Register *init_vcpu_register(int vcpu_index,
+                                    qemu_plugin_reg_descriptor *desc)
+{
+    Register *reg = g_new0(Register, 1);
+    int r;
+
+    reg->handle = desc->handle;
+    reg->name = g_strdup(desc->name);
+    reg->last = g_byte_array_new();
+    reg->new = g_byte_array_new();
+
+    /* read the initial value */
+    r = qemu_plugin_read_register(vcpu_index, reg->handle, reg->last);
+    g_assert(r > 0);
+    return reg;
+}
+
+static registers_init(int vcpu_index)
+{
+    GPtrArray *registers = g_ptr_array_new();
+    g_autoptr(GArray) reg_list = qemu_plugin_get_registers(vcpu_index);
+
+    if (reg_list && reg_list->len) {
+        /*
+         * Go through each register in the complete list and
+         * see if we want to track it.
+         */
+        for (int r = 0; r < reg_list->len; r++) {
+            qemu_plugin_reg_descriptor *rd = &g_array_index(
+                reg_list, qemu_plugin_reg_descriptor, r);
+            for (int p = 0; p < rmatches->len; p++) {
+                g_autoptr(GPatternSpec) pat = g_pattern_spec_new(rmatches->pdata[p]);
+                if (g_pattern_match_string(pat, rd->name)) {
+                    Register *reg = init_vcpu_register(vcpu_index, rd);
+                    g_ptr_array_add(registers, reg);
+                }
+            }
+        }
+    }
+    cpus[num_cpus].registers = registers;
+}
+
+/*
+ * Initialise a new vcpu/thread with:
+ *   - last_exec tracking data
+ *   - list of tracked registers
+ *   - initial value of registers
+ *
+ * As we could have multiple threads trying to do this we need to
+ * serialise the expansion under a lock.
+ */
+static void vcpu_init(qemu_plugin_id_t id, unsigned int vcpu_index)
+{
+    g_rw_lock_writer_lock(&expand_array_lock);
+
+    if (vcpu_index >= num_cpus) {
+        cpus = g_realloc_n(cpus, vcpu_index + 1, sizeof(*cpus));
+        while (vcpu_index >= num_cpus) {
+            cpus[num_cpus].last_exec = g_string_new(NULL);
+
+            /* Any registers to track? */
+            if (rmatches && rmatches->len) {
+                registers_init(vcpu_index);
+            }
+            num_cpus++;
+        }
+    }
+
+    g_rw_lock_writer_unlock(&expand_array_lock);
+}
+
 /**
  * On plugin exit, print last instruction in cache
  */
 static void plugin_exit(qemu_plugin_id_t id, void *p)
 {
     guint i;
-    GString *s;
-    for (i = 0; i < last_exec->len; i++) {
-        s = g_ptr_array_index(last_exec, i);
-        if (s->str) {
-            qemu_plugin_outs(s->str);
+    for (i = 0; i < num_cpus; i++) {
+        if (cpus[i].last_exec->str) {
+            qemu_plugin_outs(cpus[i].last_exec->str);
             qemu_plugin_outs("\n");
         }
     }
@@ -212,6 +300,18 @@ static void parse_vaddr_match(char *match)
     g_array_append_val(amatches, v);
 }
 
+/*
+ * We have to wait until vCPUs are started before we can check the
+ * patterns find anything.
+ */
+static void add_regpat(char *regpat)
+{
+    if (!rmatches) {
+        rmatches = g_ptr_array_new();
+    }
+    g_ptr_array_add(rmatches, g_strdup(regpat));
+}
+
 /**
  * Install the plugin
  */
@@ -224,9 +324,7 @@ QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
      * we don't know the size before emulation.
      */
     if (info->system_emulation) {
-        last_exec = g_ptr_array_sized_new(info->system.max_vcpus);
-    } else {
-        last_exec = g_ptr_array_new();
+        cpus = g_new(CPU, info->system.max_vcpus);
     }
 
     for (int i = 0; i < argc; i++) {
@@ -236,13 +334,16 @@ QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
             parse_insn_match(tokens[1]);
         } else if (g_strcmp0(tokens[0], "afilter") == 0) {
             parse_vaddr_match(tokens[1]);
+        } else if (g_strcmp0(tokens[0], "reg") == 0) {
+            add_regpat(tokens[1]);
         } else {
             fprintf(stderr, "option parsing failed: %s\n", opt);
             return -1;
         }
     }
 
-    /* Register translation block and exit callbacks */
+    /* Register init, translation block and exit callbacks */
+    qemu_plugin_register_vcpu_init_cb(id, vcpu_init);
     qemu_plugin_register_vcpu_tb_trans_cb(id, vcpu_tb_trans);
     qemu_plugin_register_atexit_cb(id, plugin_exit, NULL);
 
-- 
2.39.2


