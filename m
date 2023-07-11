Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9494B74E4FE
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 05:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjGKDBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 23:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjGKDBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 23:01:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE0D10CB;
        Mon, 10 Jul 2023 20:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689044456; x=1720580456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fBfqEkX2XMrQX6lmuLi0sp6h6juMN8+5Q2BJx5EK628=;
  b=my+GKclIukoHVT6K29rEXD7u9VWNtF12uulM1NFQlaVyLmttNIm3x+Oq
   G6wj4Wazn1v6Gpzlk8dYu73Vg/6SJvCcJ0e4nOv1mUEcbVVPWhxxoT+e8
   nSjxw6TWyD6XwWdXoyE+OoKfIfCSE1qXnkYYSH9lddhQ/q7o8IDHHhoJE
   r/braD1qgeQwBLT3K02SkEiZ5BaU/p1NPmXSX2Emt+iBrQdgWjiyOnFyj
   fsbGSOv1aGftDN42o12tT2Yiw2AalxF8F65qzVkZonRNn4s+NSkjO78s7
   /Bqrdf2RXpf4+XBsHunFsjdFQ9ggB6jtQT16BFrrntdhS0b5azIC5axKu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361973181"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="361973181"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="724250917"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="724250917"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2023 19:59:50 -0700
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
Subject: [PATCH v14 20/26] iommufd: Add iommufd_ctx_from_fd()
Date:   Mon, 10 Jul 2023 19:59:22 -0700
Message-Id: <20230711025928.6438-21-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/iommu/iommufd/main.c | 23 +++++++++++++++++++++++
 include/linux/iommufd.h      |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 32ce7befc8dd..e99a338d4fdf 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -377,6 +377,29 @@ struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
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
+	struct iommufd_ctx *iommufd;
+	struct fd f;
+
+	f = fdget(fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	iommufd = iommufd_ctx_from_file(f.file);
+
+	fdput(f);
+	return iommufd;
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

