Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3F3FCD9C
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 21:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbhHaTNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 15:13:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238332AbhHaTNp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 15:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630437169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3R8+9xCMOWLuSi664S67yIHwiGeNUaH36y7wRqkQk8=;
        b=Qp8QsZwJN2uTiyEF7iZ3DWp/W/mTd4N5FzHf2OsX7Z0Be7A2zkeMOzBXKT6YKaJiiSrQEr
        ElQRsGpBZpyfqNs6KUmvW1waphRLp7oq50WfwPfm+NH9cTn3wZTzxwl6MM9ne4hMIFLtc/
        gZ5Lx6kolruThwJROZTKSIFlRrtXFRo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-_XoyE_t1NfiWuqlVo-EtiQ-1; Tue, 31 Aug 2021 15:12:47 -0400
X-MC-Unique: _XoyE_t1NfiWuqlVo-EtiQ-1
Received: by mail-wr1-f69.google.com with SMTP id p10-20020a5d68ca000000b001552bf8b9daso136511wrw.22
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=B3R8+9xCMOWLuSi664S67yIHwiGeNUaH36y7wRqkQk8=;
        b=C8t1pR0ojj2Wu4i2lB4AsR5rMbu5miyvazh7lD1Z86ano0i2JoU4ys6NltHP+DvTbA
         49jhaVM2UqArRMeZyWKX7agJzG/7h05mjORWD5tGDxPDP0gQKa+I5m4uDKJKPpWUOS0K
         wGTnD0vU//kxN1Vw8joClXtz8oEtN0Jty+CCQGDt2IPwcQAJ4rlRsDgZzR0ZhvVRsDpK
         7g8E52kqcKrXjEmesFRS++zAu2mm5T74W6QJeBKHF2F5xVJd3cVJY7rLTDZa09yv3gAz
         czB1QtGP+jAqNqj55J5qjTQQADHBPAWo3fYiFLatb9ZsAG/eYLxWNoxB5Wgs5KWoiRte
         idfg==
X-Gm-Message-State: AOAM530A7daoaO/2OO68UWnS2RlaG528FQxZv7TFXnZEnBoHclryLmlJ
        V7h58KrFEbGtBfjDa8vYvt2ahg5ISQ0Zk2IRESF5cr+56SgTB/Ikm49AJtcRrQcpXRliQVbBT3P
        3CeZp7CFFUQKv
X-Received: by 2002:a1c:f315:: with SMTP id q21mr5819458wmq.76.1630437166300;
        Tue, 31 Aug 2021 12:12:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiLNTwKQMvs3colTkzHCAECIzU7cGUrdshsPwDbRyk3ubr6ahQwvcGeQbVyq70Sw5+SV5+fA==
X-Received: by 2002:a1c:f315:: with SMTP id q21mr5819425wmq.76.1630437166118;
        Tue, 31 Aug 2021 12:12:46 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bf5.dip0.t-ipconnect.de. [79.242.59.245])
        by smtp.gmail.com with ESMTPSA id f5sm3231993wmb.47.2021.08.31.12.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 12:12:45 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <40af9d25-c854-8846-fdab-13fe70b3b279@kernel.org>
 <cfe75e39-5927-c02a-b8bc-4de026bb7b3b@redhat.com>
 <73319f3c-6f5e-4f39-a678-7be5fddd55f2@www.fastmail.com>
 <YSlnJpWh8fdpddTA@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <949e6d95-266d-0234-3b86-6bd3c5267333@redhat.com>
Date:   Tue, 31 Aug 2021 21:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSlnJpWh8fdpddTA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.08.21 00:28, Sean Christopherson wrote:
> On Fri, Aug 27, 2021, Andy Lutomirski wrote:
>>
>> On Thu, Aug 26, 2021, at 2:26 PM, David Hildenbrand wrote:
>>> On 26.08.21 19:05, Andy Lutomirski wrote:
>>
>>>> Oof.  That's quite a requirement.  What's the point of the VMA once all
>>>> this is done?
>>>
>>> You can keep using things like mbind(), madvise(), ... and the GUP code
>>> with a special flag might mostly just do what you want. You won't have
>>> to reinvent too many wheels on the page fault logic side at least.
> 
> Ya, Kirill's RFC more or less proved a special GUP flag would indeed Just Work.
> However, the KVM page fault side of things would require only a handful of small
> changes to send private memslots down a different path.  Compared to the rest of
> the enabling, it's quite minor.
> 
> The counter to that is other KVM architectures would need to learn how to use the
> new APIs, though I suspect that there will be a fair bit of arch enabling regardless
> of what route we take.
> 
>> You can keep calling the functions.  The implementations working is a
>> different story: you can't just unmap (pte_numa-style or otherwise) a private
>> guest page to quiesce it, move it with memcpy(), and then fault it back in.
> 
> Ya, I brought this up in my earlier reply.  Even the initial implementation (without
> real NUMA support) would likely be painful, e.g. the KVM TDX RFC/PoC adds dedicated
> logic in KVM to handle the case where NUMA balancing zaps a _pinned_ page and then
> KVM fault in the same pfn.  It's not thaaat ugly, but it's arguably more invasive
> to KVM's page fault flows than a new fd-based private memslot scheme.

I might have a different mindset, but less code churn doesn't 
necessarily translate to "better approach".

I'm certainly not pushing for what I proposed (it's a rough, broken 
sketch). I'm much rather trying to come up with alternatives that try 
solving the same issue, handling the identified requirements.

I have a gut feeling that the list of requirements might not be complete 
yet. For example, I wonder if we have to protect against user space 
replacing private pages by shared pages or punishing random holes into 
the encrypted memory fd.

-- 
Thanks,

David / dhildenb

