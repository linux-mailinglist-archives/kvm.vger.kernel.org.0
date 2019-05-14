Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50941C63E
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 11:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfENJmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 05:42:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40494 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfENJmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 05:42:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E9cprn123136;
        Tue, 14 May 2019 09:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=YGDQa1OkuMiXUV4tNUheY+38sI8XlHHOPmmUhcxpfkg=;
 b=s5uOWBtyx5/VI95COzKSHJ/b/LVqo+7GlEl1DbKKVD33BRoJAKQq1nRPIAqjgas9q0L/
 mwMEaaJxbDV3Pf5hxsGOBzlfSwtaF2pgC1uPZdmOl/JvXhfVp+8TUwwxvgkCOxrplHWU
 77HLbDKF18hazfA1PjCoqLA3NFAGX43RJlzJRgbsEHbIyUgo/OIceeIiY+GaIr9y6Aa0
 DLq2s0dWRNoDJQRTcM9WJBbBqkFwCytNxeElFSr4bE1sbm2a0EjNlVGCJ7BtminobseM
 +i7Xa0HWfSx4EalKWyakdHJodZyFqpHs917sLRUUbOyKmNFELd29+Xu/claf3qQnx5yn aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sdkwdmwam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 09:41:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E9fGlY003658;
        Tue, 14 May 2019 09:41:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sdmeayt91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 09:41:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4E9fkZN010996;
        Tue, 14 May 2019 09:41:46 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 02:41:45 -0700
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net>
 <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
Date:   Tue, 14 May 2019 11:41:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140070
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140070
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/14/19 10:34 AM, Andy Lutomirski wrote:
> 
> 
>> On May 14, 2019, at 1:25 AM, Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>
>>
>>> On 5/14/19 9:09 AM, Peter Zijlstra wrote:
>>>> On Mon, May 13, 2019 at 11:18:41AM -0700, Andy Lutomirski wrote:
>>>> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
>>>> <alexandre.chartre@oracle.com> wrote:
>>>>>
>>>>> pcpu_base_addr is already mapped to the KVM address space, but this
>>>>> represents the first percpu chunk. To access a per-cpu buffer not
>>>>> allocated in the first chunk, add a function which maps all cpu
>>>>> buffers corresponding to that per-cpu buffer.
>>>>>
>>>>> Also add function to clear page table entries for a percpu buffer.
>>>>>
>>>>
>>>> This needs some kind of clarification so that readers can tell whether
>>>> you're trying to map all percpu memory or just map a specific
>>>> variable.  In either case, you're making a dubious assumption that
>>>> percpu memory contains no secrets.
>>> I'm thinking the per-cpu random pool is a secrit. IOW, it demonstrably
>>> does contain secrits, invalidating that premise.
>>
>> The current code unconditionally maps the entire first percpu chunk
>> (pcpu_base_addr). So it assumes it doesn't contain any secret. That is
>> mainly a simplification for the POC because a lot of core information
>> that we need, for example just to switch mm, are stored there (like
>> cpu_tlbstate, current_task...).
> 
> I don’t think you should need any of this.
> 

At the moment, the current code does need it. Otherwise it can't switch from
kvm mm to kernel mm: switch_mm_irqs_off() will fault accessing "cpu_tlbstate",
and then the page fault handler will fail accessing "current" before calling
the kvm page fault handler. So it will double fault or loop on page faults.
There are many different places where percpu variables are used, and I have
experienced many double fault/page fault loop because of that.

>>
>> If the entire first percpu chunk effectively has secret then we will
>> need to individually map only buffers we need. The kvm_copy_percpu_mapping()
>> function is added to copy mapping for a specified percpu buffer, so
>> this used to map percpu buffers which are not in the first percpu chunk.
>>
>> Also note that mapping is constrained by PTE (4K), so mapped buffers
>> (percpu or not) which do not fill a whole set of pages can leak adjacent
>> data store on the same pages.
>>
>>
> 
> I would take a different approach: figure out what you need and put it in its
> own dedicated area, kind of like cpu_entry_area.

That's certainly something we can do, like Julian proposed with "Process-local
memory allocations": https://lkml.org/lkml/2018/11/22/1240

That's fine for buffers allocated from KVM, however, we will still need some
core kernel mappings so the thread can run and interrupts can be handled.

> One nasty issue you’ll have is vmalloc: the kernel stack is in the
> vmap range, and, if you allow access to vmap memory at all, you’ll
> need some way to ensure that *unmap* gets propagated. I suspect the
> right choice is to see if you can avoid using the kernel stack at all
> in isolated mode.  Maybe you could run on the IRQ stack instead.

I am currently just copying the task stack mapping into the KVM page table
(patch 23) when a vcpu is created:

	err = kvm_copy_ptes(tsk->stack, THREAD_SIZE);

And this seems to work. I am clearing the mapping when the VM vcpu is freed,
so I am making the assumption that the same task is used to create and free
a vcpu.


alex.
