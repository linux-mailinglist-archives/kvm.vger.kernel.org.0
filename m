Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0869ECC7
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 03:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjBVCWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 21:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBVCWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 21:22:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D524CB7
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 18:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677032567; x=1708568567;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/QA91mH/btSH3sc+TIsxUUnzwCP/67YRXnt1q72i+lg=;
  b=ZfN3Yi9wFFzjWq1PhX3mIlTH2a7mOAeHC3P1iPBMObjH3LIyC9uAjxfW
   IkKhCWIdCbBhq4A7cs9xxp1lo/kHTQGjFRFX19by8x4G/x9HGJPes/QiB
   sNfMXUwp4ceeDcMvKAaVT5B3wO0qP51fwmPx9V6V/4X826wrw70u6SntP
   XJODT64r3eQw03PVZqpjgF9UbvHiAO8+YZ/1rPSH0bjU9uBQI1WbAlc4I
   ffbgdoZhLoRUQl9QJIpQkZak8/u985kVo9DJQ4/9fgfjWyK5cwJ7N6CZV
   Va6roONYgGDFy7hooMdwcgj4smRVSgxp9JB5R24PMNIHPbUx5h5tDGy+J
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="312438961"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="312438961"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 18:22:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="795725831"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="795725831"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga004.jf.intel.com with ESMTP; 21 Feb 2023 18:22:33 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, pbonzini@redhat.co
Subject: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD before VFIO_GROUP_GET_DEVICE_FD
Date:   Tue, 21 Feb 2023 18:22:31 -0800
Message-Id: <20230222022231.266381-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

as some vfio_device drivers require a kvm pointer to be set in their
open_device and kvm pointer is set to VFIO in GROUP_ADD path.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
v2:
 - Adopt Alex's suggestion
v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
---
 Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
index 2d20dc561069..79b6811bb4f3 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
 	- @groupfd is a file descriptor for a VFIO group;
 	- @tablefd is a file descriptor for a TCE table allocated via
 	  KVM_CREATE_SPAPR_TCE.
+
+::
+
+The GROUP_ADD operation above should be invoked prior to accessing the
+device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
+drivers which require a kvm pointer to be set in their .open_device()
+callback.
-- 
2.34.1

