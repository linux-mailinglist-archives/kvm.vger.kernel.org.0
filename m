Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13C1757EBA
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjGRN6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjGRN6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:58:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC4197;
        Tue, 18 Jul 2023 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688669; x=1721224669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7JlSkImz3ShAuDaiIZ+sh4zHfMa5cWhubnsyO0SRRR4=;
  b=Y7ivL4yyG0JFTPoI81YHAO6nbW0BIraFB0kT6NlX8KQ+qu0R6aRxAp12
   8V0QfzwBNZfz2fDvH7JhI+7+T1hUplRFtrIdv0qjou+f8KacPxXNTh9TB
   jWwSpZm1YB3TFBAP2soRPZWLz5IlrTC01uuL7e9r8xWCQVrntsxmYF3uN
   CRhuPEayY7Gq5lTOpqMiNrBME1h6y8/9Y+8Wtnc7Wy+dbCaQ/432MrAGA
   Mk7T+nN4LdfyFHOi1f0ayA+xG0QH/43Qj4eBuncBE7wLUBKRJlisNNhoJ
   ZWK2JvZXtWy4RLnxzFS/0O8SfRwAGAdCgOIdGw7NnJ89bTnGSFyGrhrk9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452590787"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452590787"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:56:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="970251096"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="970251096"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2023 06:56:09 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v15 20/26] iommufd: Add iommufd_ctx_from_fd()
Date:   Tue, 18 Jul 2023 06:55:45 -0700
Message-Id: <20230718135551.6592-21-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718135551.6592-1-yi.l.liu@intel.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's common to get a reference to the iommufd context from a given file
descriptor. So adds an API for it. Existing users of this API are compiled
only when IOMMUFD is enabled, so no need to have a stub for the IOMMUFD
disabled case.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/main.c | 24 ++++++++++++++++++++++++
 include/linux/iommufd.h      |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 32ce7befc8dd..4bbb20dff430 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -377,6 +377,30 @@ struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_file, IOMMUFD);
 
+/**
+ * iommufd_ctx_from_fd - Acquires a reference to the iommufd context
+ * @fd: File descriptor to obtain the reference from
+ *
+ * Returns a pointer to the iommufd_ctx, otherwise ERR_PTR. On success
+ * the caller is responsible to call iommufd_ctx_put().
+ */
+struct iommufd_ctx *iommufd_ctx_from_fd(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (file->f_op != &iommufd_fops) {
+		fput(file);
+		return ERR_PTR(-EBADFD);
+	}
+	/* fget is the same as iommufd_ctx_get() */
+	return file->private_data;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_fd, IOMMUFD);
+
 /**
  * iommufd_ctx_put - Put back a reference
  * @ictx: Context to put back
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 3a3216cb9482..9657c58813dc 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -54,6 +54,7 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
+struct iommufd_ctx *iommufd_ctx_from_fd(int fd);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
 bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group);
 
-- 
2.34.1

