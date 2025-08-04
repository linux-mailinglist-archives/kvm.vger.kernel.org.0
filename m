Return-Path: <kvm+bounces-53896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C55B19FD7
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 368C416E5E6
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885412512F1;
	Mon,  4 Aug 2025 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="CDnPjKjT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AC222D7B6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304109; cv=none; b=aU9fm08UxA9hdTf3TJaZL1bfEII33t45hbZibibRg/IT0alJ8phAfDQkGlJ4hZ9KuzsMNzQFlwOiJDd8JzsWRnVo1pFnoOAQpoLoWQu6SgLczfdAZ9EgnNdGuEaY6Zn+ra+jIAAQZV7zqO4Fr1Y9FzyQ2qqRmYyiy8A9bDm6Eao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304109; c=relaxed/simple;
	bh=OTSq35PjiQw2OyLcDh+OS6liYtdfb9luQ+G67yiyxS4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azUZ1BSyEXg9+/N+ep/H16w6Xiplc97bYAkc+7sS2Kj0Eq6MPpxi9ZAbxoNPX/donm8N54ayW7EE1grSh52wQG5naR0ov4zUtj5QaiFLRD/URN8SIhGB47OG9dbLnoJ14IxZt26DEh3EbrpgktQYIGkg5bli0RG2+IZxi8zkSok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=CDnPjKjT; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304108; x=1785840108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zSlaqFQ21REFQd4lOPjVCm40OUlTwrBSlIhnp0zqptc=;
  b=CDnPjKjTm7gq8TSSmGx2ZPVyn/hl8YNjh4RxW/+ftT7adqBnps7Mh7Vq
   r+0A+OMpk6BhMxhJflH9cTukHpiJttIek/jDIwGGoWxUYVoSm76Jvz/t3
   RoLDyIzzBUP9l+a1HIfxPjbrDFXi/oEaQRqtoVDJfPVwyhV0ocIMHNr8Q
   v/2u/2CForjIRARqhE5eDva9X1fGyO6LVCBEjnxQe/P2ffpwPhW1XfsG7
   nkR+2jvHz5+6yAxw+6yfGAZXFSBvN3vSGeMmxT6E+ZW0ZZ74QljSIvBfH
   GPp9W9QU2Xf/gjdHqCco0Pkxvyk2HqmTPp9iNr26FN8oVSzX65bOrSuZj
   g==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="767495606"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:41:45 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:58310]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.131:2525] with esmtp (Farcaster)
 id 41fd1612-19f6-47dc-876e-3ddfc4c972ec; Mon, 4 Aug 2025 10:41:44 +0000 (UTC)
X-Farcaster-Flow-ID: 41fd1612-19f6-47dc-876e-3ddfc4c972ec
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:41:43 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:41:41 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 2/9] vfio: add transient ops to support vfio mmap mt
Date: Mon, 4 Aug 2025 12:39:55 +0200
Message-ID: <20250804104012.87915-3-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

add a new transient operations for ioctl & mmap that allows using the
new mmap maple tree, since these operations are used extensively, it's
better to transition into new temporary ops, then after onboarding all
the users to the new ops we will drop the old legacy ops proto and
replace it with the new ones. Having new ops allows us to enforce the
vmmap existence check when mmap ops is called, and make the migration
more stable, and reviewable.

ioctl needs to have access over the whole mt to add/query entries when
needed, this allows inserting new range in the mt for example when
DEVICE_GET_REGION_INFO is called by the user, this also enabled us to
add other uapi to change mmap attrs in a certain range. When mmapping
there must be a vmmap entry for that offset otherwise return -EINVAL.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
This names is only used for the migration period that was I used 2 as a suffix,
maybe _vmmap could also be used or similar.

 drivers/vfio/vfio_main.c | 12 ++++++++++++
 include/linux/vfio.h     |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4c4af4de60d12..3275ff56eef47 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1324,6 +1324,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 		break;
 
 	default:
+		if (device->ops->ioctl2) {
+			ret = device->ops->ioctl2(device, cmd, arg, &df->mmap_mt);
+			break;
+		}
 		if (unlikely(!device->ops->ioctl))
 			ret = -EINVAL;
 		else
@@ -1372,11 +1376,19 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	struct vfio_mmap *vmmap;
 
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
 
+	if (device->ops->mmap2) {
+		vmmap = mtree_load(&df->mmap_mt, (vma->vm_pgoff << PAGE_SHIFT));
+		if (!vmmap)
+			return -EINVAL;
+		return device->ops->mmap2(device, vma, vmmap);
+	}
+
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 6e0aca05aa406..836ef72a38104 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -142,7 +142,11 @@ struct vfio_device_ops {
 			 size_t count, loff_t *size);
 	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 			 unsigned long arg);
+	long	(*ioctl2)(struct vfio_device *vdev, unsigned int cmd,
+			 unsigned long arg, struct maple_tree *mmap_mt);
 	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
+	int	(*mmap2)(struct vfio_device *vdev, struct vm_area_struct *vma,
+			 struct vfio_mmap *vmmap);
 	void	(*request)(struct vfio_device *vdev, unsigned int count);
 	int	(*match)(struct vfio_device *vdev, char *buf);
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


