Return-Path: <kvm+bounces-59693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3CDBC839A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 11:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81C893E3B8E
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 09:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9CB2D5A0C;
	Thu,  9 Oct 2025 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eQImvIr/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967F32D4816;
	Thu,  9 Oct 2025 09:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760001136; cv=none; b=NAtCEkUBwq6AE80RijcF1HZC+YvC2bYvqD9pM7PLzxk18kgW9Vk3DNhD5Aq99J1jLSFHea2dG7zpo/zbRakr4U1ZZZOABdtrltgE1NLQmRcLfBf4chZ1/zqeTENRwoenytliv36sEp3ScvienBU1exdp41LaBvqSVynp5VT2b+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760001136; c=relaxed/simple;
	bh=DBfWsEQ8fk+QyAzVWle14hUiYz/jGoL8fyft/szn14k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mN6otcms1YiZMWAomAvUfVXezxfUGfCWvmC4HAjz3ys5Hm5O72u1k5ylvR6QfABPyWl//pMYOsTnTNI+x+x8aIUsjv5oMlYeZHdFMCswGyvEJ71ZHXhyxzFeJ95mP08wv9CSL0xDq+r0QqH4HgrLeAIvzUrb5pavNJK9JOICWA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eQImvIr/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5995esoP031997;
	Thu, 9 Oct 2025 09:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3TT5SW
	ynHhluPgVTu7fgeHkypejhHfuydOHV9aDGu3Q=; b=eQImvIr/7itMsG64F9umiK
	N5yGYRzCfN3A3roAv6wuVaOA/umzKstmHBgCKb0X8/+01klRdBuOZ0SOSzWZroHY
	+KgUesun8vDrJ3ITre0ZXhCLQWJ3+GsNHLGc+2NgBX+LTLdx2tje5/e8pWhpadRK
	ECZK99dnuiNJDM611qr7k34zS2P37eQZUjSWz+EMiAHX1lDP6Q7rmELk3Kv2sUdI
	Bds+628YrbehMaAmNQPeosw+csPByQaYXcTh5D1GUSm8uJ9jl/TO8QaC04L+iYHF
	5GinHpsa+t8IqB2sWbGHg7yRuUr4/IAtKI3uPAvE5k83Z46TDExpiehFQumqVEOQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv823uyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 09:12:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5998G9A0022812;
	Thu, 9 Oct 2025 09:12:07 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv8vbpnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 09:12:07 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5999C5f69699846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 09:12:06 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5E1B5805A;
	Thu,  9 Oct 2025 09:12:05 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 304245805C;
	Thu,  9 Oct 2025 09:12:04 +0000 (GMT)
Received: from [9.152.212.179] (unknown [9.152.212.179])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 09:12:04 +0000 (GMT)
Message-ID: <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Lukas Wunner <lukas@wunner.de>, Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        helgaas@kernel.org, clg@redhat.com, mjrosato@linux.ibm.com
Date: Thu, 09 Oct 2025 11:12:03 +0200
In-Reply-To: <aOaqEhLOzWzswx8O@wunner.de>
References: <20250924171628.826-1-alifm@linux.ibm.com>
	 <20250924171628.826-2-alifm@linux.ibm.com>
	 <20251001151543.GB408411@p1gen4-pw042f0m>
	 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
	 <aOE1JMryY_Oa663e@wunner.de>
	 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
	 <aOQX6ZTMvekd6gWy@wunner.de>
	 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
	 <aOZoWDQV0TNh-NiM@wunner.de>
	 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
	 <aOaqEhLOzWzswx8O@wunner.de>
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
X-Authority-Analysis: v=2.4 cv=KrpAGGWN c=1 sm=1 tr=0 ts=68e77c68 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=tru8vRl8NrK3ZrvGlPcA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: nzZyoXQxXbxJEoPIw3y7BvG32i2Q0c06
X-Proofpoint-ORIG-GUID: nzZyoXQxXbxJEoPIw3y7BvG32i2Q0c06
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX8SHur6icTTL0
 g8xu/X8zWsdwu/RYd/hHq/oVbQe7emIBefdGm/CZ8VdDEljVzo9l9aAfa6GtNu5DiqXuIVlpHAn
 TrwfTfjp+PakdvPgGIq78qJqcS+7POXpFxlntgaQwtuREi8chmW4xWaZ21EQXNOZhMc2zR+JTVB
 UxONsJx+OAySRgo2InA6ZV+gcB9gcUzb+lRS+effmDemFoEbLXR0G+XS4BvChIHrKJiXbVRCVOp
 PQaIs/ZU80iRVHZElXNclKgaHSjvYd3bFIHEz402ctyFbYM1zXPw50vrh7zKpz0O5Ietowb+VZD
 e9992veDsWcZbuGY1vUe5uhOubuWYNwZtFEUiH5Y2/+WrpD9gP9XQLbSQrPUu1Uy7CT0NsDaRbV
 pBmho0bpHBmpc+pxAGUOLxXsMO30sw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

On Wed, 2025-10-08 at 20:14 +0200, Lukas Wunner wrote:
> On Wed, Oct 08, 2025 at 10:56:35AM -0700, Farhan Ali wrote:
> > On 10/8/2025 6:34 AM, Lukas Wunner wrote:
> > > I'm not sure yet.  Let's back up a little:  I'm missing an
> > > architectural description how you're intending to do error
> > > recovery in the VM.  If I understand correctly, you're
> > > informing the VM of the error via the ->error_detected() callback.
> > >=20
> > > You're saying you need to check for accessibility of the device
> > > prior to resetting it from the VM, does that mean you're attempting
> > > a reset from the ->error_detected() callback?
> > >=20
> > > According to Documentation/PCI/pci-error-recovery.rst, the device
> > > isn't supposed to be considered accessible in ->error_detected().
> > > The first callback which allows access is ->mmio_enabled().
> > >=20
> >=20
> > The ->error_detected() callback is used to inform userspace of an error=
. In
> > the case of a VM, using QEMU as a userspace, once notified of an error =
QEMU
> > will inject an error into the guest in s390x architecture specific way =
[1]
> > (probably should have linked the QEMU series in the cover letter). Once
> > notified of the error VM's device driver will drive the recovery action=
. The
> > recovery action require a reset of the device and on s390x PCI devices =
are
> > reset using architecture specific instructions (zpci_device_hot_reset()=
).
>=20
> According to Documentation/PCI/pci-error-recovery.rst:
>=20
>    "STEP 1: Notification
>     --------------------
>     Platform calls the error_detected() callback on every instance of
>     every driver affected by the error.
>     At this point, the device might not be accessible anymore, [...]
>     it gives the driver a chance to cleanup, waiting for pending stuff
>     (timers, whatever, etc...) to complete; it can take semaphores,
>     schedule, etc... everything but touch the device."
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> And yet you're touching the device by trying to reset it.
>=20
> The code you're introducing in patch [01/10] only becomes necessary
> because you're not following the above-quoted protocol.  If you
> follow the protocol, patch [01/10] becomes unnecessary.
>=20

I agree with your point above error_detected() should not touch the
device. My understanding of Farhan's series though is that it follows
that rule. As I understand it error_detected() is only used to inject
the s390 specific PCI error event into the VM using the information
stored in patch 7. As before vfio-pci returns
PCI_ERS_RESULT_CAN_RECOVER from error_detected() but then with patch 7
the pass-through case is detected and this gets turned into
PCI_ERS_RESULT_RECOVERED and the rest of the s390 recovery code gets
skipped. And yeah, writing it down I'm not super happy with this part,
maybe it would be better to have an explicit
PCI_ERS_RESULT_LEAVE_AS_IS.

Either way this leaves the PCI device in the error state just like for
the host the platform leaves the device in the error state. Up until
this point even if the VM/QEMU tried to do a reset already it would get
blocked on at least the zdev->state_lock until the recovery code is
done. Only after the VM would run its recovery code and with that drive
the reset.

> > > I also don't quite understand why the VM needs to perform a reset.
> > > Why can't you just let the VM tell the host that a reset is needed
> > > (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
> > > behalf of the VM?

The reason is that we want the behavior from the VMs perspective to
follow s390's PCI error event handling architecture. In this model
however there is no mechanism to synchroniously ask the OS "An error
occurred would you want the device reset?" or to tell it that we as
hypervisor already unblocked MMIO/DMA or performed a reset. So instead
our idea was that we just do the error_detected() part in the host's
recovery code and then leave the device as is driving the rest from the
guest.

Thanks,
Niklas

