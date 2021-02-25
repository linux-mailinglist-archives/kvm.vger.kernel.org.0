Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2276632483A
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhBYBCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:02:55 -0500
Received: from foss.arm.com ([217.140.110.172]:58516 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234943AbhBYBCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4489F1435;
        Wed, 24 Feb 2021 17:00:43 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEA643F73B;
        Wed, 24 Feb 2021 17:00:41 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 11/22] hw/rtc: Switch to new trap handler
Date:   Thu, 25 Feb 2021 00:59:04 +0000
Message-Id: <20210225005915.26423-12-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the RTC device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
2.17.5

