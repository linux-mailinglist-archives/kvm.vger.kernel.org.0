Return-Path: <kvm+bounces-17841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1DD8CB1A6
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F11CB1F22DEF
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CFD147C99;
	Tue, 21 May 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DMx3j1Uo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F491FBB;
	Tue, 21 May 2024 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306468; cv=none; b=ESROkmZbwp3zjrq/zmx0nFv23Rm2u9ep/UjH0gOf0IsTq5i5eqNXcLBAFxxBuxB6DnT/e6CqFZn8Si2B/zKfs4j3Vv3gXONHVwfti6ewmqIjIgmJ1YJEqmoYkK+WusxHM06Iv/fHOBWLkwjCFa71q9PW1eH5acVwErXgU+Z1iE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306468; c=relaxed/simple;
	bh=Zj7huKZVxNfJ93u1CZ7SzF/s/GZiR3mvv6b1h2pGWm4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CzjKzWL9MdNV9szWMeEYSyuwGjXcMyNz1WIJ7zVM8NBTyeKHSQjoy7PEUk1aoTxxI3IDDtjYxdObSRAoJH1+Rx9kRX3P93PzCOL28PyiZYSsr5gAF35Cp9Uhoh1edwYfKbhJUyBA5oH1lTGU7RR3v54+zLXu9WDcrRJaQ0fQUkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DMx3j1Uo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LFG95R011790;
	Tue, 21 May 2024 15:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Zj7huKZVxNfJ93u1CZ7SzF/s/GZiR3mvv6b1h2pGWm4=;
 b=DMx3j1UoDUjCKeIlY3iq+Klne2paco9kgbYfvA18ZfPaT/r9bOcSs+8YnFXMXU5XWMwb
 KfWW9BCIQAyZ2DMyZrYsXyn/rviwF3MHMbopEuyPz4yn4S09vCBqNoFXoiwrlEcphkhU
 ItUQxURLW3K+08t+18gQAaWEJ1gz35twdPKzSTdl4Pd7sPiJxLVfnz2LU28sRTIoW+5C
 s6LIx4YtR+A7YTqEIZ1kS/RzlJcHnY2spQFnSb+VhgTF22exAXkGAOTNwD8zDx6LQ+fn
 /2/u3jsOlWb5K2cX+5+DaysIiYDdz8XuMeWN3f/L356+nnxcQGwBBXBKwZHMqBtNDxUA LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8x3t02v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:47:42 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LFlgvX030595;
	Tue, 21 May 2024 15:47:42 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8x3t02ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:47:42 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LEVcve023459;
	Tue, 21 May 2024 15:47:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77np6hpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:47:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LFlZOB31129964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 15:47:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7811F2004E;
	Tue, 21 May 2024 15:47:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0006220040;
	Tue, 21 May 2024 15:47:34 +0000 (GMT)
Received: from [9.179.20.140] (unknown [9.179.20.140])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 15:47:34 +0000 (GMT)
Message-ID: <734a02fad0f7fd33e64d0e43c05643119ed63224.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson
 <alex.williamson@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
        Yishai Hadas
	 <yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess
	 <julianr@linux.ibm.com>
Date: Tue, 21 May 2024 17:47:34 +0200
In-Reply-To: <20240429223333.GS231144@ziepe.ca>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	 <20240425165604.899447-2-gbayer@linux.ibm.com>
	 <20240429200910.GQ231144@ziepe.ca>
	 <20240429161103.655b4010.alex.williamson@redhat.com>
	 <20240429223333.GS231144@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pw8pRTdIJitlYjA0ODirNKCIb7dvrejp
X-Proofpoint-ORIG-GUID: B8izk3--151l9z8RrCtAEA9nURw_kVCD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_09,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=729 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210119

On Mon, 2024-04-29 at 19:33 -0300, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2024 at 04:11:03PM -0600, Alex Williamson wrote:
> > > This isn't very performance optimal already, we take a lock on
> > > every
> > > iteration, so there isn't much point in inlining multiple copies
> > > of
> > > everything to save an branch.
> >=20
> > These macros are to reduce duplicate code blocks and the errors
> > that typically come from such duplication,=20
>=20
> But there is still quite a bit of repetition here..

I appears like duplications, I agree - but the vfio_pci_core_ioreadX
and vfio_pci_core_iowriteX accessors are exported as such, or might be
reused by way of vfio_pci_iordwrX in vfio_pci_core_do_io_rw for
arbitrarily sized read/writes, too.

> > as well as to provide type safe functions in the spirit of the
> > ioread# and iowrite# helpers.
>=20
> But it never really takes any advantage of type safety? It is making
> a memcpy..

At first, I was overwhelmed by the macro definitions, too. But after a
while I started to like the strict typing once the value came out of
memcpy or until it is memcpy'd.

>=20
> Jason
>=20


