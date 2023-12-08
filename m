Return-Path: <kvm+bounces-3933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FE580AA0A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D60B71C20756
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C4F38DF5;
	Fri,  8 Dec 2023 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="h+7ugoKz"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F919AE;
	Fri,  8 Dec 2023 09:07:25 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20231208170723usoutp01ef686ac550e12a796229a24c0c626402~e6jnps0_a0264202642usoutp01e;
	Fri,  8 Dec 2023 17:07:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20231208170723usoutp01ef686ac550e12a796229a24c0c626402~e6jnps0_a0264202642usoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702055243;
	bh=THc47KYlcSLuiEYUvuwp54Hu0/VrT9VABzAuAV7fp/0=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=h+7ugoKz2zwr1v7LuCScNDgDs6pSsOyRvuDlQyCOopsMi5TGYS01NLIVuXwJ5qMSh
	 DJK6q4tOzgG+Vd0BXOzQKeL5MIALIOSeKg03QRLDxiIupHb4US7J9Zyrn0Rdg+SsUL
	 Q5h3/NzT+N4jWtd7Ju+OQxU4E6d9SULqRWhptLFc=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20231208170723uscas1p16b2522aec6c25d1e68ca76acf3c365d7~e6jngH4cE1674416744uscas1p1a;
	Fri,  8 Dec 2023 17:07:23 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id D9.C5.09678.B4D43756; Fri, 
	8 Dec 2023 12:07:23 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231208170723uscas1p2313022f2b22a2344d3d9a1dd6e46e215~e6jnDTlWH2914329143uscas1p2T;
	Fri,  8 Dec 2023 17:07:23 +0000 (GMT)
X-AuditID: cbfec36d-85fff700000025ce-2f-65734d4be193
Received: from SSI-EX2.ssi.samsung.com ( [105.128.3.66]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 66.58.09930.A4D43756; Fri, 
	8 Dec 2023 12:07:22 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Fri, 8 Dec 2023 09:07:22 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Fri,
	8 Dec 2023 09:07:22 -0800
From: Jim Harris <jim.harris@samsung.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZbCe+60AgAAHXQCAASJQAA==
Date: Fri, 8 Dec 2023 17:07:22 +0000
Message-ID: <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
In-Reply-To: <20231207234810.GN2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17011258BF67F74EBF6D308903A1D8AB@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djX87revsWpBt/vill8+9/DZtG8dSaj
	xZKmDIsr//YwWsyZWmhxdt5xNgc2jwWbSj16m9+xebzfd5XN4/MmuQCWKC6blNSczLLUIn27
	BK6M21NnMBd8lq64su4wSwPjI7EuRg4OCQETiZ8LdboYuTiEBFYySlzb/Zm9i5ETyGllkjh9
	gRXEBqnZM3UlE0TRGkaJdQ/a2CGcj4wSN75OhMosZZSY9PoUM0gLm4CmxK8ra5hAbBEBFYkT
	J86AdTALvGGUePL2CwtIQljAXaJ58glGiCIPiZ2/GtkgbCeJ/kmtYDYLUPO9rilgQ3kFbCV+
	rd4KVs8pYCSxcOIVsDijgJjE91MQy5gFxCVuPZnPBHG3oMSi2XuYIWwxiX+7HrJB2IoS97+/
	ZIeo15FYsPsTG4RtJ3F92RdGCFtbYtnC11B7BSVOznzCAtErKXFwxQ0WkGckBA5wSNz83MUI
	kXCR+LtzM5QtLXH1+lSoxdkSK9d3MEECu0Ci4UgQRNhaYuGf9UwTGFVmITl7FpKTZiE5aRaS
	k2YhOWkBI+sqRvHS4uLc9NRiw7zUcr3ixNzi0rx0veT83E2MwCR0+t/h3B2MO2591DvEyMTB
	eIhRgoNZSYQ353x+qhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeQ9uTyUIC6YklqdmpqQWpRTBZ
	Jg5OqQamWe9St4nzH/9Z9YFXUFFK/N9bx6cP9HPcz32ziuMXf2R+7ae90H2u4stxpjkLb1Z/
	KHLZaJEZUjN1sq9Z7gULlWn1DfISCaElrPInLrZ0HfVYwJrDZ2rwS8Xkcj1Py+O0kkM3TDJy
	bpdrV6vvn3ndjFPAuOqcY56Hn6TyM51HK8P+BKts9gi8PIWH+VG1+QJHHXtnm91JWmVB6SJ3
	fj9Xv5izM7qR49BkO0b9Z/mqpR/PiCf+XsVfp7diYTT38an31C+27+7TfRmrHiWx0z/5bAKj
	8/FF76a53VHjnrzBP1ns21KjDwx/ItdrCrvY+T5sPSxxf4vecu3p/+xVlBkFn/aF5QcK+ClP
	nlRVosRSnJFoqMVcVJwIAMw7vjGxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWS2cDspOvlW5xq8HufucW3/z1sFs1bZzJa
	LGnKsLjybw+jxZyphRZn5x1nc2DzWLCp1KO3+R2bx/t9V9k8Pm+SC2CJ4rJJSc3JLEst0rdL
	4Mq4PXUGc8Fn6Yor6w6zNDA+Euti5OSQEDCR2DN1JVMXIxeHkMAqRokXZ2awQzgfGSXW3PnC
	COEsZZR4t28DI0gLm4CmxK8ra5hAbBEBFYkTJ86AdTALvGGUePL2CwtIQljAXaJ58glGiCIP
	iZ2/GtkgbCeJ/kmtYDYLUPO9rinMIDavgK3Er9VbobbdYJR4OOUrWIJTwEhi4cQrYDajgJjE
	91MQm5kFxCVuPZnPBPGEgMSSPeeZIWxRiZeP/7FC2IoS97+/ZIeo15FYsPsTG4RtJ3F92RdG
	CFtbYtnC11BHCEqcnPmEBaJXUuLgihssExglZiFZNwvJqFlIRs1CMmoWklELGFlXMYqXFhfn
	plcUG+allusVJ+YWl+al6yXn525iBMbx6X+HI3cwHr31Ue8QIxMH4yFGCQ5mJRHenPP5qUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR57z7QSBUSSE8sSc1OTS1ILYLJMnFwSjUwxb9Zt2NqfXaF
	y9VrPvXz7bc2qW/eXjbvWZLgaS7ByR8KBU29P1278uKCWYmkkuTX6+2bDzcGV8VWPDFVXSbd
	5PbrZ6tuRdxJcbvtdkfq+SUfJW3zmt27+fnc0NoHG2oWtD/bEVW8/6zX25OTjB69Z5nFdNv0
	26pLnI7bM9dtend5ZQgLR/49HY5vKjY2tWtvvbUPnJfHcu6f6pczdzkf5WwP3hxxY4+g05oD
	Vw7XPgrX9rbQ2bFwUWnwg8PN8Xwp0Ue1hIuv7TCKX7q9yk2sL+2crMcu5ZbJP2Mm675/+kN1
	esTjtmel7m+/ehaU7ZE2N16jM2+d7r+9ibriGtoWLNGHXl29lqy89Mmc5A1piUosxRmJhlrM
	RcWJAGWEOXdSAwAA
X-CMS-MailID: 20231208170723uscas1p2313022f2b22a2344d3d9a1dd6e46e215
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
	<ZXJI5+f8bUelVXqu@ubuntu>
	<20231207162148.2631fa58.alex.williamson@redhat.com>
	<20231207234810.GN2692119@nvidia.com>

On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 07, 2023 at 04:21:48PM -0700, Alex Williamson wrote:
> > On Thu, 7 Dec 2023 22:38:23 +0000
> > Jim Harris <jim.harris@samsung.com> wrote:
> >=20
> > device_lock() has been a recurring problem.  We don't have a lot of
> > leeway in how we support the driver remove callback, the device needs
> > to be released.  We can't return -EBUSY and I don't think we can drop
> > the mutex while we're waiting on userspace.
>=20
> The mechanism of waiting in remove for userspace is inherently flawed,
> it can never work fully correctly. :( I've hit this many times.
>=20
> Upon remove VFIO should immediately remove itself and leave behind a
> non-functional file descriptor. Userspace should catch up eventually
> and see it is toast.
>=20
> The kernel locking model just cannot support userspace delaying this
> process.
>=20
> Jason

Maybe for now we just whack this specific mole with a separate mutex
for synchronizing access to sriov->num_VFs in the sysfs paths?
Something like this (tested on my system):

---

Author: Jim Harris <jim.harris@samsung.com>

pci: sync sriov->num_VFs sysfs access with its own mutex

If SR-IOV enabled device is held by vfio, and device is removed, vfio will =
hold
device lock and notify userspace of the removal. If userspace reads sriov_n=
umvfs
sysfs entry, that thread will be blocked since sriov_numvfs_show() also tri=
es
to acquire the device lock. If that same thread is responsible for releasin=
g the
device to vfio, it results in a deadlock.

So add a separate mutex, specifically for struct pci_sriov. Use this to
synchronize accesses to sriov_numvfs in the sysfs paths. sriov_numvfs_store=
()
will also still hold the device lock while configuring sriov.

Fixes: 35ff867b765 ("PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes"=
)

Signed-off-by: Jim Harris <jim.harris@samsung.com>

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 25dbe85c4217..8910cf6c97be 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -398,9 +398,9 @@ static ssize_t sriov_numvfs_show(struct device *dev,
 	u16 num_vfs;
=20
 	/* Serialize vs sriov_numvfs_store() so readers see valid num_VFs */
-	device_lock(&pdev->dev);
+	mutex_lock(&pdev->sriov->lock);
 	num_vfs =3D pdev->sriov->num_VFs;
-	device_unlock(&pdev->dev);
+	mutex_unlock(&pdev->sriov->lock);
=20
 	return sysfs_emit(buf, "%u\n", num_vfs);
 }
@@ -427,6 +427,7 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 		return -ERANGE;
=20
 	device_lock(&pdev->dev);
+	mutex_lock(&pdev->sriov->lock);
=20
 	if (num_vfs =3D=3D pdev->sriov->num_VFs)
 		goto exit;
@@ -468,6 +469,7 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 			 num_vfs, ret);
=20
 exit:
+	mutex_unlock(&pdev->sriov->lock);
 	device_unlock(&pdev->dev);
=20
 	if (ret < 0)
@@ -808,6 +810,7 @@ static int sriov_init(struct pci_dev *dev, int pos)
 		nres++;
 	}
=20
+	mutex_init(&iov->lock);
 	iov->pos =3D pos;
 	iov->nres =3D nres;
 	iov->ctrl =3D ctrl;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5ecbcf041179..04e636ab50e5 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -313,6 +313,7 @@ struct pci_sriov {
 	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
+	struct mutex	lock; /* for synchronizing num_VFs sysfs accesses */
 };
=20
 #ifdef CONFIG_PCI_DOE=

