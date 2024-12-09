Return-Path: <kvm+bounces-33312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF539E9633
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C056C2817C3
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC732223C47;
	Mon,  9 Dec 2024 13:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCZ2M/Xk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008A233D75
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733749633; cv=none; b=kPo4hZu3fmdMeRdTzfy3JOqbcnFLlltZsI5iGVIrBOMVyMnRMDREAy1Kx0xmGi2mGX3WcpeBc7dOGGkbPiW+y8KeVXU76O8OeiYiGW1ehwEl4Vb2P/09rkaWc4huqqQDR/8LywU5bUENHbFq3J3ehqQ8Z9Vlgt2Zh8zkk9PCsFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733749633; c=relaxed/simple;
	bh=9Z1Cy2anDz0HAw/5Tw9Wb58QkDW/mnPO9GaPuFYE3VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljncnC5UyxeXhfXAmGLNLV1Szlc3EYPPlNuw+yDSL0yP7a2ZmrvBtEiheJbiZVJjEGHsTKX1Z+gxdml2qCWnh7KzAsSJ9UxnR7J77M+GrFvvxltT8eTD2gtbVT01xtk1tLoHWlfKc/O0tgGyysAQeBUdkTFm6qS6lI6vuFP632Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCZ2M/Xk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733749627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiILKR2a3QjvArtxAPrSG5MTRD3aI59eir0l7Eg71/Q=;
	b=bCZ2M/XkCDXGcHmZVHCJLxzDPhwvMAjhlP9m9k7/YLUd0Eflt9N4km2RSOtz+lAwgJyL75
	9P9MWFGnDWKxHMsa5A/maJbwXeAgdpukebVkl550Bk9z9b1vKxQoVQfQ9l4VjvYQwe+Xab
	TNwbHW7y287+2wC6uaX6APHY54tRK+U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-V4uwYnWKMHGQImQbVkjvew-1; Mon, 09 Dec 2024 08:07:03 -0500
X-MC-Unique: V4uwYnWKMHGQImQbVkjvew-1
X-Mimecast-MFC-AGG-ID: V4uwYnWKMHGQImQbVkjvew
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385dcae001fso1583771f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733749622; x=1734354422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiILKR2a3QjvArtxAPrSG5MTRD3aI59eir0l7Eg71/Q=;
        b=HXFUSSOx4yMtalCLQfKBOGDGr32s2ekJliI7XmAsDNv9JMeDVLCRaAbmZTTiOx0UMv
         ehW/mEphtUl8W4rvAE7BoohqQrFo5sDHJQGX03vyOsKGZOx9n9mYiFSsyOPJ6PFTZP0Y
         ToMf6CBJGE0AAy0RavU7Sy+8RomrIYvP9YS7vUEkD2d/MTqurJa25kmzB74h1LrVhrI3
         iq2bHz4tXfPpz+qAIs2MPmWW5PHr447lOAg1jcbxShz9DTi6nKcpNwPWMizbByJOe/nI
         Auf3hHaAokIm3Tjbw4L+T/sjpGouwNgbr2cTuiUtTPD5R+e1nxTmhIBoChKs5dLGl9uQ
         MS6A==
X-Forwarded-Encrypted: i=1; AJvYcCWlVJrfn6p7FEbpW1yUp/oftvcof5FL0IsKE4bCOG5z5LBh92d1Ld1IuZWYuX1vm0aDD6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqL34cwR+tsEpEYdsBLgXOZTkeIQbyjBUK3fud1van3THutEHD
	IBEPB+TV6psG+efg+EZvmCHytFIgwetqN26LR7EXPJeQu90QMLyCI50TCdJacYFhdc50Nqy4Nqs
	AqXUcrMo/ypVmyu3sw+F/s1wBKWRL9iTB0sjLrxO8SXkGPa0tqg==
X-Gm-Gg: ASbGncuR2plLQQ+IPyHBrrL2rPlvKFCk2hc6PC7rN0mNhw8+TWd2rV1Cxa0BY/cgWMM
	toq/DCucHF/Xv9eORDYK6qg0VW4YRooh6IDgllnrETCf8M8Wq8vJWG6D/gNVnWnYrzqk6wJMqqd
	Fl2SZfyPoSAP8VnN8CgI5TLCPjiN6EtTKvWEhEugi/aKPz8hDSgXtDGRAlfrG/MDY4j4wGk2RjL
	QuqJweIWlw53Dx9/U0i9E0IAvbPsxjMb6ewE4+/kxgPxeVXikzssn3APxdz9pAP83qgBMFI77el
	Rs6dKEWp
X-Received: by 2002:adf:e18a:0:b0:385:e3b8:f331 with SMTP id ffacd0b85a97d-3862b355ed9mr8982734f8f.14.1733749621839;
        Mon, 09 Dec 2024 05:07:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEcWIoVaHlqXXOi6I/o8U0Sx4v85WRQCbXdmf3r6S4bXIGyWlICGFsXbMo+gcSn1pLdSeKWw==
X-Received: by 2002:adf:e18a:0:b0:385:e3b8:f331 with SMTP id ffacd0b85a97d-3862b355ed9mr8982697f8f.14.1733749621414;
        Mon, 09 Dec 2024 05:07:01 -0800 (PST)
Received: from eisenberg.redhat.com (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190965asm13200127f8f.82.2024.12.09.05.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:07:01 -0800 (PST)
From: Philipp Stanner <pstanner@redhat.com>
To: amien Le Moal <dlemoal@kernel.org>,
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Philipp Stanner <pstanner@redhat.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kevin Tian <kevin.tian@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
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
Subject: [PATCH v3 07/11] PCI: MSI: Use never-managed version of pci_intx()
Date: Mon,  9 Dec 2024 14:06:29 +0100
Message-ID: <20241209130632.132074-9-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209130632.132074-2-pstanner@redhat.com>
References: <20241209130632.132074-2-pstanner@redhat.com>
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
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
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
2.47.1


