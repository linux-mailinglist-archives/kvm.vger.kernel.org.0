Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B420299839
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 21:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgJZUwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 16:52:40 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8330 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgJZUwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 16:52:12 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9737030000>; Mon, 26 Oct 2020 13:52:19 -0700
Received: from [10.2.57.113] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 20:52:08 +0000
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
To:     Matthew Wilcox <willy@infradead.org>
CC:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Liran Alon" <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
 <20201022114946.GR20115@casper.infradead.org>
 <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
 <20201026042158.GN20115@casper.infradead.org>
 <ee308d1d-8762-6bcf-193e-85fea29743c3@nvidia.com>
 <20201026132830.GQ20115@casper.infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <e78fb7af-627b-ce80-275e-51f97f1f3168@nvidia.com>
Date:   Mon, 26 Oct 2020 13:52:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026132830.GQ20115@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603745539; bh=En7RBhVPDASyx1ikAPEMmxLBTKzCwYVMSmAZAOLt4F0=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=f0ZInIoMhho0FwiYGbQmy/cFCjcszWJ4ksz0xVHxCfriMfXl/ArnCzev6eJCdK5Kk
         SKcPrGBhvbj9FFXYX8Kulgwm5LFJf/IF7ahfg9uFG11y1RvMDvuI37jYONs5JdsFSg
         CxTXCx0QKuCpH2ZkZxYB1l7X5xDV7JdA2Du5WAkA56/8NFydmbJwGc5RoWQehk9kqm
         Z5+4oEawXJxSHhRq56HXamNmJcwBNs2E97FfuQjnEN8NwaLF/fEVnvK2FXYZeu8GDF
         /AKMvqHg1ckc040vGzeuNsTOkhUWrgg0uCbyuLSpMP4N+gNEOlUGPQaNqNBEiWf5lp
         dv+cEOmOP0/IQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/20 6:28 AM, Matthew Wilcox wrote:
> On Sun, Oct 25, 2020 at 09:44:07PM -0700, John Hubbard wrote:
>> On 10/25/20 9:21 PM, Matthew Wilcox wrote:
>>> I don't think the page pinning approach is ever valid.  For file
>>
>> Could you qualify that? Surely you don't mean that the entire pin_user_pages
>> story is a waste of time--I would have expected you to make more noise
>> earlier if you thought that, yes?
> 
> I do think page pinning is the wrong approach for everything.  I did say


Not *everything*, just "pinning for DMA", right? Because I don't recall
any viable solutions for Direct IO that avoided gup/pup!

Also, back to Case 5: I *could* create a small patchset to change over
the very few Case 5 call sites to use "gup, lock_page(), write to
page...etc", instead of pup. And also, update pin_user_pages.rst to
recommend that approach in similar situations. After all, it's not
really a long-term DMA pin, which is really what pin_user_pages*() is
intended for.

Would that be something you'd like to see happen? It's certainly easy
enough to fix that up. And your retroactive NAK is sufficient motivation
to do so.


> so at the time, and I continue to say so when the opportunity presents
> itself.  But shouting about it constantly only annoys people, so I don't
> generally bother.  I have other things to work on, and they're productive,
> so I don't need to spend my time arguing.


Sure. As a practical matter, I've assumed that page pinning is not going
to go away any time soon, so I want it to work properly while it's here.
But if there is a viable way to eventually replace dma-pinning with
something better, then let's keep thinking about it. I'm glad to help in
that area.


thanks,
-- 
John Hubbard
NVIDIA
