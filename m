Return-Path: <kvm+bounces-20594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D1391A2C9
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A7BDB225E2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E3413AD09;
	Thu, 27 Jun 2024 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ESwzgNvH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB5713A41D;
	Thu, 27 Jun 2024 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481218; cv=none; b=hqf2ebszp9pzu+Dih8S9Cyqf/BSqv5AnWHD5dydosdYNiigPo2SLZ3O9pk5It823BVGOmkic1qg5XMKB5Oybf/Duxf7VcX7Dlc4+wgWhDgR8G1myL9uQgDOblIb3xWxU6ff9BNbieEtC07LZoFcTer/vb7yEhrraT5w9YDLFGec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481218; c=relaxed/simple;
	bh=O3/Y/pup4YwVlkg/RhQhm5mFrHvkbLGAfK6hlLz8zvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Up1QSjaEKaJMS+SsBh4F4CQBDyH+R1mU5oVYHz56ourj37ELnoYYNQ1lLXV7h0tEb5g72u82ppdOko1M6ZQsJ5UhwhdNgB85Jbp1t/QbAosqvHfz61oUZD43hc7ydnxQ0QM9zFjJ5m4WYXTIdDOkc8Pz6YoQW1gJ4LUNpuLibXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ESwzgNvH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R9SZk2005640;
	Thu, 27 Jun 2024 09:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=Y
	4HSoLp/8dzeKCYh03A2Whxd+ONxxn4c2FQXy92CTFU=; b=ESwzgNvHQqRDssf8V
	bUlZmyVzayMXZA1yRHbLD3l8Mdnih0KuugWqZ9dLXDQF+h7AQDvpokmyjNJdx6a7
	/B0AIgnduCZJMZwwTq9mozkWzuje51ZprY97JtbMCs+PVYfazHYHFM4J7F0nVnZ2
	DID+nYpdqLLhTmUrQLeWI9O4M/CZTJ29c/XxF7zMEpkA/FEikjPsJMu7craIjbi8
	4IuOtE86d65aIIuyhbieSqhkNHJD2sx5FDZZ4K01O2Pmzk4DEisrgmPIaTM0VQWm
	dIDyhmXMSWmgNK3hBWCkEh7hQ6dgoI6DQnQUJUQbEj2Jz+kSigCnSUUcsdNNBHjx
	/FxIQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4015frg0sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:40:15 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45R9eEOO026295;
	Thu, 27 Jun 2024 09:40:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4015frg0sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:40:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45R7FIMY018103;
	Thu, 27 Jun 2024 09:40:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xuj8t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:40:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45R9e8Jh57278794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 09:40:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 276572004F;
	Thu, 27 Jun 2024 09:40:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 935042004E;
	Thu, 27 Jun 2024 09:40:07 +0000 (GMT)
Received: from [9.179.9.187] (unknown [9.179.9.187])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 09:40:07 +0000 (GMT)
Message-ID: <8a894728-aa93-48fe-9556-b1e1013bfd87@linux.ibm.com>
Date: Thu, 27 Jun 2024 11:40:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <20240627112359.474cbd95@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240627112359.474cbd95@p-imbrenda.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UWDmYOs0FEfo7suIwicwyZ0QZ5KeW74t
X-Proofpoint-GUID: QX96IIcQ0rl3IbuyVhjKOjCQzMQrFlkh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270070



Am 27.06.24 um 11:23 schrieb Claudio Imbrenda:
> On Thu, 27 Jun 2024 11:05:20 +0200
> Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
> 
>> in rare cases, e.g. for injecting a machine check we do intercept all
>> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
>> LPSWEY was added. KVM needs to handle that as well.
>>
>> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> [...]
> 
>> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
>> +{
>> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
>> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
>> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
>> +
>> +	/* The displacement is a 20bit _SIGNED_ value */
>> +	if (disp1 & 0x80000)
>> +		disp1+=0xfff00000;
>> +
>> +	if (ar)
>> +		*ar = base1;
>> +
>> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
>> +}
>> +
>>   static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
>>   					      u64 *address1, u64 *address2,
>>   					      u8 *ar_b1, u8 *ar_b2)
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 1be19cc9d73c..1a49b89706f8 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> +static int handle_lpswey(struct kvm_vcpu *vcpu)
>> +{
>> +	psw_t new_psw;
>> +	u64 addr;
>> +	int rc;
>> +	u8 ar;
>> +
>> +	vcpu->stat.instruction_lpswey++;
>> +
>> +	if (!test_kvm_facility(vcpu->kvm, 193))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>> +
>> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> +
>> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
>> +	if (addr & 7)
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +
>> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
>> +	if (rc)
>> +		return kvm_s390_inject_prog_cond(vcpu, rc);
>> +
>> +	vcpu->arch.sie_block->gpsw = new_psw;
>> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +
>> +	return 0;
>> +}
> 
> looks quite straightforward, but you duplicated most of handle_lpswe.
> it would probably be cleaner to abstract the "load psw" logic, and
> convert handle_lpswe{,y} to be wrappers around it, something like
> 
> static int _handle_load_psw(struct kvm_vcpu *vcpu, unsigned long
> pswaddr)
> 
> which can then contain the old code from the "if (addr & 7)" to the end
> of the function.
> 
> 
> 
> I think it would look cleaner, but I don't have a super strong opinion
> about it

As this is a functional fix needed to properly run z16 code I would like to
minimize refactoring. I think we also need a different fix for LPSW(E) (we
should set the BEAR register).  We can do refactoring after we have fixed
everything.

