Return-Path: <kvm+bounces-70106-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IvIABhzgmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70106-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:13:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B31FDF223
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5D88630493B3
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260D1387593;
	Tue,  3 Feb 2026 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aXQlxC9U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9E3859FF
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156613; cv=none; b=lrb2esHxprugudH4cVydzu0vTygrShVz0lE9mX93kdyxRaxaEocnJ1qNjfZmvfcJ98YNbJRJ7zuArOkg3cExajMfmXp/36YOGS4pmcmGCsVoAeLdJwimOlhbB68IYs8ROzfOUxW8BvI5HBkbBOGa38nacWdUak4p2LzsYJrBQ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156613; c=relaxed/simple;
	bh=OvnjKmtuP+/pnyWLrwtRVT2pKYDknDMFSdYGBTZusD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IMsL+aMdMBWxW0gg2U5yd75ZQfgvm/uQl6GaZNNLeGDCCAyYJfgNHORUgJgxh3lFmhzNU1fSFKiQEkxB/JF7LQr+NVobhyTftH/eVQ04pKuV5Blli+6qoMKDeD0Ck51Kv4rJXwsFpp4l0WIakfw6sx+BzcdpnKK8o12XV8BNTh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aXQlxC9U; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-823486f311bso3165805b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156611; x=1770761411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/8ncc0FKC3TXUBMo9gNfkA/biCGmORiTT+jCw4LASx4=;
        b=aXQlxC9UVztklrIzfWpZev/rwSmUKlvraxtoY5lfgHt/QeO1hxJl+lnQRKrGJcKEGL
         Gk1/ca2Q7pf5Q11WoTGLYViBevkmo6aW454pmyCDGCaW8we/f6UxzbSKSCHQ4GaSH6gZ
         8qizJ79pp2lbnZzUsa4iBg5NyymBPMFZRM6YEjtTKfGLAplSnTQ2Hxp9JSW4B5hmS/Yc
         eyXqvfyBpDiA4MooFTFuulxWEs0Vjykgjs/Cz7vD2ZNcu9pcJLn5vJCXtpcMMw1Eupr3
         6B+alAOc5TAMWNwkkM9i99hbhVOJqWtP2+yKa+t7APffXiWcSRl7x1UN783xBBduPAQw
         kncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156611; x=1770761411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/8ncc0FKC3TXUBMo9gNfkA/biCGmORiTT+jCw4LASx4=;
        b=O8u6apjno2h+swmdrts54lttIIalLANY+p2Gd53a6yBfj1v/LuIaOvwm3n7p0mRu/Z
         sqccTvRgZOSEXD6ZUL1+7F12qH4/c+A3tSk0DChxzV90Rx1UIu58W2yMeFVIfj1EVEbW
         k1+0SNGG7JGKUJPoZ9N/Bs6b/gXuZbK+iCm1GObLmxV0pyB/ijieloKPfCnt8/QL5J2y
         FvXMvlNkX/8exunpS0cXIer/hj8TyHQQcgy/8WPd6APWT/3gwTwWRtd6S3nu8o/ZyZdE
         g23BHdDGcz1gQadR5QLDpVvG/X6xj++vBlZYzMnFZil7dW9IHGObHgkm9Kr6Evq/398p
         evJg==
X-Forwarded-Encrypted: i=1; AJvYcCUdPmc/rENpc5CBRHnd3vmtlVSXfz9CvW39OP/9Fn3kEpFw7nnUJLM/Bg2N/syEkwDwwJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOoWI4E14Pw5UcXqrdLdwbJV8xCcZe/PoehtiML2CwyUl5YtOo
	VcDowL8f/sXVtBQTL9Tv2N41BE86umY3rlz05BvPE4FRIpLT/JS9rE5cEa+oh0Q6vqkFq04EbA2
	j5gKsx44V5o/sOQ==
X-Received: from pfblr43.prod.google.com ([2002:a05:6a00:73ab:b0:7dd:8bba:6394])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e8f:b0:821:81ef:5de8 with SMTP id d2e1a72fcca58-8241c1ab516mr847226b3a.12.1770156610959;
 Tue, 03 Feb 2026 14:10:10 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:47 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-14-skhawaja@google.com>
Subject: [PATCH 13/14] vfio/pci: Preserve the iommufd state of the vfio cdev
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70106-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B31FDF223
X-Rspamd-Action: no action

If the vfio cdev is attached to an iommufd, preserve the state of the
attached iommufd also. Basically preserve the iommu state of the device
and also the attached domain. The token returned by the preservation API
will be used to restore/rebind to the iommufd state after liveupdate.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 28 +++++++++++++++++++++++++-
 include/linux/kho/abi/vfio_pci.h       | 10 +++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index c52d6bdb455f..af6fbfb7a65c 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -15,6 +15,7 @@
 #include <linux/liveupdate.h>
 #include <linux/errno.h>
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio_pci_priv.h"
 
@@ -39,6 +40,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 	struct vfio_pci_core_device_ser *ser;
 	struct vfio_pci_core_device *vdev;
 	struct pci_dev *pdev;
+	u64 token = 0;
 
 	vdev = container_of(device, struct vfio_pci_core_device, vdev);
 	pdev = vdev->pdev;
@@ -49,15 +51,32 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 	if (vfio_pci_is_intel_display(pdev))
 		return -EINVAL;
 
+#if CONFIG_IOMMU_LIVEUPDATE
+	/* If iommufd is attached, preserve the underlying domain */
+	if (device->iommufd_attached) {
+		int err = iommufd_device_preserve(args->session,
+						  device->iommufd_device,
+						  &token);
+		if (err < 0)
+			return err;
+	}
+#endif
+
 	ser = kho_alloc_preserve(sizeof(*ser));
-	if (IS_ERR(ser))
+	if (IS_ERR(ser)) {
+		if (device->iommufd_attached)
+			iommufd_device_unpreserve(args->session,
+						  device->iommufd_device, token);
+
 		return PTR_ERR(ser);
+	}
 
 	pci_liveupdate_outgoing_preserve(pdev);
 
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
 	ser->reset_works = vdev->reset_works;
+	ser->iommufd_ser.token = token;
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
@@ -66,6 +85,13 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
 	struct vfio_device *device = vfio_device_from_file(args->file);
+	struct vfio_pci_core_device_ser *ser;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (device->iommufd_attached)
+		iommufd_device_unpreserve(args->session,
+					  device->iommufd_device,
+					  ser->iommufd_ser.token);
 
 	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
 	kho_unpreserve_free(phys_to_virt(args->serialized_data));
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index 6c3d3c6dfc09..d01bd58711c2 100644
--- a/include/linux/kho/abi/vfio_pci.h
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -28,6 +28,15 @@
 
 #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
 
+/**
+ * struct vfio_iommufd_ser - Serialized state of the attached iommufd.
+ *
+ * @token: The token of the bound iommufd state.
+ */
+struct vfio_iommufd_ser {
+	u32 token;
+} __packed;
+
 /**
  * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
  * device.
@@ -40,6 +49,7 @@ struct vfio_pci_core_device_ser {
 	u16 bdf;
 	u16 domain;
 	u8 reset_works;
+	struct vfio_iommufd_ser iommufd_ser;
 } __packed;
 
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
-- 
2.53.0.rc2.204.g2597b5adb4-goog


