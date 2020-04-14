Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4F1A7FFF
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391118AbgDNOkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:53 -0400
Received: from foss.arm.com ([217.140.110.172]:57202 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391072AbgDNOkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C22D139F;
        Tue, 14 Apr 2020 07:40:16 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 246893F73D;
        Tue, 14 Apr 2020 07:40:15 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 16/18] hw/vesa: Don't ignore fatal errors
Date:   Tue, 14 Apr 2020 15:39:44 +0100
Message-Id: <20200414143946.1521-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Failling an mmap call or creating a memslot means that device emulation
will not work, don't ignore it.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index 5646a5af9672..ad09373ea2ff 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -63,22 +63,25 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
 		return NULL;
-	r = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
+	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
+	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
 	if (r < 0)
-		return ERR_PTR(r);
+		goto out_error;
 
-	vesa_base_addr			= (u16)r;
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
 	r = device__register(&vesa_device);
 	if (r < 0)
-		return ERR_PTR(r);
+		goto unregister_ioport;
 
 	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
-	if (mem == MAP_FAILED)
-		return ERR_PTR(-errno);
+	if (mem == MAP_FAILED) {
+		r = -errno;
+		goto unregister_device;
+	}
 
-	kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	if (r < 0)
+		goto unmap_dev;
 
 	vesafb = (struct framebuffer) {
 		.width			= VESA_WIDTH,
@@ -90,4 +93,13 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		.kvm			= kvm,
 	};
 	return fb__register(&vesafb);
+
+unmap_dev:
+	munmap(mem, VESA_MEM_SIZE);
+unregister_device:
+	device__unregister(&vesa_device);
+unregister_ioport:
+	ioport__unregister(kvm, vesa_base_addr);
+out_error:
+	return ERR_PTR(r);
 }
-- 
2.20.1

