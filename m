Return-Path: <kvm+bounces-61303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FB1C15744
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24331B25DD3
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 15:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED68340A48;
	Tue, 28 Oct 2025 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="h+By7Gqw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D8C18991E;
	Tue, 28 Oct 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761665358; cv=none; b=iSJMmy3PSLYXRxtRPzAMLA4doTwUT1czxJnSf6Z6fdxK0tEnMImQWMK1yu2dl5MU7CES8CMFL5HibdtW+pPTD9MWXclbzd2/hnF5VVpjG3nMfUyzfRvCWIWlCmj3Miaeqv62Swf0nvCthynFbuzKHx3Ox317xJazQGIwCH0elyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761665358; c=relaxed/simple;
	bh=NCfCXzIFfkH6cFsk3rxSj8Jx0+Jy0Qv0I9QNFqtB8UI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LEPaQGARAxQ2W4Dfg4JNRbsCJel/sFQ/qvyFyYy97gDscwsUU5bRU0azbCuUFn35NIEfLIsDk1stXfTvx3lCp9OZdi8+DVfcbbrs/5TB989cxSLCl20GrYKGWcMi6CdQ1xfdk+Yitcz1g5kprhKYupG7ridfcLZChjPGDqan3vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=h+By7Gqw; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
	by m0050102.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 59SEUeXD2489895;
	Tue, 28 Oct 2025 15:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=jan2016.eng; bh=zEj64/+eigdpoB38YMajnvera82FtERxf
	iJQI0UokSI=; b=h+By7GqweTiQdjkRJIgV1/sNqfaL/7lEMD+ZsBDMd4EZNNdCb
	7scHagyObYLsLfZbXAVC2PedcHmXoFYLc3iT8laXDNKQj7g3QhIpMyzzkB5GmOc3
	7jEj6xx6Hpt9luDiMnS3EMHrmf0U+lNrQPGJOiiNYhyyMiMII1o58yzn7eklEyvj
	q28w+YodUwopsK9ahyLSefLW0z7AN0YFKUFdo3Jz5kh2EXIR2OqxABFbQiYartim
	3kEaCIUplojlV2kHEHRI4dA2s6czCPTy7qh3U3jMxfUz8Ng8vDw/ZwHEtt8IbGnx
	jqfnYX1u6rv1jRaR+ZnkHZef5se9CTcdxQ0qg==
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18])
	by m0050102.ppops.net-00190b01. (PPS) with ESMTPS id 4a2weya8ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 15:29:09 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 59SEAXIH012449;
	Tue, 28 Oct 2025 11:29:08 -0400
Received: from prod-mail-relay02.akamai.com ([172.27.118.35])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 4a2yc1gbbb-1;
	Tue, 28 Oct 2025 11:29:08 -0400
Received: from muc-lhvdhd.munich.corp.akamai.com (muc-lhvdhd.munich.corp.akamai.com [172.29.2.201])
	by prod-mail-relay02.akamai.com (Postfix) with ESMTP id 5072283;
	Tue, 28 Oct 2025 15:29:07 +0000 (UTC)
From: Nick Hudson <nhudson@akamai.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Cc: Nick Hudson <nhudson@akamai.com>, Max Tottenham <mtottenh@akamai.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and use in net.c
Date: Tue, 28 Oct 2025 15:28:54 +0000
Message-Id: <20251028152856.1554948-1-nhudson@akamai.com>
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
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510280129
X-Authority-Analysis: v=2.4 cv=UbxciaSN c=1 sm=1 tr=0 ts=6900e145 cx=c_pps
 a=StLZT/nZ0R8Xs+spdojYmg==:117 a=StLZT/nZ0R8Xs+spdojYmg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=X7Ea-ya5AAAA:8
 a=EHjAbftWRgUkfAlJtAYA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: F9R5Oc0P0kde7f6IO1DXITIYgfYapybP
X-Proofpoint-GUID: F9R5Oc0P0kde7f6IO1DXITIYgfYapybP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDEzMCBTYWx0ZWRfX8dzQFMjJxKZf
 /XzXIUHfPcI5yQc2ckPrJ6Ixiv7jU41ALCqgvMOIdtyV5qvf7TdH3Gpm869HqLqiooASU1qI1CH
 Sp5UQHV5ksN27HHBOqR2gnAvfqJnjaUoV5+nUKBdrqGBBqNKQgvsWd5h9jy2cIZ/n01BInj/rZZ
 lM2yz15uDtTafnQ36WYYxxfWgj3XYwTfxS/4ZtGRxbjYhWsrocwYZGNnX8H0O3+9txtp58mLRZR
 Y3QANl1FtKN22htXgzMoy8N/IsZ6XqvFkk5Zm+k7/ahGTYjKBD/hW9fuWtT6krFfnGzP6mxs/Dv
 9zqKapeOMzKYRvdOw/6JENR2+mPlGhxD5+LTOMfxMXSUUvWQrv8jR1opfiSgk4tNeA2wEZbWKUJ
 WCdaGZeziFH29xaZvrGyvlZDsSQ7Ag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510210000 definitions=main-2510280130

The vhost_net (and vhost_sock) drivers create worker tasks to handle
the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO that
can be used to determine the PID of these tasks so that, for example,
they can be pinned to specific CPU(s).

Signed-off-by: Nick Hudson <nhudson@akamai.com>
Reviewed-by: Max Tottenham <mtottenh@akamai.com>
---
 drivers/vhost/net.c              |  5 +++++
 drivers/vhost/vhost.c            | 19 +++++++++++++++++++
 include/linux/sched/vhost_task.h |  2 ++
 include/uapi/linux/vhost.h       |  3 +++
 include/uapi/linux/vhost_types.h | 13 +++++++++++++
 kernel/vhost_task.c              | 12 ++++++++++++
 6 files changed, 54 insertions(+)

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
index 8570fdf2e14a..20ad9d190dc3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1012,6 +1012,7 @@ long vhost_worker_ioctl(struct vhost_dev *dev, unsigned int ioctl,
 			void __user *argp)
 {
 	struct vhost_vring_worker ring_worker;
+	struct vhost_vring_worker_info ring_worker_info;
 	struct vhost_worker_state state;
 	struct vhost_worker *worker;
 	struct vhost_virtqueue *vq;
@@ -1050,6 +1051,7 @@ long vhost_worker_ioctl(struct vhost_dev *dev, unsigned int ioctl,
 	/* vring worker ioctls */
 	case VHOST_ATTACH_VRING_WORKER:
 	case VHOST_GET_VRING_WORKER:
+	case VHOST_GET_VRING_WORKER_INFO:
 		break;
 	default:
 		return -ENOIOCTLCMD;
@@ -1082,6 +1084,23 @@ long vhost_worker_ioctl(struct vhost_dev *dev, unsigned int ioctl,
 		if (copy_to_user(argp, &ring_worker, sizeof(ring_worker)))
 			ret = -EFAULT;
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
+
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
diff --git a/include/linux/sched/vhost_task.h b/include/linux/sched/vhost_task.h
index 25446c5d3508..568f9596f29e 100644
--- a/include/linux/sched/vhost_task.h
+++ b/include/linux/sched/vhost_task.h
@@ -11,4 +11,6 @@ void vhost_task_start(struct vhost_task *vtsk);
 void vhost_task_stop(struct vhost_task *vtsk);
 void vhost_task_wake(struct vhost_task *vtsk);
 
+struct task_struct *vhost_get_task(struct vhost_task *vtsk);
+
 #endif /* _LINUX_SCHED_VHOST_TASK_H */
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


