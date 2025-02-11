Return-Path: <kvm+bounces-37815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02825A3045D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A2C18890F1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7DF1EDA06;
	Tue, 11 Feb 2025 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b8DXhJMG"
X-Original-To: kvm@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552421D63F7
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739258607; cv=none; b=JaXPuLDwgKtWohfwhn6ssBYmte16SdfjKxl7KcRuiaju6LDrLyOXshGobnav44jMA4pNbF+iW5IZxSu1dVP2kug/4mauQax/iq2uuTiCJ7grZM7zdvUYrrEJUwDQQIC4H2Y3pls2hHrzbNTbvHhQDXSSwEGiuMfioG9iyFT3wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739258607; c=relaxed/simple;
	bh=5tQjiIQk2nuzxRJad588bn9deftW0ZNoEH56ATm3DXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=f+aOlxAs7mSkQh/fPFeNH80b9NUsvFriwNNzM8maIjXZx6+4ecu48+Q4ODStgAjqYpwrydtj/bvOwEzIp8j+3VKSQuxEmT3QYTPrx+WaQqjYns1NbL6IeFsS1r6In+fyRCzpIndV+ROidrElC1dq9GFd9jpqb8PIc3fg20ZcGqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b8DXhJMG; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250211072316epoutp03d16b116325884f6a20336d5fc8253956~jFnqUV4tW3092530925epoutp03Z
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:23:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250211072316epoutp03d16b116325884f6a20336d5fc8253956~jFnqUV4tW3092530925epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739258596;
	bh=G6avid1hrwNJPrhgZ7UQBMr1iT6oxnJhYUfx9eOouYA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=b8DXhJMGXuEE9MQIJk36NgFENkhX3Zpz51zpRdYrijixuUOTqTMRkg+o3yRUkSRZ6
	 3aVQul4maquBZkUqy31WVfFGUuwgcWHMxUmWNSeifcqXDE5mzw/K2ffDxcrOPMp8R6
	 U9M/whJgKyhQq6D48eZSfD6mMJ4EnB1ZeOLxIJOk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250211072315epcas5p2e343d70ffe99c82d9313aaadff90e7ef~jFnpeOHZp2733327333epcas5p2K;
	Tue, 11 Feb 2025 07:23:15 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4YsXwf4Tsbz4x9Q7; Tue, 11 Feb
	2025 07:23:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	47.B5.29212.2EAFAA76; Tue, 11 Feb 2025 16:23:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250211071930epcas5p2dbb3a4171fbe04574c0fa7b3a6f1a0c2~jFkXYbuoh0889308893epcas5p2-;
	Tue, 11 Feb 2025 07:19:30 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250211071930epsmtrp2d5e817728b2b7e36619d54991cd86cd4~jFkXXZJ4a0103201032epsmtrp2h;
	Tue, 11 Feb 2025 07:19:30 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-30-67aafae28315
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.58.18949.20AFAA76; Tue, 11 Feb 2025 16:19:30 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250211071927epsmtip18b2e100e232e16e03af55d6fa339fd3b~jFkUZCSIX1188211882epsmtip1B;
	Tue, 11 Feb 2025 07:19:27 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
	jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, q1.huang@samsung.com, ying01.gao@samsung.com,
	ying123.xu@samsung.com, lei19.wang@samsung.com, Junnan Wu
	<junnan01.wu@samsung.com>
Subject: [Patch net 0/2] vsock suspend/resume fix
Date: Tue, 11 Feb 2025 15:19:20 +0800
Message-Id: <20250211071922.2311873-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbVRj29HLLhVh3B4jHIqNeRWWz0LpSDvLhFomr20yqxB8sLtjBTSGU
	tuttxzSGzEIwYzDBMQa0W0C2Cp3bTKnIxncZCCgro4rDMBcKM3NAIVbAMBBLW3T/nvc57/M+
	5zkfBBYyweYSuUotrVHKFBQ7OKC1L+YVvnPVLBeM9z2PjPbiAHR/wBmIps83ByLn54NsZBpz
	s9Dd8X1otPU0joxnj6KSNgeOHDeMbPTTxbJAtLH6EEcD9eFo+Yc5gC7Nj2BopGIRR3bjBoZm
	v9jAUf93zTga1yM0etMztdtZi+8Jl1ibJ1iSeotOYjGfZEuuTyVKHrTUAslC189syWmrGUjc
	lh1S4lBecg4ty6Y1PFqZpcrOVcpTqAPpmW9mxosFQr4wESVQPKUsn06h0g5K+W/lKjzRKN4x
	mULnoaQyhqHiUpM1Kp2W5uWoGG0KRauzFWqROpaR5TM6pTxWSWtfFwoEr8V7Gj/My7ls/xRX
	r2PH1yqLwAlgxkpBEAFJEWzpnwOlIJgIITsAdC6f8hd/Arj4i5XtK5YBNNdUs7ckK/pxzLfQ
	CeADy6xf8juAvznd3i42GQMHO5q88jCyEUB70xK+WWBkOws2/OoGm12hpBDenKz04gAyGq6W
	urxqDpkKZ++acJ9fFOzuHcF8/HY4VDsTsIkxD1/0rcEfY5CAY+1hPpwG18+t+vcaCh9+bw30
	YS50uzr9fB4s79/q0cJTrjG/VxK0X/3MM5PwzI+B127E+ehIeHb4Kstn+xQsfzTD8vEc2HZh
	ExMeHA0XKj7x0RGw2WLxu0rgVxN/eROGkIfhVEcjXgGi6h4LU/dYmLr/jesBZgZcWs3ky+ms
	eLWQr6QL/rvaLFW+BXjf+E5pG7j8zXqsDbAIYAOQwKgwjqihSR7CyZZ99DGtUWVqdAqasYF4
	zxFXYtyns1SeT6LUZgpFiQKRWCwWJe4WC6lnOEXXi+UhpFympfNoWk1rtnQsIoh7glWTUKAT
	BKem0W0/cqpvQcforTvHmr/edeDMkUXDnuqlJHfJYX3pu9EffPneC49Mb/BGSJcmadcTGdnc
	96/s7ovP4Jycs6o3Il2N+6YyrtwZMSkO7gdnnmPqJMJq48Vp/iFVYWFP7Dy2LWogwrDWeFs/
	/LZt5ll9Z8G1FXLIWhg83k8tlHcXF2zfZuzorRIU5K4XHpWz/ik7N8bd2GvTt6fFTavKXh3K
	EkujS6s4+j8wPGhirS7yyXt73+kSrV5KH04PNcwZGuYmE1+ELkdEl2ktvfflnnt2ccbS3/Wt
	t3sSVDtMyFES7lgpL6x5aZLhpyQvHK+Ou19lcI2V7G+pOjJPBTA5MuFOTMPI/gVzSuvUbAQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTpfp16p0g0vHuS3mnG9hsXh67BG7
	xeO5K9ktHvWfYLNYdukzk8Xda+4WF7b1sVrMmVpo0bbjMqvF5V1z2CyuLOlht/j/6xWrxbEF
	YhbfTr9htFj69iyzxdkJH1gtzs/5z2zxetJ/Vouj21eyWlxrsrC4cARo6v5HM1kdxDy2rLzJ
	5LFgU6nHplWdbB47H1p6vNg8k9Hj/b6rbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVsfp8
	I2vBX+aKPxObGRsYVzF3MXJySAiYSHxvugZkc3EICexmlPjYPhcqIS3R9bsNyhaWWPnvOTtE
	0RNGiU/zN7CDJNgENCVO7FnBBmKLCKxllNi0zxCkiFngJJPErRkTwLqFBQwljtyZyAhiswio
	SvzqegfWwCtgJ/H67jJWiA3yEvsPnmWGiAtKnJz5hAXEZgaKN2+dzTyBkW8WktQsJKkFjEyr
	GCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI0pLawfjnlUf9A4xMnEwHmKU4GBWEuE1
	WbgiXYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQamSakH
	a9k7z6wP2n28MmdTXHLAlJ6/h5qy5esarpy2nv1KrfdFZdfhgtbSf4tO3dhrZHzu9ZS3O+8F
	v0l6GPbmbZJmkt+zyzHXpeIc51l+3D/LkCVX+8hCmUhnPetP6kJ+b3JFXq3RDnZ89/NH9rNq
	Zln9j3I/d7AEfbwaeOspZymzzK4rTK8tNmSpR6qwBAaczja/lPTP77vNB52eSFOLxl61DW96
	96cEbPcrujblete2LtZ326VrFv2/X7JdqHbCx1599l+2WW8PMZv9UtZwVg2ddTtgVvW1TO0b
	2yoezz1zUSOG4ej6bZP4199fvrFegTsmPL708TzjLdODys6817wZU3z8fnDmCc0gzQYJJZbi
	jERDLeai4kQAQC26ihcDAAA=
X-CMS-MailID: 20250211071930epcas5p2dbb3a4171fbe04574c0fa7b3a6f1a0c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250211071930epcas5p2dbb3a4171fbe04574c0fa7b3a6f1a0c2
References: <CGME20250211071930epcas5p2dbb3a4171fbe04574c0fa7b3a6f1a0c2@epcas5p2.samsung.com>

CC all maintainers and reviews.
Modify commits accroding to reviewers' comments.
Re-organize the patches, cover letter, tag, Signed-Off, Co-worker etc.

Junnan Wu (2):
  vsock/virtio: initialize rx_buf_nr and rx_buf_max_nr when resuming
  vsock/virtio: Don't reset the created SOCKET during suspend to ram

 net/vmw_vsock/virtio_transport.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)


base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
-- 
2.34.1


