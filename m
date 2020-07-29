Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF282319DD
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgG2G5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgG2G5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:57:30 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F7C061794;
        Tue, 28 Jul 2020 23:57:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id r4so751114pls.2;
        Tue, 28 Jul 2020 23:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QRfAGN0MdP+fjxq7Qg4MlatGWem+7ksb1mj2jHuAXdQ=;
        b=HDkmcAiR+/bPIFwjc/Z0779rnahpdKk7jr5hQ9OaLsCLzSvXCUhqW/DehAe3X1GG3f
         BtN3KB3IybsbhEX8m8ztP/PIcC9GG0BEGZuXtxsQ/tE7iaCvCXuHlwbJBujXx87PKehi
         yGepQgc66HsL12OqSHKxXzsB43C/5/q6PubOE21+EnZoNqzc1bzRQEhag8mZGo/ql1pt
         flut4uuHthmmlLI7N/WMAR9k3JdlXcYbDg12dDfzxw6S3RkoaKCQUUey1RO0Vvwn43G/
         HuNREEsa2CyCjdxYAwTcf4I53ehsRj8O+V76avBuDSkRktqRPqrNwAeSIoEMSNNRbFmf
         VFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=QRfAGN0MdP+fjxq7Qg4MlatGWem+7ksb1mj2jHuAXdQ=;
        b=Iz5Yuly5KQLaNVBxiiiiJd/XW6rnoaQXH/jA6Di0gamjwafKLDA1GO/2UHsKTJUt7B
         t/kzZWpQIORhnW9IXz6UeVO6yOzXnCL2aKYVz/jTz+J4i0K48C2k4IeQI76mO9JaD2So
         PFVjvRM0KO2NPRBPh2R3anW+jPROS3+xoUt6mFbbxwJSjqvUAyZogwpCZzRBfB6ZvJys
         yEoCxTFzxSeIY5ycV2JrEuT/y1i1/4JsuiEITUUe8eGsvtOCRxcLedlFTAY1Gn3wW0lJ
         RrCdZ9MGI0363f3ZXfGmIySWcmL/luNBHMskMRlfsSQbeGkMaQKSKNuzKpVCv4pWGvdL
         3EmA==
X-Gm-Message-State: AOAM533ASVjDIHte4DcLxBEabyPNAdIZy5IfV876REJkVvyREeUHsOTY
        r1xrZRNxkc1MxHE2/yn1/hU=
X-Google-Smtp-Source: ABdhPJzcdix3lRR0Kktkx1Zs3ckJKhTJQ7ihPiBpRGRCUZ0IJ9cfFMfNUY8y1JqyFoZ8Po6HMTxO/A==
X-Received: by 2002:a17:90b:2056:: with SMTP id ji22mr7866018pjb.61.1596005850156;
        Tue, 28 Jul 2020 23:57:30 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 127sm1207202pgf.5.2020.07.28.23.57.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 23:57:29 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 3/5] MIPS: KVM: Add kvm guest support for Loongson-3
Date:   Wed, 29 Jul 2020 14:58:37 +0800
Message-Id: <1596005919-29365-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 KVM guest is based on virtio, it use liointc as its interrupt
controller and use GPEX as the pci controller.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/Kconfig                                  |   1 +
 arch/mips/boot/dts/loongson/Makefile               |   1 +
 .../boot/dts/loongson/loongson64v_4core_virtio.dts | 102 +++++++++++++++++++++
 arch/mips/include/asm/mach-loongson64/boot_param.h |   4 +-
 .../include/asm/mach-loongson64/builtin_dtbs.h     |   1 +
 arch/mips/loongson64/env.c                         |  15 ++-
 arch/mips/loongson64/init.c                        |   5 +
 7 files changed, 126 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/boot/dts/loongson/loongson64v_4core_virtio.dts

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f6bb446..499a20d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -478,6 +478,7 @@ config MACH_LOONGSON64
 	select COMMON_CLK
 	select USE_OF
 	select BUILTIN_DTB
+	select PCI_HOST_GENERIC
 	help
 	  This enables the support of Loongson-2/3 family of machines.
 
diff --git a/arch/mips/boot/dts/loongson/Makefile b/arch/mips/boot/dts/loongson/Makefile
index ae1c8bf..8fd0efb 100644
--- a/arch/mips/boot/dts/loongson/Makefile
+++ b/arch/mips/boot/dts/loongson/Makefile
@@ -3,5 +3,6 @@ dtb-$(CONFIG_MACH_LOONGSON64)	+= loongson64c_4core_ls7a.dtb
 dtb-$(CONFIG_MACH_LOONGSON64)	+= loongson64c_4core_rs780e.dtb
 dtb-$(CONFIG_MACH_LOONGSON64)	+= loongson64c_8core_rs780e.dtb
 dtb-$(CONFIG_MACH_LOONGSON64)	+= loongson64g_4core_ls7a.dtb
+dtb-$(CONFIG_MACH_LOONGSON64)	+= loongson64v_4core_virtio.dtb
 
 obj-$(CONFIG_BUILTIN_DTB)	+= $(addsuffix .o, $(dtb-y))
diff --git a/arch/mips/boot/dts/loongson/loongson64v_4core_virtio.dts b/arch/mips/boot/dts/loongson/loongson64v_4core_virtio.dts
new file mode 100644
index 00000000..41f0b11
--- /dev/null
+++ b/arch/mips/boot/dts/loongson/loongson64v_4core_virtio.dts
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/dts-v1/;
+/ {
+	compatible = "loongson,loongson64v-4core-virtio";
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	cpuintc: interrupt-controller {
+		#address-cells = <0>;
+		#interrupt-cells = <1>;
+		interrupt-controller;
+		compatible = "mti,cpu-interrupt-controller";
+	};
+
+	package0: bus@1fe00000 {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0x1fe00000 0 0x1fe00000 0x100000
+			0 0x3ff00000 0 0x3ff00000 0x100000
+			0xefd 0xfb000000 0xefd 0xfb000000 0x10000000>;
+
+		liointc: interrupt-controller@3ff01400 {
+			compatible = "loongson,liointc-1.0";
+			reg = <0 0x3ff01400 0x64>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+
+			interrupt-parent = <&cpuintc>;
+			interrupts = <2>, <3>;
+			interrupt-names = "int0", "int1";
+
+			loongson,parent_int_map = <0x00000001>, /* int0 */
+						<0xfffffffe>, /* int1 */
+						<0x00000000>, /* int2 */
+						<0x00000000>; /* int3 */
+
+		};
+
+		cpu_uart0: serial@1fe001e0 {
+			compatible = "ns16550a";
+			reg = <0 0x1fe001e0 0x8>;
+			clock-frequency = <33000000>;
+			interrupt-parent = <&liointc>;
+			interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
+			no-loopback-test;
+		};
+	};
+
+	bus@10000000 {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0 0x10000000 0 0x10000000 0 0x10000000 /* PIO & CONF & APB */
+				0 0x40000000 0 0x40000000 0 0x40000000>; /* PCI MEM */
+
+		rtc0: rtc@10081000 {
+			compatible = "google,goldfish-rtc";
+			reg = <0 0x10081000 0 0x1000>;
+			interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-parent = <&liointc>;
+		};
+
+		pci@1a000000 {
+			compatible = "pci-host-ecam-generic";
+			device_type = "pci";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			#interrupt-cells = <1>;
+
+			bus-range = <0x0 0x1f>;
+			reg = <0 0x1a000000 0 0x02000000>;
+
+			ranges = <0x01000000 0x0 0x00004000 0x0 0x18004000 0x0 0x0000c000>,
+				 <0x02000000 0x0 0x40000000 0x0 0x40000000 0x0 0x40000000>;
+
+			interrupt-map = <
+				0x0000 0x0 0x0  0x1  &liointc  0x2 IRQ_TYPE_LEVEL_HIGH
+				0x0800 0x0 0x0  0x1  &liointc  0x3 IRQ_TYPE_LEVEL_HIGH
+				0x1000 0x0 0x0  0x1  &liointc  0x4 IRQ_TYPE_LEVEL_HIGH
+				0x1800 0x0 0x0  0x1  &liointc  0x5 IRQ_TYPE_LEVEL_HIGH
+				>;
+
+			interrupt-map-mask = <0x1800 0x0 0x0  0x7>;
+		};
+
+		isa {
+			compatible = "isa";
+			#address-cells = <2>;
+			#size-cells = <1>;
+			ranges = <1 0 0 0x18000000 0x4000>;
+		};
+	};
+
+	hypervisor {
+		compatible = "linux,kvm";
+	};
+};
diff --git a/arch/mips/include/asm/mach-loongson64/boot_param.h b/arch/mips/include/asm/mach-loongson64/boot_param.h
index b35be70..afc92b7 100644
--- a/arch/mips/include/asm/mach-loongson64/boot_param.h
+++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
@@ -194,7 +194,8 @@ struct boot_params {
 
 enum loongson_bridge_type {
 	LS7A = 1,
-	RS780E = 2
+	RS780E = 2,
+	VIRTUAL = 3
 };
 
 struct loongson_system_configuration {
@@ -230,5 +231,6 @@ extern struct loongson_system_configuration loongson_sysconf;
 extern u32 node_id_offset;
 extern void ls7a_early_config(void);
 extern void rs780e_early_config(void);
+extern void virtual_early_config(void);
 
 #endif
diff --git a/arch/mips/include/asm/mach-loongson64/builtin_dtbs.h b/arch/mips/include/asm/mach-loongson64/builtin_dtbs.h
index 6d2f141..839410c 100644
--- a/arch/mips/include/asm/mach-loongson64/builtin_dtbs.h
+++ b/arch/mips/include/asm/mach-loongson64/builtin_dtbs.h
@@ -12,4 +12,5 @@ extern u32 __dtb_loongson64c_4core_ls7a_begin[];
 extern u32 __dtb_loongson64c_4core_rs780e_begin[];
 extern u32 __dtb_loongson64c_8core_rs780e_begin[];
 extern u32 __dtb_loongson64g_4core_ls7a_begin[];
+extern u32 __dtb_loongson64v_4core_virtio_begin[];
 #endif
diff --git a/arch/mips/loongson64/env.c b/arch/mips/loongson64/env.c
index 2cb9573..99bc199 100644
--- a/arch/mips/loongson64/env.c
+++ b/arch/mips/loongson64/env.c
@@ -167,14 +167,25 @@ void __init prom_init_env(void)
 	vendor = id & 0xffff;
 	device = (id >> 16) & 0xffff;
 
-	if (vendor == PCI_VENDOR_ID_LOONGSON && device == 0x7a00) {
+	switch (vendor) {
+	case PCI_VENDOR_ID_LOONGSON:
 		pr_info("The bridge chip is LS7A\n");
 		loongson_sysconf.bridgetype = LS7A;
 		loongson_sysconf.early_config = ls7a_early_config;
-	} else {
+		break;
+	case PCI_VENDOR_ID_AMD:
+	case PCI_VENDOR_ID_ATI:
 		pr_info("The bridge chip is RS780E or SR5690\n");
 		loongson_sysconf.bridgetype = RS780E;
 		loongson_sysconf.early_config = rs780e_early_config;
+		break;
+	case PCI_VENDOR_ID_REDHAT:
+	default:
+		pr_info("The bridge chip is VIRTUAL\n");
+		loongson_sysconf.bridgetype = VIRTUAL;
+		loongson_sysconf.early_config = virtual_early_config;
+		loongson_fdt_blob = __dtb_loongson64v_4core_virtio_begin;
+		break;
 	}
 
 	if ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64C) {
diff --git a/arch/mips/loongson64/init.c b/arch/mips/loongson64/init.c
index 8ba22c30..ed75f79 100644
--- a/arch/mips/loongson64/init.c
+++ b/arch/mips/loongson64/init.c
@@ -42,6 +42,11 @@ void rs780e_early_config(void)
 	node_id_offset = 37;
 }
 
+void virtual_early_config(void)
+{
+	node_id_offset = 44;
+}
+
 void __init prom_init(void)
 {
 	fw_init_cmdline();
-- 
2.7.0

