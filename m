Return-Path: <kvm+bounces-68719-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEx6JZbQcGkOaAAAu9opvQ
	(envelope-from <kvm+bounces-68719-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:11:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C59575F7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 30AD6609A09
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CE948C8C3;
	Wed, 21 Jan 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bgu2bHAk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A7D48C41A;
	Wed, 21 Jan 2026 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000394; cv=none; b=XMCQ0Kdp3OYJkG5601iitd3dfawH9Rj6iHGitxsCkkgdgGutNfrfN7dMzv279LJXwbK6+B5QJior/OSKrEDcDf4roMLCBLp9J62z3RoHGjLKkQgFrZhikBMA+1IfsVSYK3ZPJnEd08Ql2DkdzOT7dJTJtTRB7C1Vxtx+FQw/pBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000394; c=relaxed/simple;
	bh=p5A57x2ML6ijm4DUYOv5yNl/9WgFsMaBe4B+t34Ueu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AEX8Y+wFpPhOZcJpk/1t07CexsA5+Bw9FryMp05kZDe6Y1F/+toaO3hHHZ5mllLL5Y50gQQKwqjVhKrD8oukDeZqpOYD2GTOuo2m5fjVESAb7cqd25di1Ny1v3i8VZv1Mz9xs2xPovmvtokky7OBPmcsAv5giQIu409OzYfLm1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bgu2bHAk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E54C19421;
	Wed, 21 Jan 2026 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769000394;
	bh=p5A57x2ML6ijm4DUYOv5yNl/9WgFsMaBe4B+t34Ueu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgu2bHAkHMR/M+vKnRgSzqRNbT/nZu4dmR6qTZVbksWjxxbfG5r0XQu4ZvjS2xoSu
	 kf634oD8satFXndwsk79FHK+mGI8n0dEF9cwaiKWN+Xlx68y2uKuVIBQNT+KWfxQSg
	 YtwOADQ2Taz6hnGN3XTQ+0g4dUg2AQmOubVtWKf6iTxNu8pPb+aVPIHPSTFb6jZmIE
	 PHhPB+/TTj4Pv2QM3i+KEsEZ0cMOYKo7GEeJQWPbhtOkl4P2kwqVkTz5CLXGIoNOym
	 lvR3voUgpvWnOe5kUSati4ByTwuCtyCXzwy//FdzB2cCxlqk8UiTjIJaqtpS8KDPnR
	 u9e5Is4MyVM7Q==
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
Subject: [PATCH v4 5/8] dma-buf: Add check function for revoke semantics
Date: Wed, 21 Jan 2026 14:59:13 +0200
Message-ID: <20260121-dmabuf-revoke-v4-5-d311cbc8633d@nvidia.com>
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
	TAGGED_FROM(0.00)[bounces-68719-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 08C59575F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

A DMA-buf revoke mechanism that allows an exporter to explicitly
invalidate ("kill") a shared buffer after it has been handed out to
importers. Once revoked, all further CPU and device access is blocked, and
importers consistently observe failure.

This requires both importers and exporters to honor the revoke contract.

For importers, this means implementing .invalidate_mappings(). For exporters,
this means implementing the .pin() and/or .attach() callback, which check the
dma‑buf attachment for a valid revoke implementation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 32 +++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h   |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 1629312d364a..20fef3fb3bdf 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1242,13 +1242,43 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
 
+/**
+ * dma_buf_attach_revocable - check if a DMA-buf importer implements
+ * revoke semantics.
+ * @attach: the DMA-buf attachment to check
+ *
+ * Returns true if the DMA-buf importer can handle invalidating it's mappings
+ * at any time, even after pinning a buffer.
+ */
+bool dma_buf_attach_revocable(struct dma_buf_attachment *attach)
+{
+	return attach->importer_ops &&
+	       attach->importer_ops->invalidate_mappings;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
+
 /**
  * dma_buf_invalidate_mappings - notify attachments that DMA-buf is moving
  *
  * @dmabuf:	[in]	buffer which is moving
  *
  * Informs all attachments that they need to destroy and recreate all their
- * mappings.
+ * mappings. If the attachment is dynamic then the dynamic importer is expected
+ * to invalidate any caches it has of the mapping result and perform a new
+ * mapping request before allowing HW to do any further DMA.
+ *
+ * If the attachment is pinned then this informs the pinned importer that
+ * the underlying mapping is no longer available. Pinned importers may take
+ * this is as a permanent revocation so exporters should not trigger it
+ * lightly.
+ *
+ * For legacy pinned importers that cannot support invalidation this is a NOP.
+ * Drivers can call dma_buf_attach_revocable() to determine if the importer
+ * supports this.
+ *
+ * NOTE: The invalidation triggers asynchronous HW operation and the callers
+ * need to wait for this operation to complete by calling
+ * to dma_resv_wait_timeout().
  */
 void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d5c3ce2b3aa4..2aa9c7d08abb 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -601,6 +601,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
+bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,

-- 
2.52.0


