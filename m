Return-Path: <kvm+bounces-6560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FCF8366A1
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:05:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 310902879C8
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C4048795;
	Mon, 22 Jan 2024 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O+pGQx7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE28A47A6A
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935387; cv=none; b=drWxghq5re5p3bTfCAyTl0g8JeseRASOYyw7ssq0ciZ7vIDry+FWa79tTXBi6cI79paEKDolA+QLfr8xTzO5karTI13hLQHvRs0hf1krwlOkghJ9rANfkhcad04beeqd7NnngOM/ThEX8H+EZiwqzd80ZoXTKK+x3jpCd92WVTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935387; c=relaxed/simple;
	bh=tR0nakBW8JzFWIcSrJdjrciKJn6HWW8j93ZV/QQMXNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/pLByxaNPGCgkoDMWHA5eoDqizxMnrhWMslpiC5ATQDIETrNQgBQnt7vm7jqS+VgSvSQtYJtDNHXaTgrDEimUIAfiYRNrTJAq7Ij6AtuGjpSx+U+58TeXvxQx57Hk5Q1BNrY6dCwNUp/4RsSc78w+WeP5xU1nU6ZZ7oPkozqqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O+pGQx7R; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40e86a9fbd9so36072355e9.1
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935384; x=1706540184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2fjpQGWIVdaUhrKBxzpHv8KWPTJS+XO5n/dS9EIjS4=;
        b=O+pGQx7R539YroEvVYCTA3fbnMpTQ2AWPoZZDKEpzhNtTRaACmOWsGG6GEXNfA+0Um
         iCCG4zjjq0b9HSDP+hUMw2V6OCQodkasY8jRSpP9fKfSGhncZsMTXw3LEj5DxoJhDMXD
         fQcZgNJYgjfiomWD+7LRtl2gPFU+58PBjQT/wWNahB52yut2ySqNxLQ60zDEqioDmjP4
         m5XZs1XEOLYubwsfub+AMmMheEVO3LedV1kftRUgT6732ocaynAs2X6bwdoH+HmjtD7s
         b8g5m2UNX3t1btGnE79bSrX4phQyYhNL1weik/ZEFL4xBV6P5DU2Ntcaw5pP47oJs9jZ
         K/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935384; x=1706540184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W2fjpQGWIVdaUhrKBxzpHv8KWPTJS+XO5n/dS9EIjS4=;
        b=vAXvg6vV5OtGi5uPAX2S3sRjgZlZ4DGlxzxrYkcKxruVM2w2IzphDJaZEs0ZOEbz7y
         DLhKw4AzGH0K4e6HG3+W8alKcf7HGd2MnY4IdiCXOy5Jyqn5xaU/x3oaoR3x/oisMZM2
         QgQ6ToEM17CWzB4+Th+n/xG1Uuad9PnWX1OGH6X44W2MpdXRTxyfvywAjKTlB5/OhnfM
         7W86s2nMZb7tC+WyzKTVRHCdYE0SZYHLR5PCDO04dpq2tO5guueYu+G0nnD+7+ZTQUJp
         LbKx9mjSDk464VaZdxFVWjIgEje9dzUOGhWN23wKvzTWyMtmWpZw2G1SXyx6/PaTTUks
         SeAA==
X-Gm-Message-State: AOJu0YwBc4D0FfSZMmU312JHrdp4P4Qv4giNBsDWtXGq12FK5cEKmYL5
	alsv7is3clBox67bPAE3dgDG///e1jn+ppqNdv+1p/eOWzYp+5kws2oQCkh+Jh8=
X-Google-Smtp-Source: AGHT+IEScfjWXUyT+16NGhk84eBOICncw64aNoX0grPWv47lGKOLuB6g+dkWFaG3Q/r849LZP0XdZg==
X-Received: by 2002:a05:600c:54cc:b0:40d:87b7:24c7 with SMTP id iw12-20020a05600c54cc00b0040d87b724c7mr2387732wmb.125.1705935384148;
        Mon, 22 Jan 2024 06:56:24 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id i19-20020a05600c355300b0040e76b60235sm28316321wmq.8.2024.01.22.06.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:21 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 971625F933;
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
Subject: [PATCH v3 15/21] plugins: Use different helpers when reading registers
Date: Mon, 22 Jan 2024 14:56:04 +0000
Message-Id: <20240122145610.413836-16-alex.bennee@linaro.org>
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

This avoids optimizations incompatible when reading registers.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240103173349.398526-37-alex.bennee@linaro.org>
Message-Id: <20231213-gdb-v17-12-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


