Return-Path: <kvm+bounces-68619-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJQ0CpiAcGktYAAAu9opvQ
	(envelope-from <kvm+bounces-68619-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:30:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DEA52D2A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B0620906F17
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E46A4418FE;
	Tue, 20 Jan 2026 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRchcWPp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AD439015;
	Tue, 20 Jan 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918049; cv=none; b=ifW3Ma7PWnmJR7KXUlGe8Fty0Ap/K6Fz2HJFDBgeeVcQ0cQFzenrIkoXI8wKxIiK0cZ9NS2ey0L5+Duj9DmlJkYtJKwaPZIPkh+mPCbFk5v9USrx23rh/kuxrDWSbMkY5SkjnSF/bUdvbIudB+u+u5fkc/hyRFtuPOGja1t9yVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918049; c=relaxed/simple;
	bh=MryhAftyHxYTop+mnKinqTb8eFJW20BmygrDTfbPY2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYzjNqj4dXSOMfZ/U4f+nn5VN8uPuEpzrKtAXE48PtR1KITgZiZOCiWPPORllX9NSKiUhAM7cRjh1juFrNIBp2pKpeFWvuOB1gztIqzfMwbgyx3cfudA7OrL8xqe7FIcN41Rkn1I0Ie2B6CMvET67QG4usyVB6fqVbbwXLQVhHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRchcWPp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB10C16AAE;
	Tue, 20 Jan 2026 14:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918049;
	bh=MryhAftyHxYTop+mnKinqTb8eFJW20BmygrDTfbPY2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRchcWPpsUvcK+Crk3OAOK761eYKGCH0fgOBvesqeEQQlf1bYaTkU5/cAIoZz24Xg
	 QZOa8k69UfgH0yHQAxr/k5AFdCcArO4JpyQS0ALF7IOK7+5MXk+zQaXz/gMMgMYxTE
	 oN/OiCYRgZMn7+HHLVC8ZS7zvMFhxFJKTXEohcy6HZiZ6em6nCJZ4V8msli3NFxDPo
	 ULsfYeHN5PJhqPiDXsOQsfLXaqDydvqEYPJGjBmI323H0aNfpgB/Gkg/XAf2FMSE0t
	 NXBeQanufm7+6AtVifiTmQhurpZw8xuWsfKDlKQKi/x2zRXK6HWmQL9ZaTNupRUW8w
	 BferpMeWKFc9A==
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
Subject: [PATCH v3 4/7] dma-buf: Add check function for revoke semantics
Date: Tue, 20 Jan 2026 16:07:04 +0200
Message-ID: <20260120-dmabuf-revoke-v3-4-b7e0b07b8214@nvidia.com>
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
	TAGGED_FROM(0.00)[bounces-68619-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 74DEA52D2A
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
 drivers/dma-buf/dma-buf.c | 37 ++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h   |  1 +
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index c4fa35034b92..c048c822c3e9 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1252,13 +1252,48 @@ void dma_buf_unsupported_invalidate_mappings(struct dma_buf_attachment *attach)
 }
 EXPORT_SYMBOL_FOR_MODULES(dma_buf_unsupported_invalidate_mappings, "ib_uverbs");
 
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
+	/*
+	 * There is no need to check existence of .invalidate_mappings() as
+	 * it always exists when importer_ops is set in dma_buf_dynamic_attach().
+	 */
+	return attach->importer_ops &&
+	       (attach->importer_ops->invalidate_mappings !=
+		&dma_buf_unsupported_invalidate_mappings);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
+
 /**
  * dma_buf_move_notify - notify attachments that DMA-buf is moving
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
 void dma_buf_move_notify(struct dma_buf *dmabuf)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 7d7d0a4fb762..ac2ce1273b4c 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -602,6 +602,7 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_move_notify(struct dma_buf *dma_buf);
 void dma_buf_unsupported_invalidate_mappings(struct dma_buf_attachment *attach);
+bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
 
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);

-- 
2.52.0


