Return-Path: <kvm+bounces-65291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1536DCA43B0
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23149313601F
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21BC2D97AB;
	Thu,  4 Dec 2025 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBy3L8Ip";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdjHzAw1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8103280A29
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861013; cv=none; b=PRnDOrJ7ALZKiJtI7VHE+n9ujj3tcj5jEPwb6g33gviQQ0az2GmEtr89wIXn17UFs/1QP5IHWa2JGXyIalP5qAtCQEQG2lmgczloaliRkB/tnvZ+eU4JI3Mz7tBB2LlY8JHPINDMwR+CkQAwWUrSI4vxGrSstvSdXdiCF7OJ9Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861013; c=relaxed/simple;
	bh=hRw909hsYtm2e5B93fgKIIvka/HUziL1SH4ns6RYGS0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=U0jD4PunBdrZcjdw7My1OOf50WD8RoNnitbcenLI8kj3aYJ4UGbidPuGbSpQGF1KHAunowZmJHeKXb3Ov1xSEamkr7d3oemWzOVKjUhYvMUByf65CXNxJeW7gzUwEyg7BHZoMi5vJs7LDdBXNesWc+o8/RaVjyTbWlw6C3mamL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hBy3L8Ip; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdjHzAw1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
	b=hBy3L8IpWlKBe1CsA4CFW81TIXpuvYhNerfnNFsd2QyVXhOSViMM+I9zRCOUnX1zXhKIde
	vn/zao0ttSTkRVt5HZitIhMSm0A8dOevbmCySvzJWXyv/UzQz+V1fTsGhDRiCL9XHx6rxl
	7qHa5vjwy1bgEPOaRJDoUyF27d2nCYs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-piI8V_B7M8aygQ5QZfrgcQ-1; Thu, 04 Dec 2025 10:10:08 -0500
X-MC-Unique: piI8V_B7M8aygQ5QZfrgcQ-1
X-Mimecast-MFC-AGG-ID: piI8V_B7M8aygQ5QZfrgcQ_1764861007
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2d2c91215so238837385a.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 07:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764861007; x=1765465807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
        b=HdjHzAw1zYxxvYVvXi5djhi4oBQQAqbKGxQTD1ZXaY/OTXdka9BjWUqikLn6WnRHfp
         Sxffbdl8GzPZbjp2ai984xm+MemIQQQ0XJJX9zavUKSmqj4qRWF8Q7KskAMri3HHX54h
         h1mLfvHN+Y+QGRrqjWebfPGBgwebKPs5X7hzvzQ2vfEp9gOVj5moNKoY4yV0c/6jD/7U
         S1Rw48Q9KNEJu4mx/2BdbSF6vicTHKaVQq4V2ZMg/OGWtXX/3+HNHCH+AAG58q+jaVHa
         HfLtUznte9TpKnzhseP008AR3yGJCL3ubQnesoNIqQQxZr1VCJLB2sJD3LqxbCl+XjqO
         8byQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861007; x=1765465807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
        b=pwZSyM+Vn8kIZ0jHWQgNvKPLBxlNadMpLArZ5k2OyUKA4sSKdKcNKo1JVbqw5Np5NW
         xVGnNmfUn9mMxi8I7keIktBopydu36VUCPEzCVxa3uxNQJjoGBgealr+wpZDd5FTnAF3
         Dyer4sPeKcVPq5IxnsL6/ryygRT93spyScfHZhp7usKfV1zWQUUFZHal6KFQQ4dduL8o
         3jzxjNWVTASDu9hk2dP+hN85az3NBJvzPGe2EaBPAS2z3o+1+l6xNLicCCUcBFxRl2Kn
         /LA4hDwND1lBb7ZnuUvF9G96pwMIh55dOluE2H/bCAtzSImoI2ZWmZhlKgenwICVOhCt
         tzfQ==
X-Gm-Message-State: AOJu0Yxn6dEo+gcNDiU/fQtwSEXe9h3iyJTjPBCsloXvM6zSau8j41kv
	QJU6ahMCaGSCaO0kDQvx7/slhiCmQ2Fv9Kg5Q2pEeast1izwl1b8v2+sMhmx3CvzUoPvujx8afP
	xWzeIbCEud0XzYECFGj9gMNAsH8AMWWQOwJmsftkGCqo82f4fJi98TDhX7SHFUxP/ncU1+E4E1X
	BqjDoS+fJ50zElYLlIfORWqe1X3JzyU1fjx/8=
X-Gm-Gg: ASbGncsLUDfzIsAnEDuZh4LlFtkUHkMjMRNnCQT57UeNSHetPjdVZaKlPhEnvPprd+7
	1X5uBBvMoXw0HopUD6e8qGklMIqhiOxZENBW+BJ23/NQWATqPb0d+zgAd6L7/kj8anLCLH1c8Q+
	XTKwWjJbWLX2AFFyiRgeICrh8dm+NQy4I947TPqAoyot2NUqINXOcpr+Ts7ruDrCgyDlC9X7ykh
	4KIdIHhunVagebo0C5YlrYm7GciYz/6hzppTSS8uW6s6PjcAWHWeIedTpUKdr/Uxm/rHuidZPjh
	rY8QeQDHaCVbfNOzHuyQb8Denyt/iM02wVspgQIXXWSwb711/femmycJg6vFuWTv66RaD8uauaY
	N
X-Received: by 2002:a05:620a:280d:b0:8b2:f29e:3b00 with SMTP id af79cd13be357-8b5e6a905e1mr808459585a.51.1764861006826;
        Thu, 04 Dec 2025 07:10:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyH0V7BtmZhH2ckfMcjK9avGlDSwL+lIn0HZdyHGEVc1fLrFDrwIW691WvbiU7DsS62jiCgw==
X-Received: by 2002:a05:620a:280d:b0:8b2:f29e:3b00 with SMTP id af79cd13be357-8b5e6a905e1mr808450985a.51.1764861006226;
        Thu, 04 Dec 2025 07:10:06 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:05 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
Date: Thu,  4 Dec 2025 10:09:59 -0500
Message-ID: <20251204151003.171039-1-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is based on v6.18.  It allows mmap(!MAP_FIXED) to work with
huge pfnmaps with best effort.  Meanwhile, it enables it for vfio-pci as
the first user.

v1: https://lore.kernel.org/r/20250613134111.469884-1-peterx@redhat.com

A changelog may not apply because all the patches were rewrote based on a
new interface this v2 introduced.  Hence omitted.

In this version, a new file operation, get_mapping_order(), is introduced
(based on discussion with Jason on v1) to minimize the code needed for
drivers to implement this.  It also helps avoid exporting any mm functions.
One can refer to the discussion in v1 for more information.

Currently, get_mapping_order() API is define as:

  int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);

The first argument is the file pointer, the 2nd+3rd are the pgoff+len
specified from a mmap() request.  The driver can use this interface to
opt-in providing mapping order hints to core mm on VA allocations for the
range of the file specified.  I kept the interface as simple for now, so
that core mm will always do the alignment with pgoff assuming that would
always work.  The driver can only report the order from pgoff+len, which
will be used to do the alignment.

Before this series, an userapp in most cases need to be modified to benefit
from huge mappings to provide huge size aligned VA using MAP_FIXED.  After
this series, the userapp can benefit from huge pfnmap automatically after
the kernel upgrades, with no userspace modifications.

It's still best-effort, because the auto-alignment will require a larger VA
range to be allocated via the per-arch allocator, hence if the huge-mapping
aligned VA cannot be allocated then it'll still fallback to small mappings
like before.  However that's from theory POV: in reality I don't yet know
when it'll fail especially when on a 64bits system.

So far, only vfio-pci is supported.  But the logic should be applicable to
all the drivers that support or will support huge pfnmaps.  I've copied
some more people in this version too from hardware perspective.

For testings:

- checkpatch.pl
- cross build harness
- unit test that I got from Alex [1], checking mmap() alignments on a QEMU
  instance with an 128MB bar.

Checking the alignments look all sane with mmap(!MAP_FIXED), and huge
mappings properly installed.  I didn't observe anything wrong.

I currently lack larger bars to test PUD sizes.  Please kindly report if
one can run this with 1G+ bars and hit issues.

Alex Mastro: thanks for the testing offered in v1, but since this series
was rewritten, a re-test will be needed.  I hence didn't collect the T-b.

Comments welcomed, thanks.

[1] https://github.com/awilliam/tests/blob/vfio-pci-device-map-alignment/vfio-pci-device-map-alignment.c

Peter Xu (4):
  mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
  mm: Add file_operations.get_mapping_order()
  vfio: Introduce vfio_device_ops.get_mapping_order hook
  vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings

 Documentation/filesystems/vfs.rst |  4 +++
 drivers/vfio/pci/vfio_pci.c       |  1 +
 drivers/vfio/pci/vfio_pci_core.c  | 49 ++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 14 ++++++++
 include/linux/fs.h                |  1 +
 include/linux/huge_mm.h           |  5 +--
 include/linux/vfio.h              |  5 +++
 include/linux/vfio_pci_core.h     |  2 ++
 mm/huge_memory.c                  |  7 ++--
 mm/mmap.c                         | 58 +++++++++++++++++++++++++++----
 10 files changed, 135 insertions(+), 11 deletions(-)

-- 
2.50.1


