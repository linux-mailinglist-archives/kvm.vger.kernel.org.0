Return-Path: <kvm+bounces-58584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6312BB96E73
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F0C17C087
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F0325EFBC;
	Tue, 23 Sep 2025 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="u6BocjFx"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698FB2236E8
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647086; cv=none; b=FbsbbwtpOd1gidkAZhANru0zWHaTDCgEJghQCgug++FAhnfref2+0l1+xmTU5BEazgKxyA/MGFY9JAqmgh5t4ad8rhcBjKrIxUHEUUHetEGh3m6rbw0EBi8sQ/iM9BDIe1F2qwRMXFH7NRjvm3T8mUqkDazt+0kOic+dYxaLcEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647086; c=relaxed/simple;
	bh=/xUhxJYBgqN7CnmtMqjsQwmZu6+nxbPQJGFksvLTRPc=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=gik83/Q/hIPurD4uP+OVlG5pKeHcZh3itdGQrhbALbhTzrFNpUfTGXJZY1PBO/ZxeyXfUIXKk4M00roSpUd+iW6ygjCNDAGiFw6zfoLylO20n9slvzJRZ5X4Yj7kpWgzsAwwHTMIqTWMzaCmXucUtjrIWPQDsEtIjQ9AZe4D0kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=u6BocjFx; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 9D65B82889AD;
	Tue, 23 Sep 2025 12:04:34 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id cbeJ3-IlNVw4; Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id A87378288A28;
	Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com A87378288A28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758647073; bh=XsHXAr26uFmYtgxTEGLWtr8ER0vhVE7qa73NnCyYLIA=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=u6BocjFxh6gHY9s10Dy0DmzkDWpBeJjKC3jyk4QcUHfqN+1N0wG7RLxCvnH6NQ7IW
	 10aOmBhx+OXRyEkPiEwv2wvWS7UP59Z+tMzHTg1lXO11bTYqPuR0Bzb4jb5J98uO6D
	 jwOrI3PwXmUvaBIPi2fb7/vm3QxS2JYJNG75T70w=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kG_iOPuhvPfI; Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 77FEF82889AD;
	Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
Date: Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: kvm <kvm@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Alex Williamson <alex.williamson@redhat.com>, 
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Message-ID: <333803015.1744464.1758647073336.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v4] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC140 (Linux)/8.5.0_GA_3042)
Thread-Index: W8Zeg2QdRz9DmmY8boDuhMyhWXGeBA==
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

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
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

