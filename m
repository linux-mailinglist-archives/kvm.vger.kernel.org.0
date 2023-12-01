Return-Path: <kvm+bounces-3180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3150980178D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DECEA280FEC
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FCF3F8F5;
	Fri,  1 Dec 2023 23:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpPkzUDT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAD5FC
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 15:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701472933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2It67EXDhApMVqtGRDR3LyeWNVXSB0HYmIpaVAhnqBE=;
	b=EpPkzUDTPWWVHvHN+rjYZHJQdcWlAtPerA334FyjcrbwMOb53Ve7kdzeD4473pvu9KH0Bp
	B1cLUOC0XuEo9kc9MjaGB1PeR3edA9X8PK+qf4/IvBt7sxCM+8wF112FWaEazTXA/lGZjE
	n033fas05FOuNGV6QgVCzVxyai5stw8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-6xijDPXYObmU88hubWSzdg-1; Fri, 01 Dec 2023 18:22:12 -0500
X-MC-Unique: 6xijDPXYObmU88hubWSzdg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7b42af63967so6956439f.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 15:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701472932; x=1702077732;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2It67EXDhApMVqtGRDR3LyeWNVXSB0HYmIpaVAhnqBE=;
        b=I87uU+O0dQHZ+OXzGlEmqIKh82O2C23SNA5jNpswlNYdYfZP8sUYoNI9XnMjN/XsVd
         WmlmQn92xyhyJCaNGfXFPlhZOov56yYR4sTgIttriwVhYQmnGubjtZZswRz8vDGQWMET
         mtb77XQ8K8ytuwCdZHaJYey0OIVTTIwfacCLMepWLiTa6LA18NPBQfAcYjOsueMibkd/
         omO3u5Hmt/2rYJ3zGDxTkcDEqAva2WT6RITgg/RUuXaM4MtbHZ/wJI4aLy2BsLRbk/eV
         ilm/j1QOZcVwBRzw2XNfFSkSwfL5nw4INBhkf2koCRz/8iSztyYLvph2Au8kX1teBGBJ
         1Zxw==
X-Gm-Message-State: AOJu0YyENITeNPG23avbvxody+mi3QUzkbKcBQVV+CauoA/703+IKUxd
	ODKzHkkrTh4bqPorHRCzqJw3uhB/aWxyVXHRWBrXawahrF559cqejqgrIxNsm5YmEsNyDxe0sOk
	z9qI0zq49yCeb
X-Received: by 2002:a6b:e815:0:b0:7b4:28f8:2bf8 with SMTP id f21-20020a6be815000000b007b428f82bf8mr378567ioh.33.1701472931934;
        Fri, 01 Dec 2023 15:22:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFazra/I71ZeyXPm/bApiqsfwZgJ1ogQvL8QHOBXoLZrytqb6Z7nk+emp8aFIg/bHDAdwCMNw==
X-Received: by 2002:a6b:e815:0:b0:7b4:28f8:2bf8 with SMTP id f21-20020a6be815000000b007b428f82bf8mr378562ioh.33.1701472931716;
        Fri, 01 Dec 2023 15:22:11 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id cw2-20020a05663849c200b004640db25da8sm1099439jab.131.2023.12.01.15.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 15:22:10 -0800 (PST)
Date: Fri, 1 Dec 2023 16:22:09 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v6.7-rc4
Message-ID: <20231201162209.1298a086.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab:

  Linux 6.7-rc3 (2023-11-26 19:59:33 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc4

for you to fetch changes up to 4ea95c04fa6b9043a1a301240996aeebe3cb28ec:

  vfio: Drop vfio_file_iommu_group() stub to fudge around a KVM wart (2023-11-30 11:27:17 -0700)

----------------------------------------------------------------
VFIO fixes for v6.7-rc4

 - Fix the lifecycle of a mutex in the pds variant driver such that
   a reset prior to opening the device won't find it uninitialized.
   Implement the release path to symmetrically destroy the mutex.
   Also switch a different lock from spinlock to mutex as the code
   path has the potential to sleep and doesn't need the spinlock
   context otherwise. (Brett Creeley)

 - Fix an issue detected via randconfig where KVM tries to symbol_get
   an undeclared function.  The symbol is temporarily declared
   unconditionally here, which resolves the problem and avoids churn
   relative to a series pending for the next merge window which
   resolves some of this symbol ugliness, but also fixes Kconfig
   dependencies. (Sean Christopherson)

----------------------------------------------------------------
Brett Creeley (2):
      vfio/pds: Fix mutex lock->magic != lock warning
      vfio/pds: Fix possible sleep while in atomic context

Sean Christopherson (1):
      vfio: Drop vfio_file_iommu_group() stub to fudge around a KVM wart

 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 30 +++++++++++++++++++++---------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 include/linux/vfio.h            |  8 ++------
 4 files changed, 26 insertions(+), 18 deletions(-)


