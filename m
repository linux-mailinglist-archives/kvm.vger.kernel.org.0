Return-Path: <kvm+bounces-17790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 238DE8CA1D5
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A77741F2271B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1161138487;
	Mon, 20 May 2024 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MN/TPm5e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83113792E
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228752; cv=none; b=TFFi+ptzS9INTu1tZIM0U1wiefK5zpSG+bSs9W4ZCd/nO6mSFlU+U5jG0yJd7bTbUf0QJx76UFSGCfryZYtIS+kd7TkFsZx7TUhHYGg0TRp6GKltYva7wPwO2XlV5k3rWhpyFEci1N8Vmy0V8ZjqigjXL1gap6ARz2XoB2nu5vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228752; c=relaxed/simple;
	bh=AvNgiG7Ty6On1gO7eAIVeqPSZaEDl5cwVHkvkiALAVM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=URsjnCD+uPM9hqUfZobYzwU2sDlRjVAfUOTkse/iR2S76dVjP90O1LvBY8S/GHTZ38mful2c7GFjm6mGCuKYicSDGdnhph76LAVBvb6SIfp1pNcIYP4nQ8sOXivDUGAxuNw6JAZWGv28d2GmaQC/RFF4EC0fE50lU6SfGSU1bFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MN/TPm5e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716228749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tpgK0JNXc3vf5jmgzRV5GAwx2RKOrBVvEHmBko1zztQ=;
	b=MN/TPm5e/rneXjSc2HTWHPnNGGl20gVuvukwULoBMpp45RmcNFDEdkU3IgK/trz5aA1N8s
	4PoDM6tvd9I1/TC9yi+tyJxDtjdNNLFMeJ8oy4Ja6lrDhK5d0eacARInxcdGr/SEDfhbKA
	BIo2Ja8lozhdb5j5F5X+XD+Lpsiw0Xc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-FyUBFNQ-OgeIaw-Iw7NO1g-1; Mon, 20 May 2024 14:12:27 -0400
X-MC-Unique: FyUBFNQ-OgeIaw-Iw7NO1g-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36c1af8f2f3so132536375ab.3
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 11:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716228746; x=1716833546;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpgK0JNXc3vf5jmgzRV5GAwx2RKOrBVvEHmBko1zztQ=;
        b=e6pI8sPbTqiCZswUxZHfqCz0WSUvFQ0UfXux0TQZvk/dO78ctX063WOm3arE/OcZ7H
         Yjkm9NbD/zz6ZJxTxJKgEFwhx9T8Eaje7+geUHCsghMKudUjcILFR2Wf2iEaMZwq6+MV
         iYBnDwH5Kn41G8HNGFhOkks2UPv+zh0+OMN8htyMl4QSbKIHA0SioQYYc/5FkqgUOQ4C
         SWTaiPrlkt3RFAgDKPZu6GM8AWUIJXsxkoXuKYffWIu1zMDi/SLplSVmt49kdgrPVaId
         Lr8INQUfIyONBxVx3FHO6l7+kz5CXU+S5ityYyneYJ+p8RuBaFtQtqJieUTzERGojBQj
         3ezw==
X-Gm-Message-State: AOJu0YwGmbb3htQlSQfcQLY1aC7NsjrFHbFc7eWR6ddyG3DlKIRUQFgt
	ypFFNvIM3fSqDaXr+cRq/z6zathOtPWSfSx4wu2zNRb+EuT4EYaIPGUv5QcPfjkercLIuB69NVZ
	4b++IX5ybQl7sfA1kcxUUvYj+/4GVR8iUEgmx5nLjeg+Uwqg8JerOgJtoBQ==
X-Received: by 2002:a05:6e02:2169:b0:36d:b8cd:7c76 with SMTP id e9e14a558f8ab-36db8cd7e71mr171582905ab.8.1716228746129;
        Mon, 20 May 2024 11:12:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdEPsxzqSvPh4vEUG/JNB19h8REHHXMFfUi7xd8FcqA0aTyQNf3ide0gJ71CzeFmyt6kI3Xw==
X-Received: by 2002:a05:6e02:2169:b0:36d:b8cd:7c76 with SMTP id e9e14a558f8ab-36db8cd7e71mr171582795ab.8.1716228745816;
        Mon, 20 May 2024 11:12:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36dc7c21e1asm20816795ab.81.2024.05.20.11.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 11:12:25 -0700 (PDT)
Date: Mon, 20 May 2024 12:12:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.10-rc1
Message-ID: <20240520121223.5be06e39.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

I've provided the simplified diffstat from a temporary merge branch to
avoid the noise of merging QAT dependencies from a branch provided by
Herbert.  The dependencies were already merged in commit 84c7d76b5ab6
("Merge tag 'v6.10-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6")
Thanks,

Alex

The following changes since commit ed30a4a51bb196781c8058073ea720133a65596f:

  Linux 6.9-rc5 (2024-04-21 12:35:54 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc1

for you to fetch changes up to cbb325e77fbe62a06184175aa98c9eb98736c3e8:

  vfio/pci: Restore zero affected bus reset devices warning (2024-05-17 08:00:52 -0600)

----------------------------------------------------------------
VFIO updates for v6.10-rc1

 - The vfio fsl-mc bus driver has become orphaned.  We'll consider
   removing it in future releases if a new maintainer isn't found.
   (Alex Williamson)

 - Improved usage of opaque data in vfio-pci INTx handling,
   avoiding lookups of the eventfd through the interrupt and
   irqfd runtime paths. (Alex Williamson)

 - Resolve an error path memory leak introduced in vfio-pci
   interrupt code. (Ye Bin)

 - Addition of interrupt support for vfio devices exposed on the
   CDX bus, including a new MSI allocation helper and export of
   existing helpers for MSI alloc and free. (Nipun Gupta)

 - A new vfio-pci variant driver supporting migration of Intel
   QAT VF devices for the GEN4 PFs. (Xin Zeng & Yahui Cao)

 - Resolve a possibly circular locking dependency in vfio-pci
   by avoiding copy_to_user() from a PCI bus walk callback.
   (Alex Williamson)

 - Trivial docs update to remove a duplicate semicolon.
   (Foryun Ma)

----------------------------------------------------------------
Alex Williamson (6):
      MAINTAINERS: Orphan vfio fsl-mc bus driver
      vfio/pci: Pass eventfd context to IRQ handler
      vfio/pci: Pass eventfd context object through irqfd
      Merge branch 'vfio' of https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6 into v6.10/vfio/qat-v7
      vfio/pci: Collect hot-reset devices to local buffer
      vfio/pci: Restore zero affected bus reset devices warning

Nipun Gupta (2):
      genirq/msi: Add MSI allocation helper and export MSI functions
      vfio/cdx: add interrupt support

Xin Zeng (1):
      vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices

Ye Bin (1):
      vfio/pci: fix potential memory leak in vfio_intx_enable()

foryun.ma (1):
      vfio: remove an extra semicolon

 Documentation/driver-api/vfio.rst |   2 +-
 MAINTAINERS                       |  11 +-
 drivers/vfio/cdx/Makefile         |   2 +-
 drivers/vfio/cdx/intr.c           | 217 ++++++++++++
 drivers/vfio/cdx/main.c           |  63 +++-
 drivers/vfio/cdx/private.h        |  18 +
 drivers/vfio/pci/Kconfig          |   2 +
 drivers/vfio/pci/Makefile         |   2 +
 drivers/vfio/pci/qat/Kconfig      |  12 +
 drivers/vfio/pci/qat/Makefile     |   3 +
 drivers/vfio/pci/qat/main.c       | 702 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c  |  81 +++--
 drivers/vfio/pci/vfio_pci_intrs.c |  61 ++--
 include/linux/msi.h               |   6 +
 kernel/irq/msi.c                  |   2 +
 15 files changed, 1116 insertions(+), 68 deletions(-)
 create mode 100644 drivers/vfio/cdx/intr.c
 create mode 100644 drivers/vfio/pci/qat/Kconfig
 create mode 100644 drivers/vfio/pci/qat/Makefile
 create mode 100644 drivers/vfio/pci/qat/main.c


