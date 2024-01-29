Return-Path: <kvm+bounces-7367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA042840C21
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A2BBB26A3E
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1719157036;
	Mon, 29 Jan 2024 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KLNZEk+T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192BD156993
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546852; cv=none; b=VfqTSETdZdDOzpiFeKleNCc2jy1Kymo38ej45JCy1HP5NH6Mdj3T7p8c3X9Y/hAAbg9K51+daH4KaF/hHlZB0x3CculOLAiHKXWzGQiJs3bAOfP/8+lMIKJGZ125PmkhNsaoEcj8FkgWDgr+lV3vTMOhvr50QlFP6T++EuiGxeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546852; c=relaxed/simple;
	bh=bAaEo7UXq+25gnYLyv+CDL6A9umnb37zDC3CbSlvXHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/qC3GwaJib4rQPb9qXawoDBGRN5+ifYJ1QUZsscl1xVTvJ87mSM6xTACHDLf4g5sGiubpMF2Oo2oX2D1h9ucajB3RqhJTG9DiGeoW6piZJCpHAUzVVGSOyXIyeLtIYHua+1Wsvxdh0auopjUXYNwi98T9uNuxS5sAqTqlIcFmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KLNZEk+T; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40efcd830f6so1469285e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546848; x=1707151648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTmQyRcnNqgQwJoS6XsHQE+cWrjtXUUhl4cs1cvfE94=;
        b=KLNZEk+TIQ38BJjgOTDnDosp7mPivCyC10nmJHL1L97c//W5/0T/fFFdDE761wU+bK
         ANR6il2AFN/YzYVED1PGZbfv7tZeS8YiJIJ+KAwnoOLLXLYF/wkAlpdI7cQ6yXBwrzfo
         M5ri0c5251amVzlfCiTMshFAlF068sjun44kbqc+glI6og/8E7Hz9Y/Uwd2s2GbbOxRn
         bBrCPTMbttLiqAK+lEBAvjA/FnHpUdssD/t5IBs2kLk2++r5gg0cQgXJHjq1nBzaYs5q
         pFTarbjgk9TerjUO7vGTsMeF5RrEySIOPmmGYw8uUx8Cmhrqmf+8HGr2X7CaOTqltrs7
         Jf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546848; x=1707151648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DTmQyRcnNqgQwJoS6XsHQE+cWrjtXUUhl4cs1cvfE94=;
        b=DwWFsmXwjx/+TJKW6r867NFkY/ySZhqeyfrEzMjKL8n9m8cV5EyApkQhbIC00Bql7A
         jPbJ2Nmr5oqKw1AWbEtbumeDMyAuGQ/rbij1oZfjFhh7lpe81RMAGqNXZMNyJ5Rf6UuH
         21+tMtvc9+/lNa65KGdmEs5gf6d+dco+vpRZ+BVRmQ/KPA5WSaFqEqkcCvS9PpAcUrhz
         6J9xMDYrOW5vrXgE0J8THgF/glXuFLhlupiWvj/TLS0+ScxJo4Y96eTY7gJTTR1pdVjN
         YW0D0XTUHjkcwepH9IjHCztK9aOjto+ttG9DJODbd5x0NN46o0REw/hQCNOIT+OKC8C9
         a3Yg==
X-Gm-Message-State: AOJu0YyfUrragYCKGd8dyPiU3a4HJlPxRbMy9YLTL+C7OnV7etSksAUH
	EHoAcJhrfBCbNCsEZwHoU9yESalfgYi+dQUEBxPK15nuYVGwwdVodiSbQ5RCrFM=
X-Google-Smtp-Source: AGHT+IHRjk0Ni+ZTdCCitsdAD/Rw7PNydGz3Lc9DD15Omv+6GlenJU/4b1yCorKx64kreoceRIK6Ww==
X-Received: by 2002:a05:600c:19cf:b0:40e:85fe:af82 with SMTP id u15-20020a05600c19cf00b0040e85feaf82mr5997213wmq.24.1706546848265;
        Mon, 29 Jan 2024 08:47:28 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id bd25-20020a05600c1f1900b0040ee0abd8f1sm9962562wmb.21.2024.01.29.08.47.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:47:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>
Subject: [PATCH v3 21/29] target/ppc: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:45:03 +0100
Message-ID: <20240129164514.73104-22-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240129164514.73104-1-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/mpc8544_guts.c         |  3 +--
 hw/ppc/pnv.c                  |  3 +--
 hw/ppc/pnv_xscom.c            |  5 +----
 hw/ppc/ppce500_spin.c         |  3 +--
 hw/ppc/spapr.c                |  3 +--
 hw/ppc/spapr_caps.c           |  7 ++-----
 target/ppc/cpu_init.c         | 11 +++--------
 target/ppc/excp_helper.c      |  3 +--
 target/ppc/gdbstub.c          | 12 ++++--------
 target/ppc/kvm.c              | 12 ++++--------
 target/ppc/ppc-qmp-cmds.c     |  3 +--
 target/ppc/user_only_helper.c |  3 +--
 12 files changed, 21 insertions(+), 47 deletions(-)

diff --git a/hw/ppc/mpc8544_guts.c b/hw/ppc/mpc8544_guts.c
index a26e83d048..e3540b0281 100644
--- a/hw/ppc/mpc8544_guts.c
+++ b/hw/ppc/mpc8544_guts.c
@@ -71,8 +71,7 @@ static uint64_t mpc8544_guts_read(void *opaque, hwaddr addr,
                                   unsigned size)
 {
     uint32_t value = 0;
-    PowerPCCPU *cpu = POWERPC_CPU(current_cpu);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(current_cpu);
 
     addr &= MPC8544_GUTS_MMIO_SIZE - 1;
     switch (addr) {
diff --git a/hw/ppc/pnv.c b/hw/ppc/pnv.c
index 202a569e27..77ee278a98 100644
--- a/hw/ppc/pnv.c
+++ b/hw/ppc/pnv.c
@@ -2294,8 +2294,7 @@ static void pnv_machine_set_hb(Object *obj, bool value, Error **errp)
 
 static void pnv_cpu_do_nmi_on_cpu(CPUState *cs, run_on_cpu_data arg)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
     ppc_cpu_do_system_reset(cs);
diff --git a/hw/ppc/pnv_xscom.c b/hw/ppc/pnv_xscom.c
index 805b1d0c87..a17816d072 100644
--- a/hw/ppc/pnv_xscom.c
+++ b/hw/ppc/pnv_xscom.c
@@ -44,15 +44,12 @@ static void xscom_complete(CPUState *cs, uint64_t hmer_bits)
      * passed for the cpu, and no CPU completion is generated.
      */
     if (cs) {
-        PowerPCCPU *cpu = POWERPC_CPU(cs);
-        CPUPPCState *env = &cpu->env;
-
         /*
          * TODO: Need a CPU helper to set HMER, also handle generation
          * of HMIs
          */
         cpu_synchronize_state(cs);
-        env->spr[SPR_HMER] |= hmer_bits;
+        cpu_env(cs)->spr[SPR_HMER] |= hmer_bits;
     }
 }
 
diff --git a/hw/ppc/ppce500_spin.c b/hw/ppc/ppce500_spin.c
index bbce63e8a4..dfbe759481 100644
--- a/hw/ppc/ppce500_spin.c
+++ b/hw/ppc/ppce500_spin.c
@@ -90,8 +90,7 @@ static void mmubooke_create_initial_mapping(CPUPPCState *env,
 
 static void spin_kick(CPUState *cs, run_on_cpu_data data)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     SpinInfo *curspin = data.host_ptr;
     hwaddr map_size = 64 * MiB;
     hwaddr map_start;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 0b77aa5514..55d0fcb583 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3487,8 +3487,7 @@ static void spapr_machine_finalizefn(Object *obj)
 void spapr_do_system_reset_on_cpu(CPUState *cs, run_on_cpu_data arg)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
     /* If FWNMI is inactive, addr will be -1, which will deliver to 0x100 */
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index e889244e52..cc91d59c57 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -194,8 +194,7 @@ static void cap_htm_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 static void cap_vsx_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 {
     ERRP_GUARD();
-    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(first_cpu);
 
     if (!val) {
         /* TODO: We don't support disabling vsx yet */
@@ -213,14 +212,12 @@ static void cap_vsx_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 static void cap_dfp_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 {
     ERRP_GUARD();
-    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
-    CPUPPCState *env = &cpu->env;
 
     if (!val) {
         /* TODO: We don't support disabling dfp yet */
         return;
     }
-    if (!(env->insns_flags2 & PPC2_DFP)) {
+    if (!(cpu_env(first_cpu)->insns_flags2 & PPC2_DFP)) {
         error_setg(errp, "DFP support not available");
         error_append_hint(errp, "Try appending -machine cap-dfp=off\n");
     }
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 61b8495a90..5d23b32c0e 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7195,12 +7195,9 @@ static void ppc_cpu_reset_hold(Object *obj)
 
 static bool ppc_cpu_is_big_endian(CPUState *cs)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
-
     cpu_synchronize_state(cs);
 
-    return !FIELD_EX64(env->msr, MSR, LE);
+    return !FIELD_EX64(cpu_env(cs)->msr, MSR, LE);
 }
 
 static bool ppc_get_irq_stats(InterruptStatsProvider *obj,
@@ -7287,8 +7284,7 @@ static bool ppc_pvr_match_default(PowerPCCPUClass *pcc, uint32_t pvr, bool best)
 
 static void ppc_disas_set_info(CPUState *cs, disassemble_info *info)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     if ((env->hflags >> MSR_LE) & 1) {
         info->endian = BFD_ENDIAN_LITTLE;
@@ -7446,8 +7442,7 @@ void ppc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 #define RGPL  4
 #define RFPL  4
 
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "NIP " TARGET_FMT_lx "   LR " TARGET_FMT_lx " CTR "
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 2ec6429e36..fccfefa88e 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -2588,8 +2588,7 @@ void ppc_cpu_do_fwnmi_machine_check(CPUState *cs, target_ulong vector)
 
 bool ppc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int interrupt;
 
     if ((interrupt_request & CPU_INTERRUPT_HARD) == 0) {
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index ec5731e5d6..fd986b1922 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -108,8 +108,7 @@ void ppc_maybe_bswap_register(CPUPPCState *env, uint8_t *mem_buf, int len)
 
 int ppc_cpu_gdb_read_register(CPUState *cs, GByteArray *buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     uint8_t *mem_buf;
     int r = ppc_gdb_register_len(n);
 
@@ -152,8 +151,7 @@ int ppc_cpu_gdb_read_register(CPUState *cs, GByteArray *buf, int n)
 
 int ppc_cpu_gdb_read_register_apple(CPUState *cs, GByteArray *buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     uint8_t *mem_buf;
     int r = ppc_gdb_register_len_apple(n);
 
@@ -206,8 +204,7 @@ int ppc_cpu_gdb_read_register_apple(CPUState *cs, GByteArray *buf, int n)
 
 int ppc_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int r = ppc_gdb_register_len(n);
 
     if (!r) {
@@ -253,8 +250,7 @@ int ppc_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 }
 int ppc_cpu_gdb_write_register_apple(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int r = ppc_gdb_register_len_apple(n);
 
     if (!r) {
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index b95a0b4928..b0e35b31a6 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -546,8 +546,7 @@ static void kvm_sw_tlb_put(PowerPCCPU *cpu)
 
 static void kvm_get_one_spr(CPUState *cs, uint64_t id, int spr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     /* Init 'val' to avoid "uninitialised value" Valgrind warnings */
     union {
         uint32_t u32;
@@ -581,8 +580,7 @@ static void kvm_get_one_spr(CPUState *cs, uint64_t id, int spr)
 
 static void kvm_put_one_spr(CPUState *cs, uint64_t id, int spr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     union {
         uint32_t u32;
         uint64_t u64;
@@ -615,8 +613,7 @@ static void kvm_put_one_spr(CPUState *cs, uint64_t id, int spr)
 
 static int kvm_put_fp(CPUState *cs)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     struct kvm_one_reg reg;
     int i;
     int ret;
@@ -682,8 +679,7 @@ static int kvm_put_fp(CPUState *cs)
 
 static int kvm_get_fp(CPUState *cs)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     struct kvm_one_reg reg;
     int i;
     int ret;
diff --git a/target/ppc/ppc-qmp-cmds.c b/target/ppc/ppc-qmp-cmds.c
index c0c137d9d7..9ac74f5c04 100644
--- a/target/ppc/ppc-qmp-cmds.c
+++ b/target/ppc/ppc-qmp-cmds.c
@@ -133,8 +133,7 @@ static int ppc_cpu_get_reg_num(const char *numstr, int maxnum, int *pregnum)
 int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval)
 {
     int i, regnum;
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     /* General purpose registers */
     if ((qemu_tolower(name[0]) == 'r') &&
diff --git a/target/ppc/user_only_helper.c b/target/ppc/user_only_helper.c
index 7ff76f7a06..a4d07a0d0d 100644
--- a/target/ppc/user_only_helper.c
+++ b/target/ppc/user_only_helper.c
@@ -27,8 +27,7 @@ void ppc_cpu_record_sigsegv(CPUState *cs, vaddr address,
                             MMUAccessType access_type,
                             bool maperr, uintptr_t retaddr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int exception, error_code;
 
     /*
-- 
2.41.0


