Return-Path: <kvm+bounces-60493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2FFBF011F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4D53189EC4B
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 09:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C62E2ED165;
	Mon, 20 Oct 2025 09:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JQG6KNFP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03042EC54B;
	Mon, 20 Oct 2025 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760950818; cv=none; b=Xc9ht3eILrHHM6NInZwBBi3gCxsXCtITr4hHWULSG4eWBMHj8wyliobgxNZ6jAuhVrNxw1RQ+C+cF+IEeArqIUoJEb6yBGts88mgZyHpavH5Ies9L2Rno0x5wVYf+RqKHUuniFI5Ww6AZ+XEjUQ5k9Iz+xHk7YO66cN8oYmO0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760950818; c=relaxed/simple;
	bh=+jFZYr2kC50kCmKUrtMimyHdoYSmePtTF/KTisughUM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UxVZT+XqR/sUrcdJIiMupttSPsN3d3FYpbAjPf2s4zv2xdIZpgasUf7hfn/EkvH4WNMEoMppDU+om9ix0yMIXOzq97GU5gyy5BWrl1xVdnsr6jnyUDzQMIPXx8H/6iJT5jUChEFz4HTAGILPS2mxSETKaeJlvIDYQN/rPJRVtfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JQG6KNFP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8Rxad030419;
	Mon, 20 Oct 2025 08:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jVtDuk
	Gw2n+ZaQ9mM67Eub+Cmf6GKijXyww7IL5m5bE=; b=JQG6KNFPOZWEVQxw/s7mYw
	s0VtmOG4p67YOKBRlc3EiRKlYjwr03hMZBj8zlZYmkOSLPd8d0wQUTpkknDpHg6+
	PC1XgYSPRTfSx/HaNzGc/xGZdqqyIlm1xZpIwOsMFgzi0cPpny4ItpMOsdQFjWnd
	8RUTNCOY6wfRGEhugbqgw1pQ0FnqCKtF2q9NbC0gXzS7zz7pZOxWnpyNpARQqDfe
	GmoA7jrs9tG3lLWUfSruC3oyowbQV4DBmnDBKB4gHzMVyV51+hxrAFqyh7aFELno
	JDTGj0Q50eVBen1SyRlW0AZS9vfg956qBuejczuxh+mIK2Su/XjnCc06UqLbMm6g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31byjhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 08:59:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59K5cWtZ017061;
	Mon, 20 Oct 2025 08:59:51 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnkxn0ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 08:59:51 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59K8xoBQ54067622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 08:59:50 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9595B58056;
	Mon, 20 Oct 2025 08:59:50 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E984658052;
	Mon, 20 Oct 2025 08:59:48 +0000 (GMT)
Received: from [9.152.212.179] (unknown [9.152.212.179])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Oct 2025 08:59:48 +0000 (GMT)
Message-ID: <0f4776c0eac3c004d36677377525662d75752ebd.camel@linux.ibm.com>
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Farhan Ali <alifm@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
Date: Mon, 20 Oct 2025 10:59:48 +0200
In-Reply-To: <aPT26UZ41DsN5C01@wunner.de>
References: <aOE1JMryY_Oa663e@wunner.de>
	 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
	 <aOQX6ZTMvekd6gWy@wunner.de>
	 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
	 <aOZoWDQV0TNh-NiM@wunner.de>
	 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
	 <aOaqEhLOzWzswx8O@wunner.de>
	 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
	 <aOtL_Y6HH5-qh2jD@wunner.de>
	 <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
	 <aPT26UZ41DsN5C01@wunner.de>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _-3epTCZB-2k-1SE1GlAsA-TZnRTMC0M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXwDKNHQ2Uu4xz
 BaCLEkEpxgHcVQ+taR54Qu0Wwde3D7V4ySmQ4vRRMmum8P/1yhYXQkHL5Wt8GEL0EVVwwuwgjbi
 8NiVz6oozJF5I/aZhIQrtim0BSrE4Z06gldNwF8TXedVWbuv5LnU0eTelfuctQQ4OrxDxlnJRgW
 dEhh6n5gVGz1z78nNktCNF6wTu5jiz57kBghQwgP3ECm0NABZ14QLm8SdCo2sCi0HYA7LPRBcX1
 TxzVKmRH4bnH14RFmfmIWF+75oQtbSwYV7pZe6EE1gdVDkNMXG5nhMvKGliiA6825fsOM4GSNjE
 IVkPtQjTdLdAs/9YXC6o7Fr6ckEK5deZ97KSWoyEn+S/Yb/EI/yJJTmlezDpihWqAW95y5WFKQN
 gzpC69uxboMsZJql4cBIt0ouOCrZOQ==
X-Proofpoint-GUID: _-3epTCZB-2k-1SE1GlAsA-TZnRTMC0M
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68f5fa08 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=oXgQLIJDr0Oto5wQi3AA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

On Sun, 2025-10-19 at 16:34 +0200, Lukas Wunner wrote:
> On Tue, Oct 14, 2025 at 02:07:57PM +0200, Niklas Schnelle wrote:
> > On Sun, 2025-10-12 at 08:34 +0200, Lukas Wunner wrote:
> > > If you do want to stick with your alternative approach,
> > > maybe doing the error handling in the ->mmio_enabled() phase
> > > instead of ->error_detected() would make more sense.
> > > In that phase you're allowed to access the device,
> > > you can also attempt a local reset and return
> > > PCI_ERS_RESULT_RECOVERED on success.
> > >=20
> > > You'd have to return PCI_ERS_RESULT_CAN_RECOVER though
> > > from the ->error_detected() callback in order to progress
> > > to the ->mmio_enabled() step.
> >=20
> > The problem with using ->mmio_enabled() is two fold. For one we
> > sometimes have to do a reset instead of clearing the error state, for
> > example if the device was not only put in the error state but also
> > disabled, or if the guest driver wants it,
>=20
> Well in that case you could reset the device in the ->mmio_enabled() step
> from the guest using the vfio reset ioctl.
>=20
> > Second and more
> > importantly this would break the guests assumption that the device will
> > be in the error state with MMIO and DMA blocked when it gets an error
> > event. On the other hand, that's exactly the state it is in if we
> > report the error in the ->error_detected() callback
>=20
> At the risk of continuously talking past each other:
>=20
> How about this, the host notifies the guest of the error in the
> ->error_detected() callback.  The guest notifies the driver and
> collects the result (whether a reset is requested or not), then
> returns PCI_ERS_RESULT_CAN_RECOVER to the host.
>=20
> The host re-enables I/O to the device, invokes the ->mmio_detected()
> callback.  The guest then resets the device based on the result it
> collected earlier or invokes the driver's ->mmio_enabled() callback.
>=20
> If the driver returns PCI_ERS_RESULT_NEED_RESET from the
> ->mmio_enabled() callback, you can likewise reset the device from
> the guest using the ioctl method.
>=20
> My concern is that by insisting that you handle device recovery
> completely in the ->error_detected() phase, you're not complying
> with the protocol specified in Documentation/PCI/pci-error-recovery.rst
> and as a result, you have to amend the reset code in the PCI core
> because it assumes that all arches adheres to the protocol.
> In my view, that suggests that the approach needs to be reworked
> to comply with the protocol.  Then the workarounds for performing
> a reset while I/O is blocked become unnecessary.
>=20
> Thanks,
>=20
> Lukas

Yeah I think we're talking past each other a bit. In my mind we're
really not doing the recovery in ->error_detected() at all. Within that
callback we only do the notify, and then do nothing in the rest of
recovery. Only after will the guest do recovery though I do see your
point that leaving the device in the error state kind of means that
recovery is still ongoing even if we're not in the recovery handler
anymore. But then any driver could also just return
PCI_ERS_RESULT_RECOVERED in error_detected() and land us in the same
situation.=C2=A0And at least on s390 there is also the case that the device
actually enters the error state before we get the error event so we
could already race into a situation where the guest does a reset and
the device is already in the error state but we haven't seen the event
yet. And this seems inherent to hardware blocking I/O on error which by
it's nature can happen at any time.

But let's put that aside, say we want to implement your model where we
do check with the guest and its device driver. How would that work,
somehow error_detected() would have to wait for the guest to proceed
into recovery and since the guest could just not do that we'd have to
have some kind of timeout. Also we can't allow the guest to choose
PCI_ERS_RESULT_RECOVERED because otherwise we'd again be in the
situation where recovery is completed without unblocking I/O. And if we
want to stick to the architecture QEMU/KVM will have to kind of have a
mode where after being informed of ongoing recovery for a device they
intercept attempts to reset / firmware calls for reset and turn that
into the correct return. And somehow also deal with the timeout because
e.g. old Linux guests won't do recovery but there is also no
architected way for a guest to say that it does recovery.

To me this seems worse than accepting that even with PCI error
recovery,  resets can encounter PCI devices with blocked I/O which is
already true now if e.g. user-space happens to drive a reset racing
with hardware I/O blocking.

Thanks,
Niklas

