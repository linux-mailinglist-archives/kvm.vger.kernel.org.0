Return-Path: <kvm+bounces-62504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DD0C4674B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 13:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD12189ADE8
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 12:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBC830EF62;
	Mon, 10 Nov 2025 12:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="koM03mHG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE8530DD2C;
	Mon, 10 Nov 2025 12:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762776168; cv=none; b=jTJnxrzMB8/zWRyN6QmDIUr5K93fzbHRlvgeTzj0WPqMFJxKjYUGub0lRfSbn9ggPNarsG3BopE829DEzK8MB5oSTZo+Hregw2ObRk4xqqp9wnpIwOg8FfDaa9kS0gn3VVWuSj0TlrV3F53YfUbJ3BOtap3bOJmr02k01j3eVRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762776168; c=relaxed/simple;
	bh=REp9wQTaEi6nHXZh4VunZPcTgElybS6FbKuJdk8yULU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itrcDX3LHnaf4tvu+hE6Z+CK5ZrtndI0M+ZUocA0r1DNL25nCsyOzJFwPIMoGnKOC3MA2nD27F7vnSFM43xKiXL17wPqc/DojT/B7Pb7wvlcJkSxXUmstaZcaD14lP5GxIfFNdSEldmyIqSSfOuZP2OFLQLv0pkGAVOz4tUZi0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=koM03mHG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9Jt3Ho015833;
	Mon, 10 Nov 2025 12:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EMHJjy
	3qfDUPwPK/YVKa96nT5T98Vmmf6aAAX/6JP5s=; b=koM03mHGSM4qb0L2zIX6zp
	EC9LjiQqH93Q34AhlwzkNCeL8yH7V3SFLjD1INJyjH5HoeRf8WE1yaoyECBNYyOl
	OythlMTeFT8ldj+0BSSAEYcYOXDc3qvMAM4zEPldbUGISICV4YVhJWRyT2Cy7FWH
	laKaXL0rQjvUetLI69M1NB4alR2JFk2Ouqt6bmG9turTvG2F5L1bm0FIlOtOIGPL
	wNK8SpISu50STVLd8onFLQ+DGhf4IyytFtdd0ibdFZyuh/ZNnElqHWpkgTbuc/Wf
	uH9mmmwPxzh2ruUcuJs3lpkQbJOQ2SjVxUatXAZW4VH8ff13VhBApjGgyo0a98qA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m7x8gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 12:02:17 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AABxwbv004164;
	Mon, 10 Nov 2025 12:02:17 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m7x8g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 12:02:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA98fRp008218;
	Mon, 10 Nov 2025 12:02:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6mnf5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 12:02:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAC2CHm22217422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 12:02:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 784FB20043;
	Mon, 10 Nov 2025 12:02:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08CD62004B;
	Mon, 10 Nov 2025 12:02:12 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 12:02:11 +0000 (GMT)
Message-ID: <a1e5a8db-8382-4f52-8ef2-3b62b0c031ab@linux.ibm.com>
Date: Mon, 10 Nov 2025 13:02:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Mete Durlu <meted@linux.ibm.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=6911d44a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=RGqg41XGIlgyeIaX6XkA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: qXsWQnQL86nX1XvMI3FtIg5oLzxHqs6d
X-Proofpoint-ORIG-GUID: bpb605FGcMWJ3fRxGCD26Rs-flBGB4Fu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX5cdfHi7QNWyw
 4AGDjPnDx5KhpOOm/6/eKaBa6uALkPoIAkNqIPEW4jcsNmqoiuWuhLBcabEYgWrouNQQ+OdnTng
 uZxHVN5DdVPoYvQkLm/0QqydjDxFD7DD5pyOF0NK1U/FVkhB5QxAbMbGtawBh0Xi9ZU6anORBTg
 QMSIZyED7k1CLi2CTfxFQ17VDrB2v2HTGVf1/BeT9DlxDTa0OY5U7J+SIMSqdsIEGtP3rbDsAVA
 snzWn3FlEUMubepQpYnzNjpbQ2z5Qd3cRRy7o/G0TQ1ebB3rSdlrfbH/r+ZRdycYVf+fvfAK8hF
 u5ShSDtVmdwB+iV97498cGXe7c5qUfZF5MgZtw+jHODjtqoN5Vvyca8es1lEIfGPG+853WvfNzw
 it9OEdI3s1kjWxwC8qj0n3dYQsfdTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

Am 10.11.25 um 04:32 schrieb Wanpeng Li:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> This series addresses long-standing yield_to() inefficiencies in
> virtualized environments through two complementary mechanisms: a vCPU
> debooster in the scheduler and IPI-aware directed yield in KVM.
> 
> Problem Statement
> -----------------
> 
> In overcommitted virtualization scenarios, vCPUs frequently spin on locks
> held by other vCPUs that are not currently running. The kernel's
> paravirtual spinlock support detects these situations and calls yield_to()
> to boost the lock holder, allowing it to run and release the lock.
> 
> However, the current implementation has two critical limitations:
> 
> 1. Scheduler-side limitation:
> 
>     yield_to_task_fair() relies solely on set_next_buddy() to provide
>     preference to the target vCPU. This buddy mechanism only offers
>     immediate, transient preference. Once the buddy hint expires (typically
>     after one scheduling decision), the yielding vCPU may preempt the target
>     again, especially in nested cgroup hierarchies where vruntime domains
>     differ.
> 
>     This creates a ping-pong effect: the lock holder runs briefly, gets
>     preempted before completing critical sections, and the yielding vCPU
>     spins again, triggering another futile yield_to() cycle. The overhead
>     accumulates rapidly in workloads with high lock contention.

I can certainly confirm that on s390 we do see that yield_to does not always
work as expected. Our spinlock code is lock holder aware so our KVM always yield
correctly but often enought the hint is ignored our bounced back as you describe.
So I am certainly interested in that part.

I need to look more closely into the other part.



