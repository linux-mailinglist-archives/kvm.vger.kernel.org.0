Return-Path: <kvm+bounces-30187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7388A9B7D50
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2BE8B20E89
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E76E1A2562;
	Thu, 31 Oct 2024 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Aail3gZw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF719AD78;
	Thu, 31 Oct 2024 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386338; cv=none; b=J+2JPUlCkI39fUY/DXE6m3e/Q2gyRhAA74vVkPmaV8eMA/DW5N8MHz/ASHXu2XsRqGVtfpq5Zmj4k1Y8xZgYSFVYTXktNCPmQkEj/QYhH6qQ7YULO2k7GTDaukjk9QOCCmP35mkYFfQEr3piIImbf6Y/NCRB85JCQVBuIUPe80g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386338; c=relaxed/simple;
	bh=2nxpmqk4qNJOrhJC1KFlRwea3LTbAEa5eA1ZIPaKIsc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nDiKashDhyD/JXivP0ol5hYZMtezYd+zzELRGfvJUP31HkggvwjwUyQLeO1mNmbkAr02WN6hVrLgrn+JuQJdsxeYdSq+lexzNlYYnNz//UYOnYYQnS7nuMjDnJjYUYOdXYxxgg1xuaLSrwfYfcz+yXqLa2lP9XbR5akh04Z9M08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Aail3gZw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V2ivUw012608;
	Thu, 31 Oct 2024 14:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eMehb8
	yZLbrGamAQxaO+5FS89f8D8W8mRO1fH7L4EBE=; b=Aail3gZwnLwbhByxbfxKhy
	M9zxfaQ9+xBCXfwr10bTvme//9oaXij3VdLxOlTU5YlAndJybTePMWg2bKahVSgP
	nqcAMs5CE0Y4xbjjBpMY5OfaI+q7/M1/S6/XNIKMOhxw+fXcZ+dmid403hmiQwZx
	75P1Dh5igl1Ap7ccYf3mbXPMr0QcNjGm+GTgarquR768g6QI9tGnH/tWsZKHTkfG
	XSmHF3tLt05IZobL/c0xyd2ca0OGwnCHAGIhaYJOiaUhQyl+rG8/hZlOsVn/k6Tu
	lvwhmK+fM8GzkTXOkz5jegJ1HFuDIWn9Z34ggGYVvhDDXPI/+0wtK1O6NqRPiioA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nt5c1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:52:06 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49VElC8i007486;
	Thu, 31 Oct 2024 14:52:05 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nt5c1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:52:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VB3UHi015831;
	Thu, 31 Oct 2024 14:52:04 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hdf1mx4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:52:04 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VEq2Wd48693792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 14:52:03 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7D7B5805C;
	Thu, 31 Oct 2024 14:52:02 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDC8358051;
	Thu, 31 Oct 2024 14:52:00 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.67.19.177])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 31 Oct 2024 14:52:00 +0000 (GMT)
Message-ID: <3713941b040d7ba2528c11b820bbb362a17b33d9.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/7] virtio-mem: s390 support
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens
	 <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia
 Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hendrik
 Brueckner <brueckner@linux.ibm.com>
Date: Thu, 31 Oct 2024 10:52:00 -0400
In-Reply-To: <67a85d88-6705-4e8e-ba48-7b945aca4d8f@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
	 <20241030093453.6264-H-hca@linux.ibm.com>
	 <67a85d88-6705-4e8e-ba48-7b945aca4d8f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RZZHKLG0DjRZaVpObym4PP_q71cjF6_I
X-Proofpoint-GUID: S4IY6Vq2BQurOvyMtvCHK31wWN3P9WEN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310110

On Wed, 2024-10-30 at 17:49 +0100, Christian Borntraeger wrote:
>=20
> Am 30.10.24 um 10:34 schrieb Heiko Carstens:
> > On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
> > > Let's finally add s390 support for virtio-mem; my last RFC was sent
> > > 4 years ago, and a lot changed in the meantime.
> > >=20
> > > The latest QEMU series is available at [1], which contains some more
> > > details and a usage example on s390 (last patch).
> > >=20
> > > There is not too much in here: The biggest part is querying a new dia=
g(500)
> > > STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> >=20
> > ...
> >=20
> > > David Hildenbrand (7):
> > >    Documentation: s390-diag.rst: make diag500 a generic KVM hypercall
> > >    Documentation: s390-diag.rst: document diag500(STORAGE LIMIT)
> > >      subfunction
> > >    s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KV=
M
> > >      memory devices
> > >    virtio-mem: s390 support
> > >    lib/Kconfig.debug: default STRICT_DEVMEM to "y" on s390
> > >    s390/sparsemem: reduce section size to 128 MiB
> > >    s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_N=
UMA
> > >=20
> > >   Documentation/virt/kvm/s390/s390-diag.rst | 35 +++++++++++++----
> > >   arch/s390/boot/physmem_info.c             | 47 ++++++++++++++++++++=
++-
> > >   arch/s390/boot/startup.c                  |  7 +++-
> > >   arch/s390/include/asm/physmem_info.h      |  3 ++
> > >   arch/s390/include/asm/sparsemem.h         | 10 ++++-
> > >   drivers/virtio/Kconfig                    | 12 +++---
> > >   lib/Kconfig.debug                         |  2 +-
> > >   7 files changed, 98 insertions(+), 18 deletions(-)
> >=20
> > I'll apply the whole series as soon as there are ACKs for the third
> > patch, and from the KVM guys for the whole series.
> > Christian, Janosch, Claudio?
>=20
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> for the series.
>=20
> @Eric Farman,
> Was someone from your team planning to look into this (testing, review wh=
atever)?

The guy that was testing it just got back from a long holiday. I'll ping hi=
m and see if he can chime
in here.

