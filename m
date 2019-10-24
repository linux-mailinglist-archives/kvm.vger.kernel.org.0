Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FBE29C5
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437468AbfJXFIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437457AbfJXFIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627654"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:38 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 4/6] Documentation/driver-api/vfio-mediated-device.rst: Update for vfio/mdev aggregation support
Date:   Thu, 24 Oct 2019 13:08:27 +0800
Message-Id: <20191024050829.4517-5-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update vfio/mdev doc on new "aggregate" create parameter, new "aggregation"
attribute and "aggregated_instances" attribute for mdev device.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 .../driver-api/vfio-mediated-device.rst       | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..2881be654516 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -216,6 +216,7 @@ Directories and files under the sysfs for Each Physical Device
   |          |--- available_instances
   |          |--- device_api
   |          |--- description
+  |          |--- <aggregation>
   |          |--- [devices]
 
 * [mdev_supported_types]
@@ -260,6 +261,21 @@ Directories and files under the sysfs for Each Physical Device
   This attribute should show brief features/description of the type. This is
   optional attribute.
 
+* <aggregation>
+
+  <aggregation> is an optional attributes to show maximum number that the
+  instance resources of [<type-id>] can be aggregated to be assigned
+  for one mdev device. No <aggregation> attribute means driver doesn't
+  support to aggregate instance resoures for one mdev device.
+
+  Set number of instances by appending "aggregate=N" parameter for
+  create attribute. By default without "aggregate=N" parameter it
+  will create one instance as normal.
+
+Example::
+
+	# echo "<uuid>,aggregate=N" > create
+
 Directories and Files Under the sysfs for Each mdev Device
 ----------------------------------------------------------
 
@@ -268,6 +284,7 @@ Directories and Files Under the sysfs for Each mdev Device
   |- [parent phy device]
   |--- [$MDEV_UUID]
          |--- remove
+         |--- <aggregated_instances>
          |--- mdev_type {link to its type}
          |--- vendor-specific-attributes [optional]
 
@@ -281,6 +298,12 @@ Example::
 
 	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
 
+* <aggregated_instances> (read only)
+
+For mdev created with aggregate parameter, this shows number of
+instances assigned for this mdev. For normal type this attribute will
+not exist.
+
 Mediated device Hot plug
 ------------------------
 
-- 
2.24.0.rc0

