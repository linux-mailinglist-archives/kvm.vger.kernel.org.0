Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678C46FF65C
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbjEKPpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbjEKPpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:45:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABA459E6;
        Thu, 11 May 2023 08:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819901; x=1715355901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8QfQokLJef1Q3tFm7nj3VQwR9R1wsoZXkMCX5UZhwws=;
  b=BPNojPFC3PGuF7jA9DOxYrp/IK0Im2Yc7OlGDSoE8pXAj5cr6Q+j/7Ak
   Xfezzqdb5jBnbjDMJuC3C5pM1lXk1mtXPeBdJhBoMXBCcbZPpy/ROkyFg
   ruaCJYS4utdagSZg2zMQZeV6agfUMHoG8hd3l4ejiuqditARbQ6lArfWL
   EXHCHALL+D9+c7vNUumzfxuTIyGDbsCcIm/N6HdEs1HYbS7lQe/UHwXh0
   r5Ia3PcxiZr1ID5QNQQAqF8mw3+5I+BdhURa00JulqXHrCqQ6Shdkr0Ch
   /TMHDDyujC/KrCCEFpdFSA4AqYRioowUmRmoq2n59K5uuJqENAMpXG97W
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046685"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046685"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776242"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776242"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 08/11] vfio/pci: Use bitfield for struct vfio_pci_core_device flags
Date:   Thu, 11 May 2023 08:44:35 -0700
Message-Id: <cf34bf0499c889554a8105eeb18cc0ab673005be.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag. (Kevin)

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

