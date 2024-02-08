Return-Path: <kvm+bounces-8346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8F884E284
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9219F289951
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EC97992A;
	Thu,  8 Feb 2024 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nJCmgI3M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7978B51;
	Thu,  8 Feb 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707400324; cv=none; b=JGGWxNkUNg0JAfJGzwCWC4CgeZoNuKGDqhKTTZmv2EUbhVFUV7xI5y6ua75ST2l1RVJSJQdgofrDbLhCG0LF7I5qEjD4WMASShxLMLaFTMy2qJrg5lHj9AfLfygV7GjzNoK73h7KHWfjkuwCczqobIpvAWJ6WvedxCpdpnNrojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707400324; c=relaxed/simple;
	bh=csev0OvZB5RlTT3pM+W7YD0AnyDHo8l7BCU04ZcRDOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8NjVDl2qEusWDhoX9amIXjIMRI7x90j1BUTVQeJpoHJdRpo2lJUPQYgLzFPIlee89UKK3wukQpOw+4rnyxM2yk8+YqCqm7zx7SF0g9yBFLggfBkS1ly91IFsWfkSywy1rE5EaWfmncqF+QIVuvwsgvZAknkwHaGvoC1pO1+1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nJCmgI3M; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418Dk82L005920;
	Thu, 8 Feb 2024 13:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qTllvUjzOOCahVHpd9bf0M3v2/AXqI4uoDasVK8Foyk=;
 b=nJCmgI3MHPA5CPJaQFAarTRiS7glRNehf0SOcHGYQwnAY9tXssJ2Elzb/OyGMZH/lJ2V
 pCXb+UKks51p5lT0BGrV/cSwOAG3Gt7LZu77z7JWyreJRKGlhzTMXaijnoYW9PXy6etc
 B7IVXsU2AMg78Moa3FjzltCQVn34icM3KR8HL0JsAJ2fSE9IFdr4fG5qYcmvWZo+WUbT
 k/RP7DdfEsqFqyIbWQMAbJWLHI28hIcJey55J4Xb5p8lCcIULW/kN7+V4m2R5AKXNlOC
 +f40qIzT60CT5Lj6yxmqAD2gRgTDetYERzG56d60ORhp2cSr5zE5QXcZWRp8MNYWHtTC yw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4x613gst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 13:52:01 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 418DkwMk011726;
	Thu, 8 Feb 2024 13:52:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4x613gs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 13:52:01 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 418BgDUO008770;
	Thu, 8 Feb 2024 13:52:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w206yvu3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 13:51:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 418DpueU42271362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Feb 2024 13:51:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BCFD2004D;
	Thu,  8 Feb 2024 13:51:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7A3C20043;
	Thu,  8 Feb 2024 13:51:55 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Feb 2024 13:51:55 +0000 (GMT)
Message-ID: <4b2729ba-d9ca-48f4-aa6d-4b421e8fa44d@linux.ibm.com>
Date: Thu, 8 Feb 2024 14:51:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers into
 KVM_RUN
To: Janosch Frank <frankja@linux.ibm.com>, Eric Farman
 <farman@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
 <5ecbe9f3-827d-4308-90cd-84e065a76489@linux.ibm.com>
 <84ae4b14-a514-462a-b084-4657f0353332@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <84ae4b14-a514-462a-b084-4657f0353332@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o3KR_61IgDTgnNs7eDKGxxnD_BqsUroW
X-Proofpoint-GUID: lo-0mXCAWFzho6ySRvIYJnguKDDxVD8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_05,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=790 bulkscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080074



Am 08.02.24 um 13:37 schrieb Janosch Frank:
> On 2/8/24 12:50, Christian Borntraeger wrote:
>> Am 31.01.24 um 21:58 schrieb Eric Farman:
>>> The routine ar_translation() is called by get_vcpu_asce(), which is
>>> called from a handful of places, such as an interception that is
>>> being handled during KVM_RUN processing. In that case, the access
>>> registers of the vcpu had been saved to a host_acrs struct and then
>>> the guest access registers loaded from the KVM_RUN struct prior to
>>> entering SIE. Saving them back to KVM_RUN at this point doesn't do
>>> any harm, since it will be done again at the end of the KVM_RUN
>>> loop when the host access registers are restored.
>>>
>>> But that's not the only path into this code. The MEM_OP ioctl can
>>> be used while specifying an access register, and will arrive here.
>>>
>>> Linux itself doesn't use the access registers for much, but it does
>>> squirrel the thread local storage variable into ACRs 0 and 1 in
>>> copy_thread() [1]. This means that the MEM_OP ioctl may copy
>>> non-zero access registers (the upper- and lower-halves of the TLS
>>> pointer) to the KVM_RUN struct, which will end up getting propogated
>>> to the guest once KVM_RUN ioctls occur. Since these are almost
>>> certainly invalid as far as an ALET goes, an ALET Specification
>>> Exception would be triggered if it were attempted to be used.
>>>
>>> [1] arch/s390/kernel/process.c:169
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>
>>> Notes:
>>>       I've gone back and forth about whether the correct fix is
>>>       to simply remove the save_access_regs() call and inspect
>>>       the contents from the most recent KVM_RUN directly, versus
>>>       storing the contents locally. Both work for me but I've
>>>       opted for the latter, as it continues to behave the same
>>>       as it does today but without the implicit use of the
>>>       KVM_RUN space. As it is, this is (was) the only reference
>>>       to vcpu->run in this file, which stands out since the
>>>       routines are used by other callers.
>>>       Curious about others' thoughts.
>>
>> Given the main idea that we have the guest ARs loaded in the kvm module
>> when running a guest and that the kernel does not use those. This avoids
>> saving/restoring the ARs for all the fast path exits.
>> The MEM_OP is indeed a separate path.
>> So what about making this slightly slower by doing something like this
>> (untested, white space damaged)
> 
> We could fence AR loading/storing via the the PSW address space bits for more performance and not do a full sync/store regs here.

Hmm, we would then add a conditional branch which also is not ideal.
Maybe just load/restore the ARs instead of the full sync/save_reg dance?

