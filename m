Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2D2D65FF
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393252AbgLJTIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:08:19 -0500
Received: from foss.arm.com ([217.140.110.172]:45086 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389170AbgLJObA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8675F1500;
        Thu, 10 Dec 2020 06:29:36 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C49E3F718;
        Thu, 10 Dec 2020 06:29:35 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 11/21] hw/rtc: Switch to new trap handler
Date:   Thu, 10 Dec 2020 14:28:58 +0000
Message-Id: <20201210142908.169597-12-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the RTC device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/rtc.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index 664d4cb0..ee4c9102 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -120,23 +120,6 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	}
 }
 
-static bool cmos_ram_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	cmos_ram_io(vcpu, port, data, size, false, NULL);
-	return true;
-}
-
-static bool cmos_ram_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	cmos_ram_io(vcpu, port, data, size, true, NULL);
-	return true;
-}
-
-static struct ioport_operations cmos_ram_ioport_ops = {
-	.io_out		= cmos_ram_out,
-	.io_in		= cmos_ram_in,
-};
-
 #ifdef CONFIG_HAS_LIBFDT
 static void generate_rtc_fdt_node(void *fdt,
 				  struct device_header *dev_hdr,
@@ -169,7 +152,7 @@ int rtc__init(struct kvm *kvm)
 		return r;
 
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	r = ioport__register(kvm, 0x0070, &cmos_ram_ioport_ops, 2, NULL);
+	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
 	if (r < 0)
 		goto out_device;
 
@@ -188,7 +171,7 @@ dev_init(rtc__init);
 int rtc__exit(struct kvm *kvm)
 {
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	ioport__unregister(kvm, 0x0070);
+	kvm__deregister_pio(kvm, 0x0070);
 
 	return 0;
 }
-- 
2.17.1

