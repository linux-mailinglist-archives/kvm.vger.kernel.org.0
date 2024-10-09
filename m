Return-Path: <kvm+bounces-28187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA6D996349
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93E042814D4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E67194088;
	Wed,  9 Oct 2024 08:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z09XEqVv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9122318DF81
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463059; cv=none; b=cOMMIByMsoMjgyfrBHNdnTFInUWOB52idu2XbFxu4D0Es9hUl7BDyzM9amFsuOvyN43/sSFRzJ6eqh2b+YXkcFjD4Yn79N0Gu2pwr/XTjDAYzpepwF3VYGCCz2AcEs6KYStwgBoOxjD9qMUI2gaW4ajwsTCxBbWAIJBlLEJXSk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463059; c=relaxed/simple;
	bh=ZRd/gcDD33niWws9hdgtuxw4M4HG1qFe++9lbpf0T80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaENa/Vilva8AOEGk2cwIyUDsyLZYypUeqCA/bfRIioPWYEuNFOwlRtSbF/7+lIBNX/4dYem8j4ZPDTRZQucrbQIpAbVLyxKAgPmDbpDNXEgU1be8A/tbybLUsOJ6xM/RuCgrWITbXOpjAedG7w9BZ++zDBlX8EaLRou5AZzFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z09XEqVv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lTHYC2Ta++0YaXHTW6I7MhYRpUqFySCxRFqkuz5HbMw=;
	b=Z09XEqVvVxgq2uAaHtGJ/0p+1VaCWUhTl5m60BLn58Ols0Wo/UKWSzR/A7750dp4wXgQIO
	b/266lFERqLBmtJWx/F3kbD32FaGtt0jvI8+Is3fdspWGWiFxr/Tpjy8GKYBg7os23JkFM
	f5BU8yvOumjhiv85pQMbzGGWZZVp2lA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-ANeKefQQN5SWRXjYN5SZeg-1; Wed, 09 Oct 2024 04:37:34 -0400
X-MC-Unique: ANeKefQQN5SWRXjYN5SZeg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7ac8f684cdaso1238160585a.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463054; x=1729067854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lTHYC2Ta++0YaXHTW6I7MhYRpUqFySCxRFqkuz5HbMw=;
        b=Z5eMWIs/WzQnZ5f0fY22ibxE6NoLWuuJc4VNiHZfMVQtA3t4ABEt8kONDs66urgjJ5
         Zt3AevtPmw5i7+yAGnEF8LrGa6FXZt1NkoXz6LZOeNCdzQ3/mQS7hOdNcpr9xrEF2AoL
         HsuLpHVPt3kRyGbbbj/XYrxwa88Bw17AVmcx0AhhuoiSvj9q+8PArjK4YphOl89X+bG1
         lZW66UpnFUpCxCOEI/N4Iyg3py5CeutfYI9V4R1v0I5EgyCgtSefc0Tx3OE5z2eQrEmk
         zwha69f4JqEL0vuRQdT76r4rI4Ei8ucCedyO2H5DNaV/8sNcjRS/VW6ja9UFGKVCkkmR
         9UUA==
X-Forwarded-Encrypted: i=1; AJvYcCUyBfv5VLkL4vgbxU81Xlxvht9Y17BLvDiD+25/bNg9jo4iZ0P0zwfFunXlOGvUEMxbDF4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3jCEQqR2pp0LMTcefd74eG5Ih+5XirbNaBpPtvaT08SfPEl7v
	OL2RZe1R9Od7XpXZVq66hUAOKpbIJynyiXc+3POhI6DuG7V3Li/yiH7vOstiiXJ0B0KD9dT4elX
	qHo8cUqKBJiIqEV1qgJHwuQTGetBul0Ly7Rmg10+/RDk5XZxZjw==
X-Received: by 2002:a05:620a:1a0d:b0:79f:a82:51b6 with SMTP id af79cd13be357-7b07954f31amr225717585a.37.1728463053940;
        Wed, 09 Oct 2024 01:37:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyOmhURDToKlj0Tx/+LSrRiFI4N0xp4bxoYWlBt9rq37ZdtOecLCJNvSEgZi/GrzB82+mMyA==
X-Received: by 2002:a05:620a:1a0d:b0:79f:a82:51b6 with SMTP id af79cd13be357-7b07954f31amr225709385a.37.1728463053424;
        Wed, 09 Oct 2024 01:37:33 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:37:33 -0700 (PDT)
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
Subject: [RFC PATCH 06/13] misc: Use never-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:12 +0200
Message-ID: <20241009083519.10088-7-pstanner@redhat.com>
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

cardreader/rtsx_pcr.c and tifm_7xx1.c enable their PCI-Device with
pci_enable_device(). Thus, they need the never-managed version.

Replace pci_intx() with pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/misc/cardreader/rtsx_pcr.c | 2 +-
 drivers/misc/tifm_7xx1.c           | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index be3d4e0e50cc..e25e6d560dd7 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1057,7 +1057,7 @@ static int rtsx_pci_acquire_irq(struct rtsx_pcr *pcr)
 	}
 
 	pcr->irq = pcr->pci->irq;
-	pci_intx(pcr->pci, !pcr->msi_en);
+	pci_intx_unmanaged(pcr->pci, !pcr->msi_en);
 
 	return 0;
 }
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 1d54680d6ed2..5f9c7ccae8d2 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -327,7 +327,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 		goto err_out;
 	}
 
-	pci_intx(dev, 1);
+	pci_intx_unmanaged(dev, 1);
 
 	fm = tifm_alloc_adapter(dev->device == PCI_DEVICE_ID_TI_XX21_XX11_FM
 				? 4 : 2, &dev->dev);
@@ -368,7 +368,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 err_out_free:
 	tifm_free_adapter(fm);
 err_out_int:
-	pci_intx(dev, 0);
+	pci_intx_unmanaged(dev, 0);
 	pci_release_regions(dev);
 err_out:
 	if (!pci_dev_busy)
@@ -392,7 +392,7 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
 		tifm_7xx1_sock_power_off(tifm_7xx1_sock_addr(fm->addr, cnt));
 
 	iounmap(fm->addr);
-	pci_intx(dev, 0);
+	pci_intx_unmanaged(dev, 0);
 	pci_release_regions(dev);
 
 	pci_disable_device(dev);
-- 
2.46.1


