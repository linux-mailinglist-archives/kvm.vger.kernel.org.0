Return-Path: <kvm+bounces-37559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50095A2BABD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 06:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7426C7A3A5A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 05:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117232343AA;
	Fri,  7 Feb 2025 05:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fuVgtOlY"
X-Original-To: kvm@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7E1233148
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 05:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738906785; cv=none; b=jci1gTzhqcrDmOMDbGJu0aiAc2P3P4L85ezLfcvx4YYodKcfcV124nvoNGlBwWN2m99mTtiFg77INrtlxmpD9VV2U/hN1IKK5EyA9rutOc39unZRkXAcx6pXYVx3VX76GC+sXDk9stQwhKKypy4EjDqSUxXm4apoj659ev/2sU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738906785; c=relaxed/simple;
	bh=cjRMI8k1TjxxbHaDRJMMOtxO9Rs62DlBNPtQVuJPDWY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=O8fBu6H4dL9sX+WzG2Lbu5/a5YK7ilIxgt94UGIRBpmR9eEfblouRxBNu8h29pYm1F8dW8IAxoIBCbp9nJ+/kOu9xOJXXY/GZbY2ar8Dzejw90AehP/E8AADww47bFgwhZDJ0vZOr4r6xr/Uq127vKTIrNcuhDDc9/T15S84bk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fuVgtOlY; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250207053933epoutp04c73d122bff433171cfdb246d902d9503~h1n9o2rVx1565915659epoutp04g
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 05:39:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250207053933epoutp04c73d122bff433171cfdb246d902d9503~h1n9o2rVx1565915659epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1738906773;
	bh=bETukrRy+BaCVaBPdi6kwcNgl47fiTggLPIFFE4Rw6A=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fuVgtOlYp1WRbmIHpN8lxN8CH8cMETc4yxIzjrcR3GpsgK562XlRs2LsqtvzO2Onp
	 LB8pwO9XUZoF1J6xlbmDhMO4zUMsyokOI3JHkejyQ18bBqFd2WI/3jn7cH+uK+YqEh
	 +rlDhoVChey2BJnRAS0GMCrQLgsK3gZfkgRcOA/4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250207053933epcas5p4fca5154a4c70fe03dfabf58bee04330d~h1n9EvvJv1820918209epcas5p40;
	Fri,  7 Feb 2025 05:39:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Yq2pq1TtCz4x9QG; Fri,  7 Feb
	2025 05:39:31 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	15.6E.19710.39C95A76; Fri,  7 Feb 2025 14:39:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250207051943epcas5p4b831a4f975232d67f5849c3a2ddbcb59~h1WpTmAFo0303303033epcas5p4C;
	Fri,  7 Feb 2025 05:19:43 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250207051943epsmtrp1bcfa17ea0406fa16ee3f812202b4e666~h1WpKGv8A0593805938epsmtrp1v;
	Fri,  7 Feb 2025 05:19:43 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-8d-67a59c93df51
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F3.1E.18949.FE795A76; Fri,  7 Feb 2025 14:19:43 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250207051942epsmtip25c0a85294bbd1986114655a22884933b~h1Wn4iFrg0715807158epsmtip2Z;
	Fri,  7 Feb 2025 05:19:42 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: stefanha@redhat.com, sgarzare@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, mindong.zhao@samsung.com, q1.huang@samsung.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com, Junnan Wu
	<junnan01.wu@samsung.com>
Subject: [PATCH 1/2] vsock/virtio: Move rx_buf_nr and rx_buf_max_nr
 initialization position
Date: Fri,  7 Feb 2025 13:20:32 +0800
Message-Id: <20250207052033.2222629-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmlu7kOUvTDZ7P57C4e83dYs7UQou2
	HZdZLa4s6WG3OLZAzGLp27PMFmcnfGC1OD/nP7PF60n/WS2Wn53HZnHhyEp2i/2PZrI68HhM
	vrGc0eP9vqtsHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlh
	rqSQl5ibaqvk4hOg65aZA3SXkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECv
	ODG3uDQvXS8vtcTK0MDAyBSoMCE748vqJYwF97grrh2wa2D8y9nFyMkhIWAiseXnEfYuRi4O
	IYHdjBJfV71mg3A+MUo8vHKeHaRKSOAbo8SLneowHafadjFBFO1llHhzqhXKecYo8f/TLjaQ
	KjYBTYkTe1aA2SICOhIb7uwHG8ss8JRRYs2zV6wgCWGBWInWhklgRSwCqhJ/9ywDi/MK2Els
	bmhnhVgnL7H/4FlmiLigxMmZT1hAbGagePPW2cwQNS/ZJR4+84KwXSQu3mxghLCFJV4d38IO
	YUtJvOxvg7KzJXqP/mKDsEskut9dgtplLXF+XTvQTA6g+ZoS63fpQ4RlJaaeWscEsZZPovf3
	EyaIOK/EjnkgNgeQrSrxfkINRFhaYuWmTewQYQ+J27tqIGEYK/FlwXXmCYzys5D8MgvJL7MQ
	9i5gZF7FKJlaUJybnppsWmCYl1oOj9Xk/NxNjOC0qeWyg/HG/H96hxiZOBgPMUpwMCuJ8E5Z
	syRdiDclsbIqtSg/vqg0J7X4EKMpMIAnMkuJJucDE3deSbyhiaWBiZmZmYmlsZmhkjhv886W
	dCGB9MSS1OzU1ILUIpg+Jg5OqQampx4H737bmFnbI3WDszfzyMc7+QzKqVdO/ew5PDu3iuf4
	PD8P+bd6l1rucPS3vNkR+MN6CVNnA+M67qPBJSzPZtdGL38pGXB4B+fhKQekPn+Y4eTZPPWX
	9LfEyT8mPX9/4rHYPRbTyxyWaj23X5aayX0UYzjUU2d9r+NMctBS1nOM9kZ3UmOfsFTdWPs3
	flXsr7Z9jbdlbzvd+/I0yryZa8LiHS5J3yzyso+8yrzykX9x9xfBFxLzNrM/21GaubkthWn+
	huD2hsUpq5QdV63e8TvpbK1VkVbwR8bPYtvTW9kuFgS9jZR7sisrTIPv/uRFFktEbiy8fSH3
	Xrr+cRmHs0yFuvbrTdZE/PB68kSIQYmlOCPRUIu5qDgRACe20dIkBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWy7bCSvO776UvTDba+lrW4e83dYs7UQou2
	HZdZLa4s6WG3OLZAzGLp27PMFmcnfGC1OD/nP7PF60n/WS2Wn53HZnHhyEp2i/2PZrI68HhM
	vrGc0eP9vqtsHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxZfUSxoJ73BXXDtg1MP7l7GLk
	5JAQMJE41baLqYuRi0NIYDejxM5Ls9ghEtISXb/bmCFsYYmV/56zQxQ9YZS4cvIKI0iCTUBT
	4sSeFWwgtoiAnsSuk58ZQYqYBd4yStzo6GACSQgLREu0H1gKNpVFQFXi755lrCA2r4CdxOaG
	dlaIDfIS+w+eZYaIC0qcnPmEBcRmBoo3b53NPIGRbxaS1CwkqQWMTKsYJVMLinPTc4sNC4zy
	Usv1ihNzi0vz0vWS83M3MYIDWUtrB+OeVR/0DjEycTAeYpTgYFYS4Z2yZkm6EG9KYmVValF+
	fFFpTmrxIUZpDhYlcd5vr3tThATSE0tSs1NTC1KLYLJMHJxSDUxTTjtn7zoru3jL13dLzJKP
	nVVi6+XU0ZRTtb3Cqq+6rsa6s/6ifcvqRUH5D/7nnc2fJGmyQ6s6YtVbRh/pG/zVJ190T3TR
	rj12kFFKb5nQ4l19YZNjliWIW2zLqll08Ok72aSadRM/Ni4q1v/f4K29fLbubR31Hh79R2bV
	ecbfi9Y9bVZkkot746LmqHBqqQzfKtMQM7WlXaf+7g9z/XL00ES7+wwnrlSbr70wgXumaWl1
	eHZT8Qo/IYby/EneARrMUnc2Pozuf+yyPOe1aHOf7vFXh15/tm+7x3i7XdOlw3lDDvuW+Yqv
	Rf5Fh5i8VfOUWM+zWvXurzXmX4OveE42Zl5zkj1y22X5CdwXpZRYijMSDbWYi4oTAYFXf0nT
	AgAA
X-CMS-MailID: 20250207051943epcas5p4b831a4f975232d67f5849c3a2ddbcb59
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250207051943epcas5p4b831a4f975232d67f5849c3a2ddbcb59
References: <CGME20250207051943epcas5p4b831a4f975232d67f5849c3a2ddbcb59@epcas5p4.samsung.com>

From: Ying Gao <ying01.gao@samsung.com>

In function virtio_vsock_probe, it initializes the variables
"rx_buf_nr" and "rx_buf_max_nr",
but in function virtio_vsock_restore it doesn't.

Move the initizalition position into function virtio_vsock_vqs_start.

Once executing s2r twice in a row without
initializing rx_buf_nr and rx_buf_max_nr,
the rx_buf_max_nr increased to three times vq->num_free,
at this time, in function virtio_transport_rx_work,
the conditions to fill rx buffer
(rx_buf_nr < rx_buf_max_nr / 2) can't be met.

Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
---
 net/vmw_vsock/virtio_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index b58c3818f284..9eefd0fba92b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -688,6 +688,8 @@ static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
 	mutex_unlock(&vsock->tx_lock);
 
 	mutex_lock(&vsock->rx_lock);
+	vsock->rx_buf_nr = 0;
+	vsock->rx_buf_max_nr = 0;
 	virtio_vsock_rx_fill(vsock);
 	vsock->rx_run = true;
 	mutex_unlock(&vsock->rx_lock);
@@ -779,8 +781,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->vdev = vdev;
 
-	vsock->rx_buf_nr = 0;
-	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
 
 	mutex_init(&vsock->tx_lock);
-- 
2.34.1


