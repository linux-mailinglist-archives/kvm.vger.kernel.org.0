Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7010E2109F8
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 13:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgGALDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 07:03:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:29889 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbgGALDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 07:03:48 -0400
IronPort-SDR: asJaAkLjyOSEEz6u1GWVTssiUyFivVVLoggQjXUXv4YlkhURPTnOXMIyF0G7ZfxGMFYWoWgjSn
 Io7voRAnFVhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="126632458"
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="126632458"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 04:03:47 -0700
IronPort-SDR: ClRWOQP56fgcGEJMfeS8FwppZy345xzH8yP7pfKIZcTyVoj4r65AK8jgMzCDYMWzbCICK3uesi
 1w4gROiAKq6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="425557294"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga004.jf.intel.com with ESMTP; 01 Jul 2020 04:03:44 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 5/5] crypto: qat - use PCI_VDEVICE
Date:   Wed,  1 Jul 2020 12:03:02 +0100
Message-Id: <20200701110302.75199-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
References: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Build pci_device_id structure using the PCI_VDEVICE macro.
This removes any references to the ADF_SYSTEM_DEVICE macro.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 7 ++-----
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 7 ++-----
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 7 ++-----
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 7 ++-----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 7 ++-----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 7 ++-----
 6 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index bba0f142f7f6..43929d70c41d 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c3xxx_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index b77a58886599..dca52de22e8d 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c3xxxvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 722838ff03be..f104c9d1195d 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c62x_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index a766cc18aae9..e0b909e70712 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_c62xvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_C62X_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4c3aea07f444..857aa4c8595f 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_dh895xcc_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 673348ca5dea..2987855a70dc 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -18,12 +18,9 @@
 #include <adf_cfg.h>
 #include "adf_dh895xccvf_hw_data.h"
 
-#define ADF_SYSTEM_DEVICE(device_id) \
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
-
 static const struct pci_device_id adf_pci_tbl[] = {
-	ADF_SYSTEM_DEVICE(PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF),
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF), },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
-- 
2.26.2

