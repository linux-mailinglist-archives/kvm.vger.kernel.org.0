Return-Path: <kvm+bounces-45477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3524AAA4B7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 01:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14B5C164B64
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC8328D8F1;
	Mon,  5 May 2025 22:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUxUXOPe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC0F28D8CF;
	Mon,  5 May 2025 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484058; cv=none; b=CfUEwGVJBTLT9J3pHORDnnnDBNhTdlg1FJiHsAwPyEgSUtF6kqQvtqoP3s0fhJoh8pnNeJZxewjnErptPzehoX20MAhoQUW1c0HQ4mrYinziZ2Q41UeYr3cdutH6xJ/neJFd7uU9BAczvq+sqgpMYaQAA+yZ6bDLQ2LofRfuaj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484058; c=relaxed/simple;
	bh=Me0u92KtWJbVatZweqiucn310jO79Ids9W1Hom/IDw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TB3j/4lDqTUcAW1HmSXuY7A35ZftVjbu9vVbHTs3jpBV8QEbA/x+BM8+rSb/t8E2wLbQcUcK5aHl2EJs0hxIE5vZKimf+8c1l+3u+sQSO2qjkXdq1kku8hiJhMaes5z33lF6z44K0Fva7eD2lxt398eXYLKhv8bNRm9FvbMRL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUxUXOPe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BA3C4CEEF;
	Mon,  5 May 2025 22:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484058;
	bh=Me0u92KtWJbVatZweqiucn310jO79Ids9W1Hom/IDw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUxUXOPejkVJb/F4vxrJmrsWFQ6ns2Xa/SO9fdMEnmMJ74ydfAvA9uk3TuiUSApAv
	 5UXjZ83QsX7hy3rXLGvjoxJkotRFV98MiTCFS6V3/ij9C1G8t0aMaRUBEF/EoY1zKM
	 BXFFC1XBkDQiW3O21qERw+iSR33svmiR/06LIgXgRKWSUCCOpSCOU4XOaV14hLdfUy
	 2lwk53blAoSDAQAvXbdajPArhgxmY+XLQkAJNKaqyPeD0sK1Kzxfly1hM7ZIgCQ4qi
	 TxLSv6EDr8xHbxTZdbvQ5N9riKEuf1tdO4PQLY2Vn119UPNgPOw7nGLePT6z3UWxS9
	 ENy7sk1++w/vg==
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
Subject: [PATCH AUTOSEL 6.14 330/642] vhost-scsi: Return queue full for page alloc failures during copy
Date: Mon,  5 May 2025 18:09:06 -0400
Message-Id: <20250505221419.2672473-330-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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


