Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72D93FF358
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347063AbhIBSmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347055AbhIBSmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B7561054;
        Thu,  2 Sep 2021 18:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630608069;
        bh=Rz27QrMv3CmEHDYgF/fVueCgLU4vpnJjqWFkkAFYWTo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aAeGYLAqgzAU48atK8jAIAITEdS1UEjxwuAflbmidzx0ALrOBEwzA2ev56kjz/umQ
         uZqY+/B5VCOzIeDcO0/SMFwQ2ZrHxn0rHI7R+SiZcZc+bvPu5hA33bnpI2x354TeNw
         gNoh7kx6MyBDHccHT4gwSqhwqTFQKPoupyUd4BPiSU+6E21EV8dOBm+ed43cUnVrOu
         wMjhh8vcM98olY5RkwTuRnZhw++6zXDWQZU27zpjTszKctI2/N4PZwaexQ7hFguDoG
         DQdBdHB5zbJpPmFiCHNChobr1WkwQDIpG7aQ/V2CfxmMvI4oOhOhTHQsER188NlSvP
         Wju2ZUSj2VOXA==
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
 <20210902081923.lertnjsgnskegkmn@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <d4f90b99-85de-9007-85d0-46d41892c283@kernel.org>
Date:   Thu, 2 Sep 2021 11:41:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902081923.lertnjsgnskegkmn@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>
>> In principle, you could actually initialize a TDX guest with all of its
>> memory shared and all of it mapped in the host IOMMU.  When a guest
>> turns some pages private, user code could punch a hole in the memslot,
>> allocate private memory at that address, but leave the shared backing
>> store in place and still mapped in the host IOMMU.  The result would be
>> that guest-initiated DMA to the previously shared address would actually
>> work but would hit pages that are invisible to the guest.  And a whole
>> bunch of memory would be waste, but the whole system should stll work.
> 
> Do you mean to let VFIO & IOMMU to treat all guest memory as shared first,
> and then just allocate the private pages in another backing store? I guess
> that could work, but with the cost of allocating roughly 2x physical pages
> of the guest RAM size. After all, the shared pages shall be only a small
> part of guest memory.

Yes.

My point is that I don't think there should be any particular danger in
leaving the VFIO code alone as part of TDX enablement.  The code ought
to *work* even if it will be wildly inefficient.  If someone cares to
make it work better, they're welcome to do so.

--Andy
