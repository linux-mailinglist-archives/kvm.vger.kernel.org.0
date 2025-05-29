Return-Path: <kvm+bounces-47997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C4DAC835F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2CE91C00E5A
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 20:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEC5293462;
	Thu, 29 May 2025 20:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYphrWw4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373702356C4
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 20:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551742; cv=none; b=LAD3+Gl2Iw7uPa+qI8Gor2UKW4m2LbxXlqjpwMh7oXl9ipDA8Mojhg0TQxnSgJtQ2//3mmC4xEM5/T75GKxvqqMlkkymdnHQRwDtJoD6diI/sT5pk0g4cwYrvZJZ0aQQM6OioRgYFnpJqpY7/7lFXB2AeKFVg9mcH5gwsieQtFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551742; c=relaxed/simple;
	bh=ih8DlvU4tKofltliu46O2s62nPDCCu+VEeNQCQzA6Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Cp1+EPRd//+6bUsR8hDWKzdu1OP9SPeSClb7u0VlD9DLT6oWh+W63SZNsDy2nUAcF48YAjzptQh5ahLwHb4Ob+ZT2CD3+q+/rNR3khWcYknlWVypy4CKT4LQTgBnk9GzkEoW2t+V+ppcyWm5SYU0BEaZQf44B/O8d/Q+ebT86YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYphrWw4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748551739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZeQ2Vo+oQZDQGCMwwHxe2K14O9sa4zRfd9DC9KDPWg4=;
	b=hYphrWw4IWfzQguv9/NIp678rvSTmQRyP+NmSnis8tAB4QBye/uaSNsRnBGBANajKi09tV
	deDQhHhsGEmVexGwQClbX7WffBFQ2qM56k3ZgK2wRTrtUuTE3j46iOhW8Ak6zyUWrtrAvi
	5zGQ6l/WNL5/0+W8XAeO1lopZSH5qFE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-1r1Loi41NnCWPF4MqA4sHQ-1; Thu, 29 May 2025 16:48:57 -0400
X-MC-Unique: 1r1Loi41NnCWPF4MqA4sHQ-1
X-Mimecast-MFC-AGG-ID: 1r1Loi41NnCWPF4MqA4sHQ_1748551737
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8643da7eba4so25052139f.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748551737; x=1749156537;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZeQ2Vo+oQZDQGCMwwHxe2K14O9sa4zRfd9DC9KDPWg4=;
        b=vds8e1N0R65N1wLCKx3RlnUAOadtLB4m0AuMcucdUz0cuiRqsXi1byMKt9YI18ZWLE
         PvUDCsivpXIZhqrk2Sb53PTWPM3geBGZCApCy7Or+G6I0HQx8UtMiAfabLvtoX0g1rWS
         hWJCvdgIbLM+LqeAyil/q/XD7kgXiCdSgrVwet4ii2zLEramPL6gT3fBz71lqcmBW6xP
         tuFTs0lsFwiEMmn3sr85Yl3QahcO1S3G3oR/3k2Yt6D5MefnQDuHhVtjmPE3hR6PHUez
         AZaHC+weR+++K/j2q0vbqKgA7OKCxTyDt4xvSUaFJCTtVw77Ni29PKRzR1Lo/LpioR6K
         Uj/g==
X-Forwarded-Encrypted: i=1; AJvYcCWltBG+0So2TwPBn6rAonyQEQW8ujMOfri2URCqOI9lRKMqivkSt8KwZLUo2R/KmKZS9oY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqbiasJjglV88/x0rtpmrf05k6gIrDRCFzLFmHDOl3Py3GvUt1
	Iws1BXF+R/zgtpDOnPpZLVVObKqo1UQdJWyPWuTR182mrFfTVaNw7Pii1lNiqDU3VKzb1zVBjIj
	8mLjLo+YIE0phNQtIEnB4pFuIOcTAKA3qwe/fCjGraNMb9zuZz1zKQQ==
X-Gm-Gg: ASbGncuMHcCMlA0bHVVIr2u58mIBxsx5bCe/KzoeSQVEEBN6td9Wl0DjTFaNYzMmt9N
	AvPx1pO6nHp8FAIWBX6n+smpp4tG/cxpSn2Z5fD4AIUf7fXIsBMev6wip8QeXHlz7xU0zZQIMS/
	742vMaZF1hZchSVNCOXawjWs3mk5piLZ974VYYHXAGcGyaxatQtYAD3y+j/c/xQs4Kr9QlrVTpe
	sU25XlPpMOih8iYN3J92UFXhaCBfYX5PgDr7gVsPGcbsS9cHlBbfKJ+hhMXlqqBnfpxmsvy9y5/
	WTMzb3wXxslV/SQ=
X-Received: by 2002:a05:6602:158e:b0:864:3df4:29e9 with SMTP id ca18e2360f4ac-86d026e6e05mr271939f.4.1748551736680;
        Thu, 29 May 2025 13:48:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFs7nGM96u64Rohq1xYaZrhS0fIeg77cLR+/KgxB5GeNDPWvzAH+3nY+R63aPqOG0LhIRDjNA==
X-Received: by 2002:a05:6602:158e:b0:864:3df4:29e9 with SMTP id ca18e2360f4ac-86d026e6e05mr271739f.4.1748551736317;
        Thu, 29 May 2025 13:48:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e4fee3sm43971639f.10.2025.05.29.13.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 13:48:54 -0700 (PDT)
Date: Thu, 29 May 2025 14:48:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.16-rc1
Message-ID: <20250529144851.1ce2ce66.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

Please note the diffstat below is generated relative to a trial merge
against mainline as the merged topic branch from Marek has already been
pulled via 23022f545610.  Thanks,

Alex

The following changes since commit a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.16-rc1

for you to fetch changes up to 4518e5a60c7fbf0cdff393c2681db39d77b4f87e:

  vfio/type1: Fix error unwind in migration dirty bitmap allocation (2025-05-22 10:41:24 -0600)

----------------------------------------------------------------
VFIO updates for v6.16-rc1

 - Remove an outdated DMA unmap optimization that relies on a feature
   only implemented in AMDv1 page tables. (Jason Gunthorpe)

 - Fix various migration issues in the hisi_acc_vfio_pci variant
   driver, including use of a wrong DMA address requiring an update to
   the migration data structure, resending task completion interrupt
   after migration to re-sync queues, fixing a write-back cache
   sequencing issue, fixing a driver unload issue, behaving correctly
   when the guest driver is not loaded, and avoiding to squash errors
   from sub-functions. (Longfang Liu)

 - mlx5-vfio-pci variant driver update to make use of the new two-step
   DMA API for migration, using a page array directly rather than
   using a page list mapped across a scatter list. (Leon Romanovsky)

 - Fix an incorrect loop index used when unwinding allocation of dirty
   page bitmaps on error, resulting in temporary failure in freeing
   unused bitmaps. (Li RongQing)

----------------------------------------------------------------
Alex Williamson (1):
      Merge branch 'dma-mapping-for-6.16-two-step-api' of git://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux into v6.16/vfio/next

Jason Gunthorpe (1):
      vfio/type1: Remove Fine Grained Superpages detection

Leon Romanovsky (3):
      vfio/mlx5: Explicitly use number of pages instead of allocated length
      vfio/mlx5: Rewrite create mkey flow to allow better code reuse
      vfio/mlx5: Enable the DMA link API

Li RongQing (1):
      vfio/type1: Fix error unwind in migration dirty bitmap allocation

Longfang Liu (6):
      hisi_acc_vfio_pci: fix XQE dma address error
      hisi_acc_vfio_pci: add eq and aeq interruption restore
      hisi_acc_vfio_pci: bugfix cache write-back issue
      hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
      hisi_acc_vfio_pci: bugfix live migration function without VF device driver
      hisi_acc_vfio_pci: update function return values.

 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 121 +++-----
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h |  14 +-
 drivers/vfio/pci/mlx5/cmd.c                    | 371 +++++++++++++------------
 drivers/vfio/pci/mlx5/cmd.h                    |  35 +--
 drivers/vfio/pci/mlx5/main.c                   |  87 +++---
 drivers/vfio/vfio_iommu_type1.c                |  51 +++-
 6 files changed, 341 insertions(+), 338 deletions(-)


