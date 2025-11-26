Return-Path: <kvm+bounces-64731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C27DC8BA41
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 768673B9D3C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFA53446C8;
	Wed, 26 Nov 2025 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q4asNFnU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C3934028F
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185788; cv=none; b=sqcIS6wjk0zGuR2WV7VAcYWP3QV5wiKe9wgv+ksLQL5U4Rl5czePD53O40i3Ibvj5VmjJ1NK9q7lCoVQ2suRvKNoC/J8wVId27KcMsuDruVAndWxVV1xp0SDR04f2H1t/FKdVE/D7h+7jJIqIB/duYPyRvUbAKTdvqYtryGsWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185788; c=relaxed/simple;
	bh=dYwaWyRIbjLSPJvPfwfi39/44Tve6NUTV8wbCVJRFAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PiS775hagqNNZkiM8b46ulSBbp+h332aGda+9iJmcuX8rfCizMyX5geNAqCyYS/fC9FnMb6m72pI0Y49zBQVETEMFgxy+6qInYfCWCM1bUIk2e6ES0n1e+EAvFbmxut7FsS9trvgfcXy0jdv5fvaLB8nHCEiTA1w+tjjWFW+RQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q4asNFnU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297f3710070so1904375ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764185785; x=1764790585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oupTdIgiJcobDgdLCKQ4bCK5hBmMGc7yRUjoOu6trk8=;
        b=q4asNFnUx0t6QIitaPgc/5GLpLQXvY3BXVGEPex4Bu52KS7bXAnIBQ8xm6c9ht6dt9
         8GChiubJAM5zGLZI4WeOsIFLVFNucWneMjVUxodYmHjxJi1Qg8UQTKDKJ2C1DHA/yxTo
         roXPZ0lnlEGa7y2ekykT1ITMbHzFsxg1C7L35TFpNqrJOxgDxY+SU14bC+C6pb8hgOq7
         jMFkyL0bDGbI5J0dRoSVZpQA3yr+buqGnRnJX7W6MNUz5sJciFAT/lfBPxGjjt15bFaR
         WAMC8IwrelECwS2OnPnfgThhaFUzwNmPF8JU68DvH9U3g5WHANnp85+lLI7NTdMDS1DG
         pINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764185785; x=1764790585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oupTdIgiJcobDgdLCKQ4bCK5hBmMGc7yRUjoOu6trk8=;
        b=FjdgDsfhGyhUhdCgv2D6/Di5qZJ6LudMRMO/vsyvm+TVJiD5ACRt/G+2nvZ2PcXhoV
         BrIOfGSmXXo7U/zHUqaJm01RoSGvru/idiNS/8s/aHRdCXKlYw00HbK/E/JVLli5s7SS
         nKjQohmCEWl9H3M/CL6dJ+HkAQ0LWDFKu99TTDyvJIiPiqevi++K2oXlcBpW0U020BNH
         4mN6sJKoFv/9dT8Akt2MGXeAHNp2dqI4e9bIPMWGzEcC1WU/NTxMMMsNzZ8/pf3XBQKF
         u513NDAjV0GGdEYL8lsBSVwc4hfqTRQVi/mgW79zN+ENZdmReFsyYVLP+ioXSZlqnMbD
         rPKg==
X-Forwarded-Encrypted: i=1; AJvYcCXvSXCFfmC4ISMJUN85UiBdi+T98vZquOdvMajNwbH6AWhXrWxyunugWGq8A2iCbzWmGu0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQKQ17ss/BP1niCesYV6lZ9lp2PswyENY9cLNimDisY4rTadD8
	s0m3i6VSY4TAUI/fopGb9aTIKcrFEbQY5H3j1iT6Fds2lBKhfh75o7KDMo7zp3/AdoFyh3T32Sg
	JF3WGxkESSLuMnw==
X-Google-Smtp-Source: AGHT+IF1dFRpdgEXNa+eADLtxGLANbMQ+v0Qp/LYDBPxS4oxJSeNtN05AVnZrSpiBB35n+k+Bh9kmPafil/o6A==
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:341:c8a:bd40])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:ace:b0:295:350a:f9b8 with SMTP id d9443c01a7336-29b6c685132mr215591725ad.29.1764185785065;
 Wed, 26 Nov 2025 11:36:25 -0800 (PST)
Date: Wed, 26 Nov 2025 19:35:56 +0000
In-Reply-To: <20251126193608.2678510-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126193608.2678510-10-dmatlack@google.com>
Subject: [PATCH 09/21] vfio/pci: Store Live Update state in struct vfio_pci_core_device
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Philipp Stanner <pstanner@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Stash a pointer to a device's Live Updated state in struct
vfio_pci_core_device. This will enable subsequent commits to use the
preserved state when enabling the device.

To enable VFIO to safely access this pointer during device enablement,
require that the device is fully enabled before returning true from
can_finish().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       |  1 +
 drivers/vfio/pci/vfio_pci_liveupdate.c | 20 +++++++++++++++++++-
 include/linux/vfio_pci_core.h          |  6 ++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..b09fe0993e04 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -536,6 +536,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
+	vdev->liveupdate_state = NULL;
 
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 7669c65bde17..0fb29bd3ae3b 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -145,6 +145,7 @@ static int match_device(struct device *dev, const void *arg)
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	struct folio *folio;
 	struct file *file;
@@ -186,6 +187,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 		goto out;
 	}
 
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	vdev->liveupdate_state = ser;
+
 	args->file = file;
 
 out:
@@ -197,7 +201,21 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 
 static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 {
-	return args->retrieved;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+
+	if (!args->retrieved)
+		return false;
+
+	device = vfio_device_from_file(args->file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	/*
+	 * Ensure VFIO is done using vdev->liveupdate_state, which means its
+	 * safe for vfio_pci_liveupdate_finish() to free it.
+	 */
+	guard(mutex)(&device->dev_set->lock);
+	return !vdev->liveupdate_state;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..56ff6452562d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,12 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+
+	/*
+	 * State passed by the previous kernel during a Live Update. Only
+	 * safe to access when first opening the device.
+	 */
+	struct vfio_pci_core_device_ser *liveupdate_state;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.52.0.487.g5c8c507ade-goog


