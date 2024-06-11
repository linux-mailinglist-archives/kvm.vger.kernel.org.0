Return-Path: <kvm+bounces-19331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A22AF903F1E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6672873A2
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D751311712;
	Tue, 11 Jun 2024 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hPGRDvdH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200FD12B6C;
	Tue, 11 Jun 2024 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718117276; cv=none; b=XYpex8D38Ji1x6kYCdgj9oFetXTQ94Mxt10pkLy/omF/AvQ74BKuUSSHACmwC8RtRioNSTybDxkwoKiplmsK0/z9sjbVSXLlmwWV2n5Z7yIiQ3iM++0hmmbzCfX5fcvKmQLhW+hDYdg2SfoQ9IkLwlHdJfLuwVKZhQmY8GIpWeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718117276; c=relaxed/simple;
	bh=AeULTD+5S9SS41c0nI/MRoCWrBtmJ1IJs0puCjy5mbY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oujY0hBJWnUaEq6uUsexpxJsWioiD4s2TCav+vHc6D8GwyDgSe36Ht5YpfWRr9SbVsRLDbD+kohBiX7465O6RfKmcbl/SXox9ATmPF6vVrowerOgn0goTBS+OPmpE2hKQQig8p29qi6azFhtWf4/rrNW1RNnmLWbUlUScN8fs6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hPGRDvdH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BESNfW029557;
	Tue, 11 Jun 2024 14:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	RcKLdaAJAJdrz0gyMs5bDOkoPxNzBkjdXqDfVFLifMo=; b=hPGRDvdHriQDmaet
	258deEa69yTOZMDoG4OC46UHqdNYqEr3HzaXE+GmHn7fhOKXKYtnxxAnNDKCqGyz
	IiIXF/hXfivMEGa83LuB5ddcxuh4j+jfB8HWFtndjo0XqvcE2aX5dKZkVYhBjRKW
	WlGFQzQmLtajmuHKtlO/EOkrY0Cx9GQ0t7EnFbmrPWtXXcJl+kYzvWg642SjUwvi
	Nup36qg0DbjEtWi2k/tXiFqadKLZSRrHj3mW19HF+4rLmE4EQfT1w+m+JR7JSQtC
	MLVGBDrz8OCNXSLoi60OCsavtW2ZrwEiD/GcBG02+UyMVlmWFuXUflBqq1/6QxLW
	krzAZw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yprcb81g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 14:47:51 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BElpmP025525;
	Tue, 11 Jun 2024 14:47:51 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yprcb81g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 14:47:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BCc8Ma008700;
	Tue, 11 Jun 2024 14:47:50 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yn4b35u9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 14:47:50 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BEllBu8716808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 14:47:49 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D9DC58068;
	Tue, 11 Jun 2024 14:47:47 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4997F58067;
	Tue, 11 Jun 2024 14:47:44 +0000 (GMT)
Received: from [9.179.8.185] (unknown [9.179.8.185])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 14:47:44 +0000 (GMT)
Message-ID: <32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd
 Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 11 Jun 2024 16:47:43 +0200
In-Reply-To: <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
	 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
	 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
	 <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
	 <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3-s8JfWy1v1uEo872gFcDIzbVUKOLBY1
X-Proofpoint-GUID: SyIMNVfZVYQOBf4Ka0HeFYKN1dIO8WoS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=596 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406110104

> > >=20
--- 8< snip 8< ---
> > > > Ughh, I think I just stumbled over a problem with this. This is a
> > > > failing lock held assertion via __is_vma_write_locked() in
> > > > remap_pfn_range_notrack() but I'm not sure yet what exactly causes =
this
> > > >=20
> > > > [   67.338855] ------------[ cut here ]------------
> > > > [   67.338865] WARNING: CPU: 15 PID: 2056 at include/linux/rwsem.h:=
85 remap_pfn_range_notrack+0x596/0x5b0
> > > > [   67.338874] Modules linked in: <--- 8< --->
> > > > [   67.338931] CPU: 15 PID: 2056 Comm: vfio-test Not tainted 6.10.0=
-rc1-pci-pfault-00004-g193e3a513cee #5
> > > > [   67.338934] Hardware name: IBM 3931 A01 701 (LPAR)
> > > > [   67.338935] Krnl PSW : 0704c00180000000 000003e54c9730ea (remap_=
pfn_range_notrack+0x59a/0x5b0)
> > > > [   67.338940]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 =
CC:0 PM:0 RI:0 EA:3
> > > > [   67.338944] Krnl GPRS: 0000000000000100 000003655915fb78 000002d=
80b9a5928 000003ff7fa00000
> > > > [   67.338946]            0004008000000000 0000000000004000 0000000=
000000711 000003ff7fa04000
> > > > [   67.338948]            000002d80c533f00 000002d800000100 000002d=
81bbe6c28 000002d80b9a5928
> > > > [   67.338950]            000003ff7fa00000 000002d80c533f00 000003e=
54c973120 000003655915fab0
> > > > [   67.338956] Krnl Code: 000003e54c9730de: a708ffea            lhi=
     %r0,-22
> > > >                            000003e54c9730e2: a7f4fff6            br=
c     15,000003e54c9730ce
> > > >                           #000003e54c9730e6: af000000            mc=
      0,0
> > > >                           >000003e54c9730ea: a7f4fd6e            br=
c     15,000003e54c972bc6
> > > >                            000003e54c9730ee: af000000            mc=
      0,0
> > > >                            000003e54c9730f2: af000000            mc=
      0,0
> > > >                            000003e54c9730f6: 0707                bc=
r     0,%r7
> > > >                            000003e54c9730f8: 0707                bc=
r     0,%r7
> > > > [   67.339025] Call Trace:
> > > > [   67.339027]  [<000003e54c9730ea>] remap_pfn_range_notrack+0x59a/=
0x5b0
> > > > [   67.339032]  [<000003e54c973120>] remap_pfn_range+0x20/0x30
> > > > [   67.339035]  [<000003e4cce5396c>] vfio_pci_mmap_fault+0xec/0x1d0=
 [vfio_pci_core]
> > > > [   67.339043]  [<000003e54c977240>] handle_mm_fault+0x6b0/0x25a0
> > > > [   67.339046]  [<000003e54c966328>] fixup_user_fault+0x138/0x310
> > > > [   67.339048]  [<000003e54c63a91c>] __s390x_sys_s390_pci_mmio_read=
+0x28c/0x3a0
> > > > [   67.339051]  [<000003e54c5e200a>] do_syscall+0xea/0x120
> > > > [   67.339055]  [<000003e54d5f9954>] __do_syscall+0x94/0x140
> > > > [   67.339059]  [<000003e54d611020>] system_call+0x70/0xa0
> > > > [   67.339063] Last Breaking-Event-Address:
> > > > [   67.339065]  [<000003e54c972bc2>] remap_pfn_range_notrack+0x72/0=
x5b0
> > > > [   67.339067] ---[ end trace 0000000000000000 ]---
> > > >=20
> > >=20
> > > This has me a bit confused so far as __is_vma_write_locked() checks
> > > mmap_assert_write_locked(vma->vm_mm) but most other users of
> > > fixup_user_fault() hold mmap_read_lock() just like this code and
> > > clearly in the non page fault case we only need the read lock.
>=20
> This is likely the=20
> vm_flags_set()->vma_start_write(vma)->__is_vma_write_locked()

Yes

>=20
> which checks mmap_assert_write_locked().
>=20
> Setting VMA flags would be racy with the mmap lock in read mode.
>=20
>=20
> remap_pfn_range() documents: "this is only safe if the mm semaphore is=
=20
> held when called." which doesn't spell out if it needs to be held in=20
> write mode (which I think it does) :)

Logically this makes sense to me. At the same time it looks like
fixup_user_fault() expects the caller to only hold mmap_read_lock() as
I do here. In there it even retakes mmap_read_lock(). But then wouldn't
any fault handling by its nature need to hold the write lock?

>=20
>=20
> My best guess is: if you are using remap_pfn_range() from a fault=20
> handler (not during mmap time) you are doing something wrong, that's why=
=20
> you get that report.

@Alex: I guess so far the vfio_pci_mmap_fault() handler is only ever
triggered by "normal"/"actual" page faults where this isn't a problem?
Or could it be a problem there too?

>=20
> vmf_insert_pfn() and friends might be better alternatives, that make=20
> sure that the VMA already received the proper VMA flags at mmap time.
>=20
> > >=20
> >=20
> > And it gets weirder, as I could have sworn that I properly tested this
> > on v1, I retested with v1 (tags/sent/vfio_pci_mmap-v1 on my
> > git.kernel.org/niks and based on v6.9) and there I don't get the above
> > warning. I also made sure that it's not caused by my change to
> > "current->mm" for v2. But I'm also not hitting the checks David moved
> > into follow_pte() so yeah not sure what's going on here.
>=20
>=20
> You mean the mmap_assert_locked()? Yeah, that only checks if you have it=
=20
> in read mode, but not in write mode.
>=20

Turns out this part was just me being stupid and not running the old
version with lockdep enabled when it "worked" and this only turned into
a normal warn with commit ba168b52bf8e ("mm: use rwsem assertion macros
for mmap_lock"). Rerunning v1 with lockdep on gave me an equivalent
lockdep splat.

