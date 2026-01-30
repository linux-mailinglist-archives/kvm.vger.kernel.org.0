Return-Path: <kvm+bounces-69716-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EJJbGy21fGm7OQIAu9opvQ
	(envelope-from <kvm+bounces-69716-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:42:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C26C0BB414
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 08FF33021CC8
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD276329E40;
	Fri, 30 Jan 2026 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPkS8oOq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18062EFD91;
	Fri, 30 Jan 2026 13:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780277; cv=none; b=oxsC7gtDYzCMYGs04cZVnUZP6QVUG0zcy81MqOAWqIDFOrygbCygYkotY+W+DPkxkwirWd6I6plaRugaFbFRh7hsMq6sLMy2N4YeKT28hHC4Te1CwUlZ0FOb9SThI7qWnzFn+FdUmS+Cff0FcC8CXdt2DaZCL0tZhnoPNTT86/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780277; c=relaxed/simple;
	bh=BadvRp2kMbYiE6vohEKv25VeRPZoBeiAhKDHz+nyIJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPfB0MgsQndQKGMAgDAoqV7CZFUu/P2xhkkon6fvLL15prAKfLhd3EYOVBmyR+t8J2w4ChO31CVbYL2d6DvP2vWt4B40iORx6iwGQsWpt9IER4ahHqQrJSADT55pQUu3DojkDH7qNk/FMu5Uj5JKWoAytPdBl18fwA3dAtkP67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPkS8oOq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CBAC4CEF7;
	Fri, 30 Jan 2026 13:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769780276;
	bh=BadvRp2kMbYiE6vohEKv25VeRPZoBeiAhKDHz+nyIJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPkS8oOqgSFwkSTrkhU0/7w1YTiXWrBwmNLdSrmnI505F0sCH2YnugM/smtGpOYdx
	 raV66aWR0nKu5TZK3XZ5aPV/DTrldO8qLyqO0ga6eB2QjF4EhZCyCn4wMn5dMeI8tI
	 OlC3ShlpvpYlEfrUnpj1MASBnoXseoaAvPuxH87WPOAmwSmfWKFQFaBCWWG6Gx71hA
	 /k3NqfAqm9qEPlzB7TEFfIjKzx62DrLS0kwYXj7B5pmZi7kwUWHvp9//JdsNwEunV8
	 kMoNJAIwUgS+dxBumKWfWkadG3CJb74es60RejSM97JAK8HGE9Lxl+y3JxOBjWrD7Z
	 GMyPknJMh9dAQ==
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
Subject: [PATCH v6 7/8] vfio: Permit VFIO to work with pinned importers
Date: Fri, 30 Jan 2026 15:37:23 +0200
Message-ID: <20260130-dmabuf-revoke-v6-7-06278f9b7bf0@nvidia.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69716-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email,shazbot.org:email,intel.com:email,amd.com:email]
X-Rspamd-Queue-Id: C26C0BB414
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
 drivers/vfio/pci/vfio_pci_dmabuf.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 485515629fe4..20d8a452471d 100644
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
@@ -357,7 +348,8 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
 
 		if (priv->revoked != revoked) {
 			dma_resv_lock(priv->dmabuf->resv, NULL);
-			priv->revoked = revoked;
+			if (revoked)
+				priv->revoked = true;
 			dma_buf_invalidate_mappings(priv->dmabuf);
 			dma_resv_wait_timeout(priv->dmabuf->resv,
 					      DMA_RESV_USAGE_BOOKKEEP, false,
@@ -365,17 +357,7 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
 			dma_resv_unlock(priv->dmabuf->resv);
 			if (revoked) {
 				kref_put(&priv->kref, vfio_pci_dma_buf_done);
-				/* Let's wait till all DMA unmap are completed. */
-				wait = wait_for_completion_timeout(
-					&priv->comp, secs_to_jiffies(1));
-				/*
-				 * If you see this WARN_ON, it means that
-				 * importer didn't call unmap in response to
-				 * dma_buf_invalidate_mappings() which is not
-				 * allowed.
-				 */
-				WARN(!wait,
-				     "Timed out waiting for DMABUF unmap, importer has a broken invalidate_mapping()");
+				wait_for_completion(&priv->comp);
 			} else {
 				/*
 				 * Kref is initialize again, because when revoke
@@ -389,6 +371,9 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
 				 * priv->revoked == true.
 				 */
 				reinit_completion(&priv->comp);
+				dma_resv_lock(priv->dmabuf->resv, NULL);
+				priv->revoked = false;
+				dma_resv_unlock(priv->dmabuf->resv);
 			}
 		}
 		fput(priv->dmabuf->file);
@@ -417,9 +402,7 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
 				      MAX_SCHEDULE_TIMEOUT);
 		dma_resv_unlock(priv->dmabuf->resv);
 		kref_put(&priv->kref, vfio_pci_dma_buf_done);
-		wait = wait_for_completion_timeout(&priv->comp,
-						   secs_to_jiffies(1));
-		WARN_ON(!wait);
+		wait_for_completion(&priv->comp);
 		vfio_device_put_registration(&vdev->vdev);
 		fput(priv->dmabuf->file);
 	}

-- 
2.52.0


