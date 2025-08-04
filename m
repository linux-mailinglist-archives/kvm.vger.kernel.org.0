Return-Path: <kvm+bounces-53898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA3BB19FDA
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45F0218988B2
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A03724CEEA;
	Mon,  4 Aug 2025 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="FTn+jjL5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0F2494FF
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304155; cv=none; b=ozDV5OudgFZNbf9hnpIkyhU3uVsRQoI3Ht9zm25lGcMoSYRAWgjWsbZvvJkBw04tGJUOKDVRbMExxDu0sgPRbNb8oSYQU6HIhZnJRBFZXPwuJkaRtm3kpvPc/ow6IhPl+bB+ldAv6kZsEHL3iCLEf+Tn/o0dYsDchM8KSHk72Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304155; c=relaxed/simple;
	bh=VulvDmwrDA22km2VsZ8Ytv4utsSK79Kfl8hiW0DB0VU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdm5KidMVGf4+Muw5whiLl3poHGXE8VBUmSpG9K/UdZV+a2CM8pyR8cmXI6+dRW11dCnhfdvQhKd1QUpj6UtsTMLk1eUiA09xxe9US710SkH5pFfoiXr8f/yfVBqoa7dHqf9O7WPWBeDJvcbP9pCU/h8pFvJHsiRBKnJ5l+PnyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=FTn+jjL5; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304154; x=1785840154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIm0CFfNto0RblCpatIlKqB03qMjxLChdjkjgVFxIXA=;
  b=FTn+jjL5UUrbh88CwEaekATzV3ROG9Tluf9b8mEonzxUU+mzNZRc4pr+
   b5meVtGTpXeRQjLeXWI+xabRpsRuzeU18nCOL3CneD/3SdlWn6cS4ygqb
   5wyk2auDSxjIc44Cyn8C2f/fORkxY7ktPGTeU40t+C5rwYl7qzg4B231W
   lBBAeAlL8djiQ/GGdGE97N0JRriH9e2aa9iK/UxxBtQi8A0hFD40S4TWN
   g7MeVFUCnPEKgjVLWfcx1IoFxaUl/FScHNMaZO9/dzA36Bhvc7IqblMRh
   M1BoCYrwaj7xrdVgFqcTIRv0B2p9jA1NDfDADFNXJrgH8DatnVYgPop8O
   w==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="542599970"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:42:29 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:4401]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.131:2525] with esmtp (Farcaster)
 id 382842d4-a2d1-4674-952e-f314fb1bb15c; Mon, 4 Aug 2025 10:42:27 +0000 (UTC)
X-Farcaster-Flow-ID: 382842d4-a2d1-4674-952e-f314fb1bb15c
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:42:27 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:42:24 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 4/9] vfio-pci-core: remove redundant offset calculations
Date: Mon, 4 Aug 2025 12:39:57 +0200
Message-ID: <20250804104012.87915-5-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

all switch cases are calculating the offset similarly, and they are
not used until the end of the function, just calculate the offset once
at the end, which makes it simpler to change the offset in one spot in
the following patch.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9a22969607bfe..467466a0b619f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1014,13 +1014,11 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 
 	switch (info.index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.size = pdev->cfg_size;
 		info.flags = VFIO_REGION_INFO_FLAG_READ |
 			     VFIO_REGION_INFO_FLAG_WRITE;
 		break;
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.size = pci_resource_len(pdev, info.index);
 		if (!info.size) {
 			info.flags = 0;
@@ -1044,7 +1042,6 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 		size_t size;
 		u16 cmd;
 
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.flags = 0;
 		info.size = 0;
 
@@ -1074,7 +1071,6 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 		if (!vdev->has_vga)
 			return -EINVAL;
 
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.size = 0xc0000;
 		info.flags = VFIO_REGION_INFO_FLAG_READ |
 			     VFIO_REGION_INFO_FLAG_WRITE;
@@ -1093,7 +1089,6 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 
 		i = info.index - VFIO_PCI_NUM_REGIONS;
 
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.size = vdev->region[i].size;
 		info.flags = vdev->region[i].flags;
 
@@ -1131,6 +1126,7 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 		kfree(caps.buf);
 	}
 
+	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


