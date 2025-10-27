Return-Path: <kvm+bounces-61151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F2ABFC0CF47
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7450E34C7D2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7B72F693B;
	Mon, 27 Oct 2025 10:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="Fon/lqKC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E8D2F3C26;
	Mon, 27 Oct 2025 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761560844; cv=none; b=QxrDW+tjShm97ljd99nHEmc5WSxvzEBG4bgSAbnPUhYUCSIJYmK2GX4xDHgPOz0+BTc+vfUZmjqGmeqjrchMSamtE+qVpMSJIkpxi3x7DBFJMcEIQxMCJcrwbIG5+pbz4F+SjXRMUhr8IN/nbrPA1gx8mdZQYjTgY+PdsD27+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761560844; c=relaxed/simple;
	bh=jXAAj67VByP6AXYtptL0mITMT/dGFN5VXSakFK1aluQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AVoC+qPVO5Y40gZVpGzDbeZaILNe3i+oQ+JiKuVfsG5xQ/SlFuqPWVHKqqEO6i6TPTx2l5+eWlUIpXVytDHeb3n84KKmiS/w2PY87L2d8E7hKQI+EPJCBZiqBQRSEa9zfLzbIaS6LVxHT/NZuJaMQ6p08Zsm9GBI9ncvau0CBkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=Fon/lqKC; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
	by mx0a-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RA1oEW3083451;
	Mon, 27 Oct 2025 10:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=jan2016.eng; bh=vjpGgOHUOzQBJjbmi3ZzYe0ig6bvhvg6P
	zLW4ciotmE=; b=Fon/lqKCUNmllPTKFr/WJwBjjFND8w0JqGTOH6vAchohzKkQf
	ZfICq86h8skzCX4V6dO5fu2Io86e5TslrImL9bqHV5c3RMOm6a2WHI95zRDpV10d
	UD/EvSl0N7fkZBJJELJyHQAyeZMA5B5qXaN86LmdzKpU8EGXrFQZj8QvCLxFW7n2
	IGAxwKt46/a4Zrb0xne/SHkrl+h4pUY6SnDwXn+Ox7EKVTNA86AMQc7LA1cAG83q
	i7MX6QfjGzqKmm7UbE6Db/UtY5pheXAntDNBp1NK9RnXMmvNTl0I36jNGi6HqvUz
	DviL8vhPHxIrkXW3YalcPaLCuknuFi0ImKXIg==
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60])
	by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 4a0nt8sqmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 10:27:11 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 59R73c2B025840;
	Mon, 27 Oct 2025 03:27:10 -0700
Received: from prod-mail-relay02.akamai.com ([172.27.118.35])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTP id 4a0vh86pyc-1;
	Mon, 27 Oct 2025 03:27:09 -0700
Received: from muc-lhvdhd.munich.corp.akamai.com (muc-lhvdhd.munich.corp.akamai.com [172.29.2.201])
	by prod-mail-relay02.akamai.com (Postfix) with ESMTP id 9162C83;
	Mon, 27 Oct 2025 10:27:08 +0000 (UTC)
From: Nick Hudson <nhudson@akamai.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Cc: Nick Hudson <nhudson@akamai.com>, Max Tottenham <mtottenh@akamai.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and use in net.c
Date: Mon, 27 Oct 2025 10:26:44 +0000
Message-Id: <20251027102644.622305-1-nhudson@akamai.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270096
X-Authority-Analysis: v=2.4 cv=QaRrf8bv c=1 sm=1 tr=0 ts=68ff48ff cx=c_pps
 a=NpDlK6FjLPvvy7XAFEyJFw==:117 a=NpDlK6FjLPvvy7XAFEyJFw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=X7Ea-ya5AAAA:8
 a=s2F8ZfxWFg2Xnt8VUUoA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 3_hAfG8Jii9R6Ttd3oyXC2qDXGaXWTnw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA5NyBTYWx0ZWRfX0JYiNUNqObp8
 JSHsznxaXuUnKUXZEPfIh5l+6VdbhfQgEhhbg6uy1bZKkvJsbnTSBGTAKSJNmZLA4Jc+0Y8mEFr
 s3BN1ElBHHIfugkuIJ1VNg2f8XYlWrP1XHSqBD0oEhtv7M64eQR1A+POuA00bIEFhNqZ9MWbpfe
 Sz+KiyUl7g89Bl41ET/JhLkW7E/j+rs8tmsm7sX2rk7WNPgS1RhOHYsm2DuoIxA0hHd35rGgzf6
 iZDfadQ+U8y3tA3ItJ2tELK4tmQkAZaCfWzpilp5+kBhiKEmBAIWXBIP5Xk7Pk0lnKC2qmNj1jT
 tgZgMwgzqyiBerScIUmoG8dyHggPVCj0703xnXza84fpeRpNRmmFe4Muz9jhT45Vc+F2Kok75R+
 b3Iavehd92S2qd/MSPMCfJBbX+kHOg==
X-Proofpoint-ORIG-GUID: 3_hAfG8Jii9R6Ttd3oyXC2qDXGaXWTnw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1011 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510210000 definitions=main-2510270097

The vhost_net (and vhost_sock) drivers create worker tasks to handle
the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO that
can be used to determine the PID of these tasks so that, for example,
they can be pinned to specific CPU(s).

Signed-off-by: Nick Hudson <nhudson@akamai.com>
Reviewed-by: Max Tottenham <mtottenh@akamai.com>
---
 drivers/vhost/net.c              |  5 +++++
 drivers/vhost/vhost.c            | 16 ++++++++++++++++
 include/uapi/linux/vhost.h       |  3 +++
 include/uapi/linux/vhost_types.h | 13 +++++++++++++
 kernel/vhost_task.c              | 12 ++++++++++++
 5 files changed, 49 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 35ded4330431..e86bd5d7d202 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1804,6 +1804,11 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 		return vhost_net_reset_owner(n);
 	case VHOST_SET_OWNER:
 		return vhost_net_set_owner(n);
+	case VHOST_GET_VRING_WORKER_INFO:
+		mutex_lock(&n->dev.mutex);
+		r = vhost_worker_ioctl(&n->dev, ioctl, argp);
+		mutex_unlock(&n->dev.mutex);
+		return r;
 	default:
 		mutex_lock(&n->dev.mutex);
 		r = vhost_dev_ioctl(&n->dev, ioctl, argp);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..8b52fd5723c3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2399,6 +2399,22 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		if (ctx)
 			eventfd_ctx_put(ctx);
 		break;
+	case VHOST_GET_VRING_WORKER_INFO:
+		worker = rcu_dereference_check(vq->worker,
+					       lockdep_is_held(&dev->mutex));
+		if (!worker) {
+			ret = -EINVAL;
+			break;
+		}
+
+		memset(&ring_worker_info, 0, sizeof(ring_worker_info));
+		ring_worker_info.index = idx;
+		ring_worker_info.worker_id = worker->id;
+		ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
+
+		if (copy_to_user(argp, &ring_worker_info, sizeof(ring_worker_info)))
+			ret = -EFAULT;
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 		break;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c57674a6aa0d..c32aa8c71952 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -101,6 +101,9 @@
 /* Return the vring worker's ID */
 #define VHOST_GET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x16,		\
 				     struct vhost_vring_worker)
+/* Return the vring worker's ID and PID */
+#define VHOST_GET_VRING_WORKER_INFO _IOWR(VHOST_VIRTIO, 0x17,	\
+				     struct vhost_vring_worker_info)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 1c39cc5f5a31..28e00f8ade85 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -63,6 +63,19 @@ struct vhost_vring_worker {
 	unsigned int worker_id;
 };
 
+/* Per-virtqueue worker mapping entry */
+struct vhost_vring_worker_info {
+	/* vring index */
+	unsigned int index;
+	/*
+	 * The id of the vhost_worker returned from VHOST_NEW_WORKER or
+	 * allocated as part of vhost_dev_set_owner.
+	 */
+	unsigned int worker_id;
+
+	__kernel_pid_t worker_pid;  /* PID/TID of worker thread, -1 if none */
+};
+
 /* no alignment requirement */
 struct vhost_iotlb_msg {
 	__u64 iova;
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 27107dcc1cbf..aa87a7f0c98a 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -67,6 +67,18 @@ static int vhost_task_fn(void *data)
 	do_exit(0);
 }
 
+/**
+ * vhost_get_task - get a pointer to the vhost_task's task_struct
+ * @vtsk: vhost_task to return the task for
+ *
+ * return the vhost_task's task.
+ */
+struct task_struct *vhost_get_task(struct vhost_task *vtsk)
+{
+	return vtsk->task;
+}
+EXPORT_SYMBOL_GPL(vhost_get_task);
+
 /**
  * vhost_task_wake - wakeup the vhost_task
  * @vtsk: vhost_task to wake
-- 
2.34.1


