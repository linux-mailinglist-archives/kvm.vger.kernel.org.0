Return-Path: <kvm+bounces-6566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F523836818
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1FBB285F67
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE285EE62;
	Mon, 22 Jan 2024 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wvn3auy9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459575D8FF
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935694; cv=none; b=VVvJlx3dPpypbURrfW6EGW1BsbJLaC9X2FKUQavziOYZTnY/USt9A0dUcStTieYaVMZbxuxak9wImyBkiqGLyt9XgDZO5i9ksqF05yGEtT3+3LNbbIK3v0gzA1VsEQ4qSNk7WHH4zz7VnPVW08HC/cIR0dcDFszjzb1lAQqllKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935694; c=relaxed/simple;
	bh=lSS2wXL+lOuwd/5Ck3XcZ+APuI76bAPJI/U5VPqMcZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiV5PFk2pRXU4tj4upROIgZ3o+UPbI+XKnKv5Ym8MPBn/a/CNAMUqMMCoCPQOW2cnCqO0JsuigXOdTHRrH3DLFiek98nPcltnn9j60GPIeFZkTisWRJnCa9+CnOhlX4Udb4OuaL1XSuJaNa9URtziXdJF1vVOPlSSen3eKbYop4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wvn3auy9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40e5afc18f5so36322225e9.3
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 07:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935689; x=1706540489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF+6vtEK4gOK8l8PcBJA0ii9SNWLkvGPJjhyZu+R33w=;
        b=Wvn3auy9WuW0+Hd5DWWDNECBL3/+0RxhcyzqZlGvmAOwiE4i7Szvdni3Pb2uJRKYTS
         iEJZmmlXnq2C/CbTnQMuI4XQb5ebLWYQfV2j39iHAo6YVMxZBgRIBmHEASGWLj7cwC3T
         FZwpgMMMb85NI0donR+vShyrcRxolPoeyq499bYsLo/fHZwV7KK9wv7kCVbdvm5uuA0Q
         6OwHs9Zuvte2qpO2Hxm+ApZywlktV4iHHxlYGQNUOFhfcaSUjuJ5f+v9+7JV1gjR0qWC
         ryL10JCDqQdmPkwEv7E6BdJH66tIY2g6plOqLL+WfcoPKaRYnpbERACMQB7XMq4z5a/4
         Kh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935689; x=1706540489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aF+6vtEK4gOK8l8PcBJA0ii9SNWLkvGPJjhyZu+R33w=;
        b=rtjquiY/P2IiqxRAFxbgEj02jUL+BnGOyJ2ZH3ml6ibcCUL0Io6yRjeoMtppzRU5J0
         okDFF1SAAX4j0Of5CxsVSAx7W/ri/Fpxi8OWaF9miJgE4BwTM4MUoNiSeBorHq932sz2
         2oQWvpLKR6e9X25CL3Nzc1knUv6hm4rwBWwUV7hPR33JwEL3PN35bVgD/gFqJt39NHk0
         6n/fj0wQBBZJlxfxqc9iGnjoAPHNsWjIQhkhloP7QdpqN5GWcrGAuSTTqul4saVs9fZO
         vp4EOIuiABRQ45sveAMiub2QsS+v7ijiCD6nf9cuGGCBkVH+LvVNOTgLO2dNIotvhXbV
         GJkA==
X-Gm-Message-State: AOJu0YwXr33tuaOzN9or6B3uGNmkgfy6XaiNP2SrXoo29mXmcHaYm4QW
	FMoT8AVt7aq5nkn3mKQyEDFirCzUfMOrAJx3sPzQnZ155JrzC8IGWLagyzah/bg=
X-Google-Smtp-Source: AGHT+IEkkXBbReLPWaxRMRYzLQ8sUu7Oy2hIuGdxCZjPcKutLPfbWqLn+O0VLeTBcvoKWO/TZ3+cGQ==
X-Received: by 2002:a05:600c:2e51:b0:40e:86eb:9e7e with SMTP id q17-20020a05600c2e5100b0040e86eb9e7emr2321508wmf.142.1705935688612;
        Mon, 22 Jan 2024 07:01:28 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c359500b0040e3488f16dsm39042113wmq.12.2024.01.22.07.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 07:01:28 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 07E225F9D3;
	Mon, 22 Jan 2024 14:56:13 +0000 (GMT)
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
Subject: [PATCH v3 19/21] contrib/plugins: extend execlog to track register changes
Date: Mon, 22 Jan 2024 14:56:08 +0000
Message-Id: <20240122145610.413836-20-alex.bennee@linaro.org>
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

Message-Id: <20240103173349.398526-41-alex.bennee@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Based-On: <20231025093128.33116-19-akihiko.odaki@daynix.com>

---
v3
  - just use a GArray for the CPU array
  - drop duplicate of cpu_index
---
 docs/devel/tcg-plugins.rst |  17 +-
 contrib/plugins/execlog.c  | 317 +++++++++++++++++++++++++++++++------
 2 files changed, 282 insertions(+), 52 deletions(-)

diff --git a/docs/devel/tcg-plugins.rst b/docs/devel/tcg-plugins.rst
index 81dcd43a612..fa7421279f5 100644
--- a/docs/devel/tcg-plugins.rst
+++ b/docs/devel/tcg-plugins.rst
@@ -497,6 +497,22 @@ arguments if required::
   $ qemu-system-arm $(QEMU_ARGS) \
     -plugin ./contrib/plugins/libexeclog.so,ifilter=st1w,afilter=0x40001808 -d plugin
 
+This plugin can also dump registers when they change value. Specify the name of the
+registers with multiple ``reg`` options. You can also use glob style matching if you wish::
+
+  $ qemu-system-arm $(QEMU_ARGS) \
+    -plugin ./contrib/plugins/libexeclog.so,reg=\*_el2,reg=sp -d plugin
+
+Be aware that each additional register to check will slow down
+execution quite considerably. You can optimise the number of register
+checks done by using the rdisas option. This will only instrument
+instructions that mention the registers in question in disassembly.
+This is not foolproof as some instructions implicitly change
+instructions. You can use the ifilter to catch these cases:
+
+  $ qemu-system-arm $(QEMU_ARGS) \
+    -plugin ./contrib/plugins/libexeclog.so,ifilter=msr,ifilter=blr,reg=x30,reg=\*_el1,rdisas=on
+
 - contrib/plugins/cache.c
 
 Cache modelling plugin that measures the performance of a given L1 cache
@@ -583,4 +599,3 @@ The following API is generated from the inline documentation in
 include the full kernel-doc annotations.
 
 .. kernel-doc:: include/qemu/qemu-plugin.h
-
diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
index f262e5555eb..c26664c0ab3 100644
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
@@ -15,29 +15,40 @@
 
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
+static GArray *cpus;
 static GRWLock expand_array_lock;
 
 static GPtrArray *imatches;
 static GArray *amatches;
+static GPtrArray *rmatches;
+static bool disas_assist;
+static GMutex add_reg_name_lock;
+static GPtrArray *all_reg_names;
 
-/*
- * Expand last_exec array.
- *
- * As we could have multiple threads trying to do this we need to
- * serialise the expansion under a lock.
- */
-static void expand_last_exec(int cpu_index)
+static CPU *get_cpu(int vcpu_index)
 {
-    g_rw_lock_writer_lock(&expand_array_lock);
-    while (cpu_index >= last_exec->len) {
-        GString *s = g_string_new(NULL);
-        g_ptr_array_add(last_exec, s);
-    }
-    g_rw_lock_writer_unlock(&expand_array_lock);
+    CPU *c;
+    g_rw_lock_reader_lock(&expand_array_lock);
+    c = &g_array_index(cpus, CPU, vcpu_index);
+    g_rw_lock_reader_unlock(&expand_array_lock);
+
+    return c;
 }
 
 /**
@@ -46,13 +57,10 @@ static void expand_last_exec(int cpu_index)
 static void vcpu_mem(unsigned int cpu_index, qemu_plugin_meminfo_t info,
                      uint64_t vaddr, void *udata)
 {
-    GString *s;
+    CPU *c = get_cpu(cpu_index);
+    GString *s = c->last_exec;
 
     /* Find vCPU in array */
-    g_rw_lock_reader_lock(&expand_array_lock);
-    g_assert(cpu_index < last_exec->len);
-    s = g_ptr_array_index(last_exec, cpu_index);
-    g_rw_lock_reader_unlock(&expand_array_lock);
 
     /* Indicate type of memory access */
     if (qemu_plugin_mem_is_store(info)) {
@@ -73,32 +81,91 @@ static void vcpu_mem(unsigned int cpu_index, qemu_plugin_meminfo_t info,
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
+static void insn_check_regs(int vcpu_index, CPU *cpu)
 {
-    GString *s;
+    for (int n = 0; n < cpu->registers->len; n++) {
+        Register *reg = cpu->registers->pdata[n];
+        int sz;
 
-    /* Find or create vCPU in array */
-    g_rw_lock_reader_lock(&expand_array_lock);
-    if (cpu_index >= last_exec->len) {
-        g_rw_lock_reader_unlock(&expand_array_lock);
-        expand_last_exec(cpu_index);
-        g_rw_lock_reader_lock(&expand_array_lock);
+        g_byte_array_set_size(reg->new, 0);
+        sz = qemu_plugin_read_register(vcpu_index, reg->handle, reg->new);
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
+    /* Print previous instruction in cache */
+    if (cpu->last_exec->len) {
+        if (cpu->registers) {
+            insn_check_regs(cpu_index, cpu);
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
+            insn_check_regs(cpu_index, cpu);
+        }
+
+        qemu_plugin_outs(cpu->last_exec->str);
+        qemu_plugin_outs("\n");
     }
-    s = g_ptr_array_index(last_exec, cpu_index);
-    g_rw_lock_reader_unlock(&expand_array_lock);
+
+    /* reset */
+    cpu->last_exec->len = 0;
+}
+
+/* Log last instruction without checking regs, setup next */
+static void vcpu_insn_exec(unsigned int cpu_index, void *udata)
+{
+    CPU *cpu = get_cpu(cpu_index);
 
     /* Print previous instruction in cache */
-    if (s->len) {
-        qemu_plugin_outs(s->str);
+    if (cpu->last_exec->len) {
+        qemu_plugin_outs(cpu->last_exec->str);
         qemu_plugin_outs("\n");
     }
 
     /* Store new instruction in cache */
     /* vcpu_mem will add memory access information to last_exec */
-    g_string_printf(s, "%u, ", cpu_index);
-    g_string_append(s, (char *)udata);
+    g_string_printf(cpu->last_exec, "%u, ", cpu_index);
+    g_string_append(cpu->last_exec, (char *)udata);
 }
 
 /**
@@ -111,6 +178,8 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
 {
     struct qemu_plugin_insn *insn;
     bool skip = (imatches || amatches);
+    bool check_regs_this = rmatches;
+    bool check_regs_next = false;
 
     size_t n = qemu_plugin_tb_n_insns(tb);
     for (size_t i = 0; i < n; i++) {
@@ -131,7 +200,8 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
         /*
          * If we are filtering we better check out if we have any
          * hits. The skip "latches" so we can track memory accesses
-         * after the instruction we care about.
+         * after the instruction we care about. Also enable register
+         * checking on the next instruction.
          */
         if (skip && imatches) {
             int j;
@@ -139,6 +209,7 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
                 char *m = g_ptr_array_index(imatches, j);
                 if (g_str_has_prefix(insn_disas, m)) {
                     skip = false;
+                    check_regs_next = rmatches;
                 }
             }
         }
@@ -153,8 +224,39 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
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
+         * - Log insn
+         * - Log insn while checking registers
+         * - Don't log this insn but check if last insn changed registers
+         */
+
         if (skip) {
-            g_free(insn_disas);
+            if (check_regs_this) {
+                qemu_plugin_register_vcpu_insn_exec_cb(insn,
+                                                       vcpu_insn_exec_only_regs,
+                                                       QEMU_PLUGIN_CB_R_REGS,
+                                                       NULL);
+            }
         } else {
             uint32_t insn_opcode;
             insn_opcode = *((uint32_t *)qemu_plugin_insn_data(insn));
@@ -167,30 +269,125 @@ static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
                                              QEMU_PLUGIN_MEM_RW, NULL);
 
             /* Register callback on instruction */
-            qemu_plugin_register_vcpu_insn_exec_cb(insn, vcpu_insn_exec,
-                                                   QEMU_PLUGIN_CB_NO_REGS, output);
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
 
+static Register *init_vcpu_register(int vcpu_index,
+                                    qemu_plugin_reg_descriptor *desc)
+{
+    Register *reg = g_new0(Register, 1);
+    g_autofree gchar *lower = g_utf8_strdown(desc->name, -1);
+    int r;
+
+    reg->handle = desc->handle;
+    reg->name = g_intern_string(lower);
+    reg->last = g_byte_array_new();
+    reg->new = g_byte_array_new();
+
+    /* read the initial value */
+    r = qemu_plugin_read_register(vcpu_index, reg->handle, reg->last);
+    g_assert(r > 0);
+    return reg;
+}
+
+static GPtrArray *registers_init(int vcpu_index)
+{
+    g_autoptr(GPtrArray) registers = g_ptr_array_new();
+    g_autoptr(GArray) reg_list = qemu_plugin_get_registers(vcpu_index);
+
+    if (rmatches && reg_list && reg_list->len) {
+        /*
+         * Go through each register in the complete list and
+         * see if we want to track it.
+         */
+        for (int r = 0; r < reg_list->len; r++) {
+            qemu_plugin_reg_descriptor *rd = &g_array_index(
+                reg_list, qemu_plugin_reg_descriptor, r);
+            for (int p = 0; p < rmatches->len; p++) {
+                g_autoptr(GPatternSpec) pat = g_pattern_spec_new(rmatches->pdata[p]);
+                g_autofree gchar *rd_lower = g_utf8_strdown(rd->name, -1);
+                if (g_pattern_match_string(pat, rd->name) ||
+                    g_pattern_match_string(pat, rd_lower)) {
+                    Register *reg = init_vcpu_register(vcpu_index, rd);
+                    g_ptr_array_add(registers, reg);
+
+                    /* we need a list of regnames at TB translation time */
+                    if (disas_assist) {
+                        g_mutex_lock(&add_reg_name_lock);
+                        if (!g_ptr_array_find(all_reg_names, reg->name, NULL)) {
+                            g_ptr_array_add(all_reg_names, reg->name);
+                        }
+                        g_mutex_unlock(&add_reg_name_lock);
+                    }
+                }
+            }
+        }
+    }
+
+    return registers->len ? g_steal_pointer(&registers) : NULL;
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
+    CPU *c;
+
+    g_rw_lock_writer_lock(&expand_array_lock);
+    if (vcpu_index >= cpus->len) {
+        g_array_set_size(cpus, vcpu_index + 1);
+    }
+    g_rw_lock_writer_unlock(&expand_array_lock);
+
+    c = get_cpu(vcpu_index);
+    c->last_exec = g_string_new(NULL);
+    c->registers = registers_init(vcpu_index);
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
+    g_rw_lock_reader_lock(&expand_array_lock);
+    for (i = 0; i < cpus->len; i++) {
+        CPU *c = get_cpu(i);
+        if (c->last_exec && c->last_exec->str) {
+            qemu_plugin_outs(c->last_exec->str);
             qemu_plugin_outs("\n");
         }
     }
+    g_rw_lock_reader_unlock(&expand_array_lock);
 }
 
 /* Add a match to the array of matches */
@@ -212,6 +409,18 @@ static void parse_vaddr_match(char *match)
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
@@ -223,11 +432,8 @@ QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
      * Initialize dynamic array to cache vCPU instruction. In user mode
      * we don't know the size before emulation.
      */
-    if (info->system_emulation) {
-        last_exec = g_ptr_array_sized_new(info->system.max_vcpus);
-    } else {
-        last_exec = g_ptr_array_new();
-    }
+    cpus = g_array_sized_new(true, true, sizeof(CPU),
+                             info->system_emulation ? info->system.max_vcpus : 1);
 
     for (int i = 0; i < argc; i++) {
         char *opt = argv[i];
@@ -236,13 +442,22 @@ QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
             parse_insn_match(tokens[1]);
         } else if (g_strcmp0(tokens[0], "afilter") == 0) {
             parse_vaddr_match(tokens[1]);
+        } else if (g_strcmp0(tokens[0], "reg") == 0) {
+            add_regpat(tokens[1]);
+        } else if (g_strcmp0(tokens[0], "rdisas") == 0) {
+            if (!qemu_plugin_bool_parse(tokens[0], tokens[1], &disas_assist)) {
+                fprintf(stderr, "boolean argument parsing failed: %s\n", opt);
+                return -1;
+            }
+            all_reg_names = g_ptr_array_new();
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


