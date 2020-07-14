Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7149421E84D
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGNGhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:37:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:13263 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgGNGhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:37:00 -0400
IronPort-SDR: nNBMfrlxa7/jZm5mbrDH5UcvIKtAg/A5BIz+t1AXjXVPwxzHNXGpIYIVdd8RiG6/A21asmcNjZ
 EQ9utvaJ1mDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="210355854"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="210355854"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:37:00 -0700
IronPort-SDR: X3VJoRwKlecuM927C3LobPEYIu+COs3PUs3wDIfCoX79xngEsRZJ5vZBnevAkEIrWWkMYE/jHo
 qGd2IUUdZO8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="299435571"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 23:36:56 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 5/5] crypto: qat - use PCI_VDEVICE
Date:   Tue, 14 Jul 2020 07:36:10 +0100
Message-Id: <20200714063610.849858-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
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

