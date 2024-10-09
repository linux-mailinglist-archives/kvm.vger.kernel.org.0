Return-Path: <kvm+bounces-28188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3731F996351
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB2CB1F21C38
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D55A1953A2;
	Wed,  9 Oct 2024 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AcP49GSi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DED18E023
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463067; cv=none; b=eD6fLy1a88+czb56ZxEPMYCWHz4omr7fe62d5l3hWTncwxdLwOAWL3+J4KaIkgkjhbnZSCL2H/4kLdSOXKcxRLZiOsEiQssEtjG7e7v8Bi25xtQO4NF+MPSLGfi2FG5+eCd+TgxjKRaAfyf6WlJl3ntq8JSak5SXm4+aZbTAWDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463067; c=relaxed/simple;
	bh=EpcjpNUPxDJfeNBdK7OSbEE2nGoSE5GNXjSmcKadEZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8QrHd8sBBXYB2duJ5n+knV9+aqTZbrprEs/+7OOfpnz7Jj3YMqp6WjrRaCvZM3wIjxTr/Zilr40q3SYivaa9597aQ9gV+mUS+XTZjX+TwHwPVz3s0mq14Q9pvUyAqD7yCAw87IvyDqo6SgkMvvQ/pgT+nkvvKHF3cBUJk+/AaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AcP49GSi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JsGvGJm9MmViCmQHy+rwDTsxwdGI+an22CjgwnYtt0I=;
	b=AcP49GSi+0YKdiVR9D0PvqGMrX+1tqaLXAJcEMR4AtuBm4wV9MvhZfFSwNIBiyB2J1vovw
	DecWHjUuH0ejMcAdMndeAHWGxIJ6WjlAPMUEeqmkUg4+URSLBhTTWqh/zQb/mXpRFbWoLp
	7iarfN3/5TFKY1r+39tHA6vUYK72bzE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-uC5cpAINOh2DJ66CRz5xew-1; Wed, 09 Oct 2024 04:37:44 -0400
X-MC-Unique: uC5cpAINOh2DJ66CRz5xew-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7afcd3945fbso184388185a.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463063; x=1729067863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JsGvGJm9MmViCmQHy+rwDTsxwdGI+an22CjgwnYtt0I=;
        b=jSoAq+xeOqegAfqOUehuso592Gc+6VEzsi6h+6suGFdZGgGrXfo8+fQ8yqWPq2tV8v
         evtFh3DNng0MMTeUUX4KgAA6Ayt1dPBl1ofgT1inCZN8FEAkiTTbfKjh3Y19/r8rx1J3
         pQy1eEM4FcNiUSVgQCZxgnVaz8Wua32SMUS+zu+aGFaG0ip2s9Cabq5nMtmN59LXI41r
         9NnG6azoMgDTxeLuyqvElERHRJEgHU+k/L+kKNZC1DxnNnhENj0vKNTitUkiaQqkoRTT
         KC6jMglr1pRDrSNRD+LY0U23foKOVzcOt6cfFzyWv+TQ2H0/IH0wOpovjvFPfa2/DtV2
         ML6A==
X-Forwarded-Encrypted: i=1; AJvYcCW7xodpGTInrsCZarPvmF7bduToQLidw7E08LQKlQFhOhtjD/QJFTGOdEjtkcGxCRCMXyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5CaIgyUAyMIciIxs+qHr+4AteqJ/swEA9BxqVWry2XtJegmsj
	JD8S1GUDXGRG8FrC+vcD5f3K0JOCpZs13Nr7Th8dSCuo27E48DdxG1CbUYOt97WaaXo2piXyvH8
	grx9TPM/u1KsepxyS9uq3jv7IBljRzyd0YYJFn/dglm2EqXWVYw==
X-Received: by 2002:a05:620a:2a0e:b0:7ac:a6f9:2986 with SMTP id af79cd13be357-7b0874d79cdmr228235585a.56.1728463063298;
        Wed, 09 Oct 2024 01:37:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFImvB9Qv7o17NV9RNqrUwhslSwlEiuBLwjyyln/SL0KXDFR9AO0zKFsp8+HNe0WvD5hbb1TQ==
X-Received: by 2002:a05:620a:2a0e:b0:7ac:a6f9:2986 with SMTP id af79cd13be357-7b0874d79cdmr228232385a.56.1728463062845;
        Wed, 09 Oct 2024 01:37:42 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:37:42 -0700 (PDT)
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
Subject: [RFC PATCH 07/13] vfio/pci: Use never-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:13 +0200
Message-ID: <20241009083519.10088-8-pstanner@redhat.com>
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

vfio enables its PCI-Device with pci_enable_device(). Thus, it
needs the never-managed version.

Replace pci_intx() with pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c  |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ab58da9f38a..90240c8d51aa 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -498,7 +498,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		if (vfio_pci_nointx(pdev)) {
 			pci_info(pdev, "Masking broken INTx support\n");
 			vdev->nointx = true;
-			pci_intx(pdev, 0);
+			pci_intx_unmanaged(pdev, 0);
 		} else
 			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
 	}
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..40abb0b937a2 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -118,7 +118,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	 */
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
-			pci_intx(pdev, 0);
+			pci_intx_unmanaged(pdev, 0);
 		goto out_unlock;
 	}
 
@@ -132,7 +132,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 		 * mask, not just when something is pending.
 		 */
 		if (vdev->pci_2_3)
-			pci_intx(pdev, 0);
+			pci_intx_unmanaged(pdev, 0);
 		else
 			disable_irq_nosync(pdev->irq);
 
@@ -178,7 +178,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *data)
 	 */
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
-			pci_intx(pdev, 1);
+			pci_intx_unmanaged(pdev, 1);
 		goto out_unlock;
 	}
 
@@ -296,7 +296,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	 */
 	ctx->masked = vdev->virq_disabled;
 	if (vdev->pci_2_3) {
-		pci_intx(pdev, !ctx->masked);
+		pci_intx_unmanaged(pdev, !ctx->masked);
 		irqflags = IRQF_SHARED;
 	} else {
 		irqflags = ctx->masked ? IRQF_NO_AUTOEN : 0;
@@ -569,7 +569,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	 * via their shutdown paths.  Restore for NoINTx devices.
 	 */
 	if (vdev->nointx)
-		pci_intx(pdev, 0);
+		pci_intx_unmanaged(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 }
-- 
2.46.1


