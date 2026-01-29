Return-Path: <kvm+bounces-69612-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMSNJmHRe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69612-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:30:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B50B4B7F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F189630886DC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C881E362127;
	Thu, 29 Jan 2026 21:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxeVlgC6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F735DCEA
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721951; cv=none; b=YQmxMWOaxTmtBu4oNCB/nkNlFzgtqpBNv4J9hOyGr98gBTko2X3643H+ZpVm91GI2fkHJjLX9T9MCXvhl6PetbKRfPLwHj1fP5MPHq+nWAdU8YZ4HpIsfHhEmmyEKAR6unT2Odr9Enaw6EXCDCfnT2FrfsX3W7ymF+fs456GjZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721951; c=relaxed/simple;
	bh=SRC6WyUfpos4EfjDAe8KcuM0pgKR7jThm7ZjQ5NtQv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sgCobnkCDU65/C0vM3oRRaoJhT2SlB+FJ4wUFRCBDFNAs9jdmIcld4WsRnd1ZaLKDTP90OTz+0TgFAm2ViAS/uHpkAhLFhR95DFh7HEPDHDuDIkDR8PHR70+h2zwzunpvGRGMsib6oC5hE+c+9l40m/neVBt8FHO/nWZWajD4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxeVlgC6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so1604657a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721947; x=1770326747; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvBnrq4VVaLn6O5AYPXHhriXtNBsa9110uSNH/MSfDg=;
        b=KxeVlgC6MlgLSZpDVBSKKqgoqQy9CkkT9ocCoxG7UNFMaBwKvBbHnCtQs6T2E8ChJ0
         pt0NB8PmPoEbMGDzcRZ4433x5FqaWtYKtDmJGY1ZxZNhbyldGltYcZbUXWBBBXf0O9I7
         xRlLUqEyaqyVV1w09g+VVcIRNjQSGAzeq6BTqL9wQ9r0557s7DYgESOGrkMFJsV/Ugqy
         JgY57agfZ4yxM/ve2ma+RAQ2cv9z9Hzw3QbovOTjiUWN3RiGM2t7aMNCr9VDbLl+IJFM
         p8+QaUiy+lJproWxDVlXdVpr7xRPS6eaqlN6fArXVXtQMi8AGh5yhzQogSUJVw7F9zOC
         kY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721947; x=1770326747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvBnrq4VVaLn6O5AYPXHhriXtNBsa9110uSNH/MSfDg=;
        b=YH9f/KrrjwHMlorycUrTzzpoIypDDQInjuyrbs8JFTjA1La8T7AMwnC7FPbeVS3SBX
         /JzZPkf4bianWeX5qG1NZ7O1ZZdYz154y5N0rOmSEdOv9e2GyP/gnA20ZdqohN6yge9X
         1U2lajLcDWUu44v3r+x+jCOGxQn5CNl7C/8XRWcWojkA3Bd3/hHM/TNGc/3rC+uCKa33
         TtKTb73LopXARnHQpLOvrjyV4GOfNZhAYlaJNBJLe/m/msPGNPPz9/qtEPje1cYTjE9r
         Kutv5l8HLBIPhSdlb6aCBrFW81FGrv2yz2d/4DNbA2wB8dUyTDuIgxE96iiyDKbDUnlF
         izUg==
X-Forwarded-Encrypted: i=1; AJvYcCVDZghK3HaS9QIPFu071TWKNsQUAcTQW8tLF3fR0Q+L/o9jaOnAaChNKqZXz84mp3UXw0E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3p1HDIogL9K7q1bixBukSPbAkCYVlQmSOjoGonwu3PFUfX4xa
	mtVMTxxBniqCqn7B3nUg2OCeR1H742n9278VrYis3nAku4Rh/QlHSah7Wot9OiP1LeJGkx8wCiP
	KPLXIPBSQNSaFEg==
X-Received: from pjbcp23.prod.google.com ([2002:a17:90a:fb97:b0:352:e9d7:ffd2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d4d:b0:34c:9cec:dd83 with SMTP id 98e67ed59e1d1-3543b3d6641mr750618a91.27.1769721947474;
 Thu, 29 Jan 2026 13:25:47 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:53 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-7-dmatlack@google.com>
Subject: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69612-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 12B50B4B7F
X-Rspamd-Action: no action

From: Vipin Sharma <vipinsh@google.com>

Enable userspace to retrieve preserved VFIO device files from VFIO after
a Live Update by implementing the retrieve() and finish() file handler
callbacks.

Use an anonymous inode when creating the file, since the retrieved
device file is not opened through any particular cdev inode, and the
cdev inode does not matter in practice.

For now the retrieved file is functionally equivalent a opening the
corresponding VFIO cdev file. Subsequent commits will leverage the
preserved state associated with the retrieved file to preserve bits of
the device across Live Update.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/device_cdev.c             | 21 ++++++---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
 drivers/vfio/vfio_main.c               | 13 ++++++
 include/linux/vfio.h                   | 12 ++++++
 4 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 8ceca24ac136..935f84a35875 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-/*
- * device access via the fd opened by this function is blocked until
- * .open_device() is called successfully during BIND_IOMMUFD.
- */
-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
 {
-	struct vfio_device *device = container_of(inode->i_cdev,
-						  struct vfio_device, cdev);
 	struct vfio_device_file *df;
 	int ret;
 
@@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	vfio_device_put_registration(device);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
+
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+
+	return __vfio_device_fops_cdev_open(device, filep);
+}
 
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index f01de98f1b75..7f4117181fd0 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -8,6 +8,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
@@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
 	return ret;
 }
 
+static int match_device(struct device *dev, const void *arg)
+{
+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
+	const struct vfio_pci_core_device_ser *ser = arg;
+	struct pci_dev *pdev;
+
+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
+	if (!pdev)
+		return false;
+
+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_device *device;
+	struct file *file;
+	int ret;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	device = vfio_find_device(ser, match_device);
+	if (!device)
+		return -ENODEV;
+
+	/*
+	 * Simulate opening the character device using an anonymous inode. The
+	 * returned file has the same properties as a cdev file (e.g. operations
+	 * are blocked until BIND_IOMMUFD is called).
+	 */
+	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
+					&vfio_device_fops, NULL,
+					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out;
+	}
+
+	ret = __vfio_device_fops_cdev_open(device, file);
+	if (ret) {
+		fput(file);
+		goto out;
+	}
+
+	args->file = file;
+
+out:
+	/* Drop the reference from vfio_find_device() */
+	put_device(&device->device);
+
+	return ret;
+}
+
+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
+{
+	return args->retrieved;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
 static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
@@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
 	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
+	.can_finish = vfio_pci_liveupdate_can_finish,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
 };
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 276f615f0c28..89c5feef75d5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -13,6 +13,7 @@
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
+#include <linux/device/class.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
@@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
+{
+	struct device *device;
+
+	device = class_find_device(vfio.device_class, NULL, data, match);
+	if (!device)
+		return NULL;
+
+	return container_of(device, struct vfio_device, device);
+}
+EXPORT_SYMBOL_GPL(vfio_find_device);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9aa1587fea19..dc592dc00f89 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
+#else
+static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
+					       struct file *filep)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
+
+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
+
 #endif /* VFIO_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog


