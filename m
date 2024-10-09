Return-Path: <kvm+bounces-28191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1BD996369
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E3A11C23DF8
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F56D1993B8;
	Wed,  9 Oct 2024 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EieKqTAk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D518E754
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463094; cv=none; b=Nd5CzaEGRXbSbUNO7i++hHahG/KzrNLeoIHr4LhUA3yn4j83hVU+NUVgAHC2KHJNyS0aM0/aE+PmsK+P85dvcg7w7R18csUrFEyucdBt97Tc6aq/ri/AwUpx6kDY/siIeajSY/HQ8+oV5SuVPcYD5dyaowiVdNk2ruv312M+BxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463094; c=relaxed/simple;
	bh=WtIqqb3Qz76cjqi0EoDty0yZzRmnvQrkK4n/LtQ6xEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI+f5dmY0z1eS8n/18ZhL/T27qIXipBh7z9BdSdSbNl/HpEPVBGzHIm7b784CiR8giOxvfNbvFB5+7hHVQubG3YOqoUbnBoqvxupJcP0IQZS0OkDDg+jiUh0+lLMYGE3GJfIMte/SvJuipaOzks+LpOyB++ND0oaFyI0PmV0/Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EieKqTAk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whIiuNRJJmYlfQ3wiaGZ/HmATem6GNPoxo7pUmmbAqQ=;
	b=EieKqTAkrDo0LDV1F9bo1DPI8UsrfVuin/ZUB2iLfRFIID7Vqf0qKIRCx9Ro9vLkqx4siO
	f2vW2uRdbADcuQDmlOFpcUQeeqs+wKDj/K7Efzmj1qK20EnomDaB4UE5bzPFkaclsi46kc
	rgvlMyoN/aqyg0vnD7vpClmifJH5SyU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-bTQco0RFMESSsS3xTHO0zw-1; Wed, 09 Oct 2024 04:38:11 -0400
X-MC-Unique: bTQco0RFMESSsS3xTHO0zw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b10e7958c6so78219085a.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463090; x=1729067890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=whIiuNRJJmYlfQ3wiaGZ/HmATem6GNPoxo7pUmmbAqQ=;
        b=rX9FTxGyEERkp9WYoaNvnawx2eQVD43cXBo0xSDM74CtD8C48zk54aVQGdVcQ5pH7d
         ZWOqOnRQKqseLnsrQODVvS6yGG+HZTZwI4pmAb6VyGSfw7oFMUT2hJ5N4RlYBGx8BFYn
         mVyAl4drdekb4mijx+0Fmw9Mo6xrx0gswbcBW17JCNzTXDHelF62W+WyZ7iB47Svo4Rh
         CcwoEVIxMl1b8v4Nk5yEzK2qa5nsArkQ/8npwCrTxDxK6PloJtue8GK6dSArYlavVIAL
         HMH968rLVD8tcLhaWyIavj2NWvbWD+sYAAD+vcxyRUBmBiNQEzbrJB8ByqkhQqtQMu9S
         iszA==
X-Forwarded-Encrypted: i=1; AJvYcCWT7xLW/H1KN48I58cuwrQ7lf+AcBefoFp6W2iyIXSJRBdXkNoc5otX4UdhF3NMgfB7Ey8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQQL/lEAz/vPpJVXLG7HcfQsZ+xo/p+pwPqhtXAaj1b2piMG+
	PH8XjJD710d/ajAmulRCTrlTn4ip4TlOxDLH8cb/0M4m6b0Ev2/V4wz4yrRBw2VhMbZ0tFj2YMS
	nDIdOohBD1Ebdys6hy6+oe2D4JYPUYt5fkC3rtM8vHQShnL9epw==
X-Received: by 2002:a05:620a:6006:b0:7a9:ab72:7374 with SMTP id af79cd13be357-7b10ed4fff8mr102284085a.35.1728463090682;
        Wed, 09 Oct 2024 01:38:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/MgCEUv0CJEAIc6rr0qvcu86NTMXEfUgLL+h2hiKBHzQb8C5W8ydxW51ghGpiTPgzdZQtmw==
X-Received: by 2002:a05:620a:6006:b0:7a9:ab72:7374 with SMTP id af79cd13be357-7b10ed4fff8mr102275485a.35.1728463090297;
        Wed, 09 Oct 2024 01:38:10 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:38:10 -0700 (PDT)
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
Subject: [RFC PATCH 10/13] staging: rts5280: Use always-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:16 +0200
Message-ID: <20241009083519.10088-11-pstanner@redhat.com>
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

rts5208 enables its PCI-Device with pcim_enable_device(). Thus, it needs the
always-managed version.

Replace pci_intx() with pcim_intx().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/staging/rts5208/rtsx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index c4f54c311d05..4831eb035bf7 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -246,7 +246,7 @@ static int rtsx_acquire_irq(struct rtsx_dev *dev)
 	}
 
 	dev->irq = dev->pci->irq;
-	pci_intx(dev->pci, !chip->msi_en);
+	pcim_intx(dev->pci, !chip->msi_en);
 
 	return 0;
 }
-- 
2.46.1


