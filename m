Return-Path: <kvm+bounces-68618-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLjUAexwcGktYAAAu9opvQ
	(envelope-from <kvm+bounces-68618-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:23:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A39D15201F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8A49F7055A8
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E848E44104D;
	Tue, 20 Jan 2026 14:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSnGk9XF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7C9439015;
	Tue, 20 Jan 2026 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918045; cv=none; b=fTpw8bmTNYtgVBF8RHtlE7FHocA54mCUi3yQZDaLkBuqPe3ehTQuVVnTNtksr99xVjW0pAQjpYwujmcVovf4rzAe1X7BBEjQXcgW1pR+/BN1pFaq2iryxUc/TBkl1QFBLYvufHeDO2T+gQJrsyxm5SJGd90XsoI9Dn6JaCZrZnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918045; c=relaxed/simple;
	bh=3eb1V4Rv6TEPo/iUbHVsGnBY7mv0aXK8Ke6NEm2PaJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqnFlA/XeqzI+OSCs8gwb2jp+Hz7bR9x43QJx6ehDGphiRcOYMmPKV/3jvqrTq7S1Be8QBUvOn+rRXHV69Xxf9kBFlILHASm8CeQJHzlIT4Cm2npePYU3CnhUnrDzSjL7DrfaGG/G6GM8aWxUspxVEuE7/udeCvFPMNHSMFmC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSnGk9XF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CDFC19423;
	Tue, 20 Jan 2026 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918045;
	bh=3eb1V4Rv6TEPo/iUbHVsGnBY7mv0aXK8Ke6NEm2PaJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSnGk9XFDR4LcBjJZ3PdWo/nLxtHrZYRrbNJIbATZmIMl/oIgDp7Zv3+Iv2FgU217
	 XVf93XW9pO75mbYU7+mCrG3kSK0it+Br0MlfELbZ31oz+qTMUvDB5n3yGI2SnV3Qrp
	 D1WvGs3G3WGDLykWT09F9nPjulEAfUuV/7wykEKRBV2yJ7E0cEX5M0sYZgxlnc8sNd
	 /ouz/Bj0hGmYAAt2OyWdPAEJ9C/gT46X3HvhPjEKYLZSKETXF88S2ATjiB1BsX/IX8
	 3NXeM8d2pcUK4R9/jjKU8NFqyvNjGSef59Q10YMOdntmwc0NzsTIIUYhhfhlHlaozG
	 g5RqxzB/E0aRw==
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
Subject: [PATCH v3 3/7] dma-buf: Document RDMA non-ODP invalidate_mapping() special case
Date: Tue, 20 Jan 2026 16:07:03 +0200
Message-ID: <20260120-dmabuf-revoke-v3-3-b7e0b07b8214@nvidia.com>
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
	TAGGED_FROM(0.00)[bounces-68618-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: A39D15201F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

The .invalidate_mapping() callback is documented as optional, yet it
effectively became mandatory whenever importer_ops were provided. This
led to cases where RDMA non-ODP code had to supply an empty stub just to
provide allow_peer2peer.

Document this behavior by creating a dedicated export for the
dma_buf_unsupported_invalidate_mappings() function. This function is
intended solely for the RDMA non-ODP case and must not be used by any
other dma-buf importer.

This makes it possible to rely on a valid .invalidate_mappings()
callback to determine whether an importer supports revocation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c             | 14 ++++++++++++++
 drivers/infiniband/core/umem_dmabuf.c | 11 +----------
 include/linux/dma-buf.h               |  4 +++-
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index cd3b60ce4863..c4fa35034b92 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1238,6 +1238,20 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
 
+/*
+ * This function shouldn't be used by anyone except RDMA non-ODP case.
+ * The reason to it is UAPI mistake where dma-buf was exported to the
+ * userspace without knowing that .invalidate_mappings() can be called
+ * for pinned memory too.
+ *
+ * This warning shouldn't be seen in real production scenario.
+ */
+void dma_buf_unsupported_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	pr_warn("Invalidate callback should not be called when memory is pinned\n");
+}
+EXPORT_SYMBOL_FOR_MODULES(dma_buf_unsupported_invalidate_mappings, "ib_uverbs");
+
 /**
  * dma_buf_move_notify - notify attachments that DMA-buf is moving
  *
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index d77a739cfe7a..81442a887b48 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -184,18 +184,9 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
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
+	.invalidate_mappings = dma_buf_unsupported_invalidate_mappings,
 };
 
 struct ib_umem_dmabuf *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 1b397635c793..7d7d0a4fb762 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -458,7 +458,7 @@ struct dma_buf_attach_ops {
 	bool allow_peer2peer;
 
 	/**
-	 * @invalidate_mappings: [optional] notification that the DMA-buf is moving
+	 * @invalidate_mappings: notification that the DMA-buf is moving
 	 *
 	 * If this callback is provided the framework can avoid pinning the
 	 * backing store while mappings exists.
@@ -601,6 +601,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_move_notify(struct dma_buf *dma_buf);
+void dma_buf_unsupported_invalidate_mappings(struct dma_buf_attachment *attach);
+
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,

-- 
2.52.0


