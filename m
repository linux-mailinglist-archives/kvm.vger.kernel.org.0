Return-Path: <kvm+bounces-49579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74269ADA9E5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D34B7A912D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 07:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB1720C48C;
	Mon, 16 Jun 2025 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OtqKMLOl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B926F1DB34B
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750060388; cv=none; b=uzmeMz3ci5QcwA3yFRF1uRBSLN+bn6003gQW/BEqPnlTh/SQYB7ppO/pZButdWZjdVt3IYgC6C2zfcE6/CsBzIw5vTn5GfW8NUmRrO3goZBme+QskqfkUwUESr3ovm34tFbwW0m3zQaDziKi5uvxy8daqKJvWWYiwHqkcww7Q0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750060388; c=relaxed/simple;
	bh=nU3MVzPAz2W/MmUBLQRYb+KaRA8m268+ptAzhabPrCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P+dak7Vxc448x/legAiUsll0qEhpLTNn6V6MEi425GTzEgkY+mLPBzNHHbF/+4e8JZrCxjm3Ol5eM4tEPHhgYKM/WF8l9R4o6VWTrbJKIRZ4tSybrXfLgroeRkf7QAI1lVIZkjjZt7I6mMvKweJvav6lva3pWquGz9/C5c2YmeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OtqKMLOl; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-31332cff2d5so3542417a91.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 00:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750060386; x=1750665186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BBQ+2bMvAOaABHXtNuxuVBu+Oc5HFaxNYNRCaBfbVBo=;
        b=OtqKMLOlxP9ehGokSF/Q+AKz/N6L09aPqvowzph98QqYPSlDsjHODnG7cVUAVqlF4S
         QeTmZoGu6qGg1Xlzf5BdFrMvIZxr5xO6sytiVuv16LMdWdaP+nkuxw8haVWHoveeByoU
         sCPl7LGwqiAkyTkQmTT/WJjBDSI/dA6neN64K0mwtp/7q+uX1jkUC3sNWofk7Mg9b1wa
         RqiccA3vaZHfhChG6mxYF3A439YYNwYhNhOAgL+zb0WqUCbwriXZ7kQuTxfxGsg/HIBX
         B/QfqavD04L/nNZ8TUkLp8OF+xhSJvy5sJE1AYz78ZlqV71KlRo4pndymqlnR2Dj0JmK
         wxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750060386; x=1750665186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBQ+2bMvAOaABHXtNuxuVBu+Oc5HFaxNYNRCaBfbVBo=;
        b=M4jGiHhbDqzBCZIJgMO8gW9xgc4nBW8bsbSw/m8TD9YmQgF0Qmrclo9iufm7R0Z23H
         Lv79Vd05An/0VMKy3pdtspLxMwKYfGcqXNrqPai9UAy4y5iGWbI+rP6FgCU1r6JKI4w9
         fPq07Ko5Puf+AcbgVJcZ2Z2LHvVtEBShcboxl3ZYETXB5euUmtcvsZi36c5yv1SOTiDH
         DIE9wU5/4+mprBbXuaS7zcNMwK8ehELKmYXeKtD4HYs/ra0Nblad+vKFc/6c0mXh0KtN
         CmvChpk+V+nJ6RPaKLAaRJroi9ptOVv8pU1Yfx6NHrTch39NVaV9BLIoEhVztIFmsDog
         Kk7Q==
X-Gm-Message-State: AOJu0Ywdj3TD8bVLAZg+NVwD79a+5STF5fA93VQUVpR7ncyLjXQdcXgB
	gxRS1giLg5ovBsBex5qtV/gitqnDxBaBkovOUzvsjJpFQf6ZIs2EwLEmUC+QkP154Io=
X-Gm-Gg: ASbGnctminFKS+6XohfvfzGX01otE6MQgrnQXN+x/7nh9G6aJv6dw3Betm7DExfxT/N
	hqEjd7IqnGV5NdP3vc0K6ioT0bSFUfKH/eodjKXvBoRJpdBNU/RtVbzjtZ+XUJc1awPwyl1dnsJ
	0WZjFgj4W9PqML+WuWTZYYbina3BuQIkwfWSSunURrwKKGbCj6gvY8i7mAIOsXsYPjhh6Im8wf8
	kyMBLpyOFsitPeoT96Fi9dU1t6ybxrT/rJI8zg/lg5L2yVvImJC9rpfjHETNyJwGRqBw+ZxJaHx
	KbzeKXybFbUHIlB2VcBbxwQeRMNz0YxM80JPbGv+kX16E5LujHhk9YINYvoQYny2ZRu3To+DdNY
	Izlf5oVUn90a6qA==
X-Google-Smtp-Source: AGHT+IE2b2wVBEzCLW4p0LTN9AxQbWpaHf9MTFJ34uDqSAIumyaW8XvtdoyxYcfKP/ch+23nwmdzgA==
X-Received: by 2002:a17:90b:1dc4:b0:311:fde5:e225 with SMTP id 98e67ed59e1d1-313f1c01641mr15461579a91.14.1750060385867;
        Mon, 16 Jun 2025 00:53:05 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88be76sm55179045ad.32.2025.06.16.00.53.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 00:53:05 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david@redhat.com,
	peterx@redhat.com,
	lizhe.67@bytedance.com
Subject: [PATCH v3 0/2] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Mon, 16 Jun 2025 15:52:49 +0800
Message-ID: <20250616075251.89067-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is based on patch 'vfio/type1: optimize
vfio_pin_pages_remote() for large folios'[1].

When vfio_unpin_pages_remote() is called with a range of addresses
that includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of
pages. We can optimize this process by batching the put_pfn()
operations.

The first patch batches the vfio_find_vpfn() calls in function
vfio_unpin_pages_remote(). However, performance testing indicates that
this patch does not seem to have a significant impact. The primary
reason is that the vpfn rb tree is generally empty. Nevertheless, we
believe it can still offer performance benefits in certain scenarios
and also lays the groundwork for the second patch. The second patch,
using the method described earlier, optimizes the performance of
vfio_unpin_pages_remote() for large folio scenarios.

The performance test results, based on v6.15, for completing the 16G VFIO
IOMMU DMA unmapping, obtained through unit test[2] with slight
modifications[3], are as follows.

Base(v6.15):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (338.6 GB/s)
VFIO UNMAP DMA in 0.138 s (116.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (308.3 GB/s)
VFIO UNMAP DMA in 0.139 s (115.1 GB/s)

Map[1] + first patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (596.1 GB/s)
VFIO UNMAP DMA in 0.138 s (115.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.292 s (54.8 GB/s)
VFIO UNMAP DMA in 0.310 s (51.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (506.5 GB/s)
VFIO UNMAP DMA in 0.140 s (114.1 GB/s)

Map[1] + first + sencond patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (598.2 GB/s)
VFIO UNMAP DMA in 0.049 s (328.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.289 s (55.3 GB/s)
VFIO UNMAP DMA in 0.303 s (52.9 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (506.8 GB/s)
VFIO UNMAP DMA in 0.049 s (326.7 GB/s)

The first patch appears to have negligible impact on the performance
of VFIO UNMAP DMA.

With the second patch, we achieve an approximate 64% performance
improvement in the VFIO UNMAP DMA item for large folios. For small
folios, the performance test results appear to show no significant
changes.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[3]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Changelogs:

v2->v3:
- Split the original patch into two separate patches.
- Add several comments specific to large folio scenarios.
- Rename two variables.
- The update to iova has been removed within the loop in
  vfio_unpin_pages_remote().
- Update the performance test results.

v1->v2:
- Refactor the implementation of the optimized code

v2: https://lore.kernel.org/all/20250610045753.6405-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250605124923.21896-1-lizhe.67@bytedance.com/

Li Zhe (2):
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  vfio/type1: optimize vfio_unpin_pages_remote() for large folio

 drivers/vfio/vfio_iommu_type1.c | 57 ++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 12 deletions(-)

-- 
2.20.1


