Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530231BB45
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfEMQsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:48:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfEMQsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:48:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGhekd120570;
        Mon, 13 May 2019 16:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Qff8KnehFhJXqovrxQdZ7APq0wkHxbUzI8v2H1GwFfQ=;
 b=G2PtJ/Hfil95i1O+Kj9eeEbcL8e9GWSz+sp/dIX+Krqd0IgEw72OA3na6JA2QkunW1Lh
 JKW6+KcvM0Mxvji8hOLBqippaReXLoArtdrLqLWpi0WfFrGPSJv8AQMlbGvNHsH0u1qN
 tBUcIEzdnlzk/abdFkpNaoYJhw/cwDALRtoJs/l5cZU1uFcp5qwy4IZa72ymnO6gLsdV
 1OEMNqfQsdvowAL5ozgkN3E3Ziorm2pM2kBOZuFuykS7pXteajYIbbV84jUrTwzTKt/J
 awJtAdHcJ9Im3lPKOIsxABjPLcLibncI8wFTFwdgNUoOc41NbDkXu844ARxniVYYk7Zu qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sdq1q88eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:47:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGlHO4061879;
        Mon, 13 May 2019 16:47:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2se0tvntqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:47:18 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DGlDdp020804;
        Mon, 13 May 2019 16:47:14 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 16:47:13 +0000
Subject: Re: [RFC KVM 19/27] kvm/isolation: initialize the KVM page table with
 core mappings
To:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-20-git-send-email-alexandre.chartre@oracle.com>
 <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <463b86c8-e9a0-fc13-efa4-31df3aea8e54@oracle.com>
Date:   Mon, 13 May 2019 18:47:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/19 5:50 PM, Dave Hansen wrote:
>> +	/*
>> +	 * Copy the mapping for all the kernel text. We copy at the PMD
>> +	 * level since the PUD is shared with the module mapping space.
>> +	 */
>> +	rv = kvm_copy_mapping((void *)__START_KERNEL_map, KERNEL_IMAGE_SIZE,
>> +	     PGT_LEVEL_PMD);
>> +	if (rv)
>> +		goto out_uninit_page_table;
> 
> Could you double-check this?  We (I) have had some repeated confusion
> with the PTI code and kernel text vs. kernel data vs. __init.
> KERNEL_IMAGE_SIZE looks to be 512MB which is quite a bit bigger than
> kernel text.

I probably have the same confusion :-) but I will try to check again.


>> +	/*
>> +	 * Copy the mapping for cpu_entry_area and %esp fixup stacks
>> +	 * (this is based on the PTI userland address space, but probably
>> +	 * not needed because the KVM address space is not directly
>> +	 * enterered from userspace). They can both be copied at the P4D
>> +	 * level since they each have a dedicated P4D entry.
>> +	 */
>> +	rv = kvm_copy_mapping((void *)CPU_ENTRY_AREA_PER_CPU, P4D_SIZE,
>> +	     PGT_LEVEL_P4D);
>> +	if (rv)
>> +		goto out_uninit_page_table;
> 
> cpu_entry_area is used for more than just entry from userspace.  The gdt
> mapping, for instance, is needed everywhere.  You might want to go look
> at 'struct cpu_entry_area' in some more detail.

Ok. Thanks.

>> +#ifdef CONFIG_X86_ESPFIX64
>> +	rv = kvm_copy_mapping((void *)ESPFIX_BASE_ADDR, P4D_SIZE,
>> +	     PGT_LEVEL_P4D);
>> +	if (rv)
>> +		goto out_uninit_page_table;
>> +#endif
> 
> Why are these mappings *needed*?  I thought we only actually used these
> fixup stacks for some crazy iret-to-userspace handling.  We're certainly
> not doing that from KVM context.

Right. I initially looked what was used for PTI, and I probably copied unneeded
mapping.

> Am I forgetting something?
> 
>> +#ifdef CONFIG_VMAP_STACK
>> +	/*
>> +	 * Interrupt stacks are vmap'ed with guard pages, so we need to
>> +	 * copy mappings.
>> +	 */
>> +	for_each_possible_cpu(cpu) {
>> +		stack = per_cpu(hardirq_stack_ptr, cpu);
>> +		pr_debug("IRQ Stack %px\n", stack);
>> +		if (!stack)
>> +			continue;
>> +		rv = kvm_copy_ptes(stack - IRQ_STACK_SIZE, IRQ_STACK_SIZE);
>> +		if (rv)
>> +			goto out_uninit_page_table;
>> +	}
>> +
>> +#endif
> 
> I seem to remember that the KVM VMENTRY/VMEXIT context is very special.
>   Interrupts (and even NMIs?) are disabled.  Would it be feasible to do
> the switching in there so that we never even *get* interrupts in the KVM
> context?

Ideally we would like to run with the KVM address space when handling a VM-exit
(so between a VMEXIT and the next VMENTER) where interrupts are not disabled.

> I also share Peter's concerns about letting modules do this.  If we ever
> go down this road, we're going to have to think very carefully how we
> let KVM do this without giving all the not-so-nice out-of-tree modules
> the keys to the castle.

Right, we probably need some more generic framework for creating limited
kernel context space which kvm (or other module?) can deal with. I think
kvm is a good place to start for having this kind of limited context, hence
this RFC and my request for advice how best to do it.

> A high-level comment: it looks like this is "working", but has probably
> erred on the side of mapping too much.  The hard part is paring this
> back to a truly minimal set of mappings.
> 

Agree.

Thanks,

alex.
