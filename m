Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA01B3353
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgDUXeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:63698 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDUXeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:44 -0400
IronPort-SDR: dPSH45TC/zqH8EOaDMtHUzXFakbOzuKNWclZKYFyPCN1k69vTWv/oBWM2v8mBqxn6RZjTjL52y
 7WpoazAnLLZQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:44 -0700
IronPort-SDR: 881OnYkA0p1Dly6ophckgg8d9a6a39jFKJWZJ35KssbxE3eAKzsiMXHmDmTZaEEQ/Pk1jBQKAA
 eBGAlWMuRqOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="255449567"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2020 16:34:42 -0700
Subject: [PATCH RFC 09/15] vfio/type1: Save domain when attach domain to mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:42 -0700
Message-ID: <158751208274.36773.9573092458996405211.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

This saves the iommu domain in mdev on attaching a domain
to it and clear it on detaching.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c |   52 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 85b32c325282..40b22c456b06 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1309,20 +1309,62 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
 	return NULL;
 }
 
+static int vfio_mdev_set_domain(struct device *dev, struct iommu_domain *domain)
+{
+	void (*fn)(struct device *dev, void *domain);
+
+	fn = symbol_get(mdev_set_iommu_domain);
+	if (fn) {
+		fn(dev, domain);
+		symbol_put(mdev_set_iommu_domain);
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct iommu_domain *vfio_mdev_get_domain(struct device *dev)
+{
+	void *(*fn)(struct device *dev);
+
+	fn = symbol_get(mdev_get_iommu_domain);
+	if (fn) {
+		struct iommu_domain *domain;
+
+		domain = fn(dev);
+		symbol_put(mdev_get_iommu_domain);
+
+		return domain;
+	}
+
+	return NULL;
+}
+
 static int vfio_mdev_attach_domain(struct device *dev, void *data)
 {
-	struct iommu_domain *domain = data;
+	struct iommu_domain *domain;
 	struct device *iommu_device;
+	int ret = -ENODEV;
+
+	/* Only single domain is allowed to attach to an mdev. */
+	domain = vfio_mdev_get_domain(dev);
+	if (domain)
+		return -EINVAL;
+	domain = data;
 
 	iommu_device = vfio_mdev_get_iommu_device(dev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			return iommu_aux_attach_device(domain, iommu_device);
+			ret = iommu_aux_attach_device(domain, iommu_device);
 		else
-			return iommu_attach_device(domain, iommu_device);
+			ret = iommu_attach_device(domain, iommu_device);
 	}
 
-	return -EINVAL;
+	if (!ret)
+		vfio_mdev_set_domain(dev, domain);
+
+	return ret;
 }
 
 static int vfio_mdev_detach_domain(struct device *dev, void *data)
@@ -1338,6 +1380,8 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
 			iommu_detach_device(domain, iommu_device);
 	}
 
+	vfio_mdev_set_domain(dev, NULL);
+
 	return 0;
 }
 

