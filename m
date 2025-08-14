Return-Path: <kvm+bounces-54642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D8DB25C2C
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 947555A56AE
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6897B259CB2;
	Thu, 14 Aug 2025 06:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ix8c6bxz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BAD259CB0
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154065; cv=none; b=HfobC3y9CNnwbrqiU5NYcg/TayMDQrppn3VfGCeP/g/fYFDQui4ckxKPgd5oCIpZfY4EHwM2ACI6RvMx7hJfHtKaEOOQ3lxmZCrjjJ0rUXn4jG/r5vOUWkcMUWcGKq9lw6LuU/lFG9bxk6HHeW9RYgFf5jYz/vRtoc6b0ycUMkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154065; c=relaxed/simple;
	bh=qqm9v0QJBbxVVQn7AoFq9tSWZaBsc5dcOISlyW3Yipg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T8S2RBigbWvIYMPyMO75UkuuNcnq69nPCcaN4PfHYjHXh8sRS8Qf0aUHfKsqQgbh4Z8dBzCQg2PDh0CPl0cwYs7WkwJvljaK+o6XXQ1hnqvgGAhYwha3XGxeS6hQaeGnMY4cwZhdL7JtrCpb5IxZKPESWjjQRbsgrycJm0rFWJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ix8c6bxz; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-244582738b5so4763815ad.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154063; x=1755758863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc/79XSwvseOMROg0iCTGbt49umwlFqoanOatXRXlL8=;
        b=ix8c6bxzMZ6yuarZZggVCFCb7o5B/BtbeUo2QadmEccwZFF1fRP3X6Bw1Buh5iX6H3
         eqyYl/Ii20Jx0lJK0JjR9Lk2pEdOqDpqmJm20jEnnihWCcjjUU8aJ0vhbpWm1fU3Vn5T
         wC4BP2ddMQtKIuPALHWi6Mz6mpo4uTzSlsqBBPzL4XUOYrr452LbXnzni/jo6caHVVe4
         IZWGV9MLWe9HeXjJtJSSBsu9gTpHEsOa6d1oqUW7H/FV89dxVZzUxGdcvUuRTlde8Bd8
         S90zowVq/otUMBcMUX8fkZmf3EHOzzxnu2fbD7QeaAtH24UmlAezha73e8pPAS7LkTML
         CjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154063; x=1755758863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zc/79XSwvseOMROg0iCTGbt49umwlFqoanOatXRXlL8=;
        b=c5nusplZqFlgsv5iDnP9rK4jx2v7FK7Z4PNAy5QoAKcmwqkpO1reGzVezWsnD6QlSe
         voR+RObdVmjlPe+HrBAS+rWMKrBuZWzdMgsmd8Mv+vsqLyheGsMu1cUAX88GOue7qeGS
         MrnWeqEvSUaVdIDtJJAHsfmSAVRS3uDrEY1ZsCO0ou64VCLIQlNBBjPJbWvRZq5wmuXT
         7Lgc80k+HG5ImX5jYz5BJovMoNR8nLVVjPvevOy1RFGj88iHEf19uFNIkoXzE7+UHVtH
         YD385ehgVD0QRfJO+Kc69kmv/vo49Vsoas38yNUoHnzGM+WnF5HuRjIWVwX6DdslFyyf
         mXBg==
X-Forwarded-Encrypted: i=1; AJvYcCUWYnqqTj703KnQtKtJqjzZtY27oiytaizjuk7GBgLUO/M/xF0KD+UKGt2leuZsqf/WYw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUnpgRdqNmkYuCmnuC+xVImImXW3zA4gInfmgKEvD8B8DnD4O1
	7BjyBEJd4EJdQQF1nNtCbk0dlR9sSpjw/zViGzdhFIJRUk6OKkbq63m3JDw7Y1MKVsQ=
X-Gm-Gg: ASbGncvktWPRh5fuf05oU4SWKpu/NvmkBkCmo9q5qoCT7BGTgzJOfV5AsTRKz2zx04j
	M5+NGHOxaCSamVNw0ioUid51XPrY+ylpgPdCheyy9eUpwvASPWtPezjkeTBcm6Tc1LaSeqc9hf8
	voic4CZO/3FhOlRdoA4rYA7PoHvLB18+IR6o7CaOVR9Nl8iZh62SSXfTNqCExBQOM2aE3y2QYp0
	WpFBmlscEPb97dBgMnoN+45n0oR1+BTkc69KkFDPY93fxG/vGhdqE2Eh188+BBk32EnVlibHkH0
	TC37/Rt1JMPgNEKTgfe3R9gsr3Zg1FPjhgvwJZE8A5w3XyOZdAcB29uNRvWpPvUBrfv+h4m8SVc
	UU97JaWBHsVib6iFddqtcjvuVJr0tc7nQj4ghXuDqW6dBg7hg9w==
X-Google-Smtp-Source: AGHT+IEb3eJicXsgaNlyzBQ3nJS4mCdWERJyOxedSkNcWUM25YdoSAcIjs1UdYpqo12C3/PgqtNh2g==
X-Received: by 2002:a17:902:ebcb:b0:240:58a7:8938 with SMTP id d9443c01a7336-244584af696mr28229005ad.7.1755154062636;
        Wed, 13 Aug 2025 23:47:42 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:42 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 0/5] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:09 +0800
Message-ID: <20250814064714.56485-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is an integration of the two previous patchsets[1][2].

When vfio_pin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

The function vfio_unpin_pages_remote() has a similar issue, where executing
put_pfn() for each pfn brings considerable consumption.

This patchset primarily optimizes the performance of the relevant functions
by batching the less efficient operations mentioned before.

The first two patch optimizes the performance of the function
vfio_pin_pages_remote(), while the remaining patches optimize the
performance of the function vfio_unpin_pages_remote().

The performance test results, based on v6.16, for completing the 16G
VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
modifications[4], are as follows.

Base(6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.049 s (328.5 GB/s)
VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.268 s (59.6 GB/s)
VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.051 s (310.9 GB/s)
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.025 s (633.1 GB/s)
VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.249 s (64.2 GB/s)
VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.030 s (533.2 GB/s)
VFIO UNMAP DMA in 0.044 s (361.3 GB/s)

For large folio, we achieve an over 40% performance improvement for VFIO
MAP DMA and an over 67% performance improvement for VFIO DMA UNMAP. For
small folios, the performance test results show a slight improvement with
the performance before optimization.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
[3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Li Zhe (5):
  mm: introduce num_pages_contiguous()
  vfio/type1: optimize vfio_pin_pages_remote()
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  vfio/type1: introduce a new member has_rsvd for struct vfio_dma
  vfio/type1: optimize vfio_unpin_pages_remote()

 drivers/vfio/vfio_iommu_type1.c | 112 ++++++++++++++++++++++++++------
 include/linux/mm.h              |   7 +-
 include/linux/mm_inline.h       |  35 ++++++++++
 3 files changed, 132 insertions(+), 22 deletions(-)

---
Changelogs:

v4->v5:
- Update the performance test results based on v6.16.
- Re-implement num_pages_contiguous() without relying on nth_page(),
  and relocate it into mm_inline.h.
- Merge the fixup patch into the original patch (patch #2).

v3->v4:
- Fix an indentation issue in patch #2.

v2->v3:
- Add a "Suggested-by" and a "Reviewed-by" tag.
- Address the compilation errors introduced by patch #1.
- Resolved several variable type issues.
- Add clarification for function num_pages_contiguous().

v1->v2:
- Update the performance test results.
- The function num_pages_contiguous() is extracted and placed in a
  separate commit.
- The phrase 'for large folio' has been removed from the patchset title.

v4: https://lore.kernel.org/all/20250710085355.54208-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20250707064950.72048-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20250704062602.33500-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250630072518.31846-1-lizhe.67@bytedance.com/
-- 
2.20.1


