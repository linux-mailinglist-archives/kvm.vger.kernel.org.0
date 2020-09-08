Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B00260BC0
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgIHHSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:18:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:30606 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgIHHSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:18:15 -0400
IronPort-SDR: +5hr4C9uP+aTZfLMkLPgtox2Zb0RtjaKTJYl6v5jMfcCuspBCCqZm/uI7RYVthehR00zyeMa4q
 xGX/98AprNCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="159058785"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="159058785"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 00:18:09 -0700
IronPort-SDR: 8JSwMJ6Tjug/3Tsn0DNYD/WMK5ydlgPjxoYidbQBmcwW4Uf7eMF9cw/PgMI4uR/ao3qqcX18Id
 CskrK1evAVwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="448677754"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2020 00:18:07 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     mdf@kernel.org, alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-fpga@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>
Subject: [PATCH 3/3] Documentation: fpga: dfl: Add description for VFIO Mdev support
Date:   Tue,  8 Sep 2020 15:13:32 +0800
Message-Id: <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds description for VFIO Mdev support for dfl devices on
dfl bus.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
---
 Documentation/fpga/dfl.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
index 0404fe6..f077754 100644
--- a/Documentation/fpga/dfl.rst
+++ b/Documentation/fpga/dfl.rst
@@ -502,6 +502,26 @@ FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
 could be a reference.
 
 
+VFIO Mdev support for DFL devices
+=================================
+As we introduced a dfl bus for private features, they could be added to dfl bus
+as independent dfl devices. There is a requirement to handle these devices
+either by kernel drivers or by direct access from userspace. Usually we bind
+the kernel drivers to devices which provide board management functions, and
+gives user direct access to devices which cooperate closely with user
+controlled Accelerated Function Unit (AFU). We realize this with a VFIO Mdev
+implementation. When we bind the vfio-mdev-dfl driver to a dfl device, it
+realizes a group of callbacks and registers to the Mdev framework as a
+parent (physical) device. It could then create one (available_instances == 1)
+mdev device.
+Since dfl devices are sub devices of FPGA DFL physical devices (e.g. PCIE
+device), which provide no DMA isolation for each sub device, this may leads to
+DMA isolation problem if a private feature is designed to be capable of DMA.
+The AFU user could potentially access the whole device addressing space and
+impact the private feature. So now the general HW design rule is, no DMA
+capability for private features. It eliminates the DMA isolation problem.
+
+
 Open discussion
 ===============
 FME driver exports one ioctl (DFL_FPGA_FME_PORT_PR) for partial reconfiguration
-- 
2.7.4

