Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93629C4E4
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823657AbgJ0R7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:59:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:34126 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1823203AbgJ0R6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:58:11 -0400
IronPort-SDR: fW7T60hx1U28IPgMbQ/ufL/NsJsLrDr8h6qOpKkB5QSrnKFjB6eeDphAXriX73rCczz297b1SU
 KEzTXfMmJZLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="168230686"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="168230686"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:58:10 -0700
IronPort-SDR: pVBI96o6WMqJ6mq5a8oXe8bATKbSaxP/VCM1wYfH+mNa36hNrOtpMcv+1HKUfbt7UIprRLPVTs
 BcddLyFjzpHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="303841822"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 27 Oct 2020 10:58:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E4DE0179; Tue, 27 Oct 2020 19:58:06 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-usb@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v1 1/5] driver core: platform: Introduce platform_get_mem_or_io_resource()
Date:   Tue, 27 Oct 2020 19:58:02 +0200
Message-Id: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are at least few existing users of the proposed API which
retrieves either MEM or IO resource from platform device.

Make it common to utilize in the existing and new users.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Peng Hao <peng.hao2@zte.com.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/platform_device.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 77a2aada106d..eb8d74744e29 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -52,6 +52,19 @@ extern struct device platform_bus;
 
 extern struct resource *platform_get_resource(struct platform_device *,
 					      unsigned int, unsigned int);
+static inline
+struct resource *platform_get_mem_or_io_resource(struct platform_device *pdev,
+						 unsigned int num)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, num);
+	if (res)
+		return res;
+
+	return platform_get_resource(pdev, IORESOURCE_IO, num);
+}
+
 extern struct device *
 platform_find_device_by_driver(struct device *start,
 			       const struct device_driver *drv);
-- 
2.28.0

