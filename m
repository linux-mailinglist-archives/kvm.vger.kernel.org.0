Return-Path: <kvm+bounces-20858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2A3924905
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 22:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 242F11F2275E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 20:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234EE200132;
	Tue,  2 Jul 2024 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iSJ/zkT5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95675282E1
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719951565; cv=none; b=h78dPJR1GGbJdz62ed57eVhXUlsUxcCCtnkP1pOGydft4oQED2H5nxnKw4ytLPDpdoRhgwwWjkZrV9Pb0Yb0q5cx8CpoKimRR9KOlzr4dm/7GtfRBel/E8JUhDbClX7j78L1geKHOxRmQ9Tu+ffK8hUms5XcE3oCWztx+GFDN18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719951565; c=relaxed/simple;
	bh=DL9g0ISgeRefyG10IKfseYnH/gBK17Rmtk8biWknW2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOlBHoRERnJ9Tbv2SwgdcnVmdxqD+jil/XdeM3dSUpqNGCaIYa1gdGVcl2vgDKQjdlVv15EoYeHPXAgolL+dKcqU3ksutu4CYFmLdRi9CtUFcrh9x1Q5hNU2kHuSq24aTsr55vOIHL0cgz8aY72eQkD5vo2nLe2XrW5YSYfhJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iSJ/zkT5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719951562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H3osRPyR8JjW6MeyHBrRsmkcAIK1uR3HKs135scl6wM=;
	b=iSJ/zkT5OGuadnO2HhH8N1VlAMl5sUkKXHVuBju2QHSgoxuaKwCK08UaFm15glNkgvFwwT
	srT+liqUX1bcPuN9S8Xk/BKOWwFWk52NsnTQ92167HStlJp1DnkHaKXmvOTI8+gJZduc5R
	aTjUO9rCicxvfqgdenvvcm+j+uaaGZ0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-sjAyT39oPQ66SmsIlzXRTA-1; Tue, 02 Jul 2024 16:19:20 -0400
X-MC-Unique: sjAyT39oPQ66SmsIlzXRTA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-36789def10eso527540f8f.0
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 13:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719951559; x=1720556359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3osRPyR8JjW6MeyHBrRsmkcAIK1uR3HKs135scl6wM=;
        b=VHnco28U+wyE4BE3fCap/Semg8fEHTP/m+BQ9U73KnHPGaGUOuyl3Cny9vQmYE9oz/
         ZGagJUViWZsyDsnj0S5gJ3Map5kmi4R+T4vTiRU3eI126bf5r1ynfgL8Fcu3Y+DSKWm/
         7FO7cYRzRpqixUYT4svUUgffojk+RHro3Y91fCZiac3YvJk4xRLdJMY5Dj+vzeAAoRyb
         /0fB4WTGAVGsniyT6cHgX2kb/RF2RAUjAvO4NuHPVri0n/+AM7t8Hp3DdLE6+KWSV7CB
         NH+1sfjZAgkvFIUC3kZTvjUcLUNWWBSt4hmUVn/bHZTt5QQoJP/fYfumUf4a+3yUq/pR
         SlrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuJJvvzu5ol5AmuaqToEgP01/9Tj/eIY5idwVgsii8ACCmRJdVhwQLkLsfu/D+2dGSV4txBPowUm44l5KHjAKGPEah
X-Gm-Message-State: AOJu0YxN2qXyQG5ze0Q0oAg2pwUjcPd7UmkDpSPbjHAb0OIJ+FrKFGSI
	/mmEVXlRjkIEKRy+XHk5tMlXc5nYcqeWMJSSk5E8xkuMKVIcSsyAQB3cH0MLY1viQAFKF9qiUX7
	Ot2SnBpDRkTyM8tfWPKKrDES9p46UmmC34dXpEZbOMtAvAjwUjQ==
X-Received: by 2002:adf:e682:0:b0:362:6908:e2e3 with SMTP id ffacd0b85a97d-3677571c4e8mr6218265f8f.45.1719951559628;
        Tue, 02 Jul 2024 13:19:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGezRFkcB9rwxFrW2dCnoNbXe1Iero1jBEBp3U7p7UwUudeD8CNDuuNfjV9Z5ZQg0Ew3jaPuA==
X-Received: by 2002:adf:e682:0:b0:362:6908:e2e3 with SMTP id ffacd0b85a97d-3677571c4e8mr6218245f8f.45.1719951559056;
        Tue, 02 Jul 2024 13:19:19 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f5:eadd:8c31:db01:9d01:7604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a103d00sm14169751f8f.99.2024.07.02.13.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 13:19:18 -0700 (PDT)
Date: Tue, 2 Jul 2024 16:19:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Sergio Lopez <slp@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, Paul Durrant <paul@xen.org>,
	kvm@vger.kernel.org
Subject: [PULL v2 61/88] hw/i386/fw_cfg: Add etc/e820 to fw_cfg late
Message-ID: <63592d296f1a6b1aea223d5a1bb2f20f2f0373e2.1719951168.git.mst@redhat.com>
References: <cover.1719951168.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1719951168.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: David Woodhouse <dwmw2@infradead.org>

In e820_add_entry() the e820_table is reallocated with g_renew() to make
space for a new entry. However, fw_cfg_arch_create() just uses the
existing e820_table pointer. This leads to a use-after-free if anything
adds a new entry after fw_cfg is set up.

Shift the addition of the etc/e820 file to the machine done notifier, via
a new fw_cfg_add_e820() function.

Also make e820_table private and use an e820_get_table() accessor function
for it, which sets a flag that will trigger an assert() for any *later*
attempts to add to the table.

Make e820_add_entry() return void, as most callers don't check for error
anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <a2708734f004b224f33d3b4824e9a5a262431568.camel@infradead.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/i386/e820_memory_layout.h |  8 ++------
 hw/i386/fw_cfg.h             |  1 +
 hw/i386/e820_memory_layout.c | 17 ++++++++++++-----
 hw/i386/fw_cfg.c             | 18 +++++++++++++-----
 hw/i386/microvm.c            |  4 ++--
 hw/i386/pc.c                 |  1 +
 target/i386/kvm/kvm.c        |  6 +-----
 target/i386/kvm/xen-emu.c    |  7 +------
 8 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/hw/i386/e820_memory_layout.h b/hw/i386/e820_memory_layout.h
index 7c239aa033..b50acfa201 100644
--- a/hw/i386/e820_memory_layout.h
+++ b/hw/i386/e820_memory_layout.h
@@ -22,13 +22,9 @@ struct e820_entry {
     uint32_t type;
 } QEMU_PACKED __attribute((__aligned__(4)));
 
-extern struct e820_entry *e820_table;
-
-int e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
-int e820_get_num_entries(void);
+void e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
 bool e820_get_entry(int index, uint32_t type,
                     uint64_t *address, uint64_t *length);
-
-
+int e820_get_table(struct e820_entry **table);
 
 #endif
diff --git a/hw/i386/fw_cfg.h b/hw/i386/fw_cfg.h
index 92e310f5fd..e560fd7be8 100644
--- a/hw/i386/fw_cfg.h
+++ b/hw/i386/fw_cfg.h
@@ -27,5 +27,6 @@ void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg,
                          SmbiosEntryPointType ep_type);
 void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg);
 void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg);
+void fw_cfg_add_e820(FWCfgState *fw_cfg);
 
 #endif
diff --git a/hw/i386/e820_memory_layout.c b/hw/i386/e820_memory_layout.c
index 06970ac44a..3e848fb69c 100644
--- a/hw/i386/e820_memory_layout.c
+++ b/hw/i386/e820_memory_layout.c
@@ -11,22 +11,29 @@
 #include "e820_memory_layout.h"
 
 static size_t e820_entries;
-struct e820_entry *e820_table;
+static struct e820_entry *e820_table;
+static gboolean e820_done;
 
-int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+void e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
 {
+    assert(!e820_done);
+
     /* new "etc/e820" file -- include ram and reserved entries */
     e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
     e820_table[e820_entries].address = cpu_to_le64(address);
     e820_table[e820_entries].length = cpu_to_le64(length);
     e820_table[e820_entries].type = cpu_to_le32(type);
     e820_entries++;
-
-    return e820_entries;
 }
 
-int e820_get_num_entries(void)
+int e820_get_table(struct e820_entry **table)
 {
+    e820_done = true;
+
+    if (table) {
+        *table = e820_table;
+    }
+
     return e820_entries;
 }
 
diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 7c43c325ef..0e4494627c 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -48,6 +48,15 @@ const char *fw_cfg_arch_key_name(uint16_t key)
     return NULL;
 }
 
+/* Add etc/e820 late, once all regions should be present */
+void fw_cfg_add_e820(FWCfgState *fw_cfg)
+{
+    struct e820_entry *table;
+    int nr_e820 = e820_get_table(&table);
+
+    fw_cfg_add_file(fw_cfg, "etc/e820", table, nr_e820 * sizeof(*table));
+}
+
 void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg,
                          SmbiosEntryPointType ep_type)
 {
@@ -60,6 +69,7 @@ void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg,
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     MachineClass *mc = MACHINE_GET_CLASS(pcms);
     X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
+    int nr_e820;
 
     if (pcmc->smbios_defaults) {
         /* These values are guest ABI, do not change */
@@ -78,8 +88,9 @@ void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg,
     }
 
     /* build the array of physical mem area from e820 table */
-    mem_array = g_malloc0(sizeof(*mem_array) * e820_get_num_entries());
-    for (i = 0, array_count = 0; i < e820_get_num_entries(); i++) {
+    nr_e820 = e820_get_table(NULL);
+    mem_array = g_malloc0(sizeof(*mem_array) * nr_e820);
+    for (i = 0, array_count = 0; i < nr_e820; i++) {
         uint64_t addr, len;
 
         if (e820_get_entry(i, E820_RAM, &addr, &len)) {
@@ -138,9 +149,6 @@ FWCfgState *fw_cfg_arch_create(MachineState *ms,
 #endif
     fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, 1);
 
-    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
-                    sizeof(struct e820_entry) * e820_get_num_entries());
-
     fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
     /* allocate memory for the NUMA channel: one (64bit) word for the number
      * of nodes, one word for each VCPU->node and one word for each node to
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index fec63cacfa..40edcee7af 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -324,8 +324,6 @@ static void microvm_memory_init(MicrovmMachineState *mms)
     fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, machine->smp.max_cpus);
     fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)machine->ram_size);
     fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, 1);
-    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
-                    sizeof(struct e820_entry) * e820_get_num_entries());
 
     rom_set_fw(fw_cfg);
 
@@ -586,9 +584,11 @@ static void microvm_machine_done(Notifier *notifier, void *data)
 {
     MicrovmMachineState *mms = container_of(notifier, MicrovmMachineState,
                                             machine_done);
+    X86MachineState *x86ms = X86_MACHINE(mms);
 
     acpi_setup_microvm(mms);
     dt_setup_microvm(mms);
+    fw_cfg_add_e820(x86ms->fw_cfg);
 }
 
 static void microvm_powerdown_req(Notifier *notifier, void *data)
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 77415064c6..d2c29fbfcb 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -625,6 +625,7 @@ void pc_machine_done(Notifier *notifier, void *data)
     acpi_setup();
     if (x86ms->fw_cfg) {
         fw_cfg_build_smbios(pcms, x86ms->fw_cfg, pcms->smbios_entry_point_type);
+        fw_cfg_add_e820(x86ms->fw_cfg);
         fw_cfg_build_feature_control(MACHINE(pcms), x86ms->fw_cfg);
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index dd8b0f3313..bf182570fe 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2706,11 +2706,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     /* Tell fw_cfg to notify the BIOS to reserve the range. */
-    ret = e820_add_entry(identity_base, 0x4000, E820_RESERVED);
-    if (ret < 0) {
-        fprintf(stderr, "e820_add_entry() table is full\n");
-        return ret;
-    }
+    e820_add_entry(identity_base, 0x4000, E820_RESERVED);
 
     shadow_mem = object_property_get_int(OBJECT(s), "kvm-shadow-mem", &error_abort);
     if (shadow_mem != -1) {
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index fc2c2321ac..2f89dc628e 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -176,12 +176,7 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     s->xen_caps = xen_caps;
 
     /* Tell fw_cfg to notify the BIOS to reserve the range. */
-    ret = e820_add_entry(XEN_SPECIAL_AREA_ADDR, XEN_SPECIAL_AREA_SIZE,
-                         E820_RESERVED);
-    if (ret < 0) {
-        fprintf(stderr, "e820_add_entry() table is full\n");
-        return ret;
-    }
+    e820_add_entry(XEN_SPECIAL_AREA_ADDR, XEN_SPECIAL_AREA_SIZE, E820_RESERVED);
 
     /* The pages couldn't be overlaid until KVM was initialized */
     xen_primary_console_reset();
-- 
MST


