Return-Path: <kvm+bounces-44831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 192A8AA3D48
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 01:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B8C61893554
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878F5240EFA;
	Tue, 29 Apr 2025 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzvTQBWi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F99823507E;
	Tue, 29 Apr 2025 23:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970647; cv=none; b=QXB9OGPP7hMfzxYBbCcJZyCjwgyRC8rCAN8V7YYbC7HofpxEPpJ8GoZ/0SIzQ6PfTnDABkYuJLuX94T2rtFy/dslX12nP8cZddcBvp8mnt2qJHnHvn17Bu0Rdli3Lr6WhH9k2lbex0mgoJA/W4/gX3oIWLQPN4or6wKkoT02txE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970647; c=relaxed/simple;
	bh=1gdYAgF4o2X+INtJu0Fcctni83UjSMMe6r/sreDBkEc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XUK+tk+m1pzbiovuyJT73HCHrtAQz3xVhx7S4QaEZrIJt1AHRFfSALc8p655aS6K9bRH6q0D/xDi7dvRHPDL6fD1PtES4hkvfW7szJ3NKfX5N8S+r3kFHcE44R8t9rmAFDpl+aqU+J0iqoKG44HBHj/hq79W9Tg5DqxSmO4e+ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzvTQBWi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4BAC4CEE3;
	Tue, 29 Apr 2025 23:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970647;
	bh=1gdYAgF4o2X+INtJu0Fcctni83UjSMMe6r/sreDBkEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzvTQBWiJ7mbhiybGk9pTIpWDFbJWmvMdJcpJLmZLAK8MPDNtL4JnbjCh3yZbYF5b
	 Nmr5tqbR+kU+8PMJ57UEp9jYUQo+QReASyBbThgijZtwNatQqpdlD+YwBM4SC8ODi1
	 iZ8gg2U92QaazZ2UIpnvOjfakHC5CvvDfREH/WBQGqN3ksRKJYHuY/s1uex89d9CAU
	 sVAf+bRf9nnKi5dRawq4Y9Rd9PqFqNhoboK2Fuhw2GAj0sYZfnTNOtRthNC1SA4mPi
	 d1DuYAAAyWCFRr+BHe+lpxzmiSBpOMZ8Vbw6BsMDxQhanJX6lhhpW1lkjfa7jr7asi
	 7KqXpYvGbpESA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dongli Zhang <dongli.zhang@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 21/39] vhost-scsi: protect vq->log_used with vq->mutex
Date: Tue, 29 Apr 2025 19:49:48 -0400
Message-Id: <20250429235006.536648-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit f591cf9fce724e5075cc67488c43c6e39e8cbe27 ]

The vhost-scsi completion path may access vq->log_base when vq->log_used is
already set to false.

    vhost-thread                       QEMU-thread

vhost_scsi_complete_cmd_work()
-> vhost_add_used()
   -> vhost_add_used_n()
      if (unlikely(vq->log_used))
                                      QEMU disables vq->log_used
                                      via VHOST_SET_VRING_ADDR.
                                      mutex_lock(&vq->mutex);
                                      vq->log_used = false now!
                                      mutex_unlock(&vq->mutex);

				      QEMU gfree(vq->log_base)
        log_used()
        -> log_write(vq->log_base)

Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can be
reclaimed via gfree(). As a result, this causes invalid memory writes to
QEMU userspace.

The control queue path has the same issue.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20250403063028.16045-2-dongli.zhang@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7aeff435c1d87..a71ad7353341e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -571,6 +571,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	int ret;
 
 	llnode = llist_del_all(&svq->completion_list);
+
+	mutex_lock(&svq->vq.mutex);
+
 	llist_for_each_entry_safe(cmd, t, llnode, tvc_completion_list) {
 		se_cmd = &cmd->tvc_se_cmd;
 
@@ -604,6 +607,8 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
+	mutex_unlock(&svq->vq.mutex);
+
 	if (signal)
 		vhost_signal(&svq->vs->dev, &svq->vq);
 }
@@ -1297,8 +1302,11 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 	else
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
 
+	mutex_lock(&tmf->svq->vq.mutex);
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+	mutex_unlock(&tmf->svq->vq.mutex);
+
 	vhost_scsi_release_tmf_res(tmf);
 }
 
-- 
2.39.5


