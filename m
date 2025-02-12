Return-Path: <kvm+bounces-37997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C1BA3344A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 01:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05E2A167E0E
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 00:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8C578F49;
	Thu, 13 Feb 2025 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Uvxanwg7"
X-Original-To: kvm@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D55269D2B
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739408069; cv=none; b=as0Zc0e3OpTX3HL6qLjCp0rO2p+DCjkDsFIe9e6CieIcyicGsdohvPh6q4Szm0534zKBoFcYJzFRHrHZqM0SxQCbTPcZQacKUn3VYMfYcVxVchJ16KJk6j9YFlZ4325c4XFRI37CdllQhkAvSh7HHRVGNbopR4aW0pO/2In4gow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739408069; c=relaxed/simple;
	bh=kgUFriaHckAX/UICIIOkdTeA5rYC2/8rEcYmDesObJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qGsVrvgLi2BnotmsnndiFXGZsU4bLsoWUSBybx0bv/RVTjIZk8WtXStQsobnzxwCMIbDb8XwWfrdipgsqnhZ2a9wFezdryz/BC/9UYChqjTMJPd97dl+yNSijLQcIDxUAz4rngleFqy3VRGo32CDtDfZ/7FYgJ4ehCJVdyzgxWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Uvxanwg7; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250213005425epoutp03e49b707820f1f0829b07f74841d4feac~jnmtsqJso1914419144epoutp03F
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:54:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250213005425epoutp03e49b707820f1f0829b07f74841d4feac~jnmtsqJso1914419144epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739408065;
	bh=Udyyr3+c9lIf9GcZ3IJILI+Ye26O93De7LR99Gj/9uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uvxanwg7NRlXF3/LAqEPBmNQxfQKwWQTNuq3QQg+rrtyjYCFLgw3z6p5v9iY/je0g
	 T+nNlhqiFysq5JLSebtUWq59BzafjePjr6PJ6tQUIdT4ajL7zx0LWwON741h7k8H/l
	 6dKx77lOfcq33nbwfG3hL6k+n6qrrduMRhrFPbiU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250213005424epcas5p4f032cb96bade799d688f14d852cd760a~jnms77Sy70467304673epcas5p4q;
	Thu, 13 Feb 2025 00:54:24 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YtcC30nT0z4x9Q0; Thu, 13 Feb
	2025 00:54:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CC.65.19710.EB24DA76; Thu, 13 Feb 2025 09:54:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250212044758epcas5p244c3add904f0ee06f669cd4c53a9e594~jXJWfa6WE0590205902epcas5p2Y;
	Wed, 12 Feb 2025 04:47:58 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250212044758epsmtrp2eb9ed694647f7cc135ec78bea36e710b~jXJWeRLdi1049510495epsmtrp2D;
	Wed, 12 Feb 2025 04:47:58 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-12-67ad42be62a3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.8B.18949.EF72CA76; Wed, 12 Feb 2025 13:47:58 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250212044756epsmtip25c699e119d66b569633d23b44a6db2b9~jXJUAOdwh2400724007epsmtip2d;
	Wed, 12 Feb 2025 04:47:55 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, junnan01.wu@samsung.com,
	kuba@kernel.org, kvm@vger.kernel.org, lei19.wang@samsung.com,
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
	pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: RE: Re: [PATCH 2/2] vsock/virtio: Don't reset the created SOCKET
 during s2r
Date: Wed, 12 Feb 2025 12:48:43 +0800
Message-Id: <20250212044843.254862-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <iv6oalr6yuwsfkoxnorp4t77fdjheteyojauwf2phshucdxatf@ominy3hfcpxb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxbVRjGc3p7LxeS4h0gnGHYmm6okACto+zggOAks9kIIX4whkGs9K4l
	hbb2Y26oWRnNkM+xZSWCyNCB0u7D0XUbhSGCljFIpRtjjCWgIF0ICt3EMC0KttxO99/vfc/z
	vk+ec+4lsRAXEUkWKbS0WiEu5hFB7Kvfx7wY17f7gpRf9gkLNY8a2Mg1OBuAfvncFIBmTwwR
	6Kvbyyw0dfc15Lxah6Nm4/voeNcYjsa6mwl0p60mAK17FnA02BqOVkZ+A6h90YEhR/1DHI02
	r2Po11PrOLJfM+Ho7jGEnD94t/bNNuLp4SKraZIlarXoRBZzJSGyzSSL5i83ApH723FCVGc1
	A9GyZUs2mSdPkdFiCa3m0opCpaRIIU3l7Xuj4NUCYRJfECdIRjt5XIW4hE7lZWRmx+0pKvZG
	43EPiYt13la2WKPhJaSlqJU6Lc2VKTXaVB6tkhSrElXxGnGJRqeQxito7csCPv8loVf4rly2
	draPUJ2KO3zruB7XA8v2KhBIQioRNtqmsSoQRIZQPQCev1GDM8XvAK48NAOmWAGwfs2FPxkp
	tzv8B70ATrhbWUzxAMDZOWuAT0VQMXDoegfh4zAqAjpb2gifCKN6MPhzZ+XGQSiVAydOTm6s
	ZVPR8NJCNeZjDpUK9cfOAcZuK+zrd2z0A6ks+M/9Lhaj2QRvNs6xfYx5NeVXPttIAal5EjrO
	tbOY4QxYZpgKYDgULtyw+jkSLi/1EgzLYa3d42ctrF667c+5C45erPAuJb0GMfCb7gSmHQWN
	wxdZjG8wrF2d81txYFeLj0kvR0N3/UdM+zloslj8riL4o76ZYC7rCwDvD7bj9YDb9FScpqfi
	NP3v3AowM9hMqzQlUrpQqBIo6A/+e+ZCZYkFbHzvsRld4N6ZtfgBwCLBAIAkxgvjwIbz0hCO
	RHyklFYrC9S6YlozAITe+z6JRT5bqPT+MAptgSAxmZ+YlJSUmLwjScCL4JTbDNIQSirW0nKa
	VtHqJ3MsMjBSz2oav1yXy27xDN88ayoKx8d60r90cBI+NQ1o8lDQ4pnqnFtlpy2bdY3vDVfF
	2F43NTRMjw3Nr/65C7e5RLbdWSORVvnWtbaftn0YU7ov2iqrlLf0O9dnOkdd3/W0ddSmGRzP
	bDmYxXdL00wTb01nXsmX/LXjQQ7nRM3H1W+rBW+mXR+hJ2fyQ43JgS/slMxGVBy2h6s7Fkzu
	o+/kdQvMj6XWImOULGw/hAdjdXLD0rb9XwdfKxUULkeluKZ6azcden5xadWdf+9vZ+c4WMg8
	uufIKyvcx3srh7T2itwWt+5S997gvkcXPAeEi8P9EfSjO1V/6D0HjOVT6fr+uIztuflZPLZG
	JhbEYmqN+F9x3znjeAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvO4/9TXpBru7NC3mnG9hsXh67BG7
	xeO5K9ktHvWfYLNYdukzk8Xda+4WF7b1sVrMmVpo0bbjMqvF5V1z2CyuLOlht/j/6xWrxbEF
	YhbfTr9htFj69iyzxdkJH1gtzs/5z2zxetJ/Vouj21eyWlxrsrC4cARo6v5HM1kdxDy2rLzJ
	5LFgU6nHplWdbB47H1p6vNg8k9Hj/b6rbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8W/x
	fraCSboVF9saWBsYN6l0MXJySAiYSDQfPcvYxcjFISSwm1FiyvMjTBAJaYmu323MELawxMp/
	z9lBbCGBJ4wS+14ogNhsApoSJ/asYAOxRQTEJS7MW8IGMohZ4DKzxLmfd8AahAVCJHr/bgcr
	YhFQldjwqhtsKK+ArURD02pGiAXyEvsPngWLcwr4Sfy9tYMJYpmvRM+X44wQ9YISJ2c+YQGx
	mYHqm7fOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB8ael
	tYNxz6oPeocYmTgYDzFKcDArifCaLFyRLsSbklhZlVqUH19UmpNafIhRmoNFSZz32+veFCGB
	9MSS1OzU1ILUIpgsEwenVAPTgdJjFd9fnzm4O2u2m23JhV+1VonaklfOHX/7hvNuVMmE3+b1
	3FYsPwO6wk2nd75c3lRin8MT+lnd6THH/9jDCsovds+es1plf1Nt5DRVtzMeF9a+Dr3RaLwm
	0d32lHRj5N2N35v8+bz8trOc2OR94FF1VtP9BXKep184XXs07bPI8ZPvLis87snf/Phi/e3k
	2TPrnJev3PJM2njNeoe+5svnrugv4thoL7r/x5SPt24J2DaIL3m7t2q5mZJhjaT1v/zt3f0J
	W0TfXk+9HPXwSW334pkmsUIHDb7KuJXvMzfYMiVB6fC97F/m2xPXq254qXtP/ci9eu1Zi+c9
	3568Yu6rayeTnXM4k85NE0m/+UCJpTgj0VCLuag4EQALXMThLgMAAA==
X-CMS-MailID: 20250212044758epcas5p244c3add904f0ee06f669cd4c53a9e594
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250212044758epcas5p244c3add904f0ee06f669cd4c53a9e594
References: <iv6oalr6yuwsfkoxnorp4t77fdjheteyojauwf2phshucdxatf@ominy3hfcpxb>
	<CGME20250212044758epcas5p244c3add904f0ee06f669cd4c53a9e594@epcas5p2.samsung.com>

>On Mon, Feb 10, 2025 at 12:48:03PM +0100, leonardi@redhat.com wrote:
>>Like for the other patch, some maintainers have not been CCd.
>
>Yes, please use `scripts/get_maintainer.pl`.
>

Ok, I will add other maintainers by this script in next push.
 
>>
>>On Fri, Feb 07, 2025 at 01:20:33PM +0800, Junnan Wu wrote:
>>>From: Ying Gao <ying01.gao@samsung.com>
>>>
>>>If suspend is executed during vsock communication and the
>>>socket is reset, the original socket will be unusable after resume.
>
>Why? (I mean for a good commit description)
>
>>>
>>>Judge the value of vdev->priv in function virtio_vsock_vqs_del,
>>>only when the function is invoked by virtio_vsock_remove,
>>>all vsock connections will be reset.
>>>
>>The second part of the commit message is not that clear, do you mind 
>>rephrasing it?
>
>+1 on that
>

Well, I will rephrase it in next version.

>Also in this case, why checking `vdev->priv` fixes the issue?
>
>>
>>>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>>Missing Co-developed-by?
>>>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>>
>>
>>>---
>>>net/vmw_vsock/virtio_transport.c | 6 ++++--
>>>1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>index 9eefd0fba92b..9df609581755 100644
>>>--- a/net/vmw_vsock/virtio_transport.c
>>>+++ b/net/vmw_vsock/virtio_transport.c
>>>@@ -717,8 +717,10 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>>	struct sk_buff *skb;
>>>
>>>	/* Reset all connected sockets when the VQs disappear */
>>>-	vsock_for_each_connected_socket(&virtio_transport.transport,
>>>-					virtio_vsock_reset_sock);
>>I would add a comment explaining why you are adding this check.
>
>Yes, please.
>

Ok, I left a comment here in next version

>>>+	if (!vdev->priv) {
>>>+		vsock_for_each_connected_socket(&virtio_transport.transport,
>>>+						virtio_vsock_reset_sock);
>>>+	}
>
>Okay, after looking at the code I understood why, but please write it 
>into the commit next time!
>
>virtio_vsock_vqs_del() is called in 2 cases:
>1 - in virtio_vsock_remove() after setting `vdev->priv` to null since
>     the drive is about to be unloaded because the device is for example
>     removed (hot-unplug)
>
>2 - in virtio_vsock_freeze() when suspending, but in this case
>     `vdev->priv` is not touched.
>
>I don't think is a good idea using that because in the future it could 
>change. So better to add a parameter to virtio_vsock_vqs_del() to 
>differentiate the 2 use cases.
>
>
>That said, I think this patch is wrong:
>
>We are deallocating virtqueues, so all packets that are "in flight" will 
>be completely discarded. Our transport (virtqueues) has no mechanism to 
>retransmit them, so those packets would be lost forever. So we cannot 
>guarantee the reliability of SOCK_STREAM sockets for example.
>
>In any case, after a suspension, many connections will be expired in the 
>host anyway, so does it make sense to keep them open in the guest?
>

If host still holds vsock connection during suspend,
I think guest should keep them open at this case.

Because we find a scenario that when we do freeze at the time that vsock
connection is communicating, and after restore, upper application
is trying to continue sending msg via vsock, then error `ENOTCONN`
returned in function `vsock_connectible_sendmsg`. But host does not realize
this thing and still waiting to receive msg with old connect.
If host doesn't close old connection, it will cause that guest
can never connect to host via vsock because of error `EPIPE` returned.

If we freeze vsock after sending and receiving data operation completed,
this error will not happen, and guest can still connect to host after resume.

For example:
In suitaion 1), if we do following steps
    step 1) Host start a vsock server
    step 2) Guest start a vsock client which will no-limited sending data
    step 3) Guest freeze and resume
Then vsock connection will be broken and guest can never connect to host via
vsock untill Host reset vsock server.

And in suitaion 2), if we do following steps
    step1) Host start a vsock server
    step2) Guest start a vsock client and send some data
    step3) After client completed transmit, Guest freeze and resume
    step4) Guest start a new vsock client and send some data
In this suitaion, host server don't need to reset, and guest client works well
after resume.

>If you want to support this use case, you must first provide a way to 
>keep those packets somewhere (e.g. avoiding to remove the virtqueues?), 
>but I honestly don't understand the use case.
>

In cases guest sending no-reply-required packet via vsock,
when guest suspend, the sending action will also suspend
and no packets will loss after resume.

And when host is sending packet via vsock when guest suspend and Vq disapper,
like you mentioned, those packets will loss.
But I think those packets should be keep in host device side,
and promise that once guest resume,
get them in host device and continue sending.

Thanks,
Junnan Wu

>To be clear, this behavior is intended, and it's for example the same as 
>when suspending the VM is the hypervisor directly, which after that, it 
>sends an event to the guest, just to close all connections because it's 
>complicated to keep them active.
>
>Thanks,
>Stefano
>
>
>
>>>
>>>	/* Stop all work handlers to make sure no one is accessing the device,
>>>	 * so we can safely call virtio_reset_device().
>>>-- 
>>>2.34.1
>>>
>>
>>I am not familiar with freeze/resume, but I don't see any problems 
>>with this patch.
>>
>>Thank you,
>>Luigi
>>

