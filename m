Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDEF22C12D
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGXIs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:48:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:45604 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgGXIs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:48:26 -0400
IronPort-SDR: pIDhLSUNvR3EsaAQM80gDa6PXMxlsHXN4uHfBmwET5M/pMz4RAXVv0N58CiVzzKOBeN+q+RF/S
 creILAa2MCAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138742764"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="138742764"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 01:48:26 -0700
IronPort-SDR: V8R8aOVSxL34PFSmEt7k2xbNrpYQn1Ioqrjhl6IVcY6BvWdjAR1TFItSUUy7NE1K+QFgvZGrRg
 1QIdn+Bg0JEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="311335322"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2020 01:48:23 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 5/5] crypto: qat - use PCI_VDEVICE
Date:   Fri, 24 Jul 2020 09:48:00 +0100
Message-Id: <20200724084800.6136-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
References: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
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

