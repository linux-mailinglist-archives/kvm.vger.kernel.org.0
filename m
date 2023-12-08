Return-Path: <kvm+bounces-3938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7173380AB7D
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CBD21F212EC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C1341C9B;
	Fri,  8 Dec 2023 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E276xbP6"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A405DB5;
	Fri,  8 Dec 2023 09:59:20 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20231208175919usoutp01a77d5964ab0763c7b380080913c0904a~e7Q9hoMCh3034830348usoutp01D;
	Fri,  8 Dec 2023 17:59:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20231208175919usoutp01a77d5964ab0763c7b380080913c0904a~e7Q9hoMCh3034830348usoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702058359;
	bh=qU0eJIgdQr6zgcxChnPUwe+5BBI88iRdU7BR5a9c0gg=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=E276xbP6zQNIFXaW/kQJYQYVEtHcRrrFwoBqN8+VYsELyh66nRjk185jdV+QbTCI/
	 YCERR+/NfNVo+BX1epjucgw+OOAqAfs6QvbMUbDEm8UKsVRz8fppwFEtce0zSKO/ZG
	 hDId/319hbAqkJQ+ul9B6TbojGMWoN0uie9EZ6GM=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20231208175919uscas1p155d5503d60399c9f1df695ac4b6d3237~e7Q9MvnOs2828328283uscas1p1N;
	Fri,  8 Dec 2023 17:59:19 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id FA.F7.09760.77953756; Fri, 
	8 Dec 2023 12:59:19 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231208175918uscas1p2b1aaa46b914c6b65e464ba63483b9250~e7Q89wfvV0190201902uscas1p2t;
	Fri,  8 Dec 2023 17:59:18 +0000 (GMT)
X-AuditID: cbfec36f-7f9ff70000002620-47-65735977bb8f
Received: from SSI-EX2.ssi.samsung.com ( [105.128.3.66]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id A9.38.09511.67953756; Fri, 
	8 Dec 2023 12:59:18 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Fri, 8 Dec 2023 09:59:18 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Fri,
	8 Dec 2023 09:59:18 -0800
From: Jim Harris <jim.harris@samsung.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZbCe+60AgAAHXQCAASslAIAAAKWAgAAFEYA=
Date: Fri, 8 Dec 2023 17:59:17 +0000
Message-ID: <ZXNZdXgw0xwGtn4g@bgt-140510-bm01.eng.stellus.in>
In-Reply-To: <20231208174109.GQ2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <091F23DB23C4AC44A4F6DAA42B753729@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTe7+7uel1NrsvymJElQg/TskZc8kGQ5SKQ6AUVPYZeXHad265T
	e5iPYYQp9qCWm+iszAcDSyuyRHGt3MqSyrKkN4OStNRmk7CZ8yrsv++c7/vO+c6PHymUVosW
	kkdUWYxWpWDDCTF+9/FYT1TOXo5ZU9uH038mSwlaf6cC0deLlHSvpw3RlZc09LOqLmIjITc3
	6+Rl+p+E/Ff7a0L+u3nxdnyfOC6VYY9kM9rVCYfFStuT537qSXHuLc9jvwL0gixB/iRQMuge
	bsNKkJiUUg0ICp3dOF8UYzDxyiCcVU2WjxM8YUEw7u5CfDGC4PNV1wxTi+Df0C3MayGoFfC3
	1zKNg6gIsNu7/bwiITWIwDnkwr3EPCoJ9BftiBfJofVv4dQkcgonQ5tjo7eNT3nfTQxMSyRU
	PLRcKBN5sT+1FszvzdNjELUA3E/4XUIqGPqd1RgfOxCumtpmTlgAnvtfCB4vhU/uAT9evwrM
	D0YJHieA2zM7JxJu1PwQ8nsDwVHhxHlvCHTWv51+I6BsJNir6meWJcLHN5dFPA4Fg+XVjOEo
	NDSdwbx3AaWGAtsOvh0LNRNN2DkUYfSJbfSJZPSJZPSJZPSJZEaiRhSs47iMNIZbq2JyojlF
	BqdTpUWnZGY0o6k/9NTzMPMe6usfibYijERWBKQwPEjC9mQyUkmq4thxRpt5SKtjGc6KQkk8
	PFgSE+9IkVJpiizmKMOoGe0si5H+Cwuw/a09GOvZxeWbUmS2YVdc8pJNktgPH/V0uuDR+WrT
	AZZw5kWW7twZ1dJ5Nptco2G31GG9cdTAWIf0j8FgNRy4fv/M8sZYEDZtXX9znagjJCjY37LD
	qpHVOeKGN8Sy5TGnZD0Pv31XZl17oa+35M7d09cRlLi6aywg58RX4x6sksnv3JsdneEobDSE
	FQ3JXaMQoL69wfQl5V1+hObwYCs56Eq4LUsqlA+oyrhxetvnOcXNgmT7pDm9PCBKM1oimO+8
	0hGmS9xtwscERZR70ebLLYJf2p/9N7uUiWEJ6Qfz5jCG9b/zXCWczRBCtNOD1h/x5mUvH6We
	Pulm1eE4p1TErBRqOcV/9WDJIbIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWS2cDspFsWWZxqMHetgcW3/z1sFs1bZzJa
	LGnKsLjybw+jxZyphRZn5x1nc2DzWLCp1KO3+R2bx/t9V9k8Pm+SC2CJ4rJJSc3JLEst0rdL
	4Mo4cuoce8F/roqN/46xNzBe5Ohi5OSQEDCR+N//g62LkYtDSGAVo8TMeQuZIJyPjBKXDmxg
	gXCWMkps/t3HBtLCJqAp8evKGiYQW0RAReLEiTPsIEXMAm8YJZ68/cICkhAWcJdonnyCEaLI
	Q2Lnr0agZg4g209iz0kHkDALUO/NPy/BSngFbCU2T+plhVi2hUmic+Y+ZpAEp4CRxII7C8Bm
	MgqISXw/BbGYWUBc4taT+UwQPwhILNlznhnCFpV4+fgfK4StKHH/+0t2iHodiQW7P7FB2HYS
	3//BzNGWWLbwNTPEEYISJ2c+YYHolZQ4uOIGywRGiVlI1s1CMmoWklGzkIyahWTUAkbWVYzi
	pcXFuekVxcZ5qeV6xYm5xaV56XrJ+bmbGIFRfPrf4ZgdjPdufdQ7xMjEwXiIUYKDWUmEN+d8
	fqoQb0piZVVqUX58UWlOavEhRmkOFiVx3rsPNFKFBNITS1KzU1MLUotgskwcnFINTB6uq4y8
	125vKIs6F9P2/ou+wbZ7CXK1dWERrVoLynfad+fNiFBauFB82iLNv6XuGfK6/+aePbku5qDU
	kqt3b3Hs+hw28YivfM+fW7d/qiQoLmCdkOKRryMgKxElyOJfvZP7ndp6dev7qZMnChQK7OyN
	N21b+LswMp9lkZ6DlOSn7DfN/dskrkWKvLj9e3eYxdLyFu7LESJZZTqe7lf3HPoVscShLJRJ
	NjuGS+a7cdUDv2l+E28k5s+vlqjKXSBp8v7Okmsph84Vi+zyLYvXerfnm/AuIx/NNyYV1ZKv
	eiYV7Ho/aW5JrVLlDfbbXPc0fIJPMUt+7Z90/dWkyRuabuj53Fv/+K7QVOaP+2MeK7EUZyQa
	ajEXFScCAOs6foNRAwAA
X-CMS-MailID: 20231208175918uscas1p2b1aaa46b914c6b65e464ba63483b9250
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
	<ZXJI5+f8bUelVXqu@ubuntu>
	<20231207162148.2631fa58.alex.williamson@redhat.com>
	<20231207234810.GN2692119@nvidia.com>
	<ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
	<20231208174109.GQ2692119@nvidia.com>

On Fri, Dec 08, 2023 at 01:41:09PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 08, 2023 at 05:38:51PM +0000, Jim Harris wrote:
> > On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
> > >=20
> > > The mechanism of waiting in remove for userspace is inherently flawed=
,
> > > it can never work fully correctly. :( I've hit this many times.
> > >=20
> > > Upon remove VFIO should immediately remove itself and leave behind a
> > > non-functional file descriptor. Userspace should catch up eventually
> > > and see it is toast.
> >=20
> > One nice aspect of the current design is that vfio will leave the BARs
> > mapped until userspace releases the vfio handle. It avoids some rather
> > nasty hacks for handling SIGBUS errors in the fast path (i.e. writing
> > NVMe doorbells) where we cannot try to check for device removal on
> > every MMIO write. Would your proposal immediately yank the BARs, withou=
t
> > waiting for userspace to respond? This is mostly for my curiosity - SPD=
K
> > already has these hacks implemented, so I don't think it would be
> > affected by this kind of change in behavior.
>=20
> What we did in RDMA was map a dummy page to the BARs so the sigbus was
> avoided. But in that case RDMA knows the BAR memory is used only for
> doorbell write so this is a reasonable thing to do.

Yeah, this is exactly what SPDK (and DPDK) does today.=

