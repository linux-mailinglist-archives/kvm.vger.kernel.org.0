Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889083FDFDE
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbhIAQ20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:28:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245242AbhIAQ2W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630513645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCAH52YqS9JZQzJKa7DRR1Gpuc8EPZCmTZ5AQVbYtWA=;
        b=CQSXfa1RsLb8cees6QT9Hv5mRreNLsW5HcBvOcAgXOXFdtnlUYIv8ZrxLTbUPb59GwkJUa
        dQqvHNVvBvcGGvV7ZyRB9xOaw0ibOKu0yptS5I8P0cI5Pfvo0NXoPZ9BtKiknc2U695N7r
        gFOSR/rywuYjLZE23EjnzDN9ifKSQEw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57--yw-hXnXMN21o3akplrH7Q-1; Wed, 01 Sep 2021 12:27:23 -0400
X-MC-Unique: -yw-hXnXMN21o3akplrH7Q-1
Received: by mail-wm1-f70.google.com with SMTP id b126-20020a1c8084000000b002f152a868a2so29406wmd.1
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 09:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TCAH52YqS9JZQzJKa7DRR1Gpuc8EPZCmTZ5AQVbYtWA=;
        b=JWyL6flK3T80I1DvWi/VWmzJd+gp73pRl+OhFL45inE/agltvRghTUvDUOfVXmAAvP
         KmogIPut4Gaa4ZM9gx7W7+EiXZd8UzrtvshNKjR7wkrKmxdM9yFW1ogllftSRN2bNg1B
         cs+eDBQgZ/grK7+OZ3srfYCVo5foVno/p1/Y6R0JppOFvPri/eAuQa1MxkNo/g2nrp03
         dWWLTMGKDPc6aCgc6/KzIq36ScByvbh8ByPyGmxHwtPiaGxHTalEiCHarBH1/SkZHHf7
         SoZKTtKUWH+tEmG+EkxjtEURN6EQlBsw3q24BgHe0vCOIOttmAwzI0Clhl5zfeFLBcKm
         FHFg==
X-Gm-Message-State: AOAM531ODA7Dju1yJwAwsI5Ow+bOz72M5KA3OlCttyCniGU23/19trY0
        wztSNCiPvHkJXsvHc3Iuct/4O3dONOPFGBGLuU7GlEakcVvsgheITflolkilKKP48fRVH0rEjeR
        OeuLxVRTcJvpX
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr259282wrr.382.1630513642553;
        Wed, 01 Sep 2021 09:27:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGHmzuvAvqEcnBZI7Y23pSv8aObIhsarRJKP+kEp6VN4fOLNmhGpMU3DYltGLE2gcg2FV3PQ==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr259251wrr.382.1630513642352;
        Wed, 01 Sep 2021 09:27:22 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id k17sm225645wmj.0.2021.09.01.09.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:27:21 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Andy Lutomirski <luto@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2b2740ec-fa89-e4c3-d175-824e439874a6@redhat.com>
Date:   Wed, 1 Sep 2021 18:27:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 18:07, Andy Lutomirski wrote:
> On 9/1/21 3:24 AM, Yu Zhang wrote:
>> On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
>>>
>>>
>>> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
>>>> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
>>>
>>>> Thanks a lot for this summary. A question about the requirement: do we or
>>>> do we not have plan to support assigned device to the protected VM?
>>>>
>>>> If yes. The fd based solution may need change the VFIO interface as well(
>>>> though the fake swap entry solution need mess with VFIO too). Because:
>>>>
>>>> 1> KVM uses VFIO when assigning devices into a VM.
>>>>
>>>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
>>>> guest pages will have to be mapped in host IOMMU page table to host pages,
>>>> which are pinned during the whole life cycle fo the VM.
>>>>
>>>> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
>>>> in vfio_dma_do_map().
>>>>
>>>> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
>>>> and pin the page.
>>>>
>>>> But if we are using fd based solution, not every GPA can have a HVA, thus
>>>> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
>>>> doubt if VFIO can be modified to support this easily.
>>>>
>>>>
>>>
>>> Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
>>>
>>> If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
>>>
>>> If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
>>>
>>
>> Thanks Andy. I was asking the first scenario.
>>
>> Well, I agree it is doable if someone really want some assigned
>> device in TD guest. As Kevin mentioned in his reply, HPA can be
>> generated, by extending VFIO with a new mapping protocol which
>> uses fd+offset, instead of HVA.
> 
> I'm confused.  I don't see why any new code is needed for this at all.
> Every proposal I've seen for handling TDX memory continues to handle TDX
> *shared* memory exactly like regular guest memory today.  The only
> differences are that more hole punching will be needed, which will
> require lightweight memslots (to have many of them), memslots with
> holes, or mappings backing memslots with holes (which can be done with
> munmap() on current kernels).
> 
> So you can literally just mmap a VFIO device and expect it to work,
> exactly like it does right now.  Whether the guest will be willing to
> use the device will depend on the guest security policy (all kinds of
> patches about that are flying around), but if the guest tries to use it,
> it really should just work.

... but if you end up mapping private memory into IOMMU of the device 
and the device ends up accessing that memory, we're in the same position 
that the host might get capped, just like access from user space, no?

Sure, you can map only the complete duplicate shared-memory region into 
the IOMMU of the device, that would work. Shame vfio mostly always pins 
all guest memory and you essentially cannot punch holes into the shared 
memory anymore -- resulting in the worst case in a duplicate memory 
consumption for your VM.

So you'd actually want to map only the *currently* shared pieces into 
the IOMMU and update the mappings on demand. Having worked on something 
related, I can only say that 64k individual mappings, and not being able 
to modify existing mappings except completely deleting them to replace 
with something new (!atomic), can be quite an issue for bigger VMs.

-- 
Thanks,

David / dhildenb

