Return-Path: <kvm+bounces-68716-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mB4iCSDQcGkOaAAAu9opvQ
	(envelope-from <kvm+bounces-68716-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:09:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 10784575A5
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A11224A9E94
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD2B48BD2B;
	Wed, 21 Jan 2026 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HM6a6IQ+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C32C48B381;
	Wed, 21 Jan 2026 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000383; cv=none; b=G1aTBZ0WDX0XaOkYuQo8qGWRk6ztyV8mBx0kv2V1Cpxi6Q69SPT6M5qlM/TPWWRYc7zj/k6Lg5y5MmdhMpZ0RE3lPPkcorWAVR3gBg5oBqkmCCMI6PnOB/TMlUSm4/05CQPfpNhYisxwKuMk9luqNhKR/qZNMD9l3D5kk2As8eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000383; c=relaxed/simple;
	bh=Hg+PCl94D7mEbx1+9P2eXzfMtxX5wkTvpHZQYOw5sNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/GtrA3Q+trC9hZ+O0sSksOG+ucyKTF2GP9hxLksmdeeX6ooDqAv4AqCwtRSbLI5T+9b4yREsb7UiGlbz+kZDVXUk+dU5a4exQ2FrQfOCycVoNvmhS3Yk5iI765lgPJpCWp0Vg2gYMt0yADHkc3GXxlgDV3LAjpRW7KRMH09v64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HM6a6IQ+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82582C19421;
	Wed, 21 Jan 2026 12:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769000383;
	bh=Hg+PCl94D7mEbx1+9P2eXzfMtxX5wkTvpHZQYOw5sNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HM6a6IQ+AhLBuJDmA/lFkqxyAunt3g5aK7v9YdUfBqREs640dtG6nrOD1zNjqm8Gp
	 vEP1J2Fi+gqQ3tLIzy0Xn03t+xBB/8GnbD+UuXicPNLk6gkBROjWBSbX0dEJ7kYHTZ
	 K/nl+CneSxYhZc9dRZktkvw8RAUzHTlspeexxTjQjCdPY8xZSOJ3P9rTA0KCqYdE9c
	 bGdNOtzPaUem3EI7LKuYIACEjclww7RCIsCsjGOqDW8ZxYnK29Z9KG9crosYCasEiy
	 N1Qs/f4kyV6L1B23j78StagSE4L/vhsu5QyFHZt+elx1ophwOBhCMP5mYGD6y46kM2
	 ga94NGtgcGMcA==
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
Subject: [PATCH v4 4/8] dma-buf: Make .invalidate_mapping() truly optional
Date: Wed, 21 Jan 2026 14:59:12 +0200
Message-ID: <20260121-dmabuf-revoke-v4-4-d311cbc8633d@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
References: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68716-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 10784575A5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

The .invalidate_mapping() callback is documented as optional, yet it
effectively became mandatory whenever importer_ops were provided. This
led to cases where RDMA non-ODP code had to supply an empty stub.

Relax the checks in the dma-buf core so the callback can be omitted,
allowing RDMA code to drop the unnecessary function.

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


