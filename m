Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F67435571A
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbhDFO6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 10:58:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233270AbhDFO6E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 10:58:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617721075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKDcOIFPZJ62VRJvhDT2hmTM6kAbID3Fjqmj7ekGUOQ=;
        b=QWOcBxTot9ikVhkkKTuX2WPmgA9zqtsmn9ml90vrICeIy7l8yuRaDOdeqrsN4m0QyVZ8Ie
        r8BJHlpzO/rj5fCUuBuO/l/lUA/jT6VjgqmtLa+WmCqY+ByfosMqgl6zH3r4BL/1MJtifR
        uuez+XWpJCnKkihlFsB7OtW8MslSdlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-UtF-KEdZMee-b0oXQVGlcA-1; Tue, 06 Apr 2021 10:57:54 -0400
X-MC-Unique: UtF-KEdZMee-b0oXQVGlcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C323E99C4;
        Tue,  6 Apr 2021 14:57:52 +0000 (UTC)
Received: from [10.36.113.79] (ovpn-113-79.ams2.redhat.com [10.36.113.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35E7A5D9D0;
        Tue,  6 Apr 2021 14:57:47 +0000 (UTC)
To:     Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
 <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
Date:   Tue, 6 Apr 2021 16:57:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.04.21 16:33, Dave Hansen wrote:
> On 4/6/21 12:44 AM, David Hildenbrand wrote:
>> On 02.04.21 17:26, Kirill A. Shutemov wrote:
>>> TDX architecture aims to provide resiliency against confidentiality and
>>> integrity attacks. Towards this goal, the TDX architecture helps enforce
>>> the enabling of memory integrity for all TD-private memory.
>>>
>>> The CPU memory controller computes the integrity check value (MAC) for
>>> the data (cache line) during writes, and it stores the MAC with the
>>> memory as meta-data. A 28-bit MAC is stored in the ECC bits.
>>>
>>> Checking of memory integrity is performed during memory reads. If
>>> integrity check fails, CPU poisones cache line.
>>>
>>> On a subsequent consumption (read) of the poisoned data by software,
>>> there are two possible scenarios:
>>>
>>>    - Core determines that the execution can continue and it treats
>>>      poison with exception semantics signaled as a #MCE
>>>
>>>    - Core determines execution cannot continue,and it does an unbreakable
>>>      shutdown
>>>
>>> For more details, see Chapter 14 of Intel TDX Module EAS[1]
>>>
>>> As some of integrity check failures may lead to system shutdown host
>>> kernel must not allow any writes to TD-private memory. This requirment
>>> clashes with KVM design: KVM expects the guest memory to be mapped into
>>> host userspace (e.g. QEMU).
>>
>> So what you are saying is that if QEMU would write to such memory, it
>> could crash the kernel? What a broken design.
> 
> IMNHO, the broken design is mapping the memory to userspace in the first
> place.  Why the heck would you actually expose something with the MMU to
> a context that can't possibly meaningfully access or safely write to it?

I'd say the broken design is being able to crash the machine via a 
simple memory write, instead of only crashing a single process in case 
you're doing something nasty. From the evaluation of the problem it 
feels like this was a CPU design workaround: instead of properly 
cleaning up when it gets tricky within the core, just crash the machine. 
And that's a CPU "feature", not a kernel "feature". Now we have to fix 
broken HW in the kernel - once again.

However, you raise a valid point: it does not make too much sense to to 
map this into user space. Not arguing against that; but crashing the 
machine is just plain ugly.

I wonder: why do we even *want* a VMA/mmap describing that memory? 
Sounds like: for hacking support for that memory type into QEMU/KVM.

This all feels wrong, but I cannot really tell how it could be better. 
That memory can really only be used (right now?) with hardware 
virtualization from some point on. From that point on (right from the 
start?), there should be no VMA/mmap/page tables for user space anymore.

Or am I missing something? Is there still valid user space access?

> 
> This started with SEV.  QEMU creates normal memory mappings with the SEV
> C-bit (encryption) disabled.  The kernel plumbs those into NPT, but when
> those are instantiated, they have the C-bit set.  So, we have mismatched
> mappings.  Where does that lead?  The two mappings not only differ in
> the encryption bit, causing one side to read gibberish if the other
> writes: they're not even cache coherent.
> 
> That's the situation *TODAY*, even ignoring TDX.
> 
> BTW, I'm pretty sure I know the answer to the "why would you expose this
> to userspace" question: it's what QEMU/KVM did alreadhy for
> non-encrypted memory, so this was the quickest way to get SEV working.
> 

Yes, I guess so. It was the fastest way to "hack" it into QEMU.

Would we ever even want a VMA/mmap/process page tables for that memory? 
How could user space ever do something *not so nasty* with that memory 
(in the current context of VMs)?

-- 
Thanks,

David / dhildenb

