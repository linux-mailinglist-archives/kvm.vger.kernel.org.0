Return-Path: <kvm+bounces-3882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C6980957D
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 23:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7291CB20D4C
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 22:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61E557320;
	Thu,  7 Dec 2023 22:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G2lEU+q+"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29467133;
	Thu,  7 Dec 2023 14:38:29 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20231207223824usoutp018529c2370b10bcc6e0ff00dace0cbde8~erbWqvGet2412324123usoutp014;
	Thu,  7 Dec 2023 22:38:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20231207223824usoutp018529c2370b10bcc6e0ff00dace0cbde8~erbWqvGet2412324123usoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1701988705;
	bh=oEmnfVAsY1dOI/pQf9I4bPt/Tnpohu9BwqrBo9tC190=;
	h=From:To:Subject:Date:References:From;
	b=G2lEU+q+FU1fKGQ1iGkPLya5diQsCAQDdmPsGFBAHcqF3bdQPeNV0dwilkIR8J/hw
	 HOXZbYpTOLgYCmvMDZgUvpiKa7aAemh1C6hC5NEHYF8FV1Ed1Xok8XAg87Fjsi1z8R
	 zM1tVsmIN2OLNX65Tcvby5qDgRFwrR2fr75rRNlg=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20231207223824uscas1p1aa3d463237f8ba1b6a899f373e8e63c7~erbWeNsjQ2550225502uscas1p14;
	Thu,  7 Dec 2023 22:38:24 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id 5A.8B.09550.06942756; Thu, 
	7 Dec 2023 17:38:24 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9~erbWFyKxW0755007550uscas1p26;
	Thu,  7 Dec 2023 22:38:24 +0000 (GMT)
X-AuditID: cbfec370-933ff7000000254e-53-65724960964e
Received: from SSI-EX2.ssi.samsung.com ( [105.128.3.67]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id B1.30.09511.06942756; Thu, 
	7 Dec 2023 17:38:24 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 7 Dec 2023 14:38:23 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Thu,
	7 Dec 2023 14:38:23 -0800
From: Jim Harris <jim.harris@samsung.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ben@nvidia.com"
	<ben@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
Subject: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZQ==
Date: Thu, 7 Dec 2023 22:38:23 +0000
Message-ID: <ZXJI5+f8bUelVXqu@ubuntu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EC6AB01C89AA14CBAE9C5A80CB308F0@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djX87oJnkWpBo9/aVh8+9/DZtG8dSaj
	xZKmDIsr//YwWsyZWmhxdt5xNgc2jwWbSj16m9+xebzfd5XN4/MmuQCWKC6blNSczLLUIn27
	BK6M27NuMRe84a049L6PtYFxAXcXIyeHhICJxK2/7xm7GLk4hARWMkrcujUdymllknjzdBtT
	FyMHWNXPxlSI+BpGiVdv5rNDOB8ZJfa8fsAE4SxllNj+7xcjyFw2AU2JX1fWgCVEBOYxSTTc
	284MkhAWcJaY9W4vC4gtIuAhsfNXIxuErSfRc2k5E4jNIqAi8er2SrA4r4CqRMP9HlYQm1FA
	TOL7qTVgNcwC4hK3nsxngnhCUGLR7D3MELaYxL9dD9kgbEWJ+99fskPU60gs2P2JDcK2k3iy
	8i8LhK0tsWzha2aIXYISJ2c+YYHolZQ4uOIGC8gDEgILOSS2/H0MtcxF4v/0XihbWmL6mstQ
	DdkSK9d3QMOrQKLhSBBE2Fpi4Z/1UDfzSfz99YgRooRXoqNNaAKj0iwk38xCcuksJJfOQnLp
	LCSXLmBkXcUoXlpcnJueWmycl1quV5yYW1yal66XnJ+7iRGYhE7/O1ywg/HWrY96hxiZOBgP
	MUpwMCuJ8Oacz08V4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmtoezJZSCA9sSQ1OzW1ILUIJsvE
	wSnVwDQ7Zurx+UuX6PjZ3j7fOscsct3qfZy/vnH0R1de/5Bs9kpj2jfLxa8/rXpwk9V42hK1
	if7/lsxK19MJ1NiXod60RnhZotPLt2FltwK+XitYevrM+rs676frVSUamgt+22jAdpnX96/B
	ru1/vWyWy5wJt/Rz8stfVNr746ulSrNEAculGEceQyEV9U9FSVM494nmZC9d++623CF5hpKV
	kR27whs4rU3v/dx4UEk/2X4RA/vKTWuDd58/2uCz+5x+yI3rX5SFmlQb3M/eXRiR/VezRktg
	3j71e2v+yElPXXTkjfYbuZ0T57f+1D1w6m3n9j0sYlPntKVyykctkVto/45hxvHisgCFNU/T
	Vl3gb7uqxFKckWioxVxUnAgAhYlJ+LEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWS2cDsrJvgWZRq8PkWr8W3/z1sFs1bZzJa
	LGnKsLjybw+jxZyphRZn5x1nc2DzWLCp1KO3+R2bx/t9V9k8Pm+SC2CJ4rJJSc3JLEst0rdL
	4Mq4PesWc8Eb3opD7/tYGxgXcHcxcnBICJhI/GxM7WLk5BASWMUo0TvVqIuRC8j+yChxY+s0
	FojEUkaJjmfuIDabgKbErytrmECKRATmMEmc3nyEFSQhLOAsMevdXrAGEQEPiZ2/GtkgbD2J
	nkvLmUBsFgEViVe3V4LFeQVUJRru94D1MgqISXw/tQashllAXOLWk/lgtoSAgMSSPeeZIWxR
	iZeP/7FC2IoS97+/ZIeo15FYsPsTG4RtJ/Fk5V8WCFtbYtnC18wQuwQlTs58wgLRKylxcMUN
	lgmMorOQrJuFZNQsJKNmIRk1C8moBYysqxjFS4uLc9Mrio3zUsv1ihNzi0vz0vWS83M3MQLj
	7vS/wzE7GO/d+qh3iJGJg/EQowQHs5IIb875/FQh3pTEyqrUovz4otKc1OJDjNIcLErivHcf
	aKQKCaQnlqRmp6YWpBbBZJk4OKUamLimv12w5tMEMY1NZ9gPRNfL7RG/MvEJz1SmiIp3yeJ5
	2ueYq5/lRPIYzPsRyOmZGblj/dy3Mf3/D14TNhNPVvL1M7QUtpvwmtvg+r0jT5fICJvmc9l9
	lX57bn9CyC35z7sOK7I5T7u4eOHh8qkywttc4yfq/n0jmsmxNvxqbUG3Sdaddd9F1694E7ig
	+MmPZKUlxyMmvC75IGm068+szMaSj73v1rtz52S9eqjMnqEwt0tL16+6d3195jpO8QftbhIP
	LvD4T1PXTLwudzZl8tcFv1bcrj0wv1Zk/UuttAPn17SrvgqokPT5tT85+91dqWOrLj3Q8FZ+
	bypqxjS5iW3BO79fJ2r+iR35o8BvWKDEUpyRaKjFXFScCABYBrVsKgMAAA==
X-CMS-MailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>

I am seeing a deadlock using SPDK with hotplug detection using vfio-pci
and an SR-IOV enabled NVMe SSD. It is not clear if this deadlock is intende=
d
or if it's a kernel bug.

Note: SPDK uses DPDK's PCI device enumeration framework, so I'll reference
both SPDK and DPDK in this description.

DPDK registers an eventfd with vfio for hotplug notifications. If the assoc=
iated
device is removed (i.e. write 1 to its pci sysfs remove entry), vfio
writes to the eventfd, requesting DPDK to release the device. It does this
while holding the device_lock(), and then waits for completion.

DPDK gets the notification, and passes it up to SPDK. SPDK does not release
the device immediately. It has some asynchronous operations that need to be
performed first, so it will release the device a bit later.

But before the device is released, SPDK also triggers DPDK to do a sysfs sc=
an
looking for newly inserted devices. Note that the removed device is not
completely removed yet from kernel PCI perspective - all of its sysfs entri=
es
are still available, including sriov_numvfs.

DPDK explicitly reads sriov_numvfs to see if the device is SR-IOV capable.
SPDK itself doesn't actually use this value, but it is part of the scan
triggered by SPDK and directly leads to the deadlock. sriov_numvfs_show()
deadlocks because it tries to hold device_lock() while reading the pci
device's pdev->sriov->num_VFs.

We're able to workaround this in SPDK by deferring the sysfs scan if
a device removal is in process. And maybe that is what we are supposed to
be doing, to avoid this deadlock?

Reference to SPDK issue, for some more details (plus simple repro stpes for
anyone already familiar with SPDK): https://github.com/spdk/spdk/issues/320=
5=

