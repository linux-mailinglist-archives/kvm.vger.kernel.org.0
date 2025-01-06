Return-Path: <kvm+bounces-34635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E447A03107
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 233C41610AF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B901D61B9;
	Mon,  6 Jan 2025 20:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mkkdda3n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6C1D799D
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193811; cv=none; b=HvbWnqBhe4heh4GmXlSAp+Kn+slTThHFnqofY9CRk0bZ/njEIaFD06jM8mJ63xq3lGM4KHUC5qTG6jKpBCzEEo/qsFJFG2msb5F1xzFY0WmrO2W8D/0lZQWI+wurGnU1AvOAsafcx93YoolfeNsJMZvWGrkvpHgT0K6mn6Ox0Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193811; c=relaxed/simple;
	bh=SALFw4F5p5mN8BlcdhgV0DARypbvRTD5Cq1Wr8Zs9xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0XbFWhqe5Hl8/yPcdwIzhdTOAkmHe8FMeY+1R5FX2MBFNbf4FhhhYQFg64ozJJK8mtMKKhfz2KJnaXbIFy0or7c3Ml9oj/88NLrBeys4FDcoZpatk9Id18cxiOLE9HwlOGCfn60RyClL3/fs+OkSux5I4bntGn+BhOEIHxo6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mkkdda3n; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43618283d48so106994835e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193808; x=1736798608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfaBEiOdRjHzzwUS3kiFtedqZxggxEJ4hucj9YdleWw=;
        b=mkkdda3nIizSmlRwM4ja2snwlBbVdcDBMr3PzHjWp5PCyzL4daiX4MuVQ9f67EblUs
         lYjBOinB/BIW2QatskEdy5MTkYVu9jFzpZmXJHpAFDVfBVA+bYWq36W+3Tb0XwHPQXif
         jqVtq5k7hklB1Jc3AkotGSdwe2EJ0EkB8fHwejo13b1hVKx0PglJlqpnByVP22E5UjoH
         9QedR8HRYuRmMk64ztOSyJuadk3JKipxYWkqa6AeI/XGlRHaGhcOO7IE5f5NEwbHIO06
         uYo49DsOWVhPlpsSHGD98aWvqtWdYKCUUCvMkPIJ3vOYzWpIVUeN6YNKkvTUjqfq5fxN
         6Fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193808; x=1736798608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfaBEiOdRjHzzwUS3kiFtedqZxggxEJ4hucj9YdleWw=;
        b=BRsszWilqyQO6pW3ZKspxNIhyLpd1C6VwP1QHu4puHKWMINJBdXQT10X19hnkZMiqs
         EYYTkqCcgwtRJWh5fs7tFqEHOsaisw70KTulPLJLSLUyTsuxrv0joCXekKNQlek7et2i
         6K62lDgrryXIxi1khhA5/NP6kDRc8TyWtA/ejroFLUN/NlfF+OSAudF/eBhNbCQNSQqj
         D+CjHAMBWdB7lD/vzeqPSMNltw2R0442YLm2KLKVzGYS/r2cOHLs9bJ/P3CcQ82Jlcs6
         7BM0jnIiJ5OXj9YHThGohvqnZD9k38/t9sfYPMpYjTALq+QDi86gfOhJaSwtfWxEshs3
         YLdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGDXjN+k4uNsVbx6f1BHIaj9YwndCf8XkqLBPVpre1p4pOwk/NbG77ANsKoZlunIxlJhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFeygrOVcXryYJikuE9risi45NFcadhaXtOWIGd6lJjHtIDM8b
	4NVdDGMd3Fxq/GbCwwR56GCcLSNOkf+MXw+iGUGbR1GxwaYKvcrZQJe2CqCmZP4=
X-Gm-Gg: ASbGnctXsnSKlm4UeAVL/EiDOkK9apdqDnOV3kASeVziiu1z3jQKyKhbu8DlGbhcNte
	ZBZQAOo14lCIhxJid5pThrOKCC5oGk9NukaS0p/wt92gWJMwKPAQBHdCPhIzYcwxTovMAjapyTB
	tbSDVDVjMWRqxlFoi40DUEmhk2AWlt2aup6ysLtdbxc0CSMn57spBK+N7fmFnolT+4OW3dxRiAl
	DAMr6+1NXAocewUA3k0bFamsnGfXIF31P6h8QUmOTyDHuqldmxTpnu8iTREsgfuR0zbw1ErGwo3
	MJAE4FqfdxwHh95icslW6qXCi0JpoDA=
X-Google-Smtp-Source: AGHT+IF3+buEkSMAzhBuTtka5TQV/I34nAgDx1rHh3g80/cDyG64W7K1EH4+aemix37pseTOETajew==
X-Received: by 2002:a05:600c:4f94:b0:434:f871:1b96 with SMTP id 5b1f17b1804b1-43668b7a1dfmr474821135e9.29.1736193807616;
        Mon, 06 Jan 2025 12:03:27 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656af6cbbsm610646205e9.3.2025.01.06.12.03.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:26 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Alexander Graf <agraf@csgraf.de>,
	Paul Durrant <paul@xen.org>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org,
	Riku Voipio <riku.voipio@iki.fi>,
	Anthony PERARD <anthony@xenproject.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Edgar E . Iglesias" <edgar.iglesias@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	David Woodhouse <dwmw2@infradead.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>
Subject: [RFC PATCH 4/7] accel/tcg: Use CPU_FOREACH_TCG()
Date: Mon,  6 Jan 2025 21:02:55 +0100
Message-ID: <20250106200258.37008-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106200258.37008-1-philmd@linaro.org>
References: <20250106200258.37008-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only iterate over TCG vCPUs when running TCG specific code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/cputlb.c           |  7 ++++---
 accel/tcg/monitor.c          |  3 ++-
 accel/tcg/tb-maint.c         |  7 ++++---
 accel/tcg/tcg-accel-ops-rr.c | 10 +++++-----
 accel/tcg/tcg-accel-ops.c    |  8 ++++----
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index b4ccf0cdcb7..06f34df808b 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -48,6 +48,7 @@
 #endif
 #include "tcg/tcg-ldst.h"
 #include "tcg/oversized-guest.h"
+#include "tcg-accel-ops.h"
 
 /* DEBUG defines, enable DEBUG_TLB_LOG to log to the CPU_LOG_MMU target */
 /* #define DEBUG_TLB */
@@ -368,7 +369,7 @@ static void flush_all_helper(CPUState *src, run_on_cpu_func fn,
 {
     CPUState *cpu;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         if (cpu != src) {
             async_run_on_cpu(cpu, fn, d);
         }
@@ -646,7 +647,7 @@ void tlb_flush_page_by_mmuidx_all_cpus_synced(CPUState *src_cpu,
         TLBFlushPageByMMUIdxData *d;
 
         /* Allocate a separate data block for each destination cpu.  */
-        CPU_FOREACH(dst_cpu) {
+        CPU_FOREACH_TCG(dst_cpu) {
             if (dst_cpu != src_cpu) {
                 d = g_new(TLBFlushPageByMMUIdxData, 1);
                 d->addr = addr;
@@ -839,7 +840,7 @@ void tlb_flush_range_by_mmuidx_all_cpus_synced(CPUState *src_cpu,
     d.bits = bits;
 
     /* Allocate a separate data block for each destination cpu.  */
-    CPU_FOREACH(dst_cpu) {
+    CPU_FOREACH_TCG(dst_cpu) {
         if (dst_cpu != src_cpu) {
             p = g_memdup(&d, sizeof(d));
             async_run_on_cpu(dst_cpu, tlb_flush_range_by_mmuidx_async_1,
diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index ae1dbeb79f8..98bd937ae20 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -19,6 +19,7 @@
 #include "tcg/tcg.h"
 #include "internal-common.h"
 #include "tb-context.h"
+#include "tcg-accel-ops.h"
 
 
 static void dump_drift_info(GString *buf)
@@ -131,7 +132,7 @@ static void tlb_flush_counts(size_t *pfull, size_t *ppart, size_t *pelide)
     CPUState *cpu;
     size_t full = 0, part = 0, elide = 0;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         full += qatomic_read(&cpu->neg.tlb.c.full_flush_count);
         part += qatomic_read(&cpu->neg.tlb.c.part_flush_count);
         elide += qatomic_read(&cpu->neg.tlb.c.elide_flush_count);
diff --git a/accel/tcg/tb-maint.c b/accel/tcg/tb-maint.c
index 3f1bebf6ab5..8598c59654f 100644
--- a/accel/tcg/tb-maint.c
+++ b/accel/tcg/tb-maint.c
@@ -36,6 +36,7 @@
 #ifdef CONFIG_USER_ONLY
 #include "user/page-protection.h"
 #endif
+#include "tcg-accel-ops.h"
 
 
 /* List iterators for lists of tagged pointers in TranslationBlock. */
@@ -771,7 +772,7 @@ static void do_tb_flush(CPUState *cpu, run_on_cpu_data tb_flush_count)
     }
     did_flush = true;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         tcg_flush_jmp_cache(cpu);
     }
 
@@ -885,13 +886,13 @@ static void tb_jmp_cache_inval_tb(TranslationBlock *tb)
 
     if (tb_cflags(tb) & CF_PCREL) {
         /* A TB may be at any virtual address */
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             tcg_flush_jmp_cache(cpu);
         }
     } else {
         uint32_t h = tb_jmp_cache_hash_func(tb->pc);
 
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             CPUJumpCache *jc = cpu->tb_jmp_cache;
 
             if (qatomic_read(&jc->array[h].tb) == tb) {
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 028b385af9a..e5ce285efb9 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -42,7 +42,7 @@ void rr_kick_vcpu_thread(CPUState *unused)
 {
     CPUState *cpu;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         cpu_exit(cpu);
     };
 }
@@ -116,7 +116,7 @@ static void rr_wait_io_event(void)
 
     rr_start_kick_timer();
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         qemu_wait_io_event_common(cpu);
     }
 }
@@ -129,7 +129,7 @@ static void rr_deal_with_unplugged_cpus(void)
 {
     CPUState *cpu;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_TCG(cpu) {
         if (cpu->unplug && !cpu_can_run(cpu)) {
             tcg_cpu_destroy(cpu);
             break;
@@ -160,7 +160,7 @@ static int rr_cpu_count(void)
 
     if (cpu_list_generation_id_get() != last_gen_id) {
         cpu_count = 0;
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             ++cpu_count;
         }
         last_gen_id = cpu_list_generation_id_get();
@@ -201,7 +201,7 @@ static void *rr_cpu_thread_fn(void *arg)
         qemu_cond_wait_bql(first_cpu->halt_cond);
 
         /* process any pending work */
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             current_cpu = cpu;
             qemu_wait_io_event_common(cpu);
         }
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 1fb077f7b38..371bbaa0307 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -144,7 +144,7 @@ static int tcg_insert_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
     switch (type) {
     case GDB_BREAKPOINT_SW:
     case GDB_BREAKPOINT_HW:
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             err = cpu_breakpoint_insert(cpu, addr, BP_GDB, NULL);
             if (err) {
                 break;
@@ -154,7 +154,7 @@ static int tcg_insert_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
     case GDB_WATCHPOINT_WRITE:
     case GDB_WATCHPOINT_READ:
     case GDB_WATCHPOINT_ACCESS:
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             err = cpu_watchpoint_insert(cpu, addr, len,
                                         xlat_gdb_type(cpu, type), NULL);
             if (err) {
@@ -175,7 +175,7 @@ static int tcg_remove_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
     switch (type) {
     case GDB_BREAKPOINT_SW:
     case GDB_BREAKPOINT_HW:
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             err = cpu_breakpoint_remove(cpu, addr, BP_GDB);
             if (err) {
                 break;
@@ -185,7 +185,7 @@ static int tcg_remove_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
     case GDB_WATCHPOINT_WRITE:
     case GDB_WATCHPOINT_READ:
     case GDB_WATCHPOINT_ACCESS:
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_TCG(cpu) {
             err = cpu_watchpoint_remove(cpu, addr, len,
                                         xlat_gdb_type(cpu, type));
             if (err) {
-- 
2.47.1


