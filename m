Return-Path: <kvm+bounces-57143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C72B5076F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B7ED1C659C2
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF6F342C93;
	Tue,  9 Sep 2025 20:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="vHUt4pHm"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670A23597A
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757450933; cv=none; b=CTR5ZxVyokPv693Npp5RTKTKUR89ulHTfKbXUi4lIBVMA5in0FXlss1se/2vBLnkGVc6jx+Ct7vltGaJShFQ9UEvwGRqFctcGVsqvT9hIQoGYY2kLkPGieJuScSOR9u2rWwY2oKp6c2HXAOWfOww1vuC2CPGv5dDGvKjxjUOFvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757450933; c=relaxed/simple;
	bh=g6R1h/BhvYe2WmruXaj8MDnedgDzaue30m/ddAAmfFs=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=EQM0nW8Yh9lWzzV80pe4Hf99CDm3balIdKeDj0NROXVDAJfEam3IWOQy8gSM0Yr8NPmYC2+cro1g2FkKEh+HcWiv6uHxxPjEcLeeFFaN4uF4qISFhLzAwFXvC4oi5amsLyeN9YBKB31D6hjhNTGNR2ggswVBj/sllrO5uKgXENo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=vHUt4pHm; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 12F378287DA8;
	Tue,  9 Sep 2025 15:48:48 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id jAc376xn005e; Tue,  9 Sep 2025 15:48:47 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 5FBE58287DE2;
	Tue,  9 Sep 2025 15:48:47 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 5FBE58287DE2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1757450927; bh=aHB5DXkErjn2E5tn1hQOECXYgRXXDEcJQb4TCKOHPKY=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=vHUt4pHmyzEeERDA/vZRWNpHMRm9WD2860IVhEZ1SwCwQoRoc8v2xAmlDSGd2tuoY
	 +7X70xJ8D2ffJcyZTx4KJwZKLX7SqxF4bKgmpAscvqeWEs3kSDPrTYdPDiRSDhGZGr
	 ptSnybrUVuF+n2MmY3kszhjw4D80HIYK4AGOYMs4=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cD_RFPt7wzuY; Tue,  9 Sep 2025 15:48:47 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 263888287DA8;
	Tue,  9 Sep 2025 15:48:47 -0500 (CDT)
Date: Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: kvm <kvm@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC139 (Linux)/8.5.0_GA_3042)
Thread-Index: R10GhsXRj6kdi6znKwcsfy1REC69Aw==
Thread-Topic: vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices

PCI devices prior to PCI 2.3 both use level interrupts and do not support
interrupt masking, leading to a failure when passed through to a KVM guest on
at least the ppc64 platform, which does not utilize the resample IRQFD. This
failure manifests as receiving and acknowledging a single interrupt in the guest
while leaving the host physical device VFIO IRQ pending.

Level interrupts in general require special handling due to their inherently
asynchronous nature; both the host and guest interrupt controller need to
remain in synchronization in order to coordinate mask and unmask operations.
When lazy IRQ masking is used on DisINTx- hardware, the following sequence
occurs:

 * Level IRQ assertion on host
 * IRQ trigger within host interrupt controller, routed to VFIO driver
 * Host EOI with hardware level IRQ still asserted
 * Software mask of interrupt source by VFIO driver
 * Generation of event and IRQ trigger in KVM guest interrupt controller
 * Level IRQ deassertion on host
 * Guest EOI
 * Guest IRQ level deassertion
 * Removal of software mask by VFIO driver

Note that no actual state change occurs within the host interrupt controller,
unlike what would happen with either DisINTx+ hardware or message interrupts.
The host EOI is not fired with the hardware level IRQ deasserted, and the
level interrupt is not re-armed within the host interrupt controller, leading
to an unrecoverable stall of the device.

Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.

---
 drivers/vfio/pci/vfio_pci_intrs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..011169ca7a34 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -304,6 +304,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
+	if (is_intx(vdev) && !vdev->pci_2_3)
+		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, ctx);
 	if (ret) {
@@ -351,6 +354,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	if (ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		free_irq(pdev->irq, ctx);
 		if (ctx->trigger)
 			eventfd_ctx_put(ctx->trigger);
-- 
2.39.5

