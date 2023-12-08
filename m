Return-Path: <kvm+bounces-3966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E081A80AD93
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A6841F21223
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401E957327;
	Fri,  8 Dec 2023 20:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XbfnUl2W"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4D8F1;
	Fri,  8 Dec 2023 12:09:43 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20231208200935usoutp013eade6b562d56a6dec224e2953fc5c3b~e9CtAUsTA0188501885usoutp01e;
	Fri,  8 Dec 2023 20:09:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20231208200935usoutp013eade6b562d56a6dec224e2953fc5c3b~e9CtAUsTA0188501885usoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702066175;
	bh=Iv7XyhyxUSiHcnN6SjqD7mdRbAbHc4NXoqsP3KfXXLw=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=XbfnUl2WmEPn7/JEIBVfd5l0rcVEb9sCTyBJTcIeViOfbpkrXLhEberX40srqu3zX
	 0VfmI8oxUJNc7j6TjSLs3Sffp1i5FYGNEv34ZrwRF1qYemlY+SraOy248j7WADkXjm
	 UYYrBJZH8TbMPCHkltqUKIFmxvwO+FO/FtDenG/Q=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231208200935uscas1p26edc81734e83823ca1e9631c10c58542~e9Cs6jOxO0752507525uscas1p2b;
	Fri,  8 Dec 2023 20:09:35 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id 87.0B.09550.FF773756; Fri, 
	8 Dec 2023 15:09:35 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
	[203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231208200935uscas1p27bf9af3e1af779eeb569440fbafe1d99~e9CspZ3sm2540125401uscas1p2a;
	Fri,  8 Dec 2023 20:09:35 +0000 (GMT)
X-AuditID: cbfec370-933ff7000000254e-8c-657377ff2d18
Received: from SSI-EX1.ssi.samsung.com ( [105.128.3.67]) by
	ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 4F.88.09813.FF773756; Fri, 
	8 Dec 2023 15:09:35 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Fri, 8 Dec 2023 12:09:34 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Fri,
	8 Dec 2023 12:09:34 -0800
From: Jim Harris <jim.harris@samsung.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Leon Romanovsky <leonro@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ben@nvidia.com"
	<ben@nvidia.com>, "pierre.cregut@orange.com" <pierre.cregut@orange.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZbCe+60AgAAHXQCAASJQAIAAKz2AgAAHr4A=
Date: Fri, 8 Dec 2023 20:09:34 +0000
Message-ID: <ZXN3+dHzM1N5b7r+@ubuntu>
In-Reply-To: <20231208194159.GS2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF5832D762627B42B9DF6D4214B266B3@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7djXc7r/y4tTDR5fUbH49r+HzaJ560xG
	iyVNGRZX/u1htJgztdBi04YnLBZn5x1ns1j/9T2bA4fHgk2lHr3N79g8Wp6dZPN4v+8qm8fn
	TXIBrFFcNimpOZllqUX6dglcGfenPWQrOMRe8XT+D8YGxna2LkZODgkBE4kZR3YydzFycQgJ
	rGSU2DlrMSuE08okcXTZJqAqDrCqo5MiIOJrGCV+r9/GBOF8ZJR41bIfbJSQwFJGiUmrRUFs
	NgFNiV9X1jCB2CICKhInTpxhB2lgFjjFJLH+ajMjSEJYwF2iefIJRogiD4mdvxrZIGw/iZMb
	/4A1swA1nzk3nxnE5hVQlZh+4hxYnFPASOLv89msIDajgJjE91MQy5gFxCVuPZnPBPGboMSi
	2XuYIWwxiX+7HkL9rChx//tLdoh6HYkFuz+xQdh2Ej9e/GSGsLUlli18DbVXUOLkzCcsEL2S
	EgdX3ICy73BIPNrsBQkhF4nH7aIQYWmJv3eXQZ2QLbFyfQcTREmBRMORIIiwtcTCP+uZJjCq
	zEJy9CwkB81CctAsJAfNQnLQAkbWVYzipcXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIHp6fS/
	wwU7GG/d+qh3iJGJg/EQowQHs5IIb875/FQh3pTEyqrUovz4otKc1OJDjNIcLErivIa2J5OF
	BNITS1KzU1MLUotgskwcnFINTMmX9V8bqRybri97I8lXbznzjGZrxZdRn95s81pxqrOks/6m
	ZOAL74OnLi3/8eeSc+VbMV1hrxUqDLp+j4tyoj5P5Tlgpa/X9WFTgcX//Nl3Y3WqapeHhIU7
	c1l9+RtcmjrrslJcqe+N//cfPD7G/r1i8UfxxBWXeS/Xl1cbNu2a3la3/uPFF00zp53f0L66
	zTkhMPyI8ROtK/+cNRNPNTSVHp4Sk/H7+0v7j9Ut9neCTt6TqOfNEcj6oDDVcpbtvm0eKlnK
	zYdf3Vh/UKSbe117152si4Wr1+/+5/rFmvmZpSrXz9POtmd9GaUm5ygvrQ8S+y3G0iYVvI1x
	6x43x53l4i8nWl2sjGUSYVi7UomlOCPRUIu5qDgRAOEYmhO+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWS2cDsrPu/vDjV4PVMQYtv/3vYLJq3zmS0
	WNKUYXHl3x5GizlTCy02bXjCYnF23nE2i/Vf37M5cHgs2FTq0dv8js2j5dlJNo/3+66yeXze
	JBfAGsVlk5Kak1mWWqRvl8CVcX/aQ7aCQ+wVT+f/YGxgbGfrYuTgkBAwkTg6KaKLkZNDSGAV
	o0TfBccuRi4g+yOjxIkfC5khnKWMEj+mTGMHqWIT0JT4dWUNE4gtIqAiceLEGXaQImaBU0wS
	6682M4IkhAXcJZonn2CEKPKQ2PmrkQ3C9pM4ufEPWDMLUPOZc/OZQWxeAVWJ6SfOMUGcsYVJ
	Yt2WaBCbU8BI4u/z2awgNqOAmMT3UxCLmQXEJW49mQ9mSwgISCzZc54ZwhaVePn4HyuErShx
	//tLdoh6HYkFuz+xQdh2Ej9e/GSGsLUlli18DXWDoMTJmU9YIHolJQ6uuMEygVFiFpJ1s5CM
	moVk1Cwko2YhGbWAkXUVo3hpcXFuekWxUV5quV5xYm5xaV66XnJ+7iZGYHyf/nc4egfj7Vsf
	9Q4xMnEwHmKU4GBWEuHNOZ+fKsSbklhZlVqUH19UmpNafIhRmoNFSZz37gONVCGB9MSS1OzU
	1ILUIpgsEwenVAOT1oki6W3B7OqBf38e8m6e1HWieGtf3aKLrx/N6Vfsnny/KOe+mMoZV6nf
	lWX7bX8ahc/nEDT8GLvux7MMPzaH7OyfgbVZE78z/otgWXdm66Xr7qG3BW6XuzgbJSg8zHWd
	ni9xz+20wE73assDJ3ZNalx2UvLnR5NTN55PCtT0cvmR+O3weRXV6qBSHa3DKdnycz85ucaz
	d7hafzHJOmkwLyvio2NG7JRnL98tbdy16dBplt0aR2vL8ut2+hb5aYtPYbhx9PSmB2yTzum4
	bd/ietmYqUVOqf16YwWD3dXyN3vPP0/gurwidumnxUrMb5u3MZ68++ykgNmvsDlFQsZrFvpt
	CGM4uG23UL+v/OVOJZbijERDLeai4kQA2gLgtV4DAAA=
X-CMS-MailID: 20231208200935uscas1p27bf9af3e1af779eeb569440fbafe1d99
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
	<ZXJI5+f8bUelVXqu@ubuntu>
	<20231207162148.2631fa58.alex.williamson@redhat.com>
	<20231207234810.GN2692119@nvidia.com>
	<ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
	<20231208194159.GS2692119@nvidia.com>

On Fri, Dec 08, 2023 at 03:41:59PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 08, 2023 at 05:07:22PM +0000, Jim Harris wrote:
> >=20
> > Maybe for now we just whack this specific mole with a separate mutex
> > for synchronizing access to sriov->num_VFs in the sysfs paths?
> > Something like this (tested on my system):
>=20
> TBH, I don't have the time right now to unpack this locking
> mystery. Maybe Leon remembers?
>=20
> device_lock() gets everywhere and does a lot of different stuff, so I
> would be surprised if it was so easy..

The store() side still keeps the device_lock(), it just also acquires this
new sriov lock. So store() side should observe zero differences. The only
difference is now the show() side can acquire just the more-granular lock,
since it is only trying to synchronize on sriov->num_VFs with the store()
side. But maybe I'm missing something subtle here...

Adding Pierre who authored the 35ff867b7 commit.=

