Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E448194316
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgCZPZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:25 -0400
Received: from foss.arm.com ([217.140.110.172]:33898 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgCZPZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA9EC1045;
        Thu, 26 Mar 2020 08:25:23 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E3F623F71E;
        Thu, 26 Mar 2020 08:25:22 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 26/32] vesa: Create device exactly once
Date:   Thu, 26 Mar 2020 15:24:32 +0000
Message-Id: <20200326152438.6218-27-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A vesa device is used by the SDL, GTK or VNC framebuffers. Don't allow the
user to specify more than one of these options because kvmtool will create
identical devices and bad things will happen:

$ ./lkvm run -c2 -m2048 -k bzImage --sdl --gtk
  # lkvm run -k bzImage -m 2048 -c 2 --name guest-10159
  Error: device region [d0000000-d012bfff] would overlap device region [d0000000-d012bfff]
*** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
*** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
*** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
======= Backtrace: =========
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x777e5)[0x7fae0ed447e5]
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6/lib/x86_64-linux-gnu/libc.so.6(+0x8037a)[0x7fae0ed4d37a]
(+0x777e5)[0x7fae0ed447e5]
/lib/x86_64-linux-gnu/libc.so.6(+0x777e5)[0x7fae0ed447e5]
/lib/x86_64-linux-gnu/libc.so.6(+0x8037a)[0x7fae0ed4d37a]
/lib/x86_64-linux-gnu/libc.so.6(cfree+0x4c)[0x7fae0ed5153c]
*** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
/lib/x86_64-linux-gnu/libglib-2.0.so.0(g_string_free+0x3b)[0x7fae0f814dab]
/lib/x86_64-linux-gnu/libglib-2.0.so.0(g_string_free+0x3b)[0x7fae0f814dab]
/usr/lib/x86_64-linux-gnu/libgtk-3.so.0(+0x21121c)[0x7fae1023321c]
/usr/lib/x86_64-linux-gnu/libgtk-3.so.0(+0x21121c)[0x7fae1023321c]
======= Backtrace: =========
Aborted (core dumped)

The vesa device is explicitly created during the initialization phase of
the above framebuffers. Remove the superfluous check for their existence.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index dd59a112330b..8071ad153f27 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -61,8 +61,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
 	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
 
-	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
-		return NULL;
+	if (device__find_dev(vesa_device.bus_type, vesa_device.dev_num) == &vesa_device) {
+		r = -EEXIST;
+		goto out_error;
+	}
+
 	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
 	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
 	if (r < 0)
-- 
2.20.1

