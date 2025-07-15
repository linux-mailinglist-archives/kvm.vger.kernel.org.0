Return-Path: <kvm+bounces-52415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA816B04F1E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 051893A8857
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0762D1936;
	Tue, 15 Jul 2025 03:34:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6D15B0EC;
	Tue, 15 Jul 2025 03:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550455; cv=none; b=hM2mObTWQK+44VYmWhTNiO2b3tauAmrdoqc6SPEN+tnFO2IJz2lsqoAI9takz3NUFlm7NLpKaoMFyGZx3jlEhHIaY2z+sAHQGTrZxor6KsZepITeZm9Bpu1obEgg3/d8srbF+jo+5GT1joQCbK3HD/T8kiJhqcMPCR7/eSoYxyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550455; c=relaxed/simple;
	bh=zEUug+4FUoEJMcJ1tici7hiIpx9gNXCUsZVT5DwJrHM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N9xdt6N3kFhWbNmUjozK0cO3HvFTUSYUxQ2bWF29zUdPnG6ljql7zCFhSU63p7FJVqU6KQzcXof1yx3vgm74JGol5AZH9nK2QK9dQwtX6Y9QwTQ5kWqT59EeEEwAVZyI9oLn1VXlfNeKtU0yN2qLUiyTLqepV6IZohMBMe7pW1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bh4Vv1PFSz2TT4b;
	Tue, 15 Jul 2025 11:32:07 +0800 (CST)
Received: from kwepemo200008.china.huawei.com (unknown [7.202.195.61])
	by mail.maildlp.com (Postfix) with ESMTPS id D7EC91A0188;
	Tue, 15 Jul 2025 11:34:09 +0800 (CST)
Received: from huawei.com (10.67.175.28) by kwepemo200008.china.huawei.com
 (7.202.195.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 15 Jul
 2025 11:34:09 +0800
From: Xinyu Zheng <zhengxinyu6@huawei.com>
To: <mst@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
	<stefanha@redhat.com>, <virtualization@lists.linux-foundation.org>,
	<kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
	<stable@vger.kernel.org>
CC: <zhengxinyu6@huawei.com>
Subject: [PATCH v5.15] vhost-scsi: protect vq->log_used with vq->mutex
Date: Tue, 15 Jul 2025 03:22:34 +0000
Message-ID: <20250715032234.1624106-1-zhengxinyu6@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200008.china.huawei.com (7.202.195.61)

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

Cc: stable@vger.kernel.org#5.15.x
Cc: gregkh@linuxfoundation.org
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20250403063028.16045-2-dongli.zhang@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Conflicts in drivers/vhost/scsi.c
  bacause vhost_scsi_complete_cmd_work() has been refactored. ]
Signed-off-by: Xinyu Zheng <zhengxinyu6@huawei.com>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f9930887fdd2..2c19fa02141d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -563,8 +563,10 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
-			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
+			mutex_lock(&q->vq.mutex);
+			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			mutex_unlock(&q->vq.mutex);
 			vq = q - vs->vqs;
 			__set_bit(vq, signal);
 		} else
@@ -1166,8 +1168,11 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
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
2.34.1


