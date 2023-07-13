Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE57751788
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 06:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjGMEeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 00:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjGMEeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 00:34:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0362012F;
        Wed, 12 Jul 2023 21:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689222884; x=1720758884;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wqmFSfNFiLpHxGf4UqAgLc6Gm83K5eey8IZvYJAOyWs=;
  b=VEv1AY5KjRwIjgaryNQ8/eCovig0PBjtc004tG8G21r5TYqev0MoL/as
   uTzYEUG2Z1Cx+fagEkqe4/lDSOC9nQccpbfR5jz1GdOPhHUero/8jqNXM
   JlKdy3glUNX4612TzNO0lV1Cska1hNrLiEtSIjbT8K/VDIm0kNFhvueO5
   0OKvLvrBbBJlkLe7gkzjfxthW5i9EuZw8l25gRtP7sh9LUw9gILAa+IQt
   /Q+8zwuVR+yXGEatphgoOYn4mP+lp5S2S4joEuj8k7xTNgR00p/OVK6DH
   7z4lh9v12dgOof68Wlju4VT/+hvWOZcQzk6QC2rWTKKmfQsHRnqAvcvpv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="344677960"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="344677960"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 21:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866400203"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="866400203"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2023 21:34:40 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 0/2] Prevent RESV_DIRECT devices from user assignment
Date:   Thu, 13 Jul 2023 12:32:46 +0800
Message-Id: <20230713043248.41315-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are follow-up patches on this discussion:

https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com

I just summarized the ideas and code into a real patch series. Please
help to review and merge.

Change log:
v2:
 - Move "pg_size == 0" check out of the loop.
 - Rebase on the top of v6.5-rc1.

v1: https://lore.kernel.org/linux-iommu/20230607035145.343698-1-baolu.lu@linux.intel.com/

Best regards,
baolu

Lu Baolu (2):
  iommu: Prevent RESV_DIRECT devices from blocking domains
  iommu/vt-d: Remove rmrr check in domain attaching device path

 include/linux/iommu.h       |  2 ++
 drivers/iommu/intel/iommu.c | 58 -------------------------------------
 drivers/iommu/iommu.c       | 37 ++++++++++++++++-------
 3 files changed, 29 insertions(+), 68 deletions(-)

-- 
2.34.1

