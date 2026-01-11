Return-Path: <kvm+bounces-67667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15183D0E993
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B8A83004EDD
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 10:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61583330B2B;
	Sun, 11 Jan 2026 10:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PC42vNtx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74602334C05;
	Sun, 11 Jan 2026 10:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768127852; cv=none; b=qtCACYNHHibQml3bCSi/WFwMqYHYn4vdIhRJKqAXPv6sSBAklG0CNStH3KUWFKeIzZYgBU8co/T1wqNxG8q4TRzlaf/Y3PsOSxB3BK10KuKjJqWuPHLRRkK3TSMCC2BqPJGIaQxctmHVm6L4w9aqBgEGWlTRXzwy9JpVN7wxPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768127852; c=relaxed/simple;
	bh=EB9u2XyG8hOfqiXwLDjNViUG+l4zFMBtygFVUbtOvI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QY39eOVpvnnMXkWxbJ929vydB1GeAEi+WEmhbVurh2y2iAolw76tPMLgWUEJ9kLDmvEdsRd45cEamBzf7mk7A9j7ph1jW9+Yr7Nr/hJN4mw9bSP9KhSXqvEDoCXzhkGKeFkIeFS06qnA1ajjzB/UlqRvSLwRkUaHZwoWvePZKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PC42vNtx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765CFC4CEF7;
	Sun, 11 Jan 2026 10:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768127852;
	bh=EB9u2XyG8hOfqiXwLDjNViUG+l4zFMBtygFVUbtOvI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC42vNtxB+Qd9ZpYwFqWTPv1WbKwV1tsnlIUQNxK5JuKhr9Vc21PG2xz4+W9kyClA
	 WoqlZgKqI0PHqeEVkRivzUP8XZ7SshOloidqrN0ZZpsj9ZrTgDPJS85qXdFv3JhHmW
	 V3Mci8NLX4GRg06Z5m8BGmdBHQtXs1x6NBs3gmZL7ktD1DExEQnQHmhRJQWJIRL/Ju
	 t6UqhjElh0DIHKDFKNojNutSZWoEXYBCOhFvDNxy23odPoV4+h75gMGrHOfd5mMoPv
	 7KTB07gzSHWC3i+YtyvnLIahfUBEybflkhhjM+7s8cnjj5DtJYiuZHsGu7uGBh/dXf
	 vGneu5dryOpgw==
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
Subject: [PATCH 4/4] iommufd/selftest: Reuse dma-buf revoke semantics
Date: Sun, 11 Jan 2026 12:37:11 +0200
Message-ID: <20260111-dmabuf-revoke-v1-4-fb4bcc8c259b@nvidia.com>
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

Test iommufd_test_dmabuf_revoke() with dma-buf revoke primitives.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 550ff36dec3a..523dfac44ff8 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1958,7 +1958,6 @@ void iommufd_selftest_destroy(struct iommufd_object *obj)
 struct iommufd_test_dma_buf {
 	void *memory;
 	size_t length;
-	bool revoked;
 };
 
 static int iommufd_test_dma_buf_attach(struct dma_buf *dmabuf,
@@ -2011,9 +2010,6 @@ int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
 	if (attachment->dmabuf->ops != &iommufd_test_dmabuf_ops)
 		return -EOPNOTSUPP;
 
-	if (priv->revoked)
-		return -ENODEV;
-
 	phys->paddr = virt_to_phys(priv->memory);
 	phys->len = priv->length;
 	return 0;
@@ -2065,7 +2061,6 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 				      bool revoked)
 {
-	struct iommufd_test_dma_buf *priv;
 	struct dma_buf *dmabuf;
 	int rc = 0;
 
@@ -2078,10 +2073,11 @@ static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 		goto err_put;
 	}
 
-	priv = dmabuf->priv;
 	dma_resv_lock(dmabuf->resv, NULL);
-	priv->revoked = revoked;
-	dma_buf_move_notify(dmabuf);
+	if (revoked)
+		dma_buf_move_notify(dmabuf);
+	else
+		dma_buf_mark_valid(dmabuf);
 	dma_resv_unlock(dmabuf->resv);
 
 err_put:

-- 
2.52.0


