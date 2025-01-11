Return-Path: <kvm+bounces-35211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCD4A0A0B1
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 04:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC613A1376
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 03:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BE314F102;
	Sat, 11 Jan 2025 03:39:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBF517BB6;
	Sat, 11 Jan 2025 03:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.164.42.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736566781; cv=none; b=towhgorw0wRJiPADwuozDMqQe5LOei0LGy35MeA3aKew1+1eCkO1PZvnczf38vfh8eQ07E+HZjmx4NVV+LtBL3zEvAlGHgwiiSUA3h+Zg7b41P0Y1zdAhUtAWZQKK+Yk/tYtgLh6DMVNY+MoPQTVkRIG5cFYMq+t6ZLseMjEgZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736566781; c=relaxed/simple;
	bh=TLyhrsWjadiEWPvpQVisda8F0xFAdqaNQ5THKiNKd84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SMBv6sVA7eMYIAGt6ua8iri7ffKXnCUPQ4hGat3lGBS9cszi0ZYb7s3m1DBjcN2WUJBUsDiuPBXOhNiJ2+aKnrZzWFqkPstP1WEPi1ILzvltbBirh17iCdLi6CGTGmWtExhkGKnXrd8ZIV6a9IWQ0SJAkUw1R0D9K4TYFAH8KBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=61.164.42.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from NUC10i7FNH.. (unknown [10.214.100.11])
	by mail-app2 (Coremail) with SMTP id by_KCgBnm5fm5oFngZxwAQ--.56469S2;
	Sat, 11 Jan 2025 11:35:06 +0800 (CST)
From: Haoran Zhang <wh1sper@zju.edu.cn>
To: mst@redhat.com
Cc: jasowang@redhat.com,
	michael.christie@oracle.com,
	pbonzini@redhat.com,
	stefanha@redhat.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoran Zhang <wh1sper@zju.edu.cn>
Subject: [PATCH] vhost/scsi: Fix improper cleanup in vhost_scsi_set_endpoint()
Date: Sat, 11 Jan 2025 11:34:18 +0800
Message-ID: <20250111033454.26596-1-wh1sper@zju.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:by_KCgBnm5fm5oFngZxwAQ--.56469S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWr4UGFy7XF4xKF1xXFW7twb_yoW5Cr4kpF
	WYg347Gr4xGFWUta9FgFs8Wr1rGa1rZF18JF97K3WFvas0yrZrA3yDGF4jgF15AFZrCr4j
	yF1v93Z0qryvyaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: asssliaqzvq6lmxovvfxof0/1tbiAggCB2eABK8MSgAEsB

Since commit 3f8ca2e115e55 ("vhost scsi: alloc cmds per vq instead of session"), a bug can be triggered when the host sends a duplicate VHOST_SCSI_SET_ENDPOINT ioctl command.

In vhost_scsi_set_endpoint(), if the new `vhost_wwpn` matches the old tpg's tport_name but the tpg is still held by current vhost_scsi(i.e. it is busy), the active `tpg` will be unreferenced. Subsequently, if the owner releases vhost_scsi, the assertion `BUG_ON(sd->s_dependent_count < 1)` will be triggerred, terminating the  target_undepend_item() procedure and leaving `configfs_dirent_lock` locked. If user enters configfs afterward, the CPU will become locked up.
This issue occurs because vhost_scsi_set_endpoint() allocates a new `vs_tpg` to hold the tpg array and copies all the old tpg entries into it before proceeding. When the new target is busy, the controw flow falls back to the `undepend` label, cause ing all the target `tpg` entries to be unreferenced, including the old one, which is still in use.

The backtrace is:

[   60.085044] kernel BUG at fs/configfs/dir.c:1179!
[   60.087729] RIP: 0010:configfs_undepend_item+0x76/0x80
[   60.094735] Call Trace:
[   60.094926]  <TASK>
[   60.098232]  target_undepend_item+0x1a/0x30
[   60.098745]  vhost_scsi_clear_endpoint+0x363/0x3e0
[   60.099342]  vhost_scsi_release+0xea/0x1a0
[   60.099860]  ? __pfx_vhost_scsi_release+0x10/0x10
[   60.100459]  ? __pfx_locks_remove_file+0x10/0x10
[   60.101025]  ? __pfx_task_work_add+0x10/0x10
[   60.101565]  ? evm_file_release+0xc8/0xe0
[   60.102074]  ? __pfx_vhost_scsi_release+0x10/0x10
[   60.102661]  __fput+0x222/0x5a0
[   60.102925]  ____fput+0x1e/0x30
[   60.103187]  task_work_run+0x133/0x1c0
[   60.103479]  ? __pfx_task_work_run+0x10/0x10
[   60.103813]  ? pick_next_task_fair+0xe1/0x6f0
[   60.104179]  syscall_exit_to_user_mode+0x235/0x240
[   60.104542]  do_syscall_64+0x8a/0x170
[   60.113301]  </TASK>
[   60.113931] ---[ end trace 0000000000000000 ]---
[   60.121517] note: poc[2363] exited with preempt_count 1

To fix this issue, the controw flow should be redirected to the `free_vs_tpg` label to ensure proper cleanup.

Fixes: 3f8ca2e115e55 ("vhost scsi: alloc cmds per vq instead of session")
Signed-off-by: Haoran Zhang <wh1sper@zju.edu.cn>
---
 drivers/vhost/scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31e..b994138837f2 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1726,7 +1726,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 				mutex_unlock(&tpg->tv_tpg_mutex);
 				mutex_unlock(&vhost_scsi_mutex);
 				ret = -EEXIST;
-				goto undepend;
+				goto free_vs_tpg;
 			}
 			/*
 			 * In order to ensure individual vhost-scsi configfs
@@ -1802,6 +1802,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
+free_vs_tpg:
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
-- 
2.43.0


