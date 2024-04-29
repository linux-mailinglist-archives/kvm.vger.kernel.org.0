Return-Path: <kvm+bounces-16147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 215728B54EF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 12:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB7F0282614
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 10:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDC63612D;
	Mon, 29 Apr 2024 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lw3wsd5i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132EE2C85F;
	Mon, 29 Apr 2024 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714385927; cv=none; b=r2CpdLWexH3O7TNlgzmMckOxRej4XFd2K8nsAN6/xf2EQQxwKi7XC/2PHjhkcMFAkQTzawdkzlXGhcTTmUIRRcRj8XFEoU6qAbn4dU3yoRqwlnindhFh8MYpB6bJI75c07IbbdaXvKuQKKIJ3Cf24Bt/8OGo/KE2wdgpdkfB0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714385927; c=relaxed/simple;
	bh=lrnBzlZUFaIiwwD+zWnjpiLyuyRzKlI4CxEOxOa+Nuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvRMUculJ1hATda3QLqSnGWcsTo4kwxO40ybUrcOSTTw1DQ5wrbo+u5BmJJ8sHbk8Eaind/BT5gz0WC77dch/tSYZ9JAMR6BXtno+SobIy8y1UGahBkrT03Vt7wL5+p9vKsVZIR0bGPNKb6rYnNUbTS2Tp+BQ86DzX5Fm3w55Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lw3wsd5i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43T9U1UH012288;
	Mon, 29 Apr 2024 10:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y3mFoxRclm+/GG42ODAsM8073mf3OVr9Nk6cfwUjOkw=;
 b=lw3wsd5ixUyX98YhuLHqSnQwq8ZRaSXESzXMPskSCbC89HwR/kC1gKwys5RuTja+aowu
 RF50omkKjay312dWb6YntDHbgPm6Z8nceGgE1HSoO4ERNANfbBZzB1i6uzDc8K9AlDqc
 vtgsBjFEXCFw41R+43fWPxb2YM64ICFpj+i8mSRqbPt7HtAwkzYVslNTS60HGDLLEhJE
 QQSC3i0xVOJQU5YsJM6AMGnkafG2Fp2r4haxmLFwQ38FEaKx7V0wy6QSWXrU9e+s9H7o
 kM+qHMMfy92QdTU4/T3C9MIYwbSbsSzPUKhM0c9Nvyfxkt1E6LVRVNIBhgVmgvqFPshr Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xt8y7835d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 10:18:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TAIhfn022382;
	Mon, 29 Apr 2024 10:18:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xt8y7835b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 10:18:43 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43T7bA4w027580;
	Mon, 29 Apr 2024 10:18:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsc306r26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 10:18:42 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43TAIa1h51511730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 10:18:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCA3E2005A;
	Mon, 29 Apr 2024 10:18:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9412C2004F;
	Mon, 29 Apr 2024 10:18:36 +0000 (GMT)
Received: from [9.152.224.41] (unknown [9.152.224.41])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 29 Apr 2024 10:18:36 +0000 (GMT)
Message-ID: <dceeac23-0c58-4c78-850a-d09e7b45d6e8@linux.ibm.com>
Date: Mon, 29 Apr 2024 12:18:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host intercepts
To: Eric Farman <farman@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
 <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
 <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
 <8fbd41c0fb16a5e10401f6c2888d44084e9af86a.camel@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <8fbd41c0fb16a5e10401f6c2888d44084e9af86a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S_v9gqupd17YVieIpb0G4RkDZQli7xcU
X-Proofpoint-ORIG-GUID: 2kdE4CErLL7Fv50orjQP2Drl4NiIkVkp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_07,2024-04-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=446 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290063

Am 04.03.24 um 16:37 schrieb Eric Farman:
> On Mon, 2024-03-04 at 09:44 +0100, Christian Borntraeger wrote:
>>
>>
>> Am 04.03.24 um 09:35 schrieb David Hildenbrand:
>>> On 01.03.24 21:43, Eric Farman wrote:
>>>> It's possible that SIE exits for work that the host needs to
>>>> perform
>>>> rather than something that is intended for the guest.
>>>>
>>>> A Linux guest will ignore this intercept code since there is
>>>> nothing
>>>> for it to do, but a more robust solution would rewind the PSW
>>>> back to
>>>> the SIE instruction. This will transparently resume the guest
>>>> once
>>>> the host completes its work, without the guest needing to process
>>>> what is effectively a NOP and re-issue SIE itself.
>>>
>>> I recall that 0-intercepts are valid by the architecture. Further,
>>> I recall that there were some rather tricky corner cases where
>>> avoiding 0-intercepts would not be that easy.
> 
> Any chance you recall any details of those corner cases? I can try to
> chase some of them down.
> 
>>>
>>> Now, it's been a while ago, and maybe I misremember. SoI'm trusting
>>> people with access to documentation can review this.
>>
>> Yes, 0-intercepts are allowed, and this also happens when LPAR has an
>> exit.
> 
>  From an offline conversation I'd had some months back:
> 
> """
> The arch does allow ICODE=0 to be stored, but it's supposed to happen
> only upon a host interruption -- in which case the old PSW is supposed
> to point back at the SIE, to resume guest execution if the host should
> LPSW oldPSW.
> """

Just re-read the architecture again and I agree, the SIE instruction should
be nullified. So we should go forward with this somehow.

Eric, can you maybe add this to devel for CI coverage so that we see if there
are corner cases? Maybe also try to do some performance things (how many IPIs
can we get in guest2 when a guest3 is running and how many IPIs are possible
in a guest3).


