Return-Path: <kvm+bounces-58652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD39B9A2FD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 335F61B267D1
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60295306B12;
	Wed, 24 Sep 2025 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="B6Rg2A6z"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE3305949;
	Wed, 24 Sep 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.57.120.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723185; cv=none; b=mxWyjzShg26IvVQCjsCUXU1bCdC2h5S/y4MzNQbjRPCciBPB6WhNyawkCJjyLCEVjcMmn2HW4cccvJKyR0B4hJwmNEn76E3uAYeJHyTXXOdsmupjVkVkG8tfhjsrKKaMyI5+x4UTBUfZGSjfDYyKHphyilVodeK/YgHUnd8WGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723185; c=relaxed/simple;
	bh=ViUO0IxYcuB/eb85CpxW3PyEQgoG9MD6blUfHb2Jm1k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8qSHb9Rsegz8Qg906Mya9NOFlkLxNsPweMP7EGpnCY0wIdilYDqbh9+ACIfRaGp6MmnBNG/1e1BKyQ34P4CBY6nldWSI6/k2ufyMrY0oYq4HXHe02ZfPp4ibNc/zDrbHM4LGVLOPIvxpO5QfO7aTkoB+a1ddLK3hKLAfMU09lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=B6Rg2A6z; arc=none smtp.client-ip=52.57.120.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723182; x=1790259182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=czGB2SwCKNKXAfZ9U9/T0smrUlLXryM3ssqmlBWgsFY=;
  b=B6Rg2A6z+Enaqi4sr2PpwrlPirar1/5uBUAgq7ye0OPnj00/c1tmuB+f
   Ljav9IF8e/0gWPnZzMyUpSYb2V0sxdg30r+X74MBG+Af177SXidvZRDmX
   XhLiUB/o5JRRZAseUaXuI0w0iJ5hDs4DfHyXIQJ8QbnPmfBTUF96/IX0I
   IXJpj6HUfRoOZ2xGQRe1strFsZd3RKWh/FZh/F568Xl9P9TNQM/KM4wJv
   QdZFbfGUhNeTwVe45XxrrHvz0VSi41rUoyZPanPCT2wQW8YWQtYIjlX+3
   tpRVWv/SMtb6K18aRkZY0qN549dsYtJvQCUAk9LZgzFexi7vsh20dA7N5
   A==;
X-CSE-ConnectionGUID: Qlma0UydS9yj/kfl4ty7cg==
X-CSE-MsgGUID: TJKkLL29SRmoHY2VHaAYHg==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2511554"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:13:00 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:15134]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id 9dbd9be8-2ebb-4721-b94d-5e4d39397bed; Wed, 24 Sep 2025 14:13:00 +0000 (UTC)
X-Farcaster-Flow-ID: 9dbd9be8-2ebb-4721-b94d-5e4d39397bed
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:12:58 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:12:54 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 6/7] vfio-pci: add alias_region mmap ops
Date: Wed, 24 Sep 2025 16:09:57 +0200
Message-ID: <20250924141018.80202-7-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Implement struct vfio_pci_regops for alias regions. Where it
implements the mmap ops. When mmap is called on these regions it
translates the vm_pgoff to match the aliased region. Then it calls the
required mmap for the target region. It updates the vm_page_prot
afterwards with the requested flags.

The call path would be:
vfio_pci_core_mmap (index >= VFIO_PCI_NUM_REGIONS)
 vfio_pci_alias_region_mmap (update vm_pgoff)
  vfio_pci_core_mmap

For now no more information is needed more than the aliased index. So
we use region->data to save the aliased index number.

Note: Alias regions can't alias another alias.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 04b93bd55a5c2..962d3eda1ea9f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1528,6 +1528,33 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 	return 0;
 }
 
+static int vfio_pci_alias_region_mmap(struct vfio_pci_core_device *vdev,
+				      struct vfio_pci_region *region,
+				      struct vm_area_struct *vma)
+{
+	unsigned int alias_index = (uintptr_t) region->data;
+	unsigned long vm_pgoff;
+	int ret;
+
+	/* change the pgoff to the corresponding alias */
+	vm_pgoff = alias_index << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	vm_pgoff |= vma->vm_pgoff &
+		    ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	vma->vm_pgoff = vm_pgoff;
+
+	ret = vdev->vdev.ops->mmap(&vdev->vdev, vma);
+
+	/* overwrite prot with the alias flags */
+	if (region->flags & VFIO_REGION_INFO_FLAG_WC)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	return ret;
+}
+
+struct vfio_pci_regops vfio_pci_alias_region_ops = {
+	.mmap = vfio_pci_alias_region_mmap,
+};
+
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


