Return-Path: <kvm+bounces-45524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB999AAB624
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65A8E1BA784C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CB5329406;
	Tue,  6 May 2025 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nh4xGY9a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABC62BEC52;
	Mon,  5 May 2025 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485304; cv=none; b=kxMe0AgegsmWlRUY5X+V0z10ROvs0nOsX5+Pklku1S6prW4MjGmNVGpRk7oZko1VLIiAN4LpkROoIMPwcPjwnkDmV8alPIlf5Jdof9Me6cv1Lw5k0OUFTzzH1tDiRPPpR8ne5A/HmE8F0Oz2MwY44FgIIljJCSSqSCA0B62Omnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485304; c=relaxed/simple;
	bh=Me0u92KtWJbVatZweqiucn310jO79Ids9W1Hom/IDw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n1TtrqLEpQ90RzB0tBU0RAhqRkJuk62jS9SbEU3kmtMS5R0GAIsrdMGY++hSbZEa2aEuiJok74hEE8J0aqBhHR5ZzYGZBov7z6YwdfCGGFSIjYbBO6NpbxtxVKIQ/UzS5+i3H8+5KR7Q8AjwRj4Z1T2Kvz3gglle6Ag9JD5+HHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nh4xGY9a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2687C4CEEE;
	Mon,  5 May 2025 22:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485304;
	bh=Me0u92KtWJbVatZweqiucn310jO79Ids9W1Hom/IDw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nh4xGY9aSPXBxAOmIAwg7HoD700taaHrLQuoIQTIiwwgWX84l19OSQX7LGR6Zv7Yz
	 jpJcbeRBv6QQdwXS1F17KiS7Yi3BniJcQXMVaMthe/GM60Sa2A25DwGu6aR67fxGTm
	 qfTdhM2HwV/YtW6inwkI/FtlGj1gLHysF15i1w4OUVk3u3a1qwLh7lfK/OTlJFioGn
	 56aTRxfDlKDeXv4dpNfP5ObxhxBdFIKLiCSm3xYG5NfSCQrRgCUhSJ8oKZpL3rLaMg
	 P9R2qMLigPgRQ/ZftMXAeRIzx8I//JA1YQhOKuLrEhb38bRzm5b9WPPf7iWIP6cpI0
	 8D5dJGcx2Fgtw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 258/486] vhost-scsi: Return queue full for page alloc failures during copy
Date: Mon,  5 May 2025 18:35:34 -0400
Message-Id: <20250505223922.2682012-258-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 891b99eab0f89dbe08d216f4ab71acbeaf7a3102 ]

This has us return queue full if we can't allocate a page during the
copy operation so the initiator can retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20241203191705.19431-5-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 35a03306d1345..f9a106bbe8ee1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -757,7 +757,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	size_t len = iov_iter_count(iter);
 	unsigned int nbytes = 0;
 	struct page *page;
-	int i;
+	int i, ret;
 
 	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
 		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
@@ -770,6 +770,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
 			i--;
+			ret = -ENOMEM;
 			goto err;
 		}
 
@@ -777,8 +778,10 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		sg_set_page(&sg[i], page, nbytes, 0);
 
 		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
-		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes) {
+			ret = -EFAULT;
 			goto err;
+		}
 
 		len -= nbytes;
 	}
@@ -793,7 +796,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	for (; i >= 0; i--)
 		__free_page(sg_page(&sg[i]));
 	kfree(cmd->saved_iter_addr);
-	return -ENOMEM;
+	return ret;
 }
 
 static int
@@ -1277,9 +1280,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			if (unlikely(vhost_scsi_mapal(cmd, prot_bytes,
-						      &prot_iter, exp_data_len,
-						      &data_iter))) {
+			ret = vhost_scsi_mapal(cmd, prot_bytes, &prot_iter,
+					       exp_data_len, &data_iter);
+			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
 				goto err;
-- 
2.39.5


