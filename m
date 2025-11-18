Return-Path: <kvm+bounces-63519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DE4C682BE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E46534DA50
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D023081DD;
	Tue, 18 Nov 2025 08:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fp8Uy9Ez"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938D721322F;
	Tue, 18 Nov 2025 08:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453625; cv=none; b=hhxhPcH9/QWGwluDbgi68sTLFy7N1DAbQILnYc810cVkOdJp0NZr0e6sSW+TWjctflumpQaXnLeR76k/Sr9GbLSoff1IHkIeUyU7G3HIL6gGyRF5rgD9yntj5LymkE3htZX0jNZkiLC50ezYa4X2ERqV5qL1ZGrd5tictq11QU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453625; c=relaxed/simple;
	bh=jBvR59pBhhYwJD+TTnnc1HwticZvXRhiXgqnGKLFzAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JXUHg9L5trhgzA1ElcNpdiHOds5tgIU/Daq45x5mF/PMVGc++3EdZIUnk/M+yZmq8dP9mnTd/KCQ1KiPqESR2bL8HWLlAnkQwi6IMiDaZ73b6Pq2cBAZk2S6L+0H5cKk+ZeV2Liv0INPJEhhQMzq5jUmrEVcjW+NSteFjouc+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fp8Uy9Ez; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI3RB8h031300;
	Tue, 18 Nov 2025 08:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=U8+ynj
	iadVz/eJeJrF1aru7ZZS6g7m0KpIV5xtnWGB0=; b=Fp8Uy9Ez0d60AvAE+Q9TEB
	4jm5vvx72kTsUhLLgVpWkG8FrYzpff0+4urgj1LvUU0ANHq4TgAOuQAM+3Gwe4bv
	4uO6HX0NWzw0SVTZgYCprtFFWENdDhN8bsWeLJ4Tw2op2euJ7mhgWiU3dR5Cn+YX
	hfa5hrht9cGhYlt9/lWYVfLA+HSt9fNs/RKIPFZNkLtxVJMq/oL/WKlvCqzp5w39
	QKgbzrogdHuksaEKH67MPKG1TH7d6LU55VTW0eoNPw+NYpLuAi6qR/9dOEm7T2sr
	mEP0GL1UBMCqpH6PzqD50UG3Qd//PTRcyJqahP1BcmVBd2gdBGMXcD3HbkUszy7A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw1rp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 08:12:07 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AI8C7NE009701;
	Tue, 18 Nov 2025 08:12:07 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw1rp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 08:12:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI4nvMn017335;
	Tue, 18 Nov 2025 08:12:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af6j1hsrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 08:12:05 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AI8C2ZA17498428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 08:12:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F324F20043;
	Tue, 18 Nov 2025 08:12:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EFC720040;
	Tue, 18 Nov 2025 08:12:01 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Nov 2025 08:12:01 +0000 (GMT)
Message-ID: <2a57185c-dce1-46c6-96f6-f51a81cd42a8@linux.ibm.com>
Date: Tue, 18 Nov 2025 09:11:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt
 <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Mete Durlu <meted@linux.ibm.com>, Axel Busch <axel.busch@ibm.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <a1e5a8db-8382-4f52-8ef2-3b62b0c031ab@linux.ibm.com>
 <CANRm+CzVtzgYYwgaqEMmsOAo7m=Esd9rd-zbB7zXzgL_p5SgxQ@mail.gmail.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <CANRm+CzVtzgYYwgaqEMmsOAo7m=Esd9rd-zbB7zXzgL_p5SgxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691c2a57 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=GvQkQWPkAAAA:8 a=MnPJsPCl_hJFqVVYTXAA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX1atbfOiPPoaW
 4acH+MRcC7BNpVoLeou3CMj46YB65E1BD4rtq1X3JRR8F20b+wmlP782UsTZ7o23FwZ2mG7FsuV
 zo7xKErLibkwyyt+x/zDBX2ISkiRZD+nqLN0Hq6hqcEVUWaVBPhVX2EIWCZrOJzmCs03hXNqA4e
 7J6tc8rXUwpscoy+LQWh/1V6krCGHfPNP5BTgCG/PvsCVVAqJ+JJIYH/tmQPjDhsojGopCXcx2V
 4ennQLlupjKFqdsgEHYMBmFzekfsV+E6JsfAb3w5gtWpVWr18BAOJYRHMh8ac4BH0vGCRWNnA+U
 QJUWUlX1ND33PG9bkLS68m1oxJ0G/OO7ZfJBY2KZrDAvy3UP4ZAdR/c6n8K+mYGBJmQGMyJApt+
 BFpNR5vHLav0tEVrfe+brbyWvr2ifA==
X-Proofpoint-GUID: ZDSzdySVtUL5HeXr2fnzox_Wfk8-QO0q
X-Proofpoint-ORIG-GUID: 6GO8GPkSh6SMEVprEw28-hdTYXzg3S08
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Am 12.11.25 um 06:01 schrieb Wanpeng Li:
> Hi Christian,
> 
> On Mon, 10 Nov 2025 at 20:02, Christian Borntraeger
> <borntraeger@linux.ibm.com> wrote:
>>
>> Am 10.11.25 um 04:32 schrieb Wanpeng Li:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> This series addresses long-standing yield_to() inefficiencies in
>>> virtualized environments through two complementary mechanisms: a vCPU
>>> debooster in the scheduler and IPI-aware directed yield in KVM.
>>>
>>> Problem Statement
>>> -----------------
>>>
>>> In overcommitted virtualization scenarios, vCPUs frequently spin on locks
>>> held by other vCPUs that are not currently running. The kernel's
>>> paravirtual spinlock support detects these situations and calls yield_to()
>>> to boost the lock holder, allowing it to run and release the lock.
>>>
>>> However, the current implementation has two critical limitations:
>>>
>>> 1. Scheduler-side limitation:
>>>
>>>      yield_to_task_fair() relies solely on set_next_buddy() to provide
>>>      preference to the target vCPU. This buddy mechanism only offers
>>>      immediate, transient preference. Once the buddy hint expires (typically
>>>      after one scheduling decision), the yielding vCPU may preempt the target
>>>      again, especially in nested cgroup hierarchies where vruntime domains
>>>      differ.
>>>
>>>      This creates a ping-pong effect: the lock holder runs briefly, gets
>>>      preempted before completing critical sections, and the yielding vCPU
>>>      spins again, triggering another futile yield_to() cycle. The overhead
>>>      accumulates rapidly in workloads with high lock contention.
>>
>> I can certainly confirm that on s390 we do see that yield_to does not always
>> work as expected. Our spinlock code is lock holder aware so our KVM always yield
>> correctly but often enought the hint is ignored our bounced back as you describe.
>> So I am certainly interested in that part.
>>
>> I need to look more closely into the other part.
> 
> Thanks for the confirmation and interest! It's valuable to hear that
> s390 observes similar yield_to() behavior where the hint gets ignored
> or bounced back despite correct lock holder identification.
> 
> Since your spinlock code is already lock-holder-aware and KVM yields
> to the correct target, the scheduler-side improvements (patches 1-5)
> should directly address the ping-pong issue you're seeing. The
> vruntime penalties are designed to sustain the preference beyond the
> transient buddy hint, which should reduce the bouncing effect.

So we will play a bit with the first patches and check for performance improvements.

I am curious, I did a quick unit test with 2 CPUs ping ponging on a counter. And I do
see "more than count" numbers of the yield hypercalls with that testcase (as before).
Something like 40060000 yields instead of 4000000 for a perfect ping pong. If I comment
out your rate limit code I hit exactly the 4000000.
Can you maybe outline a bit why the rate limit is important and needed?

