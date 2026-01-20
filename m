Return-Path: <kvm+bounces-68620-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJeVIuqjb2n0DgAAu9opvQ
	(envelope-from <kvm+bounces-68620-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:48:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB5446B32
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B842E6A7484
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DB9449ECC;
	Tue, 20 Jan 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYUeMXTY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640E043C048;
	Tue, 20 Jan 2026 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918054; cv=none; b=NjabP5z57UjaH+qJOdCAEqbT8drQyObFC7LOuxbdJFWptdnokye/d673d/ojRO1N4t3Nb3j+P9zSe5npmyFEK+GPQlcZBsgwZJMucthTO73Quhh9ID+IPXXwjXaztA0FixyUA9R26OWKUZ1zKFkFpOIYljPUECwD2mX7NoqEIcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918054; c=relaxed/simple;
	bh=OGYKw47EaUqM/lWyK5JqNggda0T3gP3mV7IvIl6ZhwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXza6PNpp5DCs9uFPS4rgnFc1wB5tpOZZ+EWseihp0SqiQTSaUk0Irprw55BYWdVgfYVsKNDcoijodWZoM6ZLsBQDfarnxEEPHkrDW6mA99wwOfN3sJ/29NyJCVVs4pWNIq8BfHWWPpRmxk8Z7gdxjj4dB4FcpsUCHRxfOYs3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYUeMXTY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561F9C16AAE;
	Tue, 20 Jan 2026 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918053;
	bh=OGYKw47EaUqM/lWyK5JqNggda0T3gP3mV7IvIl6ZhwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYUeMXTYft4GtVy4nltWw2eo7loX0iq5KSPd4tbFPKJ8TCxoPRxPdvjpoGw2OoDBY
	 SWmASS2V8hQJkkbZHFlSFISOLy9ok6Xm46EcCeCy9RAP8sIacs0r4rD9gaJNpKW2Cn
	 4o3Vm6BGbT7uiGIMPCGWwMYgI9paEvtL32cMHECFVIEKa6/5rmUS6mbliAmbH6h7QR
	 PW8K6Amsao0YSlCtgN5zAh3iEfY7GNmDuydcJQ2HQJz0oP8X1heqiOImOpxlky44zB
	 FpZmoS4zOv69VH85sSs2CUSjJoHA/PYmXIcIiLOyOFlEQ69qa32KUfkeBMKgZfGy7j
	 HszFLQEQAwjqg==
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
Subject: [PATCH v3 1/7] dma-buf: Rename .move_notify() callback to a clearer identifier
Date: Tue, 20 Jan 2026 16:07:01 +0200
Message-ID: <20260120-dmabuf-revoke-v3-1-b7e0b07b8214@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
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
	TAGGED_FROM(0.00)[bounces-68620-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 5BB5446B32
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

Rename the .move_notify() callback to .invalidate_mappings() to make its
purpose explicit and highlight that it is responsible for invalidating
existing mappings.

Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c                   | 6 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 4 ++--
 drivers/gpu/drm/virtio/virtgpu_prime.c      | 2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       | 6 +++---
 drivers/gpu/drm/xe/xe_dma_buf.c             | 2 +-
 drivers/infiniband/core/umem_dmabuf.c       | 4 ++--
 drivers/infiniband/hw/mlx5/mr.c             | 2 +-
 drivers/iommu/iommufd/pages.c               | 2 +-
 include/linux/dma-buf.h                     | 6 +++---
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index edaa9e4ee4ae..59cc647bf40e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -948,7 +948,7 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	if (WARN_ON(!dmabuf || !dev))
 		return ERR_PTR(-EINVAL);
 
-	if (WARN_ON(importer_ops && !importer_ops->move_notify))
+	if (WARN_ON(importer_ops && !importer_ops->invalidate_mappings))
 		return ERR_PTR(-EINVAL);
 
 	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
@@ -1055,7 +1055,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_pin, "DMA_BUF");
  *
  * This unpins a buffer pinned by dma_buf_pin() and allows the exporter to move
  * any mapping of @attach again and inform the importer through
- * &dma_buf_attach_ops.move_notify.
+ * &dma_buf_attach_ops.invalidate_mappings.
  */
 void dma_buf_unpin(struct dma_buf_attachment *attach)
 {
@@ -1262,7 +1262,7 @@ void dma_buf_move_notify(struct dma_buf *dmabuf)
 
 	list_for_each_entry(attach, &dmabuf->attachments, node)
 		if (attach->importer_ops)
-			attach->importer_ops->move_notify(attach);
+			attach->importer_ops->invalidate_mappings(attach);
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_move_notify, "DMA_BUF");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index e22cfa7c6d32..863454148b28 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -450,7 +450,7 @@ amdgpu_dma_buf_create_obj(struct drm_device *dev, struct dma_buf *dma_buf)
 }
 
 /**
- * amdgpu_dma_buf_move_notify - &attach.move_notify implementation
+ * amdgpu_dma_buf_move_notify - &attach.invalidate_mappings implementation
  *
  * @attach: the DMA-buf attachment
  *
@@ -521,7 +521,7 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 
 static const struct dma_buf_attach_ops amdgpu_dma_buf_attach_ops = {
 	.allow_peer2peer = true,
-	.move_notify = amdgpu_dma_buf_move_notify
+	.invalidate_mappings = amdgpu_dma_buf_move_notify
 };
 
 /**
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index ce49282198cb..19c78dd2ca77 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -288,7 +288,7 @@ static void virtgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 
 static const struct dma_buf_attach_ops virtgpu_dma_buf_attach_ops = {
 	.allow_peer2peer = true,
-	.move_notify = virtgpu_dma_buf_move_notify
+	.invalidate_mappings = virtgpu_dma_buf_move_notify
 };
 
 struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
diff --git a/drivers/gpu/drm/xe/tests/xe_dma_buf.c b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
index 5df98de5ba3c..1f2cca5c2f81 100644
--- a/drivers/gpu/drm/xe/tests/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
@@ -23,7 +23,7 @@ static bool p2p_enabled(struct dma_buf_test_params *params)
 static bool is_dynamic(struct dma_buf_test_params *params)
 {
 	return IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY) && params->attach_ops &&
-		params->attach_ops->move_notify;
+		params->attach_ops->invalidate_mappings;
 }
 
 static void check_residency(struct kunit *test, struct xe_bo *exported,
@@ -60,7 +60,7 @@ static void check_residency(struct kunit *test, struct xe_bo *exported,
 
 	/*
 	 * Evict exporter. Evicting the exported bo will
-	 * evict also the imported bo through the move_notify() functionality if
+	 * evict also the imported bo through the invalidate_mappings() functionality if
 	 * importer is on a different device. If they're on the same device,
 	 * the exporter and the importer should be the same bo.
 	 */
@@ -198,7 +198,7 @@ static void xe_test_dmabuf_import_same_driver(struct xe_device *xe)
 
 static const struct dma_buf_attach_ops nop2p_attach_ops = {
 	.allow_peer2peer = false,
-	.move_notify = xe_dma_buf_move_notify
+	.invalidate_mappings = xe_dma_buf_move_notify
 };
 
 /*
diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 7c74a31d4486..1b9cd043e517 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -287,7 +287,7 @@ static void xe_dma_buf_move_notify(struct dma_buf_attachment *attach)
 
 static const struct dma_buf_attach_ops xe_dma_buf_attach_ops = {
 	.allow_peer2peer = true,
-	.move_notify = xe_dma_buf_move_notify
+	.invalidate_mappings = xe_dma_buf_move_notify
 };
 
 #if IS_ENABLED(CONFIG_DRM_XE_KUNIT_TEST)
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 0ec2e4120cc9..d77a739cfe7a 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -129,7 +129,7 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 	if (check_add_overflow(offset, (unsigned long)size, &end))
 		return ret;
 
-	if (unlikely(!ops || !ops->move_notify))
+	if (unlikely(!ops || !ops->invalidate_mappings))
 		return ret;
 
 	dmabuf = dma_buf_get(fd);
@@ -195,7 +195,7 @@ ib_umem_dmabuf_unsupported_move_notify(struct dma_buf_attachment *attach)
 
 static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_ops = {
 	.allow_peer2peer = true,
-	.move_notify = ib_umem_dmabuf_unsupported_move_notify,
+	.invalidate_mappings = ib_umem_dmabuf_unsupported_move_notify,
 };
 
 struct ib_umem_dmabuf *
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 325fa04cbe8a..97099d3b1688 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1620,7 +1620,7 @@ static void mlx5_ib_dmabuf_invalidate_cb(struct dma_buf_attachment *attach)
 
 static struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
 	.allow_peer2peer = 1,
-	.move_notify = mlx5_ib_dmabuf_invalidate_cb,
+	.invalidate_mappings = mlx5_ib_dmabuf_invalidate_cb,
 };
 
 static struct ib_mr *
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index dbe51ecb9a20..76f900fa1687 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1451,7 +1451,7 @@ static void iopt_revoke_notify(struct dma_buf_attachment *attach)
 
 static struct dma_buf_attach_ops iopt_dmabuf_attach_revoke_ops = {
 	.allow_peer2peer = true,
-	.move_notify = iopt_revoke_notify,
+	.invalidate_mappings = iopt_revoke_notify,
 };
 
 /*
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 0bc492090237..1b397635c793 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -407,7 +407,7 @@ struct dma_buf {
 	 *   through the device.
 	 *
 	 * - Dynamic importers should set fences for any access that they can't
-	 *   disable immediately from their &dma_buf_attach_ops.move_notify
+	 *   disable immediately from their &dma_buf_attach_ops.invalidate_mappings
 	 *   callback.
 	 *
 	 * IMPORTANT:
@@ -458,7 +458,7 @@ struct dma_buf_attach_ops {
 	bool allow_peer2peer;
 
 	/**
-	 * @move_notify: [optional] notification that the DMA-buf is moving
+	 * @invalidate_mappings: [optional] notification that the DMA-buf is moving
 	 *
 	 * If this callback is provided the framework can avoid pinning the
 	 * backing store while mappings exists.
@@ -475,7 +475,7 @@ struct dma_buf_attach_ops {
 	 * New mappings can be created after this callback returns, and will
 	 * point to the new location of the DMA-buf.
 	 */
-	void (*move_notify)(struct dma_buf_attachment *attach);
+	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
 };
 
 /**

-- 
2.52.0


