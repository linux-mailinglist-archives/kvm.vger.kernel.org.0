Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039C63649A7
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240743AbhDSSMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240661AbhDSSMl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 14:12:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618855931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yt1B5gSPcHjxLjaX0l94gOJJ7HZzNFqMG6taUUcuBkE=;
        b=Dd2/LBmYRxcxedKWqiZID8kTkzmuv3lLjXkxjPCgG0tC+hgPbZiem5ROCjRriiXPJTOOZs
        RwzXg8tvTariXX3IwLoOjTw1vYZ7zzAyQdXNYV2f8ZdpG9kcutLyvg+gLBg4xFHE8Ke66v
        qc6XsZUNbW4SsFINKyr9l0EPBq6dgbc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-uKR8u0TqPtemawX72zg9gg-1; Mon, 19 Apr 2021 14:12:09 -0400
X-MC-Unique: uKR8u0TqPtemawX72zg9gg-1
Received: by mail-wm1-f72.google.com with SMTP id v5-20020a05600c2145b029012bdd9ddcb7so3278583wml.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Yt1B5gSPcHjxLjaX0l94gOJJ7HZzNFqMG6taUUcuBkE=;
        b=INnJ6s3HPfmQH/4RBGqA8fwBl4U2o224F8RDRUAcaTulc2P9DFU/sgXpBoRvnZw1g4
         eGubMczvK2HvOz0+DMqi5QM1+CNOcN6qbJ+/CtkT3fi4M25Jggvph9zIlque2ckk+n1+
         JFWUdiqB+a1dYgu9aGauQVCT/8aLPyUcgIVsBYl/aIvMgxYAhHGEcWU/oYecbodl/Mf0
         dzQhbuEz05oMuNRgL6RSNUjJX22Hd2oFmjZMHE7IX2dtYPlx0OtW2mj7jOiat3dSubYa
         zDN5UbG8O+7y84YXNYcp7t10oohI5omQDfb1HY6FnHOUoGacEY8JvYh+2WEknmuOLACo
         ZqbQ==
X-Gm-Message-State: AOAM532yUilIZJqq5obOyt4ohKu314i3RR0QOG0E/K2QYlMduvPz2kWz
        ai5vcHr6zdUH6DdDR+AddoA2sWuWGzO7s0WtIGr7BDFPEG++ewJdoGT01cnhheO90DnV1KXZd2+
        qOiXOwvz37dCO
X-Received: by 2002:adf:9245:: with SMTP id 63mr15301825wrj.324.1618855928128;
        Mon, 19 Apr 2021 11:12:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgBQzBqG9QV8DcunPqTZ92xpfrbS4rOlQQiRMnmFrOvdw8w4N7fXlqNhbvW/pblVoGYyrlUQ==
X-Received: by 2002:adf:9245:: with SMTP id 63mr15301787wrj.324.1618855927818;
        Mon, 19 Apr 2021 11:12:07 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c69b8.dip0.t-ipconnect.de. [91.12.105.184])
        by smtp.gmail.com with ESMTPSA id i15sm22513508wrr.73.2021.04.19.11.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 11:12:07 -0700 (PDT)
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
To:     Sean Christopherson <seanjc@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <c1d8367c-d975-dd51-0e2f-c48a97fb62d9@redhat.com>
Date:   Mon, 19 Apr 2021 20:12:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YH3HWeOXFiCTZN4y@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.04.21 20:09, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
>> On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
>>> But fundamentally the private pages, are well, private.  They can't be shared
>>> across processes, so I think we could (should?) require the VMA to always be
>>> MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
>>> enough to prevent userspace and unaware kernel code from acquiring a reference
>>> to the underlying page?
>>
>> Shared pages should be fine too (you folks wanted tmpfs support).
> 
> Is that a conflict though?  If the private->shared conversion request is kicked
> out to userspace, then userspace can re-mmap() the files as MAP_SHARED, no?
> 
> Allowing MAP_SHARED for guest private memory feels wrong.  The data can't be
> shared, and dirty data can't be written back to the file.
> 
>> The poisoned pages must be useless outside of the process with the blessed
>> struct kvm. See kvm_pfn_map in the patch.
> 
> The big requirement for kernel TDX support is that the pages are useless in the
> host.  Regarding the guest, for TDX, the TDX Module guarantees that at most a
> single KVM guest can have access to a page at any given time.  I believe the RMP
> provides the same guarantees for SEV-SNP.
> 
> SEV/SEV-ES could still end up with corruption if multiple guests map the same
> private page, but that's obviously not the end of the world since it's the status
> quo today.  Living with that shortcoming might be a worthy tradeoff if punting
> mutual exclusion between guests to firmware/hardware allows us to simplify the
> kernel implementation.
> 
>>>>   - Add a new GUP flag to retrive such pages from the userspace mapping.
>>>>     Used only for private mapping population.
>>>
>>>>   - Shared gfn ranges managed by userspace, based on hypercalls from the
>>>>     guest.
>>>>
>>>>   - Shared mappings get populated via normal VMA. Any poisoned pages here
>>>>     would lead to SIGBUS.
>>>>
>>>> So far it looks pretty straight-forward.
>>>>
>>>> The only thing that I don't understand is at way point the page gets tied
>>>> to the KVM instance. Currently we do it just before populating shadow
>>>> entries, but it would not work with the new scheme: as we poison pages
>>>> on fault it they may never get inserted into shadow entries. That's not
>>>> good as we rely on the info to unpoison page on free.
>>>
>>> Can you elaborate on what you mean by "unpoison"?  If the page is never actually
>>> mapped into the guest, then its poisoned status is nothing more than a software
>>> flag, i.e. nothing extra needs to be done on free.
>>
>> Normally, poisoned flag preserved for freed pages as it usually indicate
>> hardware issue. In this case we need return page to the normal circulation.
>> So we need a way to differentiate two kinds of page poison. Current patch
>> does this by adding page's pfn to kvm_pfn_map. But this will not work if
>> we uncouple poisoning and adding to shadow PTE.
> 
> Why use PG_hwpoison then?
> 

I already raised that reusing PG_hwpoison is not what we want. And I 
repeat, to me this all looks like a big hack; some things you (Sena) 
propose sound cleaner, at least to me.

-- 
Thanks,

David / dhildenb

