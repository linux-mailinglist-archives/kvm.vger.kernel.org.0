Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201981D2BB8
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 11:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgENJqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 05:46:00 -0400
Received: from foss.arm.com ([217.140.110.172]:33318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgENJqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 05:46:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A886431B;
        Thu, 14 May 2020 02:45:59 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACFCA3F305;
        Thu, 14 May 2020 02:45:58 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool] rtc: Generate fdt node for the real-time clock
Date:   Thu, 14 May 2020 10:45:53 +0100
Message-Id: <20200514094553.135663-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On arm and arm64 we expose the Motorola RTC emulation to the guest,
but never advertised this in the device tree.

EDK-2 seems to rely on this device, but on its hardcoded address. To
make this more future-proof, add a DT node with the address in it.
EDK-2 can then read the proper address from there, and we can change
this address later (with the flexible memory layout).

Please note that an arm64 Linux kernel is not ready to use this device,
there are some include files missing under arch/arm64 to compile the
driver. I hacked this up in the kernel, just to verify this DT snippet
is correct, but don't see much value in enabling this properly in
Linux.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/rtc.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index c1fa72f2..5483879f 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -130,24 +130,56 @@ static struct ioport_operations cmos_ram_index_ioport_ops = {
 	.io_out		= cmos_ram_index_out,
 };
 
+#ifdef CONFIG_HAS_LIBFDT
+static void generate_rtc_fdt_node(void *fdt,
+				  struct device_header *dev_hdr,
+				  void (*generate_irq_prop)(void *fdt,
+							    u8 irq,
+							    enum irq_type))
+{
+	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
+
+	_FDT(fdt_begin_node(fdt, "rtc"));
+	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
+	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+#else
+#define generate_rtc_fdt_node NULL
+#endif
+
+struct device_header rtc_dev_hdr = {
+	.bus_type = DEVICE_BUS_IOPORT,
+	.data = generate_rtc_fdt_node,
+};
+
 int rtc__init(struct kvm *kvm)
 {
-	int r = 0;
+	int r;
+
+	r = device__register(&rtc_dev_hdr);
+	if (r < 0)
+		return r;
 
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
 	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
 	if (r < 0)
-		return r;
+		goto out_device;
 
 	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
-	if (r < 0) {
-		ioport__unregister(kvm, 0x0071);
-		return r;
-	}
+	if (r < 0)
+		goto out_ioport;
 
 	/* Set the VRT bit in Register D to indicate valid RAM and time */
 	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
 
+	return r;
+
+out_ioport:
+	ioport__unregister(kvm, 0x0070);
+out_device:
+	device__unregister(&rtc_dev_hdr);
+
 	return r;
 }
 dev_init(rtc__init);
-- 
2.17.1

