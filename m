Return-Path: <kvm+bounces-26982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2B397A047
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EF91283905
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6199155336;
	Mon, 16 Sep 2024 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="IbR0D/vm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7114AD3F;
	Mon, 16 Sep 2024 11:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486319; cv=none; b=LM974H40RdjlEjlnAWe7jeFJ71fnA3B0N7kp5ngoLSe3Iik0bysaBZE8olQVsBSrRxcHkV6G6kiXXUqACVDCBfPq2r9avhcOJy5oTH7KB+My84E+wZ1vz/Jr0Feebql8nwbdw2IlgnSp/WVHR9Rf8Os4y+C9qFqcvi2K4raPEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486319; c=relaxed/simple;
	bh=50zHaqmrB4SYyMYyNydrR+zrxyQS+qWdmvPRgZ9y0gY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rssrUZA8DphDrmQag27819LxRKQCLNybHIB77zsj9l2IgEuRNX1YXdyMsF7PkpnfQCKJAc2mK13sPWcw2dSw/lSbyRzX07ZP0OCH9d8QZzqxVX2LhzuLzKjUaQtz4L50Rwd4cQ717mHO1TgIdHsRyqVHVK4GAeoWaIymDfX6Ak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=IbR0D/vm; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486319; x=1758022319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M05pjVVQI9aTtoEIvcWtno5GUtF2a6TkNMVEd9muAz4=;
  b=IbR0D/vme83UwV8mbI3QAu55DpQ/zE5N5ODHiOVyu2WSIw+re7PHi72n
   CIL6tmQmunXQte1aTZKAal6hv7ZXXDYyTLeQEQ7dHzOJ1/lfbFviXJqyz
   lMzm5QFpSzOMitQA1UJCetLbi1Sf34j4WgZz6T/Uvw0O91PlfBTRf6yWj
   I=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="760323496"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:31:53 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:34005]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.23:2525] with esmtp (Farcaster)
 id 64df1e2b-6d4b-4ece-83c0-47b88ea24823; Mon, 16 Sep 2024 11:31:51 +0000 (UTC)
X-Farcaster-Flow-ID: 64df1e2b-6d4b-4ece-83c0-47b88ea24823
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:51 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:40 +0000
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
Subject: [RFC PATCH 02/13] iommufd: Add plumbing for KHO (de)serialise
Date: Mon, 16 Sep 2024 13:30:51 +0200
Message-ID: <20240916113102.710522-3-jgowans@amazon.com>
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
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

To support serialising persistent iommufd objects to KHO, and to be able
to restore the persisted data it is necessary to have a serialise hook
on the KHO active path as well as a deserialise hook on module init.

This commit adds those hooks and the new serialise.c file which will
hold the logic here; for now it's just empty functions.
---
 drivers/iommu/iommufd/Makefile          |  1 +
 drivers/iommu/iommufd/iommufd_private.h | 22 +++++++++++++++++++++
 drivers/iommu/iommufd/main.c            | 24 ++++++++++++++++++++++-
 drivers/iommu/iommufd/serialise.c       | 26 +++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/serialise.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index cf4605962bea..80bc775c170d 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -13,3 +13,4 @@ iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
 obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
+obj-$(CONFIG_KEXEC_KHO) += serialise.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index b23f7766066c..a26728646a22 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -497,6 +497,28 @@ static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
 	iommu_detach_group(hwpt->domain, idev->igroup->group);
 }
 
+/*
+ * Serialise is invoked as a callback by KHO when changing KHO active state,
+ * it stores current iommufd state into KHO's persistent store.
+ * Deserialise is run by the iommufd module when loaded to re-hydrate state
+ * carried across from the previous kernel.
+ */
+#ifdef CONFIG_KEXEC_KHO
+int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt);
+int __init iommufd_deserialise_kho(void);
+#else
+int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt)
+{
+	return 0;
+}
+int __init iommufd_deserialise_kho(void)
+{
+	return 0;
+}
+#endif
+
 static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
 					      struct iommufd_hw_pagetable *hwpt,
 					      struct iommufd_hw_pagetable *old)
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 6708ad629b1e..fa4f0fe336ad 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -10,6 +10,7 @@
 
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/miscdevice.h>
@@ -590,6 +591,10 @@ static struct miscdevice vfio_misc_dev = {
 	.mode = 0666,
 };
 
+static struct notifier_block serialise_kho_nb = {
+	.notifier_call = iommufd_serialise_kho,
+};
+
 static int __init iommufd_init(void)
 {
 	int ret;
@@ -603,11 +608,26 @@ static int __init iommufd_init(void)
 		if (ret)
 			goto err_misc;
 	}
+
+	if (IS_ENABLED(CONFIG_KEXEC_KHO)) {
+		ret = register_kho_notifier(&serialise_kho_nb);
+		if (ret)
+			goto err_vfio_misc;
+	}
+
+	ret = iommufd_deserialise_kho();
+	if (ret)
+		goto err_kho;
+
 	ret = iommufd_test_init();
+
 	if (ret)
-		goto err_vfio_misc;
+		goto err_kho;
 	return 0;
 
+err_kho:
+	if (IS_ENABLED(CONFIG_KEXEC_KHO))
+		unregister_kho_notifier(&serialise_kho_nb);
 err_vfio_misc:
 	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
 		misc_deregister(&vfio_misc_dev);
@@ -621,6 +641,8 @@ static void __exit iommufd_exit(void)
 	iommufd_test_exit();
 	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
 		misc_deregister(&vfio_misc_dev);
+	if (IS_ENABLED(CONFIG_FTRACE_KHO))
+		unregister_kho_notifier(&serialise_kho_nb);
 	misc_deregister(&iommu_misc_dev);
 }
 
diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
new file mode 100644
index 000000000000..6e8bcc384771
--- /dev/null
+++ b/drivers/iommu/iommufd/serialise.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kexec.h>
+#include "iommufd_private.h"
+
+int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt)
+{
+	pr_info("would serialise here\n");
+	switch (cmd) {
+	case KEXEC_KHO_ABORT:
+		/* Would do serialise rollback here. */
+		return NOTIFY_DONE;
+	case KEXEC_KHO_DUMP:
+		/* Would do serialise here. */
+		return NOTIFY_DONE;
+	default:
+		return NOTIFY_BAD;
+	}
+}
+
+int __init iommufd_deserialise_kho(void)
+{
+	pr_info("would deserialise here\n");
+	return 0;
+}
-- 
2.34.1


