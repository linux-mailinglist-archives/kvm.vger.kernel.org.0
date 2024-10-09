Return-Path: <kvm+bounces-28183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F60996321
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A03F1C2329D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E508E18C03B;
	Wed,  9 Oct 2024 08:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRWJaBOY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4CD191489
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463022; cv=none; b=cTOx8DLIDORUqIqTXNlaG0v8EcWIAIXVKqH1oPZNi1O+SVYrjTzxxUkzZTHnkqB/pohrhX8xUS54/LzIH4zVzxMsl7/Cic7ikEmGclz2CEOVh4WR82yClKs6gIcMATTTfo0Q+n8GL8UvUIKM6W5UIr4jE2RtnruWQyXwe6wB/U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463022; c=relaxed/simple;
	bh=mnlbyKVHuZwz2vfwiuiGqUk5LIdw1w6V3s4ejKqAsNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcuLW91pVgGvzlm4HYNkn1ts44FypBb7RC33cnf5GXw4GlpvaVEjW7sKzhFScMWQ54sHwXLZKfQBZWwoYmjPUi1z3h+b5wHKbLacdbEDFX18jf4Cja+RGtkSj/AEkE69AL6frBH9ToViZHfrNSvLnmTRbpFgVIoj9stG9S14ark=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRWJaBOY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PPm9S1zRcO86dlq3mHzZGXnJgcIWsisXbqhvFp0Kes=;
	b=CRWJaBOYYD8QRCqaRa4T/ff9f0aNNHpEko9cycMEcpX8sQuh9TDgUKCKzoCDyrszGDf45/
	Me+1bfuWWmeoF8T1+FU+gefkDBPz153Yk4rm/ixEMzW+fL3bmKXBhQ3d5j+geniElifFS5
	aEbNVGXj1dNwD0X4KtPm+1on6PAdKEM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-kNVNHcjEOs-4dszLjwxBBw-1; Wed, 09 Oct 2024 04:36:58 -0400
X-MC-Unique: kNVNHcjEOs-4dszLjwxBBw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a9a6634b08so124359585a.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463018; x=1729067818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1PPm9S1zRcO86dlq3mHzZGXnJgcIWsisXbqhvFp0Kes=;
        b=C3K0zu5+NBtX5InMNeM769oE/bKCtRvcQPBU/069uSehm5hTnZE8cxGpAHbXuVjbg/
         aiSilfgJwLxJ1ZqMFnVZorgnxGLqX+7+nMsPH+cI3RhbVRgQl2ROCaUiiR1yyX72LdeH
         WHnIj4u7PBWRW5jnQclVFHhp8Re5Z8UfLiigCiH92vjjcl6b2UozbtEzPrhWbJR25WH5
         gaH6A132mu3OhcRkRtKurPAllImWjeDxAEzLxkFoV4leYvcTNvRCJ/hAAijIdNZ50EMq
         N3GDUN368ykEGNOhqOplBVyybnCKvbAqNh9fBDwAW7HE/Oe2bVIVA+i4Qud7ihUUNLPO
         uMEw==
X-Forwarded-Encrypted: i=1; AJvYcCWOf6BgNN16pMAbRC7IKijdMsP4OqbfvC4iX2rw8FSL+GYo9V3rf7Fqa7FzhC67/t/D1eo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhzL/ng/DIFKYA6RxAtYCF8b4Raf6AD0z7gRCP+wKbdnJi/cGb
	Mo4Tmv2BN5Af29kO3VCn1ovB6N+C/9/bYMuatVZhqR90EriUd+bx3gUsg0MKjW/bvG3j9a3yZfv
	qJ2j6//y48ZjKKOgHMhFKNJuzGAcT87KeAVRh1bzP9ANLN3/aUg==
X-Received: by 2002:a05:620a:40d2:b0:7af:cea1:2dd6 with SMTP id af79cd13be357-7afcea13062mr575431185a.9.1728463017683;
        Wed, 09 Oct 2024 01:36:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvN3DzIDBf5agA7u3XzrMCdDXSCcUz6hrKViBRxZsE1bbVXxxuhuZe+LfXJzoxle8rULiRWQ==
X-Received: by 2002:a05:620a:40d2:b0:7af:cea1:2dd6 with SMTP id af79cd13be357-7afcea13062mr575422585a.9.1728463017195;
        Wed, 09 Oct 2024 01:36:57 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:36:56 -0700 (PDT)
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
Subject: [RFC PATCH 02/13] ALSA: hda: hda_intel: Use always-managed version of pcim_intx()
Date: Wed,  9 Oct 2024 10:35:08 +0200
Message-ID: <20241009083519.10088-3-pstanner@redhat.com>
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
2.46.1


