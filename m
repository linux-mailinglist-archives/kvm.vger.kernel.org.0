Return-Path: <kvm+bounces-38109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60234A353A4
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 02:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 210893AC27B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F338F81727;
	Fri, 14 Feb 2025 01:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cbcAWgTl"
X-Original-To: kvm@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B582AF14
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 01:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739496162; cv=none; b=KgNREFOqBJjNy7wcaS21DppSdn2IEFBQpNVBELfzDHgkUQPA53/h5GywRaHo7DO22W7VTY/t2r2VGDRi/6QaNTKOxu1oFH6bFkgAsydGjlTqxNSr05l9QFKR6pmwBHWDyhfghZa9JeGWSTQQmzWPjGzXcCpW2sG0ehXIQkewOWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739496162; c=relaxed/simple;
	bh=IFVi1KzRLJQIhOXSQygfQ9egjuXlYGDLjPg29AdBZZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=X94WIVJ5hojpBtJbs+xFp8Nc6UZG47EclHOAHgRqQFov3HGMDKFK+6xpU3gfCKKxBKPKCFFgGb8Ulief9EfxCybSxpoBWKqc2Ya4kOuurO+cuXvKcmoayv6jvQ8x29hxrqywOCK9Qbwf69Q6Ybf5Wcd0eWS+VMUnaP5BbDj5e4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cbcAWgTl; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250214012237epoutp03c056900d2664898d1e243d723bf4d81f~j7onlZV6R0170101701epoutp03g
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 01:22:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250214012237epoutp03c056900d2664898d1e243d723bf4d81f~j7onlZV6R0170101701epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739496157;
	bh=vWW0cMrxiqFDMldSnf+yvYR4SjlKf7GeaVFbQk4Idww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbcAWgTlETlBzsl3TbMtQ2kLtbmoCFPXWZO8rRd3Mu74agy0cne2RUbE+VcCIro0F
	 /F287O11PfM1qWb2IbzAqkOrhGol8egl7l9eAKVLAhCnrGhs1nvcGGWocqcfhuNHG/
	 OIWSZk09vj0zu75ezNYfCZCgKY7vBtnZSHZPyQTg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250214012236epcas5p4fa21829d79194337f9979f2be5bdbf5e~j7om5ZjXq2587725877epcas5p4D;
	Fri, 14 Feb 2025 01:22:36 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YvDn60BTvz4x9Q7; Fri, 14 Feb
	2025 01:22:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.78.19956.9DA9EA76; Fri, 14 Feb 2025 10:22:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250214012219epcas5p2840feb4b4539929f37c171375e2f646b~j7oXE6qXm1410614106epcas5p2b;
	Fri, 14 Feb 2025 01:22:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250214012219epsmtrp18a9d38e9ea58dc827f9e3417383d6e5c~j7oXDyhMG0520605206epsmtrp1G;
	Fri, 14 Feb 2025 01:22:19 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-b3-67ae9ad9c3ff
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B9.FB.18729.BCA9EA76; Fri, 14 Feb 2025 10:22:19 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250214012217epsmtip1797d1fadbd3da2065d6d311b324c9e55~j7oU6oa-b1757717577epsmtip1k;
	Fri, 14 Feb 2025 01:22:16 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, junnan01.wu@samsung.com,
	kuba@kernel.org, kvm@vger.kernel.org, lei19.wang@samsung.com,
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
	pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: [Patch net v3] vsock/virtio: fix variables initialization during
 resuming
Date: Fri, 14 Feb 2025 09:22:00 +0800
Message-Id: <20250214012200.1883896-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmlu7NWevSDdpuWFrMOd/CYvH02CN2
	i8dzV7JbPOo/wWax7NJnJou719wtLmzrY7WYM7XQom3HZVaLy7vmsFlcWdLDbvH/1ytWi2ML
	xCy+nX7DaLH07Vlmi7MTPrBanJ/zn9ni9aT/rBZHt69ktbjWZGFx4QjQ1P2PZrI6iHlsWXmT
	yWPBplKPTas62Tx2PrT0eLF5JqPH+31X2Tz6tqxi9Pi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoNSWFssScUqBQQGJxsZK+nU1RfmlJ
	qkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsasM1IFl4Uqzs6aztTA+Jm/
	i5GTQ0LAROLP//dMXYxcHEICuxklXu1pZ4RwPjFKnOi8xQ5SJSTwjVHiw+VimI7V35dDFe1l
	lHi8+hUbhPOMUWLZwZMsIFVsApoSJ/asYAOxRQTEJS7MWwJWxCywm1niwcZOsISwQIjE4kdn
	mUBsFgFViTs7VgKN5eDgFbCTmPg3D2KbvMT+g2eZQWxOgUCJC+t/gV3EKyAocXLmE7BdzEA1
	zVtnM4PMlxB4wiFx6e0GNohmF4k3+++wQtjCEq+Ob2GHsKUkXva3QdnZEr1Hf0HVl0h0v7sE
	VW8tcX5dOzPIPcxAz6zfpQ8RlpWYemodE8RePone30+YIOK8EjvmgdgcQLaqxPsJNRBhaYmV
	mzZBbfKQeHDyCyskrJYwSkyb85ZtAqPCLCTvzELyziyEzQsYmVcxSqYWFOempxabFhjnpZbD
	4zg5P3cTIzixa3nvYHz04IPeIUYmDsZDjBIczEoivBLT1qQL8aYkVlalFuXHF5XmpBYfYjQF
	BvdEZinR5HxgbskriTc0sTQwMTMzM7E0NjNUEudt3tmSLiSQnliSmp2aWpBaBNPHxMEp1cBU
	xNpYPEEriO11N/+mDUnhR6+f0ah8fqLL3Lzl6/qZv5VMoo7vfeUZL2staPlvl/Fy51kmmjc/
	ZNxOOCCoUdZ19rtgU3waU4t1ZtY8xd0Lq+5G77Gd/K9gukKTa9RlpXArTf7MD0a5DSnR2zy8
	Ivp1yyfelfuX1aDq9LVI92bpPSbbR6lfirfxdDxb/HvT233XmubkcBumx6hdWnpcyY2/vllb
	0OFs++8GjuXMvIu3Cd/YtkP4w71vJ7l7r4ntVE58z2x8gXty/Iqikrnayw2bptqU/FPkLsj5
	Lazus/2hrn6hYnp1IEde1MYOfemJDO8fvPq96uDd49OC9L46urQ+k5M3qtL4oiB04eN8fiWW
	4oxEQy3mouJEAADRax11BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSnO7pWevSDZ5t5beYc76FxeLpsUfs
	Fo/nrmS3eNR/gs1i2aXPTBZ3r7lbXNjWx2oxZ2qhRduOy6wWl3fNYbO4sqSH3eL/r1esFscW
	iFl8O/2G0WLp27PMFmcnfGC1OD/nP7PF60n/WS2Obl/JanGtycLiwhGgqfsfzWR1EPPYsvIm
	k8eCTaUem1Z1snnsfGjp8WLzTEaP9/uusnn0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxqwz
	UgWXhSrOzprO1MD4mb+LkZNDQsBEYvX35YwgtpDAbkaJh0etIeLSEl2/25ghbGGJlf+es3cx
	cgHVPGGUmDlxBjtIgk1AU+LEnhVsILaIgLjEhXlL2ECKmAUuM0uc+3kHrEhYIEii9cISsA0s
	AqoSd3asBLI5OHgF7CQm/s2DWCAvsf/gWbBlnAKBEhfW/2KHOChA4sDkZrD5vAKCEidnPmEB
	sZmB6pu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwbGn
	pbmDcfuqD3qHGJk4GA8xSnAwK4nwSkxbky7Em5JYWZValB9fVJqTWnyIUZqDRUmcV/xFb4qQ
	QHpiSWp2ampBahFMlomDU6qBKez5xE8SLhdCN7IuatA4Oukhv+rupNOLd3zmaGieJ33BlSdn
	psWEFy+D9SX4t+v9ioq5tP3f45bA1xzpn2PigrN09u2NqA6bXLgtzVl28cF5u2a9L/Y9/e2w
	+ZSsq59Lq/Yb5L7caXtI6d4n7u1sj34XW00zv7s/avGDjNqvSUlO6icMulVswzP9Szsn2/I4
	LlbUn27t08t1v+HGji0qtorMpyf3S1dlfeDmn3n3y+/9LhVB1tLrus9eORWt+tnnRrS1sy3j
	Fb0LQR8lD69bIXru7IydnD09a3w5jH/cPHdInrH0y8lFK+x4irn2bLkm9vj13gbeC5n3k/Y5
	LZXw2Bg0tb6zYI5Uptj3ae1u+UosxRmJhlrMRcWJAAat4qYsAwAA
X-CMS-MailID: 20250214012219epcas5p2840feb4b4539929f37c171375e2f646b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250214012219epcas5p2840feb4b4539929f37c171375e2f646b
References: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
	<CGME20250214012219epcas5p2840feb4b4539929f37c171375e2f646b@epcas5p2.samsung.com>

When executing suspend to ram twice in a row,
the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
Then after virtqueue_get_buf and `rx_buf_nr` decreased
in function virtio_transport_rx_work,
the condition to fill rx buffer
(rx_buf_nr < rx_buf_max_nr / 2) will never be met.

It is because that `rx_buf_nr` and `rx_buf_max_nr`
are initialized only in virtio_vsock_probe(),
but they should be reset whenever virtqueues are recreated,
like after a suspend/resume.

Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
virtio_vsock_vqs_init(), so we are sure that they are properly
initialized, every time we initialize the virtqueues, either when we
load the driver or after a suspend/resume.

To prevent erroneous atomic load operations on the `queued_replies`
in the virtio_transport_send_pkt_work() function
which may disrupt the scheduling of vsock->rx_work
when transmitting reply-required socket packets,
this atomic variable must undergo synchronized initialization
alongside the preceding two variables after a suspend/resume.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
Link: https://lore.kernel.org/virtualization/20250207052033.2222629-1-junnan01.wu@samsung.com/
Co-developed-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
---
 net/vmw_vsock/virtio_transport.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index b58c3818f284..f0e48e6911fc 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	};
 	int ret;
 
+	mutex_lock(&vsock->rx_lock);
+	vsock->rx_buf_nr = 0;
+	vsock->rx_buf_max_nr = 0;
+	mutex_unlock(&vsock->rx_lock);
+
+	atomic_set(&vsock->queued_replies, 0);
+
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
 	if (ret < 0)
 		return ret;
@@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->vdev = vdev;
 
-	vsock->rx_buf_nr = 0;
-	vsock->rx_buf_max_nr = 0;
-	atomic_set(&vsock->queued_replies, 0);
 
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
-- 
2.34.1


