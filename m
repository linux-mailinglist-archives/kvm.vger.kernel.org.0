Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289008FEFC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfHPJ0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 05:26:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36017 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfHPJ0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 05:26:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so3515522wme.1;
        Fri, 16 Aug 2019 02:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VCBC1nHkile48mY94V95RJMwkkBLR3LBIagBpciu5yg=;
        b=WEUufkhsfmFdyCCPtGxHwjQbtuNVK1POWA9rFO5ONgaVRpSAuiDG6DBYb5ctpUis9A
         WneOxogDdo2UXlmVJ7/3inwF8RSyhWA3Cp0FmZeuS4N+Br7Y9RUet5a17ih4OztKfKW4
         2+kvW6c23NvOKH4t2U/3MqSsgyTmVz73dxqoHaMjUAA7hxogmkWDfZ6+M3KWtvABku1a
         j/JYnqXCmGZv55+uBu5Ci2fQCdbxP032y/LEEQujBdvLfDugqOrGvg8BBYbfAdHVFy5w
         o9yXoCepgZT2jtUYIiWHp6zH9JQAudvBKppuquAROQVs4UucTxCjbrS37wAGPfhvtniQ
         Yr9Q==
X-Gm-Message-State: APjAAAX1N1bzv+/1aPdUHXUjJYLLvf8Vq1Cltfxdkgbp/FiZYAw/HPF2
        V+cR1AVAEoRKoWelEhtdxDA=
X-Google-Smtp-Source: APXvYqw28sA05m0NJBVJdOHWxcsf+e6ETT/4+J9XklzzECtokBSPpk/j2HBhAcXCsE6EfVpjW0JZKQ==
X-Received: by 2002:a1c:630b:: with SMTP id x11mr6225403wmb.135.1565947581534;
        Fri, 16 Aug 2019 02:26:21 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id q20sm16521138wrc.79.2019.08.16.02.26.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 02:26:21 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] vfio_pci: Loop using PCI_STD_NUM_BARS
Date:   Fri, 16 Aug 2019 12:24:35 +0300
Message-Id: <20190816092437.31846-9-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816092437.31846-1-efremov@linux.com>
References: <20190816092437.31846-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor loops to use 'i < PCI_STD_NUM_BARS' instead of
'i <= PCI_STD_RESOURCE_END'.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/vfio/pci/vfio_pci.c         | 11 +++++++----
 drivers/vfio/pci/vfio_pci_config.c  | 10 ++++++----
 drivers/vfio/pci/vfio_pci_private.h |  4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 703948c9fbe1..cb7d220d3246 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -110,13 +110,15 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 {
 	struct resource *res;
-	int bar;
+	int i;
 	struct vfio_pci_dummy_resource *dummy_res;
 
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 
-	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
-		res = vdev->pdev->resource + bar;
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		int bar = i + PCI_STD_RESOURCES;
+
+		res = &vdev->pdev->resource[bar];
 
 		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
 			goto no_mmap;
@@ -399,7 +401,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vfio_config_free(vdev);
 
-	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		bar = i + PCI_STD_RESOURCES;
 		if (!vdev->barmap[bar])
 			continue;
 		pci_iounmap(pdev, vdev->barmap[bar]);
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd8444c..df8772395219 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -455,16 +455,18 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 
 	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
 
-	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
-		if (!pci_resource_start(pdev, i)) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++, bar++) {
+		int ibar = i + PCI_STD_RESOURCES;
+
+		if (!pci_resource_start(pdev, ibar)) {
 			*bar = 0; /* Unmapped by host = unimplemented to user */
 			continue;
 		}
 
-		mask = ~(pci_resource_len(pdev, i) - 1);
+		mask = ~(pci_resource_len(pdev, ibar) - 1);
 
 		*bar &= cpu_to_le32((u32)mask);
-		*bar |= vfio_generate_bar_flags(pdev, i);
+		*bar |= vfio_generate_bar_flags(pdev, ibar);
 
 		if (*bar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
 			bar++;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ee6ee91718a4..8a2c7607d513 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -86,8 +86,8 @@ struct vfio_pci_reflck {
 
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
-	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
-	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
+	void __iomem		*barmap[PCI_STD_NUM_BARS];
+	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
 	u8			*pci_config_map;
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
-- 
2.21.0

