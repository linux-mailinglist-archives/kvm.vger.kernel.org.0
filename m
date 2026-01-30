Return-Path: <kvm+bounces-69714-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLfzN1a0fGnSOQIAu9opvQ
	(envelope-from <kvm+bounces-69714-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:38:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D19BB30D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DB41D300FFBB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B13319851;
	Fri, 30 Jan 2026 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lakFUAKF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF68E30F808;
	Fri, 30 Jan 2026 13:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780269; cv=none; b=JE+sJ2UHp7gcHVMbaZJja6mNQM3mJD1k2JO3EBFgy+nHSkgBFk1jJZyn4JeWM8plGl/44ZZ01fAce3WiYxvTAGQ93AjmEM7/B5QQFiJ5CCtl0td7COzyLKGuyEKLd9IUC9dwc5HPRFuNJGeDxwCv0kzUoppF9Htb2TzwQVS0kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780269; c=relaxed/simple;
	bh=dRmSLq4/FywGyZeI8PIr9pH6bt5knP9pTzL9IXuhxBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnkhhNBKLfE21A1N5+L2FIyIjSbqnrYxbkRDHWjgtZ0ZghDDCpyADHKNUhsFrGiFsV5VES0150IRVOwu4/iL+KowJgWbaUSyJn6kUY/vnZbsTOS6kduCc1MBWjV3ZKxXxfneqb4VU40waUccTqLJWU+cBrHzEZTHY1pnrzo+twk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lakFUAKF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B241EC4CEF7;
	Fri, 30 Jan 2026 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769780269;
	bh=dRmSLq4/FywGyZeI8PIr9pH6bt5knP9pTzL9IXuhxBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lakFUAKF4Ss3kC0pvhclfwWB7Yir8BfQ7atyyaPkRgz6QaQMAZw1g1+NVleqnpQ5J
	 IWJ87o1eDJjaX9ctxF1WzF94trV2LLbRZwjGTKTSpO9FpkkUL9d5Vz+U5sz3+V+13u
	 NhbyNOFLr/5bBVz4km+rjlFg/YE/xRuE1WLoYQpTodm4u7VDwkcsY8uE+SXLSX5Uio
	 DDqw80kJ0o5R4yuAGx1G47annshAHLxKxjF5ihIlhfVk+rfStsJS9nqUnraGMshxxR
	 k23oIdeQzHOgbb5jOUOpMJekX1rj+/K/AyThALPPsSugaUFzdK32PsM2OOoqRTh2XI
	 T76HTvASgt+Sw==
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
Subject: [PATCH v6 1/8] dma-buf: Rename .move_notify() callback to a clearer identifier
Date: Fri, 30 Jan 2026 15:37:17 +0200
Message-ID: <20260130-dmabuf-revoke-v6-1-06278f9b7bf0@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
References: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69714-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email,nvidia.com:mid,nvidia.com:email]
X-Rspamd-Queue-Id: A0D19BB30D
X-Rspamd-Action: no action

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
index c1461317eb29..cd4944ceb047 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -438,7 +438,7 @@ amdgpu_dma_buf_create_obj(struct drm_device *dev, struct dma_buf *dma_buf)
 }
 
 /**
- * amdgpu_dma_buf_move_notify - &attach.move_notify implementation
+ * amdgpu_dma_buf_move_notify - &attach.invalidate_mappings implementation
  *
  * @attach: the DMA-buf attachment
  *
@@ -509,7 +509,7 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 
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


