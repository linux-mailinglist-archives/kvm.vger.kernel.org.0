Return-Path: <kvm+bounces-26993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BE897A05E
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6174C1C21D29
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3429F155322;
	Mon, 16 Sep 2024 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="bhcvRyiv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA07153824;
	Mon, 16 Sep 2024 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486563; cv=none; b=BmM3mkinPyqKdzbVb5fPohXHNh7xkxPS8mf40oyzb7TQo/tfD1VSr4cZf1nNZDmWgwXhQm76XTid3UejBZNsdSnO7267viSs5e1oVDZN3+ZtzDR/F5DIb7KexK8fE3NsbexBLEXQaSDK76dBy87Ukfh40on/XBAlLl5P246ucOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486563; c=relaxed/simple;
	bh=z++L0nDgK3j/I2EneGkWSR3NrEn1uaVrc2KHU+a8SjE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ux2igA/LJ2tRAkwUR8eURPRzru23ffgea1prj/3ji7ZZjyTqRUAfmX6r18gsqUuf8QvNcqJmyQ6/nPkyOUk7xSrHGs2gen4CST+RDGP21MLBMVzxMsFEZSmLrj/D3K6d1Um6wdnHix8+1ztJt/TcI3hQsIlYbRTO8y9ltI0uQJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=bhcvRyiv; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486562; x=1758022562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmNCEgTiIn0/HSF3qLDtBAVvZlJga9Hix4MGZ1qplug=;
  b=bhcvRyiva1xKjfbilWeVGQ1oQWNQTk2uj0h+xIozd1mGvUGsTSdokN2q
   H9H9F3KYZD3+cd57mQmD0kEoVMdvfcCM45uleNG7mnHsyQwC4ZFlnWz9S
   s+c8gLKdFlsgZ/0yTNapUiKeNr/jcfEalDWflVOCEsZiy1l57Tc6/7ER0
   o=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="424150549"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:36:00 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:6208]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.229:2525] with esmtp (Farcaster)
 id 64b5d967-c00c-45a6-8975-b19cfe456119; Mon, 16 Sep 2024 11:35:58 +0000 (UTC)
X-Farcaster-Flow-ID: 64b5d967-c00c-45a6-8975-b19cfe456119
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:35:57 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:35:47 +0000
From: James Gowans <jgowans@amazon.com>
To: <linux-kernel@vger.kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?=
	<kw@linux.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>, "Madhavan T.
 Venkataraman" <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
	<anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
	<nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: [RFC PATCH 13/13] iommufd, guestmemfs: Pin files when mapped for persistent DMA
Date: Mon, 16 Sep 2024 13:31:02 +0200
Message-ID: <20240916113102.710522-14-jgowans@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240916113102.710522-1-jgowans@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

Ordinarily after kexec the new kernel would have no idea that some files
are still actually in use as DMA targets, this could allow the files to
be deleted while still actually in use behind the scenes. This would
allow use-after-frees of the persistent memory.

To prevent this, add the ability to do long term (across kexec) pinning
of files in guestmemfs. Iommufd is updated to use this when mapping a
file into a persistent domain. As long as the file has pins it cannot be
deleted.

A hand-wavy alternative would be to use something like the iommufd's
storage domain and actually do this at the PFN level.
---
 drivers/iommu/iommufd/ioas.c            |  4 ++++
 drivers/iommu/iommufd/iommufd_private.h |  5 +++++
 drivers/iommu/iommufd/serialise.c       |  9 ++++++++-
 fs/guestmemfs/file.c                    | 20 ++++++++++++++++++++
 fs/guestmemfs/guestmemfs.h              |  1 +
 fs/guestmemfs/inode.c                   |  4 ++++
 include/linux/guestmemfs.h              |  8 ++++++++
 7 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index ce76b41d2d72..8b7fa3d17e8a 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -233,6 +233,7 @@ int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
 			mmap_read_unlock(mm);
 			return -EFAULT;
 		}
+		ioas->pinned_file_handle = guestmemfs_pin_file(vma->vm_file);
 		mmap_read_unlock(mm);
 #else
 		return -EFAULT;
@@ -331,6 +332,9 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 				     &unmapped);
 		if (rc)
 			goto out_put;
+
+		if (ioas->pinned_file_handle)
+			guestmemfs_unpin_file(ioas->pinned_file_handle);
 	}
 
 	cmd->length = unmapped;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 94612cec2814..597a54a1adf3 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -260,12 +260,17 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
  * An iommu_domain & iommfd_hw_pagetable will be automatically selected
  * for a device based on the hwpt_list. If no suitable iommu_domain
  * is found a new iommu_domain will be created.
+ *
+ * If this IOAS is pinning a file for persistent DMA, pinned_file_handle will
+ * be set to a non-zero value. When unmapping this IOAS the file will be
+ * unpinned.
  */
 struct iommufd_ioas {
 	struct iommufd_object obj;
 	struct io_pagetable iopt;
 	struct mutex mutex;
 	struct list_head hwpt_list;
+	unsigned long pinned_file_handle;
 };
 
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ctx *ictx,
diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
index baac7d6150cb..d95e150c3dd9 100644
--- a/drivers/iommu/iommufd/serialise.c
+++ b/drivers/iommu/iommufd/serialise.c
@@ -16,6 +16,7 @@
  *       account_mode = u8
  *       ioases = [
  *         {
+ *           pinned_file_handle = u64
  *           areas = [
  *           ]
  *         }
@@ -48,6 +49,9 @@ static int serialise_iommufd(void *fdt, struct iommufd_ctx *ictx)
 		snprintf(name, sizeof(name), "%lu", obj_idx);
 		err |= fdt_begin_node(fdt, name);
 
+		err |= fdt_property(fdt, "pinned-file-handle",
+				&ioas->pinned_file_handle, sizeof(ioas->pinned_file_handle));
+
 		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX); area;
 				area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
 			unsigned long iova_start, iova_len;
@@ -119,15 +123,18 @@ static int rehydrate_iommufd(char *iommufd_name)
 	snprintf(kho_path, sizeof(kho_path), "/iommufd/iommufds/%s/ioases", iommufd_name);
 	fdt_for_each_subnode(off, fdt, fdt_path_offset(fdt, kho_path)) {
 	    struct iommufd_ioas *ioas;
+	    int len;
 	    int range_off;
+	    const unsigned long *pinned_file_handle;
 
 	    ioas = iommufd_ioas_alloc(ictx);
+	    pinned_file_handle = fdt_getprop(fdt, off, "pinned-file-handle", &len);
+	    ioas->pinned_file_handle = *pinned_file_handle;
 	    iommufd_object_finalize(ictx, &ioas->obj);
 
 	    fdt_for_each_subnode(range_off, fdt, off) {
 		    const unsigned long *iova_start, *iova_len;
 		    const int *iommu_prot;
-		    int len;
 		    struct iopt_area *area = iopt_area_alloc();
 
 		    iova_start = fdt_getprop(fdt, range_off, "iova-start", &len);
diff --git a/fs/guestmemfs/file.c b/fs/guestmemfs/file.c
index ecacaf200a31..d7840831df03 100644
--- a/fs/guestmemfs/file.c
+++ b/fs/guestmemfs/file.c
@@ -109,3 +109,23 @@ bool is_guestmemfs_file(struct file const *file)
 {
 	return file && file->f_op == &guestmemfs_file_fops;
 }
+
+unsigned long guestmemfs_pin_file(struct file *file)
+{
+	struct guestmemfs_inode *inode =
+		guestmemfs_get_persisted_inode(file->f_inode->i_sb,
+				file->f_inode->i_ino);
+
+	atomic_inc(&inode->long_term_pins);
+	return file->f_inode->i_ino;
+}
+
+void guestmemfs_unpin_file(unsigned long pin_handle)
+{
+	struct guestmemfs_inode *inode =
+		guestmemfs_get_persisted_inode(guestmemfs_sb, pin_handle);
+	int new;
+
+	new = atomic_dec_return(&inode->long_term_pins);
+	WARN_ON(new < 0);
+}
diff --git a/fs/guestmemfs/guestmemfs.h b/fs/guestmemfs/guestmemfs.h
index 91cc06ae45a5..d107ad0e3323 100644
--- a/fs/guestmemfs/guestmemfs.h
+++ b/fs/guestmemfs/guestmemfs.h
@@ -42,6 +42,7 @@ struct guestmemfs_inode {
 	char filename[GUESTMEMFS_FILENAME_LEN];
 	void *mappings;
 	int num_mappings;
+	atomic_t long_term_pins;
 };
 
 void guestmemfs_initialise_inode_store(struct super_block *sb);
diff --git a/fs/guestmemfs/inode.c b/fs/guestmemfs/inode.c
index d521b35d4992..6bc0abbde8d1 100644
--- a/fs/guestmemfs/inode.c
+++ b/fs/guestmemfs/inode.c
@@ -151,6 +151,10 @@ static int guestmemfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	ino = guestmemfs_get_persisted_inode(dir->i_sb, dir->i_ino)->child_ino;
 
+	inode = guestmemfs_get_persisted_inode(dir->i_sb, dentry->d_inode->i_ino);
+	if (atomic_read(&inode->long_term_pins))
+		return -EBUSY;
+
 	/* Special case for first file in dir */
 	if (ino == dentry->d_inode->i_ino) {
 		guestmemfs_get_persisted_inode(dir->i_sb, dir->i_ino)->child_ino =
diff --git a/include/linux/guestmemfs.h b/include/linux/guestmemfs.h
index c5cd7b6a5630..c2018b4f38fd 100644
--- a/include/linux/guestmemfs.h
+++ b/include/linux/guestmemfs.h
@@ -20,4 +20,12 @@ inline bool is_guestmemfs_file(struct file const *filp)
 }
 #endif
 
+/*
+ * Ensure that the file cannot be deleted or have its memory changed
+ * until it is unpinned. The returned value is a handle which can be
+ * used to un-pin the file.
+ */
+unsigned long guestmemfs_pin_file(struct file *file);
+void guestmemfs_unpin_file(unsigned long pin_handle);
+
 #endif
-- 
2.34.1


