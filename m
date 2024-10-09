Return-Path: <kvm+bounces-28189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F83C996359
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 569801C20AA8
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585B918E030;
	Wed,  9 Oct 2024 08:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fC4DWxGO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1628197A8F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463077; cv=none; b=cjazuXiV6EdbJovVNVYHWis41Rx+smSqG2e0EanuZHzVgOe5p1CO5cLqZd11Ah1s9iMcQhQNgcuUMeddK67Y6ovGvj9IvWg0c7r0O7X0h16IAUEKMjg83U1TCDtdkiuI11Eg15/FUY8De1d4myKRxWDQFd+HgNadAm85At9JpWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463077; c=relaxed/simple;
	bh=1G+pEtntUe6ZQw3bO6bhaoH2cS+X3nDY9vjN4pE1htc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyRkKd5ZBF31N8RoZDspPOUaEoGPongFfwnwpBAmzUK4ceC+sg+0ie6X4zjpb96d+0+w9B8XgDLqgYU7mlE7ZxqMnUmWrKd4ICmtby3TC/s4fYkFq6Cl7NTGZhOhKMt4zcMIYnDCx2cOTJDJr2aWmM4Grk4f7EiwRgt67cmYNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fC4DWxGO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnZVeWBmT+J+LidRf6mImSoyv0oTiirkxqtpTQtBia8=;
	b=fC4DWxGO06507Q9t9nbUCj8a6w4abBJiI25IG5mtjuO6Xcufr6yj5YjAjZbMSwT3/sOkmM
	vU90pqOKVuGI7DP+4f9dNseps+LVKIF7CrHwBXuDKBurnbdX+zedy3KIA0WjcTPSPDXBzS
	TdAhQ7287H5GnsMsqS1S8Q0pn3EFu8c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-xpkyjLYNPaCf26YfsUKALw-1; Wed, 09 Oct 2024 04:37:53 -0400
X-MC-Unique: xpkyjLYNPaCf26YfsUKALw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7afc3f4faaaso255772185a.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463073; x=1729067873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnZVeWBmT+J+LidRf6mImSoyv0oTiirkxqtpTQtBia8=;
        b=XnOzNvU/rqsQb1Xt3rzFN9x9EnXcQRlqNQV/0P/6CWBRSH9kaDH2S/madJKSqF2Ihv
         M7BqiXmFAQItW2B4/RJgz/NEgXDfRCfBtRyIwzQiXiXd/rAEcDQ4NdRZShLML2j6nwnb
         VR0FDHsCSg8eGfI4qEPSBKIQBdm3bYm61G7Exkko5zGErO9k6tcIEVeQS+STjNG4mVBu
         GQtNm6okd+nv76Se1QInHNfS1ZwlI4e+JMHCk5aLOXWzFqcY1PW34fY9KLLzRn1y0jpt
         rs6tMU0ZJViYSaJP11V2pK/yzUuCz7aDRy746UudnbiV52h5ocB6WUtnoMAck5LNXApb
         DGpA==
X-Forwarded-Encrypted: i=1; AJvYcCU8NX3+xDjL9Ro7syvo4wbx/L0OHH72KhJ0aaaAd1EY7+eGGFR9Qo44XZxICAXUtYoUP2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTUJDEbvnjUOuxzvOHO6liogleu2lQYMs1PVsIqk0MAH9CDE1W
	VSnSi35wYU4Vy7ugB2kq6Q87DDQskJmV1d8ATma+sRihZ/Qj35/FwiyyXzebZd7gvvtagWFu7wJ
	G4fdfGYqAmtsgEZhKaomyq0U7qWC2QD5dkUhfRYP55/dP6O/8Mw==
X-Received: by 2002:a05:620a:40a:b0:7a7:fdef:27a with SMTP id af79cd13be357-7b0874d7cdemr203382485a.58.1728463072692;
        Wed, 09 Oct 2024 01:37:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVcvq1l/JiYDRYGcvT0xuobZAhQYwMoKmOoPhvJp1jfhxUy6a6lyXKK7lz5Kz5T1IwGDIQGw==
X-Received: by 2002:a05:620a:40a:b0:7a7:fdef:27a with SMTP id af79cd13be357-7b0874d7cdemr203375485a.58.1728463072097;
        Wed, 09 Oct 2024 01:37:52 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:37:51 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
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
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ye Bin <yebin10@huawei.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-staging@lists.linux.dev,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-sound@vger.kernel.org
Subject: [RFC PATCH 08/13] PCI: MSI: Use never-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:14 +0200
Message-ID: <20241009083519.10088-9-pstanner@redhat.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241009083519.10088-1-pstanner@redhat.com>
References: <20241009083519.10088-1-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_intx() is a hybrid function which can sometimes be managed through
devres. To remove this hybrid nature from pci_intx(), it is necessary to
port users to either an always-managed or a never-managed version.

MSI sets up its own separate devres callback implicitly in
pcim_setup_msi_release(). This callback ultimately uses pci_intx(),
which is problematic since the callback of course runs on driver-detach.

That problem has last been described here:
https://lore.kernel.org/all/ee44ea7ac760e73edad3f20b30b4d2fff66c1a85.camel@redhat.com/

Replace the call to pci_intx() with one to the never-managed version
pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
This MSI part here is probably the part of the series that needs most
attention.
---
 drivers/pci/msi/api.c | 2 +-
 drivers/pci/msi/msi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
index b956ce591f96..c95e2e7dc9ab 100644
--- a/drivers/pci/msi/api.c
+++ b/drivers/pci/msi/api.c
@@ -289,7 +289,7 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 			 */
 			if (affd)
 				irq_create_affinity_masks(1, affd);
-			pci_intx(dev, 1);
+			pci_intx_unmanaged(dev, 1);
 			return 1;
 		}
 	}
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 3a45879d85db..53f13b09db50 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -268,7 +268,7 @@ EXPORT_SYMBOL_GPL(pci_write_msi_msg);
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
 {
 	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
-		pci_intx(dev, enable);
+		pci_intx_unmanaged(dev, enable);
 }
 
 static void pci_msi_set_enable(struct pci_dev *dev, int enable)
-- 
2.46.1


