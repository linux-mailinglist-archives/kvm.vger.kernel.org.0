Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADA640C7D1
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhIOPBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 11:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237723AbhIOPBL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 11:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631717991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXIxfXAeAXwqynGXNUuaFoUXwg+GC8ruNUgtA4V3/Js=;
        b=JJnyV+1lmEahnCaDlKX4ee3VsuDe/NK+aDegZmNvWkvQlbhSVYhhV+9s85ZwOGk5x5yV8l
        m4NzUupcjYRLhQ09ShRv2l0q8UeXkWLoEhTQhSQzzFnq1Q0Sb8Q5MhllAmxS+LfX6MCCHi
        XVq4v5Bd5ETt+vEmZtqeUi1Xv2qOwoA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-uGteOBttMVaFaD2iHPJI_A-1; Wed, 15 Sep 2021 10:59:50 -0400
X-MC-Unique: uGteOBttMVaFaD2iHPJI_A-1
Received: by mail-wm1-f69.google.com with SMTP id g13-20020a1c200d000000b00308ecd761e8so1589692wmg.2
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 07:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sXIxfXAeAXwqynGXNUuaFoUXwg+GC8ruNUgtA4V3/Js=;
        b=lz0mJdanLtusgfc8I0THua49K8hB9F/5mQ+uuy7HSJ8JSkt8nH0RJOZ2TBbTqqKzV3
         wb6IfRePGIkkJeRckfhrgwZVheJuFIKGu0XAFyO5p2BdiXC2NWSNjZdAfUkSbeiawhFO
         RjLZYAl+MF0bK59XSFagV0r0D30c3CdJI027iCET04+IKqDYidZFb7H3SGvEblPptbeZ
         Kg7g+07hz9xi4eVc0O1geXNZmmiOGK5IX+LKkMvoR8m4IXGZPXQL7d/TyeNeNrlZ+wt5
         FK6ybHCsdZZlBBCgSMZJLqaIxBCKq4El7JnRyYSPRl24eLFfwiLb/lCG+wKVHApncLkR
         3EZw==
X-Gm-Message-State: AOAM532uByx1tIRE8NXWt+p9JdcnXI6/SrfvAFWrKTpyRTkKPOhQo/HZ
        Dc7injbILTx1M4Y/LLbaphE0D3j2SI3GFcYz7mbdA93FTr0o+/xuFkr5VjgI+5P8tfKXWa5JPbu
        EGXhvhkqz2cN9
X-Received: by 2002:a5d:630a:: with SMTP id i10mr443961wru.178.1631717989705;
        Wed, 15 Sep 2021 07:59:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1F2FJo1VqmKuCfy3iFBKkDaaKnmp1KJn/dP3v7qU1ZNwTLAenO3hU3flHn7Ro2t9lWiPT1w==
X-Received: by 2002:a5d:630a:: with SMTP id i10mr443929wru.178.1631717989498;
        Wed, 15 Sep 2021 07:59:49 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6426.dip0.t-ipconnect.de. [91.12.100.38])
        by smtp.gmail.com with ESMTPSA id r129sm204926wmr.7.2021.09.15.07.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 07:59:48 -0700 (PDT)
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
 <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
 <20210915195857.GA52522@chaop.bj.intel.com>
 <51a6f74f-6c05-74b9-3fd7-b7cd900fb8cc@redhat.com>
 <20210915142921.bxxsap6xktkt4bek@black.fi.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
Message-ID: <ca80775c-6bcb-f7c2-634b-237bc0ded52a@redhat.com>
Date:   Wed, 15 Sep 2021 16:59:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210915142921.bxxsap6xktkt4bek@black.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> I don't think we are, it still feels like we are in the early prototype
>> phase (even way before a PoC). I'd be happy to see something "cleaner" so to
>> say -- it still feels kind of hacky to me, especially there seem to be many
>> pieces of the big puzzle missing so far. Unfortunately, this series hasn't
>> caught the attention of many -MM people so far, maybe because other people
>> miss the big picture as well and are waiting for a complete design proposal.
>>
>> For example, what's unclear to me: we'll be allocating pages with
>> GFP_HIGHUSER_MOVABLE, making them land on MIGRATE_CMA or ZONE_MOVABLE; then
>> we silently turn them unmovable, which breaks these concepts. Who'd migrate
>> these pages away just like when doing long-term pinning, or how is that
>> supposed to work?
> 
> That's fair point. We can fix it by changing mapping->gfp_mask.

That's essentially what secretmem does when setting up a file.

> 
>> Also unclear to me is how refcount and mapcount will be handled to prevent
>> swapping,
> 
> refcount and mapcount are unchanged. Pages not pinned per se. Swapping
> prevented with the change in shmem_writepage().

So when mapping into the guest, we'd increment the refcount but not the 
mapcount I assume?

> 
>> who will actually do some kind of gfn-epfn etc. mapping, how we'll
>> forbid access to this memory e.g., via /proc/kcore or when dumping memory
> 
> It's not aimed to prevent root to shoot into his leg. Root do root.

IMHO being root is not an excuse to read some random file (actually used 
in production environments) to result in the machine crashing. Not 
acceptable for distributions.

I'm still missing the whole gfn-epfn 1:1 mapping discussion we 
identified as requirements. Is that supposed to be done by KVM? How?

> 
>> ... and how it would ever work with migration/swapping/rmap (it's clearly
>> future work, but it's been raised that this would be the way to make it
>> work, I don't quite see how it would all come together).
> 
> Given that hardware supports it migration and swapping can be implemented
> by providing new callbacks in guest_ops. Like ->migrate_page would
> transfer encrypted data between pages and ->swapout would provide
> encrypted blob that can be put on disk or handled back to ->swapin to
> bring back to memory.

Again, I'm missing the complete picture. To make swapping decisions 
vmscan code needs track+handle dirty+reference information. How would we 
be able to track references? Does the hardware allow for temporary 
unmapping of encrypted memory and faulting on it? How would 
page_referenced() continue working? "we can add callbacks" is not a 
satisfying answer, at least for me. Especially, when it comes to 
eventual locking problems and races.

Maybe saying "migration+swap is not supported" is clearer than "we can 
add callbacks" and missing some details on the bigger picture.

Again, a complete design proposal would be highly valuable, especially 
to get some more review from other -MM folks. Otherwise there is a high 
chance that this will be rejected late when trying to upstream and -MM 
people stumbling over it (we've had some similar thing happening just 
recently unfortunately ...).

-- 
Thanks,

David / dhildenb

