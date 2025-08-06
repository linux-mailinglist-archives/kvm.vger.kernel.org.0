Return-Path: <kvm+bounces-54117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A55B1C8D6
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 17:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AC8A1890618
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 15:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589A9292B4D;
	Wed,  6 Aug 2025 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuQhlecS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489A92918D5
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754494521; cv=none; b=tQ7TOlacJlavYMcw+z3ZEtofI8d6VISTxmixahqXEoWUIrnWVE2nsgnTQowfMp4hw0IbSShB21+4zFqyNFvFSoDMuFrT1ygm0g9Bzeylj3kblAP0Gy1cyouo1MtGu4h6PCJKdHGHubWcf+nAsFAADzp17trPhmQv09q3pSW+Yfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754494521; c=relaxed/simple;
	bh=cF98SEkmgLDyuUz5la2IFBq9eSKef3X/kl1+HDLc3So=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=cH/jrRPwRzZsZR56xijvUoVKWWLIITJzjqeKu7Uo1G0Vsk/21osQMFsceY03wz3Zr+RdKTWYwffoc1xkxFN63i9M2I+4r9HO7s/pAjWSAT3lQyGJlb/TXp4wEjE+t9W/vzsQiM/3K47Cd7rJeTcr+hs+Wu1zW0T9hu8HUNd+d9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuQhlecS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754494517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KdUYeA7YCatcEo56/VENniS5EQAYeVyAwozRoB1GUX4=;
	b=iuQhlecS4ibAUymOiMxOdJzXvynCglTtBJccvNafCUjK5sb2HB3gq5EZPKpjgdc/SXMMey
	YNUgw4u2/gnZ9LekjntZ7J82pYbx/sqlBqB+zkUTD9u5A6y3ygrFXYOuUyitRX4C283E7A
	/RNWD/JlECR0amh2bhFIs9iSKrksaS8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-ajYYOwjIM-iaABdNDx_YYA-1; Wed, 06 Aug 2025 11:35:15 -0400
X-MC-Unique: ajYYOwjIM-iaABdNDx_YYA-1
X-Mimecast-MFC-AGG-ID: ajYYOwjIM-iaABdNDx_YYA_1754494515
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-881333b71a2so39301939f.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 08:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754494515; x=1755099315;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KdUYeA7YCatcEo56/VENniS5EQAYeVyAwozRoB1GUX4=;
        b=GBYd/RUoy0aJQmGxlX8hJPd9LquQ2iEaUswAMOgou0Cv+DSAAQf5fx/iCQZtNkY2D/
         IT//xyP4lglMtsEc4g/i924JZdkxDs/YzXIuPWTlZ+lb3s59f6a7XZUnJEN9QH/HGqhZ
         LSInsuZ3C9ZQkktHHj0K7YPjFQmeiCEVPTP5hbwOvnRkwDOhAJa7ZJAMIzmtskk8NTuo
         Zxqpxq99NoshwLRGOSlWP6qCW/3ZncUn+LSyQ9p3XrSRefgDqVhH9H87zijuNnEldC5v
         60njPULz9pSXCfUYbPCLRolKn6/WJK5HBhioBYD8NA4a1tH0uoiiLG68tR4Qm9iXQvP6
         fu0g==
X-Forwarded-Encrypted: i=1; AJvYcCWOBIMMobdjHy4jXDp+DWoO040xDuio5w6rr9Zg21UI9L7Wwbao357GvBLoQweUR3sHAVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/FIzEo+x0rEZCSv8hvhPy7EHN+qfns1B8Gzo7Q4CVEcIlRAhw
	V0svvaQU5IYnxNpY/6SJ9r1EoV/OZJtFuPoqmloE+oU8bKXUpauDtOfBVd7Ijt5d1ennviS3hml
	GSevQg1m8HA+bORRhgKatEXEEX78dqDmMmXcwviS4/SdwQUuSTlecsA==
X-Gm-Gg: ASbGncu3O7ttopIe3FepZMzTR2LbulMIezPYaMkOLK6xhl+Ve1mlh8+kFNK7Vo92O5z
	+z1nkqJb8GBd3Ly5J5UvMj7jKKip/1sffuFUn2SkbI9fulkOq7YHCFUYW7DGMNPuCRfFo42vIPX
	T46C8IuH6yLYqrTqPqO3uFsvxQry+iYhx9HuzqLKcbQwtjFKC9uEVPPR6gN1v+u7yU5+BGS7GR/
	8lWLbU/FqZ0molk+u8Hv2lhU9xfY5BNGyV6lLfN+QU4y0zUpBc5rVA1yVB/TIxR+94YWHzaumt4
	+iFFjMcyf+Anb4zoFCzdhsFVFskTiiAZMSAFTjQtbCc=
X-Received: by 2002:a05:6602:3407:b0:881:982b:9963 with SMTP id ca18e2360f4ac-8819f15d6eamr165283339f.3.1754494514865;
        Wed, 06 Aug 2025 08:35:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr61K454O/LcAG5ElZj+GaCuS+x7EaUPT+YI54dzPgtM40KpgzZ/COM65VNEppBUAYn+Bk5Q==
X-Received: by 2002:a05:6602:3407:b0:881:982b:9963 with SMTP id ca18e2360f4ac-8819f15d6eamr165281739f.3.1754494514338;
        Wed, 06 Aug 2025 08:35:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3351sm4982001173.87.2025.08.06.08.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 08:35:13 -0700 (PDT)
Date: Wed, 6 Aug 2025 09:35:11 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, Jason
 Gunthorpe <jgg@nvidia.com>, "lizhe.67@bytedance.com"
 <lizhe.67@bytedance.com>
Subject: [GIT PULL] VFIO updates for v6.17-rc1 v2
Message-ID: <20250806093511.2909a521.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I've dropped the series with the troublesome mm helper in this pull
request.  We'll continue to work towards something acceptable there and
re-target it for v6.18.  Thanks,

Alex

The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.17-rc1-v2

for you to fetch changes up to b1779e4f209c7ff7e32f3c79d69bca4e3a3a68b6:

  vfio/type1: conditional rescheduling while pinning (2025-08-05 15:41:19 -=
0600)

----------------------------------------------------------------
VFIO updates for v6.17-rc1 v2

 - Fix imbalance where the no-iommu/cdev device path skips too much
   on open, failing to increment a reference, but still decrements
   the reference on close.  Add bounds checking to prevent such
   underflows. (Jacob Pan)

 - Fill missing detach_ioas op for pds_vfio_pci, fixing probe failure
   when used with IOMMUFD. (Brett Creeley)

 - Split SR-IOV VFs to separate dev_set, avoiding unnecessary
   serialization between VFs that appear on the same bus.
   (Alex Williamson)

 - Fix a theoretical integer overflow is the mlx5-vfio-pci variant
   driver. (Artem Sadovnikov)

 - Implement missing VF token checking support via vfio cdev/IOMMUFD
   interface. (Jason Gunthorpe)

 - Update QAT vfio-pci variant driver to claim latest VF devices.
   (Ma=C5=82gorzata Mielnik)

 - Add a cond_resched() call to avoid holding the CPU too long during
   DMA mapping operations. (Keith Busch)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Separate SR-IOV VF dev_set

Artem Sadovnikov (1):
      vfio/mlx5: fix possible overflow in tracking max message size

Brett Creeley (1):
      vfio/pds: Fix missing detach_ioas op

Jacob Pan (2):
      vfio: Fix unbalanced vfio_df_close call in no-iommu mode
      vfio: Prevent open_count decrement to negative

Jason Gunthorpe (1):
      vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD

Keith Busch (1):
      vfio/type1: conditional rescheduling while pinning

Ma=C5=82gorzata Mielnik (1):
      vfio/qat: add support for intel QAT 6xxx virtual functions

Xin Zeng (1):
      vfio/qat: Remove myself from VFIO QAT PCI driver maintainers

 MAINTAINERS                                    |  1 -
 drivers/vfio/device_cdev.c                     | 38 ++++++++++++++++++++++=
++--
 drivers/vfio/group.c                           |  7 ++---
 drivers/vfio/iommufd.c                         |  4 +++
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c |  1 +
 drivers/vfio/pci/mlx5/cmd.c                    |  4 +--
 drivers/vfio/pci/mlx5/main.c                   |  1 +
 drivers/vfio/pci/nvgrace-gpu/main.c            |  2 ++
 drivers/vfio/pci/pds/vfio_dev.c                |  2 ++
 drivers/vfio/pci/qat/main.c                    |  5 +++-
 drivers/vfio/pci/vfio_pci.c                    |  1 +
 drivers/vfio/pci/vfio_pci_core.c               | 24 ++++++++++------
 drivers/vfio/pci/virtio/main.c                 |  3 ++
 drivers/vfio/vfio_iommu_type1.c                |  7 +++++
 drivers/vfio/vfio_main.c                       |  3 +-
 include/linux/vfio.h                           |  4 +++
 include/linux/vfio_pci_core.h                  |  2 ++
 include/uapi/linux/vfio.h                      | 12 +++++++-
 18 files changed, 99 insertions(+), 22 deletions(-)


