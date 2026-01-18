Return-Path: <kvm+bounces-68443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCFCD394D9
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 13:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90BBC3053BF5
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 12:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4636132B994;
	Sun, 18 Jan 2026 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmFx0xYr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BE027FD75;
	Sun, 18 Jan 2026 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768738159; cv=none; b=DkYX3N7lVdxoYLakuHvNyK8nvxtisRiSwBEasQjOG+Xf/q3oYB6IC2qTnyJxl68rYnIvhbN51nP6PROWCCd/NFRcRltu5mVV3TbHWfZPQUplZ7Y3xMEsFwe3efTzf3q48gFLyIQ+ReAtGJpJ0rbANgTrvh3cqNF/Cy/NlzWObnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768738159; c=relaxed/simple;
	bh=zoYsMrm1rjNa0PY8BZkc8G3M4wgcf/AwcE0GTUAFzBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvcOngG4Mg3A0IdFjFekoR/mSIa8/9ak/68+oi0Ep035KnTmX4dw5yJUByiO5Z69Sl/ehEX22g2pZ+AjPF8QehdUijyz+i8BO/h0kYy1WGBHPU+u7ty/yys9nzJenkvO37PSjapD6rVxmTK/C7/qEQFOW15r8uBCB8xchkeawSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmFx0xYr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670ACC116D0;
	Sun, 18 Jan 2026 12:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768738153;
	bh=zoYsMrm1rjNa0PY8BZkc8G3M4wgcf/AwcE0GTUAFzBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmFx0xYrLhiCoTyr27YOjREc26M9s0f9UnpkBsDc5PYOT/t7lnouVm8sM8UhPobW3
	 GGspx43c9S9cMWUTDtYZaTGpzTIwOSQ6HFiloRqxoH1GyxbwrkLl8QY3fT0ANwBLnk
	 mnHPOB5ynxhv3SI9MbskUQ2uFktlq1ldP3K1hzBjsG/XAkFyfG7YvLvUF4J/PQmCcR
	 u0kEC4y8iQNC9pZRJuqAITvFazRttA5hZmm4quyQqXcFzT6VtfWlM9f1FKwTW64Wr/
	 5Ib8uJQhX+8/zM4l/M3BaKXf09VpjopHkwJdRyv6CSk3Lpen4DFAh+sZRhLlRUDOfz
	 duIHSuBnBQFCA==
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
Subject: [PATCH v2 4/4] vfio: Add pinned interface to perform revoke semantics
Date: Sun, 18 Jan 2026 14:08:48 +0200
Message-ID: <20260118-dmabuf-revoke-v2-4-a03bb27c0875@nvidia.com>
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

DMABUF ->pin() interface is called when the DMABUF importer perform
its DMA mapping, so let's use this opportunity to check if DMABUF
exporter revoked its buffer or not.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index d4d0f7d08c53..af9c315ddf71 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -20,6 +20,20 @@ struct vfio_pci_dma_buf {
 	u8 revoked : 1;
 };
 
+static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
+{
+	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
+
+	dma_resv_assert_held(priv->dmabuf->resv);
+
+	return dma_buf_attachment_is_revoke(attachment) ? 0 : -EOPNOTSUPP;
+}
+
+static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)
+{
+	/* Do nothing */
+}
+
 static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 				   struct dma_buf_attachment *attachment)
 {
@@ -76,6 +90,8 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 }
 
 static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
+	.pin = vfio_pci_dma_buf_pin,
+	.unpin = vfio_pci_dma_buf_unpin,
 	.attach = vfio_pci_dma_buf_attach,
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,

-- 
2.52.0


