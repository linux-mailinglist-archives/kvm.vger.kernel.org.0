Return-Path: <kvm+bounces-64591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2192BC87C33
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 03:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 04F4F4E18D6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40023093AE;
	Wed, 26 Nov 2025 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KqeTLE0U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CAE14A4F0;
	Wed, 26 Nov 2025 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764122527; cv=none; b=NB84TGTY3uLsyH704oJ2pO+6Hi88Se3tURQEQfZAoucR/65OFetG3FgECNNChqCenSdsd+eqa88N/rhQ0vPhwxd+wEa4zJbAANZpOo2A4J76nQ0eZqnSo0w41Wfp/ZOBoFgkazNu3Q2TJ5Pfyvravsd+kGwF9AGA9p4avtH6P7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764122527; c=relaxed/simple;
	bh=opHBBXvWwOKsHBC5YjcPhjb3TpSy3snlEs4/OpjHkdM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WxilZJlOQTw9HjRnact9KzlAKvpTQhpW/wqJ6HHLiekqqdICncntN0rFDjEE5bV53C9GBn+xobslKAqc5xmvdh4QBvF3mIlKsoT3LqLH3al6NfzTCO8glGREzcvMwHqZqSiW0waXfUyCab6bDW4NjXf+Ob76mXtMhVtUQsIm2Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KqeTLE0U; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5APM73ZE002793;
	Wed, 26 Nov 2025 02:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8Np3pV
	tWoYZttj8Lwt+hrCM0oocjCE1pbO6G/SALgjQ=; b=KqeTLE0UEhFxXqi8xCVlc1
	BAib9fjpazzbbjBB8vRAudhtU58y82nyew7K5j0UVVKPUdwQNTMdoin4FmuBv6E4
	9LpfUVj1XLnRzhLupZE3EQtBGq8kH8dvOWv3Y8teRCuL8U0HNJOJ1fdQjuRRxMws
	xxrTwqgLoFJvzJ0j9ySD3jsthEawafMiCjb5t1IeSCcumuGQQK24StLaHkjjB5CZ
	YmdTZ9SkDtyxtUUjJwHQ+jafwAzhnTSh5AIeWW5Kqmypx3O5fkj9WWPiTl9NyfSa
	9NcBOhajyZ7d1NdZZNYMd9LQHSn0dUzLFNXWuwbMDgLkfEUKGYc17D9uqdDrpLCg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u20cak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 02:01:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ0YHn6027443;
	Wed, 26 Nov 2025 02:01:34 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4anq4h0a66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 02:01:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ21WUQ32375346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 02:01:32 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9240858056;
	Wed, 26 Nov 2025 02:01:32 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA61D58064;
	Wed, 26 Nov 2025 02:01:27 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 02:01:27 +0000 (GMT)
Message-ID: <bec71a9ee80b6493da75693808ec846cca56343b.camel@linux.ibm.com>
Subject: Re: [PATCH 3/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK
 functions
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik	
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle	 <svens@linux.ibm.com>,
        Nicholas Miehlbradt
 <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter
 Zijlstra <peterz@infradead.org>,
        Andy Lutomirski	 <luto@kernel.org>,
        David
 Hildenbrand <david@kernel.org>
Date: Wed, 26 Nov 2025 13:01:26 +1100
In-Reply-To: <20251125111618.10410Fa0-hca@linux.ibm.com>
References: 
	<20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
	 <20251125-s390-kvm-xfer-to-guest-work-v1-3-091281a34611@linux.ibm.com>
	 <20251125111618.10410Fa0-hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX5YyEJuXnn2V/
 evRsuGlE6+1TZjCxU5IJhwNHgQpYCXazWc8asZTu1qm6FS2l6IAtZvxaFBkCC5SXPPWNF9kyjr3
 ovzjXwqyeQpQMhct9h5uHl7odrH9K95zvt9SoWWfXAOz/V9AH/xlTz2wgz5430O1yVSEaXxtggz
 GXkFwDMn/N8RsKl9k+DqPgebUc6Ul1nHW6Kj3eZRD6W1R02b8db+4W+PnL7oUeHPU+fCUjoIR4s
 S3C3WrWUleiHrBARP4JxtHD+AYLVWgUulhP91jIMrZPfn3/Fybo6hBRaKG0XcV0QyDwqDGvaQJa
 6gMaf34zDaGRW1mqv1ylw6TsS9izUEFQpqfZ9jPEMUMBfZkD7fhVe3hw93DOAQNs4EKygMMqREP
 /otJPzo7XZIhwZmNtF3Mal8mEBU0gw==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=69265f7f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=4fxpYaEtckPpArMj-v8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: S9OUbt6NHIxk2mMV7Z0mdYm-9Q31keAt
X-Proofpoint-GUID: S9OUbt6NHIxk2mMV7Z0mdYm-9Q31keAt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

On Tue, 2025-11-25 at 12:16 +0100, Heiko Carstens wrote:
> On Tue, Nov 25, 2025 at 06:45:54PM +1100, Andrew Donnellan wrote:
> > Switch to using the generic infrastructure to check for and handle pend=
ing
> > work before transitioning into guest mode.
> >=20
> > xfer_to_guest_mode_handle_work() does a few more things than the curren=
t
> > code does when deciding whether or not to exit the __vcpu_run() loop. T=
he
> > exittime tests from kvm-unit-tests, in my tests, were +/-3% compared to
> > before this series, which is within noise tolerance.
>=20
> ...
>=20
> > =C2=A0		local_irq_disable();
> > +
> > +		xfer_to_guest_mode_prepare();
> > +		if (xfer_to_guest_mode_work_pending()) {
> > +			local_irq_enable();
> > +			rc =3D kvm_xfer_to_guest_mode_handle_work(vcpu);
> > +			if (rc)
> > +				break;
> > +			local_irq_disable();
> > +		}
> > +
> > =C2=A0		guest_timing_enter_irqoff();
> > =C2=A0		__disable_cpu_timer_accounting(vcpu);
>=20
> This looks racy: kvm_xfer_to_guest_mode_handle_work() returns with
> interrupts enabled and before interrupts are disabled again more work
> might have been become pending. But that is ignored and guest state is
> entered instead. Why not change the above simply to something like
> this to avoid this:
>=20
> again:
> 	local_irq_disable();
> 		xfer_to_guest_mode_prepare();
> 		if (xfer_to_guest_mode_work_pending()) {
> 			local_irq_enable();
> 			rc =3D kvm_xfer_to_guest_mode_handle_work(vcpu);
> 			if (rc)
> 				break;
> 			goto again;
> 		}
>=20
> 		guest_timing_enter_irqoff();
> 		__disable_cpu_timer_accounting(vcpu);
>=20
> But maybe I'm missing something?

Agreed, I'll restructure this and respin.

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

