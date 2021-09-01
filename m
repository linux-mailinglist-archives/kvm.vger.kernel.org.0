Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D93FE181
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbhIARyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233691AbhIARyw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 13:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630518835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GiGBsFuqRCBAADb2SjkWOZz2ABAMuafv28YaxO7HPu8=;
        b=F6ibFq2JuZdysfOVHSLd+K8IAXeKlRv+2bCVxZAmjWXq5/ZlGQTIoCs2TgEIdA+BeWIR5m
        +0iuup4E2MNrhnwtgt9IbQfMj3lNNAcBKYOlu6c6DwGV5J5UeKSVOaqA+4Jq0K7VkV4stv
        lqDc0fbnDIYKKCZ75buYNw5hkE6GGQ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-7SvNLeM3NJunR-6PrQx2Ng-1; Wed, 01 Sep 2021 13:53:54 -0400
X-MC-Unique: 7SvNLeM3NJunR-6PrQx2Ng-1
Received: by mail-wm1-f69.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so169099wmc.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 10:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GiGBsFuqRCBAADb2SjkWOZz2ABAMuafv28YaxO7HPu8=;
        b=Pvt8YkvkRJRapCd41+A6mCozN/nTwiRWOEaUI9m4p7xnBk6aNyvZbYX2zAqpfARI2L
         W83Rysv2AlIDNhhOXbkVxEo9QSuDQFTNiCIWx9XjaPOzPRqWLszjFFZl8UQm7btP5UKD
         7txCbTU8NQk7bvYOvxq5O+y8jxsegiK3HMm3aMT/utr+RryHKkkD5n6NP1YTU1qdft0O
         Ih5zd/UHkN3RKrgjy3Rt8pDbDzkHaxC1AvGm5qOje/lkO68AIGfax3hVObpjM6IAnCRJ
         HpJxa6q8UQwYCxOkKCZ7Dn04qSUKSc1Qnc+SNK7tnfYM+0LP40z+QvS8uDvLbiQBNS7P
         gP1w==
X-Gm-Message-State: AOAM530FkPkCdtnsJ7ZT0dbeboEAclr9zu9WcTGI+MuIPoha0iBVQA/s
        P8CqCMtwS9mbkDz3IwZRnNRRK0caEeZWYGO6qx4PYg9+MD6ifgJ6GuiALnniARHO3d1CaG8bNnq
        aDHy73e6qtQHp
X-Received: by 2002:a1c:20d7:: with SMTP id g206mr717792wmg.153.1630518832802;
        Wed, 01 Sep 2021 10:53:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzId1EJQWuCXd4wDXaMAQVTM5bqXfZadYfJq5hfT4+k85e5baXrLRntNgIiFg9LFycxTroBXw==
X-Received: by 2002:a1c:20d7:: with SMTP id g206mr717764wmg.153.1630518832630;
        Wed, 01 Sep 2021 10:53:52 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id r10sm127194wrc.85.2021.09.01.10.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 10:53:52 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     jejb@linux.ibm.com, Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
References: <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
 <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
 <0d6b2a7e22f5e27e03abc21795124ccd66655966.camel@linux.ibm.com>
 <1a4a1548-7e14-c2b4-e210-cc60a2895acd@redhat.com>
 <4b863492fd33dce28a3a61662d649987b7d5066d.camel@linux.ibm.com>
 <214ca837-3102-d6d1-764e-6b4cd1bab368@redhat.com>
 <YS+9VHzC0XQF/9NK@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <3b63a5d9-30e4-2ae8-2f01-a92b758e81de@redhat.com>
Date:   Wed, 1 Sep 2021 19:53:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YS+9VHzC0XQF/9NK@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 19:50, Sean Christopherson wrote:
> On Wed, Sep 01, 2021, David Hildenbrand wrote:
>>>>> Well not necessarily, but it depends how clever we want to get.  If
>>>>> you look over on the OVMF/edk2 list, there's a proposal to do guest
>>>>> migration via a mirror VM that invokes a co-routine embedded in the
>>>>> OVMF binary:
>>>>
>>>> Yes, I heard of that. "Interesting" design.
>>>
>>> Heh, well what other suggestion do you have?  The problem is there
>>> needs to be code somewhere to perform some operations that's trusted by
>>> both the guest and the host.  The only element for a confidential VM
>>> that has this shared trust is the OVMF firmware, so it seems logical to
>>> use it.
>>
>> <offtopic>
>>
>> Let me put it this way: I worked with another architecture that doesn't
>> fault on access of a secure page, but instead automatically exports/encrypts
> 
> I thought s390 does fault on insecure accesses to secure pages, and it's the
> kernel's fault handler that "automatically" converts the page?  E.g. trap 0x3d
> -> do_secure_storage_access() -> arch_make_page_accessible().

"automatic" as in "the kernel can do it easily automatically under the 
hood when accessing such memory", yes that's what I meant :)

-- 
Thanks,

David / dhildenb

