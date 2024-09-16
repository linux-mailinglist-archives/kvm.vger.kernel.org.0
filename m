Return-Path: <kvm+bounces-26987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6E097A051
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41199283B93
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57473155CBD;
	Mon, 16 Sep 2024 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="igbE2LUH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2597461FD8;
	Mon, 16 Sep 2024 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486432; cv=none; b=HXT2GrPwa/RRhwqpS4sCUwyS/lFW6cKAGVDTAen2XEEDd7VBBR17XV9tDrdXJ73J8q+O0vBHoM80/pnSGN2EJiSg6kdURsEIgnoIyWL1RA5OuZu7bi/nit00e/73p0WZgGA81ZlL1RFRv3uQ0MXFSRNoe2Fah1H3lQX9CTAOh9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486432; c=relaxed/simple;
	bh=dxOdRSAZOWofWEYK0VVawmecWoCTfCFqvejo79rI17o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLJ3DqcTcWUfw5F5a9bUP+vZYOvoWTVz14F9HlPYsLFdZMBjN6yUObOpL/McwkTC0aUHJUtbwQ66ooGarlg3L8hfBnqkS+8Fc5gzShCcXMtbraB2w4X2JeqTC875hdomMw7lMikM0vRi6lqskjzD00zgISNob2F3thd5od1fqYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=igbE2LUH; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486431; x=1758022431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tEGWnhFMypw6xRZtfZafM76snQDV4sMYnYAjAyQltqs=;
  b=igbE2LUHolPHphzAxJJReYzI81iE55v7eU4Pp1+bKe3+IpCc4JJ17+6a
   rb5UpvVgb/Nag5JJ+d+7F4ZaVomW4BmNoGFeScRHPW6L8W0/iAeGYJvcb
   6TNdBiLdHgZ895OzNVD/HciPLPPmUyYGDWtzh5LIOT2av65nzEr1CC8is
   U=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="126593048"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:33:50 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:42594]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.198:2525] with esmtp (Farcaster)
 id f532e37d-8857-4c4d-b867-21ef2f8b2bae; Mon, 16 Sep 2024 11:33:49 +0000 (UTC)
X-Farcaster-Flow-ID: f532e37d-8857-4c4d-b867-21ef2f8b2bae
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:33:49 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:33:39 +0000
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
Subject: [RFC PATCH 07/13] iommufd: Re-hydrate a usable iommufd ctx from sysfs
Date: Mon, 16 Sep 2024 13:30:56 +0200
Message-ID: <20240916113102.710522-8-jgowans@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB003.ant.amazon.com (10.13.139.174) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

When the sysfs file is read, create an iommufd file descriptor, create a
fresh iommufd_ctx, and populate that ictx struct and related structs
with the data about mapped IOVA ranges from KHO.

This is done in a super yucky way by having the sysfs file's .show()
callback create a new file and then print out the new file's fd number.
Done this way because I couldn't figure out how to define a custom
.open() callback on a sysfs object.
An alternative would be to have a new iommufd pseudo-filesystem which
could be mounted somewhere and would have all of the relevant persistent
data in it.

Opinions/ideas on how best to expose persisted domains to userspace are
welcome.
---
 drivers/iommu/iommufd/io_pagetable.c    |  2 +-
 drivers/iommu/iommufd/iommufd_private.h |  4 ++
 drivers/iommu/iommufd/main.c            |  4 +-
 drivers/iommu/iommufd/serialise.c       | 54 ++++++++++++++++++++++++-
 4 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 05fd9d3abf1b..b4b75663d7cf 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -222,7 +222,7 @@ static int iopt_insert_area(struct io_pagetable *iopt, struct iopt_area *area,
 	return 0;
 }
 
-static struct iopt_area *iopt_area_alloc(void)
+struct iopt_area *iopt_area_alloc(void)
 {
 	struct iopt_area *area;
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index ad8d180269bd..94612cec2814 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -59,6 +59,10 @@ struct io_pagetable {
 	unsigned long iova_alignment;
 };
 
+extern const struct file_operations iommufd_fops;
+int iommufd_fops_open(struct inode *inode, struct file *filp);
+struct iopt_area *iopt_area_alloc(void);
+
 void iopt_init_table(struct io_pagetable *iopt);
 void iopt_destroy_table(struct io_pagetable *iopt);
 int iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 21a7e1ad40d1..f78a4cf23741 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -233,7 +233,7 @@ static int iommufd_destroy(struct iommufd_ucmd *ucmd)
 	return iommufd_object_remove(ucmd->ictx, NULL, cmd->id, 0);
 }
 
-static int iommufd_fops_open(struct inode *inode, struct file *filp)
+int iommufd_fops_open(struct inode *inode, struct file *filp)
 {
 	struct iommufd_ctx *ictx;
 
@@ -473,7 +473,7 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 	return ret;
 }
 
-static const struct file_operations iommufd_fops = {
+const struct file_operations iommufd_fops = {
 	.owner = THIS_MODULE,
 	.open = iommufd_fops_open,
 	.release = iommufd_fops_release,
diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
index 7f2e7b1eda13..9519969bd201 100644
--- a/drivers/iommu/iommufd/serialise.c
+++ b/drivers/iommu/iommufd/serialise.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/anon_inodes.h>
+#include <linux/fdtable.h>
 #include <linux/kexec.h>
 #include <linux/libfdt.h>
 #include "iommufd_private.h"
@@ -97,10 +99,60 @@ int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
 	}
 }
 
+static int rehydrate_iommufd(char *iommufd_name)
+{
+	struct file *file;
+	int fd;
+	int off;
+	struct iommufd_ctx *ictx;
+	struct files_struct *files = current->files;  // Current process's files_struct
+	const void *fdt = kho_get_fdt();
+	char kho_path[42];
+
+	fd = anon_inode_getfd("iommufd", &iommufd_fops, NULL, O_RDWR);
+	if (fd < 0)
+		return fd;
+	file = files_lookup_fd_raw(files, fd);
+	iommufd_fops_open(NULL, file);
+	ictx = file->private_data;
+
+	snprintf(kho_path, sizeof(kho_path), "/iommufd/iommufds/%s/ioases", iommufd_name);
+	fdt_for_each_subnode(off, fdt, fdt_path_offset(fdt, kho_path)) {
+	    struct iommufd_ioas *ioas;
+	    int range_off;
+
+	    ioas = iommufd_ioas_alloc(ictx);
+	    iommufd_object_finalize(ictx, &ioas->obj);
+
+	    fdt_for_each_subnode(range_off, fdt, off) {
+		    const unsigned long *iova_start, *iova_len;
+		    const int *iommu_prot;
+		    int len;
+		    struct iopt_area *area = iopt_area_alloc();
+
+		    iova_start = fdt_getprop(fdt, range_off, "iova-start", &len);
+		    iova_len = fdt_getprop(fdt, range_off, "iova-len", &len);
+		    iommu_prot = fdt_getprop(fdt, range_off, "iommu-prot", &len);
+
+		    area->iommu_prot = *iommu_prot;
+		    area->node.start = *iova_start;
+		    area->node.last = *iova_start + *iova_len - 1;
+		    interval_tree_insert(&area->node, &ioas->iopt.area_itree);
+	    }
+	    /* TODO: restore link from ioas to hwpt. */
+	}
+
+	return fd;
+}
+
 static ssize_t iommufd_show(struct kobject *kobj, struct kobj_attribute *attr,
 	char *buf)
 {
-	return 0;
+	char fd_str[10];
+	ssize_t len;
+
+	len = snprintf(buf, sizeof(fd_str), "%i\n", rehydrate_iommufd("1"));
+	return len;
 }
 
 static struct kobj_attribute persisted_attr =
-- 
2.34.1


