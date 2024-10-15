Return-Path: <kvm+bounces-28944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B72DC99F661
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 20:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 770FD283E03
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4678202633;
	Tue, 15 Oct 2024 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4i/O3bx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E53B201022
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729018334; cv=none; b=blc4aqGHFsCcl+VYfSlb4CktKmNFlP/uxuh/wJX5URIMwTtuHGh3/+FNVry8+Dhap144FhykWi7RALgJjVeU5COg0oaRPzecb9WHjQX8aV+9z1vYrcQ2AxETxfCBBPpgWjnXZ/o879Lx4yo76KwOhwTTVO42X4yxmxjkYZxZ/jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729018334; c=relaxed/simple;
	bh=x/7QFhAzHkLj8+w14TM+V3xJvs5L48Anth4HQxPkvDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkzDxy2kERYP8sPn6ybcd3BeV4cjK4k7S/nkVV8mU5DNenNknn2zNgSfkGEtC6m1JL/YdCYp8s2/JF/ky+csz9EsrMo4U2kI6TFreVU4YGQlSkrqiuZEfeN9gmKy67XnhAXo1/yQHqLzw4w8uYjTL22BbVXdqBPy7N5N0DWgEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4i/O3bx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729018331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NsJKOkpA+QoYlzqeYDbY0Dl9xjdlxWNvzFNzd4dMwhk=;
	b=W4i/O3bxfYp6kKqngB4NZN4xkySGLqJmMWG+eKXlf0HvZFR/rXGEEebZxgvlavdsEtez1d
	6h7pI4a+H6ma/9wJi+ePvJUwxq23xDrG/++tkA8uHd4XWyv/zQ1ExXe5Zd6FzJ+gAvQxo5
	2SrBefKLPOoIEAqLj9EeSecxZEcYJSs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-Gws5Dhs3PoybbS57Mg8nkg-1; Tue, 15 Oct 2024 14:52:09 -0400
X-MC-Unique: Gws5Dhs3PoybbS57Mg8nkg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2fb5bd1c324so7748301fa.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 11:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729018327; x=1729623127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NsJKOkpA+QoYlzqeYDbY0Dl9xjdlxWNvzFNzd4dMwhk=;
        b=eclj6aYanc0rrWHARMnZXihY1k6w6tW/6NbS1zSfJeMax7f8dDLnvMszeuwwUbMEqw
         nA6EKg5NqMOcGdbldtFg1krZ7kc8gI4HsBJxq9kvM3C9kyIlpo09ztoeL51vrEAM7yVr
         LC/nCmTemJ17fAOwmbmF6I0c7YSE0wsb7ldNBs4uIupGSJ4gm5I74k1s5bJtyo5HB4V1
         mfq6boIVrGqppFXHTxe3sDaHjnSUsVIzcO2KgQhydCB19HEORw04zBHme8eYuEmkjxlu
         pp8CiF+71mC8qJIPf25xD0u8bS7Fx9iOMVgEUQlbd2YfSwP4MaUiwel+deiVltosM2p3
         2cow==
X-Forwarded-Encrypted: i=1; AJvYcCUTYkTywnU/zRgEMiRfxrRuHo0iRXXsgY3vijCAPSM26ue9W707o0DCgg+rtVcdqLr/o5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjRG6LOZ37w6tPPumQtjB0ewTSh/tfoB7e7QDzrsvyB60lHabi
	/Hj4QtmWmuHXIi7acovuvQgzKggJOaLv5CmJ18OtLYgDddOPnhu7H1sDq3HISS+CJZqbcUtWCts
	zIAaraz8hjw78Gx/8PwVa9BzG18akU4Gp1A0JGehtDBwo3TQY6w==
X-Received: by 2002:a2e:bc24:0:b0:2fb:51e0:951 with SMTP id 38308e7fff4ca-2fb51e00cd9mr38862551fa.7.1729018327283;
        Tue, 15 Oct 2024 11:52:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVZ1XHHUqIGJ2m/RKPcgltoOTO0Mu8nn9SAFlZXigaFQMqbloSJIQ5jr77XkDUgFazWOLC0g==
X-Received: by 2002:a2e:bc24:0:b0:2fb:51e0:951 with SMTP id 38308e7fff4ca-2fb51e00cd9mr38861861fa.7.1729018326657;
        Tue, 15 Oct 2024 11:52:06 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82d5d5a0006e2615320d1d4db.dip.versatel-1u1.de. [2001:16b8:2d5d:5a00:6e2:6153:20d1:d4db])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d39a9a2sm974438a12.0.2024.10.15.11.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 11:52:06 -0700 (PDT)
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
	Chen Ni <nichen@iscas.ac.cn>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>
Cc: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-sound@vger.kernel.org
Subject: [PATCH 08/13] PCI: MSI: Use never-managed version of pci_intx()
Date: Tue, 15 Oct 2024 20:51:18 +0200
Message-ID: <20241015185124.64726-9-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015185124.64726-1-pstanner@redhat.com>
References: <20241015185124.64726-1-pstanner@redhat.com>
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
2.47.0


