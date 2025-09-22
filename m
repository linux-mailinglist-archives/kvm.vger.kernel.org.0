Return-Path: <kvm+bounces-58404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC50B9295F
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84AE01901048
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DCF318152;
	Mon, 22 Sep 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="AkC/2sIR"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51341221540
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565312; cv=none; b=kDVhb3JUhk/yEdyHfqY6T4IArEFJ2iJlyUQ/T+R+HVSy6MkGOhAX/0/4t5eiYCd/x25IhvDOzjJv98PY8O7NHetc6qihTnK4G3DZV3FdslYwqzSGv+iL5bagVh72xCJVTJ8jTFZsr8Vl+7CPAiTWS05TD6NNYB+72VtrO7w/ZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565312; c=relaxed/simple;
	bh=bQHE7hwxobR5lgWZf9BtGfZmK2ruyQhk81gHgsvQ2x0=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=P6dXrt8TYiaDXV0J2cmCw6KwJooeCZHJ66GR1gWw8FzcqrTmEvpOxFqaj8rOdvE0Fs8xwySZfCYFjVxbInjyKpZcJB+oQ5yuTidOa36JL3qYprRhuCS9TR8Wjj/+78VjwLFuzOQvfI7Ryn6aqoExsRKbOgYt/hWb7EP6h/vXllU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=AkC/2sIR; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 6C146828522F;
	Mon, 22 Sep 2025 13:21:49 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Tx7DX3xOYmPd; Mon, 22 Sep 2025 13:21:48 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id A9263828523D;
	Mon, 22 Sep 2025 13:21:48 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com A9263828523D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758565308; bh=OtvfmlA5uXTpAMNS6sVHVXDNai3k4a81Zcx6I+PbYlM=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=AkC/2sIRvMnnBGmg0lrtqXj9w0MQRwRrFWyZSbWEFQCDirjcl2eZd3sP1LmJPZRe3
	 MO8Qx9PkNc7RatLoHks9qjMqrhZNIpyPx6I3/5Dy0tSfGQ1khZ1556Ilq4aVWKZe9q
	 UxBz/YSniDODyPMU+br5LskfKw6gbt7kjYu3ng+w=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ALm6YS_aQ25a; Mon, 22 Sep 2025 13:21:48 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 7A041828522F;
	Mon, 22 Sep 2025 13:21:48 -0500 (CDT)
Date: Mon, 22 Sep 2025 13:21:45 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: kvm <kvm@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Message-ID: <1293210747.1743219.1758565305521.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v3] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC139 (Linux)/8.5.0_GA_3042)
Thread-Index: AYYHtS+hzYi6d9o76X6FCAgSNGZOEA==
Thread-Topic: vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices

PCI devices prior to PCI 2.3 both use level interrupts and do not support
interrupt masking, leading to a failure when passed through to a KVM guest on
at least the ppc64 platform. This failure manifests as receiving and
acknowledging a single interrupt in the guest, while the device continues to
assert the level interrupt indicating a need for further servicing.

When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
sequence occurs:

 * Level IRQ assertion on device
 * IRQ marked disabled in kernel
 * Host interrupt handler exits without clearing the interrupt on the device
 * Eventfd is delivered to userspace
 * Guest processes IRQ and clears device interrupt
 * Device de-asserts INTx, then re-asserts INTx while the interrupt is masked
 * Newly asserted interrupt acknowledged by kernel VMM without being handled
 * Software mask removed by VFIO driver
 * Device INTx still asserted, host controller does not see new edge after EOI

The behavior is now platform-dependent.  Some platforms (amd64) will continue
to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
only send the one request, and if it is not handled no further interrupts will
be sent.  The former behavior theoretically leaves the system vulnerable to
interrupt storm, and the latter will result in the device stalling after
receiving exactly one interrupt in the guest.

Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
---
 drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..61d29f6b3730 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
+	if (!vdev->pci_2_3)
+		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, ctx);
 	if (ret) {
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		vdev->irq_type = VFIO_PCI_NUM_IRQS;
 		kfree(name);
 		vfio_irq_ctx_free(vdev, ctx, 0);
@@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		free_irq(pdev->irq, ctx);
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		if (ctx->trigger)
 			eventfd_ctx_put(ctx->trigger);
 		kfree(ctx->name);
-- 
2.39.5

