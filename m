Return-Path: <kvm+bounces-31749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCD49C6FA8
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C1DE1F21389
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8226D213EFB;
	Wed, 13 Nov 2024 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8/Nkeoi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D591720F5DD
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 12:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731501781; cv=none; b=f7U2H5CWyKPEUBGL8DQzgXOVEbzMjvc6FqBqkMZz1PjtUrW3JHMROTF1x3zFn0JJMnuEzvqoAeaNfm98VLvdzRo32ntXjpiWPtdYdTuPCfnP90pHUmfyjIPdrfg8oHgYayzPbhrKzXzud8cCLGpwKpv6glUSvtPMFvA+Hs5gPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731501781; c=relaxed/simple;
	bh=3bU4Fky5S+T5ZKdRjWv15RJoxK3LBV1shV2FamLl7eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcQia4pZPhuDuKIPrD2lll68GPlPImqx/+pAMUejq8cxSZvuL44yuLQSQUvOLwUqSE29hZTThkHv3MKt7GXg7qjYAPlNfL4SzYoptKQWp838HN/RxFBDBg34SC1gkykea9Ebez8oGWnRg5jCAazJI/iU5GXpz7NJszzZruAHbNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8/Nkeoi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731501778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vd9hh7PH7g9r1RCJwCwuck8xpSTmXt7A/cY6nKWhVMY=;
	b=h8/NkeoiobYep3hCFhM415xXSI8RQo+bZZsDOc9eYxqlzZwv3+Kp5lJLa96/UyI8lEyeAc
	CoxA0DUoEXOZx192vtUf4n9kMkdUsAC4AIX5AaqT7QbQ4mnsmfaEAya3U3noTcwtauSnG4
	f2xrTWUNWA/rBuhTRogb+rTT9LIHgiE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-vkYcJN2EOIOTR3pjtj_PYw-1; Wed, 13 Nov 2024 07:42:56 -0500
X-MC-Unique: vkYcJN2EOIOTR3pjtj_PYw-1
X-Mimecast-MFC-AGG-ID: vkYcJN2EOIOTR3pjtj_PYw
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d458087c0so439269f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 04:42:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731501775; x=1732106575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vd9hh7PH7g9r1RCJwCwuck8xpSTmXt7A/cY6nKWhVMY=;
        b=SV73L/vBLyWoSVntTVNNcc000i0QG7Tn7HTVmRVfqHK19T0VPnrfsSOr5a87ibYGG0
         rOX54ecOlCkOrLEyPpgcCWIaE5q9uyZGqRErFYh8Y8SvxiEHjMXNZ9aDA+lvCK5EAAIr
         gI9yGeoC5YYYkSdSIQdQb1fOBgz3M3vaTbtGbQFWbAG9EhAPVfS2sV2ga09WfKgbWBu2
         gspINpMjrvep99Gu9v2D0JSPiGvOV3lkYPXvRLwNVjwIjTBi1rVe2jxJqmUS7tDmSaQr
         8My0imxw/Hi9DF88kieX9NuwzGeN4OaeK2HOFPyt552sOCIdjBzwDA7K6vyRibc+UPqH
         AKag==
X-Forwarded-Encrypted: i=1; AJvYcCX2Bfy1WTsZ6YMofymUGegLFNpGvg4D8qu2t3f20XpB+jEWJx+Y0i6n2ryGJ0IL4chbRXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPnBPnZiNFj5Y+VIAv/UvW4IwnBx6ss2vIDRxc8bejsHh59aD6
	2nrTTcDLpOrGv6Jl7khLtE+/pbznTvC3iHW9bldt+R9PqNg7HdsZFF9kbq7RFZLfc75KeoDVkZ6
	LmcPGjC4rtefKRhFTT4jROuytB8UtLY2VvkduyUWM5Pa7oGyo6Q==
X-Received: by 2002:a5d:59a9:0:b0:37d:3780:31d2 with SMTP id ffacd0b85a97d-381f0f5e2c0mr15195852f8f.15.1731501775481;
        Wed, 13 Nov 2024 04:42:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7pOukOPMDH1wuk1i6Jiz8xlWOF0F0DNhl9nXwctJdSW8HPrAiyNLBY18f7vZ+XBFDhbQ0GA==
X-Received: by 2002:a5d:59a9:0:b0:37d:3780:31d2 with SMTP id ffacd0b85a97d-381f0f5e2c0mr15195814f8f.15.1731501774995;
        Wed, 13 Nov 2024 04:42:54 -0800 (PST)
Received: from eisenberg.redhat.com (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed99aa18sm18023528f8f.61.2024.11.13.04.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 04:42:54 -0800 (PST)
From: Philipp Stanner <pstanner@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rasesh Mody <rmody@marvell.com>,
	GR-Linux-NIC-Dev@marvell.com,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sanjay R Mehta <sanju.mehta@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mostafa Saleh <smostafa@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 11/11] Remove devres from pci_intx()
Date: Wed, 13 Nov 2024 13:41:59 +0100
Message-ID: <20241113124158.22863-13-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241113124158.22863-2-pstanner@redhat.com>
References: <20241113124158.22863-2-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_intx() is a hybrid function which can sometimes be managed through
devres. This hybrid nature is undesirable.

Since all users of pci_intx() have by now been ported either to
always-managed pcim_intx() or never-managed pci_intx_unmanaged(), the
devres functionality can be removed from pci_intx().

Consequently, pci_intx_unmanaged() is now redundant, because pci_intx()
itself is now unmanaged.

Remove the devres functionality from pci_intx(). Have all users of
pci_intx_unmanaged() call pci_intx(). Remove pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/misc/cardreader/rtsx_pcr.c            |  2 +-
 drivers/misc/tifm_7xx1.c                      |  6 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/ntb/hw/amd/ntb_hw_amd.c               |  4 +-
 drivers/ntb/hw/intel/ntb_hw_gen1.c            |  2 +-
 drivers/pci/devres.c                          |  4 +-
 drivers/pci/msi/api.c                         |  2 +-
 drivers/pci/msi/msi.c                         |  2 +-
 drivers/pci/pci.c                             | 43 +------------------
 drivers/vfio/pci/vfio_pci_core.c              |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             | 10 ++---
 drivers/xen/xen-pciback/conf_space_header.c   |  2 +-
 include/linux/pci.h                           |  1 -
 14 files changed, 22 insertions(+), 62 deletions(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index e25e6d560dd7..be3d4e0e50cc 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1057,7 +1057,7 @@ static int rtsx_pci_acquire_irq(struct rtsx_pcr *pcr)
 	}
 
 	pcr->irq = pcr->pci->irq;
-	pci_intx_unmanaged(pcr->pci, !pcr->msi_en);
+	pci_intx(pcr->pci, !pcr->msi_en);
 
 	return 0;
 }
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 5f9c7ccae8d2..1d54680d6ed2 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -327,7 +327,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 		goto err_out;
 	}
 
-	pci_intx_unmanaged(dev, 1);
+	pci_intx(dev, 1);
 
 	fm = tifm_alloc_adapter(dev->device == PCI_DEVICE_ID_TI_XX21_XX11_FM
 				? 4 : 2, &dev->dev);
@@ -368,7 +368,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 err_out_free:
 	tifm_free_adapter(fm);
 err_out_int:
-	pci_intx_unmanaged(dev, 0);
+	pci_intx(dev, 0);
 	pci_release_regions(dev);
 err_out:
 	if (!pci_dev_busy)
@@ -392,7 +392,7 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
 		tifm_7xx1_sock_power_off(tifm_7xx1_sock_addr(fm->addr, cnt));
 
 	iounmap(fm->addr);
-	pci_intx_unmanaged(dev, 0);
+	pci_intx(dev, 0);
 	pci_release_regions(dev);
 
 	pci_disable_device(dev);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2ae63d6e6792..678829646cec 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1669,7 +1669,7 @@ static void bnx2x_igu_int_enable(struct bnx2x *bp)
 	REG_WR(bp, IGU_REG_PF_CONFIGURATION, val);
 
 	if (val & IGU_PF_CONF_INT_LINE_EN)
-		pci_intx_unmanaged(bp->pdev, true);
+		pci_intx(bp->pdev, true);
 
 	barrier();
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 2b37462d406e..ece6f3b48327 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2669,7 +2669,7 @@ bnad_enable_msix(struct bnad *bnad)
 		}
 	}
 
-	pci_intx_unmanaged(bnad->pcidev, 0);
+	pci_intx(bnad->pcidev, 0);
 
 	return;
 
diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index b146f170e839..d687e8c2cc78 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -791,7 +791,7 @@ static int ndev_init_isr(struct amd_ntb_dev *ndev,
 err_msi_enable:
 
 	/* Try to set up intx irq */
-	pci_intx_unmanaged(pdev, 1);
+	pci_intx(pdev, 1);
 
 	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
 			 "ndev_irq_isr", ndev);
@@ -831,7 +831,7 @@ static void ndev_deinit_isr(struct amd_ntb_dev *ndev)
 		if (pci_dev_msi_enabled(pdev))
 			pci_disable_msi(pdev);
 		else
-			pci_intx_unmanaged(pdev, 0);
+			pci_intx(pdev, 0);
 	}
 }
 
diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
index 9ad9d7fe227e..079b8cd79785 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -445,7 +445,7 @@ int ndev_init_isr(struct intel_ntb_dev *ndev,
 
 	/* Try to set up intx irq */
 
-	pci_intx_unmanaged(pdev, 1);
+	pci_intx(pdev, 1);
 
 	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
 			 "ndev_irq_isr", ndev);
diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index d32827a1f2f4..6f8f712fe34e 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -416,7 +416,7 @@ static void pcim_intx_restore(struct device *dev, void *data)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pcim_intx_devres *res = data;
 
-	pci_intx_unmanaged(pdev, res->orig_intx);
+	pci_intx(pdev, res->orig_intx);
 }
 
 static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
@@ -453,7 +453,7 @@ int pcim_intx(struct pci_dev *pdev, int enable)
 		return -ENOMEM;
 
 	res->orig_intx = !enable;
-	pci_intx_unmanaged(pdev, enable);
+	pci_intx(pdev, enable);
 
 	return 0;
 }
diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
index c95e2e7dc9ab..b956ce591f96 100644
--- a/drivers/pci/msi/api.c
+++ b/drivers/pci/msi/api.c
@@ -289,7 +289,7 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 			 */
 			if (affd)
 				irq_create_affinity_masks(1, affd);
-			pci_intx_unmanaged(dev, 1);
+			pci_intx(dev, 1);
 			return 1;
 		}
 	}
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 53f13b09db50..3a45879d85db 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -268,7 +268,7 @@ EXPORT_SYMBOL_GPL(pci_write_msi_msg);
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
 {
 	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
-		pci_intx_unmanaged(dev, enable);
+		pci_intx(dev, enable);
 }
 
 static void pci_msi_set_enable(struct pci_dev *dev, int enable)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c945811b207a..df537c6f383d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4481,17 +4481,13 @@ void pci_disable_parity(struct pci_dev *dev)
 }
 
 /**
- * pci_intx_unmanaged - enables/disables PCI INTx for device dev,
- * unmanaged version
+ * pci_intx - enables/disables PCI INTx for device dev
  * @pdev: the PCI device to operate on
  * @enable: boolean: whether to enable or disable PCI INTx
  *
  * Enables/disables PCI INTx for device @pdev
- *
- * This function behavios identically to pci_intx(), but is never managed with
- * devres.
  */
-void pci_intx_unmanaged(struct pci_dev *pdev, int enable)
+void pci_intx(struct pci_dev *pdev, int enable)
 {
 	u16 pci_command, new;
 
@@ -4507,41 +4503,6 @@ void pci_intx_unmanaged(struct pci_dev *pdev, int enable)
 
 	pci_write_config_word(pdev, PCI_COMMAND, new);
 }
-EXPORT_SYMBOL_GPL(pci_intx_unmanaged);
-
-/**
- * pci_intx - enables/disables PCI INTx for device dev
- * @pdev: the PCI device to operate on
- * @enable: boolean: whether to enable or disable PCI INTx
- *
- * Enables/disables PCI INTx for device @pdev
- *
- * NOTE:
- * This is a "hybrid" function: It's normally unmanaged, but becomes managed
- * when pcim_enable_device() has been called in advance. This hybrid feature is
- * DEPRECATED! If you want managed cleanup, use pcim_intx() instead.
- */
-void pci_intx(struct pci_dev *pdev, int enable)
-{
-	u16 pci_command, new;
-
-	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
-
-	if (enable)
-		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
-	else
-		new = pci_command | PCI_COMMAND_INTX_DISABLE;
-
-	if (new != pci_command) {
-		/* Preserve the "hybrid" behavior for backwards compatibility */
-		if (pci_is_managed(pdev)) {
-			WARN_ON_ONCE(pcim_intx(pdev, enable) != 0);
-			return;
-		}
-
-		pci_write_config_word(pdev, PCI_COMMAND, new);
-	}
-}
 EXPORT_SYMBOL_GPL(pci_intx);
 
 /**
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 90240c8d51aa..1ab58da9f38a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -498,7 +498,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		if (vfio_pci_nointx(pdev)) {
 			pci_info(pdev, "Masking broken INTx support\n");
 			vdev->nointx = true;
-			pci_intx_unmanaged(pdev, 0);
+			pci_intx(pdev, 0);
 		} else
 			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
 	}
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 40abb0b937a2..8382c5834335 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -118,7 +118,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	 */
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
-			pci_intx_unmanaged(pdev, 0);
+			pci_intx(pdev, 0);
 		goto out_unlock;
 	}
 
@@ -132,7 +132,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 		 * mask, not just when something is pending.
 		 */
 		if (vdev->pci_2_3)
-			pci_intx_unmanaged(pdev, 0);
+			pci_intx(pdev, 0);
 		else
 			disable_irq_nosync(pdev->irq);
 
@@ -178,7 +178,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *data)
 	 */
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
-			pci_intx_unmanaged(pdev, 1);
+			pci_intx(pdev, 1);
 		goto out_unlock;
 	}
 
@@ -296,7 +296,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	 */
 	ctx->masked = vdev->virq_disabled;
 	if (vdev->pci_2_3) {
-		pci_intx_unmanaged(pdev, !ctx->masked);
+		pci_intx(pdev, !ctx->masked);
 		irqflags = IRQF_SHARED;
 	} else {
 		irqflags = ctx->masked ? IRQF_NO_AUTOEN : 0;
@@ -569,7 +569,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	 * via their shutdown paths.  Restore for NoINTx devices.
 	 */
 	if (vdev->nointx)
-		pci_intx_unmanaged(pdev, 0);
+		pci_intx(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 }
diff --git a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
index 8d26d64232e8..fc0332645966 100644
--- a/drivers/xen/xen-pciback/conf_space_header.c
+++ b/drivers/xen/xen-pciback/conf_space_header.c
@@ -106,7 +106,7 @@ static int command_write(struct pci_dev *dev, int offset, u16 value, void *data)
 
 	if (dev_data && dev_data->allow_interrupt_control &&
 	    ((cmd->val ^ value) & PCI_COMMAND_INTX_DISABLE))
-		pci_intx_unmanaged(dev, !(value & PCI_COMMAND_INTX_DISABLE));
+		pci_intx(dev, !(value & PCI_COMMAND_INTX_DISABLE));
 
 	cmd->val = value;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6b8cde76d564..1b2a6dd1dfed 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1353,7 +1353,6 @@ int __must_check pcim_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_disable_parity(struct pci_dev *dev);
-void pci_intx_unmanaged(struct pci_dev *pdev, int enable);
 void pci_intx(struct pci_dev *dev, int enable);
 bool pci_check_and_mask_intx(struct pci_dev *dev);
 bool pci_check_and_unmask_intx(struct pci_dev *dev);
-- 
2.47.0


