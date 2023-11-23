Return-Path: <kvm+bounces-2365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C0F7F613C
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 15:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 678C31C21181
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 14:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD202FC3A;
	Thu, 23 Nov 2023 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NroqL+bL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCAB9
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 06:16:56 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANEBqIN007370
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 14:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : to : from : cc : subject : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=j/u9KvHniCTedyaXnaOM3vM6BIldleQ8y7kMDR50fMk=;
 b=NroqL+bL8YaMHdFjFvyX6+5ellTukaFjIvJ9+P89P+wYGsUF7VX6IhjymyE66Xz7D651
 WqS13Mgf2VXUtxVC/XDlYnqadHxMlwYqCNjgWKRqk75MTU0aRFwOQxK+EisH7C4wwGwc
 QG+IyLn0uTOkaD0/VhdHo4Ce9NwCIeEGjEv5LRY3ECJqLnjyYQE5AiTOsCG8tMNuI392
 yhvN3e/vilySYU/UoMixPe7luICHauCEtIFtABMsaG6j8JxoDWpzwVaH7dR6f+J6xkr9
 Qrner+Wj/sIK+JHKM/mX3RS+7ueBrRUVWVyiL4r2wWZHpy8FzQIYOqJZWfEMhH4BDGk7 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uj80urhkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 14:16:54 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ANEBvWD008492
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 14:16:53 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uj80urhfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 14:16:53 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANBIlvZ027258;
	Thu, 23 Nov 2023 14:16:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uf9tkq7f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 14:16:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ANEGV8D18416198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 14:16:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 144DC20040;
	Thu, 23 Nov 2023 14:16:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE9892004B;
	Thu, 23 Nov 2023 14:16:30 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.27.119])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Nov 2023 14:16:30 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <9326c1537567b02cc69fe854682e3e46d2a7e9c0.camel@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com> <20231110135348.245156-8-nrb@linux.ibm.com> <4c7ce0a1-5da0-4c1f-bb4c-af06167ad2f1@redhat.com> <9326c1537567b02cc69fe854682e3e46d2a7e9c0.camel@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From: Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Jan Richter <jarichte@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL 07/26] s390x: sie: ensure guests are aligned to 2GB
Message-ID: <170074899045.118078.17610514330766092950@t14-nrb>
User-Agent: alot/0.8.1
Date: Thu, 23 Nov 2023 15:16:30 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mN6LryaPok54Qp8Urj7F4_aV2AEnoBct
X-Proofpoint-GUID: 3EPEEWZB7y_YAmQPZbCIc4C6Rsvo-jev
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_12,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311230103

Quoting Nina Schoetterl-Glausch (2023-11-23 10:24:12)
> On Wed, 2023-11-22 at 12:06 +0100, Thomas Huth wrote:
> > On 10/11/2023 14.52, Nico Boehr wrote:
> > > Until now, kvm-unit-tests has aligned guests to 1 MB in the host virt=
ual
> > > address space. Unfortunately, some s390x environments require guests =
to
> > > be 2GB aligned in the host virtual address space, preventing
> > > kvm-unit-tests which act as a hypervisor from running there.
> > >=20
> > > We can't easily put guests at address 0, since we want to be able to =
run
> > > with MSO/MSL without having to maintain separate page tables for the
> > > guest physical memory. 2GB is also not a good choice, since the
> > > alloc_pages allocator will place its metadata there when the host has
> > > more than 2GB of memory. In addition, we also want a bit of space aft=
er
> > > the end of the host physical memory to be able to catch accesses beyo=
nd
> > > the end of physical memory.
> > >=20
> > > The vmalloc allocator unfortunately allocates memory starting at the
> > > highest virtual address which is not suitable for guest memory either
> > > due to additional constraints of some environments.
> > >=20
> > > The physical page allocator in memalign_pages() is also not a optimal
> > > choice, since every test running SIE would then require at least 4GB+=
1MB
> > > of physical memory.
> > >=20
> > > This results in a few quite complex allocation requirements, hence ad=
d a
> > > new function sie_guest_alloc() which allocates memory for a guest and
> > > then establishes a properly aligned virtual space mapping.
> > >=20
> > > Rework snippet test and sie tests to use the new sie_guest_alloc()
> > > function.
> > >=20
> > > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > Link: https://lore.kernel.org/r/20231106170849.1184162-3-nrb@linux.ib=
m.com
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >   lib/s390x/sie.h     |  2 ++
> > >   lib/s390x/snippet.h |  9 +++------
> > >   lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
> > >   s390x/sie.c         |  4 ++--
> > >   4 files changed, 49 insertions(+), 8 deletions(-)
> >=20
> >   Hi Nico!
> >=20
> > a colleague of mine (Jan) told me today that the current SIE-related te=
sts=20
> > of the kvm-unit-tests are failing when being run from a KVM guest (i.e.=
 when=20
> > we're testing a double-nested scenario). I've bisected the problem and =
ended=20
> > up with this patch here.
> > Could you please check whether "./run_tests.sh sie mvpg-sie spec_ex-sie=
"=20
> > still works for you from within a KVM guest?
>=20
> If you're getting a validity intercept, this should be fixed by
> KVM: s390: vsie: fix wrong VIR 37 when MSO is used
> https://lore.kernel.org/kvm/20231102153549.53984-1-imbrenda@linux.ibm.com/

After discussion with Thomas offline: yes it was a validity and yes the
patch mentioned by Nina fixes it.

Thanks.

