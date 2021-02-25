Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23234324849
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhBYBEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:04:33 -0500
Received: from foss.arm.com ([217.140.110.172]:58554 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236715AbhBYBCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DF771515;
        Wed, 24 Feb 2021 17:01:00 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02F613F73B;
        Wed, 24 Feb 2021 17:00:58 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 22/22] hw/rtc: ARM/arm64: Use MMIO at higher addresses
Date:   Thu, 25 Feb 2021 00:59:15 +0000
Message-Id: <20210225005915.26423-23-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the RTC device at its legacy I/O address as set by IBM in 1981
was a kludge we used for simplicity on ARM platforms as well.
However this imposes problems due to their missing alignment and overlap
with the PCI I/O address space.

Now that we can switch a device easily between using ioports and
MMIO, let's move the RTC out of the first 4K of memory on ARM platforms.

That should be transparent for well behaved guests, since the change is
naturally reflected in the device tree.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/include/arm-common/kvm-arch.h |  3 +++
 hw/rtc.c                          | 24 ++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 633ea8fa..02100c48 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -31,6 +31,9 @@
 #define ARM_UART_MMIO_BASE	ARM_MMIO_AREA
 #define ARM_UART_MMIO_SIZE	0x10000
 
+#define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
+#define ARM_RTC_MMIO_SIZE	0x10000
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/hw/rtc.c b/hw/rtc.c
index ee4c9102..aec31c52 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -5,6 +5,15 @@
 
 #include <time.h>
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
+#define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
+#else
+/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
+#define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
+#define RTC_BASE_ADDRESS	0x70
+#endif
+
 /*
  * MC146818 RTC registers
  */
@@ -49,7 +58,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	time_t ti;
 
 	if (is_write) {
-		if (addr == 0x70) {	/* index register */
+		if (addr == RTC_BASE_ADDRESS) {	/* index register */
 			u8 value = ioport__read8(data);
 
 			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
@@ -70,7 +79,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 		return;
 	}
 
-	if (addr == 0x70)
+	if (addr == RTC_BASE_ADDRESS)	/* index register is write-only */
 		return;
 
 	time(&ti);
@@ -127,7 +136,7 @@ static void generate_rtc_fdt_node(void *fdt,
 							    u8 irq,
 							    enum irq_type))
 {
-	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
+	u64 reg_prop[2] = { cpu_to_fdt64(RTC_BASE_ADDRESS), cpu_to_fdt64(2) };
 
 	_FDT(fdt_begin_node(fdt, "rtc"));
 	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
@@ -139,7 +148,7 @@ static void generate_rtc_fdt_node(void *fdt,
 #endif
 
 struct device_header rtc_dev_hdr = {
-	.bus_type = DEVICE_BUS_IOPORT,
+	.bus_type = RTC_BUS_TYPE,
 	.data = generate_rtc_fdt_node,
 };
 
@@ -151,8 +160,8 @@ int rtc__init(struct kvm *kvm)
 	if (r < 0)
 		return r;
 
-	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
+	r = kvm__register_iotrap(kvm, RTC_BASE_ADDRESS, 2, cmos_ram_io, NULL,
+				 RTC_BUS_TYPE);
 	if (r < 0)
 		goto out_device;
 
@@ -170,8 +179,7 @@ dev_init(rtc__init);
 
 int rtc__exit(struct kvm *kvm)
 {
-	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	kvm__deregister_pio(kvm, 0x0070);
+	kvm__deregister_iotrap(kvm, RTC_BASE_ADDRESS, RTC_BUS_TYPE);
 
 	return 0;
 }
-- 
2.17.5

