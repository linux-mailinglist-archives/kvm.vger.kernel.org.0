Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D88B4256
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 22:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfIPUrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 16:47:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52034 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbfIPUrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 16:47:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so797937wme.1;
        Mon, 16 Sep 2019 13:47:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLQPAYHUACHzoMzXgGl4aMEibp9KP46d8BzQG7n7Uds=;
        b=hm760oHm3uMSkpxZuRLuBvLrNOeyALAfldCHV1fv5zO0kMAXr9Vg6hYrsMdJdxoRRl
         iP6pAOxGvvtlypfAf2m7olv+nkopteVT9K+4DmxuEk9fiqTvK3nxkyJUgDkftAhnsp+7
         MTdVWhQDxmHCErYb4N8ZLbjNgLmUMnFb4rt64Z91GLefd9s29iKGvWOzuJHVv44bHpdX
         GxD+ae5EtGMO2r3hDnkwAd1oFNhWqPBRR6tDgtxGT1tdXJFTmyC9WzFVFiE+fpxvIb33
         GkXCRUwxzk2+GGBSw8/O3BwWqTFYB0r5Y0B1yQEo8jrk3kJPt6VzHyCjGiD+po34nnbM
         UJrA==
X-Gm-Message-State: APjAAAWxnD8kmzyWvIZZ/C27SIeqs74z95hA9Y6o8Gai+YdUJxuqIikx
        ukCGvDPrzT03bbDL++sAUaw=
X-Google-Smtp-Source: APXvYqxISkd0F2RDS0tk8mctmfGj06rkked0k46A5N+m1h5H/Qt5p0hKECOmJeL+5l43LAR/maBo9Q==
X-Received: by 2002:a1c:dd0a:: with SMTP id u10mr674534wmg.100.1568666847741;
        Mon, 16 Sep 2019 13:47:27 -0700 (PDT)
Received: from black.home (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id x6sm231437wmf.38.2019.09.16.13.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 13:47:27 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 17/26] vfio_pci: Loop using PCI_STD_NUM_BARS
Date:   Mon, 16 Sep 2019 23:41:49 +0300
Message-Id: <20190916204158.6889-18-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916204158.6889-1-efremov@linux.com>
References: <20190916204158.6889-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor loops to use idiomatic C style and avoid the fencepost error
of using "i < PCI_STD_RESOURCE_END" when "i <= PCI_STD_RESOURCE_END"
is required, e.g., commit 2f686f1d9bee ("PCI: Correct PCI_STD_RESOURCE_END
usage").

To iterate through all possible BARs, loop conditions changed to the
*number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
valid BAR "i <= PCI_STD_RESOURCE_END".

Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/vfio/pci/vfio_pci.c         | 11 ++++++----
 drivers/vfio/pci/vfio_pci_config.c  | 32 +++++++++++++++--------------
 drivers/vfio/pci/vfio_pci_private.h |  4 ++--
 3 files changed, 26 insertions(+), 21 deletions(-)

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
index f0891bd8444c..90c0b80f8acf 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -450,30 +450,32 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
-	__le32 *bar;
+	__le32 *vbar;
 	u64 mask;
 
-	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
+	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
 
-	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
-		if (!pci_resource_start(pdev, i)) {
-			*bar = 0; /* Unmapped by host = unimplemented to user */
+	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {
+		int bar = i + PCI_STD_RESOURCES;
+
+		if (!pci_resource_start(pdev, bar)) {
+			*vbar = 0; /* Unmapped by host = unimplemented to user */
 			continue;
 		}
 
-		mask = ~(pci_resource_len(pdev, i) - 1);
+		mask = ~(pci_resource_len(pdev, bar) - 1);
 
-		*bar &= cpu_to_le32((u32)mask);
-		*bar |= vfio_generate_bar_flags(pdev, i);
+		*vbar &= cpu_to_le32((u32)mask);
+		*vbar |= vfio_generate_bar_flags(pdev, bar);
 
-		if (*bar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
-			bar++;
-			*bar &= cpu_to_le32((u32)(mask >> 32));
+		if (*vbar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
+			vbar++;
+			*vbar &= cpu_to_le32((u32)(mask >> 32));
 			i++;
 		}
 	}
 
-	bar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
+	vbar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
 
 	/*
 	 * NB. REGION_INFO will have reported zero size if we weren't able
@@ -483,14 +485,14 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
 		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
 		mask |= PCI_ROM_ADDRESS_ENABLE;
-		*bar &= cpu_to_le32((u32)mask);
+		*vbar &= cpu_to_le32((u32)mask);
 	} else if (pdev->resource[PCI_ROM_RESOURCE].flags &
 					IORESOURCE_ROM_SHADOW) {
 		mask = ~(0x20000 - 1);
 		mask |= PCI_ROM_ADDRESS_ENABLE;
-		*bar &= cpu_to_le32((u32)mask);
+		*vbar &= cpu_to_le32((u32)mask);
 	} else
-		*bar = 0;
+		*vbar = 0;
 
 	vdev->bardirty = false;
 }
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

