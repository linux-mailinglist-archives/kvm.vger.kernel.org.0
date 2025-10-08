Return-Path: <kvm+bounces-59648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B38C1BC5F49
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 18:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6457F19E0656
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 16:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31492F360C;
	Wed,  8 Oct 2025 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWBMIDax"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60D82E8DEB
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759939735; cv=none; b=Bhlzp52v3ZglpUO4ltDTxf6AK1+qin/2QlvRabPSOodVsbYvx3SMxejYkYB4A0Fnk6SdEzUTNWr7Si7TuY20B/fngkSx7C2g6bS2PNbZzqARr/x25ditGG3WgZ2d0ni8uIi7qqVf2X4uipHaFPZW1ATO+mep53JUyxAw4hRL/Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759939735; c=relaxed/simple;
	bh=vk3AuPzABSqiYhDKyK5DZW5TBoEaJm0wm/y7QixLxVw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=u8cl+GOkFCqWf/ZRAH6lAOtF+C4LjX0cGmj1vdlCqjco4rrHPtDatEBrEjoi5kNK8zXIgO+M+13TLdJoSUz3/nFCVSNXZTwo5RjgbelAeJcfBoye/VFW59ZJTwkOOyhTOyEJk+KMfbjbZiVAyeSNRvtM2lmHvVRDEXKOk9W0WtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWBMIDax; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759939732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d83HNR6tAkbhcYaA0tnAzOhkHW7QfhiumWGCMyzcg9A=;
	b=hWBMIDaxhaAtdEdpLAnIC7J6jcIMfnYJivMpbZyKWk9TfL3TVWLKwWLwEEwUzYeUQCsq+F
	SH5J/9/C5D/S+agmv7HQmfzadJewLG2hg6DcFPkFxRk51c0VWUEB1jPX2qVqsUSU37zNLt
	FWYWYbLqmltpkqZJE1VX1oZqI3wnKOE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-SR7frf0gPXueZyRdwF2geA-1; Wed, 08 Oct 2025 12:08:51 -0400
X-MC-Unique: SR7frf0gPXueZyRdwF2geA-1
X-Mimecast-MFC-AGG-ID: SR7frf0gPXueZyRdwF2geA_1759939730
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88dd4fb24d1so57089439f.2
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 09:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759939730; x=1760544530;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d83HNR6tAkbhcYaA0tnAzOhkHW7QfhiumWGCMyzcg9A=;
        b=LsBbU0IODcts04TeoqwqfaR/nc7Gg7jkZBFKv8+7KHHuQYzWMdeS/E1+7iJ4LOyFd0
         pGaCFOvzHd5IRVROWpKNRAWhTPznwPxyo9zgbkqZ9GGBdjH7QlT462qtaJ0O0SN/gTJD
         YuIb0NYUQ0k5GS3AMfFnZcr8U9GE/kSsA+GxzB/2o3oSaBE/DyU/pwxSUQ8wj7QWYveA
         12dDDdp1GpRi4rnu7GT2xzxzv3iMj8VJmW8sjtJGxAGqMutMY+EIlZ9yj0yulzXaksTm
         Osnh+WOLZPQQ/ot0gt1qXodFc979ooA0xEKE0HF/1F/12o42VhIpmKmKwtFqgn0noyek
         KeuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQkQxaBX60lBnJZreEAeah85cUoKUXkP7PjOFPXQa2HLPFiNTnX4IOHcP0zuR54AOSsIc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPiYlxernuhd7lgur9OvX+rFN7GZqTXEMvh8ysy22WBv5rcCQh
	aQO6D87iW3fa8cZN6ODKfcz3mBjWJ993hQMy11s4nUm0chkFML4WErjNruRHGhvrw+tJAlsUy2f
	DruQSvNCmOY7rV5zfBzcUdtEa/NPHqIbYVPlh96OuIsGNXUIsSt8mcA==
X-Gm-Gg: ASbGncuimVnCDcJ+qgKwROn5vbfzhaghmx22imDrFTsBJoK64T/tJIW0DcUa+5st3g7
	3dDU736nWnevzi1jMH7G4wOSEJm0QIJJiaMAhByMu4O79V8lWgn+RGBZNnzrKpH4kWITKJU957D
	CDptfT2YcNW08iepY/hBgwqqw07ye5my6lVYXRhAf0Dh6umVPNSNABBXAhTf+QW63x+VoFCzmeY
	a0/va1zinBm+rjjalElmGzOgtrqkLLOPV1ZaUKuYl3y/q5oJliYCBETvFOz6f4LjVhn/Dr8DAFy
	Za4wAuV2iSzRqK3ocUta0SeAB9PQ7LRq91LDwpDjiE4IpZPn
X-Received: by 2002:a05:6602:4016:b0:921:5e64:677 with SMTP id ca18e2360f4ac-93bd197e8cfmr161410139f.4.1759939730082;
        Wed, 08 Oct 2025 09:08:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg4nuM2w2if09kF/9hjDJAQxyAe4TBWUu9omT72OFBq2W4qsR27e2Ru0/zlWuNm4KiUOruMg==
X-Received: by 2002:a05:6602:4016:b0:921:5e64:677 with SMTP id ca18e2360f4ac-93bd197e8cfmr161408239f.4.1759939729565;
        Wed, 08 Oct 2025 09:08:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5e9ec393sm7191810173.14.2025.10.08.09.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 09:08:48 -0700 (PDT)
Date: Wed, 8 Oct 2025 10:08:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com, =?UTF-8?B?Q8Op?=
 =?UTF-8?B?ZHJpYw==?= Le Goater <clg@redhat.com>
Subject: [GIT PULL] VFIO updates for v6.18-rc1 part 2
Message-ID: <20251008100846.47bcedd1.alex.williamson@redhat.com>
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

Sorry for the two part pull request, this is mostly the DMA map/unmap
optimization series that we tried to get into v6.17, but made use of
the nth_page API that generated some objections.  That has since been
removed, but was stalled again by the page_to_section() to
memdesc_section() change, where I opt'd for this two part approach
rather than resolution buried in a merge commit since we saw it coming.
Thanks,

Alex

The following changes since commit fd94619c43360eb44d28bd3ef326a4f85c600a07:

  Merge tag 'zonefs-6.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/=
git/dlemoal/zonefs (2025-10-05 20:45:49 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1-pt2

for you to fetch changes up to 451bb96328981808463405d436bd58de16dd967d:

  vfio: Dump migration features under debugfs (2025-10-06 11:22:48 -0600)

----------------------------------------------------------------
VFIO updates for v6.18-rc1 part 2

 - Optimizations for DMA map and unmap opertions through the type1
   vfio IOMMU backend.  This uses various means of batching and hints
   from the mm structures to improve efficiency and therefore
   performance, resulting in a significant speedup for huge page
   use cases. (Li Zhe)

 - Expose supported device migration features through debugfs.
   (C=C3=A9dric Le Goater)

----------------------------------------------------------------
C=C3=A9dric Le Goater (1):
      vfio: Dump migration features under debugfs

Li Zhe (5):
      mm: introduce num_pages_contiguous()
      vfio/type1: optimize vfio_pin_pages_remote()
      vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remot=
e()
      vfio/type1: introduce a new member has_rsvd for struct vfio_dma
      vfio/type1: optimize vfio_unpin_pages_remote()

 Documentation/ABI/testing/debugfs-vfio |   6 ++
 drivers/vfio/debugfs.c                 |  19 ++++++
 drivers/vfio/vfio_iommu_type1.c        | 112 ++++++++++++++++++++++++++---=
----
 include/linux/mm.h                     |   7 ++-
 include/linux/mm_inline.h              |  36 +++++++++++
 5 files changed, 158 insertions(+), 22 deletions(-)


