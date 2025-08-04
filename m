Return-Path: <kvm+bounces-53903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7724BB19FE4
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23FCB3A4A90
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF1124E01F;
	Mon,  4 Aug 2025 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="qHeQy6I8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522772459F3
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304259; cv=none; b=Uwpz5sgSINxMfzhJ9Z5ZXo6NWh0v1UIFQWLkPNKRu3KsDavZPRwaBitj3HEVfDRfpSylneb/TJZByDuLOf85r1gv713poHsVAT9BUaAY9RfgLzEUyI1rZcHXf3o/GYGN772R7zhkQQhSBL2yvs+HSbqSuY5kjTtpoF3T6UuxLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304259; c=relaxed/simple;
	bh=XL2OzAUSiRg6FmItAk8sxfdewYguUJnsCytNhQg7G+w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGgSmF+EF516ryfkIvi0RgapioLZVpty7sEZ8saju7Z1kfQLJDt8gQ4pg5LjKe/qaF8ethQwaxpmMgqsicdaw4SHXKfCL7BHp06IB+zZwcs9oBIfZ9xH4ydQG+CMa2SXn5/zmQS7DRdpZcTNPpmUs+DDHirISVRg4BlKUncs+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=qHeQy6I8; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304258; x=1785840258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6KwBQWO++tSTpV02Z3Wu139rT7Jb8IMEQWE42uHmrEo=;
  b=qHeQy6I8sPKmA8yWYp+UqwLYZeTPuZO5WvjeAGuS1Vd6zc/R/IEZCsRw
   XaEbn1OUIOWcezrSWJM64i0GysJdz14ODTHkB411J6a9dB6v7DNVXQ77h
   cmtfDudRZFoMNuSP4pa/MdTHzEK31dWH9H02/DwMrdXpLRyjowIfXxLNC
   giVwzT+Vs1b4ilhSAc0P1d9wjFwdWJlWD6rZvfDNzcr7O6S8W6OKI+nCC
   XaW0PHTA5YgFhx3/bkLvn7ErrDFqvuGPHX+nyLDbZLk/FBpbo1vUwQEj4
   NPQHOA7SAeHSzHk51DawUY9/4pfveAEU2v3HplCnigrSao/TEsDsKyY8k
   Q==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="219092720"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:44:16 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:22375]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.6.192:2525] with esmtp (Farcaster)
 id c89a471a-a336-4aa9-88a1-2de383a10166; Mon, 4 Aug 2025 10:44:14 +0000 (UTC)
X-Farcaster-Flow-ID: c89a471a-a336-4aa9-88a1-2de383a10166
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:44:14 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:44:11 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 9/9] vfio_pci_core: support mmap attrs uapi & WC
Date: Mon, 4 Aug 2025 12:40:02 +0200
Message-ID: <20250804104012.87915-10-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now we established the required dependencies to support WC through the
new vmmap in vfio_pci, this implements the new uapi & checks if the WC
attr is set while mmaping, then calls pgprot_writecombine.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 8418d98ac66ce..461440700af75 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1198,6 +1198,30 @@ static int vfio_pci_ioctl_get_region_info2(struct vfio_pci_core_device *vdev,
 	return _vfio_pci_ioctl_get_region_info(vdev, mmap_mt, arg);
 }
 
+static int vfio_pci_ioctl_set_mmap_attrs(struct vfio_pci_core_device *vdev,
+					 struct maple_tree *mmap_mt,
+					 struct vfio_irq_info __user *arg)
+{
+	struct vfio_mmap_attrs vmmap_attrs;
+	struct vfio_pci_mmap *vmmap;
+
+	if (copy_from_user(&vmmap_attrs, arg, sizeof(vmmap_attrs)))
+		return -EFAULT;
+
+	if (vmmap_attrs.attrs & ~VFIO_MMAP_ATTR_WRITE_COMBINE)
+		return -EINVAL;
+
+	vmmap = mtree_load(mmap_mt, vmmap_attrs.offset);
+	if (!vmmap)
+		return -EINVAL;
+
+	if (!(vmmap->core.region_flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	vmmap->core.attrs = vmmap_attrs.attrs;
+	return 0;
+}
+
 static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 				       struct vfio_irq_info __user *arg)
 {
@@ -1549,6 +1573,8 @@ long vfio_pci_core_ioctl2(struct vfio_device *core_vdev, unsigned int cmd,
 	switch (cmd) {
 	case VFIO_DEVICE_GET_REGION_INFO:
 		return vfio_pci_ioctl_get_region_info2(vdev, mmap_mt, uarg);
+	case VFIO_DEVICE_SET_MMAP_ATTRS:
+		return vfio_pci_ioctl_set_mmap_attrs(vdev, mmap_mt, uarg);
 	default:
 		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 	}
@@ -1855,7 +1881,10 @@ static int _vfio_pci_core_mmap(struct vfio_device *core_vdev,
 	}
 
 	vma->vm_private_data = vdev;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (vmmap && vmmap->core.attrs & VFIO_MMAP_ATTR_WRITE_COMBINE)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	/*
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


