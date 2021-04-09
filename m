Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7177335A056
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhDINvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 09:51:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233119AbhDINvG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 09:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617976252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1H7JWflEbUBrMm/ruOiyuJWmABK/tUM47hXSqXsjLEk=;
        b=brHMTT98acAKkO742KGilxtJ2AEIVaUmd6u7cOcP9wHOw0ZAmbxm+vohuXqo4y8p3/0rjS
        63gAWyQkTkADHbCjRX4oxKJXrMSskxL9mxYQFU/0c5D9s/9kdCfdkAtZLqhlwGLySlW5Dj
        u1Pkr7MCwH24S7g7dElHZdVkeYrVCrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372--FpuoU--OZqC7O2CBWnmIw-1; Fri, 09 Apr 2021 09:50:49 -0400
X-MC-Unique: -FpuoU--OZqC7O2CBWnmIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E4E281425A;
        Fri,  9 Apr 2021 13:50:47 +0000 (UTC)
Received: from [10.36.115.11] (ovpn-115-11.ams2.redhat.com [10.36.115.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AA635D9E3;
        Fri,  9 Apr 2021 13:50:43 +0000 (UTC)
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
 <20210409133347.r2uf3u5g55pp27xn@box>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <5ef83789-ffa5-debd-9ea2-50d831262237@redhat.com>
Date:   Fri, 9 Apr 2021 15:50:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210409133347.r2uf3u5g55pp27xn@box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> It looks quite hacky (well, what did I expect from an RFC :) ) you can no
>> longer distinguish actually poisoned pages from "temporarily poisoned"
>> pages. FOLL_ALLOW_POISONED sounds especially nasty and dangerous -  "I want
>> to read/write a poisoned page, trust me, I know what I am doing".
>>
>> Storing the state for each individual page initially sounded like the right
>> thing to do, but I wonder if we couldn't handle this on a per-VMA level. You
>> can just remember the handful of shared ranges internally like you do right
>> now AFAIU.
> 
> per-VMA would not fly for file-backed (e.g. tmpfs) memory. We may need to
> combine PG_hwpoison with VMA flag. Maybe per-inode tracking would also be
> required. Or per-memslot. I donno. Need more experiments.

Indeed.

> 
> Note, I use PG_hwpoison now, but if we find a show-stopper issue where we
> would see confusion with a real poison, we can switch to new flags and
> a new swap_type(). I have not seen a reason yet.

I think we'll want a dedicate mechanism to cleanly mark pages as 
"protected". Finding a page flag you can use will be the problematic 
part, but should not be impossible if we have a good reason to do so 
(even if it means making the feature mutually exclusive with other 
features).

> 
>>  From what I get, you want a way to
>>
>> 1. Unmap pages from the user space page tables.
> 
> Plain unmap would not work for some use-cases. Some CSPs want to
> preallocate memory in a specific way. It's a way to provide a fine-grained
> NUMA policy.
> 
> The existing mapping has to be converted.
> 
>> 2. Disallow re-faulting of the protected pages into the page tables. On user
>> space access, you want to deliver some signal (e.g., SIGBUS).
> 
> Note that userspace mapping is the only source of pfn's for VM's shadow
> mapping. The fault should be allow, but lead to non-present PTE that still
> encodes pfn.

Makes sense, but I guess that's the part still to be implemented (see 
next comment).

> 
>> 3. Allow selected users to still grab the pages (esp. KVM to fault them into
>> the page tables).
> 
> As long as fault leads to non-present PTEs we are fine. Usespace still may
> want to mlock() some of guest memory. There's no reason to prevent this.

I'm curious, even get_user_pages() will lead to a present PTE as is, no? 
So that will need modifications I assume. (although I think it 
fundamentally differs to the way get_user_pages() works - trigger a 
fault first, then lookup the PTE in the page tables).

>> 4. Allow access to currently shared specific pages from user space.
>>
>> Right now, you achieve
>>
>> 1. Via try_to_unmap()
>> 2. TestSetPageHWPoison
>> 3. TBD (e.g., FOLL_ALLOW_POISONED)
>> 4. ClearPageHWPoison()
>>
>>
>> If we could bounce all writes to shared pages through the kernel, things
>> could end up a little easier. Some very rough idea:
>>
>> We could let user space setup VM memory as
>> mprotect(PROT_READ) (+ PROT_KERNEL_WRITE?), and after activating protected
>> memory (I assume via a KVM ioctl), make sure the VMAs cannot be set to
>> PROT_WRITE anymore. This would already properly unmap and deliver a SIGSEGV
>> when trying to write from user space.
>>
>> You could then still access the pages, e.g., via FOLL_FORCE or a new fancy
>> flag that allows to write with VM_MAYWRITE|VM_DENYUSERWRITE. This would
>> allow an ioctl to write page content and to map the pages into NPTs.
>>
>> As an extension, we could think about (re?)mapping some shared pages
>> read|write. The question is how to synchronize with user space.
>>
>> I have no idea how expensive would be bouncing writes (and reads?) through
>> the kernel. Did you ever experiment with that/evaluate that?
> 
> It's going to be double bounce buffer: on the guest we force swiotlb to
> make it go through shared region. I don't think it's a good idea.

So if it's already slow, do we really care? ;)

> 
> There are a number of way to share a memory. It's going to be decided by
> the way we get these pages unmapped in the first place.

I agree that shared memory can be somewhat problematic and would require 
tracking it per page.

-- 
Thanks,

David / dhildenb

