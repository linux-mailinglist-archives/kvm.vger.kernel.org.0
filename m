Return-Path: <kvm+bounces-51544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F02AF87F6
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53F643ACF09
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F523248176;
	Fri,  4 Jul 2025 06:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="a3uHT91A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD345246BB4
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751610392; cv=none; b=c6SV8n1DXecIFGzLkIAPIrHL9Idh8BS++aUh/9fw7lvYzT6LIrbmoN82dTbOY4cz8B1tHu+MC1qULwL1jCnXj0aHjTqpjFUnC46+7fe04oUYgZ5+fnhokUuMfVq+d5i2V8hp/S09PyWaAX3j7ZfQyQX7pjn4RMJ9Ui/UoSWrwiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751610392; c=relaxed/simple;
	bh=TqO39hOdZuFrt3Vk4NPBD+GxpccbOwHCd5B4qz3NG2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ck2eibSFG4+ZUaLAk9e4u6OTGzcpLZXaeDsc+z2PDHSo9509dgs/dY/6sE18XWpH1YE98satOCoJubxpIkUI4HpYO8S96oB2OQS/XYK84R/Js/NjK/KrBSAOzg2GXyIMRUKAvF1l4qHpBEjR1UdiRfTvExtUxcZuSvdiZBbyPyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=a3uHT91A; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7481600130eso970278b3a.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751610390; x=1752215190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vtAMrec9bYb31s5/Huy8ScC44Y0MeGNii8Ny4beAYaA=;
        b=a3uHT91ASzcIngTp4XE7hZOzPz5w7PXJb57+8D9Nc6pPCp85N4OGLdUYCIlJtlcCGI
         /h+/NmHlFlvhQvX/ekcs2zQ0/BYcVblssHKfWEpZCmGdbranK6nxQtxEGi3e7dn1rqYR
         c9IdEYeKnDIc95d9Oo+stAoCIMAye/jWGzO/oDSsjVEQAmKt5liIuMOIAFVqPQkQX4jN
         tAsn79LzPxEUNFolYK6FoyAqvV9t/7tE7Jm66538pCX0eb65j/P7NINgBaPjBjgdRym2
         TBu6p3cosUOJeL3X5LyAYhEVTDfIuXJp9YJLMAz4mZC76n2O786vzEAYPkiCThSUvi4Y
         5eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751610390; x=1752215190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vtAMrec9bYb31s5/Huy8ScC44Y0MeGNii8Ny4beAYaA=;
        b=XzljFS6FNawMahd+iLIBY+iDJqQDFrNNUhjEJWu9FD+9ZDG6S8a4WlrL2KmQWSIThP
         p4WttGoyLd4iPvYQGfeVS/7uqzxsD3ZUT7q2jPeFvZmV4IzTHQ0XFA9L4sxz4m/Ll6J4
         G6KCgNCL7waWY7WkJTt6hgUweV8mrpACaYja/py93rL430DXpdVvnx2NHKfoc3R3ALim
         ZwcUqe03SfyzorNw/5Whx4G3kOLh/wul5jBPcOb6MOdNFqiX1aun994/H2PL6JR8Qkq9
         MXtR5yoBM+4ly5Re8l3hMCLhoquTlJ6LDZxt8fS8MnIvdaXNC94I/5sLdcbuFr+xtVdn
         j8MQ==
X-Gm-Message-State: AOJu0YzGZZpKzjkEqPKpzng1poJoCUkJJSfPsQk/1dOZv5Ux9Lx/MIqn
	hrFP+GR8U1V0R5rcw84/eW69wsDs753mezd7UzIy6mmaxNCpyvM+bQBHWdZl4SnX7Rw=
X-Gm-Gg: ASbGncvyU4wvkYSMvqUNWkmHHmZLx0vVJd3satvZMRVa9iMepRmXz4nIpreRI42XhPf
	2tBeLBe/5HnJWSAOXLSNiGutAl0rZnqf7eLq93Tklz3ZLBwGs2ARbxl8IuxR00JJFZ2RoHvx8DA
	zWY7zFfByL+wcKpZ4Z1PQynAOT8GNGBpUwmzhcIzl9lbT4VyGjeWz3j1QjAMiPFXm+NNlOiF2gK
	UAfvdGyofnZIoiscDQ5Uku3vVxTVEkem2XDiQqeNgpwacFZqUSlsSSNz/7n2UojoA+cvdBkRVcB
	E1MwuI/UdJxRqbwEhLJoKnqGqXFI9rLUjuY9LcxQl2DqsCaQQOFFZq4kRGn2+7dOt6a4l539+K+
	vMKa+y3cmw6o3
X-Google-Smtp-Source: AGHT+IFTOzGu3zFWSHTrf4KF59AoRGl/bkuEswL36beEW28ePztb4UqI8rnrlZ/0ccy+thk4y06H6Q==
X-Received: by 2002:a05:6a21:694:b0:201:b65:81ab with SMTP id adf61e73a8af0-225b9f64162mr2679259637.23.1751610389786;
        Thu, 03 Jul 2025 23:26:29 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee5f643dsm1183240a12.37.2025.07.03.23.26.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 23:26:29 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com,
	jgg@ziepe.ca
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v2 0/5] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()
Date: Fri,  4 Jul 2025 14:25:57 +0800
Message-ID: <20250704062602.33500-1-lizhe.67@bytedance.com>
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

The performance test results, based on v6.16-rc4, for completing the 16G
VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
modifications[4], are as follows.

Base(6.16-rc4):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (340.2 GB/s)
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (310.5 GB/s)
VFIO UNMAP DMA in 0.136 s (117.3 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (600.7 GB/s)
VFIO UNMAP DMA in 0.045 s (357.0 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.261 s (61.4 GB/s)
VFIO UNMAP DMA in 0.288 s (55.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.031 s (516.4 GB/s)
VFIO UNMAP DMA in 0.045 s (353.9 GB/s)

For large folio, we achieve an over 40% performance improvement for VFIO
MAP DMA and an over 66% performance improvement for VFIO DMA UNMAP. For
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

 drivers/vfio/vfio_iommu_type1.c | 111 ++++++++++++++++++++++++++------
 include/linux/mm.h              |  20 ++++++
 2 files changed, 110 insertions(+), 21 deletions(-)

---
Changelogs:

v1->v2:
- Update the performance test results.
- The function num_pages_contiguous() is extracted and placed in a
  separate commit.
- The phrase 'for large folio' has been removed from the patchset title.

v1: https://lore.kernel.org/all/20250630072518.31846-1-lizhe.67@bytedance.com/

-- 
2.20.1


