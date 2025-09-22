Return-Path: <kvm+bounces-58396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CFF5B92637
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 19:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32E361905CEC
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 17:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4630313D68;
	Mon, 22 Sep 2025 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="d6kWCsn9"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE1F2EA72C
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758561524; cv=none; b=oOsZzZEnoU5DS9qYO5MeJK/HXSTCKT1XiQQ9O/Rckbf/4cerspjAeohqfYRZ1pR0Wlo2+ufz9dxwPdMV1AQLve+uSyhtDJJyLKK59lcbOskQ0W0n0k3p28vQ85aVU0nwJ8+cYHHazFGLZ4zetcAHEQ5GzyF9ry1gAc3OVDEfvN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758561524; c=relaxed/simple;
	bh=/KA5wjjPEbwAlYcxeV+rWZ/WlfXL1429JYd959EXH9s=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=ICEKzgO3EQh2S1AOj3aQNNbbjmud6sAul1szq4jYZPvjb997smImxhJd0t9kIoW4X0KLlnHNZLY3p9LF4FdRJpJTzolT25zomKDgcTBZAUdzXwIAHxFk6GAK8qhW2qBf+ygUuvCQOa8E6fpaPdChxcY0Lx8l07h0AFUJjmLJ1Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=d6kWCsn9; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id D284C82877C8;
	Mon, 22 Sep 2025 12:18:40 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id H1vkj8gCDAoU; Mon, 22 Sep 2025 12:18:38 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 368648287877;
	Mon, 22 Sep 2025 12:18:38 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 368648287877
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758561518; bh=etKuEBh9PTwlPDUpZ/Kmvx/1sfJtHGqZ+HNXo8z9Z1w=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=d6kWCsn9jHa7gm1K5at7x1QwTLP3+rwvxP12nUz95sZL327Iq01NGVA0dLMt/Cv1J
	 S0wQUwvZcvLJUoyRE3d0ezVY0tGMpWxEe4EPCq30b5z2DEPNHm+pIx2Y3/Ebawwh3l
	 yQvs6bWvBRSj4TzeX+GN4InNyJWXNa+NXaQ1FSm8=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gHE7IdQJ-tQD; Mon, 22 Sep 2025 12:18:38 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 0442782877C8;
	Mon, 22 Sep 2025 12:18:37 -0500 (CDT)
Date: Mon, 22 Sep 2025 12:18:34 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: kvm <kvm@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Message-ID: <912864077.1743059.1758561514856.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v2] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
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
Thread-Index: c8lDpJ7aN2oHNLjLTs3DAIyu1mwHfA==
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
 * Host interrupt controller sees still-active INTX, reasserts IRQ
 * Host kernel ignores disabled IRQ
 * Guest processes IRQ and clears device interrupt
 * Software mask removed by VFIO driver

The behavior is now platform-dependent.  Some platforms (amd64) will continue
to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
only send the one request, and if it is not handled no further interrupts will
be sent.  The former behavior theoretically leaves the system vulnerable to
interrupt storm, and the latter will result in the device stalling after
receiving exactly one interrupt in the guest.

Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
---
 drivers/vfio/pci/vfio_pci_intrs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..d8637b53d051 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -304,6 +304,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
+	if (!vdev->pci_2_3)
+		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, ctx);
 	if (ret) {
@@ -352,6 +355,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
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

