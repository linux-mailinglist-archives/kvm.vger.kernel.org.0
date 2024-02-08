Return-Path: <kvm+bounces-8365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1794484E8C9
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 20:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FDD11C257AD
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 19:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308E736B1A;
	Thu,  8 Feb 2024 19:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UcbQf7Cq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD336AF5;
	Thu,  8 Feb 2024 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707419749; cv=none; b=T6fuVAh7s4BHfZGyD1ANVXO5dlHqE1QR02UvYtpktpOda8SXrZHd6MAf3GxElvpSSaxv/5WYymeXNDIo51aCg9q8nPVqoysjn8Xb1x/hP9ELo9pdeVTDEi4Tf3STAX7s0JJZoCuj30yVcU0JVVX9S8TEWc0FG8HrN0selN4ujhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707419749; c=relaxed/simple;
	bh=hue2GXyKpIcwWf5LC3q+QpK2v/7XmcOWpQlxrCNIv4U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EsTtUS0hDnD9H/yspdXXIO5rndBHnSPyFWXf/1ZCizyq2golvoQbFo09aALasPOXDu3fvM+U+IIYmnRi1FMFfhD+CvYk3xcr+a7eBJYjL9uOZzR4OT/BHmqJcqz5PvtWZ3A0HFJvi4g4tVnOMUd4CJn9bzkRIPfrDaqJFZl0EQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UcbQf7Cq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418HwH8P002927;
	Thu, 8 Feb 2024 19:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hue2GXyKpIcwWf5LC3q+QpK2v/7XmcOWpQlxrCNIv4U=;
 b=UcbQf7CqvIPfHRLPvKyyrZ27We1DeiN4rcjbcaXAX3jTkkOFBnTStKu717Tzb+tg7ipt
 W6Qhw9IEA5TFEYt9u8MaKs0T9TRwp+VSg7Vy15v7MB0DBG4hEm9vLGu1PC+m20mn2Rol
 WlYoy7NTqAMnS6OxI0IvACrBGYpiqxEsj0rnEQNwNqx7vXcCG6L1gCvVA+Hsf/QuHEOq
 D6Inv0VhfZJ5xkUwn1Gx6ePkfVoyFzjS+5ZJ3ViOcBCWQ6XPKDRlxp1RNkC0dhbtK8to
 9wt4m9g/We0kPCgcigDwFjztOV7VkHBIFtXilSgLaEW65ayqNgdDQONK9QJV2KZPKRpG iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w53tr1txg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:15:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 418J91wX007103;
	Thu, 8 Feb 2024 19:15:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w53tr1tx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:15:45 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 418HQsGT014765;
	Thu, 8 Feb 2024 19:15:45 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tp6m6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:15:45 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 418JFhN91573572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Feb 2024 19:15:44 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB5B358054;
	Thu,  8 Feb 2024 19:15:43 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F28FF58062;
	Thu,  8 Feb 2024 19:15:42 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.186.237])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Feb 2024 19:15:42 +0000 (GMT)
Message-ID: <f942bca2f992dd45999284f79ad671a17b6a5bd2.camel@linux.ibm.com>
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers
 into KVM_RUN
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
	 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David
	Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Nina Schoetterl-Glausch
	 <nsg@linux.ibm.com>
Date: Thu, 08 Feb 2024 14:15:42 -0500
In-Reply-To: <4b2729ba-d9ca-48f4-aa6d-4b421e8fa44d@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
	 <5ecbe9f3-827d-4308-90cd-84e065a76489@linux.ibm.com>
	 <84ae4b14-a514-462a-b084-4657f0353332@linux.ibm.com>
	 <4b2729ba-d9ca-48f4-aa6d-4b421e8fa44d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 27iDrsc6BCFookJ4t94P5uUIoB7J47Q2
X-Proofpoint-GUID: AOGPqpQQ_nmFBbFddhAU3kqFlSjKH-18
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_08,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=751 impostorscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080101

On Thu, 2024-02-08 at 14:51 +0100, Christian Borntraeger wrote:
>=20
>=20
> Am 08.02.24 um 13:37 schrieb Janosch Frank:
> > On 2/8/24 12:50, Christian Borntraeger wrote:
> > > Am 31.01.24 um 21:58 schrieb Eric Farman:
> > > > The routine ar_translation() is called by get_vcpu_asce(),
> > > > which is
> > > > called from a handful of places, such as an interception that
> > > > is
> > > > being handled during KVM_RUN processing. In that case, the
> > > > access
> > > > registers of the vcpu had been saved to a host_acrs struct and
> > > > then
> > > > the guest access registers loaded from the KVM_RUN struct prior
> > > > to
> > > > entering SIE. Saving them back to KVM_RUN at this point doesn't
> > > > do
> > > > any harm, since it will be done again at the end of the KVM_RUN
> > > > loop when the host access registers are restored.
> > > >=20
> > > > But that's not the only path into this code. The MEM_OP ioctl
> > > > can
> > > > be used while specifying an access register, and will arrive
> > > > here.
> > > >=20
> > > > Linux itself doesn't use the access registers for much, but it
> > > > does
> > > > squirrel the thread local storage variable into ACRs 0 and 1 in
> > > > copy_thread() [1]. This means that the MEM_OP ioctl may copy
> > > > non-zero access registers (the upper- and lower-halves of the
> > > > TLS
> > > > pointer) to the KVM_RUN struct, which will end up getting
> > > > propogated
> > > > to the guest once KVM_RUN ioctls occur. Since these are almost
> > > > certainly invalid as far as an ALET goes, an ALET Specification
> > > > Exception would be triggered if it were attempted to be used.
> > > >=20
> > > > [1] arch/s390/kernel/process.c:169
> > > >=20
> > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > ---
> > > >=20
> > > > Notes:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I've gone back and forth about wheth=
er the correct fix is
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to simply remove the save_access_reg=
s() call and inspect
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the contents from the most recent KV=
M_RUN directly,
> > > > versus
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 storing the contents locally. Both w=
ork for me but I've
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 opted for the latter, as it continue=
s to behave the same
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 as it does today but without the imp=
licit use of the
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KVM_RUN space. As it is, this is (wa=
s) the only reference
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to vcpu->run in this file, which sta=
nds out since the
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 routines are used by other callers.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Curious about others' thoughts.
> > >=20
> > > Given the main idea that we have the guest ARs loaded in the kvm
> > > module
> > > when running a guest and that the kernel does not use those. This
> > > avoids
> > > saving/restoring the ARs for all the fast path exits.
> > > The MEM_OP is indeed a separate path.
> > > So what about making this slightly slower by doing something like
> > > this
> > > (untested, white space damaged)

This idea seems to work fine for the case I was puzzling over.

> >=20
> > We could fence AR loading/storing via the the PSW address space
> > bits for more performance and not do a full sync/store regs here.
>=20
> Hmm, we would then add a conditional branch which also is not ideal.
> Maybe just load/restore the ARs instead of the full sync/save_reg
> dance?

This might work too. I'll give that a try later today.

