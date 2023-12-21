Return-Path: <kvm+bounces-5045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5D581B42E
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1562D282FA4
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BFA6BB42;
	Thu, 21 Dec 2023 10:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aGiobvUE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B176AB88
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40c31f18274so7816625e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155619; x=1703760419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeLMVf2eHHsXh0O15q4pkBIw3KoK3wQ6PmZ1CrbEex8=;
        b=aGiobvUEspK+q7k2UwaOZ58retztGB/+2HIkb7NHuTLDeDRauNfcnTEG127etYzoPn
         Pr5MIyV/hm5qAwS2sSR1UgoZv9/EUjspfaYEBvXzGj+e+Y01EbJh/iEl6Q99RroSuKtj
         V2uRX6R/sTTnTQY4X1HCtXhkrVDvg7y4cy7oVI1pJADAxI00k8guk52n01SVmo3no42I
         oNRUaA9jubZYtrdR8I0kSrytvxVcsno9QxWRU1MnPadJTMgEjRS/tGHsy4GQDrWv9t1t
         NRhS7kBQguZuESzOhD7uBiKRnom4gjeTud/8CKpGcRr3OD+JpWymBhBSR7tSrM0hyFih
         38Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155619; x=1703760419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yeLMVf2eHHsXh0O15q4pkBIw3KoK3wQ6PmZ1CrbEex8=;
        b=liA3YyN9NBLoeaUcnxkVjdb9VqzqK2yI8U1Mejo8Pv6T43qqp01EFSiC/7PJFQeYQm
         WAmspmQHufGT24lBWd/38r54GB/teJZta2r0yMCypTdFCeIsuahulIU4W5Lb5YdTNw5x
         gaKKx2mKcLFFuWl3nGMQfQtaAxI0IfgNdVtg2SC++7Jl/MNMRJQJ9mhhdLs3uXUSPui7
         arBrkqK+xmrgkBpeprzhAOYN5TbKCrGOEhq2ig8JewL9B57UizHfv5IL8fOn2y1SkKWG
         5Wk3tYUd91VKu0BH2JJQe9JAXaPXKq3h4xnvZ5BQVltaabm3Iu+Mr029nQPMaa3LPoXx
         tHLQ==
X-Gm-Message-State: AOJu0YxYzNi6VZV2WuLV1s4Cq824u/Y1JtsBDTb4afDzwxLVp0jyy3qR
	26/9HV0CLkKP1DQgYYLgiNwQWw==
X-Google-Smtp-Source: AGHT+IEVU+rXY4D7YK709EJV0myfRmjEYWXRKslL1le8Ej+hwkCYYeVodLZcvo82uBVDTZ+8F1HpRw==
X-Received: by 2002:a05:600c:4f0f:b0:40d:1435:5242 with SMTP id l15-20020a05600c4f0f00b0040d14355242mr625105wmq.112.1703155619382;
        Thu, 21 Dec 2023 02:46:59 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id iw11-20020a05600c54cb00b0040b3515cdf8sm2784929wmb.7.2023.12.21.02.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:46:58 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8F9E75F904;
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
Subject: [PATCH 35/40] plugins: Use different helpers when reading registers
Date: Thu, 21 Dec 2023 10:38:13 +0000
Message-Id: <20231221103818.1633766-36-alex.bennee@linaro.org>
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

This avoids optimizations incompatible when reading registers.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Message-Id: <20231213-gdb-v17-12-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 accel/tcg/plugin-helpers.h |  3 ++-
 include/qemu/plugin.h      |  1 +
 accel/tcg/plugin-gen.c     | 43 ++++++++++++++++++++++++++++++++++----
 plugins/api.c              | 12 +++++++++--
 4 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/accel/tcg/plugin-helpers.h b/accel/tcg/plugin-helpers.h
index 8e685e06545..11796436f35 100644
--- a/accel/tcg/plugin-helpers.h
+++ b/accel/tcg/plugin-helpers.h
@@ -1,4 +1,5 @@
 #ifdef CONFIG_PLUGIN
-DEF_HELPER_FLAGS_2(plugin_vcpu_udata_cb, TCG_CALL_NO_RWG | TCG_CALL_PLUGIN, void, i32, ptr)
+DEF_HELPER_FLAGS_2(plugin_vcpu_udata_cb_no_wg, TCG_CALL_NO_WG | TCG_CALL_PLUGIN, void, i32, ptr)
+DEF_HELPER_FLAGS_2(plugin_vcpu_udata_cb_no_rwg, TCG_CALL_NO_RWG | TCG_CALL_PLUGIN, void, i32, ptr)
 DEF_HELPER_FLAGS_4(plugin_vcpu_mem_cb, TCG_CALL_NO_RWG | TCG_CALL_PLUGIN, void, i32, i32, i64, ptr)
 #endif
diff --git a/include/qemu/plugin.h b/include/qemu/plugin.h
index 7fdc3a4849f..b0c5ac68293 100644
--- a/include/qemu/plugin.h
+++ b/include/qemu/plugin.h
@@ -73,6 +73,7 @@ enum plugin_dyn_cb_type {
 
 enum plugin_dyn_cb_subtype {
     PLUGIN_CB_REGULAR,
+    PLUGIN_CB_REGULAR_R,
     PLUGIN_CB_INLINE,
     PLUGIN_N_CB_SUBTYPES,
 };
diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index 78b331b2510..b37ce7683e6 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -79,6 +79,7 @@ enum plugin_gen_from {
 
 enum plugin_gen_cb {
     PLUGIN_GEN_CB_UDATA,
+    PLUGIN_GEN_CB_UDATA_R,
     PLUGIN_GEN_CB_INLINE,
     PLUGIN_GEN_CB_MEM,
     PLUGIN_GEN_ENABLE_MEM_HELPER,
@@ -90,7 +91,10 @@ enum plugin_gen_cb {
  * These helpers are stubs that get dynamically switched out for calls
  * direct to the plugin if they are subscribed to.
  */
-void HELPER(plugin_vcpu_udata_cb)(uint32_t cpu_index, void *udata)
+void HELPER(plugin_vcpu_udata_cb_no_wg)(uint32_t cpu_index, void *udata)
+{ }
+
+void HELPER(plugin_vcpu_udata_cb_no_rwg)(uint32_t cpu_index, void *udata)
 { }
 
 void HELPER(plugin_vcpu_mem_cb)(unsigned int vcpu_index,
@@ -98,7 +102,7 @@ void HELPER(plugin_vcpu_mem_cb)(unsigned int vcpu_index,
                                 void *userdata)
 { }
 
-static void gen_empty_udata_cb(void)
+static void gen_empty_udata_cb(void (*gen_helper)(TCGv_i32, TCGv_ptr))
 {
     TCGv_i32 cpu_index = tcg_temp_ebb_new_i32();
     TCGv_ptr udata = tcg_temp_ebb_new_ptr();
@@ -106,12 +110,22 @@ static void gen_empty_udata_cb(void)
     tcg_gen_movi_ptr(udata, 0);
     tcg_gen_ld_i32(cpu_index, tcg_env,
                    -offsetof(ArchCPU, env) + offsetof(CPUState, cpu_index));
-    gen_helper_plugin_vcpu_udata_cb(cpu_index, udata);
+    gen_helper(cpu_index, udata);
 
     tcg_temp_free_ptr(udata);
     tcg_temp_free_i32(cpu_index);
 }
 
+static void gen_empty_udata_cb_no_wg(void)
+{
+    gen_empty_udata_cb(gen_helper_plugin_vcpu_udata_cb_no_wg);
+}
+
+static void gen_empty_udata_cb_no_rwg(void)
+{
+    gen_empty_udata_cb(gen_helper_plugin_vcpu_udata_cb_no_rwg);
+}
+
 /*
  * For now we only support addi_i64.
  * When we support more ops, we can generate one empty inline cb for each.
@@ -192,7 +206,8 @@ static void plugin_gen_empty_callback(enum plugin_gen_from from)
                     gen_empty_mem_helper);
         /* fall through */
     case PLUGIN_GEN_FROM_TB:
-        gen_wrapped(from, PLUGIN_GEN_CB_UDATA, gen_empty_udata_cb);
+        gen_wrapped(from, PLUGIN_GEN_CB_UDATA, gen_empty_udata_cb_no_rwg);
+        gen_wrapped(from, PLUGIN_GEN_CB_UDATA_R, gen_empty_udata_cb_no_wg);
         gen_wrapped(from, PLUGIN_GEN_CB_INLINE, gen_empty_inline_cb);
         break;
     default:
@@ -588,6 +603,12 @@ static void plugin_gen_tb_udata(const struct qemu_plugin_tb *ptb,
     inject_udata_cb(ptb->cbs[PLUGIN_CB_REGULAR], begin_op);
 }
 
+static void plugin_gen_tb_udata_r(const struct qemu_plugin_tb *ptb,
+                                  TCGOp *begin_op)
+{
+    inject_udata_cb(ptb->cbs[PLUGIN_CB_REGULAR_R], begin_op);
+}
+
 static void plugin_gen_tb_inline(const struct qemu_plugin_tb *ptb,
                                  TCGOp *begin_op)
 {
@@ -602,6 +623,14 @@ static void plugin_gen_insn_udata(const struct qemu_plugin_tb *ptb,
     inject_udata_cb(insn->cbs[PLUGIN_CB_INSN][PLUGIN_CB_REGULAR], begin_op);
 }
 
+static void plugin_gen_insn_udata_r(const struct qemu_plugin_tb *ptb,
+                                    TCGOp *begin_op, int insn_idx)
+{
+    struct qemu_plugin_insn *insn = g_ptr_array_index(ptb->insns, insn_idx);
+
+    inject_udata_cb(insn->cbs[PLUGIN_CB_INSN][PLUGIN_CB_REGULAR_R], begin_op);
+}
+
 static void plugin_gen_insn_inline(const struct qemu_plugin_tb *ptb,
                                    TCGOp *begin_op, int insn_idx)
 {
@@ -721,6 +750,9 @@ static void plugin_gen_inject(struct qemu_plugin_tb *plugin_tb)
                 case PLUGIN_GEN_CB_UDATA:
                     plugin_gen_tb_udata(plugin_tb, op);
                     break;
+                case PLUGIN_GEN_CB_UDATA_R:
+                    plugin_gen_tb_udata_r(plugin_tb, op);
+                    break;
                 case PLUGIN_GEN_CB_INLINE:
                     plugin_gen_tb_inline(plugin_tb, op);
                     break;
@@ -737,6 +769,9 @@ static void plugin_gen_inject(struct qemu_plugin_tb *plugin_tb)
                 case PLUGIN_GEN_CB_UDATA:
                     plugin_gen_insn_udata(plugin_tb, op, insn_idx);
                     break;
+                case PLUGIN_GEN_CB_UDATA_R:
+                    plugin_gen_insn_udata_r(plugin_tb, op, insn_idx);
+                    break;
                 case PLUGIN_GEN_CB_INLINE:
                     plugin_gen_insn_inline(plugin_tb, op, insn_idx);
                     break;
diff --git a/plugins/api.c b/plugins/api.c
index 5521b0ad36c..ac39cdea0b3 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -89,7 +89,11 @@ void qemu_plugin_register_vcpu_tb_exec_cb(struct qemu_plugin_tb *tb,
                                           void *udata)
 {
     if (!tb->mem_only) {
-        plugin_register_dyn_cb__udata(&tb->cbs[PLUGIN_CB_REGULAR],
+        int index = flags == QEMU_PLUGIN_CB_R_REGS ||
+                    flags == QEMU_PLUGIN_CB_RW_REGS ?
+                    PLUGIN_CB_REGULAR_R : PLUGIN_CB_REGULAR;
+
+        plugin_register_dyn_cb__udata(&tb->cbs[index],
                                       cb, flags, udata);
     }
 }
@@ -109,7 +113,11 @@ void qemu_plugin_register_vcpu_insn_exec_cb(struct qemu_plugin_insn *insn,
                                             void *udata)
 {
     if (!insn->mem_only) {
-        plugin_register_dyn_cb__udata(&insn->cbs[PLUGIN_CB_INSN][PLUGIN_CB_REGULAR],
+        int index = flags == QEMU_PLUGIN_CB_R_REGS ||
+                    flags == QEMU_PLUGIN_CB_RW_REGS ?
+                    PLUGIN_CB_REGULAR_R : PLUGIN_CB_REGULAR;
+
+        plugin_register_dyn_cb__udata(&insn->cbs[PLUGIN_CB_INSN][index],
                                       cb, flags, udata);
     }
 }
-- 
2.39.2


