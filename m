Return-Path: <kvm+bounces-20683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D9291C2EF
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 255D61F22937
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5FB1C68A5;
	Fri, 28 Jun 2024 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J43rjKBB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE31DFFB;
	Fri, 28 Jun 2024 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719589852; cv=none; b=jSODXG59bOJRoKtMWSgDZkmz11gsNtyzYMBBidgrucp1Ob4CIodXc9A7kt99RZeS9KjYOQGCCOLGaDuHPNs1/Lot8+sFFc8iR8Tc1HGoFcoVPIPJGSelRdjT/hjVVe0iQmNBUSh4tNciatXbk0EmR5YyAf3fqkXDEfUO/o4R/3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719589852; c=relaxed/simple;
	bh=3xBDUaWAPSbtrsLPIy3E7265amohl3WP5YfpE6emKzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QUbg7l0RT8a/cuwQVeVA5FnripxKJXDlsSSTa+tEyQGOAr3WF6OGk7TnI+IfQPpqrvlTii5X6xBnZCtnWqeJ0E4IBiG7ZALuxc+qsUXgMiXg4yAccioN5A5nL04QXp8w2EgUkCyYefYUyH8zsHvJrblJps+P3JhZjc0pglKVFUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J43rjKBB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SFTVs1001893;
	Fri, 28 Jun 2024 15:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=X
	cn5lG5cqip9P3vf59fqc+OMgJ4Dc4XiQomJj03JvSM=; b=J43rjKBBi+HDMNAW6
	wcAmkCi6SeF3FJ3wfJbJHJkxlWYdGq7NHrkUrIyDOk/RUvulNywIln3Yi80TlDdu
	IDTYsAxWSbssGfWS3FOHLeIpEcT6GqpAoaQsiuMrNFugT8RKAod3jUTatkyMUPVH
	nOnu1Ddgk5jwi9unURZ17aVu9Dfnym3780oSBuMnICjHYzcBtA0EOxe09p5gZaCW
	TXEM5lvAOFqzZ2zxNBZBZb+w7uBBNJqwgrXY9Gwn0x2pzt7/QU8BYUGwT16AK403
	FUiT14qe47Zy3iwBIWq/xprFOQMHDg8IV9Hm2eQ+Rqt3tMJ0RYlsInulL3Y7J7/h
	JsXZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401yuhg1v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:50:49 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SFjtFS029388;
	Fri, 28 Jun 2024 15:50:48 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401yuhg1uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:50:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SCatHg008176;
	Fri, 28 Jun 2024 15:50:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9b19b72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:50:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SFofGL41222548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 15:50:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 930762004E;
	Fri, 28 Jun 2024 15:50:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E609B20043;
	Fri, 28 Jun 2024 15:50:40 +0000 (GMT)
Received: from [9.171.56.135] (unknown [9.171.56.135])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 15:50:40 +0000 (GMT)
Message-ID: <d0d1f6e1-34d3-4770-87d2-1597af9faa90@linux.ibm.com>
Date: Fri, 28 Jun 2024 17:50:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <20240627095720.8660-D-hca@linux.ibm.com>
 <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
 <20240628172259.1e172f35@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240628172259.1e172f35@p-imbrenda.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YUpHDWy9S27bsU98HsXzWqc8ppJdtTDi
X-Proofpoint-GUID: k_UIpz6R0_IwVdoJmxseaKOM0pUgh0KA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_10,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=815 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406280113

Am 28.06.24 um 17:22 schrieb Claudio Imbrenda:
> On Fri, 28 Jun 2024 16:53:20 +0200
> Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
> 
>> Am 27.06.24 um 11:57 schrieb Heiko Carstens:
>>> On Thu, Jun 27, 2024 at 11:05:20AM +0200, Christian Borntraeger wrote:
>>>> in rare cases, e.g. for injecting a machine check we do intercept all
>>>> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
>>>> LPSWEY was added. KVM needs to handle that as well.
>>>>
>>>> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
>>>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>>> ---
>>>>    arch/s390/include/asm/kvm_host.h |  1 +
>>>>    arch/s390/kvm/kvm-s390.c         |  1 +
>>>>    arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>>>>    arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>>>>    4 files changed, 50 insertions(+)
>>>
>>> ...
>>>    
>>>> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
>>>> +{
>>>> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
>>>> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> 
> long disp1 = ...
> 
>>>> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
>>>> +
>>>> +	/* The displacement is a 20bit _SIGNED_ value */
>>>> +	if (disp1 & 0x80000)
>>>> +		disp1+=0xfff00000;
> 
> disp1 = sign_extend64(disp1, 20);

Hmm, right. I was just looking at the return statement, but here it is clearly better.

Will send a v2

