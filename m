Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB5500B7D
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242516AbiDNKuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242496AbiDNKuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:50:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555A47EA37
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933264; x=1681469264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0P3OalrBHnBhU01QF07hMbsmlYmh/io4cNMn4gf855E=;
  b=H8Y1EW6PN049zY1RvP8P2VXV/EKxilMjiczvnr1UrGRJguA2vZXaZhyu
   crJQonGcuyb1eMZ6l0Td8eBqrTc4UFu6DCJ/lZ+QFc02IICOoajmWZECP
   fqhHotLAAKX49+idbYhA6CorYGuuXhRjrLmxlzx44K/ANxHvz9XdkhmrW
   BYxslBMEgK4VoVhcrNInw4Q270eyyFbNPT7aOGNLDFt8loSUdsxqSO7CH
   iLsbIfTWJna1f/JLhJMX+lXE6Yhc1BAHKP6HV33VzagO34eCVfRK1dtOy
   UJxKIaAKeq4MSj9KwILlE6pb3/mHOE1Qjz3DdB1CUydYCBDlj22wDGhF1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808704"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808704"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091268"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:25 -0700
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
Subject: [RFC 18/18] vfio/pci: Add an iommufd option
Date:   Thu, 14 Apr 2022 03:47:10 -0700
Message-Id: <20220414104710.28534-19-yi.l.liu@intel.com>
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

This auto/on/off option allows the user to force a the select
the iommu BE (iommufd or legacy).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/pci.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index cf5703f94b..70a4c2b0a8 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -42,6 +42,8 @@
 #include "qapi/error.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file.h"
+#include "qapi/visitor.h"
+#include "qapi/qapi-visit-common.h"
 
 #define TYPE_VFIO_PCI_NOHOTPLUG "vfio-pci-nohotplug"
 
@@ -3246,6 +3248,26 @@ static Property vfio_pci_dev_properties[] = {
     DEFINE_PROP_END_OF_LIST(),
 };
 
+static void get_iommu_be(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(obj);
+    VFIODevice *vbasedev = &vdev->vbasedev;
+    OnOffAuto iommufd_be = vbasedev->iommufd_be;
+
+    visit_type_OnOffAuto(v, name, &iommufd_be, errp);
+}
+
+static void set_iommu_be(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(obj);
+    VFIODevice *vbasedev = &vdev->vbasedev;
+
+    visit_type_OnOffAuto(v, name, &vbasedev->iommufd_be, errp);
+}
+
+
 static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
@@ -3253,6 +3275,10 @@ static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
 
     dc->reset = vfio_pci_reset;
     device_class_set_props(dc, vfio_pci_dev_properties);
+    object_class_property_add(klass, "iommufd", "OnOffAuto",
+                              get_iommu_be, set_iommu_be, NULL, NULL);
+    object_class_property_set_description(klass, "iommufd",
+                                          "Enable iommufd backend");
     dc->desc = "VFIO-based PCI device assignment";
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     pdc->realize = vfio_realize;
-- 
2.27.0

