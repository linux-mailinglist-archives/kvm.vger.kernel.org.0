Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCB075EB35
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjGXGF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 02:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGXGFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 02:05:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24464CF;
        Sun, 23 Jul 2023 23:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690178755; x=1721714755;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vylbDBiUo92wTd3+gPFxJnLpv6qYxlLpsvd6wc9dEQI=;
  b=R65RzQj9ByzhnP5ukT4nufVqmcaXm8ocE5FOS7vbVtmb7e2xK2pHNNZ5
   bvxc6l8JKG8bfgRiy742cTFsRDu2fAULHEp4+p7mhFRNnU7LafKw7gME3
   8/Wq5WPFKBFONd6s7a8nOz8y88UTxe7l/TiS6FVW27GJ5MjUeUy+kr7ze
   d7qyu53w06tECp9VSX1U8049Osj1xtEWRK6c5Jks/Y2r+NmOkD3pbnIfF
   9+cpLj2C6hybchv6YQ1Pr4lYCc6ZgfUowir8zKdtv4ijprtREUhF1ueFy
   BU7P8TLgukpkP1ba70DTtdOnjXkqyT5AGr9c38YEeLHmS6Ums7HwGoQm8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="346955240"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="346955240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:05:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="972134565"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="972134565"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2023 23:05:52 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 0/2] Prevent RESV_DIRECT devices from user assignment
Date:   Mon, 24 Jul 2023 14:03:50 +0800
Message-Id: <20230724060352.113458-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
v3:
 - Rename "requires_direct" to "require_direct".
 - Refine some comments.
 - Rebase on the top of iommu next branch.

v2: https://lore.kernel.org/linux-iommu/20230713043248.41315-1-baolu.lu@linux.intel.com/
 - Move "pg_size == 0" check out of the loop.
 - Rebase on the top of v6.5-rc1.

v1: https://lore.kernel.org/linux-iommu/20230607035145.343698-1-baolu.lu@linux.intel.com/

Lu Baolu (2):
  iommu: Prevent RESV_DIRECT devices from blocking domains
  iommu/vt-d: Remove rmrr check in domain attaching device path

 include/linux/iommu.h       |  2 ++
 drivers/iommu/intel/iommu.c | 58 -------------------------------------
 drivers/iommu/iommu.c       | 37 ++++++++++++++++-------
 3 files changed, 29 insertions(+), 68 deletions(-)

-- 
2.34.1

