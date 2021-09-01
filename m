Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF83FE00E
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245407AbhIAQiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:38:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245300AbhIAQiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630514245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaXvq8CHBS7mwji7NsTxccjCmayM+ohRvagESdHP8T4=;
        b=aqod+g8/gUIoUYApN6YUHzmOOzm2rh9C5X/RlWGfKt8HJNy+Lo2eNFStj2svlzd9KZ8nEB
        kXmdauIAWmRoDn4DF7YYe2eRmw+9fgclZt+yrDRluGWrVvPpnbItnmwJTf/NALt7DHEHFQ
        x8+he8Rr/KvUxUjeewuIFVhidOqSJ3w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-sfNP8xVAMAamsy_kxk2c3Q-1; Wed, 01 Sep 2021 12:37:24 -0400
X-MC-Unique: sfNP8xVAMAamsy_kxk2c3Q-1
Received: by mail-wm1-f72.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so96944wmc.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 09:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eaXvq8CHBS7mwji7NsTxccjCmayM+ohRvagESdHP8T4=;
        b=fyrQk1Rq1XoAKDyD/QQaRwZv4h+Hjlei6QZOn/Er5D/amNS3lYdd65yfSE17bhEUhL
         hIglA/uZjhfSd9uEYVwtG1BdWFZDP/yL5XKrlZl9/OzFyOBBcac56+PXq9Z7JLFWd6k5
         +NffTxwj7pXtYQCduTZH2JFhL77sYHBh7Lt9fUbBCMmnBlH23rvekmf6jUS4DRuHwabf
         woCZgmg41Q8WFGtozgNM6RygEpgDkQoX3BB4n6aFYQCpSacHQEbNlpYrQrNFI39vxM9C
         3tKQ5n3iVTdEGkSnegt/6D8MVQ4Tm3J9pydV66PEtMmmsFrnDPi5ExXXi8bzfzvm7Eup
         wP0g==
X-Gm-Message-State: AOAM532WUP5fRx090PFLHLAIpHW349G87CZUehb9ceiunjtOPbf8nTcj
        NnFFTp64t0QG1432/1IYevK+SF6RuiOanHjCMZFgkwl/+RRxbrLIRTtNDkeIuCpufDTb0+Fa8Dd
        ChMjjTFBrjvHv
X-Received: by 2002:adf:eac5:: with SMTP id o5mr367655wrn.22.1630514242964;
        Wed, 01 Sep 2021 09:37:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0zI5HF4KggMhqr5cBDmXzqiVSCZVqk3w0Sggt+1+T/x/p4eO8o9zUUZVCVxj4ftt8Wn1rJg==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr367624wrn.22.1630514242736;
        Wed, 01 Sep 2021 09:37:22 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id n1sm21391441wrp.49.2021.09.01.09.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:37:22 -0700 (PDT)
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
 <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
 <0d6b2a7e22f5e27e03abc21795124ccd66655966.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <1a4a1548-7e14-c2b4-e210-cc60a2895acd@redhat.com>
Date:   Wed, 1 Sep 2021 18:37:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0d6b2a7e22f5e27e03abc21795124ccd66655966.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 18:31, James Bottomley wrote:
> On Wed, 2021-09-01 at 18:22 +0200, David Hildenbrand wrote:
>> On 01.09.21 18:18, James Bottomley wrote:
>>> On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
>>> [...]
>>>> If you want to swap a page on TDX, you can't.  Sorry, go directly
>>>> to jail, do not collect $200.
>>>
>>> Actually, even on SEV-ES you can't either.  You can read the
>>> encrypted page and write it out if you want, but unless you swap it
>>> back to the exact same physical memory location, the encryption key
>>> won't work.  Since we don't guarantee this for swap, I think swap
>>> won't actually work for any confidential computing environment.
>>>
>>>> So I think there are literally zero code paths that currently
>>>> call try_to_unmap() that will actually work like that on TDX.  If
>>>> we run out of memory on a TDX host, we can kill the guest
>>>> completely and reclaim all of its memory (which probably also
>>>> involves killing QEMU or whatever other user program is in
>>>> charge), but that's really our only option.
>>>
>>> I think our only option for swap is guest co-operation.  We're
>>> going to have to inflate a balloon or something in the guest and
>>> have the guest driver do some type of bounce of the page, where it
>>> becomes an unencrypted page in the guest (so the host can read it
>>> without the physical address keying of the encryption getting in
>>> the way) but actually encrypted with a swap transfer key known only
>>> to the guest.  I assume we can use the page acceptance
>>> infrastructure currently being discussed elsewhere to do swap back
>>> in as well ... the host provides the guest with the encrypted swap
>>> page and the guest has to decrypt it and place it in encrypted
>>> guest memory.
>>
>> Ballooning is indeed *the* mechanism to avoid swapping in the
>> hypervisor  and much rather let the guest swap. Shame it requires
>> trusting a guest, which we, in general, can't. Not to mention other
>> issues we already do have with ballooning (latency, broken auto-
>> ballooning, over-inflating, ...).
> 
> 
> Well not necessarily, but it depends how clever we want to get.  If you
> look over on the OVMF/edk2 list, there's a proposal to do guest
> migration via a mirror VM that invokes a co-routine embedded in the
> OVMF binary:

Yes, I heard of that. "Interesting" design.

> 
> https://patchew.org/EDK2/20210818212048.162626-1-tobin@linux.ibm.com/
> 
> This gives us a page encryption mechanism that's provided by the host
> but accepted via the guest using attestation, meaning we have a
> mutually trusted piece of code that can use to extract encrypted pages.
> It does seem it could be enhanced to do swapping for us as well if
> that's a road we want to go down?

Right, but that's than no longer ballooning, unless I am missing 
something important. You'd ask the guest to export/import, and you can 
trust it. But do we want to call something like that out of random 
kernel context when swapping/writeback, ...? Hard to tell. Feels like it 
won't win in a beauty contest.

-- 
Thanks,

David / dhildenb

