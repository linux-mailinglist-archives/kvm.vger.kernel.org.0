Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBF238A8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbfETNrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:47:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbfETNrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 May 2019 09:47:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KDgXRf118335
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:46:59 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2skwa80dgw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:46:58 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 20 May 2019 14:46:56 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 May 2019 14:46:52 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4KDkpLI49021088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 13:46:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CEADA4054;
        Mon, 20 May 2019 13:46:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E8DA405C;
        Mon, 20 May 2019 13:46:51 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.226])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 May 2019 13:46:51 +0000 (GMT)
Subject: Re: [PATCH] x86: add cpuidle_kvm driver to allow guest side halt
 polling
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
References: <20190517174857.GA8611@amt.cnet>
 <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
 <a584d271-8a0b-25f8-bf3b-ef1a177220bb@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBE6cPPgBEAC2VpALY0UJjGmgAmavkL/iAdqul2/F9ONz42K6NrwmT+SI9CylKHIX+fdf
 J34pLNJDmDVEdeb+brtpwC9JEZOLVE0nb+SR83CsAINJYKG3V1b3Kfs0hydseYKsBYqJTN2j
 CmUXDYq9J7uOyQQ7TNVoQejmpp5ifR4EzwIFfmYDekxRVZDJygD0wL/EzUr8Je3/j548NLyL
 4Uhv6CIPf3TY3/aLVKXdxz/ntbLgMcfZsDoHgDk3lY3r1iwbWwEM2+eYRdSZaR4VD+JRD7p8
 0FBadNwWnBce1fmQp3EklodGi5y7TNZ/CKdJ+jRPAAnw7SINhSd7PhJMruDAJaUlbYaIm23A
 +82g+IGe4z9tRGQ9TAflezVMhT5J3ccu6cpIjjvwDlbxucSmtVi5VtPAMTLmfjYp7VY2Tgr+
 T92v7+V96jAfE3Zy2nq52e8RDdUo/F6faxcumdl+aLhhKLXgrozpoe2nL0Nyc2uqFjkjwXXI
 OBQiaqGeWtxeKJP+O8MIpjyGuHUGzvjNx5S/592TQO3phpT5IFWfMgbu4OreZ9yekDhf7Cvn
 /fkYsiLDz9W6Clihd/xlpm79+jlhm4E3xBPiQOPCZowmHjx57mXVAypOP2Eu+i2nyQrkapaY
 IdisDQfWPdNeHNOiPnPS3+GhVlPcqSJAIWnuO7Ofw1ZVOyg/jwARAQABtDRDaHJpc3RpYW4g
 Qm9ybnRyYWVnZXIgKElCTSkgPGJvcm50cmFlZ2VyQGRlLmlibS5jb20+iQI4BBMBAgAiBQJO
 nDz4AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRARe7yAtaYcfOYVD/9sqc6ZdYKD
 bmDIvc2/1LL0g7OgiA8pHJlYN2WHvIhUoZUIqy8Sw2EFny/nlpPVWfG290JizNS2LZ0mCeGZ
 80yt0EpQNR8tLVzLSSr0GgoY0lwsKhAnx3p3AOrA8WXsPL6prLAu3yJI5D0ym4MJ6KlYVIjU
 ppi4NLWz7ncA2nDwiIqk8PBGxsjdc/W767zOOv7117rwhaGHgrJ2tLxoGWj0uoH3ZVhITP1z
 gqHXYaehPEELDV36WrSKidTarfThCWW0T3y4bH/mjvqi4ji9emp1/pOWs5/fmd4HpKW+44tD
 Yt4rSJRSa8lsXnZaEPaeY3nkbWPcy3vX6qafIey5d8dc8Uyaan39WslnJFNEx8cCqJrC77kI
 vcnl65HaW3y48DezrMDH34t3FsNrSVv5fRQ0mbEed8hbn4jguFAjPt4az1xawSp0YvhzwATJ
 YmZWRMa3LPx/fAxoolq9cNa0UB3D3jmikWktm+Jnp6aPeQ2Db3C0cDyxcOQY/GASYHY3KNra
 z8iwS7vULyq1lVhOXg1EeSm+lXQ1Ciz3ub3AhzE4c0ASqRrIHloVHBmh4favY4DEFN19Xw1p
 76vBu6QjlsJGjvROW3GRKpLGogQTLslbjCdIYyp3AJq2KkoKxqdeQYm0LZXjtAwtRDbDo71C
 FxS7i/qfvWJv8ie7bE9A6Wsjn7kCDQROnDz4ARAAmPI1e8xB0k23TsEg8O1sBCTXkV8HSEq7
 JlWz7SWyM8oFkJqYAB7E1GTXV5UZcr9iurCMKGSTrSu3ermLja4+k0w71pLxws859V+3z1jr
 nhB3dGzVZEUhCr3EuN0t8eHSLSMyrlPL5qJ11JelnuhToT6535cLOzeTlECc51bp5Xf6/XSx
 SMQaIU1nDM31R13o98oRPQnvSqOeljc25aflKnVkSfqWSrZmb4b0bcWUFFUKVPfQ5Z6JEcJg
 Hp7qPXHW7+tJTgmI1iM/BIkDwQ8qe3Wz8R6rfupde+T70NiId1M9w5rdo0JJsjKAPePKOSDo
 RX1kseJsTZH88wyJ30WuqEqH9zBxif0WtPQUTjz/YgFbmZ8OkB1i+lrBCVHPdcmvathknAxS
 bXL7j37VmYNyVoXez11zPYm+7LA2rvzP9WxR8bPhJvHLhKGk2kZESiNFzP/E4r4Wo24GT4eh
 YrDo7GBHN82V4O9JxWZtjpxBBl8bH9PvGWBmOXky7/bP6h96jFu9ZYzVgIkBP3UYW+Pb1a+b
 w4A83/5ImPwtBrN324bNUxPPqUWNW0ftiR5b81ms/rOcDC/k/VoN1B+IHkXrcBf742VOLID4
 YP+CB9GXrwuF5KyQ5zEPCAjlOqZoq1fX/xGSsumfM7d6/OR8lvUPmqHfAzW3s9n4lZOW5Jfx
 bbkAEQEAAYkCHwQYAQIACQUCTpw8+AIbDAAKCRARe7yAtaYcfPzbD/9WNGVf60oXezNzSVCL
 hfS36l/zy4iy9H9rUZFmmmlBufWOATjiGAXnn0rr/Jh6Zy9NHuvpe3tyNYZLjB9pHT6mRZX7
 Z1vDxeLgMjTv983TQ2hUSlhRSc6e6kGDJyG1WnGQaqymUllCmeC/p9q5m3IRxQrd0skfdN1V
 AMttRwvipmnMduy5SdNayY2YbhWLQ2wS3XHJ39a7D7SQz+gUQfXgE3pf3FlwbwZhRtVR3z5u
 aKjxqjybS3Ojimx4NkWjidwOaUVZTqEecBV+QCzi2oDr9+XtEs0m5YGI4v+Y/kHocNBP0myd
 pF3OoXvcWdTb5atk+OKcc8t4TviKy1WCNujC+yBSq3OM8gbmk6NwCwqhHQzXCibMlVF9hq5a
 FiJb8p4QKSVyLhM8EM3HtiFqFJSV7F+h+2W0kDyzBGyE0D8z3T+L3MOj3JJJkfCwbEbTpk4f
 n8zMboekuNruDw1OADRMPlhoWb+g6exBWx/YN4AY9LbE2KuaScONqph5/HvJDsUldcRN3a5V
 RGIN40QWFVlZvkKIEkzlzqpAyGaRLhXJPv/6tpoQaCQQoSAc5Z9kM/wEd9e2zMeojcWjUXgg
 oWj8A/wY4UXExGBu+UCzzP/6sQRpBiPFgmqPTytrDo/gsUGqjOudLiHQcMU+uunULYQxVghC
 syiRa+UVlsKmx1hsEg==
Date:   Mon, 20 May 2019 15:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a584d271-8a0b-25f8-bf3b-ef1a177220bb@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052013-0028-0000-0000-0000036F9ECB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052013-0029-0000-0000-0000242F4478
Message-Id: <352694a5-cc07-8fda-1dd2-2bf8be6e4dd2@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.05.19 14:07, Christian Borntraeger wrote:
> 
> 
> On 20.05.19 13:51, Paolo Bonzini wrote:
>> On 17/05/19 19:48, Marcelo Tosatti wrote:
>>>
>>> The cpuidle_kvm driver allows the guest vcpus to poll for a specified
>>> amount of time before halting. This provides the following benefits
>>> to host side polling:
>>>
>>> 	1) The POLL flag is set while polling is performed, which allows
>>> 	   a remote vCPU to avoid sending an IPI (and the associated
>>>  	   cost of handling the IPI) when performing a wakeup.
>>>
>>> 	2) The HLT VM-exit cost can be avoided.
>>>
>>> The downside of guest side polling is that polling is performed
>>> even with other runnable tasks in the host.
>>>
>>> Results comparing halt_poll_ns and server/client application
>>> where a small packet is ping-ponged:
>>>
>>> host                                        --> 31.33	
>>> halt_poll_ns=300000 / no guest busy spin    --> 33.40	(93.8%)
>>> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73	(95.7%)
>>>
>>> For the SAP HANA benchmarks (where idle_spin is a parameter 
>>> of the previous version of the patch, results should be the
>>> same):
>>>
>>> hpns == halt_poll_ns
>>>
>>>                           idle_spin=0/   idle_spin=800/	   idle_spin=0/
>>> 			  hpns=200000    hpns=0            hpns=800000
>>> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78	  (+1%)
>>> InsertC16T02 (100 thread) 2.14     	 2.07 (-3%)        2.18   (+1.8%)
>>> DeleteC00T01 (1 thread)   1.34 		 1.28 (-4.5%)	   1.29   (-3.7%)
>>> UpdateC00T03 (1 thread)	  4.72		 4.18 (-12%)	   4.53   (-5%)
>>
>> Hi Marcelo,
>>
>> some quick observations:
>>
>> 1) This is actually not KVM-specific, so the name and placement of the
>> docs should be adjusted.
>>
>> 2) Regarding KVM-specific code, however, we could add an MSR so that KVM
>> disables halt_poll_ns for this VM when this is active in the guest?
> 
> The whole code looks pretty much architecture independent. I have also seen cases
> on s390 where this kind of code would make sense. Can we try to make this
> usable for other archs as well?

I did a quick hack (not yet for  the list as it contains some uglyness).
and the code seems to run ok on s390. 
So any chance to move this into drivers/cpuidle/ so that !x86 can also enable that
when appropriate?

I actually agree with Paolo that we should disable host halt polling as soon as
the guest does it. Maybe we should have some arch specific callback (that can be
an MSR).

> 
> 
>>
>> 3) The spin time could use the same adaptive algorithm that KVM uses in
>> the host.
>>
>> Thanks,
>>
>> Paolo
>>
>>
>>> ---
>>>  Documentation/virtual/kvm/guest-halt-polling.txt |   39 ++++++++
>>>  arch/x86/Kconfig                                 |    9 +
>>>  arch/x86/kernel/Makefile                         |    1 
>>>  arch/x86/kernel/cpuidle_kvm.c                    |  105 +++++++++++++++++++++++
>>>  arch/x86/kernel/process.c                        |    2 
>>>  5 files changed, 155 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-2.6.git/arch/x86/Kconfig
>>> ===================================================================
>>> --- linux-2.6.git.orig/arch/x86/Kconfig	2019-04-22 13:49:42.858303265 -0300
>>> +++ linux-2.6.git/arch/x86/Kconfig	2019-05-16 14:18:41.254852745 -0300
>>> @@ -805,6 +805,15 @@
>>>  	  underlying device model, the host provides the guest with
>>>  	  timing infrastructure such as time of day, and system time
>>>  
>>> +config KVM_CPUIDLE
>>> +	tristate "KVM cpuidle driver"
>>> +	depends on KVM_GUEST
>>> +	default y
>>> +	help
>>> +	  This option enables KVM cpuidle driver, which allows to poll
>>> +	  before halting in the guest (more efficient than polling in the
>>> +	  host via halt_poll_ns for some scenarios).
>>> +
>>>  config PVH
>>>  	bool "Support for running PVH guests"
>>>  	---help---
>>> Index: linux-2.6.git/arch/x86/kernel/Makefile
>>> ===================================================================
>>> --- linux-2.6.git.orig/arch/x86/kernel/Makefile	2019-04-22 13:49:42.869303331 -0300
>>> +++ linux-2.6.git/arch/x86/kernel/Makefile	2019-05-17 12:59:51.673274881 -0300
>>> @@ -112,6 +112,7 @@
>>>  obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
>>>  
>>>  obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
>>> +obj-$(CONFIG_KVM_CPUIDLE)	+= cpuidle_kvm.o
>>>  obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
>>>  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
>>>  obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
>>> Index: linux-2.6.git/arch/x86/kernel/process.c
>>> ===================================================================
>>> --- linux-2.6.git.orig/arch/x86/kernel/process.c	2019-04-22 13:49:42.876303374 -0300
>>> +++ linux-2.6.git/arch/x86/kernel/process.c	2019-05-17 13:19:18.055435117 -0300
>>> @@ -580,7 +580,7 @@
>>>  	safe_halt();
>>>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>>>  }
>>> -#ifdef CONFIG_APM_MODULE
>>> +#if defined(CONFIG_APM_MODULE) || defined(CONFIG_KVM_CPUIDLE_MODULE)
>>>  EXPORT_SYMBOL(default_idle);
>>>  #endif
>>>  
>>> Index: linux-2.6.git/arch/x86/kernel/cpuidle_kvm.c
>>> ===================================================================
>>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>>> +++ linux-2.6.git/arch/x86/kernel/cpuidle_kvm.c	2019-05-17 13:38:02.553941356 -0300
>>> @@ -0,0 +1,105 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * cpuidle driver for KVM guests.
>>> + *
>>> + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2.  See
>>> + * the COPYING file in the top-level directory.
>>> + *
>>> + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
>>> + */
>>> +
>>> +#include <linux/init.h>
>>> +#include <linux/cpuidle.h>
>>> +#include <linux/module.h>
>>> +#include <linux/timekeeping.h>
>>> +#include <linux/sched/idle.h>
>>> +
>>> +unsigned int guest_halt_poll_ns;
>>> +module_param(guest_halt_poll_ns, uint, 0644);
>>> +
>>> +static int kvm_enter_idle(struct cpuidle_device *dev,
>>> +			  struct cpuidle_driver *drv, int index)
>>> +{
>>> +	int do_halt = 0;
>>> +
>>> +	/* No polling */
>>> +	if (guest_halt_poll_ns == 0) {
>>> +		if (current_clr_polling_and_test()) {
>>> +			local_irq_enable();
>>> +			return index;
>>> +		}
>>> +		default_idle();
>>> +		return index;
>>> +	}
>>> +
>>> +	local_irq_enable();
>>> +	if (!current_set_polling_and_test()) {
>>> +		ktime_t now, end_spin;
>>> +
>>> +		now = ktime_get();
>>> +		end_spin = ktime_add_ns(now, guest_halt_poll_ns);
>>> +
>>> +		while (!need_resched()) {
>>> +			cpu_relax();
>>> +			now = ktime_get();
>>> +
>>> +			if (!ktime_before(now, end_spin)) {
>>> +				do_halt = 1;
>>> +				break;
>>> +			}
>>> +		}
>>> +	}
>>> +
>>> +	if (do_halt) {
>>> +		/*
>>> +		 * No events while busy spin window passed,
>>> +		 * halt.
>>> +		 */
>>> +		local_irq_disable();
>>> +		if (current_clr_polling_and_test()) {
>>> +			local_irq_enable();
>>> +			return index;
>>> +		}
>>> +		default_idle();
>>> +	} else {
>>> +		current_clr_polling();
>>> +	}
>>> +
>>> +	return index;
>>> +}
>>> +
>>> +static struct cpuidle_driver kvm_idle_driver = {
>>> +	.name = "kvm_idle",
>>> +	.owner = THIS_MODULE,
>>> +	.states = {
>>> +		{ /* entry 0 is for polling */ },
>>> +		{
>>> +			.enter			= kvm_enter_idle,
>>> +			.exit_latency		= 0,
>>> +			.target_residency	= 0,
>>> +			.power_usage		= -1,
>>> +			.name			= "KVM",
>>> +			.desc			= "KVM idle",
>>> +		},
>>> +	},
>>> +	.safe_state_index = 0,
>>> +	.state_count = 2,
>>> +};
>>> +
>>> +static int __init kvm_cpuidle_init(void)
>>> +{
>>> +	return cpuidle_register(&kvm_idle_driver, NULL);
>>> +}
>>> +
>>> +static void __exit kvm_cpuidle_exit(void)
>>> +{
>>> +	cpuidle_unregister(&kvm_idle_driver);
>>> +}
>>> +
>>> +module_init(kvm_cpuidle_init);
>>> +module_exit(kvm_cpuidle_exit);
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
>>> +
>>> Index: linux-2.6.git/Documentation/virtual/kvm/guest-halt-polling.txt
>>> ===================================================================
>>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>>> +++ linux-2.6.git/Documentation/virtual/kvm/guest-halt-polling.txt	2019-05-17 13:36:39.274703710 -0300
>>> @@ -0,0 +1,39 @@
>>> +KVM guest halt polling
>>> +======================
>>> +
>>> +The cpuidle_kvm driver allows the guest vcpus to poll for a specified
>>> +amount of time before halting. This provides the following benefits
>>> +to host side polling:
>>> +
>>> +	1) The POLL flag is set while polling is performed, which allows
>>> +	   a remote vCPU to avoid sending an IPI (and the associated
>>> + 	   cost of handling the IPI) when performing a wakeup.
>>> +
>>> +	2) The HLT VM-exit cost can be avoided.
>>> +
>>> +The downside of guest side polling is that polling is performed
>>> +even with other runnable tasks in the host.
>>> +
>>> +Module Parameters
>>> +=================
>>> +
>>> +The cpuidle_kvm module has 1 tuneable module parameter: guest_halt_poll_ns,
>>> +the amount of time, in nanoseconds, that polling is performed before
>>> +halting.
>>> +
>>> +This module parameter can be set from the debugfs files in:
>>> +
>>> +	/sys/module/cpuidle_kvm/parameters/
>>> +
>>> +Further Notes
>>> +=============
>>> +
>>> +- Care should be taken when setting the guest_halt_poll_ns parameter as a
>>> +large value has the potential to drive the cpu usage to 100% on a machine which
>>> +would be almost entirely idle otherwise.
>>> +
>>> +- The effective amount of time that polling is performed is the host poll
>>> +value (see halt-polling.txt) plus guest_halt_poll_ns. If all guests
>>> +on a host system support and have properly configured guest_halt_poll_ns,
>>> +then setting halt_poll_ns to 0 in the host is probably the best choice.
>>> +
>>>
>>

