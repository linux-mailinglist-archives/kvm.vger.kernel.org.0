Return-Path: <kvm+bounces-45866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 908EBAAFB9A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058024E5771
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA2E22B8B6;
	Thu,  8 May 2025 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wmqQTGIs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59EF4B1E6D
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711524; cv=none; b=TeRSEo4G5mtw2dQejbIeboAL7tvfUlku0N6A/mwXz9YmTZJLXdtWlYrJeSiyQb7HsRN+IWUW2uvqeBoKSRaga+gBr8yy57/4McEI/NCWLuW0b6sX91RJS6EI3onmlH/j0SCISuI7BCTfLHSFPLxPfjNt6N6zfvwzw9ZeqQ97E7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711524; c=relaxed/simple;
	bh=nbZve86/AYbwkwYhjmqnf2kpoo9ncViMUTpo3vbGjio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ok1CU0XkfNmIQKLWevnTKBDn6ljh1wGH4bcVUpW29paJUaPhdiQXeHs0GWHQ4zM1TTokb+EHU0K+vCcTTb8Io4wsURqKWb4YAvU4eekcek10GQlSL7bU4oAZPwOm6uuaBuo/pVOdZdZeVllbPAzm6odrpO3cUfRvSE8WT1xJlGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wmqQTGIs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22fbbf9c01bso2223335ad.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711521; x=1747316321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePutPBZZqx13DDtsmzXUVgqQnJtyUKSO1VjVCMGLpvw=;
        b=wmqQTGIs1l+vJzjK74JcAf2EmU/eIUc9Y1AF+Pw9WW8K7G+7Z73agFwryM/eRHPQue
         V1chneUW8rM8KaP3oXUnFovstTB72DTQXqLCZM7a6Md4hiLLYBZ+8ptmmPnQtSNKwCev
         sDK1q7GCHQnX9o6bpUslcWLZvklm+5Y1mouNfUzPCIMyVFRB9fzNdqUYtMOhhDOfXVZi
         4ZgpTFmuPJfNYNgekPSQy3Pa+rujUZpJNJRgNM76NjLER+CaLviS173G1AsUkmbWMr6L
         5iDZ5zaE2jgywxfHCZoTOBgp6Ht6uJvScUeUv1J2K0F2cdA197eatT0F7DHmKHWxN8lw
         U2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711521; x=1747316321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePutPBZZqx13DDtsmzXUVgqQnJtyUKSO1VjVCMGLpvw=;
        b=VPY1aD9x89Q1omFvg9Vz/1/3ZgrNOuepWZM0lx4KFu1OUy+o7rFoHeIA+zjqj+p8fM
         eOvwMOhSYt4og0pMH/7ZeqUMfy7nrTUYKdKRFlc0Zdt29GiVRivk09Jet1wxGWT91ZMQ
         5ETBkHhDawGVJhFc+V3993i6zDjbzMCtw0Vd9tXpzSf4VKa1dV2M6txhU1akmPgCBaAq
         gAnydrZ0cm/1LgRbIaL/NZ3C2NZt88eju+L7T3Pq6PQIBLnNQoSQEoU8kGumYvM++W/F
         eSIunWjcybrcrtDZogny37mRmR8+pm4kc/S8TiJXcPv4QSiPsXUczjuBLrUx7A4R+rzp
         qgsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe0vafOvymx9al9eAsmJn2p2Ez34NOnp2Pr7h75XSsS+B6uPJePUd2RWU+G4hi/5FGFaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQmzlNCBnakMP7NEiJehRptWgHMgLYaQXLs40OKZH74ci8XpO
	oo3TlLBoVh/j1nb45I1aKjeysDfQcR99V4IHZVCfZndWChcm+X8qGjwMCb7ebLg=
X-Gm-Gg: ASbGncuVSLK1Iwgu+4i+cgxWDD1/HC/cA+Gr+bvqv9DJLmIbFMgVb1K1bw6u/e/mZ9f
	uEyYigdXY5iz8A2hooFeCvZVDJ6urvb1bdz3oaPyryFcpgfxEc3YbjbAwn7VwmaTBA+IbXlh/Ew
	L6UZUALoAAAPhqPc1zbBkWfRtBsnOC4AtnhhcT/scB8x6DUXlDnACtUDIuZ7TazF2/n08bx3VOi
	4NqOme4kS1NedjMUnkEjW9sJ0UPjhFvBprNsmFSZw7cEcZF6e4WJ5Fbh/oFAP4UkN5T0awECxry
	cStc1RDiNsO/5Lr9bYbz1SF/woWex55nKuyF3HQ1Al8IZno6mWjavc6d/+/R6Toow2Y0pw8xb3K
	h0o2QH2O6U1Zhjbw=
X-Google-Smtp-Source: AGHT+IGNgxOPLiTzh1fGobc2t1F5+RIKAiji7b9B9I1DfVv+yb0iKtesoZBDvhr0nJNnujewbvszoQ==
X-Received: by 2002:a17:903:32c1:b0:21f:4c8b:c4de with SMTP id d9443c01a7336-22e5ecab7c3mr113369565ad.42.1746711521068;
        Thu, 08 May 2025 06:38:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e4299618esm51501905ad.198.2025.05.08.06.38.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:38:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH v4 07/27] hw/i386/x86: Remove X86MachineClass::fwcfg_dma_enabled field
Date: Thu,  8 May 2025 15:35:30 +0200
Message-ID: <20250508133550.81391-8-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The X86MachineClass::fwcfg_dma_enabled boolean was only used
by the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
removed. Remove it and simplify.

'multiboot.bin' isn't used anymore, we'll remove it in the
next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/x86.h | 2 --
 hw/i386/microvm.c     | 3 ---
 hw/i386/multiboot.c   | 7 +------
 hw/i386/x86-common.c  | 3 +--
 hw/i386/x86.c         | 2 --
 5 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index fc460b82f82..29d37af11e6 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -29,8 +29,6 @@
 struct X86MachineClass {
     MachineClass parent;
 
-    /* use DMA capable linuxboot option rom */
-    bool fwcfg_dma_enabled;
     /* CPU and apic information: */
     bool apic_xrupt_override;
 };
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index e0daf0d4fc3..b1262fb1523 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -637,7 +637,6 @@ GlobalProperty microvm_properties[] = {
 
 static void microvm_class_init(ObjectClass *oc, const void *data)
 {
-    X86MachineClass *x86mc = X86_MACHINE_CLASS(oc);
     MicrovmMachineClass *mmc = MICROVM_MACHINE_CLASS(oc);
     MachineClass *mc = MACHINE_CLASS(oc);
     HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
@@ -671,8 +670,6 @@ static void microvm_class_init(ObjectClass *oc, const void *data)
     hc->unplug_request = microvm_device_unplug_request_cb;
     hc->unplug = microvm_device_unplug_cb;
 
-    x86mc->fwcfg_dma_enabled = true;
-
     object_class_property_add(oc, MICROVM_MACHINE_RTC, "OnOffAuto",
                               microvm_machine_get_rtc,
                               microvm_machine_set_rtc,
diff --git a/hw/i386/multiboot.c b/hw/i386/multiboot.c
index 6e6b96bc345..bfa7e8f1e83 100644
--- a/hw/i386/multiboot.c
+++ b/hw/i386/multiboot.c
@@ -153,7 +153,6 @@ int load_multiboot(X86MachineState *x86ms,
                    int kernel_file_size,
                    uint8_t *header)
 {
-    bool multiboot_dma_enabled = X86_MACHINE_GET_CLASS(x86ms)->fwcfg_dma_enabled;
     int i, is_multiboot = 0;
     uint32_t flags = 0;
     uint32_t mh_entry_addr;
@@ -402,11 +401,7 @@ int load_multiboot(X86MachineState *x86ms,
     fw_cfg_add_bytes(fw_cfg, FW_CFG_INITRD_DATA, mb_bootinfo_data,
                      sizeof(bootinfo));
 
-    if (multiboot_dma_enabled) {
-        option_rom[nb_option_roms].name = "multiboot_dma.bin";
-    } else {
-        option_rom[nb_option_roms].name = "multiboot.bin";
-    }
+    option_rom[nb_option_roms].name = "multiboot_dma.bin";
     option_rom[nb_option_roms].bootindex = 0;
     nb_option_roms++;
 
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index 1b0671c5239..27254a0e9f1 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -634,7 +634,6 @@ void x86_load_linux(X86MachineState *x86ms,
                     int acpi_data_size,
                     bool pvh_enabled)
 {
-    bool linuxboot_dma_enabled = X86_MACHINE_GET_CLASS(x86ms)->fwcfg_dma_enabled;
     uint16_t protocol;
     int setup_size, kernel_size, cmdline_size;
     int dtb_size, setup_data_offset;
@@ -993,7 +992,7 @@ void x86_load_linux(X86MachineState *x86ms,
 
     option_rom[nb_option_roms].bootindex = 0;
     option_rom[nb_option_roms].name = "linuxboot.bin";
-    if (linuxboot_dma_enabled && fw_cfg_dma_enabled(fw_cfg)) {
+    if (fw_cfg_dma_enabled(fw_cfg)) {
         option_rom[nb_option_roms].name = "linuxboot_dma.bin";
     }
     nb_option_roms++;
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index f80533df1c5..dbf104d60af 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -375,14 +375,12 @@ static void x86_machine_initfn(Object *obj)
 static void x86_machine_class_init(ObjectClass *oc, const void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
-    X86MachineClass *x86mc = X86_MACHINE_CLASS(oc);
     NMIClass *nc = NMI_CLASS(oc);
 
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
     mc->kvm_type = x86_kvm_type;
-    x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
 
     object_class_property_add(oc, X86_MACHINE_SMM, "OnOffAuto",
-- 
2.47.1


