Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C67680AA
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfGNSRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 14:17:44 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:35144 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbfGNSRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 14:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1563128261; x=1594664261;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yU8Er0dM4xN+kO/PufN1rVisDCrwrEjJU9iRQpgHWz0=;
  b=WSMIOs2rvTU4hHyWlfV3AOhx/1em3Ciux8Y4UyGeLvVqJd13vXZ8B82S
   6akzHA5HykuIeiTfZxJBxO5m1nJ+ikGCSY5FLoQ8ncLHekMWF1WM6cmP0
   n5Lrr8vUjQvSw0csNve+l4zyFPlF/RJfZ0URXseuSee9I4tTvr2aehAH0
   0=;
X-IronPort-AV: E=Sophos;i="5.62,491,1554768000"; 
   d="scan'208";a="410612451"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 14 Jul 2019 18:17:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 08C93A243C;
        Sun, 14 Jul 2019 18:17:37 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 14 Jul 2019 18:17:37 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.177) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 14 Jul 2019 18:17:32 +0000
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Andy Lutomirski <luto@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <jan.setjeeilers@oracle.com>, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <a03db3a5-b033-a469-cc6c-c8c86fb25710@oracle.com>
 <CALCETrVcM-SpEqLMJSOdyGuN0gjr+97+cpu2KYneuTv1fJDoog@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <849b74ba-2ce4-04e9-557c-6d8c8ec29e16@amazon.com>
Date:   Sun, 14 Jul 2019 20:17:30 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALCETrVcM-SpEqLMJSOdyGuN0gjr+97+cpu2KYneuTv1fJDoog@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.177]
X-ClientProxiedBy: EX13D02UWC003.ant.amazon.com (10.43.162.199) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.07.19 16:36, Andy Lutomirski wrote:
> On Fri, Jul 12, 2019 at 6:45 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>>
>> On 7/12/19 2:50 PM, Peter Zijlstra wrote:
>>> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
>>>
>>>> I think that's precisely what makes ASI and PTI different and independent.
>>>> PTI is just about switching between userland and kernel page-tables, while
>>>> ASI is about switching page-table inside the kernel. You can have ASI without
>>>> having PTI. You can also use ASI for kernel threads so for code that won't
>>>> be triggered from userland and so which won't involve PTI.
>>>
>>> PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
>>> ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
>>>
>>> See how very similar they are?
>>>
>>>
>>> Furthermore, to recover SMT for userspace (under MDS) we not only need
>>> core-scheduling but core-scheduling per address space. And ASI was
>>> specifically designed to help mitigate the trainwreck just described.
>>>
>>> By explicitly exposing (hopefully harmless) part of the kernel to MDS,
>>> we reduce the part that needs core-scheduling and thus reduce the rate
>>> the SMT siblngs need to sync up/schedule.
>>>
>>> But looking at it that way, it makes no sense to retain 3 address
>>> spaces, namely:
>>>
>>>     user / kernel exposed / kernel private.
>>>
>>> Specifically, it makes no sense to expose part of the kernel through MDS
>>> but not through Meltdow. Therefore we can merge the user and kernel
>>> exposed address spaces.
>>
>> The goal of ASI is to provide a reduced address space which exclude sensitive
>> data. A user process (for example a database daemon, a web server, or a vmm
>> like qemu) will likely have sensitive data mapped in its user address space.
>> Such data shouldn't be mapped with ASI because it can potentially leak to the
>> sibling hyperthread. For example, if an hyperthread is running a VM then the
>> VM could potentially access user sensitive data if they are mapped on the
>> sibling hyperthread with ASI.
> 
> So I've proposed the following slightly hackish thing:
> 
> Add a mechanism (call it /dev/xpfo).  When you open /dev/xpfo and
> fallocate it to some size, you allocate that amount of memory and kick
> it out of the kernel direct map.  (And pay the IPI cost unless there
> were already cached non-direct-mapped pages ready.)  Then you map
> *that* into your VMs.  Now, for a dedicated VM host, you map *all* the
> VM private memory from /dev/xpfo.  Pretend it's SEV if you want to
> determine which pages can be set up like this.
> 
> Does this get enough of the benefit at a negligible fraction of the
> code complexity cost?  (This plus core scheduling, anyway.)

The problem with that approach is that you lose the ability to run 
legacy workloads that do not support an SEV like model of "guest owned" 
and "host visible" pages, but instead assume you can DMA anywhere.

Without that, your host will have visibility into guest pages via user 
space (QEMU) pages which again are mapped in the kernel direct map, so 
can be exposed via a spectre gadget into a malicious guest.

Also, please keep in mind that even register state of other VMs may be a 
secret that we do not want to leak into other guests.


Alex
