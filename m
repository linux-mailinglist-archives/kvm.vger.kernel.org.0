Return-Path: <kvm+bounces-5039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C67581B3DB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBCD0B25075
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145F174E2F;
	Thu, 21 Dec 2023 10:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HIcTtugj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C889745CC
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40c29f7b068so6494745e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155116; x=1703759916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQ/wZukjb9MkID54+svIg/xF+LuLzsv4JVtqMj5aDqg=;
        b=HIcTtugjLtbZSqhPVhZN0j0VlmtEFrRtwyrj6FVaJ9Ht1Zgfah/Z4tCBMA6zrdxHWY
         CIlbBIFdYPeeTRAM8PCxPZtN2EgEgVaB0uXrAEolMx1GiBpeinfzRcMFdCY5MxNfca+i
         zfsli3PhKDwxIN1+pqdtKml2/8BBMqH2Inyj0RyKIIvWXaoeCsxUsuVVtMJkd8W306gv
         SFJHjUyUG/uALlqpRbYhATKtq3mhJ45Q1w4bn1GoMN5tRWoboX7ILPVqFRH6xz4Sbg7q
         o2ZYEVjpSWU/rt7nvARnzVZ9iBb4/lZYwGUFRSxS6zdOwzdYphL7igC7DEpI2Mxm07JJ
         TO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155116; x=1703759916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQ/wZukjb9MkID54+svIg/xF+LuLzsv4JVtqMj5aDqg=;
        b=cMIddABXlTZdHtWrtmrrvbR7HWNgDPxB/T4H1f37PPMGGKLkq1thDn29mKWNDsu2hN
         CcceU2b8flo4DOAxydQX0kJ2E3+01lGrdH6yTxPvYb2jsmF1wLul14xCRV4ba4SnmPSV
         OUFD+WIHzsetv6Qbs98IONVicEqE7bUb4YZQq76/FNJnrMFvSV6pglZP+mzsI/B00Rrt
         yKNK+wHbuteGgV+GT0PiuWU66mUVTWDopVQbFrt1RcdhDWFGSx2aHMm3+mQj9wxgjH9u
         6ZsDM/L5VEsOD9g6JumsCpwH67DI4miK34pkpIQecMPZ9jRF2rMbMj/eHw5ZtipR1sv1
         WUrg==
X-Gm-Message-State: AOJu0YxcT+k8JtOlTNryNH3qU/wrV8/UHNacnpCxUuT4PQRP4o96e4HS
	sxceuiwH6AN0Rl1hNbNWmqcNdg==
X-Google-Smtp-Source: AGHT+IGGs3q4Sn+pFrt96v41emu4VX1Cjlc8q5TEXui3ohNwGdr986MkBva+WZWaDOwZaApxoljyhQ==
X-Received: by 2002:a05:600c:6c7:b0:40c:3e6e:5466 with SMTP id b7-20020a05600c06c700b0040c3e6e5466mr540732wmn.182.1703155116576;
        Thu, 21 Dec 2023 02:38:36 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d4c86000000b003365fb3247csm1730355wrs.32.2023.12.21.02.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:34 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C06835F90B;
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
Subject: [PATCH 37/40] plugins: add an API to read registers
Date: Thu, 21 Dec 2023 10:38:15 +0000
Message-Id: <20231221103818.1633766-38-alex.bennee@linaro.org>
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

We can only request a list of registers once the vCPU has been
initialised so the user needs to use either call the get function on
vCPU initialisation or during the translation phase.

We don't expose the reg number to the plugin instead hiding it behind
an opaque handle. This allows for a bit of future proofing should the
internals need to be changed while also being hashed against the
CPUClass so we can handle different register sets per-vCPU in
hetrogenous situations.

Having an internal state within the plugins also allows us to expand
the interface in future (for example providing callbacks on register
change if the translator can track changes).

Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1706
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Based-on: <20231025093128.33116-18-akihiko.odaki@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - use new get whole list api, and expose upwards

vAJB:

The main difference to Akikio's version is hiding the gdb register
detail from the plugin for the reasons described above.
---
 include/qemu/qemu-plugin.h   |  53 +++++++++++++++++-
 plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
 plugins/qemu-plugins.symbols |   2 +
 3 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
index 4daab6efd29..e3b35c6ee81 100644
--- a/include/qemu/qemu-plugin.h
+++ b/include/qemu/qemu-plugin.h
@@ -11,6 +11,7 @@
 #ifndef QEMU_QEMU_PLUGIN_H
 #define QEMU_QEMU_PLUGIN_H
 
+#include <glib.h>
 #include <inttypes.h>
 #include <stdbool.h>
 #include <stddef.h>
@@ -227,8 +228,8 @@ struct qemu_plugin_insn;
  * @QEMU_PLUGIN_CB_R_REGS: callback reads the CPU's regs
  * @QEMU_PLUGIN_CB_RW_REGS: callback reads and writes the CPU's regs
  *
- * Note: currently unused, plugins cannot read or change system
- * register state.
+ * Note: currently QEMU_PLUGIN_CB_RW_REGS is unused, plugins cannot change
+ * system register state.
  */
 enum qemu_plugin_cb_flags {
     QEMU_PLUGIN_CB_NO_REGS,
@@ -708,4 +709,52 @@ uint64_t qemu_plugin_end_code(void);
 QEMU_PLUGIN_API
 uint64_t qemu_plugin_entry_code(void);
 
+/** struct qemu_plugin_register - Opaque handle for a translated instruction */
+struct qemu_plugin_register;
+
+/**
+ * typedef qemu_plugin_reg_descriptor - register descriptions
+ *
+ * @name: register name
+ * @handle: opaque handle for retrieving value with qemu_plugin_read_register
+ * @feature: optional feature descriptor, can be NULL
+ */
+typedef struct {
+    char name[32];
+    struct qemu_plugin_register *handle;
+    const char *feature;
+} qemu_plugin_reg_descriptor;
+
+/**
+ * qemu_plugin_get_registers() - return register list for vCPU
+ * @vcpu_index: vcpu to query
+ *
+ * Returns a GArray of qemu_plugin_reg_descriptor or NULL. Caller
+ * frees the array (but not the const strings).
+ *
+ * As the register set of a given vCPU is only available once
+ * the vCPU is initialised if you want to monitor registers from the
+ * start you should call this from a qemu_plugin_register_vcpu_init_cb()
+ * callback.
+ */
+GArray * qemu_plugin_get_registers(unsigned int vcpu_index);
+
+/**
+ * qemu_plugin_read_register() - read register
+ *
+ * @vcpu: vcpu index
+ * @handle: a @qemu_plugin_reg_handle handle
+ * @buf: A GByteArray for the data owned by the plugin
+ *
+ * This function is only available in a context that register read access is
+ * explicitly requested.
+ *
+ * Returns the size of the read register. The content of @buf is in target byte
+ * order. On failure returns -1
+ */
+int qemu_plugin_read_register(unsigned int vcpu,
+                              struct qemu_plugin_register *handle,
+                              GByteArray *buf);
+
+
 #endif /* QEMU_QEMU_PLUGIN_H */
diff --git a/plugins/api.c b/plugins/api.c
index ac39cdea0b3..fc1f26e3440 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -8,6 +8,7 @@
  *
  *  qemu_plugin_tb
  *  qemu_plugin_insn
+ *  qemu_plugin_register
  *
  * Which can then be passed back into the API to do additional things.
  * As such all the public functions in here are exported in
@@ -35,10 +36,12 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/main-loop.h"
 #include "qemu/plugin.h"
 #include "qemu/log.h"
 #include "tcg/tcg.h"
 #include "exec/exec-all.h"
+#include "exec/gdbstub.h"
 #include "exec/ram_addr.h"
 #include "disas/disas.h"
 #include "plugin.h"
@@ -435,3 +438,102 @@ uint64_t qemu_plugin_entry_code(void)
 #endif
     return entry;
 }
+
+/*
+ * Register handles
+ *
+ * The plugin infrastructure keeps hold of these internal data
+ * structures which are presented to plugins as opaque handles. They
+ * are global to the system and therefor additions to the hash table
+ * must be protected by the @reg_handle_lock.
+ *
+ * In order to future proof for up-coming heterogeneous work we want
+ * different entries for each CPU type while sharing them in the
+ * common case of multiple cores of the same type.
+ */
+
+static QemuMutex reg_handle_lock;
+
+struct qemu_plugin_register {
+    const char *name;
+    int gdb_reg_num;
+};
+
+static GHashTable *reg_handles; /* hash table of PluginReg */
+
+/* Generate a stable key - would xxhash be overkill? */
+static gpointer cpu_plus_reg_to_key(CPUState *cs, int gdb_regnum)
+{
+    uintptr_t key = (uintptr_t) cs->cc;
+    key ^= gdb_regnum;
+    return GUINT_TO_POINTER(key);
+}
+
+/*
+ * Create register handles.
+ *
+ * We need to create a handle for each register so the plugin
+ * infrastructure can call gdbstub to read a register. We also
+ * construct a result array with those handles and some ancillary data
+ * the plugin might find useful.
+ */
+
+static GArray * create_register_handles(CPUState *cs, GArray *gdbstub_regs) {
+    GArray *find_data = g_array_new(true, true, sizeof(qemu_plugin_reg_descriptor));
+
+    WITH_QEMU_LOCK_GUARD(&reg_handle_lock) {
+
+        if (!reg_handles) {
+            reg_handles = g_hash_table_new(g_direct_hash, g_direct_equal);
+        }
+
+        for (int i=0; i < gdbstub_regs->len; i++) {
+            GDBRegDesc *grd = &g_array_index(gdbstub_regs, GDBRegDesc, i);
+            gpointer key = cpu_plus_reg_to_key(cs, grd->gdb_reg);
+            struct qemu_plugin_register *val = g_hash_table_lookup(reg_handles, key);
+
+            /* Doesn't exist, create one */
+            if (!val) {
+                val = g_new0(struct qemu_plugin_register, 1);
+                val->gdb_reg_num = grd->gdb_reg;
+                val->name = grd->name;
+
+                g_hash_table_insert(reg_handles, key, val);
+            }
+
+            /* Create a record for the plugin */
+            qemu_plugin_reg_descriptor desc = {
+                .handle = val,
+                .feature = g_intern_string(grd->feature_name)
+            };
+            g_strlcpy(desc.name, val->name, sizeof(desc.name));
+            g_array_append_val(find_data, desc);
+        }
+    }
+
+    return find_data;
+}
+
+GArray * qemu_plugin_get_registers(unsigned int vcpu)
+{
+    CPUState *cs = qemu_get_cpu(vcpu);
+    if (cs) {
+        g_autoptr(GArray) regs = gdb_get_register_list(cs);
+        return regs->len ? create_register_handles(cs, regs) : NULL;
+    } else {
+        return NULL;
+    }
+}
+
+int qemu_plugin_read_register(unsigned int vcpu, struct qemu_plugin_register *reg, GByteArray *buf)
+{
+    CPUState *cs = qemu_get_cpu(vcpu);
+    /* assert with debugging on? */
+    return gdb_read_register(cs, buf, reg->gdb_reg_num);
+}
+
+static void __attribute__((__constructor__)) qemu_api_init(void)
+{
+    qemu_mutex_init(&reg_handle_lock);
+
+}
diff --git a/plugins/qemu-plugins.symbols b/plugins/qemu-plugins.symbols
index 71f6c90549d..6963585c1ea 100644
--- a/plugins/qemu-plugins.symbols
+++ b/plugins/qemu-plugins.symbols
@@ -3,6 +3,7 @@
   qemu_plugin_end_code;
   qemu_plugin_entry_code;
   qemu_plugin_get_hwaddr;
+  qemu_plugin_get_registers;
   qemu_plugin_hwaddr_device_name;
   qemu_plugin_hwaddr_is_io;
   qemu_plugin_hwaddr_phys_addr;
@@ -20,6 +21,7 @@
   qemu_plugin_n_vcpus;
   qemu_plugin_outs;
   qemu_plugin_path_to_binary;
+  qemu_plugin_read_register;
   qemu_plugin_register_atexit_cb;
   qemu_plugin_register_flush_cb;
   qemu_plugin_register_vcpu_exit_cb;
-- 
2.39.2


