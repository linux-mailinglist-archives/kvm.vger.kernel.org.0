Return-Path: <kvm+bounces-2357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B325F7F5B06
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 10:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48A21B20FF6
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 09:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFEB21106;
	Thu, 23 Nov 2023 09:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Z6Pnn35y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D305C2118
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 01:24:48 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AN9MHCc015002
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 09:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wuDCmD6F1EBrFfhupzVHbpEw8pKimsSTnv16QdsEzSE=;
 b=Z6Pnn35yXIFZwuc814hCL3aKaPzQbqWsGLZ9PTEPcs8Q+Bwei5fuY0ICvm5ET1Y747aL
 B6xyDvl04SNeUXCzbc2wXGKBF0k3EE4BELXTb8FLNUqkHc8o3Z+6mLMuk5fCGrPiPvBn
 p0WB9owQ3cEJcO9Nl/rlAmvxhlLPZvD9DU/D9gRnVHzl5t6KiYStG4WwmfaHmXgKFv1Z
 vcETV9SZ3YEtLMouhjUYq716r8YpuIxsWhfGuA7vn30v0dWSd/I6xESHPU0r73z1VipR
 +ULmQnPtPtopKzZHo4XLYK1JNjdlu2Ich3zhM3wQhzLz+UjEqQKJgeNx+KCMQNCUxy9t vA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uj41vr2ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 09:24:48 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AN9NEJ2017902
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 09:24:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uj41vr2br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 09:24:47 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AN8nHed021117;
	Thu, 23 Nov 2023 09:24:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uf8kp67g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 09:24:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AN9OhjK33096028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 09:24:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FD1A2004D;
	Thu, 23 Nov 2023 09:24:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FD1B20040;
	Thu, 23 Nov 2023 09:24:42 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.39.122])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Nov 2023 09:24:42 +0000 (GMT)
Message-ID: <9326c1537567b02cc69fe854682e3e46d2a7e9c0.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests GIT PULL 07/26] s390x: sie: ensure guests are
 aligned to 2GB
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Jan
	Richter <jarichte@redhat.com>
Date: Thu, 23 Nov 2023 10:24:12 +0100
In-Reply-To: <4c7ce0a1-5da0-4c1f-bb4c-af06167ad2f1@redhat.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
	 <20231110135348.245156-8-nrb@linux.ibm.com>
	 <4c7ce0a1-5da0-4c1f-bb4c-af06167ad2f1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z4Y_Q8zj1-gDT6x_MMBiFYblnS4Oepvu
X-Proofpoint-GUID: 9amfJ95poyUMVNVpvhx7K_tBPqGgXxRv
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
 definitions=2023-11-23_07,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311230067

On Wed, 2023-11-22 at 12:06 +0100, Thomas Huth wrote:
> On 10/11/2023 14.52, Nico Boehr wrote:
> > Until now, kvm-unit-tests has aligned guests to 1 MB in the host virtual
> > address space. Unfortunately, some s390x environments require guests to
> > be 2GB aligned in the host virtual address space, preventing
> > kvm-unit-tests which act as a hypervisor from running there.
> >=20
> > We can't easily put guests at address 0, since we want to be able to run
> > with MSO/MSL without having to maintain separate page tables for the
> > guest physical memory. 2GB is also not a good choice, since the
> > alloc_pages allocator will place its metadata there when the host has
> > more than 2GB of memory. In addition, we also want a bit of space after
> > the end of the host physical memory to be able to catch accesses beyond
> > the end of physical memory.
> >=20
> > The vmalloc allocator unfortunately allocates memory starting at the
> > highest virtual address which is not suitable for guest memory either
> > due to additional constraints of some environments.
> >=20
> > The physical page allocator in memalign_pages() is also not a optimal
> > choice, since every test running SIE would then require at least 4GB+1MB
> > of physical memory.
> >=20
> > This results in a few quite complex allocation requirements, hence add a
> > new function sie_guest_alloc() which allocates memory for a guest and
> > then establishes a properly aligned virtual space mapping.
> >=20
> > Rework snippet test and sie tests to use the new sie_guest_alloc()
> > function.
> >=20
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Link: https://lore.kernel.org/r/20231106170849.1184162-3-nrb@linux.ibm.=
com
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   lib/s390x/sie.h     |  2 ++
> >   lib/s390x/snippet.h |  9 +++------
> >   lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
> >   s390x/sie.c         |  4 ++--
> >   4 files changed, 49 insertions(+), 8 deletions(-)
>=20
>   Hi Nico!
>=20
> a colleague of mine (Jan) told me today that the current SIE-related test=
s=20
> of the kvm-unit-tests are failing when being run from a KVM guest (i.e. w=
hen=20
> we're testing a double-nested scenario). I've bisected the problem and en=
ded=20
> up with this patch here.
> Could you please check whether "./run_tests.sh sie mvpg-sie spec_ex-sie"=
=20
> still works for you from within a KVM guest?

If you're getting a validity intercept, this should be fixed by
KVM: s390: vsie: fix wrong VIR 37 when MSO is used
https://lore.kernel.org/kvm/20231102153549.53984-1-imbrenda@linux.ibm.com/
>=20
>   Thanks,
>    Thomas
>=20
>=20


