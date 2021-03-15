Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487EC33BFF4
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhCOPe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:34:59 -0400
Received: from foss.arm.com ([217.140.110.172]:50734 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhCOPe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 11:34:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C27E6106F;
        Mon, 15 Mar 2021 08:34:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B6A23F792;
        Mon, 15 Mar 2021 08:34:25 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v3 10/22] hw/rtc: Refactor trap handlers
Date:   Mon, 15 Mar 2021 15:33:38 +0000
Message-Id: <20210315153350.19988-11-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide emulation functions compatible with the MMIO prototype.

Merge the two different trap handlers into one function, checking for
read/write and data/index register inside.
Adjust the trap handlers to use that new function, and provide shims to
implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/rtc.c | 70 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index 5483879f..664d4cb0 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -42,11 +42,37 @@ static inline unsigned char bin2bcd(unsigned val)
 	return ((val / 10) << 4) + val % 10;
 }
 
-static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+			u32 len, u8 is_write, void *ptr)
 {
 	struct tm *tm;
 	time_t ti;
 
+	if (is_write) {
+		if (addr == 0x70) {	/* index register */
+			u8 value = ioport__read8(data);
+
+			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
+			rtc.cmos_idx		= value & ~(1UL << 7);
+
+			return;
+		}
+
+		switch (rtc.cmos_idx) {
+		case RTC_REG_C:
+		case RTC_REG_D:
+			/* Read-only */
+			break;
+		default:
+			rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
+			break;
+		}
+		return;
+	}
+
+	if (addr == 0x70)
+		return;
+
 	time(&ti);
 
 	tm = gmtime(&ti);
@@ -92,42 +118,23 @@ static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 po
 		ioport__write8(data, rtc.cmos_data[rtc.cmos_idx]);
 		break;
 	}
-
-	return true;
 }
 
-static bool cmos_ram_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool cmos_ram_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
-	switch (rtc.cmos_idx) {
-	case RTC_REG_C:
-	case RTC_REG_D:
-		/* Read-only */
-		break;
-	default:
-		rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
-		break;
-	}
-
+	cmos_ram_io(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
-static struct ioport_operations cmos_ram_data_ioport_ops = {
-	.io_out		= cmos_ram_data_out,
-	.io_in		= cmos_ram_data_in,
-};
-
-static bool cmos_ram_index_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool cmos_ram_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
-	u8 value = ioport__read8(data);
-
-	vcpu->kvm->nmi_disabled	= value & (1UL << 7);
-	rtc.cmos_idx		= value & ~(1UL << 7);
-
+	cmos_ram_io(vcpu, port, data, size, true, NULL);
 	return true;
 }
 
-static struct ioport_operations cmos_ram_index_ioport_ops = {
-	.io_out		= cmos_ram_index_out,
+static struct ioport_operations cmos_ram_ioport_ops = {
+	.io_out		= cmos_ram_out,
+	.io_in		= cmos_ram_in,
 };
 
 #ifdef CONFIG_HAS_LIBFDT
@@ -162,21 +169,15 @@ int rtc__init(struct kvm *kvm)
 		return r;
 
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
+	r = ioport__register(kvm, 0x0070, &cmos_ram_ioport_ops, 2, NULL);
 	if (r < 0)
 		goto out_device;
 
-	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
-	if (r < 0)
-		goto out_ioport;
-
 	/* Set the VRT bit in Register D to indicate valid RAM and time */
 	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
 
 	return r;
 
-out_ioport:
-	ioport__unregister(kvm, 0x0070);
 out_device:
 	device__unregister(&rtc_dev_hdr);
 
@@ -188,7 +189,6 @@ int rtc__exit(struct kvm *kvm)
 {
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
 	ioport__unregister(kvm, 0x0070);
-	ioport__unregister(kvm, 0x0071);
 
 	return 0;
 }
-- 
2.17.5

