Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1663FCD86
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbhHaTJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 15:09:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238332AbhHaTJd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 15:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630436917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SWxEMPDuRz0FY7KmKfDVDG8ppIxTwJN7M0MpRD99pY=;
        b=OU/3jr3eE121nNCak64NPj/UyGUeqT/ZAmAlqHJ+djRGsy786zY/gLcqgin79fyK+FG52g
        fvnOXqiKNEo8k7PzcvjIdwaNiA8UpMTArTEGeqgz2wPRBoABz14Y3XmMXER+czmSleLCMy
        aG7PwmYYKBD1TlZ3F7QKco+HpqoTw/Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-N0NBKhWIOyCsyruLaGBkJw-1; Tue, 31 Aug 2021 15:08:36 -0400
X-MC-Unique: N0NBKhWIOyCsyruLaGBkJw-1
Received: by mail-wr1-f71.google.com with SMTP id v6-20020adfe4c6000000b001574f9d8336so138051wrm.15
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4SWxEMPDuRz0FY7KmKfDVDG8ppIxTwJN7M0MpRD99pY=;
        b=cRtidTatRHbxHxx6vQj38AlBhbHEECyRVDPqG53NTF65FVqpysHNzcNV9RoQQ7bF2X
         4RZqowR/QG622Vp6Gcdsx9rQotAxi9f0zDo5o793ZmSG+XRTECAWAbmZSdw5BPIaAJld
         FODuZ/VyQTSI6GaCpjc2ACnE6Fb/ikQX7M6j8oGPIjPp9/E3CsffAfRcuVsDLLW/zkaD
         8f8kUWWCEKyCeB2vqQTZvj41nscEJ67aqfdNa9MeufbwMV4Y/yGSBaJEOqV1BHvS1j5+
         lzi6c5PdSKepX2B8aGk6WauagTNfK6PAV90bTXr1QfE096mJY5upvq3z8woOZEV/tXSB
         RQgQ==
X-Gm-Message-State: AOAM533zOqdZs9rC07FTXtZsJJi+laOKa3SRX0x7ZYown3178uQjpSPz
        lgNyvU6LVU8ZyQTz2q+OJ+DFHoLzW4dRNpIHCwlFkGMoYZAFaOu+2GooQ8cnL3LwjgCQlxohq4W
        pbUh54WYWGOYD
X-Received: by 2002:a1c:29c3:: with SMTP id p186mr5819797wmp.22.1630436915202;
        Tue, 31 Aug 2021 12:08:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1F1cNwRIN0hukoTwKZyMeA3JM8Dvn1W5XQb38okw/iCNR0VQvNO0o/m5wjByu0ITsWo/x4A==
X-Received: by 2002:a1c:29c3:: with SMTP id p186mr5819762wmp.22.1630436914992;
        Tue, 31 Aug 2021 12:08:34 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bf5.dip0.t-ipconnect.de. [79.242.59.245])
        by smtp.gmail.com with ESMTPSA id m3sm24311904wrg.45.2021.08.31.12.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 12:08:34 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <243bc6a3-b43b-cd18-9cbb-1f42a5de802f@redhat.com>
Date:   Tue, 31 Aug 2021 21:08:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.08.21 04:31, Yu Zhang wrote:
> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
>> On 24.08.21 02:52, Sean Christopherson wrote:
>>> The goal of this RFC is to try and align KVM, mm, and anyone else with skin in the
>>> game, on an acceptable direction for supporting guest private memory, e.g. for
>>> Intel's TDX.  The TDX architectural effectively allows KVM guests to crash the
>>> host if guest private memory is accessible to host userspace, and thus does not
>>> play nice with KVM's existing approach of pulling the pfn and mapping level from
>>> the host page tables.
>>>
>>> This is by no means a complete patch; it's a rough sketch of the KVM changes that
>>> would be needed.  The kernel side of things is completely omitted from the patch;
>>> the design concept is below.
>>>
>>> There's also fair bit of hand waving on implementation details that shouldn't
>>> fundamentally change the overall ABI, e.g. how the backing store will ensure
>>> there are no mappings when "converting" to guest private.
>>>
>>
>> This is a lot of complexity and rather advanced approaches (not saying they
>> are bad, just that we try to teach the whole stack something completely
>> new).
>>
>>
>> What I think would really help is a list of requirements, such that
>> everybody is aware of what we actually want to achieve. Let me start:
>>
>> GFN: Guest Frame Number
>> EPFN: Encrypted Physical Frame Number
>>
>>
>> 1) An EPFN must not get mapped into more than one VM: it belongs exactly to
>> one VM. It must neither be shared between VMs between processes nor between
>> VMs within a processes.
>>
>>
>> 2) User space (well, and actually the kernel) must never access an EPFN:
>>
>> - If we go for an fd, essentially all operations (read/write) have to
>>    fail.
>> - If we have to map an EPFN into user space page tables (e.g., to
>>    simplify KVM), we could only allow fake swap entries such that "there
>>    is something" but it cannot be  accessed and is flagged accordingly.
>> - /proc/kcore and friends have to be careful as well and should not read
>>    this memory. So there has to be a way to flag these pages.
>>
>> 3) We need a way to express the GFN<->EPFN mapping and essentially assign an
>> EPFN to a GFN.
>>
>>
>> 4) Once we assigned a EPFN to a GFN, that assignment must not longer change.
>> Further, an EPFN must not get assigned to multiple GFNs.
>>
>>
>> 5) There has to be a way to "replace" encrypted parts by "shared" parts
>>     and the other way around.
>>
>> What else?
> 
> Thanks a lot for this summary. A question about the requirement: do we or
> do we not have plan to support assigned device to the protected VM?

Good question, I assume that is stuff for the far far future.

> 
> If yes. The fd based solution may need change the VFIO interface as well(
> though the fake swap entry solution need mess with VFIO too). Because:
> 
> 1> KVM uses VFIO when assigning devices into a VM.
> 
> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> guest pages will have to be mapped in host IOMMU page table to host pages,
> which are pinned during the whole life cycle fo the VM.
> 
> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
> in vfio_dma_do_map().
> 
> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
> and pin the page.
> 
> But if we are using fd based solution, not every GPA can have a HVA, thus
> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
> doubt if VFIO can be modified to support this easily.

I fully agree. Maybe Intel folks have some idea how that's supposed to 
look like in the future.

-- 
Thanks,

David / dhildenb

