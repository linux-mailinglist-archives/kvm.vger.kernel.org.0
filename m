Return-Path: <kvm+bounces-6440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1F383202B
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42CE5B26C24
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A502E836;
	Thu, 18 Jan 2024 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UaqLemxN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641292E826
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608461; cv=none; b=HKFOqdgFB7goi5NAC761NS7yTGZVAx46FXy8kojBBJdG2cPM0N+PpgFFwTicT8gtEUc3bLrN947r2l1zvgWFUNB69z8ueGEHOAjwldb+bRoIOaIGOKopr/XdhaoBL+MEalSig1qG26PmmRUVuUNhRQ95zw7LafHk2DNmgOHWW5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608461; c=relaxed/simple;
	bh=/qV+glV9bKFxPzor5MRukAyNlVVBZyPDloBrgGh4i4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NpDU0fwDCIFh1hFWg2qlRsThkG8zpqz9hqN8y9tYdizf2ggpfBHQWtf9EAsJf5XnoVHwYY/nNEyLcxhGPEml4dfQo3EcYG+w+9E8K0PsNuTHvHFHCpOJa3F15AGCVbg8H8bF9nDRqOLYMUmiNBYjs6MGZKJ6h9iLIBPa3RRjgu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UaqLemxN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e959b1867so303735e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608457; x=1706213257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/ejlWr/vr3IWLu/MuGvfyfJuGNUVTGyi/ukONUd4RY=;
        b=UaqLemxNEF3ltafe4BRSsomFgCI3pRqMbnbvAuUZPtHWCCd/yrApoJ3aOHgg+kkjCN
         u9qGRELIFVjTb7TkUc0SQzOTz+zjvLCylC1a3e5B4vB4jhBAPQFswCkfk6lpmff3UPBg
         x2ZJDK8Z+P9bHhfHEqk1fclhq3BHmKJWri42Q+0MMER+rVDNcmVyvJzk2XqA64gukmpO
         4wxGOfPhLCeMd9W54gV+hWtaHW8Uy3hPUy/XdRcNNEzPs5zYpEajehvWeoIZkIKWqwId
         ZGhwpY9uddMn/ZBuF2TFPOSE5xs7/LSXa83TKPvjPdSiH45ucNNRkarhQK9+j98ryJ5F
         52Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608457; x=1706213257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/ejlWr/vr3IWLu/MuGvfyfJuGNUVTGyi/ukONUd4RY=;
        b=hTYpa1BvmMCLbok2gAFvrqYtZYgbye9KTPFFJvP2pkfY39qWDdIkYroo7By6XvqyfU
         b8ccCwcN+dEBUFaL5WVKBDP11Y5G59qqTLxDU1cZ3+luBHAYVBO8QgrvGWTqme9gj/PO
         bNkpcLH5Pd4yltyYaOqBxfMqyKoirUNKfUpMH4uMPj42S+/yl1IIRPLPBmrmPa9wdGay
         wlkpqQySu+XeWQMOQHkTpHsAIQjqXVTvK5l3h/s9mbFIlZR8u8+XqrZyITLq9RYmSUSt
         FwnWnINzy8YTNjTCvnTfLErrd/GjGAq6vDOQL54EYw2QUjfiBPeyT45kSh/bW6wD1C30
         n7Qg==
X-Gm-Message-State: AOJu0YxnUbNz/MJCRekIawTcc0fbBQcduAsruAMVU280tx60oq1yK3Ac
	uRE3jBeCd7AVUCRJ1FdADVm+uHObami0EalvlsUod8LLz7Jk43e5rLVBYRHiru0=
X-Google-Smtp-Source: AGHT+IH48LYCm5FvvdfIRtPDEmtB/JkgBtRiKzuU74C3lUeA8vSv4dmG9wi39anX1f9TeL29iIfhIg==
X-Received: by 2002:a05:600c:63d7:b0:40e:71e7:b2e4 with SMTP id dx23-20020a05600c63d700b0040e71e7b2e4mr900948wmb.60.1705608457713;
        Thu, 18 Jan 2024 12:07:37 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c138600b0040d5a9d6b68sm30919468wmf.6.2024.01.18.12.07.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:37 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 09/20] target/arm: Create arm_cpu_mp_affinity
Date: Thu, 18 Jan 2024 21:06:30 +0100
Message-ID: <20240118200643.29037-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Henderson <richard.henderson@linaro.org>

Wrapper to return the mp affinity bits from the cpu.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h          | 5 +++++
 hw/arm/virt-acpi-build.c  | 2 +-
 hw/arm/virt.c             | 6 +++---
 hw/arm/xlnx-versal-virt.c | 3 ++-
 hw/misc/xlnx-versal-crl.c | 4 ++--
 target/arm/arm-powerctl.c | 2 +-
 target/arm/hvf/hvf.c      | 4 ++--
 target/arm/tcg/psci.c     | 2 +-
 8 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 55a19e8539..d1584bdb3b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1173,6 +1173,11 @@ void arm_cpu_post_init(Object *obj);
 
 uint64_t arm_build_mp_affinity(int idx, uint8_t clustersz);
 
+static inline uint64_t arm_cpu_mp_affinity(ARMCPU *cpu)
+{
+    return cpu->mp_affinity;
+}
+
 #ifndef CONFIG_USER_ONLY
 extern const VMStateDescription vmstate_arm_cpu;
 
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index a22a2f43a5..2127778c1e 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -720,7 +720,7 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
         build_append_int_noprefix(table_data, vgic_interrupt, 4);
         build_append_int_noprefix(table_data, 0, 8);    /* GICR Base Address*/
         /* MPIDR */
-        build_append_int_noprefix(table_data, armcpu->mp_affinity, 8);
+        build_append_int_noprefix(table_data, arm_cpu_mp_affinity(armcpu), 8);
         /* Processor Power Efficiency Class */
         build_append_int_noprefix(table_data, 0, 1);
         /* Reserved */
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 3fc144236b..34cba9ebd8 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -370,7 +370,7 @@ static void fdt_add_cpu_nodes(const VirtMachineState *vms)
     for (cpu = 0; cpu < smp_cpus; cpu++) {
         ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(cpu));
 
-        if (armcpu->mp_affinity & ARM_AFF3_MASK) {
+        if (arm_cpu_mp_affinity(armcpu) & ARM_AFF3_MASK) {
             addr_cells = 2;
             break;
         }
@@ -397,10 +397,10 @@ static void fdt_add_cpu_nodes(const VirtMachineState *vms)
 
         if (addr_cells == 2) {
             qemu_fdt_setprop_u64(ms->fdt, nodename, "reg",
-                                 armcpu->mp_affinity);
+                                 arm_cpu_mp_affinity(armcpu));
         } else {
             qemu_fdt_setprop_cell(ms->fdt, nodename, "reg",
-                                  armcpu->mp_affinity);
+                                  arm_cpu_mp_affinity(armcpu));
         }
 
         if (ms->possible_cpus->cpus[cs->cpu_index].props.has_node_id) {
diff --git a/hw/arm/xlnx-versal-virt.c b/hw/arm/xlnx-versal-virt.c
index 537118224f..841ef69df6 100644
--- a/hw/arm/xlnx-versal-virt.c
+++ b/hw/arm/xlnx-versal-virt.c
@@ -107,7 +107,8 @@ static void fdt_add_cpu_nodes(VersalVirt *s, uint32_t psci_conduit)
         ARMCPU *armcpu = ARM_CPU(qemu_get_cpu(i));
 
         qemu_fdt_add_subnode(s->fdt, name);
-        qemu_fdt_setprop_cell(s->fdt, name, "reg", armcpu->mp_affinity);
+        qemu_fdt_setprop_cell(s->fdt, name, "reg",
+                              arm_cpu_mp_affinity(armcpu));
         if (psci_conduit != QEMU_PSCI_CONDUIT_DISABLED) {
             qemu_fdt_setprop_string(s->fdt, name, "enable-method", "psci");
         }
diff --git a/hw/misc/xlnx-versal-crl.c b/hw/misc/xlnx-versal-crl.c
index ac6889fcf2..9bfa9baa15 100644
--- a/hw/misc/xlnx-versal-crl.c
+++ b/hw/misc/xlnx-versal-crl.c
@@ -67,9 +67,9 @@ static void crl_reset_cpu(XlnxVersalCRL *s, ARMCPU *armcpu,
                           bool rst_old, bool rst_new)
 {
     if (rst_new) {
-        arm_set_cpu_off(armcpu->mp_affinity);
+        arm_set_cpu_off(arm_cpu_mp_affinity(armcpu));
     } else {
-        arm_set_cpu_on_and_reset(armcpu->mp_affinity);
+        arm_set_cpu_on_and_reset(arm_cpu_mp_affinity(armcpu));
     }
 }
 
diff --git a/target/arm/arm-powerctl.c b/target/arm/arm-powerctl.c
index 8850381565..6c86e90102 100644
--- a/target/arm/arm-powerctl.c
+++ b/target/arm/arm-powerctl.c
@@ -37,7 +37,7 @@ CPUState *arm_get_cpu_by_id(uint64_t id)
     CPU_FOREACH(cpu) {
         ARMCPU *armcpu = ARM_CPU(cpu);
 
-        if (armcpu->mp_affinity == id) {
+        if (arm_cpu_mp_affinity(armcpu) == id) {
             return cpu;
         }
     }
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index a537a5bc94..659401e12c 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1016,7 +1016,7 @@ static void hvf_raise_exception(CPUState *cpu, uint32_t excp,
 
 static void hvf_psci_cpu_off(ARMCPU *arm_cpu)
 {
-    int32_t ret = arm_set_cpu_off(arm_cpu->mp_affinity);
+    int32_t ret = arm_set_cpu_off(arm_cpu_mp_affinity(arm_cpu));
     assert(ret == QEMU_ARM_POWERCTL_RET_SUCCESS);
 }
 
@@ -1045,7 +1045,7 @@ static bool hvf_handle_psci_call(CPUState *cpu)
     int32_t ret = 0;
 
     trace_hvf_psci_call(param[0], param[1], param[2], param[3],
-                        arm_cpu->mp_affinity);
+                        arm_cpu_mp_affinity(arm_cpu));
 
     switch (param[0]) {
     case QEMU_PSCI_0_2_FN_PSCI_VERSION:
diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index 9080a91d9c..50d4b23d26 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -215,7 +215,7 @@ err:
     return;
 
 cpu_off:
-    ret = arm_set_cpu_off(cpu->mp_affinity);
+    ret = arm_set_cpu_off(arm_cpu_mp_affinity(cpu));
     /* notreached */
     /* sanity check in case something failed */
     assert(ret == QEMU_ARM_POWERCTL_RET_SUCCESS);
-- 
2.41.0


