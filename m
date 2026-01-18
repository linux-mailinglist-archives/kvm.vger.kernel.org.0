Return-Path: <kvm+bounces-68442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5356AD394D3
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 13:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65ACD3047182
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 12:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0824A32B98E;
	Sun, 18 Jan 2026 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b57lGzkE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F218932B998;
	Sun, 18 Jan 2026 12:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768738152; cv=none; b=UpkyiStMW8F/erjjT6wMQtzdZvcN4L91C61O6Mr64GmFDKlaqeIzH2WMzMLRjAAXV7dCZhvZfZfGP1uFN5EeSw6YRpRAMlhxsqvqGsLbmqzeNiu0vX4qOUU8fSSWXHnPfnwjDUIJZ+3bRco07qjHcLAbivVg6GsUvt+WXs2hVvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768738152; c=relaxed/simple;
	bh=lFp92L2u8Fi3C1r4wz7ICZZY29W6l9NNfEn6EJZj7GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkXRufJdRAfpwhWdIU9mcYyECjkozBEQILm/GKFdHKHt7RmVdlax3yT7d062aBfsCfZZQIf10g2BleIXot+Cilg8N5e6q+jKf1O2+CRHx/J+OWNKG6UYwCTBN+B7/gT/+GkZC3nxyvcgIKcWKRqfpm4AZt/GEjQeNeVDuRGG/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b57lGzkE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27A2C2BC86;
	Sun, 18 Jan 2026 12:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768738149;
	bh=lFp92L2u8Fi3C1r4wz7ICZZY29W6l9NNfEn6EJZj7GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b57lGzkEObf4t2IQTf/DJYle2Vi+wmkenWL8JiZcUXMFG32RI5QLPPJvEQbZNmUVu
	 tVm9SQkuRLXsV+VARTyTJ0ctKEAh36t9OF36xOHzMKHdzrqQIUN+wCKowPjw2OfZCq
	 uTMmw9GjLJOlRA/x9vlNTo9600EoOlZ5fJuR5yabUCBsAqvyrwoWDAdpO0SdPcxQzn
	 fmRvtiPmspxW0vLun5hT89R8Sl29pf9lU45i5p0t62erSJena939KfeGaNSbhd6Kjo
	 PB+o9YyRlIiDI8/OKCEyXgL3nGXjyaFi1GkzNHDkMORYewY4EEZiBeSpWeQYfoARox
	 VmHDCcvdgPMdg==
From: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 2/4] dma-buf: Document revoke semantics
Date: Sun, 18 Jan 2026 14:08:46 +0200
Message-ID: <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Document a DMA-buf revoke mechanism that allows an exporter to explicitly
invalidate ("kill") a shared buffer after it has been handed out to
importers. Once revoked, all further CPU and device access is blocked, and
importers consistently observe failure.

This requires both importers and exporters to honor the revoke contract.

For importers, this means implementing .invalidate_mappings() and calling
dma_buf_pin() after the DMA‑buf is attached to verify the exporter’s support
for revocation.

For exporters, this means implementing the .pin() callback, which checks
the DMA‑buf attachment for a valid revoke implementation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-buf.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 1b397635c793..e0bc0b7119f5 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -579,6 +579,25 @@ static inline bool dma_buf_is_dynamic(struct dma_buf *dmabuf)
 	return !!dmabuf->ops->pin;
 }
 
+/**
+ * dma_buf_attachment_is_revoke - check if a DMA-buf importer implements
+ * revoke semantics.
+ * @attach: the DMA-buf attachment to check
+ *
+ * Returns true if DMA-buf importer honors revoke semantics, which is
+ * negotiated with the exporter, by making sure that importer implements
+ * .invalidate_mappings() callback and calls to dma_buf_pin() after
+ * DMA-buf attach.
+ */
+static inline bool
+dma_buf_attachment_is_revoke(struct dma_buf_attachment *attach)
+{
+	return IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY) &&
+	       dma_buf_is_dynamic(attach->dmabuf) &&
+	       (attach->importer_ops &&
+		attach->importer_ops->invalidate_mappings);
+}
+
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 					  struct device *dev);
 struct dma_buf_attachment *

-- 
2.52.0


