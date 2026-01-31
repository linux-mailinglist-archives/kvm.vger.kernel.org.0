Return-Path: <kvm+bounces-69770-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CA4tK5eUfWnQSgIAu9opvQ
	(envelope-from <kvm+bounces-69770-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 06:35:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1D8C0D1A
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 06:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7030A300D0C1
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 05:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DDE341650;
	Sat, 31 Jan 2026 05:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJdD3UUT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC001327C0F;
	Sat, 31 Jan 2026 05:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769837694; cv=none; b=awoeij0GiiBVBJ7/fM6lhLKhEyzvXwxn+qXwwKS15qBvNHc0e/70qqByolACzSUg3r9CUaTJlu6MdyNwIFeF0rxqEsPEYxjfvmv2tw/YZmyCkbHEWHpshY5maDKHHRUzKETmVwrVO2pfJTpdL6+M6M4mTdwf01EtOghJw5IK2ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769837694; c=relaxed/simple;
	bh=lXD3Rfmrq9ID2Phy2qOuoiFRYX7CFuqYnX/mCIn2d/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkQCSfBt2UR+51V5yniYsuf4dGTcXoyeQvHmPtNffzOzAkOppX+O7ES+Qf9o0kk9JunRoTBFBuybRqQWYPGLfB9Syn1QzWT75BNiDzB72R3C7+t6hq+7bUX2PIw8cZYe+XNZheLuh9bUxoVdzCk6ESOvz+M1USw8ef70JWFtBlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJdD3UUT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07C1C19422;
	Sat, 31 Jan 2026 05:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769837694;
	bh=lXD3Rfmrq9ID2Phy2qOuoiFRYX7CFuqYnX/mCIn2d/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJdD3UUTvFVZ1bRRWcfac7E2Miig22lWJ0Vdj0fqat20b+afqAxwxDcGADCeOe6r+
	 dSULAUUKTv9DRSSwjGE8Jh1hvQaT83fJdQ8X4+t40pSbEGaU2gXVPQMvEE79tNYFs6
	 0SR8//5HGdjJYUVS8hHjCSwBt9DycPFUSm6jcidAT1fADs4ETvGOW1H5bOLzMr/F95
	 zCrJ7XrYRxny/BEYqw205a2U01qNka3wt0hY2vohqW/17+cstkTE5GgWPnV4+LlrMJ
	 v2xIGQlWMfA/+QHXJv153fzHFZyXdOAbArLuKXEEJzgQ+vpGLpGBxfemJXLQ5LxmN9
	 yeUh1saKO3Y/w==
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
Subject: [PATCH v7 7/8] vfio: Permit VFIO to work with pinned importers
Date: Sat, 31 Jan 2026 07:34:17 +0200
Message-ID: <20260131-dmabuf-revoke-v7-7-463d956bd527@nvidia.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69770-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email,intel.com:email,shazbot.org:email]
X-Rspamd-Queue-Id: 5C1D8C0D1A
X-Rspamd-Action: no action

From: Leon Romanovsky <leonro@nvidia.com>

Till now VFIO has rejected pinned importers, largely to avoid being used
with the RDMA pinned importer that cannot handle a move_notify() to revoke
access.

Using dma_buf_attach_revocable() it can tell the difference between pinned
importers that support the flow described in dma_buf_invalidate_mappings()
and those that don't.

Thus permit compatible pinned importers.

This is one of two items IOMMUFD requires to remove its private interface
to VFIO's dma-buf.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Alex Williamson <alex@shazbot.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 78d47e260f34..a5fb80e068ee 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -22,16 +22,6 @@ struct vfio_pci_dma_buf {
 	u8 revoked : 1;
 };
 
-static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
-{
-	return -EOPNOTSUPP;
-}
-
-static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)
-{
-	/* Do nothing */
-}
-
 static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 				   struct dma_buf_attachment *attachment)
 {
@@ -43,6 +33,9 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 	if (priv->revoked)
 		return -ENODEV;
 
+	if (!dma_buf_attach_revocable(attachment))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 
@@ -107,8 +100,6 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 }
 
 static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
-	.pin = vfio_pci_dma_buf_pin,
-	.unpin = vfio_pci_dma_buf_unpin,
 	.attach = vfio_pci_dma_buf_attach,
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,

-- 
2.52.0


