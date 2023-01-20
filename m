Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A3D675447
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjATMUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjATMUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:20:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD9F8B303
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 04:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674217242; x=1705753242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Tgo1gQ7gSdxjO4L2CZmSW0g/1s7bejNlbjGJMrJ3PDQ=;
  b=mcRxKTH3deMlfQSD7ZtaX0fP9S3UaZO3z7qJ3moNaCYoHKat92XF8nrf
   q1SJ5LexgUt7AdvFVa5eRC89LQW9EOOBNLuyN00MEjsm5aJ/PzazgOTeW
   R+7D78DSIP4LA0CYRARbnWDhSln/rk0JjBgRXnDYGUHNuggFrprdhqWpl
   jBdhiKGzFm8wpEKPLm3VlkUxig2nW8zuJS6GF77eFxV0s5Gx2SqH8F4Tz
   VfANU/TM2oY4X37cvuH2jRIkHYVPcIEVzq08bm+F2ydvzhhyaRmPiZVds
   vEYYVK+wS7F4br+FdTCpEZuuobGQoynmEeXihMhBZHX0erdztmc7FHcbe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323257796"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="323257796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 04:20:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834395473"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="834395473"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga005.jf.intel.com with ESMTP; 20 Jan 2023 04:20:41 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com, kevin.tian@intel.com
Cc:     yi.l.liu@intel.com, kvm@vger.kernel.org, iommu@lists.linux.dev
Subject: [PATCH v2] iommufd: Add three missing structures in ucmd_buffer
Date:   Fri, 20 Jan 2023 04:20:40 -0800
Message-Id: <20230120122040.280219-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct iommu_ioas_copy, struct iommu_option and struct iommu_vfio_ioas
are missed in ucmd_buffer. Although they are smaller than the size of
ucmd_buffer, it is safer to list them in ucmd_buffer explicitly.

Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
v2:
  - add iommu_ioas_copy as KevinT pointed

v1: https://lore.kernel.org/kvm/20230120055757.67879-1-yi.l.liu@intel.com/

 drivers/iommu/iommufd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 083e6fcbe10a..3fbe636c3d8a 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -252,9 +252,12 @@ union ucmd_buffer {
 	struct iommu_destroy destroy;
 	struct iommu_ioas_alloc alloc;
 	struct iommu_ioas_allow_iovas allow_iovas;
+	struct iommu_ioas_copy ioas_copy;
 	struct iommu_ioas_iova_ranges iova_ranges;
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
+	struct iommu_option option;
+	struct iommu_vfio_ioas vfio_ioas;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
-- 
2.34.1

