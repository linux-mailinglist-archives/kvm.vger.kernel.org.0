Return-Path: <kvm+bounces-28938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C095299F62F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 20:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38562B20EAE
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BAB1F81AA;
	Tue, 15 Oct 2024 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIhh/qmg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7688E1F6697
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729018313; cv=none; b=cDxNMwCwpRyl2qmn5eGVuEdrqXfp6HcBb7SwBYBM8vyjD0hajbB6i+qY6FgrBG6VG0i+pNKzLG8Iphjx2j1rzNk+Nv+ggmL8FkzLNJ31Zsfj/TQcET4nOQhfFopCKcalykeFMdUygZlFSMEWIcpRQVHFHP7Jf8lA51baUF4T86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729018313; c=relaxed/simple;
	bh=KHLKi60pv4gLVTsiuJyXLJXAzGodCYBvpuQkjf82Rd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfsH65qEG3Am+LuzEkScTHxRxb624sbI3sEPECB8FTXcQ39h0JpM8Vrd9K4kK3AeoLvWEXZM7QUk4Jk8X7TavbYmRQx791LLbin88Unb0WHF1WBh2S6REWu/Rkuod1dg+nCZ3BezathnPQ3kfnLkdfHSQEtw9B5Lgz5friU5Lh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIhh/qmg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729018309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bl3QB30NLAEEM3JzJm3v9Fl/AaPLWrckmhbzUoxAcY=;
	b=gIhh/qmgxQ2pPvvPJXjiSGpFhRQDI+Gs5k86wb6DxozkgIdYOV+o07b/lq3rOjlym0us5x
	aAvfst7M+iBJzquqEeHZ6oNfUOBmbE+ScLH8JmLx8EF2ZXi1TwQR+AU8Yl4eaaOR6w3VZ6
	puJat6inyEktFLT1fH/wA/BLUv24U8s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-bOo8O2ZkNbaHxOJgk0QQ5A-1; Tue, 15 Oct 2024 14:51:48 -0400
X-MC-Unique: bOo8O2ZkNbaHxOJgk0QQ5A-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5c94ccfb210so3348191a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 11:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729018307; x=1729623107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bl3QB30NLAEEM3JzJm3v9Fl/AaPLWrckmhbzUoxAcY=;
        b=BGS9eYF6vyzQXZ/QFnsEVlgJnjOu+Ve3y9gfcZuxP8NBDBsmVxPP2b9NxIMIS/YJPv
         1aOnbBUWCuqeNFSbiSbbMeE1B40Bzs9znQwydhVH+VftgpcFirbwLn/df5SbUU1bU0Nj
         5gdTM/TC6/ZFpKv5Cz7o8jwtb+nn/bSmEuhaM5C5jTF+MLpk1quimzeegAVBsQusTJb/
         y3oFeVeVMg50liJqrt8TfYP/lPJ6CMOGwdeCSRpF8TYc3GEmC/PW9wbDduPB2bHy32g/
         Yncx7rG8X8sZy3ITsoaAupzCIL4WX0vcD0WgM3bdVWV7Heu2aqSK0iEZS1iy4Fz8tDHn
         tbAA==
X-Forwarded-Encrypted: i=1; AJvYcCV9wk86fgjcBWL3UVoSG9XAkcxTJFPpLhMgpgTg+t9/5O5Iquoj7cWXHzS4qCPxYg6Wg6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcD0P5LK3sXqzt5TjdgUNnQddOjh0Gfs0Zw9Sm/9VaYOh+DmUf
	acolor5oi2S1vJhXBAYAe/DF5+FbKsktkvzbNDnR3dnojoD8osd+2z3D3bRo/2aqFWQBSbBhU9/
	TQjv9R1LXpzK6VJiaKZrSgBssuJbI67G0wvQyE1oHQHrjwNDy3w==
X-Received: by 2002:a05:6402:274b:b0:5c9:758c:307d with SMTP id 4fb4d7f45d1cf-5c995123e65mr1042726a12.34.1729018307284;
        Tue, 15 Oct 2024 11:51:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcpsVUn9n0QaeMUMW5c7DLX/r1R+cfZY7789CvnHFdFGuHG3lQrtgeZ9VzucvxMpAlT7QteA==
X-Received: by 2002:a05:6402:274b:b0:5c9:758c:307d with SMTP id 4fb4d7f45d1cf-5c995123e65mr1042656a12.34.1729018306780;
        Tue, 15 Oct 2024 11:51:46 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82d5d5a0006e2615320d1d4db.dip.versatel-1u1.de. [2001:16b8:2d5d:5a00:6e2:6153:20d1:d4db])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d39a9a2sm974438a12.0.2024.10.15.11.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 11:51:46 -0700 (PDT)
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
Subject: [PATCH 02/13] ALSA: hda_intel: Use always-managed version of pcim_intx()
Date: Tue, 15 Oct 2024 20:51:12 +0200
Message-ID: <20241015185124.64726-3-pstanner@redhat.com>
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

hda_intel enables its PCI-Device with pcim_enable_device(). Thus, it needs
the always-managed version.

Replace pci_intx() with pcim_intx().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 sound/pci/hda/hda_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index b4540c5cd2a6..b44ca7b6e54f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -786,7 +786,7 @@ static int azx_acquire_irq(struct azx *chip, int do_disconnect)
 	}
 	bus->irq = chip->pci->irq;
 	chip->card->sync_irq = bus->irq;
-	pci_intx(chip->pci, !chip->msi);
+	pcim_intx(chip->pci, !chip->msi);
 	return 0;
 }
 
-- 
2.47.0


