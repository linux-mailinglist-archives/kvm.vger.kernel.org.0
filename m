Return-Path: <kvm+bounces-37998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A6FA334A8
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 02:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 039D2188A203
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 01:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C851482F5;
	Thu, 13 Feb 2025 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uhhqpX35"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07797139566
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410057; cv=none; b=sbjKW6D2Rk13PefAIkIoQ9iVlAv4f7XmwULG6OMJqwNhwWnC/Y5Z/lc4dvZrD6Tmw4UTN6k1EcBHfNpxgDs8SoiXIaijrtXoA60fsEor8I2U4FWp8WewmQk65+rFUeHBdvQpcuS4cxhS051G7lxMnr5pADfin88doI/jae1hkE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410057; c=relaxed/simple;
	bh=K1KJcO/iMIszsejQubSSJo5rLiAltDSQBLIwlW4rkFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=syXb+dmEAzjo99LRBcz3dKKNgO0T+J0MHhM+YHqd9lJxIxe+0DlOa31xzlK4HHQCbNSZ3877gKJB36WkgasliZJinST+7Ol3p1buqzII+jx3MzzN4RnNmLXVSHweWub5f5ag6s2jDuAQiCyMqEkxx4I4NbBNwZ24hTXhBbiJ+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uhhqpX35; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250213012732epoutp0122bc918a34880861fbeab3792b1630f8~joDoAmfco0893408934epoutp018
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 01:27:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250213012732epoutp0122bc918a34880861fbeab3792b1630f8~joDoAmfco0893408934epoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739410052;
	bh=cUNcxOwztr93Bkz78+ZRLsndQixwVjIGrEz9jLDFpWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhhqpX35kp9D1ni5no1E5IccHc23T2G9lyDkd13WwedzYz2vi0b8e4mi6Lnw4NDHZ
	 sLPb0ZRzmLViLmp6nhMaD2gzJTXrY9PGP40QbkIY0sj0vU4txPjY767MljrQfxfTmL
	 QCRlPdTB8LmR0rYCtZw0DAn7kDqTJ8I5ue5p3f6A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250213012730epcas5p414b410c5ac1edad9af12bc84dfc954bf~joDm3sUjB1474714747epcas5p4v;
	Thu, 13 Feb 2025 01:27:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YtcxF4CRTz4x9Q7; Thu, 13 Feb
	2025 01:27:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	81.B6.19933.18A4DA76; Thu, 13 Feb 2025 10:27:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8~joDezkhkP2020120201epcas5p2f;
	Thu, 13 Feb 2025 01:27:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250213012722epsmtrp2151ed053faea735a7b8c7f91b215dcd6~joDesL5qW2391223912epsmtrp2B;
	Thu, 13 Feb 2025 01:27:22 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-79-67ad4a81014e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F8.A4.18729.97A4DA76; Thu, 13 Feb 2025 10:27:21 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250213012719epsmtip2284086063341bdcb19d2c59a50b4a97f~joDcabYEG2733127331epsmtip2e;
	Thu, 13 Feb 2025 01:27:19 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, junnan01.wu@samsung.com,
	kuba@kernel.org, kvm@vger.kernel.org, lei19.wang@samsung.com,
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
	pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: Re: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
Date: Thu, 13 Feb 2025 09:28:05 +0800
Message-Id: <20250213012805.2379064-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <gr5rqfwb4qgc23dadpfwe74jvsq37udpeqwhpokhnvvin6biv2@6v5npbxf6kbn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxze6e29LSw1d6BygA2hDhfZgFZKORUhczLp1JGaLSRzcV1TbgoB
	bksf2zAuwkQQFAcssBUYj4w5YKBYAXlKVh6DDQaTR1jASbEYAgpUJi4lGWt7cfO/7/f4ft/5
	fuccLuZhJXy4SbSe0tKKFD7hzm7t3f9acOaxRpVg5q4vKh/NYqOFgXkOuv9tHQfNfzlIoKt3
	1lno7lQsGmu9gqPy4jSU3TaOo/GOcgJN1FzmoC37Eo4GqnajjV8fAvT9oxEMjRSs4Wi0fAtD
	y0VbOOq/VYejqS8QGutzTO2ZN+Jv7pY21/3BklaZDFJTfS4hbbdIpIs3jUC6enuSkF5prgfS
	dZOfjHsq+VAipUigtP4UrVQnJNGqKP7x9+RH5OFigTBYKEERfH9akUpF8WNOyIKPJqU4rPH9
	P1GkGBwpmUKn44dGH9KqDXrKP1Gt00fxKU1CikakCdEpUnUGWhVCU/qDQoHgQLij8ePkxI3c
	ekIz7/VZUf8TkAH+8cwDblxIiuD9P2/iecCd60F2AmieWGYxwWMA/7rQBJhgA0BbexfxjGIu
	aSeYQjeA31Vf3OY/ANAyVY07uwhyPxzsqnUxdpJecKyixsXAyE4Mzt3IdRU8SQoWPVxwEdhk
	ILQNfe3CPDIajqzVchi5PbDnpxHMid3IOHjDuspmel6CQ0arC2OOnvMtZZhTAJJWLmzafOQ4
	ONcRxMCJmmBmjidc+rl5e6YPXF/p3raTDPP77dtYDy+t3MEZHAlHr+VgzjGYw8z1jlAm/Qos
	/uUai5HdAfM3rSwmz4NtFU7sVA2EqwVnmbQvrDOZtlWlDldDHGZX1QA+vprDKQD+pc+5KX3O
	Ten/ylUAqwfelEaXqqJ04ZoDNPXpf7esVKeagOu5Bx1rA5a5tRAzYHGBGUAuxt/JgyUNKg9e
	giL9DKVVy7WGFEpnBuGOdRdiPruUasd/ofVyoUgiEInFYpEkTCzke/HOt2epPEiVQk8lU5SG
	0j7jsbhuPhks73OnopbSwi0yzu3MkuGI2oAhQUnowtshL4zPzkj2Xbe7W09bsivfVzaerGxr
	3RFED0QX23Li5/TpEUGF8Q1xC0iJG5reZe/hrQ7abT8u9okjA//GYt0DRm99VHW2PS6jcNfe
	d6ZZNWEfflVRkTnt2wrpDnl89oUu4/Lvh2V9cz60stiu4X5zsU4oOry3rFveUFnWVpj0op0Q
	fJ5X5Pfq8NO3Zj1g5IPeN8K8+WemY0MpvOxgwLmWo4p8EhlmO23G07KV37IuvT67GbOVPpm9
	OGxuuRc/V2O53NFI4DPpkoHJey3L6OWTx/clt3bybD8cedLrW/007UTPB36y/qUmIZ+tS1QI
	gzCtTvEvluIvOHcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG6l19p0gytTrS3mnG9hsXh67BG7
	xeO5K9ktHvWfYLNYdukzk8Xda+4WF7b1sVrMmVpo0bbjMqvF5V1z2CyuLOlht/j/6xWrxbEF
	YhbfTr9htFj69iyzxdkJH1gtzs/5z2zxetJ/Vouj21eyWlxrsrC4cARo6v5HM1kdxDy2rLzJ
	5LFgU6nHplWdbB47H1p6vNg8k9Hj/b6rbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8a1z
	FVvBI/GKSUe/MjYw/hPuYuTkkBAwkTg0bSdbFyMXh5DAbkaJo68WMEEkpCW6frcxQ9jCEiv/
	PWeHKHrCKPFm4l92kASbgKbEiT0r2EBsEQFxiQvzloBNYha4zCxx7ucdsCJhgWSJw9d2gE1i
	EVCV+HhyOiuIzStgJ3H2wwp2iA3yEvsPngWr4RTwk9j45D0LiC0k4Cux9W4vO0S9oMTJmU/A
	4sxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4AjU
	0tzBuH3VB71DjEwcjIcYJTiYlUR4JaatSRfiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6iN0VI
	ID2xJDU7NbUgtQgmy8TBKdXANHH3p8SOik+a38N6D1w+9Gi6+BUj5ZgvKv2pL1b+jmI0/te5
	2/rDjHPv7pyLnbkjP/2xb6XUP2ZpG+v/Dvf623L+y9ls+7137T83rfyOzywmmtcZPXME2Ngd
	vnW6HTvpt+iqEMeUN3FKJjP3pKnP++p7/6yGXkl7mHFccNkauR1ufzVYmCZniX2Z850nLyN/
	h4CGvtQO2d/Mm714TXarLk73M10++73Xg6U/5nj+3GX6VFZJ63bV2ZZv3B0snO8mBp3Zd3zK
	XaPcTx8/zVhovbh9sn/ncp0JMulVVnJyivefPZ2ewPuN+4mZw5p5TElO3f36xat9uz+Lvnx+
	N/J5ksau6fELH5ZkPZpoJOPMq8RSnJFoqMVcVJwIAOvmwtgvAwAA
X-CMS-MailID: 20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8
References: <gr5rqfwb4qgc23dadpfwe74jvsq37udpeqwhpokhnvvin6biv2@6v5npbxf6kbn>
	<CGME20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8@epcas5p2.samsung.com>

>You need to update the title now that you're moving also queued_replies.
>

Well, I will update the title in V3 version.

>On Tue, Feb 11, 2025 at 03:19:21PM +0800, Junnan Wu wrote:
>>When executing suspend to ram twice in a row,
>>the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
>>Then after virtqueue_get_buf and `rx_buf_nr` decreased
>>in function virtio_transport_rx_work,
>>the condition to fill rx buffer
>>(rx_buf_nr < rx_buf_max_nr / 2) will never be met.
>>
>>It is because that `rx_buf_nr` and `rx_buf_max_nr`
>>are initialized only in virtio_vsock_probe(),
>>but they should be reset whenever virtqueues are recreated,
>>like after a suspend/resume.
>>
>>Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
>>virtio_vsock_vqs_init(), so we are sure that they are properly
>>initialized, every time we initialize the virtqueues, either when we
>>load the driver or after a suspend/resume.
>>At the same time, also move `queued_replies`.
>
>Why?
>
>As I mentioned the commit description should explain why the changes are 
>being made for both reviewers and future references to this patch.
>

After your kindly remind, I have double checked all locations where `queued_replies`
used, and we think for order to prevent erroneous atomic load operations 
on the `queued_replies` in the virtio_transport_send_pkt_work() function
which may disrupt the scheduling of vsock->rx_work
when transmitting reply-required socket packets,
this atomic variable must undergo synchronized initialization
alongside the preceding two variables after a suspend/resume.

If we reach agreement on it, I will add this description in V3 version.

BRs
Junnan Wu

>The rest LGTM.
>
>Stefano
>
>>
>>Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
>>Co-developed-by: Ying Gao <ying01.gao@samsung.com>
>>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>>---
>> net/vmw_vsock/virtio_transport.c | 10 +++++++---
>> 1 file changed, 7 insertions(+), 3 deletions(-)
>>
>>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>index b58c3818f284..f0e48e6911fc 100644
>>--- a/net/vmw_vsock/virtio_transport.c
>>+++ b/net/vmw_vsock/virtio_transport.c
>>@@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>> 	};
>> 	int ret;
>>
>>+	mutex_lock(&vsock->rx_lock);
>>+	vsock->rx_buf_nr = 0;
>>+	vsock->rx_buf_max_nr = 0;
>>+	mutex_unlock(&vsock->rx_lock);
>>+
>>+	atomic_set(&vsock->queued_replies, 0);
>>+
>> 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
>> 	if (ret < 0)
>> 		return ret;
>>@@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>
>> 	vsock->vdev = vdev;
>>
>>-	vsock->rx_buf_nr = 0;
>>-	vsock->rx_buf_max_nr = 0;
>>-	atomic_set(&vsock->queued_replies, 0);
>>
>> 	mutex_init(&vsock->tx_lock);
>> 	mutex_init(&vsock->rx_lock);
>>-- 
>>2.34.1
>>

