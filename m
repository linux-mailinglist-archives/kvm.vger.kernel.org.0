Return-Path: <kvm+bounces-37817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89871A30467
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0D50165F6D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09CB1EF096;
	Tue, 11 Feb 2025 07:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nn7Pjwxs"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495291EBA08
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739258614; cv=none; b=mwivf0kpWktdTu80xOm2DJK5bjyh8EC90gBGcQddVrmM9sO/MMrp+Bv4wQ0NtHcDSZ8UCP1Jdmb74XLAMDOKNPzCTY6j1RThwGp+Ixsk5/m8Mvw8BFj0miWvh8oqjP3N4L7sk1VA9rI2bAT710wkXHTD6PZ7dSe8NFnUKYydqdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739258614; c=relaxed/simple;
	bh=awKoYhrVzwDw7hkf/6J7btjKvL1OaAde+egvZ6yaW7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nbOzDQuIG+T8y8ucPmtZHhbJarEbp0ViVMXQq7tYn2cn23Qc/wVnuHz12tXNIl7mAvf2ZM6JCXTrNnOs/JPkbQVb6e0NdSYzQRGJ+S/wM+MV4/OnKCxW7tSq/GSFTJq15n3haLF3j2Q7w/bJBqztwnJJsaCPg8WhMNa7ABzuGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nn7Pjwxs; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250211072325epoutp02745029068f2fd8ee028da988a9437463~jFnyFeFXg1886918869epoutp02N
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250211072325epoutp02745029068f2fd8ee028da988a9437463~jFnyFeFXg1886918869epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739258605;
	bh=KsiY07TAUV3nL0irkdKx8yriCajiaEpcxJeleGNxtA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nn7PjwxsnXwFeDyMO2uTsTJZDf+rE2yQWdrikjBhXM3jOfQJjS6ItI5Y5wMpyNFI4
	 T40VkWr54np1haJOiGZURfaMqJEMdS//+PU5n5J/FTqgbf3vmK8nU6QkaPlGKoEpj6
	 fSrRW9zwPYlxUr85xXHJTgkDsPPZnaRYS7wpbByc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250211072324epcas5p190436ac8ec622b4b6eeb618de31b22ad~jFnxSV7nx0260002600epcas5p1v;
	Tue, 11 Feb 2025 07:23:24 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YsXwp6lgNz4x9Q1; Tue, 11 Feb
	2025 07:23:22 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	88.D9.20052.AEAFAA76; Tue, 11 Feb 2025 16:23:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250211071946epcas5p3c2afde3813ab81142e81cff110ab7afa~jFkmajpv92383023830epcas5p3D;
	Tue, 11 Feb 2025 07:19:46 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250211071946epsmtrp2e7f321ea44be836632a869c1fea55d39~jFkmXAwpX0103201032epsmtrp2O;
	Tue, 11 Feb 2025 07:19:46 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-61-67aafaeaa887
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.57.33707.21AFAA76; Tue, 11 Feb 2025 16:19:46 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250211071942epsmtip1050923bde20eeca0be4070f3f06793b6~jFki7bCav1180211802epsmtip1T;
	Tue, 11 Feb 2025 07:19:42 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
	jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, q1.huang@samsung.com, ying01.gao@samsung.com,
	ying123.xu@samsung.com, lei19.wang@samsung.com, Junnan Wu
	<junnan01.wu@samsung.com>
Subject: [Patch net 2/2] vsock/virtio: Don't reset the created SOCKET during
 suspend to ram
Date: Tue, 11 Feb 2025 15:19:22 +0800
Message-Id: <20250211071922.2311873-3-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250211071922.2311873-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbVRz23NvbXggdd4DjjMVZmxFHGYxii4cJOB2Ryx4GMjWLxpQrXAqB
	3tY+3DSYMF7jIc8IAmPI3CMUyYilQxgbZGy8qggbDEEEAWEuMAYbiAmGYF+b++/7fq/v950H
	iXvM833IZE7PajkmVcx35bXc8pMELGw0KIPauuWoZjCLh+Z7ZgXoz3NGAZot7uOjy3dXMTQ5
	GoWGWooIVFP+KcppHSbQ8LUaPhq5+JUAbW0sEKinbgda/+khQJeWBnA0ULJCoMGaLRwtlm0R
	qPtHI4FGMxAaum2d2jlbRRzcQZuN4xhdZzLQpoY8Pt02E0o/aK4C9HLHPT5dZG4A9Kppdwz5
	YUpYEssksFoRy8WrE5I5Zbj4yHHFIYU8JEgaIA1Fr4tFHKNiw8WRR2MC3klOtVoTiz5jUg3W
	UAyj04n3R4Rp1QY9K0pS6/ThYlaTkKqRaQJ1jEpn4JSBHKs/IA0KCpZbC+NSkuau5hOaSs9T
	HZ0/CNJBKZUPXEhIyWDGcCXIB66kB9UOYIUlj+8gTwDseJCOPyNPRtbB05acwlHMkWizJi40
	Ocl9ABdKLDxbFZ/yg33X6+2zvKgLAA7W/03YCE61Y/D8b6v2WZ7UxzC/bAS3YR7lC7MnZwT5
	gCSFVAQcvS5yyL0MO28O2EtcqDfhSGWLwIaF1HbYXzVnF8OtNZlXz9p3hdQ0CY0VZZijORIu
	T5U69/aEC71mgQP7wNVHN/gOnAILuzecWA8LHt0lHPgNOHjlDG7bB7e6abq23xF+CZZbrmAO
	3W2w8N85p5QQttbaMGnFvnC5JM0R3gWNJpNTlYY/dw47D7sMwKGCEUEJEFU/Z6f6OTvV/yvX
	AbwB7GQ1OpWS1ck1Uo49+eya49UqE7C/d0l0K5icXgnsAhgJugAkcbGXUHa+XukhTGA+/4LV
	qhVaQyqr6wJy63GX4j4vxqutH4bTK6Sy0CBZSEiILPS1EKnYW5jZlqX0oJSMnk1hWQ2rfdqH
	kS4+6VhEQWN/E+Z+JCzz67i3XjUSrFDAGzwce+eXjN2a07Sv1JAWfcbXPOXXv8yLEgSfmKv+
	pmNvvapFEdlrNvgf/1VZfMp8kLdrbPE98QnpuV6i1S3glWiN3x2u1m30xvT74y+sKxrNbFYp
	O++3+Zf3eOdl17jfYx6HWix7JAO5iVOX4s+ub/BrxyYet1R8e1L+7kfYdvPbD4vjElVuzUkT
	S4c+qe/OzbO4LLffPzqWW+71Zdxc/PrUzAeRKxX+NFPCuackHzudzU4MNG/LI7Il2VvB+3T/
	fOchuvn9Xt8lbzp259p4WtSxe0O3e9fcL97C8vSJBxo1m7EBa5Kcvn3+m4s9RX+IebokRirB
	tTrmPwKjlRZ4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSnK7Qr1XpBu/bRSzmnG9hsXh67BG7
	xeO5K9ktHvWfYLNYdukzk8Xda+4WF7b1sVrMmVpo0bbjMqvF5V1z2CyuLOlht/j/6xWrxbEF
	YhbfTr9htFj69iyzxdkJH1gtzs/5z2zxetJ/Vouj21eyWlxrsrC4cARo6v5HM1kdxDy2rLzJ
	5LFgU6nHplWdbB47H1p6vNg8k9Hj/b6rbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8WRr
	F2vBDOGKffs3sjcwThToYuTkkBAwkWjrvcbUxcjFISSwnVHiSNtbJoiEtETX7zZmCFtYYuW/
	5+wQRU8YJS5sXM0KkmAT0JQ4sWcFG4gtIrCWUWLTPkOQImaBk0wSt2ZMAOsWFoiWePN2OzuI
	zSKgKtF69yGQzcHBK2AncW2PAsQCeYn9B8+ClXMK2EtcmbENrFwIqGTX/GUsIDavgKDEyZlP
	wGxmoPrmrbOZJzAKzEKSmoUktYCRaRWjaGpBcW56bnKBoV5xYm5xaV66XnJ+7iZGcNxpBe1g
	XLb+r94hRiYOxkOMEhzMSiK8JgtXpAvxpiRWVqUW5ccXleakFh9ilOZgURLnVc7pTBESSE8s
	Sc1OTS1ILYLJMnFwSjUwCVxPSuIK+PRS5tWGc3azwi5EXLm9bo3WvU9vrJZJ7lBp7M96aPhU
	PCwjfPWFKKPtOW1x95ssZOdInF4k6HSiOmcRp3iTe2TBmb+8bU8Mf4TEbY90ML6j/0N6mebn
	jp6jy0PX/pZ4L/JwunDkGYM1H54LCr5/IZHz4M3UyKQ3Nzpq8zQ9H8XVX1xl7zQtSVame33t
	ko5cntNW521fBqiwqJmyTDNWDniUuzHiXNfPLS5Z3N/nplkJP665/qXxjAFHn+W9GfcTZ/xX
	rztdNov38MsF+plmnv5nd3tvt7/4/KcO83WL9euXrHi4pr3O6spqlZTOhX92u2nv8F22SkRl
	y8TXjJdv+xU7LKydwJfnqMRSnJFoqMVcVJwIADs3GXIqAwAA
X-CMS-MailID: 20250211071946epcas5p3c2afde3813ab81142e81cff110ab7afa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250211071946epcas5p3c2afde3813ab81142e81cff110ab7afa
References: <20250211071922.2311873-1-junnan01.wu@samsung.com>
	<CGME20250211071946epcas5p3c2afde3813ab81142e81cff110ab7afa@epcas5p3.samsung.com>

Function virtio_vsock_vqs_del will be invoked in 2 cases
virtio_vsock_remove() and virtio_vsock_freeze().

And when driver freeze, the connected socket will be set to TCP_CLOSE
and it will cause that socket can not be unusable after resume.

Refactor function virtio_vsock_vqs_del to differentiate the 2 use cases.

Co-developed-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
---
 net/vmw_vsock/virtio_transport.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..909048c9069b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -716,14 +716,20 @@ static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 }
 
-static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
+static void virtio_vsock_vqs_del(struct virtio_vsock *vsock, bool vsock_reset)
 {
 	struct virtio_device *vdev = vsock->vdev;
 	struct sk_buff *skb;
 
-	/* Reset all connected sockets when the VQs disappear */
-	vsock_for_each_connected_socket(&virtio_transport.transport,
-					virtio_vsock_reset_sock);
+	/* When driver is removed, reset all connected
+	 * sockets because the VQs disappear.
+	 * When driver is just freezed, don't do that because the connected
+	 * socket still need to use after restore.
+	 */
+	if (vsock_reset) {
+		vsock_for_each_connected_socket(&virtio_transport.transport,
+						virtio_vsock_reset_sock);
+	}
 
 	/* Stop all work handlers to make sure no one is accessing the device,
 	 * so we can safely call virtio_reset_device().
@@ -831,7 +837,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	rcu_assign_pointer(the_virtio_vsock, NULL);
 	synchronize_rcu();
 
-	virtio_vsock_vqs_del(vsock);
+	virtio_vsock_vqs_del(vsock, true);
 
 	/* Other works can be queued before 'config->del_vqs()', so we flush
 	 * all works before to free the vsock object to avoid use after free.
@@ -856,7 +862,7 @@ static int virtio_vsock_freeze(struct virtio_device *vdev)
 	rcu_assign_pointer(the_virtio_vsock, NULL);
 	synchronize_rcu();
 
-	virtio_vsock_vqs_del(vsock);
+	virtio_vsock_vqs_del(vsock, false);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
-- 
2.34.1


