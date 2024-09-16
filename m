Return-Path: <kvm+bounces-26981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C5E97A045
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A69422838BF
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175DD155C83;
	Mon, 16 Sep 2024 11:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ApkcddzU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10B6136345;
	Mon, 16 Sep 2024 11:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486307; cv=none; b=Qi6ouis+s5PKO95vJR0zlMBwi/54t8CZsm3KcvK/JCd/3nJzYHc+nds0iqduhYHoY0s9l4hh6cBwEF4R7dYKZHfaAKT48kkd/fqsVTuWDdU2dZxixA+DI0r1ShbA8MXSzex8wpobJnFYnPRS2171vo4ZDdBZcGKQ4iAdPnPs3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486307; c=relaxed/simple;
	bh=9NXEqGFX9ne4oh9zK4Gzz+zWzFEI/zjLFeRQPJqT5Zc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLeJu0cOGG00Qu4kwNtj6qSKENUBC+i0bjQAsFFfrxZRJPRAe//3HWcBUb1otQcAVMrRiXr1Jm6Mi7cnEPjE0NLjPfR+yl6FrQy3icEF9RAIz/Hgs2d4sY/uaQCE7Uex81MMJP12smSQGa1toxIxBlJl5urph2tZSs3PKx3Tfl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ApkcddzU; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486304; x=1758022304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YBMtYNcR4Cg8RdM83OXxt0GVv0Yun58zU3Vf1MOia6s=;
  b=ApkcddzUlvUqRj5RUNfu825VQe6VonVs9daV3btHsdWqdklER4uoNptx
   4AnVDEdgVgYSVW4j8yCfTdaXCKovm1ftPz1z4VeVgHjTt9gGr7guNaidC
   qKlMOmVY7ckKzu03lbz/5gyNq0hnbJ8+OKeWZYxDVSlchPtOwsqLNdnU1
   Q=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="126592449"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:31:42 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:26360]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.249:2525] with esmtp (Farcaster)
 id a8bee893-5a46-4c75-8e61-dea3d9a45d8b; Mon, 16 Sep 2024 11:31:40 +0000 (UTC)
X-Farcaster-Flow-ID: a8bee893-5a46-4c75-8e61-dea3d9a45d8b
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:40 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:31:30 +0000
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
Subject: [RFC PATCH 01/13] iommufd: Support marking and tracking persistent iommufds
Date: Mon, 16 Sep 2024 13:30:50 +0200
Message-ID: <20240916113102.710522-2-jgowans@amazon.com>
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

Introduce a new iommufd option to mark an iommufd as persistent. For now
this allocates it a unique persistent ID from an xarray index and keeps
a reference to the domain.

This will be used so that at serialisation time the open iommufds can be
iterated through and serialised.
---
 drivers/iommu/iommufd/iommufd_private.h |  1 +
 drivers/iommu/iommufd/main.c            | 47 +++++++++++++++++++++++++
 include/uapi/linux/iommufd.h            |  5 +++
 3 files changed, 53 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 92efe30a8f0d..b23f7766066c 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -28,6 +28,7 @@ struct iommufd_ctx {
 	/* Compatibility with VFIO no iommu */
 	u8 no_iommu_mode;
 	struct iommufd_ioas *vfio_ioas;
+	unsigned long persistent_id;
 };
 
 /*
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 83bbd7c5d160..6708ad629b1e 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -29,6 +29,8 @@ struct iommufd_object_ops {
 static const struct iommufd_object_ops iommufd_object_ops[];
 static struct miscdevice vfio_misc_dev;
 
+static DEFINE_XARRAY_ALLOC(persistent_iommufds);
+
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
 					     enum iommufd_object_type type)
@@ -287,10 +289,52 @@ static int iommufd_fops_release(struct inode *inode, struct file *filp)
 			break;
 	}
 	WARN_ON(!xa_empty(&ictx->groups));
+
+	rcu_read_lock();
+	if (ictx->persistent_id)
+		xa_erase(&persistent_iommufds, ictx->persistent_id);
+	rcu_read_unlock();
 	kfree(ictx);
 	return 0;
 }
 
+static int iommufd_option_persistent(struct iommufd_ucmd *ucmd)
+{
+	unsigned int persistent_id;
+	int rc;
+	struct iommu_option *cmd = ucmd->cmd;
+	struct iommufd_ctx *ictx = ucmd->ictx;
+	struct xa_limit id_limit = XA_LIMIT(1, UINT_MAX);
+
+	if (cmd->op == IOMMU_OPTION_OP_GET) {
+		cmd->val64 = ictx->persistent_id;
+		return 0;
+	}
+
+	if (cmd->op == IOMMU_OPTION_OP_SET) {
+		/*
+		 * iommufds can only be marked persistent before they
+		 * have been used for DMA mappings. HWPTs must be known
+		 * to be persistent at creation time.
+		 */
+		if (!xa_empty(&ictx->objects)) {
+			pr_warn("iommufd can only be marked persistented when unused\n");
+			return -EFAULT;
+		}
+
+		rc = xa_alloc(&persistent_iommufds, &persistent_id, ictx, id_limit, GFP_KERNEL_ACCOUNT);
+		if (rc) {
+			pr_warn("Unable to keep track of iommufd object\n");
+			return rc;
+		}
+
+		ictx->persistent_id = persistent_id;
+		cmd->val64 = ictx->persistent_id;
+		return 0;
+	}
+	return -EOPNOTSUPP;
+}
+
 static int iommufd_option(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_option *cmd = ucmd->cmd;
@@ -306,6 +350,9 @@ static int iommufd_option(struct iommufd_ucmd *ucmd)
 	case IOMMU_OPTION_HUGE_PAGES:
 		rc = iommufd_ioas_option(ucmd);
 		break;
+	case IOMMU_OPTION_PERSISTENT:
+		rc = iommufd_option_persistent(ucmd);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 4dde745cfb7e..7d8cb242e9b0 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -276,10 +276,15 @@ struct iommu_ioas_unmap {
  *    iommu mappings. Value 0 disables combining, everything is mapped to
  *    PAGE_SIZE. This can be useful for benchmarking.  This is a per-IOAS
  *    option, the object_id must be the IOAS ID.
+ * @IOMMU_OPTION_PERSISTENT
+ *    Value 1 sets this iommufd object as a persistent iommufd. Mappings will
+ *    survive across kexec. The returned value is the persistent ID which can
+ *    be used to restore the iommufd after kexec.
  */
 enum iommufd_option {
 	IOMMU_OPTION_RLIMIT_MODE = 0,
 	IOMMU_OPTION_HUGE_PAGES = 1,
+	IOMMU_OPTION_PERSISTENT = 2,
 };
 
 /**
-- 
2.34.1


