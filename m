Return-Path: <kvm+bounces-67665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E46D0E9B1
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22051300A358
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 10:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36FF334C06;
	Sun, 11 Jan 2026 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiXYJHFl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042A8334C1F;
	Sun, 11 Jan 2026 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768127844; cv=none; b=EjutusShA9ZERKGT10Y5IQKG5IuKkXfxrnFf1EGMPlsj6nVJpY4AGEmPiCJg0Mpl8txWTVjrdf8R6TbwpxAN+8hZHOBNkJdYbRMvlsZL94+2JCF04hJvwBPNWT0oC8gJgA/moqV0vzspqtUAynSohKeFueiEo8injxlmsa1BVGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768127844; c=relaxed/simple;
	bh=bVMuAERSBlKdzhLxVaQlP3hzLMvLvZAcJTcCJIC68T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfX3bNkkvI4Nf2QZBekkvkZeU6+xayU32tZwjO3sKcx+0X7UcorwcXqCh6K0h27cWSflvEZnK6/JrhwcGj3s64oNJDKM6gpX+59OHrS2uwAZIcWmGrr4M3zVziZKFJJYpSiDHUM2KkvyyUXqz6Sc+j6OnWHGHwgL/EqYP3ZpTsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiXYJHFl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558FFC4CEF7;
	Sun, 11 Jan 2026 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768127843;
	bh=bVMuAERSBlKdzhLxVaQlP3hzLMvLvZAcJTcCJIC68T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiXYJHFlcIoC/JoZ3ceH4yWSeLVsDm8VlgrAF92ZCEZxttSm9JnrPYWffKu4e/rvF
	 0e1BR1toZVAHOc0NxeaZQtlKIWYDLkjYlQxpd+XHLGAQG7CC0Gkvevxh5V7S2esfVQ
	 VjESTxhMJdrw9rMKLkziQuuROWp4fDnP+cnF6i8y620MbZcvk5koKkbbpN4GAiijfK
	 jqNfg0dv1ncnpPlC7kpKAfz1xdZ+0wgQC38s1ynVTcSU4BIrJI0z6Fg9RXDmAx7xnj
	 vdZgkO86I1XvaAerLFBFYAsQ5o9pxWSgREEfAMHGhUaof748wCuF0DJ2HNeACb5iLG
	 JhZC5kzgmjb3g==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev
Subject: [PATCH 1/4] dma-buf: Introduce revoke semantics
Date: Sun, 11 Jan 2026 12:37:08 +0200
Message-ID: <20260111-dmabuf-revoke-v1-1-fb4bcc8c259b@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
References: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
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

Add a dma-buf revoke mechanism that allows an exporter to explicitly
invalidate ("kill") a shared buffer after it has been handed out to
importers. Once revoked, all further CPU and device access is blocked, and
importers consistently observe failure.

This requires both importers and exporters to honor the revoke contract.
For importers, this means no page faults are delivered after the buffer is
invalidated. For exporters, the dma-buf core prevents attaching new
importers and remapping existing ones once revocation has occurred.

The proposed mechanism allows binding importers that do not require revoke
support, and they shall continue using the existing .move_notify() API.
However, importers that cannot handle page faults to remap buffers will
fail to bind to exporters that do not support revoke.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 36 ++++++++++++++++++++++++++++++++----
 include/linux/dma-buf.h   | 31 +++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index edaa9e4ee4ae..4d31fba792ee 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -697,6 +697,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
 
+	if (WARN_ON(exp_info->revoke_semantics && exp_info->ops->pin))
+		return ERR_PTR(-EINVAL);
+
 	if (!try_module_get(exp_info->owner))
 		return ERR_PTR(-ENOENT);
 
@@ -727,6 +730,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
 	dmabuf->cb_in.active = dmabuf->cb_out.active = 0;
 	INIT_LIST_HEAD(&dmabuf->attachments);
+	dmabuf->revoke_semantics = exp_info->revoke_semantics;
 
 	if (!resv) {
 		dmabuf->resv = (struct dma_resv *)&dmabuf[1];
@@ -948,8 +952,21 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	if (WARN_ON(!dmabuf || !dev))
 		return ERR_PTR(-EINVAL);
 
-	if (WARN_ON(importer_ops && !importer_ops->move_notify))
-		return ERR_PTR(-EINVAL);
+	if (dmabuf->invalidate)
+		return ERR_PTR(-ENODEV);
+
+	if (importer_ops) {
+		if (WARN_ON(!importer_ops->move_notify &&
+			    !importer_ops->revoke_notify))
+			return ERR_PTR(-EINVAL);
+
+		if (WARN_ON(importer_ops->move_notify &&
+			    importer_ops->revoke_notify))
+			return ERR_PTR(-EINVAL);
+
+		if (!dmabuf->revoke_semantics && importer_ops->revoke_notify)
+			return ERR_PTR(-EINVAL);
+	}
 
 	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
 	if (!attach)
@@ -1102,6 +1119,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
+	if (attach->dmabuf->invalidate)
+		return ERR_PTR(-ENODEV);
+
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	if (dma_buf_pin_on_map(attach)) {
@@ -1261,8 +1281,16 @@ void dma_buf_move_notify(struct dma_buf *dmabuf)
 	dma_resv_assert_held(dmabuf->resv);
 
 	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (attach->importer_ops)
-			attach->importer_ops->move_notify(attach);
+		if (attach->importer_ops) {
+			if (attach->importer_ops->move_notify)
+				attach->importer_ops->move_notify(attach);
+
+			if (attach->importer_ops->revoke_notify)
+				attach->importer_ops->revoke_notify(attach);
+		}
+
+	if (dmabuf->revoke_semantics)
+		dmabuf->invalidate = true;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_move_notify, "DMA_BUF");
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 0bc492090237..e198ee490151 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -23,6 +23,7 @@
 #include <linux/dma-fence.h>
 #include <linux/wait.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/dma-resv.h>
 
 struct device;
 struct dma_buf;
@@ -441,6 +442,15 @@ struct dma_buf {
 		struct dma_buf *dmabuf;
 	} *sysfs_entry;
 #endif
+	/**
+	 * @revoke_semantics:
+	 *
+	 * This exporter implements revoke semantics.
+	 */
+	bool revoke_semantics;
+
+	/** @invalidate: this buffer was revoked and invalidated */
+	bool invalidate;
 };
 
 /**
@@ -476,6 +486,18 @@ struct dma_buf_attach_ops {
 	 * point to the new location of the DMA-buf.
 	 */
 	void (*move_notify)(struct dma_buf_attachment *attach);
+
+	/**
+	 * @revoke_notify: [optional] notification that the DMA-buf is revoking
+	 *
+	 * If this callback is provided the importer will invildate the mappings.
+	 *
+	 * This callback is called with the lock of the reservation object
+	 * associated with the dma_buf held.
+	 *
+	 * New mappings shouldn't be created after this callback returns.
+	 */
+	void (*revoke_notify)(struct dma_buf_attachment *attach);
 };
 
 /**
@@ -516,6 +538,7 @@ struct dma_buf_attachment {
  * @size:	Size of the buffer - invariant over the lifetime of the buffer
  * @flags:	mode flags for the file
  * @resv:	reservation-object, NULL to allocate default one
+ * @revoke_semantics: support revoke semantics
  * @priv:	Attach private data of allocator to this buffer
  *
  * This structure holds the information required to export the buffer. Used
@@ -528,6 +551,7 @@ struct dma_buf_export_info {
 	size_t size;
 	int flags;
 	struct dma_resv *resv;
+	bool revoke_semantics;
 	void *priv;
 };
 
@@ -620,4 +644,11 @@ int dma_buf_vmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
 void dma_buf_vunmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
 struct dma_buf *dma_buf_iter_begin(void);
 struct dma_buf *dma_buf_iter_next(struct dma_buf *dmbuf);
+
+static inline void dma_buf_mark_valid(struct dma_buf *dma_buf)
+{
+	dma_resv_assert_held(dma_buf->resv);
+
+	dma_buf->invalidate = false;
+}
 #endif /* __DMA_BUF_H__ */

-- 
2.52.0


