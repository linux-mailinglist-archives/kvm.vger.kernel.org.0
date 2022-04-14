Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDC500B71
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242459AbiDNKtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242060AbiDNKth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EF7237C8
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933233; x=1681469233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8R8kN5Bu9OPLz5yK28BftrdZsFf6rfmLlwn/OnqjUE=;
  b=LaSkHsrZ+HwKi84mm8JIwLDM+CSrr2uACsNaHSRYnweNG1Y+m3eyR5B+
   IJmncOEA4mxRvj8ow0EHgnX3v2D2aF7j+R8+asUUG29g37yyr40zuxpod
   eMY9m+hTouzp0WNYr2PDDLjh7/Njx27I5RVaMaOqDQgi3eWW69nbUDYmK
   1w8KORY7zw3PfsWYAGO2KA5JajxZXC4vQXkRofDhdz5AflQP8I/Fs0I08
   TyYSKDineBjWm9ak5qyjTHQ2YiVr/XON5qu8YDwIzArIdlL/5oDDYyXYj
   KBWoOKxfiOjlAXenuF8gmihPdHI6uFkJMt6l8tnJugYH7QDer2bkDRrZK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808662"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808662"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091185"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:12 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 03/18] hw/vfio/pci: fix vfio_pci_hot_reset_result trace point
Date:   Thu, 14 Apr 2022 03:46:55 -0700
Message-Id: <20220414104710.28534-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Properly output the errno string.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 67a183f17b..e26e65bb1f 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2337,7 +2337,7 @@ static int vfio_pci_hot_reset(VFIOPCIDevice *vdev, bool single)
     g_free(reset);
 
     trace_vfio_pci_hot_reset_result(vdev->vbasedev.name,
-                                    ret ? "%m" : "Success");
+                                    ret ? strerror(errno) : "Success");
 
 out:
     /* Re-enable INTx on affected devices */
-- 
2.27.0

