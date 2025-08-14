Return-Path: <kvm+bounces-54672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93551B266C9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B40F65E27BD
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 13:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD442FFDFF;
	Thu, 14 Aug 2025 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XEyzx4cF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECDF2ECE9E;
	Thu, 14 Aug 2025 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755177168; cv=none; b=Wb8s0TSDuRWwMvzoQGJmkJJGG2ngOY4PswxHmConkqsjzmBMrjUs9YjhV8Fq/b75ojtfVY1efQ3/DjSLGRAI4y6fu4DoGeKqLTtTnXllv4ZvEKHxNxACka89S277I9iYUjAw+ZxlPZDgCpTb/Pr6l0/PIRrTYQDiA7S3J8RK0IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755177168; c=relaxed/simple;
	bh=q3iOg8uWBAI+HNqAr+Co/DVEaNTWz4/LvQSW0aF3MnA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=peUE807RTwpYmEP6qYDcHfU/lFyJKjHc7ZUhiQLKRA9ZvG9zx64FmyBALRc2mPYNQWJmuwHtJ37k1f0I34yw3cKQMasyZV/dGN6Ly/NxI/82aMC62YB6jmgZU3123sISkrIAqcnbc9IDmliLm5Y2ga+utAYlkyr0PJsc4UY62Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XEyzx4cF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EAKVHd009662;
	Thu, 14 Aug 2025 13:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7Cmn9m
	mtIgwWgcz0jEd3uU2qxXvvkBpTtvhCNP6Je80=; b=XEyzx4cFk+hP3BU71J4WKo
	rzUaDO7NT2wZpqXeQM9NMSgrZCDgfASYTbFHy58UiId7MywHcIocKOndsKLYA/q5
	a/Z7+zWwP9nVLP66PTs7PbYEOEgm19peKpw4ptEGGcb+7JEOgyKd7bk+4sTxRMmQ
	KVYIWvEvDur2d6pCjZiJ/no28HsEBtA1yo8ImL2mLyAZ49JKRDbxOjADKCqNmplt
	U2baO83fvLfmzs6uwQWUDul2Ys6enQeSUu3UzX2WW4Soi6GhvPB4cXbNXAGDJUab
	Mkb7iLTUk0v5W3Fvmv7byL+Jf3y/AP6ZM7EabI5bRktRZuyXGr0mSUBjO2Iul0Ig
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duruj675-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 13:12:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57EBRjW8017617;
	Thu, 14 Aug 2025 13:12:39 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3ux11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 13:12:39 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57EDCbYL32243990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 13:12:37 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC6C858058;
	Thu, 14 Aug 2025 13:12:37 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52DAF58059;
	Thu, 14 Aug 2025 13:12:36 +0000 (GMT)
Received: from [9.87.142.31] (unknown [9.87.142.31])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 13:12:36 +0000 (GMT)
Message-ID: <5c76f6cfb535828f6586a67bd3409981663d14d8.camel@linux.ibm.com>
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific
 function reset for zPCI
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Farhan Ali
	 <alifm@linux.ibm.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjrosato@linux.ibm.com
Date: Thu, 14 Aug 2025 15:12:35 +0200
In-Reply-To: <20250813165631.7c22ef0f.alex.williamson@redhat.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
		<20250813170821.1115-6-alifm@linux.ibm.com>
		<20250813143034.36f8c3a4.alex.williamson@redhat.com>
		<7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
	 <20250813165631.7c22ef0f.alex.williamson@redhat.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BH4VjtBXSN30zjNWgFJZzxyeU8golyrA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX9vqZFH4vdki0
 y5e3ELNccXmIZ4sgv2KtXKR634G9I1Gp7lpBMeXNtyt7pZ8hsJSOnE3mIEuWD6W60w/LfqgFUvP
 qUfP3Xe54fSRYNZT0SvA38yIBK92MqKGpy0p0uwGl0f2Jbk57JVvlXgz31oPRux8gz2l/dVnrZY
 3VIaza0aKSzEporNMWOQ8ipfbvGnHrNBPSUcBO7z4eMvabt/5CHtckIH6Kuqa0ADK65cIkYAgNj
 lnjaEAx146CX6Xu5gL8i0MyJwnPlHzHL4J75yGE/Qaqxb0uY5fzCaz2lLvvKrWpl722oExJ0GpO
 uMgTT7bfI59gMmFoYr6YMR/rfdT2fsT+a/J7ahFab2ZiIFVzM+jeluI9iLP4E+g7L2TcmzMn7nE
 5oKbEiH5
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689de0c8 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=MB7ycCNmAEwgrl9QjFcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: BH4VjtBXSN30zjNWgFJZzxyeU8golyrA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

On Wed, 2025-08-13 at 16:56 -0600, Alex Williamson wrote:
> On Wed, 13 Aug 2025 14:52:24 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>=20
> > On 8/13/2025 1:30 PM, Alex Williamson wrote:
> > > On Wed, 13 Aug 2025 10:08:19 -0700
> > > Farhan Ali <alifm@linux.ibm.com> wrote:
> > > =20
> > > > For zPCI devices we should drive a platform specific function reset
> > > > as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI d=
evice
> > > > in error state.
> > > >=20
> > > > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > > > ---
> > > >   arch/s390/pci/pci.c              |  1 +
> > > >   drivers/vfio/pci/vfio_pci_core.c |  4 ++++
> > > >   drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
> > > >   drivers/vfio/pci/vfio_pci_zdev.c | 39 +++++++++++++++++++++++++++=
+++++
> > > >   4 files changed, 49 insertions(+)
--- snip ---
> > > >  =20
> > > > +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> > > > +{
> > > > +	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
> > > > +	int rc =3D -EIO;
> > > > +
> > > > +	if (!zdev)
> > > > +		return -ENODEV;
> > > > +
> > > > +	/*
> > > > +	 * If we can't get the zdev->state_lock the device state is
> > > > +	 * currently undergoing a transition and we bail out - just
> > > > +	 * the same as if the device's state is not configured at all.
> > > > +	 */
> > > > +	if (!mutex_trylock(&zdev->state_lock))
> > > > +		return rc;
> > > > +
> > > > +	/* We can reset only if the function is configured */
> > > > +	if (zdev->state !=3D ZPCI_FN_STATE_CONFIGURED)
> > > > +		goto out;
> > > > +
> > > > +	rc =3D zpci_hot_reset_device(zdev);
> > > > +	if (rc !=3D 0)
> > > > +		goto out;
> > > > +
> > > > +	if (!vdev->pci_saved_state) {
> > > > +		pci_err(vdev->pdev, "No saved available for the device");
> > > > +		rc =3D -EIO;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	pci_dev_lock(vdev->pdev);
> > > > +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
> > > > +	pci_restore_state(vdev->pdev);
> > > > +	pci_dev_unlock(vdev->pdev);
> > > > +out:
> > > > +	mutex_unlock(&zdev->state_lock);
> > > > +	return rc;
> > > > +} =20
> > > This looks like it should be a device or arch specific reset
> > > implemented in drivers/pci, not vfio.  Thanks,
> > >=20
> > > Alex =20
> >=20
> > Are you suggesting to move this to an arch specific function? One thing=
=20
> > we need to do after the zpci_hot_reset_device, is to correctly restore=
=20
> > the config space of the device. And for vfio-pci bound devices we want=
=20
> > to restore the state of the device to when it was initially opened.
>=20
> We generally rely on the abstraction of pci_reset_function() to select
> the correct type of reset for a function scope reset.  We've gone to
> quite a bit of effort to implement all device specific resets and
> quirks in the PCI core to be re-used across the kernel.
>=20
> Calling zpci_hot_reset_device() directly seems contradictory to those
> efforts.  Should pci_reset_function() call this universally on s390x
> rather than providing access to FLR/PM/SBR reset?=C2=A0
>=20

I agree with you Alex. Still trying to figure out what's needed for
this. We already do zpci_hot_reset_device() in reset_slot() from the
s390_pci_hpc.c hotplug slot driver and that does get called via
pci_reset_hotplug_slot() and pci_reset_function(). There are a few
problems though that meant it didn't work for Farhan but I agree maybe
we can fix them for the general case. For one pci_reset_function()
via DEVICE_RESET first tries FLR but that won't work with the device in
the error state and MMIO blocked. Sadly __pci_reset_function_locked()
then concludes that other resets also won't work. So that's something
we might want to improve in general, for example maybe we need
something more like pci_dev_acpi_reset() with higher priority than FLR.

Now for pci_reset_hotplug_slot() via VFIO_DEVICE_PCI_HOT_RESET I'm not
sure why that won't work as is. @Farhan do you know?

>  Why is it
> universally correct here given the ioctl previously made use of
> standard reset mechanisms?
>=20
> The DEVICE_RESET ioctl is simply an in-place reset of the device,
> without restoring the original device state.  So we're also subtly
> changing that behavior here, presumably because we're targeting the
> specific error recovery case.  Have you considered how this might
> break non-error-recovery use cases?
>=20
> I wonder if we want a different reset mechanism for this use case
> rather than these subtle semantic changes.=20

I think an alternative to that, which Farhan actually had in the
previous internal version, is to implement
pci_error_handlers::reset_done() and do the pci_load_saved_state()
there. That would only affect the error recovery case leaving other
cases alone.

Thanks,
Niklas

