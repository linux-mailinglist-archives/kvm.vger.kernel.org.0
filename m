Return-Path: <kvm+bounces-2797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C109C7FE188
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1F791C20AD5
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A734C6167E;
	Wed, 29 Nov 2023 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aWfFSrWe"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D316D7F;
	Wed, 29 Nov 2023 13:07:20 -0800 (PST)
Received: from [192.168.4.26] (unknown [47.186.13.91])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9F48020B74C0;
	Wed, 29 Nov 2023 13:07:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F48020B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1701292039;
	bh=g0AY9rrkukTGXOLxBKqEJb1vaakkKHoCObfBMRMkeqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aWfFSrWef7i6zVJabhgmnM4JnmCqk6BrvDkrAAbiBIkBnHQPuwTfObHozAznpz4Bn
	 67aS84GZ/hKOvAy61RmoxVipr08LJ9KgYhyYxV9Zfc+gr9QD2ZTY7JBJ6F92OXI8p8
	 9mn/NAs3EoxT5SKa/o4LBX1a/ygyKoz+jPGoJrpY=
Message-ID: <ea63ae4e-e8ea-4fbf-9383-499e14de2f5e@linux.microsoft.com>
Date: Wed, 29 Nov 2023 15:07:15 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 17/19] heki: x86: Update permissions counters
 during text patching
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Alexander Graf <graf@amazon.com>,
 Chao Peng <chao.p.peng@linux.intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Forrest Yuan Yu <yuanyu@google.com>, James Gowans <jgowans@amazon.com>,
 James Morris <jamorris@linux.microsoft.com>,
 John Andersen <john.s.andersen@intel.com>,
 Marian Rotariu <marian.c.rotariu@gmail.com>,
 =?UTF-8?Q?Mihai_Don=C8=9Bu?= <mdontu@bitdefender.com>,
 =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
 Thara Gopinath <tgopinath@microsoft.com>,
 Trilok Soni <quic_tsoni@quicinc.com>, Wei Liu <wei.liu@kernel.org>,
 Will Deacon <will@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Zahra Tarkhani <ztarkhani@microsoft.com>,
 =?UTF-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
 dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
 x86@kernel.org, xen-devel@lists.xenproject.org
References: <20231113022326.24388-1-mic@digikod.net>
 <20231113022326.24388-18-mic@digikod.net>
 <20231113081929.GA16138@noisy.programming.kicks-ass.net>
 <a52d8885-43cc-4a4e-bb47-9a800070779e@linux.microsoft.com>
 <20231127200841.GZ3818@noisy.programming.kicks-ass.net>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20231127200841.GZ3818@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/27/23 14:08, Peter Zijlstra wrote:
> On Mon, Nov 27, 2023 at 10:48:29AM -0600, Madhavan T. Venkataraman wrote:
>> Apologies for the late reply. I was on vacation. Please see my response below:
>>
>> On 11/13/23 02:19, Peter Zijlstra wrote:
>>> On Sun, Nov 12, 2023 at 09:23:24PM -0500, Mickaël Salaün wrote:
>>>> From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>>>>
>>>> X86 uses a function called __text_poke() to modify executable code. This
>>>> patching function is used by many features such as KProbes and FTrace.
>>>>
>>>> Update the permissions counters for the text page so that write
>>>> permissions can be temporarily established in the EPT to modify the
>>>> instructions in that page.
>>>>
>>>> Cc: Borislav Petkov <bp@alien8.de>
>>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>>>> Cc: Mickaël Salaün <mic@digikod.net>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: Sean Christopherson <seanjc@google.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>> Cc: Wanpeng Li <wanpengli@tencent.com>
>>>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>>>> ---
>>>>
>>>> Changes since v1:
>>>> * New patch
>>>> ---
>>>>  arch/x86/kernel/alternative.c |  5 ++++
>>>>  arch/x86/mm/heki.c            | 49 +++++++++++++++++++++++++++++++++++
>>>>  include/linux/heki.h          | 14 ++++++++++
>>>>  3 files changed, 68 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
>>>> index 517ee01503be..64fd8757ba5c 100644
>>>> --- a/arch/x86/kernel/alternative.c
>>>> +++ b/arch/x86/kernel/alternative.c
>>>> @@ -18,6 +18,7 @@
>>>>  #include <linux/mmu_context.h>
>>>>  #include <linux/bsearch.h>
>>>>  #include <linux/sync_core.h>
>>>> +#include <linux/heki.h>
>>>>  #include <asm/text-patching.h>
>>>>  #include <asm/alternative.h>
>>>>  #include <asm/sections.h>
>>>> @@ -1801,6 +1802,7 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
>>>>  	 */
>>>>  	pgprot = __pgprot(pgprot_val(PAGE_KERNEL) & ~_PAGE_GLOBAL);
>>>>  
>>>> +	heki_text_poke_start(pages, cross_page_boundary ? 2 : 1, pgprot);
>>>>  	/*
>>>>  	 * The lock is not really needed, but this allows to avoid open-coding.
>>>>  	 */
>>>> @@ -1865,7 +1867,10 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
>>>>  	}
>>>>  
>>>>  	local_irq_restore(flags);
>>>> +
>>>>  	pte_unmap_unlock(ptep, ptl);
>>>> +	heki_text_poke_end(pages, cross_page_boundary ? 2 : 1, pgprot);
>>>> +
>>>>  	return addr;
>>>>  }
>>>
>>> This makes no sense, we already use a custom CR3 with userspace alias
>>> for the actual pages to write to, why are you then frobbing permissions
>>> on that *again* ?
>>
>> Today, the permissions for a guest page in the extended page table
>> (EPT) are RWX (unless permissions are restricted for some specific
>> reason like for shadow page table pages). In this Heki feature, we
>> don't allow RWX by default in the EPT. We only allow those permissions
>> in the EPT that the guest page actually needs.  E.g., for a text page,
>> it is R_X in both the guest page table and the EPT.
> 
> To what end? If you always mirror what the guest does, you've not
> actually gained anything.
> 
>> For text patching, the above code establishes an alternate mapping in
>> the guest page table that is RW_ so that the text can be patched. That
>> needs to be reflected in the EPT so that the EPT permissions will
>> change from R_X to RWX. In other words, RWX is allowed only as
>> necessary. At the end of patching, the EPT permissions are restored to
>> R_X.
>>
>> Does that address your comment?
> 
> No, if you want to mirror the native PTEs why don't you hook into the
> paravirt page-table muck and get all that for free?
> 
> Also, this is the user range, are you saying you're also playing these
> daft games with user maps?

I think that we should have done a better job of communicating the threat model in Heki and
how we are trying to address it. I will correct that here. I think this will help answer
many questions. Some of these questions also came up in the LPC when we presented this.
Apologies for the slightly long answer. It is for everyone's benefit. Bear with me.

Threat Model
------------

In the threat model in Heki, the attacker is a user space attacker who exploits
a kernel vulnerability to gain more privileges or bypass the kernel's access
control and self-protection mechanisms. 

In the context of the guest page table, one of the things that the threat model translates
to is a hacker gaining access to a guest page with RWX permissions. E.g., by adding execute
permissions to a writable page or by adding write permissions to an executable page.

Today, the permissions for a guest page in the extended page table are RWX by
default. So, if a hacker manages to establish RWX for a page in the guest page
table, then that is all he needs to do some damage.

How to defeat the threat
------------------------

To defeat this, we need to establish the correct permissions for a guest page
in the extended page table as well. That is, R_X for a text page, R__ for a
read-only page and RW_ for a writable page. The only exception is a guest page
that is mapped via multiple mappings with different permissions in each
mapping. In that case, the collective permissions across all mappings needs
to be established in the extended page table so that all mappings can work.

Mechanism
---------

To achieve all this, Heki finds all the kernel mappings at the end of kernel
boot and reflects their permissions in the extended page table before
kicking off the init process.

During runtime, permissions on a guest page can change because of genuine
kernel operations:
	- vmap/vunmap
	- text patching for FTrace, Kprobes, etc
	- set_memory_*()

In each of these cases as well, the permissions need to be reflected in the
extended page table. In summary, the extended page table permissions mirror
the guest page table ones.

Authentication
--------------

The above approach addresses the case where a hacker tries to directly
modify a guest page table entry. It doesn't matter since the extended page
table permissions are not changed.

Now, the question is - what if a hacker manages to use the Heki primitives
and establish the permissions he wants in the extended page table? All of
this work is for nothing!!

The answer is - authentication. If an entity outside the guest can validate
or authenticate each guest request to change extended page table permissions,
then it can tell a genuine request from an attack. We are planning to make the
VMM that entity. In the case of a genuine request, the VMM will call the
hypervisor and establish the correct permissions in the extended page table.
If the VMM thinks that it is an attack, it will have the hypervisor send an
exception to the guest.

In the current version (RFC V2), we don't have authentication in place. The
VMM is not in the picture yet. This is WIP. We are hoping to implement some
authentication in V3 and improve it as we go forward. So, in V2, we only have
the mechanisms in place.

So, I agree that it is kinda hard to see the value of Heki without authentication.

Kernel Lockdown
---------------

But, we must provide at least some security in V2. Otherwise, it is useless.

So, we have implemented what we call a kernel lockdown. At the end of kernel
boot, Heki establishes permissions in the extended page table as mentioned
before. Also, it adds an immutable attribute for kernel text and kernel RO data.
Beyond that point, guest requests that attempt to modify permissions on any of
the immutable pages will be denied.

This means that features like FTrace and KProbes will not work on kernel text
in V2. This is a temporary limitation. Once authentication is in place, the
limitation will go away.

Additional information
----------------------

The following primitives call Heki functions to reflect guest page table
permissions in the extended page table:

heki_arch_late_init()
	This calls heki_protect().
	
	This is called at the end of kernel boot to protect all guest kernel
	mappings at that point.

vmap_range_noflush()
vmap_small_pages_range_noflush()
	These functions call heki_map().

	These are the lowest level functions called from different places
	to map something in the kernel address space.

set_memory_nx()
set_memory_rw()
	These functions call heki_change_page_attr_set().

set_memory_x()
set_memory_ro()
set_memory_rox()
	These functions call heki_change_page_attr_clear().

__text_poke()
	This function is called by various features to patch text.
	This calls heki_text_poke_start() and heki_text_poke_end().

	heki_text_poke_start() is called to add write permissions to the
	extended page table so that text can be patched. heki_text_poke_end()
	is called to revert write permissions in the extended page table.

User mappings
-------------

All of this work is only for protecting guest kernel mappings. So, the idea is
- the VMM+Hypervisor protect the integrity of the kernel and the kernel
protects the integrity of user land. So, user pages continue to have RWX in the
extended page table. The MBEC feature makes it possible to have separate execute
permission bits in the page table entry for user and kernel.

One final thing
---------------

Peter mentioned the following:

"if you want to mirror the native PTEs why don't you hook into the
paravirt page-table muck and get all that for free?"

We did consider using a shadow page table kind of approach so that guest page table
modifications can be intercepted and reflected in the page table entry. We did not
do this for two reasons:

- there are bits in the page table entry that are not permission bits. We would like
  the guest kernel to be able to modify them directly.

- we cannot tell a genuine request from an attack.

That said, we are still considering making the guest page table read only for added
security. This is WIP. I do not have details yet.

If I have not addressed any comment, please let me know.

As always, thanks for your comments.

Madhavan T Venkataraman





