Return-Path: <kvm+bounces-5569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DF382338B
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D1B9284586
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F761CAB9;
	Wed,  3 Jan 2024 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wbk9+ZJc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59E1CA8C
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40d89446895so4431375e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303552; x=1704908352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctlsx5qTTsFuiHpWia+LYNCfPNohh0GYQvm+lOAMVvc=;
        b=wbk9+ZJc/9HD0NsKDTzOI3oyiJKh9MpUDvCZUSuPuD/+30RX5hgUqrSNhlNxfLgAY7
         6lyPYmny/DxCkHVWFryibgshdDU269WmNwwZKBq05mIylWToS5rMdbdvLUDx9KR3pP3p
         1spyUCyeOZdPkZ5TEHVfPt5Vr/UGhuTRZPwxUPYNYv+Q41vq1KqlSr3EdSQAxgUsE9NM
         a4k6VYLsoRAKeGTU6zj7nruIiU8l4kcYzN2Oo/QtfPtRl9di/yIALS6vcG5LTEuIkW7k
         Z4FBLY0HPYrVa/ZJ877rt9WcGlsKdHFMn0JP0DR9+6hlUeKXfhEQrWxMNNQlpOAPLIPI
         vMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303552; x=1704908352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctlsx5qTTsFuiHpWia+LYNCfPNohh0GYQvm+lOAMVvc=;
        b=ncjCPty9XJ5I0nPSFY4HSBDTNlmsjpnIqQhVZtXkhV8hdyF6162HOKRaQEh+MoU3kY
         grBFP5oGtDCDIju+Eh1y0F0EhOgAl2u+nutwPfqO4eA5tYarHkOHegEGoiNcKkb8PP/f
         8o09vGboh5IcVyjznbAURDCVEiTv5kv2DuDYMi+ibP4U+nCwVRr0d9/gqAzc0jesHoqT
         +WzQ1iJZRx9EMJrXFDcOUIgkqHQi1BkTrAcTaKPIc9hXzyDK+/D9WmbD3wyutTzSfZ36
         dikd9fhv1fBCxvyrOYe2rTbDsYTvFFAMbsjmCKoO0dC1BzqPaqZZXnNy6GBeGIDBBhPp
         0/UQ==
X-Gm-Message-State: AOJu0Yzl47AJ6dj4q35YWlhGdJwu7fkVByqXIBLfS8NM1edFYEDbdd35
	yyZxgnBd0B+K9FawngxY7JARPrrGdkl7lg==
X-Google-Smtp-Source: AGHT+IEuHutLYteo6vG6WlNBeXWADd3eSquGtGu+n6EBwY95PnWE283bmkTL7IK2oAEJ7tDzHj2jSw==
X-Received: by 2002:a05:600c:3b08:b0:40d:8586:82c5 with SMTP id m8-20020a05600c3b0800b0040d858682c5mr706985wms.12.1704303552097;
        Wed, 03 Jan 2024 09:39:12 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z1-20020a05600c0a0100b0040c3953cda5sm2984624wmp.45.2024.01.03.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:39:08 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 83FBF5F9D6;
	Wed,  3 Jan 2024 17:33:53 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v2 41/43] contrib/plugins: optimise the register value tracking
Date: Wed,  3 Jan 2024 17:33:47 +0000
Message-Id: <20240103173349.398526-42-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This adds an additional flag which attempts to optimise the register
tracking by only instrumenting instructions which are likely to change
its value. This relies on the disassembler showing up the register
names in disassembly so is only enabled when asked for.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 docs/devel/tcg-plugins.rst |  10 +-
 contrib/plugins/execlog.c  | 189 ++++++++++++++++++++++++++++++-------
 2 files changed, 165 insertions(+), 34 deletions(-)

diff --git a/docs/devel/tcg-plugins.rst b/docs/devel/tcg-plugins.rst
index 3a0962723d7..fa7421279f5 100644
--- a/docs/devel/tcg-plugins.rst
+++ b/docs/devel/tcg-plugins.rst
@@ -503,7 +503,15 @@ registers with multiple ``reg`` options. You can also use glob style matching if
   $ qemu-system-arm $(QEMU_ARGS) \
     -plugin ./contrib/plugins/libexeclog.so,reg=\*_el2,reg=sp -d plugin
 
-Be aware that each additional register to check will slow down execution quite considerably.
+Be aware that each additional register to check will slow down
+execution quite considerably. You can optimise the number of register
+checks done by using the rdisas option. This will only instrument
+instructions that mention the registers in question in disassembly.
+This is not foolproof as some instructions implicitly change
+instructions. You can use the ifilter to catch these cases:
+
+  $ qemu-system-arm $(QEMU_ARGS) \
+    -plugin ./contrib/plugins/libexeclog.so,ifilter=msr,ifilter=blr,reg=x30,reg=\*_el1,rdisas=on
 
 - contrib/plugins/cache.c
 
diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
index c20e88a6941..a5269baf067 100644
--- a/contrib/plugins/execlog.c
+++ b/contrib/plugins/execlog.c
@@ -27,6 +27,7 @@ typedef struct CPU {
     GString *last_exec;
     /* Ptr array of Register */
     GPtrArray *registers;
+    int index;
 } CPU;
 
 QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
@@ -38,6 +39,9 @@ static GRWLock expand_array_lock;
 static GPtrArray *imatches;
 static GArray *amatches;
 static GPtrArray *rmatches;
+static bool disas_assist;
+static GMutex add_reg_name_lock;
+static GPtrArray *all_reg_names;
 
 /**
  * Add memory read or write information to current instruction log
@@ -72,9 +76,14 @@ static void vcpu_mem(unsigned int cpu_index, qemu_plugin_meminfo_t info,
 }
 
 /**
- * Log instruction execution
+ * Log instruction execution, outputting the last one.
+ *
+ * vcpu_insn_exec() is a copy and paste of vcpu_insn_exec_with_regs()
+ * without the checking of register values when we've attempted to
+ * optimise with disas_assist.
  */
-static void vcpu_insn_exec(unsigned int cpu_index, void *udata)
+
+static CPU *get_cpu(int cpu_index)
 {
     CPU *cpu;
 
@@ -83,39 +92,87 @@ static void vcpu_insn_exec(unsigned int cpu_index, void *udata)
     cpu = &cpus[cpu_index];
     g_rw_lock_reader_unlock(&expand_array_lock);
 
+    return cpu;
+}
+
+static void insn_check_regs(CPU *cpu) {
+    for (int n = 0; n < cpu->registers->len; n++) {
+        Register *reg = cpu->registers->pdata[n];
+        int sz;
+
+        g_byte_array_set_size(reg->new, 0);
+        sz = qemu_plugin_read_register(cpu->index, reg->handle, reg->new);
+        g_assert(sz == reg->last->len);
+
+        if (memcmp(reg->last->data, reg->new->data, sz)) {
+            GByteArray *temp = reg->last;
+            g_string_append_printf(cpu->last_exec, ", %s -> 0x", reg->name);
+            /* TODO: handle BE properly */
+            for (int i = sz; i >= 0; i--) {
+                g_string_append_printf(cpu->last_exec, "%02x",
+                                       reg->new->data[i]);
+            }
+            reg->last = reg->new;
+            reg->new = temp;
+        }
+    }
+}
+
+/* Log last instruction while checking registers */
+static void vcpu_insn_exec_with_regs(unsigned int cpu_index, void *udata)
+{
+    CPU *cpu = get_cpu(cpu_index);
+
     /* Print previous instruction in cache */
     if (cpu->last_exec->len) {
         if (cpu->registers) {
-            for (int n = 0; n < cpu->registers->len; n++) {
-                Register *reg = cpu->registers->pdata[n];
-                int sz;
-
-                g_byte_array_set_size(reg->new, 0);
-                sz = qemu_plugin_read_register(cpu_index, reg->handle, reg->new);
-                g_assert(sz == reg->last->len);
-
-                if (memcmp(reg->last->data, reg->new->data, sz)) {
-                    GByteArray *temp = reg->last;
-                    g_string_append_printf(cpu->last_exec, ", %s -> 0x", reg->name);
-                    /* TODO: handle BE properly */
-                    for (int i = sz; i >= 0; i--) {
-                        g_string_append_printf(cpu->last_exec, "%02x",
-                                               reg->new->data[i]);
-                    }
-                    reg->last = reg->new;
-                    reg->new = temp;
-                }
-            }
+            insn_check_regs(cpu);
+        }
+
+        qemu_plugin_outs(cpu->last_exec->str);
+        qemu_plugin_outs("\n");
+    }
+
+    /* Store new instruction in cache */
+    /* vcpu_mem will add memory access information to last_exec */
+    g_string_printf(cpu->last_exec, "%u, ", cpu_index);
+    g_string_append(cpu->last_exec, (char *)udata);
+}
+
+/* Log last instruction while checking registers, ignore next */
+static void vcpu_insn_exec_only_regs(unsigned int cpu_index, void *udata)
+{
+    CPU *cpu = get_cpu(cpu_index);
+
+    /* Print previous instruction in cache */
+    if (cpu->last_exec->len) {
+        if (cpu->registers) {
+            insn_check_regs(cpu);
         }
 
         qemu_plugin_outs(cpu->last_exec->str);
         qemu_plugin_outs("\n");
     }
 
+    /* reset */
+    cpu->last_exec->len = 0;
+}
+
+/* Log last instruction without checking regs, setup next */
+static void vcpu_insn_exec(unsigned int cpu_index, void *udata)
+{
+    CPU *cpu = get_cpu(cpu_index);
+
+    /* Print previous instruction in cache */
+    if (cpu->last_exec->len) {
+        qemu_plugin_outs(cpu->last_exec->str);
+        qemu_plugin_outs("\n");
+    }
+
     /* Store new instruction in cache */
     /* vcpu_mem will add memory access information to last_exec */
-    g_string_printf(cpus[cpu_index].last_exec, "%u, ", cpu_index);
-    g_string_append(cpus[cpu_index].last_exec, (char *)udata);
+    g_string_printf(cpu->last_exec, "%u, ", cpu_index);
+    g_string_append(cpu->last_exec, (char *)udata);
 }
 
 /**
@@ -128,6 +185,8 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
 {
     struct qemu_plugin_insn *insn;
     bool skip = (imatches || amatches);
+    bool check_regs_this = rmatches;
+    bool check_regs_next = false;
 
     size_t n = qemu_plugin_tb_n_insns(tb);
     for (size_t i = 0; i < n; i++) {
@@ -148,7 +207,8 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
         /*
          * If we are filtering we better check out if we have any
          * hits. The skip "latches" so we can track memory accesses
-         * after the instruction we care about.
+         * after the instruction we care about. Also enable register
+         * checking on the next instruction.
          */
         if (skip && imatches) {
             int j;
@@ -156,6 +216,7 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
                 char *m = g_ptr_array_index(imatches, j);
                 if (g_str_has_prefix(insn_disas, m)) {
                     skip = false;
+                    check_regs_next = rmatches;
                 }
             }
         }
@@ -170,8 +231,38 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
             }
         }
 
+        /*
+         * Check the disassembly to see if a register we care about
+         * will be affected by this instruction. This relies on the
+         * dissembler doing something sensible for the registers we
+         * care about.
+         */
+        if (disas_assist && rmatches) {
+            check_regs_next = false;
+            gchar *args = g_strstr_len(insn_disas, -1, " ");
+            for (int n = 0; n < all_reg_names->len; n++) {
+                gchar *reg = g_ptr_array_index(all_reg_names, n);
+                if (g_strrstr(args, reg)) {
+                    check_regs_next = true;
+                    skip = false;
+                }
+            }
+        }
+
+        /*
+         * We now have 3 choices:
+         *
+         * Log this instruction normally
+         * Log this instruction checking for register changes
+         * Don't log this instruction but check for register changes from the last one
+         */
+
         if (skip) {
-            g_free(insn_disas);
+            if (check_regs_this) {
+                qemu_plugin_register_vcpu_insn_exec_cb(insn,
+                                                       vcpu_insn_exec_only_regs,
+                                                       QEMU_PLUGIN_CB_R_REGS, NULL);
+            }
         } else {
             uint32_t insn_opcode;
             insn_opcode = *((uint32_t *)qemu_plugin_insn_data(insn));
@@ -184,15 +275,28 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
                                              QEMU_PLUGIN_MEM_RW, NULL);
 
             /* Register callback on instruction */
-            qemu_plugin_register_vcpu_insn_exec_cb(
-                insn, vcpu_insn_exec,
-                rmatches ? QEMU_PLUGIN_CB_R_REGS : QEMU_PLUGIN_CB_NO_REGS,
-                output);
+            if (check_regs_this) {
+                qemu_plugin_register_vcpu_insn_exec_cb(
+                    insn, vcpu_insn_exec_with_regs,
+                    QEMU_PLUGIN_CB_R_REGS,
+                    output);
+            } else {
+                qemu_plugin_register_vcpu_insn_exec_cb(
+                    insn, vcpu_insn_exec,
+                    QEMU_PLUGIN_CB_NO_REGS,
+                    output);
+            }
 
             /* reset skip */
             skip = (imatches || amatches);
         }
 
+        /* set regs for next */
+        if (disas_assist && rmatches) {
+            check_regs_this = check_regs_next;
+        }
+
+        g_free(insn_disas);
     }
 }
 
@@ -200,10 +304,11 @@ static Register *init_vcpu_register(int vcpu_index,
                                     qemu_plugin_reg_descriptor *desc)
 {
     Register *reg = g_new0(Register, 1);
+    g_autofree gchar *lower = g_utf8_strdown(desc->name, -1);
     int r;
 
     reg->handle = desc->handle;
-    reg->name = g_strdup(desc->name);
+    reg->name = g_intern_string(lower);
     reg->last = g_byte_array_new();
     reg->new = g_byte_array_new();
 
@@ -213,7 +318,7 @@ static Register *init_vcpu_register(int vcpu_index,
     return reg;
 }
 
-static registers_init(int vcpu_index)
+static void registers_init(int vcpu_index)
 {
     GPtrArray *registers = g_ptr_array_new();
     g_autoptr(GArray) reg_list = qemu_plugin_get_registers(vcpu_index);
@@ -228,9 +333,20 @@ static registers_init(int vcpu_index)
                 reg_list, qemu_plugin_reg_descriptor, r);
             for (int p = 0; p < rmatches->len; p++) {
                 g_autoptr(GPatternSpec) pat = g_pattern_spec_new(rmatches->pdata[p]);
-                if (g_pattern_match_string(pat, rd->name)) {
+                g_autofree gchar *rd_lower = g_utf8_strdown(rd->name, -1);
+                if (g_pattern_match_string(pat, rd->name) ||
+                    g_pattern_match_string(pat, rd_lower)) {
                     Register *reg = init_vcpu_register(vcpu_index, rd);
                     g_ptr_array_add(registers, reg);
+
+                    /* we need a list of regnames at TB translation time */
+                    if (disas_assist) {
+                        g_mutex_lock(&add_reg_name_lock);
+                        if (!g_ptr_array_find(all_reg_names, reg->name, NULL)) {
+                            g_ptr_array_add(all_reg_names, reg->name);
+                        }
+                        g_mutex_unlock(&add_reg_name_lock);
+                    }
                 }
             }
         }
@@ -254,6 +370,7 @@ static void vcpu_init(qemu_plugin_id_t id, unsigned int vcpu_index)
     if (vcpu_index >= num_cpus) {
         cpus = g_realloc_n(cpus, vcpu_index + 1, sizeof(*cpus));
         while (vcpu_index >= num_cpus) {
+            cpus[num_cpus].index = vcpu_index;
             cpus[num_cpus].last_exec = g_string_new(NULL);
 
             /* Any registers to track? */
@@ -336,6 +453,12 @@ QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
             parse_vaddr_match(tokens[1]);
         } else if (g_strcmp0(tokens[0], "reg") == 0) {
             add_regpat(tokens[1]);
+        } else if (g_strcmp0(tokens[0], "rdisas") == 0) {
+            if (!qemu_plugin_bool_parse(tokens[0], tokens[1], &disas_assist)) {
+                fprintf(stderr, "boolean argument parsing failed: %s\n", opt);
+                return -1;
+            }
+            all_reg_names = g_ptr_array_new();
         } else {
             fprintf(stderr, "option parsing failed: %s\n", opt);
             return -1;
-- 
2.39.2


