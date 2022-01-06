Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40B485EA8
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344843AbiAFCXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:23:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:45674 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344750AbiAFCWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435751; x=1672971751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GDCUJufXvlu7Z20AypZ4GsZd9L9C8y8eFXL56cSyTrE=;
  b=A93kSzd8hs2KrJ8Tk8sCxIHEXc7epR5IYy2mOhdMLX9k69XP3KYD6lS1
   NABwp+FaDCxcxJv8zF5wvqnEwLxi5NzGI3glW/idGSFxk17QCh8dHwPZC
   QVqs9e/aewY4qOIbVak4ikSUTAcypB3OqugDd2U5xvhHj/xUYXJpfRz/e
   12mvzQgzUFHUgBeQCDvuNhdhwx+Dzc1vpdM3rg0soNBtsTiMperI2HvLa
   tOSuZxXOVaeD/0+k5F3bDiJl45Iglz7ARsoGq0iGpz91R5VRu8RVbbgN/
   Pj5zTEI2RQM9kT4RZaIzUzw9Rj37QvbyATBUFCCXCy2e/pBQRZACU+3Df
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229389218"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="229389218"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794466"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:24 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v1 6/8] gpu/host1x: Use iommu_attach/detach_device()
Date:   Thu,  6 Jan 2022 10:20:51 +0800
Message-Id: <20220106022053.2406748-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ordinary drivers should use iommu_attach/detach_device() for domain
attaching and detaching.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/gpu/host1x/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index fbb6447b8659..6e08cb6202cc 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -265,7 +265,7 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
 			goto put_cache;
 		}
 
-		err = iommu_attach_group(host->domain, host->group);
+		err = iommu_attach_device(host->domain, host->dev);
 		if (err) {
 			if (err == -ENODEV)
 				err = 0;
@@ -335,7 +335,7 @@ static void host1x_iommu_exit(struct host1x *host)
 {
 	if (host->domain) {
 		put_iova_domain(&host->iova);
-		iommu_detach_group(host->domain, host->group);
+		iommu_detach_device(host->domain, host->dev);
 
 		iommu_domain_free(host->domain);
 		host->domain = NULL;
-- 
2.25.1

