Return-Path: <kvm+bounces-60015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AA25CBD93B1
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 14:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5497C4FFCBE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 12:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292BF3126DC;
	Tue, 14 Oct 2025 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tJ09cH8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9807E3126C2;
	Tue, 14 Oct 2025 12:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760443701; cv=none; b=gTaWX6MwSArmkX/Kk/hj1N7HMNLBhI79C0W9OCUR5BygIMVaL2NfikNVnqo/zrjWtpA5IjXZJm5lHo5UTp939ki4RCD+gcuQaPfYF6Fs0BC02R/r2JVgtLWRYoaHgH5+3sq1M5oSGDLXkEodAroi2Pht9DMlkG4wcErTHxsICfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760443701; c=relaxed/simple;
	bh=U8Us9LitOmjOFaVD+CU03U1T7n7zwky1Fmp0QhaE2g0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aNI9EZIXs9rQSL9U+i9NS5yXwHvpwvpGKBY8MpPgXp1NR8cDTuRj3zH6cz6e7ubiKWCdzlQ7MFe5sh+7f3TML5kSqe7kt5bf40Zr8X63f8x+uyCOwVRDQPXqatHlM+HPYpxh8PJxRZMASdXqu9uYwdOQMcD8Vae8BGiEocHw77M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tJ09cH8Q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EAwOTY019051;
	Tue, 14 Oct 2025 12:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DhVifR
	Lnc7vi/kAk8hfEkn8P4a1dMxcx2GsrnqgU4Ks=; b=tJ09cH8QnUlTmnXLFDhAIt
	wedyNeJ/lbpHylUlnY5QiwnbtVHCKtnys0vu7o7n0COBjBIsKD694VBlFvrfDy4C
	5A72NdeYkskykquVc6bs0N/7CDR+Y+LABupDt6HmANgtteWegxMhQX1lqbFo5MYF
	3bwpEPbozX1q7FNK6eZJoNU61ZXD9UGPF53aeLtfByEMr60DmT9UmkhAwveRUykc
	QGPsjp4hsnaJk2GFVhxc7clHOs+1E8nskyoGRgc0CHQ3S+asr//1jk+0H6ngPMWt
	IpJh6QjIxaGdOgKaIsyzHf5Ba7Gjz6vmsoIg2wU+YI1kE9XvwLWPFeUMDrhGlzag
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp7s9a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 12:08:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59EAw3CY016967;
	Tue, 14 Oct 2025 12:08:00 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r32jtnta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 12:08:00 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EC7lQH49283498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:07:47 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B5C358057;
	Tue, 14 Oct 2025 12:07:59 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D4BE5805D;
	Tue, 14 Oct 2025 12:07:57 +0000 (GMT)
Received: from [9.152.212.179] (unknown [9.152.212.179])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 12:07:57 +0000 (GMT)
Message-ID: <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Farhan Ali <alifm@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
Date: Tue, 14 Oct 2025 14:07:57 +0200
In-Reply-To: <aOtL_Y6HH5-qh2jD@wunner.de>
References: <20251001151543.GB408411@p1gen4-pw042f0m>
	 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
	 <aOE1JMryY_Oa663e@wunner.de>
	 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
	 <aOQX6ZTMvekd6gWy@wunner.de>
	 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
	 <aOZoWDQV0TNh-NiM@wunner.de>
	 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
	 <aOaqEhLOzWzswx8O@wunner.de>
	 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
	 <aOtL_Y6HH5-qh2jD@wunner.de>
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
X-Proofpoint-ORIG-GUID: JmUQbcgBWQNkcK5sqL3QXpWPvzP_XgGM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA4NCBTYWx0ZWRfXzlhUiymy38ur
 1ReZu/TW3xMbWval25bT7+vHuNjoCXGDA8oMcwo2BaGB9jHQoz7MUDlhepO+6NrFCnbD4A5h57s
 drayPIpn8W8gG50D6RbJ/5DsofLiiVg2llIMl6+RJpgmXcBEDShsP0pDBFO8IKk//rEL7FQeMmu
 RfTvO4knqTO3PGGEUmzEDkp/ziNnz03DcH+OKAOK851oz/2V247/ICtXyYpmzANsK7D1j7CFmoj
 eOTj/ZB7YfAIksUAvZFQ8TmUYNCMC8hc8NSbskUUgJoWMPtSejKRtKsU/T4syLv5MKCnl5fbgV+
 y8Bil+rUOZWeANbMa1TZmiB0q+cZ95qwXVHkUkQl9BkYnReNEH9FiIEnxoi6jYH7WjsA5ZGtRLH
 d284f0usCXDj+1ztzmyE8+DB1tygHQ==
X-Proofpoint-GUID: JmUQbcgBWQNkcK5sqL3QXpWPvzP_XgGM
X-Authority-Analysis: v=2.4 cv=af5sXBot c=1 sm=1 tr=0 ts=68ee3d22 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2KVN1fEavNI1z5f3wLwA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510120084

On Sun, 2025-10-12 at 08:34 +0200, Lukas Wunner wrote:
> On Thu, Oct 09, 2025 at 11:12:03AM +0200, Niklas Schnelle wrote:
> > On Wed, 2025-10-08 at 20:14 +0200, Lukas Wunner wrote:
> > > And yet you're touching the device by trying to reset it.
> > >=20
> > > The code you're introducing in patch [01/10] only becomes necessary
> > > because you're not following the above-quoted protocol.  If you
> > > follow the protocol, patch [01/10] becomes unnecessary.
> >=20
> > I agree with your point above error_detected() should not touch the
> > device. My understanding of Farhan's series though is that it follows
> > that rule. As I understand it error_detected() is only used to inject
> > the s390 specific PCI error event into the VM using the information
> > stored in patch 7. As before vfio-pci returns
> > PCI_ERS_RESULT_CAN_RECOVER from error_detected() but then with patch 7
> > the pass-through case is detected and this gets turned into
> > PCI_ERS_RESULT_RECOVERED and the rest of the s390 recovery code gets
> > skipped. And yeah, writing it down I'm not super happy with this part,
> > maybe it would be better to have an explicit
> > PCI_ERS_RESULT_LEAVE_AS_IS.
>=20
> Thanks, that's the high-level overview I was looking for.
>=20
> It would be good to include something like this at least
> in the cover letter or additionally in the commit messages
> so that it's easier for reviewers to connect the dots.
>=20
> I was expecting paravirtualized error handling, i.e. the
> VM is aware it's virtualized and vfio essentially proxies
> the pci_ers_result return value of the driver (e.g. nvme)
> back to the host, thereby allowing the host to drive error
> recovery normally.  I'm not sure if there are technical
> reasons preventing such an approach.

It does sound technically feasible but sticking to the already
architected error reporting and recovery has clear advantages. For one
it will work with existing Linux versions without guest changes and it
also has precedent with it working already in the z/VM hypervisor for
years. I agree that there is some level of mismatch with Linux'
recovery support but I don't think that outweighs having a clean
virtualization support where the host and guest use the same interface.

>=20
> If you do want to stick with your alternative approach,
> maybe doing the error handling in the ->mmio_enabled() phase
> instead of ->error_detected() would make more sense.
> In that phase you're allowed to access the device,
> you can also attempt a local reset and return
> PCI_ERS_RESULT_RECOVERED on success.
>=20
> You'd have to return PCI_ERS_RESULT_CAN_RECOVER though
> from the ->error_detected() callback in order to progress
> to the ->mmio_enabled() step.
>=20
> Does that make sense?
>=20
> Thanks,
>=20
> Lukas

The problem with using ->mmio_enabled() is two fold. For one we
sometimes have to do a reset instead of clearing the error state, for
example if the device was not only put in the error state but also
disabled, or if the guest driver wants it, so we would also have to use
->slot_reset() and could end up with two resets. Second and more
importantly this would break the guests assumption that the device will
be in the error state with MMIO and DMA blocked when it gets an error
event. On the other hand, that's exactly the state it is in if we
report the error in the ->error_detected() callback and then skip the
rest of recovery so it can be done in the guest, likely with the exact
same Linux code. I'd assume this should be similar if QEMU/KVM wanted
to virtualize AER+DPC except that there MMIO remains accessible?

Here's an idea. Could it be an option to detect the pass-through in the
vfio-pci driver's ->error_detected() callback, possibly with feedback
from QEMU (@Alex?), and then return PCI_ERS_RESULT_RECOVERED from there
skipping the rest of recovery?

The skipping would be in-line with the below section of the
documentation i.e. "no further intervention":

  - PCI_ERS_RESULT_RECOVERED
      Driver returns this if it thinks the device is usable despite
      the error and does not need further intervention.

It's just that in this case the device really remains with MMIO and DMA
blocked, usable only in the sense that the vfio-pci + guest VM combo
knows how to use a device with MMIO and DMA blocked with the guest
recovery.

Thanks,
Niklas

