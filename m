Return-Path: <kvm+bounces-20622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 749E991AF47
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0589EB2148E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 18:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141921993A2;
	Thu, 27 Jun 2024 18:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ut63iVYr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7EA3D;
	Thu, 27 Jun 2024 18:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719514049; cv=none; b=prPHdTsVuSALnMKIIDRg4CpM7Q+hTUJy8StO3mKPEfELJo4TwO6jui5iypBoJju+B4z4YpCb0O2MQ2jvb97VZOuEK0MIFhPlBeUikAxnmjB/N6yJof0875ynHZIQ2NX2vCkmFW5pzudOriPSrldUcJsgHgXTx5SQl9BH4Kh1Vro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719514049; c=relaxed/simple;
	bh=GaCqT394L+OfOjnXqqaONMuWIgXdgFyw3HHLwRraFLI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsQOdGRw28Shfn4AUhk69erxCyD0MtyG6fv2qjC6sECgatHhdaXo2yWJdlJvZfMvXBzycg1OYTZY5VEyTDKssFt19kQY/FJxULtmQUeI/ueU7jNMDESgGpFlQmRb7CaGpVmHSORz77cdGh6NnoaqtntF4eamMSvOIrX390M2nXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ut63iVYr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RIT6Rv006551;
	Thu, 27 Jun 2024 18:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	kVqQoMWdc00828fjx8VCUxmo5WMeccVdx43pwpIg4rA=; b=Ut63iVYrQbzgkk+3
	UFU0lfgZwtqU0JDrqtZ0pRKXB0iCYSBkE33BtwdeJs8CD8ThUe+RHG1cWBrnCyYA
	Zl03VgOp0P9CZSBA4U/t5J+abllTAs4mVTZLAj9I97o99GJAyFcS5lTIXtYWG9mC
	vsQI+kkDu1ZdUhYGYlS0/qY3zF/cSYEL5N8oMMJz5YdZyo1YowJx6KrYA2XjBfeJ
	VUCmndulxCB7b/QAt/eEJAHkCICIbEsxX0jATCpTULZ8cADmtgNU6pNVhse1y+wR
	eVsiqiTTOlAdSP7efADgOWPo4vkXL99lhfyaWYslVs3tmhY9BHeDp4+NZqB1EZki
	HpC9Fw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401dcy8157-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:47:23 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RIlNWV002541;
	Thu, 27 Jun 2024 18:47:23 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401dcy8152-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:47:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RFUGlJ000574;
	Thu, 27 Jun 2024 18:47:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaenc5w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:47:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RIlGcH54591790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 18:47:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2042220043;
	Thu, 27 Jun 2024 18:47:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62B9620040;
	Thu, 27 Jun 2024 18:47:15 +0000 (GMT)
Received: from darkmoore (unknown [9.179.5.203])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 27 Jun 2024 18:47:15 +0000 (GMT)
Date: Thu, 27 Jun 2024 20:47:13 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] s390/kvm: Reject memory region operations for ucontrol
 VMs
Message-ID: <20240627204713.099e1a5d.schlameuss@linux.ibm.com>
In-Reply-To: <35cb7d12-d93b-4fbb-98fe-10ce2e6358f2@linux.ibm.com>
References: <20240624095902.29375-1-schlameuss@linux.ibm.com>
	<CABgObfYxZZdwe94u7OvHPUx+u4fDEJLnBEQbk1hdYs_Zy0D2hA@mail.gmail.com>
	<35cb7d12-d93b-4fbb-98fe-10ce2e6358f2@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uoKwXKGyxipDEj4_r9fvlrjD-pB-GlEc
X-Proofpoint-GUID: 1LVx65-JroayqNhx6hpopgKFC3PTJqRz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_14,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=651
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406270138

On Thu, 27 Jun 2024 14:32:51 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/27/24 13:53, Paolo Bonzini wrote:
> > On Mon, Jun 24, 2024 at 11:59=E2=80=AFAM Christoph Schlameuss
> > <schlameuss@linux.ibm.com> wrote: =20
> >>
> >> This change rejects the KVM_SET_USER_MEMORY_REGION and
> >> KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
> >> This is neccessary since ucontrol VMs have kvm->arch.gmap set to 0 and
> >> would thus result in a null pointer dereference further in.
> >> Memory management needs to be performed in userspace and using the
> >> ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.
> >>
> >> Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
> >> and KVM_SET_USER_MEMORY_REGION2. =20
> >=20
> > Would be nice to have a selftest for ucontrol VMs, too... just saying :)
> >=20
> > Paolo
> >  =20
>=20
> Already in the works, he just hasn't posted it yet :)
> We did do a couple rounds of internal feedback on the tests first.

I do also have a test case for this specifically, but it depends on the
base fixture. So I would send it together with that soon.

Christoph

