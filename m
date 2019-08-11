Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9924A8923F
	for <lists+kvm@lfdr.de>; Sun, 11 Aug 2019 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfHKPKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Aug 2019 11:10:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33365 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfHKPKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Aug 2019 11:10:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so102614582wru.0;
        Sun, 11 Aug 2019 08:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvL0w/RrWzCXmEqGtiPSbyCPgpLUV0eBfGdylB2j+qE=;
        b=CLzcbNGvwl9aPNKORIzGoCSyJPRTTIBLGJs8OAJKGg2pCfzOKAn7KKXwrMa3jdJuln
         pNe+nYY+fREDZEVjonjvbC5OkQ8uJYiPn9yw3ucd8agyuPL7I6FlvL/yduM4Z3J0qw5d
         po/wAIZk0WFNVNWshwuVreIuCFZPvU17rhWl8cLJ7pboEez1qxRCLZ+aGdR75N31/38K
         RYXhhKoOruptS34HOrlB8qpeuKL0cBoaJq+Uift5dSll3nMsrDMQIoh464juyaP3GWGi
         4X/Uni57EilSwZzsXTrh7GvjEwYaEp4CJ+5rz+7+RqHVVZgqlmYD77US7FvBknNEAIv4
         WgsA==
X-Gm-Message-State: APjAAAU0yWTDoc2AcxvV0lMEKeG8yS0PYXpCy46epvMv8MGzrtiwXzzY
        2sQWCW4BxT74nphpwVmGR6U=
X-Google-Smtp-Source: APXvYqyC1XseTJUsID4U0s2kw/P6UJNA5sVYJ6WdgeL+XNrPosY9yRULJaidsX4driYK6FPd5RYWNw==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr22816979wri.218.1565536251573;
        Sun, 11 Aug 2019 08:10:51 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id y16sm227049408wrg.85.2019.08.11.08.10.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:10:51 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] vfio_pci: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
Date:   Sun, 11 Aug 2019 18:08:04 +0300
Message-Id: <20190811150802.2418-8-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811150802.2418-1-efremov@linux.com>
References: <20190811150802.2418-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactors the loop condition scheme from
'i <= PCI_STD_RESOURCE_END' to 'i < PCI_STD_NUM_BARS'.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/vfio/pci/vfio_pci.c         | 4 ++--
 drivers/vfio/pci/vfio_pci_config.c  | 2 +-
 drivers/vfio/pci/vfio_pci_private.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 703948c9fbe1..13f5430e3f3c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -115,7 +115,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 
-	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
+	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
 		res = vdev->pdev->resource + bar;
 
 		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
@@ -399,7 +399,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vfio_config_free(vdev);
 
-	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
+	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
 		if (!vdev->barmap[bar])
 			continue;
 		pci_iounmap(pdev, vdev->barmap[bar]);
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd8444c..6035a2961160 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -455,7 +455,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 
 	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
 
-	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++, bar++) {
 		if (!pci_resource_start(pdev, i)) {
 			*bar = 0; /* Unmapped by host = unimplemented to user */
 			continue;
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

