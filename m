Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8ED1A1BA9
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgDHF63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:58:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:43466 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDHF63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:58:29 -0400
IronPort-SDR: eQMh8CX4I8bzM8le9XYsNkJkduEnQQ1bIlcduR6phn32t1pprFmG8cBVFIn8ubw9Dx0o5Qjbir
 2sLWDlJ5t0BQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 22:58:28 -0700
IronPort-SDR: nigPgWNZ4HNvtX3+5bC0TRUwPQav0GP4vhUeO2QxmnWEU0zKC8QvU3RwW2r3XytmLQrmZZvWtE
 cG7gw2j3TKXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="286448333"
Received: from jianli5-mobl2.ccr.corp.intel.com (HELO dell-xps.ccr.corp.intel.com) ([10.249.173.130])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2020 22:58:27 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, "Jiang, Dave" <dave.jiang@intel.com>
Subject: [PATCH v3 1/2] Documentation/driver-api/vfio-mediated-device.rst: update for aggregation support
Date:   Wed,  8 Apr 2020 13:58:23 +0800
Message-Id: <20200408055824.2378-2-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326054136.2543-1-zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update doc for mdev aggregation support. Describe mdev generic
parameter directory under mdev device directory.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 .../driver-api/vfio-mediated-device.rst       | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..fcc031adcf63 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -269,6 +269,9 @@ Directories and Files Under the sysfs for Each mdev Device
   |--- [$MDEV_UUID]
          |--- remove
          |--- mdev_type {link to its type}
+         |--- mdev [optional]
+	     |--- aggregated_instances [optional]
+	     |--- max_aggregation [optional]
          |--- vendor-specific-attributes [optional]
 
 * remove (write only)
@@ -281,6 +284,25 @@ Example::
 
 	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
 
+* mdev directory (optional)
+
+Vendor driver could create mdev directory to specify extra generic parameters
+on mdev device by its type. Currently aggregation parameters are defined.
+Vendor driver should provide both items to support.
+
+1) aggregated_instances (read/write)
+
+Set target aggregated instances for device. Reading will show current
+count of aggregated instances. Writing value larger than max_aggregation
+would fail and return error. Multiple writes could be done to adjust the
+setting but ensure to not exceed max_aggregation. Normally write won't
+be success after device open.
+
+2) max_aggregation (read only)
+
+Show maxium allowed instances which can be aggregated for this device. Maxium
+aggregation could be dynamic changed by vendor driver.
+
 Mediated device Hot plug
 ------------------------
 
-- 
2.25.1

