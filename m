Return-Path: <kvm+bounces-60415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAEABEC1D2
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A49A407DA4
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529E610A1E;
	Sat, 18 Oct 2025 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r/fvEjjf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B45257C9F
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746056; cv=none; b=ekfVF0SfcW5zxgqeNnNrLqEtbLgn3CoSbgab3SV/U6w8e4pJW7ReU9fL+ybAXZRABZPX/jIHBx+D2QMB2K+BAJ3OzEPC2tgHGjwgsix4ZZxPyepWVNk4b9P2HB8YYBEoshpUeDSdShEMQ2blUX7oSPR5Enz4pKgsR3osLDCenWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746056; c=relaxed/simple;
	bh=Vz1emZSFssQs0+YdiAhMnV1XqK+h1rcwL5bhHE+USAs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PDCqObNwC3fqPRok34dhSW78E0HRKLpslHCo6X1V0iw7T6pt9xTlxyt5ZEuznbsrUbHhBQMUrmf0v9BE1p0w/aSs6A1n5udMxjXK7yIyLvJOTJfY4np0esZDcDQpCYklIB3X+WLRaDDj2E/2ABawm7kOlIoy7orgh6hEhkgRM+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r/fvEjjf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28eb14e3cafso45438675ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746054; x=1761350854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yIRcwATFxVO1gYHmeyRDqu9oMXg8jJOvYeDFaGHRVhk=;
        b=r/fvEjjfsCtoWhCTv0je1iCzroYsxTgEp0bbQWgUb3cvfj6N2fEqhdisCsqXP21dFp
         Y8mL0b8cCufcQrlc3Wf9Pqr+T/XoiGCOpo1KJg4gadjISsjD7ry3thvZkpG80lfvhaVB
         X9LPTx8+r+k30DIILkPHKZWm1OCAckqQzShDeeBf6/cA5PXzdPU0Rvjhy4ejIqO7n5BY
         pDf/CsWVZbCB23Jv9eLAU2TR5P91vkoJadEPEkdU3gtM/HvCirB9NFarP68Kka4uDftz
         2wflEk8a3LnC/pGxbSYdx2mMFapkO9pmDGkY6ePm3bCI6+ztH64MieEtTVEEnNjWkXq8
         q/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746054; x=1761350854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIRcwATFxVO1gYHmeyRDqu9oMXg8jJOvYeDFaGHRVhk=;
        b=j5bBXug0bHWl3gKN1pyey+k63iNNx1hugLhv9yO73qWM9XWVgC9SC9c3xxOtag0Q/V
         0GgNbv9E9hVTvqku+KjcTB7qdLoHJubBU9yWCulpNb4nLmEPdX+eF6GnGGU7gwdidyWO
         rT5iT7aBc9vaa1G79ty1VVOlvED8Z/fRrF902gvTVICSl3asaXN1iuvUcklylUeUcXDq
         tuSknLdzcUv5u76m1pkMEAcgPgPEacWsiGXVWqiyRJwIUWwDEzzAkX2DoVi1BZA+8GKO
         MRpEPUqkteGZW9PSc9Cc89fwK9tFT1DL+h5JpNJzghgOYpIxWJWDH+pf69MJfZJ5wsO9
         Fnog==
X-Forwarded-Encrypted: i=1; AJvYcCVMFk8XEv9NjFUGpBOMsW4KkV3ShdePvRfGkQkQ8NLnt4joZuh5GdC4gk+A6wlG2X+GpeY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywa0tdRTcxrLtkPcrsAdpuFlPuOB19bY0J8JR19Bf4V6azUPDx
	rfkIVcMj/vy16IWwLiHRp2USkEG6jKH2x//2iJAGTEflfSNEQ70tOefYLh+iuoZ4Xxn4uN3/K/Q
	PL0qKViKHuw==
X-Google-Smtp-Source: AGHT+IEmJd19+BB5PjOWAQmwa3QYicq41jg2KgMlRdI0Qd+a/0AOATqoFt4XxbQkB/KEUkYDvJMU7BdKVEY5
X-Received: from pllb6.prod.google.com ([2002:a17:902:e946:b0:290:bbbe:b3d4])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1106:b0:27e:f07c:8413
 with SMTP id d9443c01a7336-290c9cf8f3amr67057365ad.9.1760746053570; Fri, 17
 Oct 2025 17:07:33 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:06:58 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-7-vipinsh@google.com>
Subject: [RFC PATCH 06/21] vfio/pci: Accept live update preservation request
 for VFIO cdev
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

Return true in can_preserve() callback of live update file handler, if
VFIO can preserve the passed VFIO cdev file. Return -EOPNOTSUPP from
prepare() callback for now to fail any attempt to preserve VFIO cdev in
live update.

The VFIO cdev opened check ensures that the file is actually used for
VFIO cdev and not for VFIO device FD which can be obtained from the VFIO
group.

Returning true from can_preserve() tells Live Update Orchestrator that
VFIO can try to preserve the given file during live update. Actual
preservation logic will be added in future patches, therefore, for now,
prepare call will fail.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 16 +++++++++++++++-
 drivers/vfio/vfio_main.c               |  3 ++-
 include/linux/vfio.h                   |  2 ++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 088f7698a72c..2ce2c11cb51c 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -8,10 +8,17 @@
  */
 
 #include <linux/liveupdate.h>
+#include <linux/vfio.h>
 #include <linux/errno.h>
 
 #include "vfio_pci_priv.h"
 
+static int vfio_pci_liveupdate_prepare(struct liveupdate_file_handler *handler,
+				       struct file *file, u64 *data)
+{
+	return -EOPNOTSUPP;
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_handler *handler,
 					u64 data, struct file **file)
 {
@@ -21,10 +28,17 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_handler *handler,
 static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
 					     struct file *file)
 {
-	return -EOPNOTSUPP;
+	struct vfio_device *device = vfio_device_from_file(file);
+
+	if (!device)
+		return false;
+
+	guard(mutex)(&device->dev_set->lock);
+	return vfio_device_cdev_opened(device);
 }
 
 static const struct liveupdate_file_ops vfio_pci_luo_fops = {
+	.prepare = vfio_pci_liveupdate_prepare,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.owner = THIS_MODULE,
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 38c8e9350a60..4cb47c1564f4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1386,7 +1386,7 @@ const struct file_operations vfio_device_fops = {
 #endif
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1394,6 +1394,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee..2443d24aa237 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -385,4 +385,6 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+struct vfio_device *vfio_device_from_file(struct file *file);
+
 #endif /* VFIO_H */
-- 
2.51.0.858.gf9c4a03a3a-goog


