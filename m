Return-Path: <kvm+bounces-26986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7187497A04F
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E810D1F22ACD
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BACA1547E8;
	Mon, 16 Sep 2024 11:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="RSU/e5Kt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5D461FD8;
	Mon, 16 Sep 2024 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486426; cv=none; b=tBZf6KLrGE6oV/5coCWVMF1Wa1kf53AvXUtH4yAKaku61Io78NCnUCCfkpuKJPIX5NuMzxSRR39KalZWD2NHU9yUR8ODWiESgadzb+uTfpxWJIh482X2HDYGgfswqLn2AEF11FXGGLNVXxlK9kabhCvd2oW7KJxuce3pZrbkVps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486426; c=relaxed/simple;
	bh=Ymegnh3AxHOuRLT5t0NoKc98Iicef7tf8alEV8sqb7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dhr0mId/wO2f5YzOVpC8UTk3SFDCZsoSxB6QJyzSV1uNSU9dK7A0KGpFNLbtU59eCYeWUFwGSDzKQWi+208FjdthtQNALfp7DRoYqa+3yLN3lJz74gcZuH6wjqJrFZoMvNLsOCrZ8R6Jy4MbtmKceJ5x1ixTqf+5fLcff0HuqYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=RSU/e5Kt; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486425; x=1758022425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QopJSZ/RSdPzLioeqfhnmkCX0oT6c27cpVIgczu8bNo=;
  b=RSU/e5KtlNGxkQjTcEAuPaXf6DSvtHS7jA+yJwtG7Pglgind9weKxuNM
   ASjx/2OT6S1LmSm4WYdDEXWyrXRCI+cIk0gL47D31YfWOOFolCJW/K1GW
   FjdOQc2CqbJ52A+Qs4e7jyZPX7XOPxH44uNPh1mMQjYEworGh6u+J43I8
   k=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="433694478"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:33:41 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:4607]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.198:2525] with esmtp (Farcaster)
 id c747a2bc-a762-49dd-ae3f-d900ed03c88e; Mon, 16 Sep 2024 11:33:39 +0000 (UTC)
X-Farcaster-Flow-ID: c747a2bc-a762-49dd-ae3f-d900ed03c88e
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:33:38 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:33:28 +0000
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
Subject: [RFC PATCH 06/13] iommufd: Expose persistent iommufd IDs in sysfs
Date: Mon, 16 Sep 2024 13:30:55 +0200
Message-ID: <20240916113102.710522-7-jgowans@amazon.com>
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

After kexec userspace needs the ability to re-acquire a handle to the
IOMMUFD which it was using before kexec. To provide userspace the
ability to discover persisted domains and get a handle to them, expose
all of the persisted IDs in sysfs. Each persisted ID will create a
directory like:
/sys/kernel/persisted_iommufd/<id>
In the next commit a file will be added to this directory to allow
actually restoring the IOMMUFD.
---
 drivers/iommu/iommufd/serialise.c | 48 ++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
index 6b4c306dce40..7f2e7b1eda13 100644
--- a/drivers/iommu/iommufd/serialise.c
+++ b/drivers/iommu/iommufd/serialise.c
@@ -21,6 +21,9 @@
  *     }
  *   ]
  */
+
+static struct kobject *persisted_dir_kobj;
+
 static int serialise_iommufd(void *fdt, struct iommufd_ctx *ictx)
 {
 	int err = 0;
@@ -94,8 +97,51 @@ int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
 	}
 }
 
+static ssize_t iommufd_show(struct kobject *kobj, struct kobj_attribute *attr,
+	char *buf)
+{
+	return 0;
+}
+
+static struct kobj_attribute persisted_attr =
+	__ATTR_RO_MODE(iommufd, 0440);
+
+static int deserialise_iommufds(const void *fdt, int root_off)
+{
+	int off;
+
+	/*
+	 * For each persisted iommufd id, create a directory
+	 * in sysfs with an iommufd file in it.
+	 */
+	fdt_for_each_subnode(off, fdt, root_off) {
+		struct kobject *kobj;
+		const char *name = fdt_get_name(fdt, off, NULL);
+		int rc;
+
+		kobj = kobject_create_and_add(name, persisted_dir_kobj);
+		rc = sysfs_create_file(kobj, &persisted_attr.attr);
+		if (rc)
+			pr_warn("Unable to create sysfs file for iommufd node %s\n", name);
+	}
+	return 0;
+}
+
 int __init iommufd_deserialise_kho(void)
 {
-	pr_info("would deserialise here\n");
+	const void *fdt = kho_get_fdt();
+	int off;
+
+	if (!fdt)
+		return 0;
+
+	/* Parent directory for persisted iommufd files. */
+	persisted_dir_kobj = kobject_create_and_add("iommufd_persisted", kernel_kobj);
+
+	off = fdt_path_offset(fdt, "/iommufd");
+	if (off <= 0)
+		return 0; /* No data in KHO */
+
+	deserialise_iommufds(fdt, fdt_subnode_offset(fdt, off, "iommufds"));
 	return 0;
 }
-- 
2.34.1


