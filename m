Return-Path: <kvm+bounces-28385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E9F99807A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02C93282FB9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A12C1CFECC;
	Thu, 10 Oct 2024 08:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vv35qUj2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6CB1CFEA1;
	Thu, 10 Oct 2024 08:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548849; cv=none; b=XQj5gIqZ27+ZAQMBCXT0/XHUoi/B/FA/mhca06VDRCvsg0v4SikZYCYx3sUKcy8KGWdv0ptYl70rl5wwWKJOjMHXMAXfXphkSfyjFuDbqsQepFdVgeAwNZ4SKWclzn9MJk7X6bOVkqWBijnqqtBPPqg4Mui7gHGeQYJxnjzxJJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548849; c=relaxed/simple;
	bh=rzZY48cprtyfcsN0IFx3hPhOhy+4PLUTHYa7MmTKVKw=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=eB1POyckHcPYSfVl94lv+WwRsGGeTOtJ5bx7izNFLQPYrjnkqCQjSvQWYJTKCgLVFrsITDSUo5rtg045Nac1lZFZSiaEWoJ8XSIKjWjhoBdu1sWJtlQTGPye21sfdIhpx4azzb7DGMT+TwjJaiQnWGSOZRCiT/kAbW59Ss5X6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vv35qUj2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A8KfnO004978;
	Thu, 10 Oct 2024 08:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=d3d8Kq
	yPybj9M3l25rjgI9YJQDZ0T+MpgwDByWHtNWY=; b=Vv35qUj21fI25yuyx+BfyN
	NC1UqXJgBVTY2mLwpd9x3T+EashfCupHnO7asSe6rCPU3GitY3bLTyc1g2Z8hcxN
	4DdzN4V8/reAEQuAS2pvHSy/M1dE8yO3S+sU0+X7BsRSZBG+qx77dSsvITdDfYZv
	dZGrYlixaZDhcBkH4Y0nlM7PeRs00oVnM/kbWFomLqdjMISrC9xSNkjAz/fpIWqk
	VN6sacOMDyIMeLuN4NVTGwY2x6F2c0DJVK2UY0UQIT94o8KyrVPIY3/c8y35rBlj
	Qxo+3VmSJNJo1loixCB+K6CSyW63dCjL/mWBnMRxYKRitU0I6quZiOgkXPhmYT7A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426bapg0wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:27:24 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A8ROPu019023;
	Thu, 10 Oct 2024 08:27:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426bapg0we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:27:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A5Q66U011521;
	Thu, 10 Oct 2024 08:27:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423g5xxt1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:27:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A8RJNR40173864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 08:27:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAB502004D;
	Thu, 10 Oct 2024 08:27:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B766520040;
	Thu, 10 Oct 2024 08:27:19 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.62.90])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 08:27:19 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com> <20240620141700.4124157-8-nsg@linux.ibm.com> <172476771096.31767.10959866977543273401@t14-nrb.local> <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE interpretive execution (format-0)
From: Nico Boehr <nrb@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Date: Thu, 10 Oct 2024 10:27:17 +0200
Message-ID: <172854883775.172737.10768298982142687956@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZgV8AlceKqhBppX7TTAFNSqtJ1t3iMEm
X-Proofpoint-GUID: X8m5lh50Nlc7JFse1enyorjun2Q4d7Yj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_05,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410100052

Quoting Nina Schoetterl-Glausch (2024-09-02 16:24:53)
> On Tue, 2024-08-27 at 16:08 +0200, Nico Boehr wrote:
> > Quoting Nina Schoetterl-Glausch (2024-06-20 16:17:00)
> > [...]
> > > diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> > > index a66fe56a..2bad05c5 100644
> > > --- a/lib/s390x/asm/facility.h
> > > +++ b/lib/s390x/asm/facility.h
> > > @@ -27,12 +27,20 @@ static inline void stfl(void)
> > >         asm volatile("  stfl    0(0)\n" : : : "memory");
> > >  }
> > > =20
> > > -static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
> > > +static inline unsigned int stfle(uint64_t *fac, unsigned int nb_doub=
lewords)
> >=20
> > Why unsigned int?
>=20
> The return value is 1-256, the size of the type is a bit arbitrary I supp=
ose.
>=20
> >=20
> > [...]
> > > diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> > > new file mode 100644
> > > index 00000000..eb024a6a
> > > --- /dev/null
> > > +++ b/s390x/snippets/c/stfle.c
> > [...]
> > > +int main(void)
> > > +{
> > > +       const unsigned int max_fac_len =3D 8;
> > > +       uint64_t res[max_fac_len + 1];
> > > +
> > > +       res[0] =3D max_fac_len - 1;
> > > +       asm volatile ( "lg      0,%[len]\n"
> > > +               "       stfle   %[fac]\n"
> > > +               "       stg     0,%[len]\n"
> > > +               : [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1]),

Nina, do you mind sending a new version where we have the constraints
simplified, e.g. with just a memory clobber?

