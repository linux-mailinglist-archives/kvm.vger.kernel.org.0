Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FC13B9D23
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 09:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhGBH4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 03:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230023AbhGBH42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 03:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625212435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G3j7A85kkCJyd49a9H0EIg2hUVbGI4jliAnA7sAXOQA=;
        b=VPfVmKDwbmfzqwtVDg7y0Q/0Jlv7abLdY2iirctvnQxZwU2Z9d86RjoDZhSBSHsN7S3r1q
        5Azpt47rFi5PF1MRNB7dW/JmfULWBxaC1J62ZKmVs5Uvxm4gzeOMfFIIK/uKGnPi2Ecp3p
        u8z8H9Z0ZvL2FNuSMPdol/dHG7ieHrE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-egE5FkW6MDCSQv7o5iUH2Q-1; Fri, 02 Jul 2021 03:53:54 -0400
X-MC-Unique: egE5FkW6MDCSQv7o5iUH2Q-1
Received: by mail-wm1-f69.google.com with SMTP id t12-20020a7bc3cc0000b02901f290c9c44eso3183156wmj.7
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 00:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G3j7A85kkCJyd49a9H0EIg2hUVbGI4jliAnA7sAXOQA=;
        b=XqyE7RbdSVbtwKZjSoVplO5OyCYEYj151FLjP/hxkri7yhgzxFeoZpzXLi+OaPw2XA
         zdwkNckdYSZxnNwrSAHAhP6cLlKLHcU/l+KXqpGlHEoRlY3Y99U63ITgR9wsYSA+/ZWK
         OSEx/zBMksrwNADus+VkfO1LJLP/kCuaDtPped5KBLQvF64NzsXSJJGC01mW4iu4ELmz
         ZZTpdRqQfG7sJgyX0v/5oWaDiPiqSw1vmqjyaTd+LD+hAAPB/8RDXM1nx7TIHDwOe9g9
         YRiijNAMw9qJUdc3lI9iAmiS3m7clqAzdzYTZid9Zbgr1XqqGHSfLBFhyckhAzWIKT48
         s+ug==
X-Gm-Message-State: AOAM533/SsD9ddV39MwwE2eCDutcNR4un94wHp1tSj7eOT2TLK7u9rQk
        bO855qiwoibr1oFubG2FtyabUYmnAuR3MIGS7lFdPxjOlo0ZwzHs/EQCeyLb8WdAJjOLgtSraQ8
        VcrEwLDI61o1A
X-Received: by 2002:a5d:6846:: with SMTP id o6mr4112601wrw.89.1625212433724;
        Fri, 02 Jul 2021 00:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3dPKMn6+RApahZHfe+TrFjDKQJHK5i1YT7og2+XdIYNoJ6Nt7QDUhQG6AMBDWwseiz4AAgg==
X-Received: by 2002:a5d:6846:: with SMTP id o6mr4112574wrw.89.1625212433483;
        Fri, 02 Jul 2021 00:53:53 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23afb.dip0.t-ipconnect.de. [79.242.58.251])
        by smtp.gmail.com with ESMTPSA id n12sm2690716wmq.5.2021.07.02.00.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 00:53:53 -0700 (PDT)
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <3568552b-f72d-b158-dc49-3721375c18d5@redhat.com>
 <YN49g7nW4pDUMiE8@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <677c40ba-43d6-4375-f12e-78f7e7fb1901@redhat.com>
Date:   Fri, 2 Jul 2021 09:53:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YN49g7nW4pDUMiE8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.07.21 00:11, David Matlack wrote:
> On Thu, Jul 01, 2021 at 07:00:51PM +0200, David Hildenbrand wrote:
>> On 30.06.21 23:47, David Matlack wrote:
>>> This patch series adds support for the TDP MMU in the fast_page_fault
>>> path, which enables certain write-protection and access tracking faults
>>> to be handled without taking the KVM MMU lock. This series brings the
>>> performance of these faults up to par with the legacy MMU.
>>>
>>> Since there is not currently any KVM test coverage for access tracking
>>> faults, this series introduces a new KVM selftest,
>>> access_tracking_perf_test. Note that this test relies on page_idle to
>>> enable access tracking from userspace (since it is the only available
>>> usersapce API to do so) and page_idle is being considered for removal
>>> from Linux
>>> (https://lore.kernel.org/linux-mm/20210612000714.775825-1-willy@infradead.org/).
>>
>> Well, at least a new selftest that implicitly tests a part of page_idle --
>> nice :)
>>
>> Haven't looked into the details, but if you can live with page tables
>> starting unpopulated and only monitoring what gets populated on r/w access,
>> you might be able to achieve something similar using /proc/self/pagemap and
>> softdirty handling.
>>
>> Unpopulated page (e.g., via MADV_DISCARD) -> trigger read or write access ->
>> sense if page populated in pagemap
>> Populated page-> clear all softdirty bits -> trigger write access -> sense
>> if page is softdirty in pagemap
> 
> Thanks for the suggestion. I modified by test to write 4 to
> /proc/self/clear_refs rather than marking pages in page_idle. However,
> by doing so I was no longer able to exercise KVM's fast_page_fault
> handler [1].
> 
> It looks like the reason why is that clear_refs issues the
> invalidate_range mmu notifiers, which will cause KVM to fully refault
> the page from the host MM upon subsequent guest memory accesses.  In
> contrast, page_idle uses clear_young which KVM can handle with
> fast_page_fault.

Right, the only thing you could provoke may be (again, did not look into 
the details):

1. 4 > /proc/self/clear_refs to clear all softdirty bits
2. Trigger a read fault. This will populate the shared zeropage on 
private anonymous memory and populate an actual page on e.g., shmem.
3. Trigger a write fault. This should result in a COW fault on private 
anonymous memory and (IIRC) a WP-fault on shmem.

The COW on private anonymous memory would invalidate the secondary MMU 
again via MMU notifiers I guess, so it's not what we want. It *might* 
work on shmem, I might be wrong, though.

But again, I haven't looked into the details/checked the code and we 
might actually not be able to test with softdirty at all. IMHO, page 
idle tracking might be good enough for a test.

Consider it rather a brain dump than a suggestion ;)

-- 
Thanks,

David / dhildenb

