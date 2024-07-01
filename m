Return-Path: <kvm+bounces-20758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7D891D8E3
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 093B01C2143C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E79674079;
	Mon,  1 Jul 2024 07:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pbA1v6Nu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EA31B809;
	Mon,  1 Jul 2024 07:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818732; cv=none; b=Os3k2ho6oGaQwHxt3TFGrFQlXU738oHcLDO87Kz6N042S11MrKn+wOsn5lQjXKrFLirD5RVkvnfNundS6jHRFZDp82ZnGi6Fq0FWq8UVNhf2JWb/GzCFlC1TCQ+3eXdkmbzqMBcwT8UjnUsDRLR/wkFX92//qys1R0pQm7B7duc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818732; c=relaxed/simple;
	bh=oZrAUOlViygrq0smuBKr4c5A48n7hjcytPv9CebCKSc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EsER9q9r8liN4MGcPTQo22pzFcHgaPYwZsiaX0t6e6otuVPcCHzL5Ppl/LzmwDJ8ApRFiIpmlZwngC1sM/TrDKD46XB/ME74DzEHiSF6TyisTySWYk9vz966fBqKJa0n4ttsSd/vvx0UjyMBRcESOVVnVZHQb4wJhvTmxozobe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pbA1v6Nu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4616SxIi023043;
	Mon, 1 Jul 2024 07:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type; s=pp1; bh=L8sFWoQlLmXimW8KVRaMOStn/q
	5lBOlh15+VnGEords=; b=pbA1v6NudCXxg34vH2HqLukYOMXSSmWKdpWEw+Fiv6
	RpiFJxvR23VzmbHMFzcTS3Da0tUccmpdsCzHFQhug92BXc0mZVbqiwqL8Lk3/jTM
	xVHd36O2sw1iY2Tp+MOSdP2wEoepgtdCntgqXIMKJiJJSSSuo1EdaaAcEt+zUh4O
	PvED6GJSC/Mypf6dkmbldeSLLvSUfrqCNET48l8J0WCoTbd/S53t9108018k9Qgk
	1B9dYoRS4Fs1rsm+bDKmrbu8J8p7iODf9B97d9lEpMgIh0VsZk567w/UGx/kJW4z
	Va+25B+K24RM1iLiv09J7qV1QAKV0461Z01rFBqz4yug==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403q7p057b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:25:28 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4617PScS019015;
	Mon, 1 Jul 2024 07:25:28 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403q7p0573-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:25:28 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4617IRbL005945;
	Mon, 1 Jul 2024 07:25:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 402vktx7q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:25:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4617PKur49414652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 07:25:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B17820063;
	Mon,  1 Jul 2024 07:25:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BB672004B;
	Mon,  1 Jul 2024 07:25:20 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jul 2024 07:25:20 +0000 (GMT)
From: Sven Schnelle <svens@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
In-Reply-To: <0d870c8d-2be8-485c-9320-4f779bccf552@linux.ibm.com> (Christian
	Borntraeger's message of "Mon, 1 Jul 2024 09:21:52 +0200")
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
	<yt9do77h7ige.fsf@linux.ibm.com>
	<0d870c8d-2be8-485c-9320-4f779bccf552@linux.ibm.com>
Date: Mon, 01 Jul 2024 09:25:19 +0200
Message-ID: <yt9dfrst7ew0.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RN4uu_mxD7JJpXG3AAklYpmfTBZHiSLm
X-Proofpoint-ORIG-GUID: uHfmrP1OgM5DS_39N8XPlUZ7GeAcO4ce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_06,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0 phishscore=0
 mlxlogscore=921 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407010056

Christian Borntraeger <borntraeger@linux.ibm.com> writes:

> Am 01.07.24 um 08:08 schrieb Sven Schnelle:
>> Christian Borntraeger <borntraeger@linux.ibm.com> writes:
>> 
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 1be19cc9d73c..1a49b89706f8 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>>>   	return 0;
>>>   }
>>>   +static int handle_lpswey(struct kvm_vcpu *vcpu)
>>> +{
>>> +	psw_t new_psw;
>>> +	u64 addr;
>>> +	int rc;
>>> +	u8 ar;
>>> +
>>> +	vcpu->stat.instruction_lpswey++;
>>> +
>>> +	if (!test_kvm_facility(vcpu->kvm, 193))
>>> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>>> +
>>> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>> +
>>> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
>>> +	if (addr & 7)
>>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>>> +
>>> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
>>> +	if (rc)
>>> +		return kvm_s390_inject_prog_cond(vcpu, rc);
>>> +
>>> +	vcpu->arch.sie_block->gpsw = new_psw;
>>> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
>>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> Shouldn't the gpsw get updated with new_psw after the check? POP
>> says "The operation
>> is suppressed on all addressing and protection exceptions."
>
> Only for exception of the instruction but not for the target PSW.
> POP says:
>
> The other PSW fields which are to be loaded by the
> instruction are not checked for validity before they are
> loaded. However, immediately after loading, a speci-
> fication exception is recognized, and a program inter-
> ruption occurs, when any of the following is true for
> the newly loaded PSW

Ok, sorry for the noise.

