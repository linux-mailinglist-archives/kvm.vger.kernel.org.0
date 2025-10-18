Return-Path: <kvm+bounces-60416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 76489BEC1AC
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 64C4F4E39CE
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A641D5147;
	Sat, 18 Oct 2025 00:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4hHZszIy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D968A19D07A
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746057; cv=none; b=JUuVbd+r6Cd+6HFWEDfDPcfzALMv7JFhEhUT6aAcuJPhKIYylWNuznYwot558fp9+x6rTz2hKZoZNn5uaXsjx4kfNn940A5W2PSLLMcRekJryy7OHFl1MyLFlappnTOP/WYWihYCF7gCvOjN46AJ3e7M2uJC95oT9KaqwLK/opI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746057; c=relaxed/simple;
	bh=9kz7IeKfS4YgzfgKMPszd7/uCUEYDB0UKs2xeqOId+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezlXHwalf+Mrck+Ja35TxScZOUMnZYuvP31HPvKtsd5+MpkFyWVOCTnG+EDkwge+b2u7yEdU17AvbAw4fjCnEgj14dsg1RlwezzKodM91yPdvF2eeUy3+VH8jHkDpm5M6vPtiDus8Td/3lGUoJmQhDiHdRVwpm7xNmQtHR/GVt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4hHZszIy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc49so3923137a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746055; x=1761350855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FsS9kFTR9UD975XBprEHxRtCq2p91h3XBSwxLrbiSS8=;
        b=4hHZszIyICDX684inLL4qqhvefcGlVk81E1+bYgkII9xXJlx6fhPBFAoLa6RUzSi7c
         Ab0GOmYq84zm/RF74ssl/qJDKT8khHszASsgn964lqaFdlvy3gMv3Gi6CsTQGbEOHW3O
         IT1AbJ5bq5yyZTOK+1fkGbo5OVHqnKMFhLsHtsmBebIt++z6l+b0QwZPLl/8zWj88LP3
         EIAfqoLHzv5GXxSnyxkYQXJ6olw2VmeU4oK34kuzHwY4IStATJThFlbxo98wMiudSJGG
         FupCI+JjwG7kghVmKWndEn2lbGaEFhyeMOwo10Rh4k+pVuhU5afh0M6oyQgzy2IHvzSi
         0hrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746055; x=1761350855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FsS9kFTR9UD975XBprEHxRtCq2p91h3XBSwxLrbiSS8=;
        b=sZO+PmepCZu/GZsIWf4bFoa4d14uVpOlD3eGC9L/L+NQrcsFBMY+1dQuYTwzxICazO
         zXvn2ojCY5zoLC3tp7PbFEFPrPha1VZcrswV1I6BqkXqEkQoDzi4Lykh+UQ8qDJKF0BY
         Ch+Y1rA90T19PdsBj7sLVGdfXj5DhCwXkLIysyis4IOnsaNcaX7ctANEk6pkRODVllnQ
         mXR/5AWVqbTz6tWEqFDycpBmB2Go6XoiOVWr7D40KRo2urjZEoK/82XjYQMTapFWWOvc
         /nC6CRmvTbELbd1dsU2X7N19TaDK//hlnB7pm3SeYrTCYXQ2Pu/tskNYaEM2obkuDdyv
         N6jw==
X-Forwarded-Encrypted: i=1; AJvYcCXWv7NeuNQL0uJAxDGQKQcj9gD4EbdBt5/CDLy6CFCSt7fLWjQ+FcRnh7a10m/boXneN0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt8ePtb16HZTUuE1tRz9UbWffKigRfty920Xw2e0L9KsAVubY5
	EkTfwJK9gop1flqsTBpTfcvs8cwW3t56FM20kjya36MMvLZRIVdRVUvHgBmClm5TFoZwJeVGhl6
	ZYVUUK5NYGw==
X-Google-Smtp-Source: AGHT+IGRIAXsRYc0Ud2iJi9huekvodTNwMahs7Yf+RSITKDZqjl7U0MJ3wXRjz337obRdzxOo9SfX8Vmvxkg
X-Received: from pjbml19.prod.google.com ([2002:a17:90b:3613:b0:33b:ba58:40a6])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d406:b0:32d:e027:9b26
 with SMTP id 98e67ed59e1d1-33bc9d1a8e6mr7604436a91.13.1760746055286; Fri, 17
 Oct 2025 17:07:35 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:06:59 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-8-vipinsh@google.com>
Subject: [RFC PATCH 07/21] vfio/pci: Store VFIO PCI device preservation data
 in KHO for live update
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create a struct to serialize VFIO PCI data and preserve it using KHO.
Provide physical address of the folio to Live Update Orchestrator (LUO)
in prepare() callback so that LUO can give it back after kexec.
Unpreserve and free the folio in cancel() callback.

Store PCI BDF value in the serialized data. BDF value is unique for each
device on a host and remains same unless hardware or firmware is
changed.

Preserving BDF value allows VFIO to find the PCI device which LUO wants
to restore in retrieve() callback after kexec. In future patches, more
meaningful data will be serialized to actually preserve working of the
device.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 54 +++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 2ce2c11cb51c..3eb4895ce475 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -10,13 +10,64 @@
 #include <linux/liveupdate.h>
 #include <linux/vfio.h>
 #include <linux/errno.h>
+#include <linux/kexec_handover.h>
 
 #include "vfio_pci_priv.h"
 
+struct vfio_pci_core_device_ser {
+	u16 bdf;
+} __packed;
+
+static int vfio_pci_lu_serialize(struct vfio_pci_core_device *vdev,
+				 struct vfio_pci_core_device_ser *ser)
+{
+	ser->bdf = pci_dev_id(vdev->pdev);
+	return 0;
+}
+
 static int vfio_pci_liveupdate_prepare(struct liveupdate_file_handler *handler,
 				       struct file *file, u64 *data)
 {
-	return -EOPNOTSUPP;
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+	struct folio *folio;
+	int err;
+
+	device = vfio_device_from_file(file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, get_order(sizeof(*ser)));
+	if (!folio)
+		return -ENOMEM;
+
+	ser = folio_address(folio);
+
+	err = vfio_pci_lu_serialize(vdev, ser);
+	if (err)
+		goto err_free_folio;
+
+	err = kho_preserve_folio(folio);
+	if (err)
+		goto err_free_folio;
+
+	*data = virt_to_phys(ser);
+
+	return 0;
+
+err_free_folio:
+	folio_put(folio);
+	return err;
+}
+
+static void vfio_pci_liveupdate_cancel(struct liveupdate_file_handler *handler,
+				       struct file *file, u64 data)
+{
+	struct vfio_pci_core_device_ser *ser = phys_to_virt(data);
+	struct folio *folio = virt_to_folio(ser);
+
+	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	folio_put(folio);
 }
 
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_handler *handler,
@@ -39,6 +90,7 @@ static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *han
 
 static const struct liveupdate_file_ops vfio_pci_luo_fops = {
 	.prepare = vfio_pci_liveupdate_prepare,
+	.cancel = vfio_pci_liveupdate_cancel,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.owner = THIS_MODULE,
-- 
2.51.0.858.gf9c4a03a3a-goog


