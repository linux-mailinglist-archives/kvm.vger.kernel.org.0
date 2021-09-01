Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9902A3FDFBC
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245282AbhIAQXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234050AbhIAQXI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630513330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kuwA3a8VRWyiF+2itRlcJL8JZbLVL9d2O5cOM0SFnRU=;
        b=iDVVpleIvDt3sj7hH04SYQZKSEAGfQbBZL1pYYl11pfwIvAquOGyd5oBr1s3A5d9186Lt9
        VAJHdzGU74fsvYvooEH6C0+ev9wW0TjGAL6mran1mlZnO6WZ//Dt7kZHBR6YgSEZGGZ/Ee
        mDiDxmFVdLLfYpM/gIrnyNo+duIuUMg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-zZxN8ugpPOai8H4qkxmWLw-1; Wed, 01 Sep 2021 12:22:09 -0400
X-MC-Unique: zZxN8ugpPOai8H4qkxmWLw-1
Received: by mail-wm1-f71.google.com with SMTP id j145-20020a1c2397000000b002ea321114f7so83717wmj.7
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 09:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kuwA3a8VRWyiF+2itRlcJL8JZbLVL9d2O5cOM0SFnRU=;
        b=eU/zIlKPvKMqn6j1Tf8yzTB2yCMqsq4nnp5clmbeEi/Q+IPvlalgbIS5E67hvkXVPB
         fD+dStr1blwFyaXC+PjJiUcUABvN0SxwttuSzUxe4ON9WuGJtR/5w3yN+OWzRhOA6GCW
         8wX5amicO0E0TaZbNilqG1PGxgOwFzwTccq3Ry/Jr8GgiX1G9eVY2s/WHYNaA2uWeP7b
         0VuePp/yfyiVicSmSseV9xpQVg4mvAWYzYHWUS5hAWEPz93kP613bYiholw3rFIjJW0G
         LKGZqk1UJP4EayUFyC2zWblb0hGnvgkuXGibpGKrIQt4LQLTOUOjqIX9ZKUaB8vmE7VT
         /AMw==
X-Gm-Message-State: AOAM533HYe6L+wxq7+3C1koXyDn3zUXGp/3eH3ZIza0354kj7jXVkSVP
        AgCkFiwF9+P10a6KCqXJe+ANPb9Nfjtb/KrH/kPwelW9F8a56n/xJ7EnG+wtEo2vPq9Zm9tioCU
        BCd+Aksw4kaZw
X-Received: by 2002:a5d:5441:: with SMTP id w1mr219204wrv.280.1630513328548;
        Wed, 01 Sep 2021 09:22:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMeavg6INqoWZwHlPtck8LgKcacomg/7RET1DPeO3xXFNSw6hOlYKr+pCFep6oFcJQhqOzMQ==
X-Received: by 2002:a5d:5441:: with SMTP id w1mr219161wrv.280.1630513328354;
        Wed, 01 Sep 2021 09:22:08 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id q85sm31443wme.23.2021.09.01.09.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:22:07 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     jejb@linux.ibm.com, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
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
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
Date:   Wed, 1 Sep 2021 18:22:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 18:18, James Bottomley wrote:
> On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
> [...]
>> If you want to swap a page on TDX, you can't.  Sorry, go directly to
>> jail, do not collect $200.
> 
> Actually, even on SEV-ES you can't either.  You can read the encrypted
> page and write it out if you want, but unless you swap it back to the
> exact same physical memory location, the encryption key won't work.
> Since we don't guarantee this for swap, I think swap won't actually
> work for any confidential computing environment.
> 
>> So I think there are literally zero code paths that currently call
>> try_to_unmap() that will actually work like that on TDX.  If we run
>> out of memory on a TDX host, we can kill the guest completely and
>> reclaim all of its memory (which probably also involves killing QEMU
>> or whatever other user program is in charge), but that's really our
>> only option.
> 
> I think our only option for swap is guest co-operation.  We're going to
> have to inflate a balloon or something in the guest and have the guest
> driver do some type of bounce of the page, where it becomes an
> unencrypted page in the guest (so the host can read it without the
> physical address keying of the encryption getting in the way) but
> actually encrypted with a swap transfer key known only to the guest.  I
> assume we can use the page acceptance infrastructure currently being
> discussed elsewhere to do swap back in as well ... the host provides
> the guest with the encrypted swap page and the guest has to decrypt it
> and place it in encrypted guest memory.

Ballooning is indeed *the* mechanism to avoid swapping in the hypervisor 
and much rather let the guest swap. Shame it requires trusting a guest, 
which we, in general, can't. Not to mention other issues we already do 
have with ballooning (latency, broken auto-ballooning, over-inflating, ...).

-- 
Thanks,

David / dhildenb

