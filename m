Return-Path: <kvm+bounces-20757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A4C991D8D9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09C741F21C55
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7ED74079;
	Mon,  1 Jul 2024 07:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="plL+kVb4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB21B809;
	Mon,  1 Jul 2024 07:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818524; cv=none; b=E+aymePdkqA3u4T6JQ8ywrDsU8bTGaocO5gTaBheuFJnTLx6n8wajqvwvTk+YVKDjbuBRl8uGgyv4CJbI7JTGUK8u8iqNZF5rh2Jng0/b1EEAsyttAg6d7Zr2A/SD9CtScX93PoRNkkvAa+r9Mp11iDtk+TDn2ZRUkyLSZLcInM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818524; c=relaxed/simple;
	bh=7PmwLoX3lTJ5mfJI+9S+V2MSG4mK6jGtpAJh3Z/Rdsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIdn4X0uqwbkfIJ4ebvQY561sa4Vcj+vG0yqsTuQNt0ZqNTx2M/gvA1xCieEW9Y9+V4EtQreiqCQjFNcgQLQxTdb+03A8tt8sDHDnJaPfUObJNCokOF3IkV0gMvoxCGWgtg0ob+4YG1EZJgu88xkRS0EbDCC3hK1cM0fFdsZ6SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=plL+kVb4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4616wtsG031947;
	Mon, 1 Jul 2024 07:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=4
	3x2lOSIXtX8OZHmyjnW4zfOByYCa8icz/74cOEfpME=; b=plL+kVb4dZJPr02dR
	EnoYzSZ6qDfMCKyiIfIU6O+qCZmMDwiw5Bdg6uWKLw1QlmqMK4rbRhgCTd96k+3d
	kdptu/9JCVH2+s/rWQ0YvWKVp720gFxs79FXD/C108yextj6L0F+FlfGEQypQ0/O
	dsNskMh3WLwBaNJaI2QL9AFw/Yg4xsYtP6iH/4KOigebymDizfLmoyz5C5jzHk97
	Z3xml/9JHTor+aLfstF/OKscl1wOcGLZJPpPktFxl2epVXb4bT/oFFjjWSkS4Wrc
	goYEpaFqImQ7XO3DMBWTwJxNqYAQW8OUdtOIoCb8KE1+IgIi3WeGGH/7A02k1tYJ
	h7VxA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403qne82ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:22:00 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4617Lxgf006251;
	Mon, 1 Jul 2024 07:21:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403qne82at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:21:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4614kFRH029195;
	Mon, 1 Jul 2024 07:21:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3mnuqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:21:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4617Lqw952166954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 07:21:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5820B2005A;
	Mon,  1 Jul 2024 07:21:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AF6E2004E;
	Mon,  1 Jul 2024 07:21:52 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Jul 2024 07:21:52 +0000 (GMT)
Message-ID: <0d870c8d-2be8-485c-9320-4f779bccf552@linux.ibm.com>
Date: Mon, 1 Jul 2024 09:21:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
To: Sven Schnelle <svens@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
 <yt9do77h7ige.fsf@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <yt9do77h7ige.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jK1VS_eBplReeiHf_G-9reGXVDMood2W
X-Proofpoint-ORIG-GUID: 33jxr0cUpD5d0cZkdKUjSHEnPK5pqHOn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_05,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407010051



Am 01.07.24 um 08:08 schrieb Sven Schnelle:
> Christian Borntraeger <borntraeger@linux.ibm.com> writes:
> 
>> in rare cases, e.g. for injecting a machine check we do intercept all
>> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
>> LPSWEY was added. KVM needs to handle that as well.
>>
>> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  1 +
>>   arch/s390/kvm/kvm-s390.c         |  1 +
>>   arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
>>   arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>>   4 files changed, 49 insertions(+)
>>
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
> 
> Shouldn't the gpsw get updated with new_psw after the check? POP says "The operation
> is suppressed on all addressing and protection exceptions."

Only for exception of the instruction but not for the target PSW.
POP says:

The other PSW fields which are to be loaded by the
instruction are not checked for validity before they are
loaded. However, immediately after loading, a speci-
fication exception is recognized, and a program inter-
ruption occurs, when any of the following is true for
the newly loaded PSW

