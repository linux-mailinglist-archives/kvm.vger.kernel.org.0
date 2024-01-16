Return-Path: <kvm+bounces-6346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB3082F29F
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BCFB1C236D7
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA461CAA5;
	Tue, 16 Jan 2024 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jynp30L+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EE91CA80;
	Tue, 16 Jan 2024 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GGeQ1N017714;
	Tue, 16 Jan 2024 16:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=keGjVo14NW1WXmXT6broB/rKN1sTqt3ubg6oJsYRaD8=;
 b=jynp30L+qxm/m3s6SZ9vtOPYJSmGF14cjnXqW9skoWCBOs66k6n04booPDF5hctRbTb3
 yvhTez3/oKvVUZIFt9KS+e6XeAYBh+cJO3/Vsg/FjJhDgsWh/Kar+oWo3tLUV4xpAYOq
 CjEAY6YyHD1TmxXt356/UF2aolURobbLXU7ejbPhWHCF1AFkox6D9adzZ0opvt1LTTJP
 g6YTAdfeXy9vdOkC9+SYto4GwarpOCv7XmECxKEszoV1qTQIUXNiNj3BEr+fjCGnGL7z
 9uPlGMdPT3YpClXw1OQYiZ+5c8FwLW3rm5mIN3eBDzExpxSeh0hjmsBS0y9CAj5NsXF9 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnwg4gaw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 16:50:46 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GGmpaD014280;
	Tue, 16 Jan 2024 16:50:45 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnwg4gavf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 16:50:45 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GGQxFr010837;
	Tue, 16 Jan 2024 16:50:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm57yfxn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 16:50:44 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GGof1t19595822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 16:50:41 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F81F20043;
	Tue, 16 Jan 2024 16:50:41 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33E2820040;
	Tue, 16 Jan 2024 16:50:40 +0000 (GMT)
Received: from [9.171.95.17] (unknown [9.171.95.17])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 16:50:40 +0000 (GMT)
Message-ID: <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com>
Date: Tue, 16 Jan 2024 17:50:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
To: Yi Wang <up2wing@gmail.com>, Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>,
        Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20240112091128.3868059-1-foxywang@tencent.com>
 <ZaFor2Lvdm4O2NWa@google.com>
 <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uGSYHvltOt2x6FJnz2wbeZOPSNTDoFZd
X-Proofpoint-ORIG-GUID: kANRDA64pEjYrGAxpeDGFbJAHLYZ3zc2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_10,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1011 suspectscore=0 mlxscore=0 phishscore=0
 mlxlogscore=663 spamscore=0 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160133



Am 15.01.24 um 17:01 schrieb Yi Wang:
> Many thanks for your such kind and detailed reply, Sean!
> 
> On Sat, Jan 13, 2024 at 12:28 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> +other KVM maintainers
>>
>> On Fri, Jan 12, 2024, Yi Wang wrote:
>>> From: Yi Wang <foxywang@tencent.com>
>>>
>>> We found that it may cost more than 20 milliseconds very accidentally
>>> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
>>> already.
>>>
>>> The reason is that when vmm(qemu/CloudHypervisor) invokes
>>> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
>>> might_sleep and kworker of srcu may cost some delay during this period.
>>
>> might_sleep() yielding is not justification for changing KVM.  That's more or
>> less saying "my task got preempted and took longer to run".  Well, yeah.
> 
> Agree. But I suppose it may be one of the reasons that makes  time of
> KVM_CAP_SPLIT_IRQCHIP delayed, of course, the kworker has the biggest
> suspicion :)
> 
>>
>>> Since this happens during creating vm, it's no need to synchronize srcu
>>> now 'cause everything is not ready(vcpu/irqfd) and none uses irq_srcu now.
> 
> ....
> 
>> And on x86, I'm pretty sure as of commit 654f1f13ea56 ("kvm: Check irqchip mode
>> before assign irqfd"), which added kvm_arch_irqfd_allowed(), it's impossible for
>> kvm_irq_map_gsi() to encounter a NULL irq_routing _on x86_.
>>
>> But I strongly suspect other architectures can reach kvm_irq_map_gsi() with a
>> NULL irq_routing, e.g. RISC-V dynamically configures its interrupt controller,
>> yet doesn't implement kvm_arch_intc_initialized().
>>
>> So instead of special casing x86, what if we instead have KVM setup an empty
>> IRQ routing table during kvm_create_vm(), and then avoid this mess entirely?
>> That way x86 and s390 no longer need to set empty/dummy routing when creating
>> an IRQCHIP, and the worst case scenario of userspace misusing an ioctl() is no
>> longer a NULL pointer deref.

Sounds like a good idea. This should also speedup guest creation on s390 since
it would avoid one syncronize_irq.
> 
> To setup an empty IRQ routing table during kvm_create_vm() sounds a good idea,
> at this time vCPU have not been created and kvm->lock is held so skipping
> synchronization is safe here.
> 
> However, there is one drawback, if vmm wants to emulate irqchip
> itself, e.g. qemu
> with command line '-machine kernel-irqchip=off' may not need irqchip
> in kernel. How
> do we handle this issue?

I would be fine with wasted memory. The only question is does it have a functional
impact or can we simply ignore the dummy routing.



