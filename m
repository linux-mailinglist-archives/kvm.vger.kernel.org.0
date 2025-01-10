Return-Path: <kvm+bounces-35062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F04FFA0970A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 17:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0703D163093
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 16:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5799C212D94;
	Fri, 10 Jan 2025 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KIyGaiFm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF36212D96;
	Fri, 10 Jan 2025 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736525904; cv=none; b=MOovpb3JfUhh595Oux/ysxkZAwJgtHHiguA1Ma/Xv9ENI1uqrmIcv6zghGnV2WijC726IrxdHI+MOShcIqQGb2ie6GU9dWvQFysxdzPWpPhK1ztwCwQGTGNPwmmdiIKdQhueu6htPVybr4ntnangpkJL90xb6tnUO6MV7TSDBcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736525904; c=relaxed/simple;
	bh=zebOn2z7Y7bA1KIHBFuCvjPr05rnnG8OxlI1qlVuPgY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QoGfu81k1JL7YKCk/DiiwGl5/HfsAUqhtfEEfJi8AtyHm36PDbaMnI3OGkoussZCY8rL8PkOD9O8fjp5vUtbFgWcRAgIL/t49x2MITFnoeEI7Q8PyHff8JXZCmc1UMaqb0zFttnEN0TxnKBu5ES+aRE5LM1IN8ghO8Ip18Gngo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KIyGaiFm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AG2IGf029207;
	Fri, 10 Jan 2025 16:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VppX6O
	CsJ2qrobkCUqDqxvVsvf48Y2dxqThETNNJ3ts=; b=KIyGaiFm76jfX42okTfFs3
	NCdRLSNsinKzeFoVFEg2WpKXr6cVYkSDyT9z3bjl4nKODKRT2bjT65UNqXwwbMy6
	cp92TSg1P2sSVz6G7lRkuFrz45fqZIBmLkblcMqJ/2UoqiyAC2CXdueVLp3ACI3J
	6ZAW12kTdT3emX6FU6iP0VPByVu03LkRlHf4HFUt4D7WbJ1L9TxWIZDzJKqWV4ZT
	wOUAk2zf8mvX/YltaUj7D/8/7mx7gL1IKUVV8giO6ivh96Xqkcp2eOK/ijQuWvAT
	45bAueXy00iFUZ7nNN9wO6TPQSwQslEZmOr7O9cj1fYE0/mvVGYX6MUrhuJ0diYw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442v1q2xq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 16:18:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50ADHHa2016669;
	Fri, 10 Jan 2025 16:18:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtmaymk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 16:18:17 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50AGIDvV13500880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 16:18:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59B4C2004E;
	Fri, 10 Jan 2025 16:18:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28B982004D;
	Fri, 10 Jan 2025 16:18:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 16:18:13 +0000 (GMT)
Date: Fri, 10 Jan 2025 17:18:11 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>, <david@redhat.com>,
        <willy@infradead.org>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <nrb@linux.ibm.com>,
        <nsg@linux.ibm.com>
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
Message-ID: <20250110171811.4bc415ab@p-imbrenda>
In-Reply-To: <D6YI8R3EGSM1.3NVP352YOB8KQ@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-3-imbrenda@linux.ibm.com>
	<D6YI8R3EGSM1.3NVP352YOB8KQ@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JVJPwHd1ry8YHpAPElxfkgS1dI1-eB1u
X-Proofpoint-ORIG-GUID: JVJPwHd1ry8YHpAPElxfkgS1dI1-eB1u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100126

On Fri, 10 Jan 2025 16:40:04 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Wed Jan 8, 2025 at 7:14 PM CET, Claudio Imbrenda wrote:
> > Create fake memslots for ucontrol VMs. The fake memslots identity-map
> > userspace.
> >
> > Now memslots will always be present, and ucontrol is not a special case
> > anymore.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 42 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 38 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index ecbdd7d41230..797b8503c162 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -59,6 +59,7 @@
> >  #define LOCAL_IRQS 32
> >  #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
> >  			   (KVM_MAX_VCPUS + LOCAL_IRQS))
> > +#define UCONTROL_SLOT_SIZE SZ_4T
> >  
> >  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> >  	KVM_GENERIC_VM_STATS(),
> > @@ -3326,6 +3327,23 @@ void kvm_arch_free_vm(struct kvm *kvm)
> >  	__kvm_arch_free_vm(kvm);
> >  }
> >  
> > +static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned long addr)
> > +{
> > +	struct kvm_userspace_memory_region2 region = {
> > +		.slot = addr / UCONTROL_SLOT_SIZE,
> > +		.memory_size = UCONTROL_SLOT_SIZE,
> > +		.guest_phys_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > +		.userspace_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > +	};
> > +	struct kvm_memory_slot *slot;
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +	slot = gfn_to_memslot(kvm, addr);
> > +	if (!slot)
> > +		__kvm_set_memory_region(kvm, &region);  
> 
> This will call into kvm_arch_commit_memory_region() where
> kvm->arch.gmap will still be NULL!

Oops!

will fix



