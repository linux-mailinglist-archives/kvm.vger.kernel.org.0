Return-Path: <kvm+bounces-36003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B3EA16C51
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBD1E18842A4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758511DFE0A;
	Mon, 20 Jan 2025 12:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KVXj4B1y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3910F1DF257;
	Mon, 20 Jan 2025 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737375945; cv=none; b=Qur8fCs9lGnoP9QjWPaSiiIzua48P5/Eq+G0rfa2Z1cZuwthbxOycEE5OWFOntZ7n+RgEMf9Ml3sILJeedxi3/fqchGD896Et5fsMFxB+UyguRbKljDOgf80WG8k/waUYUykME4iDLuy0qRSx9PywsUK/uEf8ymnfSoeMwp58t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737375945; c=relaxed/simple;
	bh=agf3O/S6lUztUqpA7NfR9k12Bq71JPmp0oOcK3vg5Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=deA2xDHbV02kVF3u2/pemFo2SI3XgsMHfv7183x1TgRMYlYkHKxn09iKgSjuZ5oyoSYPEDkSJj6vY8S06mna1cYy+41OXMADQErTu0wPwylfzQ/JD70QHXMHPYuTQZALGjWzN9KmbcISAhpT1SmI8jpYJ8rS60MpatvuiX0GqFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KVXj4B1y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K8HsIm014957;
	Mon, 20 Jan 2025 12:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kmtfN3
	Rk8XBpBEQSh8IEsEWI2vcq3Y7BjDljoDa0dxk=; b=KVXj4B1yETjYEfX87MtrSy
	4ZUBSU8YS2N/Ns1qclLI/BkOHS48QZWZkKosuKfAEe1PNwVVNSAzeDHZWA9HzCGh
	lJkzNt0ofTCbrVhDm4pCW1yfQ6/fJ1QBUwf6eXC0YdjaMghqH02ImyJnxwiwSDEs
	XGACVE1mDP8Rc13qt1rz9kF/WBgY+DG4bHT3DO+aHQdklYWYUXs+BTIKGubMQwtQ
	Dl/emfT7kyvHXutT53f/N1u240gF8eyvM8WuvVjUrzLf7QM96qLTVKdSAbw+srTs
	p5Fv7NWOQqDocFVM5PcQMD6gRAkFCQvOnvHN7buvi17KEajIW4hM51e1LhNz0qMA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4493ny44v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:25:40 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KCCXOP007040;
	Mon, 20 Jan 2025 12:25:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4493ny44ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:25:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50K904Xq032222;
	Mon, 20 Jan 2025 12:25:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 448ruje0hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:25:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KCPYPZ26542340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 12:25:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 681322024A;
	Mon, 20 Jan 2025 12:25:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FD292024D;
	Mon, 20 Jan 2025 12:25:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 12:25:33 +0000 (GMT)
Date: Mon, 20 Jan 2025 13:25:31 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: Re: [PATCH v3 04/15] KVM: s390: selftests: fix ucontrol memory
 region test
Message-ID: <20250120132531.625e2ab2@p-imbrenda>
In-Reply-To: <19a46e9e-afbd-4f83-894d-e3331c3ac956@redhat.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
	<20250117190938.93793-5-imbrenda@linux.ibm.com>
	<19a46e9e-afbd-4f83-894d-e3331c3ac956@redhat.com>
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
X-Proofpoint-ORIG-GUID: kFKPbVjjooys1u6_v-DR6IDy0NfXe_iZ
X-Proofpoint-GUID: 06alv821kbYd9V6iuaxpED91FfiAYUzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 spamscore=0 mlxlogscore=940 bulkscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200100

On Mon, 20 Jan 2025 13:12:31 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 17.01.25 20:09, Claudio Imbrenda wrote:
> > With the latest patch, attempting to create a memslot from userspace
> > will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
> > since the new memslot will collide with the internal memslot. There is
> > no simple way to bring back the previous behaviour.
> > 
> > This is not a problem, but the test needs to be fixed accordingly.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   tools/testing/selftests/kvm/s390x/ucontrol_test.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
> > index 135ee22856cf..ca18736257f8 100644
> > --- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
> > +++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
> > @@ -459,10 +459,12 @@ TEST_F(uc_kvm, uc_no_user_region)
> >   	};
> >   
> >   	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION, &region));
> > -	ASSERT_EQ(EINVAL, errno);
> > +	if (errno != EEXIST)
> > +		ASSERT_EQ(EINVAL, errno);  
> 
> ASSERT_TRUE(errno == EEXIST || errno == EINVAL)'
> 
> ?
> 

I had thought about that, but in case of failure it won't print the
failing value.

It's probably more readable with the ASSERT_EQ, I will change it.

