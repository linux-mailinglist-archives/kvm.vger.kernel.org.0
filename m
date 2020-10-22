Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51B729658E
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370489AbgJVT6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 15:58:17 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9576 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370434AbgJVT6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 15:58:17 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f91e3fa0001>; Thu, 22 Oct 2020 12:56:42 -0700
Received: from [10.2.54.36] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Oct
 2020 19:58:14 +0000
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
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
Date:   Thu, 22 Oct 2020 12:58:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022114946.GR20115@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603396602; bh=SDDfdPapwaAGPN6G5NGvPgR723v4Q3ngUYge890SCck=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=bs3xt+dzMIEc1iPoqfF/PiRE0RAm4lrjLAAOpczF8TnctMMyV4Q6U4C16Gw/BxU00
         7D0s51rhGaNO1lWwWg1UNN5wmXuNlG2QNHfTbbZxkpe8Yd8/FwKxpdss1g1AZ4bReG
         /Lg5LHvimXwF5n3bsNikgJ8lN6fbTTyz4NqL2mcGXn41IoQ2lmRaqx1bp+/171WoDZ
         b+F+ihCsmrVAtPDqwRPIj0cNvYeQ1uMbGVK00N+kUXU/mdTBBViG6uWtt+N5kwf53P
         xVAASH+PC4G9wiuXgn3Rf/c0FTJFfb0x1cK1SXN38pgZeEQwQth9jFXkRQj3NJUxOR
         nMrdMYnlmyBbg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/20 4:49 AM, Matthew Wilcox wrote:
> On Tue, Oct 20, 2020 at 01:25:59AM -0700, John Hubbard wrote:
>> Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
>> We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
>> situation, I think:
>>
>>
>> CASE 5: Pinning in order to write to the data within the page
>> -------------------------------------------------------------
>> Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
>> write to a page's data, unpin" can cause a problem. Case 5 may be considered a
>> superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
>> other words, if the code is neither Case 1 nor Case 2, it may still require
>> FOLL_PIN, for patterns like this:
>>
>> Correct (uses FOLL_PIN calls):
>>      pin_user_pages()
>>      write to the data within the pages
>>      unpin_user_pages()
> 
> Case 5 is crap though.  That bug should have been fixed by getting
> the locking right.  ie:
> 
> 	get_user_pages_fast();
> 	lock_page();
> 	kmap();
> 	set_bit();
> 	kunmap();
> 	set_page_dirty()
> 	unlock_page();
> 
> I should have vetoed that patch at the time, but I was busy with other things.
> 

It does seem like lock_page() is better, for now at least, because it
forces the kind of synchronization with file system writeback that is
still yet to be implemented for pin_user_pages().

Long term though, Case 5 provides an alternative way to do this
pattern--without using lock_page(). Also, note that Case 5, *in
general*, need not be done page-at-a-time, unlike the lock_page()
approach. Therefore, Case 5 might potentially help at some call sites,
either for deadlock avoidance or performance improvements.

In other words, once the other half of the pin_user_pages() plan is
implemented, either of these approaches should work.

Or, are you thinking that there is never a situation in which Case 5 is
valid?


thanks,
-- 
John Hubbard
NVIDIA
