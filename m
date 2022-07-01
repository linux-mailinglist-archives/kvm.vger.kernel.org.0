Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA49563597
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiGAOay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiGAO3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:29:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09A4D3EA98
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B82F415A1;
        Fri,  1 Jul 2022 07:25:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1F28B3F792;
        Fri,  1 Jul 2022 07:25:24 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 04/12] virtio/pci: Use the correct eventfd for vhost notification
Date:   Fri,  1 Jul 2022 15:24:26 +0100
Message-Id: <20220701142434.75170-5-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
References: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Legacy virtio drivers write to the I/O port BAR, and the modern virtio
device uses the MMIO BAR. Since vhost can only listen on one ioeventfd,
select the one that the guest will use.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/pci.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index c02534a6..320865c1 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -83,7 +83,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	u16 port_addr = virtio_pci__port_addr(vpci);
 	off_t offset = vpci->doorbell_offset;
 	int r, flags = 0;
-	int fd;
+	int pio_fd, mmio_fd;
 
 	vpci->ioeventfds[vq] = (struct virtio_pci_ioevent_param) {
 		.vdev		= vdev,
@@ -107,7 +107,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	/* ioport */
 	ioevent.io_addr	= port_addr + offset;
 	ioevent.io_len	= sizeof(u16);
-	ioevent.fd	= fd = eventfd(0, 0);
+	ioevent.fd	= pio_fd = eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags | IOEVENTFD_FLAG_PIO);
 	if (r)
 		return r;
@@ -115,13 +115,14 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	/* mmio */
 	ioevent.io_addr	= mmio_addr + offset;
 	ioevent.io_len	= sizeof(u16);
-	ioevent.fd	= eventfd(0, 0);
+	ioevent.fd	= mmio_fd = eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags);
 	if (r)
 		goto free_ioport_evt;
 
 	if (vdev->ops->notify_vq_eventfd)
-		vdev->ops->notify_vq_eventfd(kvm, vpci->dev, vq, fd);
+		vdev->ops->notify_vq_eventfd(kvm, vpci->dev, vq,
+					     vdev->legacy ? pio_fd : mmio_fd);
 	return 0;
 
 free_ioport_evt:
-- 
2.36.1

