Return-Path: <kvm+bounces-46648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 429B9AB7EFE
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECB1A7A4CEB
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 07:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B78283FDA;
	Thu, 15 May 2025 07:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d2Lf7jJo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB3281537;
	Thu, 15 May 2025 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747294719; cv=none; b=m0LNQATIrWVDUrIwHs+n7rheeZDDe4XdKx8ZfpTDCpEmjmWreP50bIgqnqd93ii5zJHagXudSDWFetCvn17PSa7xLrKW3MAE9/SoR/1M2/d6v8F/ZqxwuDQJB50jbIawaXZvlfIhFV9/39Nqi8AetgtAQT4/hoe1cOf26FIIURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747294719; c=relaxed/simple;
	bh=phplsZW/O9dYNL/vbPGuYQ4KJhvL9BNVeAxaJubDI3s=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=oS4iRNtgeaDLe0H5m8wl35jUFu0ameFPntRciLFa25ZzR+aehNzjgv3LQZ71snJI4gE72JsjevRXmMJMMdqMGuDa1j5qj++aqDll3jL4Dnn7hfPGQdjenepvgWUDvlMmCuHJ49rUy9B9aXl1j0C9zeyL1SfIYuMzRfObnC5Su8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=d2Lf7jJo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F5sAP0012679;
	Thu, 15 May 2025 07:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=phplsZ
	W/O9dYNL/vbPGuYQ4KJhvL9BNVeAxaJubDI3s=; b=d2Lf7jJold7YgS7AoGdYHj
	av0YPkBmB/wM/obciQB02dmQXPjvFPtZOXEFaf1zMTlcN39Y9W5xXGlQz6xh4lMV
	q9Ikq+3gQ/8biZaToSJrjLkzq9bSZf9OVebVQf/94Gnq7LADCPc2kxwWIedNAU0Y
	sXETi3KNqdJYO7oCH9OLjEcmUNO1IfzA9xnBsq4EqJvNRfeadAObyTZBwncs41/v
	YjNSIpwGQDz9IC9ZRJFox2eo87lCv8oSfV2c+hPAcyNemx7/7o1SID34kNjabvoq
	pMtAogivA0G5Y2bHUz03WMOglpBsd7eLWm9ze0gCmH6iu2Krv9MynQiSYjKM95dQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46n0v6jx3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 07:38:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54F6w05E021822;
	Thu, 15 May 2025 07:38:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpryn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 07:38:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54F7cUvo34144656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 07:38:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E461020245;
	Thu, 15 May 2025 07:38:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD5F820240;
	Thu, 15 May 2025 07:38:29 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 07:38:29 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 May 2025 09:38:24 +0200
Message-Id: <D9WKA1YIC5RP.O86BJFFCWZ1H@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle"
 <svens@linux.ibm.com>, <linux-s390@vger.kernel.org>
To: "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: s390: Use ESCA instead of BSCA at VM init
X-Mailer: aerc 0.20.1
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
 <2a46072c-ef97-40a4-9bb4-fe521232dea1@redhat.com>
In-Reply-To: <2a46072c-ef97-40a4-9bb4-fe521232dea1@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=IqAecK/g c=1 sm=1 tr=0 ts=682599fa cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=ASKbZN9MqzYasXv1-bQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: NTO4GlRAQf9EaK7ep6y2n65yRpf1Z1-I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA3MyBTYWx0ZWRfX/rC45n9P0fWP D15azwTW7HTvd0iSUu0JAIJhZAwjm9WaD1pRohS8IgjzEOgRcHQ9JIzS8AAojD0MNhr40VzVl5h f8JSI1wTo+whIksDTUMqRSeiFmmJBczLhQC9UEY5Jlb0mrEHt/IeJbnnMidzr6YHU0EluzqToRi
 ZKi8vXARExskJPnbwe51DQxfiE/Fk9xayGZb9fHLoq/3KNR/iXDOQ8p568x+uJdST4HJRvR7Ipe N8XC9W6q1PYCZyg12t1CPUmlEoLraKBasXmEQM8Ty6E2/4WF/iO7PkZzd/viavcdoIbHM4wey27 l24L0mp6S0fGS7VuYoohWPjWalZXaS+P7LGEMtF/FeLhzqM9wkHRSKQhDG2yWhEO2kgL+SLdVef
 hl0QTWiNxuo+Vd6FnW53CKmIdK6rxadOH1tA1nT5XgYiyeY/9Dv0X6Dwuti9eHiMZOFEjkk4
X-Proofpoint-GUID: NTO4GlRAQf9EaK7ep6y2n65yRpf1Z1-I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_03,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxlogscore=533 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150073

On Wed May 14, 2025 at 7:34 PM CEST, David Hildenbrand wrote:
> On 14.05.25 18:34, Christoph Schlameuss wrote:
>> All modern IBM Z and Linux One machines do offer support for the
>> Extended System Control Area (ESCA). The ESCA is available since the
>> z114/z196 released in 2010.
>> KVM needs to allocate and manage the SCA for guest VMs. Prior to this
>> change the SCA was setup as Basic SCA only supporting a maximum of 64
>> vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
>> was needed to be converted to a ESCA.
>>=20
>> Instead we will now allocate the ESCA directly upon VM creation
>> simplifying the code in multiple places as well as completely removing
>> the need to convert an existing SCA.
>>=20
>> In cases where the ESCA is not supported (z10 and earlier) the use of
>> the SCA entries and with that SIGP interpretation are disabled for VMs.
>> This increases the number of exits from the VM in multiprocessor
>> scenarios and thus decreases performance.
>
> Trying to remember vsie details ... I recall that for the vsie we never=
=20
> cared about the layout, because we simply pin+forward the given block,=20
> but disable any facility that would try de-referencing the vcpu=20
> pointers. So we only pin a single page.
>
> pin_blocks() documents: "As we reuse the sca, the vcpu pointers=20
> contained in it are invalid. We must therefore not enable any facilities=
=20
> that access these pointers (e.g. SIGPIF)."
>
>
> So I assume this change here will not affect (degrade) when being run as=
=20
> a nested hypervisor, right?

That is correct. In vsie we will simply continue running in the
!kvm_s390_use_sca_entries() path as we are today. In that path we only need
access to the SCA block header or really just the ipte_control. Which is ev=
en in
the same byte position in BSCA and ESCA.

This should really only have an impact where we do not have ESCA support in=
 g1 /
g2.

--
Cheers,

Christoph

