Return-Path: <kvm+bounces-33313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B92DE9E965B
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72B7C188B289
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77945223C7E;
	Mon,  9 Dec 2024 13:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uk7DOXS0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74E33DAC12
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733749634; cv=none; b=gaRXCFnJrGhLHkSEhskSiQ8VMZx/VxquvcVqsdEv3lqh7s4uXjkKeU6vzHfKzot9LaldsAOqwaViaBuEM98anLF6W0nX4SDNB3SRDqy4fPUOD9YkbG4YxhfPpldYXg2O2bYf95A3gaxrY/reVdJGdCDorBGBnvrPhvx8qKLeiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733749634; c=relaxed/simple;
	bh=kEzRZlYHQ35CA9CnBRQZ7a8YwaQDWA/y9wHnTg2Gq0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/gmxODNLaw9WDk7b7T3fb1h3zCbknkGgx2IuBCXf94NvDrwazRkYRQuDr/fjYhEdRql1TJEpS7yFIMO1VkwJaJv6T0/t6HOphuXoa6MwwxZ+99tsETNYFEC3ZC4gXXCIdko9sqSd1bZGVJiCfft6gyaRrrm0srCfZIJlnFkyTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uk7DOXS0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733749630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cg5FDrf0+9NG9f4wa7LEIeg49zn7uGzDf8HKpIKXKbU=;
	b=Uk7DOXS0pKDwwgrUE7AoI6sJGb49Otm4W9tOm3pILEAqne+s1qpqntlah4kIpK7x2VaJ44
	lAqhpTMAbbgU1w+D0Npa5DvbNw0OQ0rBUq5dR+o0h1809b9tvfiN/j80oF4PdL9VaBw6J7
	UPcjJbCCLDpyiY6H6tLYsUjktJBR8o8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-Md3DxRmvO8Cpwm8InyjAMA-1; Mon, 09 Dec 2024 08:07:09 -0500
X-MC-Unique: Md3DxRmvO8Cpwm8InyjAMA-1
X-Mimecast-MFC-AGG-ID: Md3DxRmvO8Cpwm8InyjAMA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-434c214c05aso36610315e9.0
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733749628; x=1734354428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg5FDrf0+9NG9f4wa7LEIeg49zn7uGzDf8HKpIKXKbU=;
        b=sMUlqO3rmu9UMbgscB/oaRUeaJaTK8dTfx0cxmdGA7hKrqNCdqSF67aPp1WVzlR1XF
         K/537LJXvwNtNXWjvmKTy1P/moEH/75VHF6eEZb0i3SFOY7JYeBjCjJtdDW3VinCG/iz
         98WiVX8MP3pNr3A3ViXzHezC44SM5nL+bouWFht33V7jGENRVmwIKm6tIQUU/H8FJhDH
         bXUN3KLFs/20BsRq9ZeM6FzdV99DylQjiHF6wd4f4SRe0IHXL2pyDlzzawhkkFx240iF
         xmo5w2LePsiWWH6fZcMWw+Etwi6iK2kUgZOmmxML8fIwoDcvAVwH27G8EQ7tzVjD3sVR
         T8ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqvlqZQUbXFYEBgEKgMtaoDoXbIH24I0/DN+ntU5ceZp3bm8TutZa2duvU//kzESrr4T0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5HW2HyeMWn73l3Amcs7w7V6RSL9Sj/fH1epopO0wBnBMQrdd7
	JkwADnr4QraZgsBMuawfl48/WeyeGVQztHy2U44IxEgYCKP7nqVl+O/fkFOJ7iVxxrKfSsauspa
	uswo9zIvOSoCYoM+x0q0SESuoe1b7OeYqkC0BzdGRRzTgiyCRvA==
X-Gm-Gg: ASbGncvNHVUtKM7xm+okeRGc2fh+jSNGrNJHzngRoKiwxIwcrOYQ63cVHjTsYIEog9K
	ZzI3UNXbdNVJm4wj+nqCxsrS7a1vMnfiIBz9faUDE4/OvO5pUe0DSgXtOYkA0x2UEnGJwdjeTt8
	ObeEezURYnXFSWlZTXRzeoQFc9FM8pFv7NOgEuD86vOd8+w4rX0Q1/sQetN6a04YHdZj4QXyyZP
	SWA3MwBIaq0Xohis/edXCRyTx/mG6/txttLqXe72ydu3b5jRYAc2oa6kJ3smYnP9CFjDn8QRNAl
	erumTzYP
X-Received: by 2002:a05:6000:2d12:b0:385:faec:d94d with SMTP id ffacd0b85a97d-3862b3e2f99mr6786227f8f.51.1733749628293;
        Mon, 09 Dec 2024 05:07:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzvkT5DctzF6sU2GBgKgYj4TZMfZMHtf63D+x4hcRmPdkPLtxCBfCUCCjCewKM8z5+rRuxWg==
X-Received: by 2002:a05:6000:2d12:b0:385:faec:d94d with SMTP id ffacd0b85a97d-3862b3e2f99mr6786186f8f.51.1733749627860;
        Mon, 09 Dec 2024 05:07:07 -0800 (PST)
Received: from eisenberg.redhat.com (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190965asm13200127f8f.82.2024.12.09.05.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:07:07 -0800 (PST)
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
	xen-devel@lists.xenproject.org,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Subject: [PATCH v3 10/11] HID: amd_sfh: Use always-managed version of pcim_intx()
Date: Mon,  9 Dec 2024 14:06:32 +0100
Message-ID: <20241209130632.132074-12-pstanner@redhat.com>
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

All users of amd_mp2_pci_remove(), where pci_intx() is used, call
pcim_enable_device(), which is why the driver needs the always-managed
version.

Replace pci_intx() with pcim_intx().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c        | 4 ++--
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 0c28ca349bcd..48cfd0c58241 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -122,7 +122,7 @@ int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
 {
 	int rc;
 
-	pci_intx(privdata->pdev, true);
+	pcim_intx(privdata->pdev, true);
 
 	rc = devm_request_irq(&privdata->pdev->dev, privdata->pdev->irq,
 			      amd_sfh_irq_handler, 0, DRIVER_NAME, privdata);
@@ -248,7 +248,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
-	pci_intx(mp2->pdev, false);
+	pcim_intx(mp2->pdev, false);
 	amd_sfh_clear_intr(mp2);
 }
 
diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index db36d87d5634..ec9feb8e023b 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -289,7 +289,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	sfh_deinit_emp2();
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
-	pci_intx(mp2->pdev, false);
+	pcim_intx(mp2->pdev, false);
 	amd_sfh_clear_intr(mp2);
 }
 
-- 
2.47.1


