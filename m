Return-Path: <kvm+bounces-21045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C34092866D
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 12:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F10F1C24628
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 10:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800621474AF;
	Fri,  5 Jul 2024 10:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdDZ5HD0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761B14659F
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 10:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720174154; cv=none; b=jN/hR1mjEDTmiWEn66DnkY1hW/kNUY5NkcWbufj3J9x9Fwyba9fTlhEe9qMF2A+x3SfBhvXS8zRuAGa8PpDjyerqgYKu8NwklJ/2CbD55oXCXzFX1HrjiI3Vdj2QECuBlYfcztgrd2NA8UnTq8YpkfH/eZGaDjg/XLEjHlN+EOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720174154; c=relaxed/simple;
	bh=hTt1vb2rlKzdwlZrBwUZKYn386WW4/puEcuG/xh7pBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUA0hSDNgTgkV8pGhZMwASjQjL758l5/Xtepsc811jw1s/D0S70vSkmyTi1OyKVUvfZ4JXo27Sf9428lr0uGxdZpNIqQHQNEwc8jc/Dk9jqLNiEdrqCCgNNMWTxFNuEtPZbpTfLLKvUrdn9FUIL0bAb/mSF7kDveeYr1T8xD+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdDZ5HD0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720174152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Odn3kI68k2nJO/AKzhT19WX3OnWz2Ozg0VobWfUmy3A=;
	b=BdDZ5HD0iyApu7/ZuXewiaa6jDPczxjRgUAba/STsMigGySzcIc3ZrxA5GDOz84DlB6ss3
	CRI72Kbdw34pa7Fpf2IhD0EDg6I0f6jS7cNdD0GnjC60HxZubzjbPLXA9x8ft1rTb6+wqx
	JZ6WCPFP4t2O/4qyA+TmCPcALAp5E3g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-C6Smu5sXN4-vF1PTS8pZYQ-1; Fri, 05 Jul 2024 06:09:11 -0400
X-MC-Unique: C6Smu5sXN4-vF1PTS8pZYQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4256667ebf9so11371125e9.1
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2024 03:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720174150; x=1720778950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Odn3kI68k2nJO/AKzhT19WX3OnWz2Ozg0VobWfUmy3A=;
        b=CLpZ3IdUSQH65P+fiDbQhXDhhBN+lDv4SLbzf/wgvJA0Hloxs/hdhZdmxr9hGdtsND
         cvqYSvJE+SZRbdZOf8y3tDj0Sekl8+JMdlRAzTX9JO0isEg1iXyR0ExebKxkgn1ZTCoM
         +2I0+KE39bruyYzMZHii2kqf12ZmpHdHJKu7NOlz56XSfVDrBWi9KbIqgUzZ6hcIeZVY
         QZp1r3tc6g0VcVrsI9bBoYAwsK+zOaQXN+TvVzpuFKy5Byac9tfGN7iYOEsnW6kr7VTx
         RG4yo+6vH56IGvta2YoT5sdK4RnkAJfV9WXF13rkn6P7OXzzMg9mc2twFyMR5vuiB0NS
         3nkw==
X-Forwarded-Encrypted: i=1; AJvYcCXvi8xyhzsEv3jAPNYk1Gzaf8yry0pT/Dohmnuc+bpUqBSOAOszFbb5eZnONF83uTda5khkB9NXDLIVSFGeHBqoOPZ9
X-Gm-Message-State: AOJu0YzrBnr60gbhTQY1VBSwDLMGGKA6O0coq/2OOZApjTdeVlkl1Ph0
	csVXXGsR6vfwMqn22KVQXxXxK7npNojm9NnHg2JJaG6hWeMATjLiAfErDm8so30Lpd5O2Ce/IID
	OGh5JlrW4tymMB2Gdi4JBNeZhSNO5eI691gOc8w69pJtTpt9L3A==
X-Received: by 2002:a05:6000:18d1:b0:366:f001:78d5 with SMTP id ffacd0b85a97d-3679dd15831mr2701328f8f.13.1720174149721;
        Fri, 05 Jul 2024 03:09:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4wwtYRyztkbCukZKtbADwQgiOS0R3XAJxhjPsgDTBQMKf8FQrtcOZyu+TAhVhA0306KQefg==
X-Received: by 2002:a05:6000:18d1:b0:366:f001:78d5 with SMTP id ffacd0b85a97d-3679dd15831mr2701283f8f.13.1720174149018;
        Fri, 05 Jul 2024 03:09:09 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f0:a185:2de6:83fc:7632:9788])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3678eb6593bsm7742101f8f.93.2024.07.05.03.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 03:09:08 -0700 (PDT)
Date: Fri, 5 Jul 2024 06:09:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 2/2] virtio: fix vq # when vq skipped
Message-ID: <1a5d7456542bcd1df8e397c93c48deacd244add5.1720173841.git.mst@redhat.com>
References: <cover.1720173841.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1720173841.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

virtio balloon communicates to the core that in some
configurations vq #s are non-contiguous by setting name
pointer to NULL.

Unfortunately, core then turned around and just made them
contiguous again. Result is that driver is out of spec.

Implement what the API was supposed to do
in the 1st place. Compatibility with buggy hypervisors
is handled inside virtio-balloon, which is the only driver
making use of this facility, so far.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/um/drivers/virtio_uml.c           | 4 ++--
 drivers/remoteproc/remoteproc_virtio.c | 4 ++--
 drivers/s390/virtio/virtio_ccw.c       | 4 ++--
 drivers/virtio/virtio_mmio.c           | 4 ++--
 drivers/virtio/virtio_pci_common.c     | 8 ++++----
 drivers/virtio/virtio_vdpa.c           | 4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 77faa2cf3a13..d65346cd340e 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1019,7 +1019,7 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct irq_affinity *desc)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
-	int i, queue_idx = 0, rc;
+	int i, rc;
 	struct virtqueue *vq;
 
 	/* not supported for now */
@@ -1036,7 +1036,7 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			continue;
 		}
 
-		vqs[i] = vu_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
+		vqs[i] = vu_setup_vq(vdev, i, callbacks[i], names[i],
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			rc = PTR_ERR(vqs[i]);
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 25b66b113b69..2d17135abb66 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -187,7 +187,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 				 const bool * ctx,
 				 struct irq_affinity *desc)
 {
-	int i, ret, queue_idx = 0;
+	int i, ret;
 
 	for (i = 0; i < nvqs; ++i) {
 		if (!names[i]) {
@@ -195,7 +195,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			continue;
 		}
 
-		vqs[i] = rp_find_vq(vdev, queue_idx++, callbacks[i], names[i],
+		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i],
 				    ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			ret = PTR_ERR(vqs[i]);
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d6491fc84e8c..64541b3bb8a2 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -696,7 +696,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	dma64_t *indicatorp = NULL;
-	int ret, i, queue_idx = 0;
+	int ret, i;
 	struct ccw1 *ccw;
 	dma32_t indicatorp_dma = 0;
 
@@ -710,7 +710,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			continue;
 		}
 
-		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
+		vqs[i] = virtio_ccw_setup_vq(vdev, i, callbacks[i],
 					     names[i], ctx ? ctx[i] : false,
 					     ccw);
 		if (IS_ERR(vqs[i])) {
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 173596589c71..a3a66a0b7cb1 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -496,7 +496,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	int irq = platform_get_irq(vm_dev->pdev, 0);
-	int i, err, queue_idx = 0;
+	int i, err;
 
 	if (irq < 0)
 		return irq;
@@ -515,7 +515,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			continue;
 		}
 
-		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
+		vqs[i] = vm_setup_vq(vdev, i, callbacks[i], names[i],
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			vm_del_vqs(vdev);
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index f6b0b00e4599..eeff060cacec 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -292,7 +292,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	u16 msix_vec;
-	int i, err, nvectors, allocated_vectors, queue_idx = 0;
+	int i, err, nvectors, allocated_vectors;
 
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
@@ -328,7 +328,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 			msix_vec = allocated_vectors++;
 		else
 			msix_vec = VP_MSIX_VQ_VECTOR;
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
+		vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
 				     ctx ? ctx[i] : false,
 				     msix_vec);
 		if (IS_ERR(vqs[i])) {
@@ -365,7 +365,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 		const char * const names[], const bool *ctx)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	int i, err, queue_idx = 0;
+	int i, err;
 
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
@@ -383,7 +383,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 			vqs[i] = NULL;
 			continue;
 		}
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
+		vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
 				     ctx ? ctx[i] : false,
 				     VIRTIO_MSI_NO_VECTOR);
 		if (IS_ERR(vqs[i])) {
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e803db0da307..fe91a5d673dc 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -370,7 +370,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	struct cpumask *masks;
 	struct vdpa_callback cb;
 	bool has_affinity = desc && ops->set_vq_affinity;
-	int i, err, queue_idx = 0;
+	int i, err;
 
 	if (has_affinity) {
 		masks = create_affinity_masks(nvqs, desc ? desc : &default_affd);
@@ -384,7 +384,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			continue;
 		}
 
-		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
+		vqs[i] = virtio_vdpa_setup_vq(vdev, i,
 					      callbacks[i], names[i], ctx ?
 					      ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
-- 
MST


