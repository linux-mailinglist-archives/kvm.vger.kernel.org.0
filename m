Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89796F0AFE
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244555AbjD0Rg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbjD0Rg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E823A82;
        Thu, 27 Apr 2023 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616986; x=1714152986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UvHuLF1vNIYR0OWCHchmVeakk9WbW07/wvEcKt6JI3M=;
  b=Nrv9pMP6yyThauizXPZLNMh8cN+fq78e70v4b50fOSOV3hrcMJMLPOAL
   GzfhSLTOgfOMPxx8Rp174w0qzglV5NduGZaaZkfVFTNm7cYt98vs6vhzt
   uo7S2UoN2p4yCZCFGzM2l2uzZLZgfniYd92H6vPfTwxXhlWtqb+ySKNYf
   uhb0RLE9yhAveMbXnpZjAOAru8EnxxNF7hs2d0kvu7+2kbc2mP6bXRo3z
   rYO1861IgqMQ3MX0d35m+4gJYT5kRHvAmSCnOsKFSs+f6qb1HPosbFQlH
   hwW9XpHkdUYmPMgx0+X5XG+98UadK/ucD9t6n2PZX0fDTCjx2oBFIfErd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496922"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496922"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172990"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172990"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:21 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 08/11] vfio/pci: Use bitfield for struct vfio_pci_core_device flags
Date:   Thu, 27 Apr 2023 10:36:05 -0700
Message-Id: <42397f8cd0419694797c6c5cf65ed715117fc760.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct vfio_pci_core_device contains eleven boolean flags.
Boolean flags clearly indicate their usage but space usage
starts to be a concern when there are many.

An upcoming change adds another boolean flag to
struct vfio_pci_core_device, thereby increasing the concern
that the boolean flags are consuming unnecessary space.

Transition the boolean flags to use bitfields. On a system that
uses one byte per boolean this reduces the space consumed
by existing flags from 11 bytes to 2 bytes with room for
a few more flags without increasing the structure's size.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V3:
- New patch. (Jason)

 include/linux/vfio_pci_core.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 148fd1ae6c1c..adb47e2914d7 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -68,17 +68,17 @@ struct vfio_pci_core_device {
 	u16			msix_size;
 	u32			msix_offset;
 	u32			rbar[7];
-	bool			pci_2_3;
-	bool			virq_disabled;
-	bool			reset_works;
-	bool			extended_caps;
-	bool			bardirty;
-	bool			has_vga;
-	bool			needs_reset;
-	bool			nointx;
-	bool			needs_pm_restore;
-	bool			pm_intx_masked;
-	bool			pm_runtime_engaged;
+	bool			pci_2_3:1;
+	bool			virq_disabled:1;
+	bool			reset_works:1;
+	bool			extended_caps:1;
+	bool			bardirty:1;
+	bool			has_vga:1;
+	bool			needs_reset:1;
+	bool			nointx:1;
+	bool			needs_pm_restore:1;
+	bool			pm_intx_masked:1;
+	bool			pm_runtime_engaged:1;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.34.1

