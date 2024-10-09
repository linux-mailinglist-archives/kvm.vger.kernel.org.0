Return-Path: <kvm+bounces-28181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3AC996314
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD340287BA0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1508190054;
	Wed,  9 Oct 2024 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dlcKQg3a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A092918A948
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463004; cv=none; b=tTE5Dmz6Rw1b8oMoEtp++QqgndXzddUiGPeziLr/PgJiCFWMF56v0hM25PVoAKHdh5NDVD+HkL05W//fhV+3bjpHWDDfuJTFM9faeqk/0cQFzzaVpfdCFpQexeVuQCTcgvRD1W0obXF40+zKiLifCdXEIlSKgf2PCFBdbzJCNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463004; c=relaxed/simple;
	bh=bwupmCthuGaQS+qMZ/7SrXy7Oyd/5BoNqSfbGXSX0bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StR6cVkM+ZBbUMEs0Z3rO8FcJ7CvtCmyzP0qhHsO0fXkMp5bbYgNWg0TeFB8jFvCLtz3pfuHpkKKiL+9MC4W0yUAFr0T9ef1zvMbSnWzmbxWcWcTEDc0UbmPkHWMEa3o5bdYFsNQmSWLMWuJv7uVi65iShme5Q5uZtZwZ9MKdhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dlcKQg3a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mOyNV1blUkGi8SBN/l2nmGqTH8tAJ4tec1wRLOcI2Z8=;
	b=dlcKQg3a8m+Ov6dKMeyzaVgzv5GTg/ltRgXo6J2rEa/VbSXMTlOF36tYdo4ROEvCY6DTnH
	pmlsL6Ol4Q95DfEcPMvKsk4hgHB4hb+Tgt7AjwR3orCVzVmQqdlSbSC7oIE2Ll0ZJHFSiU
	A2cJiEeFaoC2Ro2OAOXoC43KMkpb6C4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-suYZnThaOOyMBgc2qLk0OA-1; Wed, 09 Oct 2024 04:36:40 -0400
X-MC-Unique: suYZnThaOOyMBgc2qLk0OA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7acca6cbe87so1142924085a.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728462999; x=1729067799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOyNV1blUkGi8SBN/l2nmGqTH8tAJ4tec1wRLOcI2Z8=;
        b=Dj/xdPu/v2XgpjmKHbfM7fr6L1PlDmX9H5z2vWD2FbHpQ4ayNQdaQMAXG51lkH144k
         9Tg+UACdx+aCilptIBmfHJVpuDd6r/DaqjLdDphuMGGzqh/x1OlavXprqAZKRBF43mvN
         u9eghlX5JzcUDwVUWKYmor/JHKWVsJHJaK49nvYXTG49Lx0rQ/GO7OIhqFKozMpW2ffg
         JYao/zCV7H6dVdn+0n5GufE5ZZ1dkTbW1MaTPXnjV6WdgkTrVCEeZQlC8Yhiv/LW9KyF
         3KBhdmoZ7RPAAGE8nXBFtwyAAYKLgYoqyGYdWK99tTl4eRcZqbDAKC/CB0oLo3s7PFMs
         asNg==
X-Forwarded-Encrypted: i=1; AJvYcCXFHeV5fhI45W8/CaqbVXQ+AT3yoRrIT3fWV1s/nDc7gmcBjNcvVCZTtwvh1RKcwjO4Eag=@vger.kernel.org
X-Gm-Message-State: AOJu0YyquNfD0vbiuGXyDSk4Qm9qe2K3WPv79ipGPqFGNT9OPCMUozI9
	eMQtiNeN1EchJ+KDBLrj6mxWl8CnwG5s9gDFu4k1d+uCYy/FPlz0bnGcP335LGGVXd+hRKzrACi
	xAHx1kjtcR5aPpktSvq97KzUsQPro+8PNL7mxNzZJAZVtFrKBLA==
X-Received: by 2002:a05:620a:29c7:b0:7a2:1db:e286 with SMTP id af79cd13be357-7b0874cd670mr234483085a.52.1728462999268;
        Wed, 09 Oct 2024 01:36:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFU56nfNbRn4xRa9L06f5Bja7V/qokH03xrDBZWS39o5ckdxWurQft3H7j0iSjtDvnBZDt4+Q==
X-Received: by 2002:a05:620a:29c7:b0:7a2:1db:e286 with SMTP id af79cd13be357-7b0874cd670mr234479185a.52.1728462998841;
        Wed, 09 Oct 2024 01:36:38 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:36:38 -0700 (PDT)
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
Subject: [RFC PATCH 00/13] Remove implicit devres from pci_intx()
Date: Wed,  9 Oct 2024 10:35:06 +0200
Message-ID: <20241009083519.10088-1-pstanner@redhat.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

this series removes a problematic feature from pci_intx(). That function
sometimes implicitly uses devres for automatic cleanup. We should get
rid of this implicit behavior.

To do so, a pci_intx() version that is always-managed, and one that is
never-managed are provided. Then, all pci_intx() users are ported to the
version they need. Afterwards, pci_intx() can be cleaned up and the
users of the never-managed version be ported back to pci_intx().

This way we'd get this PCI API consistent again.

The last patch obviously reverts the previous patches that made drivers
use pci_intx_unmanaged(). But this way it's easier to review and
approve. It also makes sure that each checked out commit should provide
correct behavior, not just the entire series as a whole.

Merge plan for this would be to enter through the PCI tree.

Please say so if you've got concerns with the general idea behind the
RFC.

Regards,
P.

Philipp Stanner (13):
  PCI: Prepare removing devres from pci_intx()
  ALSA: hda: hda_intel: Use always-managed version of pcim_intx()
  drivers/xen: Use never-managed version of pci_intx()
  net/ethernet: Use never-managed version of pci_intx()
  net/ntb: Use never-managed version of pci_intx()
  misc: Use never-managed version of pci_intx()
  vfio/pci: Use never-managed version of pci_intx()
  PCI: MSI: Use never-managed version of pci_intx()
  ata: Use always-managed version of pci_intx()
  staging: rts5280: Use always-managed version of pci_intx()
  wifi: qtnfmac: use always-managed version of pcim_intx()
  HID: amd_sfh: Use always-managed version of pcim_intx()
  Remove devres from pci_intx()

 drivers/ata/ahci.c                            |  2 +-
 drivers/ata/ata_piix.c                        |  2 +-
 drivers/ata/pata_rdc.c                        |  2 +-
 drivers/ata/sata_sil24.c                      |  2 +-
 drivers/ata/sata_sis.c                        |  2 +-
 drivers/ata/sata_uli.c                        |  2 +-
 drivers/ata/sata_vsc.c                        |  2 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c        |  4 ++--
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |  2 +-
 .../wireless/quantenna/qtnfmac/pcie/pcie.c    |  2 +-
 drivers/pci/devres.c                          | 24 +++----------------
 drivers/pci/pci.c                             | 14 +----------
 drivers/staging/rts5208/rtsx.c                |  2 +-
 include/linux/pci.h                           |  1 +
 sound/pci/hda/hda_intel.c                     |  2 +-
 15 files changed, 18 insertions(+), 47 deletions(-)

-- 
2.46.1


