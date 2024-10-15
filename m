Return-Path: <kvm+bounces-28939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4205D99F634
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 20:53:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B21441F26B4A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1525D1FBF43;
	Tue, 15 Oct 2024 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8cB6U84"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7741F6697
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729018316; cv=none; b=PJPnul7Y3ieLDj3IgbtlaaAW+qEx3H7x55o6sG0Dl5xyr44sWxIzp8EySrza32bplcgLIVkfoakzmZUXO3bqcX2lLIDoSY7bYc7Sx8o07jsh4OBR5uguZHUsJk2uasLM1a9YddUyWCw3hu0SWmuc50z2eNVz3mKePKY1C1evjrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729018316; c=relaxed/simple;
	bh=dO0Bt5S9xKcwhKAQUQyexaV6kggyDnL6IVx7RfRRupg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9DfuZ8asv525cLnBXmPc7xNpu1WUO1JWbMrgcBUCmQB3QvDQqmX/IJm1gTP5kuADS5VoxGbcf1nxVDs1h5F7F91PN91CEl/kFGgLQm1rK/p3w4XhRTD8WJmqL5AcOpPQPmJ0/HcTS+s1i3O+hgxdMpV0KK5EcXPFYz9556tzIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8cB6U84; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729018313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2UdUsG2Ce2FuhD+Vr0J1b3PhjfLKCU3S+xUJ9DfCqJQ=;
	b=g8cB6U848Gt9XQxP5auObeLjNMqwplENKDWcSmOGafvXqiDlZvJKb3zC1FcFSFU3Vcvhgt
	GOhxwo2HQU9HYF81sQctGWlkh6n2Ed3O+lmEUn5b6EAZ8P+1IBhsdj0S3+zsDykE/1BpEw
	GyLonnEtsi8Mni5cK+o178RrLLnJAQk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-a5rN99tHP8SlpA0u7izksg-1; Tue, 15 Oct 2024 14:51:52 -0400
X-MC-Unique: a5rN99tHP8SlpA0u7izksg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2faca747f94so37293141fa.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 11:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729018311; x=1729623111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2UdUsG2Ce2FuhD+Vr0J1b3PhjfLKCU3S+xUJ9DfCqJQ=;
        b=YyH+zwfXMHBerkXmGq3/wp/QHcuF/8OTOQoZf3Km2iO3KxT5njRuraqpwdmeNiJbH2
         n159B6zeqPZHM5CWEcdkb1xXLWG2UwkvUM8qg3FP4ZaVQJklRZ73MwnC1fLk1PXDlA0X
         nGAeOOzvrbFnEZEb7wlgA+IVo96wlGrwaf9uRTz9V0PTamjixdBmwoVNTEojiDPXQjyl
         F2rwMBsMLI+SjYioRnGZGm7zJzybqUCO4TYODI3PS5xdevaY7aBlRkxIxAPZ2RLgoH+P
         L1a7vhvoNRLAyNerRpm15quINr1qFAmLR31x0Wk+S5vEsDgRaCq+nEb6F1o1DfkMIUtk
         pDTA==
X-Forwarded-Encrypted: i=1; AJvYcCWooczLkpvNFMp/PGlbYBnP5OJu8095fOpwJcwbwHx9bzGhYwqBAUTiu5ut92fj+b3acv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTrBoiSlKSYfSoHuYULK036SILiLqgC12mO+EpiSn68QgyQ/X/
	Wv6XodjtnotX7Mu0yHfEtfmZKKT/+aQLcHF16/Y/4KwuuhI6spKCCP2VvM93Z92P8In0mVD0+19
	EBGUaSu0BueYGgga+dlwQ4cV4q76BD/U2oHAGLTttxLiBbeqDYQ==
X-Received: by 2002:a2e:be13:0:b0:2fa:c0fc:e3d6 with SMTP id 38308e7fff4ca-2fb326fc5a0mr82286241fa.7.1729018310973;
        Tue, 15 Oct 2024 11:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGg0lXB9d95359mfSRgxCA4dveTgVHKUj5pW+Si5SQOi+coS4w/96kFO+qIGBhPz8zuJnYPgA==
X-Received: by 2002:a2e:be13:0:b0:2fa:c0fc:e3d6 with SMTP id 38308e7fff4ca-2fb326fc5a0mr82285671fa.7.1729018310336;
        Tue, 15 Oct 2024 11:51:50 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82d5d5a0006e2615320d1d4db.dip.versatel-1u1.de. [2001:16b8:2d5d:5a00:6e2:6153:20d1:d4db])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d39a9a2sm974438a12.0.2024.10.15.11.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 11:51:49 -0700 (PDT)
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
Subject: [PATCH 03/13] drivers/xen: Use never-managed version of pci_intx()
Date: Tue, 15 Oct 2024 20:51:13 +0200
Message-ID: <20241015185124.64726-4-pstanner@redhat.com>
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

xen enables its PCI-Device with pci_enable_device(). Thus, it
needs the never-managed version.

Replace pci_intx() with pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Acked-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xen-pciback/conf_space_header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
index fc0332645966..8d26d64232e8 100644
--- a/drivers/xen/xen-pciback/conf_space_header.c
+++ b/drivers/xen/xen-pciback/conf_space_header.c
@@ -106,7 +106,7 @@ static int command_write(struct pci_dev *dev, int offset, u16 value, void *data)
 
 	if (dev_data && dev_data->allow_interrupt_control &&
 	    ((cmd->val ^ value) & PCI_COMMAND_INTX_DISABLE))
-		pci_intx(dev, !(value & PCI_COMMAND_INTX_DISABLE));
+		pci_intx_unmanaged(dev, !(value & PCI_COMMAND_INTX_DISABLE));
 
 	cmd->val = value;
 
-- 
2.47.0


