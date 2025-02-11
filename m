Return-Path: <kvm+bounces-37816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78784A30463
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39B901889514
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025A21EE7C6;
	Tue, 11 Feb 2025 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="utN2ObWg"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88B71EDA04
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739258611; cv=none; b=EGyMQQRTpRJ1Uiq0jpGQIykkzRYQ2YDQ1K2yrqA6LosU+N0j+pQRIZjQsTemWXXOjkl0THKwK1reFz1HFnJWCyoIT/INiO7mPtspla3elwGyf3LOHHgXdW6uLj7e3XMUj3niSFxNVaPUPFAH843JDHq15L31NS/uAPR3CqsHjq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739258611; c=relaxed/simple;
	bh=92f3+0RBOUMWYn5GM2mPefl+n3IpS+jV8ykj5futLfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WfMY4KRrprhc3+vZ7x6QOFmALALBi46GkiX7eIMMVUb+iudf8LcuAOKDTa77T9/RGqSoKclya7cs3t4Fw+skILo/dxQzEA7rYj9e8DCebCC/ABiZmNqHXI1nq3EyT3yEBNJmw1XxvO6xQ00szdUT4uCmPK9IJH3qFDA9tG3q0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=utN2ObWg; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250211072321epoutp02a0ea25ba6873aebba7f8c269472eaae2~jFnuOUXRx1780217802epoutp02e
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250211072321epoutp02a0ea25ba6873aebba7f8c269472eaae2~jFnuOUXRx1780217802epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739258601;
	bh=cqWyoyjcojczVymuxqFKCi8tbnQu4vhX9fzr84A8Q98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utN2ObWgVgdp9qtI9MNhpO+81PNVt/if4nWYq3Ukz60xMNHSwdYRsY5dcvMycXk2O
	 iRjSD2Ql/jmmtqeWnJgN7QjiougfGdmTtfjLFx/3ktA44FKUU2If9dciJmyuxmtten
	 UKfAIf1a0KBRR7LvyL+4TkWtv7LXfEYgA1rLridY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250211072320epcas5p1db2e22adb0ac79aaf423a1aad1a69edc~jFntu0T_y0209902099epcas5p1s;
	Tue, 11 Feb 2025 07:23:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4YsXwk1x2hz4x9Q9; Tue, 11 Feb
	2025 07:23:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.D9.20052.6EAFAA76; Tue, 11 Feb 2025 16:23:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250211071941epcas5p308a13898102cf851bc9988c0e2766c5e~jFkiB3tyK2383023830epcas5p3_;
	Tue, 11 Feb 2025 07:19:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250211071941epsmtrp23491956d55b1bb2cbddf4dccbbd7c004~jFkiAxTf20103201032epsmtrp2_;
	Tue, 11 Feb 2025 07:19:41 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-54-67aafae64171
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	56.DE.18729.D0AFAA76; Tue, 11 Feb 2025 16:19:41 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250211071938epsmtip1d1635c3ad7f2a04d629821b117d3b7a4~jFke9gp1p1180211802epsmtip1Q;
	Tue, 11 Feb 2025 07:19:38 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
	jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, q1.huang@samsung.com, ying01.gao@samsung.com,
	ying123.xu@samsung.com, lei19.wang@samsung.com, Junnan Wu
	<junnan01.wu@samsung.com>
Subject: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
Date: Tue, 11 Feb 2025 15:19:21 +0800
Message-Id: <20250211071922.2311873-2-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250211071922.2311873-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmhu6zX6vSDab1cFjMOd/CYvH02CN2
	i8dzV7JbPOo/wWax7NJnJou719wtLmzrY7WYM7XQom3HZVaLy7vmsFlcWdLDbvH/1ytWi2ML
	xCy+nX7DaLH07Vlmi7MTPrBanJ/zn9ni9aT/rBZHt69ktbjWZGFx4QjQ1P2PZrI6iHlsWXmT
	yWPBplKPTas62Tx2PrT0eLF5JqPH+31X2Tz6tqxi9Pi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoNSWFssScUqBQQGJxsZK+nU1RfmlJ
	qkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsb/9uOsBUf5K+bd2MfcwDiB
	t4uRk0NCwETiyI03jF2MXBxCArsZJWZ032GGcD4xStyasooJwvkG5HR+ZYdpmdzfBGYLCexl
	lLhxKg6i6BmjxNO3D5lAEmwCmhIn9qxgA0mICCxmlDi/4isriMMssJtJYuGtz4wgVcICsRLn
	vq8Hs1kEVCVO3F7PCmLzCthJPDz9ixVinbzE/oNnmUFsTgF7iSsztrFD1AhKnJz5hAXEZgaq
	ad46G+xwCYEHHBLLF26DutVFYuHxO1CDhCVeHd8CFZeS+PxuLxuEnS3Re/QXlF0i0f3uElS9
	tcT5de1AQzmAFmhKrN+lDxGWlZh6ah0TxF4+id7fT5gg4rwSO+aB2BxAtqrE+wk1EGFpiZWb
	NrFDhD0kZky0gwTWJEaJt0vfME5gVJiF5JtZSL6ZhbB4ASPzKkbJ1ILi3PTUYtMCw7zUcngs
	J+fnbmIEJ3ctzx2Mdx980DvEyMTBeIhRgoNZSYTXZOGKdCHelMTKqtSi/Pii0pzU4kOMpsDg
	nsgsJZqcD8wveSXxhiaWBiZmZmYmlsZmhkrivM07W9KFBNITS1KzU1MLUotg+pg4OKUamNTq
	n1kcV53oVtUYvmBrdEZu+/TJuvnOKy77TqvpNeZNzYzVnx9xxdyITeqnlY+DyZ/JsupcP3tC
	tc5NOGpVHl6dPk/wqm9tydsd4r8XycRs4NrCtvn6oun7/1bv/qa+re14p9fK/9Hij5h1svps
	zPtqA7516t7ezeqVtsJZWSFNymll6sfn08492TRHR8HZe8bJJUwyvIeD91htmmUVsmF64LW7
	03dqbJC7Ps/jcSBnf09/glfyzr+n6qqYVgn76/hzlUTbSZZv+ZRfOIc5YEb+moh5hXPaz/xe
	fPvv8m6uxcubNii7yTlLeTIsXnLmlpTzNwO2yG52gXaB6x2pktPffVsluWfZU4UOlT9/lFiK
	MxINtZiLihMB/yiRoHcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSnC7vr1XpBjc+qlvMOd/CYvH02CN2
	i8dzV7JbPOo/wWax7NJnJou719wtLmzrY7WYM7XQom3HZVaLy7vmsFlcWdLDbvH/1ytWi2ML
	xCy+nX7DaLH07Vlmi7MTPrBanJ/zn9ni9aT/rBZHt69ktbjWZGFx4QjQ1P2PZrI6iHlsWXmT
	yWPBplKPTas62Tx2PrT0eLF5JqPH+31X2Tz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr43/7
	cdaCo/wV827sY25gnMDbxcjJISFgIjG5v4m9i5GLQ0hgN6PEmzkPWCAS0hJdv9uYIWxhiZX/
	nkMVPWGUmLh2BStIgk1AU+LEnhVsILaIwFpGiU37DEGKmAVOMkncmjEBrFtYIFri7fMzYDaL
	gKrEidvrwZp5BewkHp7+xQqxQV5i/8GzYDWcAvYSV2ZsYwexhYBqds1fxgJRLyhxcuYTMJsZ
	qL5562zmCYwCs5CkZiFJLWBkWsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyBWpo7
	GLev+qB3iJGJg/EQowQHs5IIr8nCFelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQn
	lqRmp6YWpBbBZJk4OKUamNKO3NyV1Xy1MSHwdU6w8UqFnTeP9vgc0F272zasU/SF5tnazw8X
	7P1xQfHUm63GIXPudHYuPnh61j4juXk1rGLvv+cFzNXJj9E7O3PdxHtT79joGiVH7eL0OTv9
	bej3Lx/+Ljz/Oe8g6w6f/3e9CwueR1c23rrxrDpgdtlTPZFQvXcykw6pLrWK+fNg8f+vlr7B
	d9iZztS2Ln4qIXhc6Y5e4/qo1X2zhJqTN11I2v56RWhcuHJurwdLT2ep1YakLK6w7bFC5RK3
	hSPc/h1Uayqom1zwwjkzQ+PqxsqXR+saI7gDE84z/67QWpRZ3BfmNOt8/q1ijoD5u2sE1Y3O
	tPtM1c5JEDvgv+TrGsG4OiWW4oxEQy3mouJEAJdyMKMvAwAA
X-CMS-MailID: 20250211071941epcas5p308a13898102cf851bc9988c0e2766c5e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250211071941epcas5p308a13898102cf851bc9988c0e2766c5e
References: <20250211071922.2311873-1-junnan01.wu@samsung.com>
	<CGME20250211071941epcas5p308a13898102cf851bc9988c0e2766c5e@epcas5p3.samsung.com>

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
At the same time, also move `queued_replies`.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
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


