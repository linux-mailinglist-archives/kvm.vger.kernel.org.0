Return-Path: <kvm+bounces-21863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 326109351A2
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 20:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F02F1C21077
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 18:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599AA1459F3;
	Thu, 18 Jul 2024 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3yOwSTE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF58442045
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721327745; cv=none; b=cHtYiBTMuuI7IFEhtV5z//jf5MlWASPCyxleQ6/WSplP1iZoBf0vT8GHD+KAk4BCmdLDH4XB9BPnvb7UNUT4XUF6kw9zPC+lhJfu7VLBZAR2UTeLQ7X+2DG8Ij4NdwyoSf/NVIec7RteJVPPA2rdz5KNZR+cb0Pn5hotyg7J9hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721327745; c=relaxed/simple;
	bh=u02ddkAcPCoiLwQdxM0rK+aeGphrXzTinlCWIgn2fgc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=cBppChaA0A/iqpLbM/j0v7rbZ7X9e0DBhW2ynBjO1JXtXohapQgquQ4e92EUIeKaANPDOcgQJzRSGKA4O/0dpuqnXDmakfsVTappefxQCW/nsSaL+N9K5C7tNhB2ffI25QT1K8cXO4S8po0A0YI+P3zKTyZQQqLkWtOJY7PtDbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3yOwSTE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721327742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PyuFM1OIMvIXLcmAF20k2pO7T0rexvFXzXgDHWSM8q0=;
	b=O3yOwSTEAXP0F5B+g0zh8aOBUuMcSpWfWV9mh/MgQ+450C0nJZzes0GopOnKoFnXAA3ZgR
	DJ7AZ0/TrgqIHqpCGeellgk/NL7AESW20C++lAwHcZfHaJNc6M9mFMTNAKUbrZn6ITvV/d
	dqC3u3O/0CtFNHhJYKcjxiDtGBze0bs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-7ZZATx2NPsmu2UPt4uwbaw-1; Thu, 18 Jul 2024 14:35:40 -0400
X-MC-Unique: 7ZZATx2NPsmu2UPt4uwbaw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-397052a7bcbso10798465ab.2
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 11:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721327739; x=1721932539;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyuFM1OIMvIXLcmAF20k2pO7T0rexvFXzXgDHWSM8q0=;
        b=szmaZG44jTHyWCgjlkr8z0F38HRFo0gyAdb+Rzi+jQkhg9vdc+DGOj6uZpDOG2WsQH
         BsStEZebM/cqVxl5NnweaOJ4034tJaxgVkqeZjeLV96vVp5heT7AK8rDglkz+svqIvI5
         EfTCUtueSYiHco0DXRHRr1WarHFaTsqUPwW+VJJ0vRKFu9MXdQz9fhRy+SClKOq1NXGj
         K5rpV/Xfr5sK7BZrX2soMvQcNdMSPfm3Usq/dfMqNWqyoXF3A6py/ZRbW//sn5kjgRbI
         MNtb2ONQyOHoL8BxsbUPyZ5omdEjUPs4Q8Hnswh9Qzh4xe97X13WYC6xqvSqHoTXYvUz
         Ec9g==
X-Forwarded-Encrypted: i=1; AJvYcCXgE9x+qwGlH3IzZ2lzVp7d1BBPEdR4WfW9RPJ+H6j0rKd04Cz69z2SubTrVy9TWcuhLMNiLSELwkjIBhk6kPDyV9bN
X-Gm-Message-State: AOJu0YxB3G22mTgk3jEIJt/mKwPCTmjdG1Ao8AhZ0egfhO2KYmDzDtDD
	bdSIH9exhv5s44qSsYuJcMvqLNqsSZtKl+ZY8CtZEtXdTmYoxRgWHFB9o/nJBzycTH/kx/ztyYC
	fKuh5DrJe4NGX30wky/cHvan0epFr1AIxiCGGBA2eEqHqpFyhdY9gSO91gA==
X-Received: by 2002:a05:6e02:180f:b0:375:a3a9:db49 with SMTP id e9e14a558f8ab-395557fff0bmr78420575ab.9.1721327739540;
        Thu, 18 Jul 2024 11:35:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEx1qPRUkHN6qE40URnXw+SHEmKc+lZRbuQ/6PJzWWtSfJeXV+gE3MMKAO+C7tH3VwQB7WTHQ==
X-Received: by 2002:a05:6e02:180f:b0:375:a3a9:db49 with SMTP id e9e14a558f8ab-395557fff0bmr78420355ab.9.1721327739241;
        Thu, 18 Jul 2024 11:35:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3950c80f614sm18428005ab.55.2024.07.18.11.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 11:35:37 -0700 (PDT)
Date: Thu, 18 Jul 2024 12:35:35 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.11-rc1
Message-ID: <20240718123535.270f63f2.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a few commits this cycle.  Thanks

The following changes since commit 6ba59ff4227927d3a8530fc2973b80e94b54d58f:

  Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.11-rc1

for you to fetch changes up to 0756bec2e45b206ccb5fc3e8791c08d696dd06f7:

  vfio-mdev: add missing MODULE_DESCRIPTION() macros (2024-07-17 12:24:13 -0600)

----------------------------------------------------------------
VFIO updates for v6.11

 - Add support for 8-byte accesses when using read/write through the
   device regions.  This fills a gap for userspace drivers that might
   not be able to use access through mmap to perform native register
   width accesses. (Gerd Bayer)

 - Add missing MODULE_DESCRIPTION to vfio-mdev sample drivers and
   replace a non-standard MODULE_INFO usage. (Jeff Johnson)

----------------------------------------------------------------
Ben Segal (1):
      vfio/pci: Support 8-byte PCI loads and stores

Gerd Bayer (2):
      vfio/pci: Extract duplicated code into macro
      vfio/pci: Fix typo in macro to declare accessors

Jeff Johnson (1):
      vfio-mdev: add missing MODULE_DESCRIPTION() macros

 drivers/vfio/pci/vfio_pci_rdwr.c | 122 ++++++++++++++++++++-------------------
 include/linux/vfio_pci_core.h    |  21 ++++---
 samples/vfio-mdev/mbochs.c       |   1 +
 samples/vfio-mdev/mdpy-fb.c      |   1 +
 samples/vfio-mdev/mdpy.c         |   1 +
 samples/vfio-mdev/mtty.c         |   2 +-
 6 files changed, 78 insertions(+), 70 deletions(-)


