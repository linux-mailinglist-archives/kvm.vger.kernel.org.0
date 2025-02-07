Return-Path: <kvm+bounces-37558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE85A2BABA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 06:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDF0D1887D35
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 05:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D198233155;
	Fri,  7 Feb 2025 05:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gfih+DYd"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B268C13CFA6
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 05:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738906781; cv=none; b=a9ZNfbPwjj/x/51reZWq8f5GJWyz/YCP4DvLOqHSfu3/d7RZ/uzL+122AmApBUirhZ2mYFijhyGJWumTLrTELieddLjlZL3JhU9rKk2xbxjiQjyOa3OxPtn0xAl3YLnvqzAVwZZYeBJ0T8dQCEY3r1ytoZE2NyYkEcO+yYwODSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738906781; c=relaxed/simple;
	bh=SyY1BofVi6x96xF4f3wJ1jJpg+B7ZpKANHIk8gW6g9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WJ96/1xvEOWrnZRemdIUefCp0UmYUhC5mkpn47q3SVCH4J3A+R6nykdVd1mkB7Olq5v+WD0PZGrFndUKhvThtFBltk8TtqRCkpaBVYy0hrHm1AJ/o3Yh1VkvGwQZlAYaWtzO9ANeBEKF4pPOIYNY8sXe8o5UWcy/jIvTWoGNbuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gfih+DYd; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250207053935epoutp017ea175af142e7220a55b57cdfe2f9f97~h1n-NlUUN0161401614epoutp01m
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 05:39:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250207053935epoutp017ea175af142e7220a55b57cdfe2f9f97~h1n-NlUUN0161401614epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1738906775;
	bh=jydq0beKCSDmdAiK7qVjqR/9kLYfVz8A/x0FiEogWco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfih+DYdVA0Oei/Mh8Dhk6DmIRLY6bzxjQrSaIjaY0V9dmQeYRSJHVyfpGKwO+B5n
	 VbOQF6DSZ9MaE5KrKhlo9W8nvSauak99Ylgp4znrftZc0HUctylY2yR4ew5P0sh3tu
	 7G/Z/dWk9HXm7SJe03eT/TGdP+FmKuDnQL7l2Q+k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250207053935epcas5p174c6592e46010e8ee0734c9729edde84~h1n_wSk6G1194211942epcas5p1-;
	Fri,  7 Feb 2025 05:39:35 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Yq2ps5fPlz4x9Q9; Fri,  7 Feb
	2025 05:39:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E8.1D.19956.59C95A76; Fri,  7 Feb 2025 14:39:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5~h1WsEW49K0669806698epcas5p2C;
	Fri,  7 Feb 2025 05:19:46 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250207051946epsmtrp13e5cb5607364fa3b2744c21b0b8fcdb2~h1WsDc_6q0593805938epsmtrp1w;
	Fri,  7 Feb 2025 05:19:46 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-20-67a59c952dfe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.1E.18949.2F795A76; Fri,  7 Feb 2025 14:19:46 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250207051945epsmtip2c38107c87737646d51eedd1a737d0461~h1WqyRPmt0710207102epsmtip2g;
	Fri,  7 Feb 2025 05:19:45 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: stefanha@redhat.com, sgarzare@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, mindong.zhao@samsung.com, q1.huang@samsung.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com, Junnan Wu
	<junnan01.wu@samsung.com>
Subject: [PATCH 2/2] vsock/virtio: Don't reset the created SOCKET during s2r
Date: Fri,  7 Feb 2025 13:20:33 +0800
Message-Id: <20250207052033.2222629-2-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207052033.2222629-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmhu7UOUvTDd7v1rK4e83dYs7UQou2
	HZdZLa4s6WG3OLZAzGLp27PMFmcnfGC1OD/nP7PF60n/WS2Wn53HZnHhyEp2i/2PZrI68HhM
	vrGc0eP9vqtsHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlh
	rqSQl5ibaqvk4hOg65aZA3SXkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECv
	ODG3uDQvXS8vtcTK0MDAyBSoMCE7Y8qdHYwFjVwVOw7/YW9g3M7RxcjJISFgIrH46CWmLkYu
	DiGB3YwSH05/ZAVJCAl8YpT4uDcCIvGNUeL9tAdMMB1TjsxhhEjsZZSYtPwCG4TzjFFix6o7
	jCBVbAKaEif2rGADsUUEdCQ23NkPVsQs8JRRYs2zV2A7hAV8JD49OwJmswioSly6OJ0ZxOYV
	sJM407eAFWKdvMT+g2eB4hwcnAL2Ege+OECUCEqcnPmEBcRmBipp3jqbGWS+hEArh8TmXf2M
	EL0uEltetjFD2MISr45vYYewpSRe9rdB2dkSvUd/sUHYJRLd7y5B7bWWOL+uHWwvM9Az63fp
	Q4RlJaaeWscEsZdPovf3E2io8ErsmAdicwDZqhLvJ9RAhKUlVm7aBLXJQ2Lm6nfQgJvEKDHr
	1yKWCYwKs5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCcl1oOj+Tk/NxNjOCkquW9g/HRgw96
	hxiZOBgPMUpwMCuJ8E5ZsyRdiDclsbIqtSg/vqg0J7X4EKMpMLgnMkuJJucD03peSbyhiaWB
	iZmZmYmlsZmhkjhv886WdCGB9MSS1OzU1ILUIpg+Jg5OqQamvDcbwiuKTzkv8HbWS5rBr/PQ
	oEpvO4NA7+lbe+bNX2nkpfQiX+yfafl0lTdnE5XnV8nKRd6V2j692eTXz+7X1osnaWXMPTj1
	0Je+Fxs3u1j65ms9/Pz38tM5879vcrD7K3HnfEqNtc+thf99Jkdq6E4Wu6q0o/XB6fsJ/OoM
	XBPXc29y9tv6JN/PaKMFy4qFPEtuVXZxrjty+aXa7d1uin08clL//h1zvRO4tOQ7yzQ+uzcx
	XKVhx7M5vuTL+Ute8fnivT3F88l5Qe1P817cPB54ovXh+YaddmU+qk0XjpodXjfn+YlJtxpO
	9a1653bhe0iqx4956/ujF4W4FjILuLzRN7+x6MsBx0Suvz+YWZRYijMSDbWYi4oTAZz+pm4z
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSvO6n6UvTDW7cUba4e83dYs7UQou2
	HZdZLa4s6WG3OLZAzGLp27PMFmcnfGC1OD/nP7PF60n/WS2Wn53HZnHhyEp2i/2PZrI68HhM
	vrGc0eP9vqtsHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx5c4OxoJGroodh/+wNzBu5+hi
	5OSQEDCRmHJkDmMXIxeHkMBuRomWwwtYIBLSEl2/25ghbGGJlf+es0MUPWGU2PVzCRtIgk1A
	U+LEnhVgtoiAnsSuk5/BJjELvGWUuNHRwQSSEBbwkfj07AgriM0ioCpx6eJ0sKm8AnYSZ/oW
	sEJskJfYf/AsUJyDg1PAXuLAFweQsBBQyabe3UwQ5YISJ2c+ATuOGai8eets5gmMArOQpGYh
	SS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc+FpaOxj3rPqgd4iRiYPxEKME
	B7OSCO+UNUvShXhTEiurUovy44tKc1KLDzFKc7AoifN+e92bIiSQnliSmp2aWpBaBJNl4uCU
	amCyjn/yMU7DuvWt98QysWVqbjpSAklLdryRjXsbeubWMyP15y+3d1zour89yFH+4dJXItVm
	vp/YYvbd1446LBl736Ho5Bbl/WZfp7iuXL6mQVg3brHe2uiF3KoBznMenCzJWvzf7YXvS+kG
	/aMaWlGJ7pvupr0rWsIlm3xv7tHEnbNU6qe90rf5JrXgx/+UazFKZxZdZLy/ynh5IP+lmh2f
	+C0/LONKlCtauvRKfPELbn+n0z+y9XhWncv9Vv/xAMfloPkdB65bLPG0Wf6OfWeSt7TLq4Ui
	yzSfXV3vGewn/f/bs7QqtqOz3/4Ps7xR/lCgu+vm1llcb69IB/SVvr/47beg2oyWcK8foss0
	Nl6WUmIpzkg01GIuKk4EAHH2qXjrAgAA
X-CMS-MailID: 20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5
References: <20250207052033.2222629-1-junnan01.wu@samsung.com>
	<CGME20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5@epcas5p2.samsung.com>

From: Ying Gao <ying01.gao@samsung.com>

If suspend is executed during vsock communication and the
socket is reset, the original socket will be unusable after resume.

Judge the value of vdev->priv in function virtio_vsock_vqs_del,
only when the function is invoked by virtio_vsock_remove,
all vsock connections will be reset.

Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
---
 net/vmw_vsock/virtio_transport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 9eefd0fba92b..9df609581755 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -717,8 +717,10 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
 	struct sk_buff *skb;
 
 	/* Reset all connected sockets when the VQs disappear */
-	vsock_for_each_connected_socket(&virtio_transport.transport,
-					virtio_vsock_reset_sock);
+	if (!vdev->priv) {
+		vsock_for_each_connected_socket(&virtio_transport.transport,
+						virtio_vsock_reset_sock);
+	}
 
 	/* Stop all work handlers to make sure no one is accessing the device,
 	 * so we can safely call virtio_reset_device().
-- 
2.34.1


