Return-Path: <kvm+bounces-10812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10067870605
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423A41C23EEC
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CCC4D59C;
	Mon,  4 Mar 2024 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="StL+gEOY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74EA4D134;
	Mon,  4 Mar 2024 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709566658; cv=none; b=HivgBU54Ghsk5Xt+uhxUvpgOwQWFJu8upTfaOZzhukNsJ8kSFa1ypsN65YO7rBLC1cWv0mPyWE5jWrwFuMsMyuFi3XxCKL9kWvgTsH2SzBzQPwFDbRYgt9aA9V7q3JCf4uf/NCQJDGAqKpUhS95fwEbd9Itlu44x3RKvGmJ1heI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709566658; c=relaxed/simple;
	bh=+/cgWwnAJEgj909x707VvZAvip29LDmYCa78NoRpy5I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nn2aLc7Vp/nMMcXrtnyzwhE4xu43H0612fscAc2i5sks4RpjqyupmhMwsfRTS5qkP4H1q0nZZDLb0cEIphHoQb1wRsEEx2/KqqHG53NrBXDn8mi0ExFJHNAyYzG0+LZJ/vj35Na8GLsH1jR0TakAmbAD3KXw/b9fKgfFar6eW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=StL+gEOY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424F29CX024538;
	Mon, 4 Mar 2024 15:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=+/cgWwnAJEgj909x707VvZAvip29LDmYCa78NoRpy5I=;
 b=StL+gEOYZlipBlYvwznrTkeX94MCN/j3D4yCFVc2b4+RN4L6jzYOUcW4YvEvkCTaaAsM
 HCXRh5j3TkQAtwAauoohcMLo5C2ExwdgpQNv9bMXo8L85N56lk0jZndRlSADkqnsoW6X
 3/lQ8EPSM2XAQ4KEga16NClw+RR1HUjIUM3tonFgtIjkO8iGkH6bWrFtaKG9wEafvmFb
 aRHE1FEGB7OUXJEsUZkXYP4dgSWjGF2FxizG2w7BYze0nKeNnxbyfxFTeQnIiS3wgZtI
 5kEnFhAcwHmej8leh9+NiOXyLrl66z+z3n5hvq5JF5kjDz1frGSmZTJ2duNyO5026xgi qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wngk7h66n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 15:37:35 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 424F3PAA031824;
	Mon, 4 Mar 2024 15:37:35 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wngk7h66g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 15:37:35 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 424EMJNp031533;
	Mon, 4 Mar 2024 15:37:34 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wmgnjs44n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 15:37:34 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 424FbUvi19858136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Mar 2024 15:37:32 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 778BB58059;
	Mon,  4 Mar 2024 15:37:30 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1F7658055;
	Mon,  4 Mar 2024 15:37:29 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.11.53])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Mar 2024 15:37:29 +0000 (GMT)
Message-ID: <8fbd41c0fb16a5e10401f6c2888d44084e9af86a.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host
 intercepts
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
	 <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
	 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Date: Mon, 04 Mar 2024 10:37:29 -0500
In-Reply-To: <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
	 <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
	 <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F08tLXnEv56zjo8LsdI43Mi6RDEAzmCB
X-Proofpoint-ORIG-GUID: HmpyPlg6tjBoUxKZfEyVG7yJy1kTHYFp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_11,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=328 phishscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040119

On Mon, 2024-03-04 at 09:44 +0100, Christian Borntraeger wrote:
>=20
>=20
> Am 04.03.24 um 09:35 schrieb David Hildenbrand:
> > On 01.03.24 21:43, Eric Farman wrote:
> > > It's possible that SIE exits for work that the host needs to
> > > perform
> > > rather than something that is intended for the guest.
> > >=20
> > > A Linux guest will ignore this intercept code since there is
> > > nothing
> > > for it to do, but a more robust solution would rewind the PSW
> > > back to
> > > the SIE instruction. This will transparently resume the guest
> > > once
> > > the host completes its work, without the guest needing to process
> > > what is effectively a NOP and re-issue SIE itself.
> >=20
> > I recall that 0-intercepts are valid by the architecture. Further,
> > I recall that there were some rather tricky corner cases where
> > avoiding 0-intercepts would not be that easy.

Any chance you recall any details of those corner cases? I can try to
chase some of them down.

> >=20
> > Now, it's been a while ago, and maybe I misremember. SoI'm trusting
> > people with access to documentation can review this.
>=20
> Yes, 0-intercepts are allowed, and this also happens when LPAR has an
> exit.

From an offline conversation I'd had some months back:

"""
The arch does allow ICODE=3D0 to be stored, but it's supposed to happen
only upon a host interruption -- in which case the old PSW is supposed
to point back at the SIE, to resume guest execution if the host should
LPSW oldPSW.
"""

> So this patch is not necessary, the question is if this would be an
> valuable optimization?

It's a reasonable question. I don't think I have a reasonable way of
measuring the exit, though. :/

