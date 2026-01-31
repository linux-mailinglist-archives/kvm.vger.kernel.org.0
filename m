Return-Path: <kvm+bounces-69771-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMWVAyqVfWnQSgIAu9opvQ
	(envelope-from <kvm+bounces-69771-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 06:37:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 878D8C0DCF
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 06:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 09BFA3060F8A
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 05:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31F134A76B;
	Sat, 31 Jan 2026 05:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fU6vI045"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409133C53A;
	Sat, 31 Jan 2026 05:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769837698; cv=none; b=JDB3ER5pg+pTHbSEsNBhkn8RLaoz4KsFbdd7S7k/ukYziPkJimYLJ9qhMBGmxWWgJi+g34qvIsvhFnPefeSw4XpOZ8dH6IC0KhCL1+798v8OImFKGkqEHy660+MZ4qe7/6XFPSyC46r/zOqtUXdPrFtgxsHq3NY/AvasFg1D2H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769837698; c=relaxed/simple;
	bh=jrUktIM7vM/80ddCZ+2MusPve+WTOO+VsuJlV1nB6jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs5BV1wTUvrYBsJMhvUYoa0F5kIoyqR77L5QSAO8lYzMZwfbqhYdjrtOi4p9R+P6yxDdFB1eZ9Qk3Hz9J5bHaTUEdDCxqTPygMPCpGvJXbPA1vETRqG2aIV45wSCIoNIX20WgwB+E4BlrWqFIEAse5/XEJORIIHzTQeVPE+6TpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fU6vI045; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25E8C4CEF1;
	Sat, 31 Jan 2026 05:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769837698;
	bh=jrUktIM7vM/80ddCZ+2MusPve+WTOO+VsuJlV1nB6jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fU6vI045uUAC9mnBucCBemgKFiD+NnxDp0cJOxdGHD32TmyIZ5kB+9rI5bYv4/rFf
	 cCjfGqvinFYG/xriaSo/bGdBXjqV9W4V6Im4z1CGqov5oSaIIoxrHZTobNLI3bE2BY
	 AfJLPF7d7DcKY1sFSgyIGqp+5mddo1xGKodqkSghslJKg0xtGa5W+vGfvbn2xY08f3
	 mVwuo7HrEQYSeHuA6SaCki2JSRq+yzkWnbMNpITme7G2OYpad2zHnBOrA7ZE5ZLs8+
	 KAhc7dFTKFnYMAybg/kx6+tgPLkCbmtat9erFzc508XBT6wr5M+VTZCkK+OxDqy9xj
	 K+78VoGo1urcg==
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
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
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
Subject: [PATCH v7 5/8] dma-buf: Make .invalidate_mapping() truly optional
Date: Sat, 31 Jan 2026 07:34:15 +0200
Message-ID: <20260131-dmabuf-revoke-v7-5-463d956bd527@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69771-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email]
X-Rspamd-Queue-Id: 878D8C0DCF
X-Rspamd-Action: no action

From: Leon Romanovsky <leonro@nvidia.com>

The .invalidate_mapping() callback is documented as optional, yet it
effectively became mandatory whenever importer_ops were provided. This
led to cases where RDMA non-ODP code had to supply an empty stub.

Relax the checks in the dma-buf core so the callback can be omitted,
allowing RDMA code to drop the unnecessary function.

Removing the stub allows the next patch to tell that RDMA does not support
.invalidate_mapping() by checking for a NULL op.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c             |  6 ++----
 drivers/infiniband/core/umem_dmabuf.c | 13 -------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index cd68c1c0bfd7..1629312d364a 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -947,9 +947,6 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	if (WARN_ON(!dmabuf || !dev))
 		return ERR_PTR(-EINVAL);
 
-	if (WARN_ON(importer_ops && !importer_ops->invalidate_mappings))
-		return ERR_PTR(-EINVAL);
-
 	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
@@ -1260,7 +1257,8 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 	dma_resv_assert_held(dmabuf->resv);
 
 	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (attach->importer_ops)
+		if (attach->importer_ops &&
+		    attach->importer_ops->invalidate_mappings)
 			attach->importer_ops->invalidate_mappings(attach);
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index d77a739cfe7a..256e34c15e6b 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -129,9 +129,6 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 	if (check_add_overflow(offset, (unsigned long)size, &end))
 		return ret;
 
-	if (unlikely(!ops || !ops->invalidate_mappings))
-		return ret;
-
 	dmabuf = dma_buf_get(fd);
 	if (IS_ERR(dmabuf))
 		return ERR_CAST(dmabuf);
@@ -184,18 +181,8 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_get);
 
-static void
-ib_umem_dmabuf_unsupported_move_notify(struct dma_buf_attachment *attach)
-{
-	struct ib_umem_dmabuf *umem_dmabuf = attach->importer_priv;
-
-	ibdev_warn_ratelimited(umem_dmabuf->umem.ibdev,
-			       "Invalidate callback should not be called when memory is pinned\n");
-}
-
 static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_ops = {
 	.allow_peer2peer = true,
-	.invalidate_mappings = ib_umem_dmabuf_unsupported_move_notify,
 };
 
 struct ib_umem_dmabuf *

-- 
2.52.0


