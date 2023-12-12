Return-Path: <kvm+bounces-4272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E4880F97A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 22:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B059C1F2117D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180CA64153;
	Tue, 12 Dec 2023 21:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m0x9L2Dx"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D8CB3;
	Tue, 12 Dec 2023 13:34:48 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20231212213444usoutp01ea4663bb41973135db7a8f0afd230a66~gMyMNxkGV2211422114usoutp011;
	Tue, 12 Dec 2023 21:34:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20231212213444usoutp01ea4663bb41973135db7a8f0afd230a66~gMyMNxkGV2211422114usoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702416884;
	bh=HskENvYQxcfNrTVNCis+busLhbUDlXCdz1NtWY5+quc=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=m0x9L2DxfdttYnjqQPA0ECIfqFlXTkWvYAjys24r32sGAegJt+BBSfhheuGQEJJaX
	 sumr3n+SPeyCjzy/sTID1deZqgqYu7PYZo+VtUoXyVfByIfUdQkbs4EHrUrRalsA+z
	 jvuVEWiPafpFbfdAUavKRIwzd+9cqpadDh69yaPA=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231212213444uscas1p29faa2f988703e9c0f92294bf7dcc70cc~gMyMFF1vv2184921849uscas1p2v;
	Tue, 12 Dec 2023 21:34:44 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id 57.2E.09678.4F1D8756; Tue,
	12 Dec 2023 16:34:44 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231212213444uscas1p2e84863df4d84fb9b20eff8005a1cd5d7~gMyL3ShNI2174721747uscas1p20;
	Tue, 12 Dec 2023 21:34:44 +0000 (GMT)
X-AuditID: cbfec36d-85fff700000025ce-2a-6578d1f44f77
Received: from SSI-EX2.ssi.samsung.com ( [105.128.3.67]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 76.E9.09930.4F1D8756; Tue,
	12 Dec 2023 16:34:44 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Tue, 12 Dec 2023 13:34:43 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Tue,
	12 Dec 2023 13:34:43 -0800
From: Jim Harris <jim.harris@samsung.com>
To: Leon Romanovsky <leonro@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ben@nvidia.com"
	<ben@nvidia.com>, "pierre.cregut@orange.com" <pierre.cregut@orange.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZbCe+60AgAAHXQCAASJQAIAAKz2AgAAHr4CAAxLggIAAzSgAgAKBEIA=
Date: Tue, 12 Dec 2023 21:34:43 +0000
Message-ID: <ZXjRvfu9urCcyEmN@ubuntu>
In-Reply-To: <20231211072006.GA4870@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D49FCAD7EBDCC04AA3B911C230FD6F6B@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djX87pfLlakGvxqV7L49r+HzaJ560xG
	iyVNGRZX/u1htJgztdBi04YnLBZn5x1ns1j/9T2bA4fHgk2lHr3N79g8Wp6dZPN4v+8qm8fn
	TXIBrFFcNimpOZllqUX6dglcGWenrmMumCdQsWjCF9YGxg88XYycHBICJhLvj51j72Lk4hAS
	WMkosfLUOiinlUni8//FjDBVyye9ZIVIrGGUmLN9K5TziVHiWOdFFghnGaPE0v6bYC1sApoS
	v66sYQKxRQTUJT6sugjWwSxwnEmi7dJCVpCEsIC7RPPkE4wQRR4SO381skHYSRI//j9jB7FZ
	BFQltt5pABrEwcELZM9YXwQS5hTQlpi55D0LiM0oICbx/RTELmYBcYlbT+YzQZwtKLFo9h5m
	CFtM4t+uh2wQtqLE/e8v2SHqdSQW7P7EBmHbSSw6eAxqjrbEsoWvwXp5geacnPmEBaJXUuLg
	ihtgD0sI3OGQmLWzE2qoi0Tvl7tQtrTE1etToRZnS6xc3wF2v4RAgUTDkSCIsLXEwj/rmSYw
	qsxCcvYsJCfNQnLSLCQnzUJy0gJG1lWM4qXFxbnpqcWGeanlesWJucWleel6yfm5mxiBSer0
	v8O5Oxh33Pqod4iRiYPxEKMEB7OSCO/JHeWpQrwpiZVVqUX58UWlOanFhxilOViUxHkNbU8m
	CwmkJ5akZqemFqQWwWSZODilGpgULu3gV5bYP13Z85fvpu65qsGNbEdCBeu+LdhlwZpYryEh
	dr3kX7SUljPzMlnDvR2WDSGhGxZ97uiO2+xxQlxtE0vqtTtptw8cOBFnVMDxmef1neCoiPJV
	syfNvaczZcZ6u+YgEx/X902P7s5ivnjijFyQks2NOy6cpiFfqnMvynLxF9771LHQtNWjpVkr
	/PMvicr73+zPLLN9N+/HQzWzNP93H17ldW+d9cQz+0njPF51j58efgtj/Z9ei4qaWp1YXq3G
	2qEUKhB0ezqf774fLw7X1x4LMZFfobbveKJLyLSqmuVdH2rMl3zstvi/5NpPL2bFtZdUigzi
	r8vGxPJVvlJS6w0vyVNX01RhUmIpzkg01GIuKk4EAMhTYczBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWS2cDsrPvlYkWqwaO7whbf/vewWTRvnclo
	saQpw+LKvz2MFnOmFlps2vCExeLsvONsFuu/vmdz4PBYsKnUo7f5HZtHy7OTbB7v911l8/i8
	SS6ANYrLJiU1J7MstUjfLoEr4+zUdcwF8wQqFk34wtrA+IGni5GTQ0LARGL5pJesXYxcHEIC
	qxglnu1bxg7hfGKUWPhxITOEs4xR4tLz6cwgLWwCmhK/rqxhArFFBNQlPqy6CNbOLHCcSaLt
	0kJWkISwgLtE8+QTjBBFHhI7fzWyQdhJEj/+P2MHsVkEVCW23mkAGsTBwQtkz1hfBLFsKrPE
	5/PNYAs4BbQlZi55zwJiMwqISXw/BbGYWUBc4taT+UwQPwhILNlznhnCFpV4+fgfK4StKHH/
	+0t2iHodiQW7P7FB2HYSiw4eg5qjLbFs4WuwXl4BQYmTM5+wQPRKShxccYNlAqPELCTrZiEZ
	NQvJqFlIRs1CMmoBI+sqRvHS4uLc9Ipiw7zUcr3ixNzi0rx0veT83E2MwBg//e9w5A7Go7c+
	6h1iZOJgPMQowcGsJMJ7ckd5qhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeuw80UoUE0hNLUrNT
	UwtSi2CyTBycUg1MtoY3n5VIPah8VqzobpZomtxg+X7C3maZD9qSP4yP7pT0exz9MUqNpWPB
	99LnCc7rg2dJK+58cnXmhkMNEy55aTG7BqhJPNiu75X5LeDOlJzp2ndjzglOrb9xSdlTya6l
	xZF1Zu/n6Y2/ngU+qLv80Kj5WhQ3k/jk2Bm3JDTiHMS3eWycx/p+zvouExfudWULTq2+Wym8
	uzex8/z172vjI/Yntk7Zd/BhyoKdB1g+BW63KJTpCJP9Uet84fLTNVJPknfNVRUqPfU9dMcv
	P9fthbpF3MyW7en+O3PvvzP6nRs3KzDkQ/StP5u6DdsFTZLX7LnvE8/ivuGVentxgvGHOIEf
	sx0UK+QSNp673zdTiaU4I9FQi7moOBEA79Hr0GADAAA=
X-CMS-MailID: 20231212213444uscas1p2e84863df4d84fb9b20eff8005a1cd5d7
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
	<ZXJI5+f8bUelVXqu@ubuntu>
	<20231207162148.2631fa58.alex.williamson@redhat.com>
	<20231207234810.GN2692119@nvidia.com>
	<ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
	<20231208194159.GS2692119@nvidia.com> <ZXN3+dHzM1N5b7r+@ubuntu>
	<20231210190549.GA2944114@nvidia.com> <20231211072006.GA4870@unreal>

On Mon, Dec 11, 2023 at 09:20:06AM +0200, Leon Romanovsky wrote:
> On Sun, Dec 10, 2023 at 03:05:49PM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 08, 2023 at 08:09:34PM +0000, Jim Harris wrote:
> > >=20
> > > The store() side still keeps the device_lock(), it just also acquires=
 this
> > > new sriov lock. So store() side should observe zero differences. The =
only
> > > difference is now the show() side can acquire just the more-granular =
lock,
> > > since it is only trying to synchronize on sriov->num_VFs with the sto=
re()
> > > side. But maybe I'm missing something subtle here...
> >=20
> > Oh if that is the only goal then probably a READ_ONCE is fine

IIUC, the synchronization was to block readers of sriov_numvfs if a writer =
was
in process of the driver->sriov_configure(). Presumably sriov_configure()
can take a long time, and it was better to block the sysfs read rather than
return a stale value.

> I would say that worth to revert the patch
> 35ff867b7657 ("PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes")
> as there is no such promise that netdev devices (as presented in script
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202991), which have differe=
nt
> lifetime model will be only after sysfs changes in PF.

But I guess you're saying using the sysfs change as any kind of indicator
is wrong to begin with.

> netlink event means netdev FOO is ready and if someone needs to follow
> after sriov_numvfs, he/she should listen to sysfs events.
>=20
> In addition, I would do this change:
>=20
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 25dbe85c4217..3b768e20c7ab 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -683,8 +683,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_v=
irtfn)
>         if (rc)
>                 goto err_pcibios;
>=20
> -       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
>         iov->num_VFs =3D nr_virtfn;
> +       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);

Ack. I'll post patches for both of these suggestions.=

