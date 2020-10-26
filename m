Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F6029863B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 05:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421544AbgJZEoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 00:44:12 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4184 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1421510AbgJZEoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 00:44:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9654200001>; Sun, 25 Oct 2020 21:44:16 -0700
Received: from [10.2.57.113] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 04:44:07 +0000
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
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <ee308d1d-8762-6bcf-193e-85fea29743c3@nvidia.com>
Date:   Sun, 25 Oct 2020 21:44:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026042158.GN20115@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603687456; bh=OugSIDEgAyrbA+hBdM+S+wjKYpamFwazDYrzvQ7ACu0=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=VMzQSXqQYz00y6HdMRRIWN0A9Ldha+c7/7WdKnZwGZT+28JsXCO93EXGLTyXEcGIu
         wdy4+yKnswoval6Koi52Q/E6Wvzl4IC64Do8HTpw51+wqx/azBng6qtTzQY7W5voFH
         jJut2BtelObV3oyNUfB316xz5b1aQd219Otl/WtFdNKVONA2Z482P82MHhfwIPnoY9
         OFKmkxJLq6yIFbgCj8rtuaMMrIg52Z4+1hFNbGYej8K+/ixbHctvSIV/9Icd4J1O0B
         kNGgWE2fS8cWFm2doc93+ifbzddx83+9n9apHfIo0DUlLYXKgAcT2C1QXFGl0m9ueF
         PMd6PV9rFRDcA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/20 9:21 PM, Matthew Wilcox wrote:
> On Thu, Oct 22, 2020 at 12:58:14PM -0700, John Hubbard wrote:
>> On 10/22/20 4:49 AM, Matthew Wilcox wrote:
>>> On Tue, Oct 20, 2020 at 01:25:59AM -0700, John Hubbard wrote:
>>>> Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
>>>> We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
>>>> situation, I think:
>>>>
>>>>
>>>> CASE 5: Pinning in order to write to the data within the page
>>>> -------------------------------------------------------------
>>>> Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
>>>> write to a page's data, unpin" can cause a problem. Case 5 may be considered a
>>>> superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
>>>> other words, if the code is neither Case 1 nor Case 2, it may still require
>>>> FOLL_PIN, for patterns like this:
>>>>
>>>> Correct (uses FOLL_PIN calls):
>>>>       pin_user_pages()
>>>>       write to the data within the pages
>>>>       unpin_user_pages()
>>>
>>> Case 5 is crap though.  That bug should have been fixed by getting
>>> the locking right.  ie:
>>>
>>> 	get_user_pages_fast();
>>> 	lock_page();
>>> 	kmap();
>>> 	set_bit();
>>> 	kunmap();
>>> 	set_page_dirty()
>>> 	unlock_page();
>>>
>>> I should have vetoed that patch at the time, but I was busy with other things.
>>
>> It does seem like lock_page() is better, for now at least, because it
>> forces the kind of synchronization with file system writeback that is
>> still yet to be implemented for pin_user_pages().
>>
>> Long term though, Case 5 provides an alternative way to do this
>> pattern--without using lock_page(). Also, note that Case 5, *in
>> general*, need not be done page-at-a-time, unlike the lock_page()
>> approach. Therefore, Case 5 might potentially help at some call sites,
>> either for deadlock avoidance or performance improvements.
>>
>> In other words, once the other half of the pin_user_pages() plan is
>> implemented, either of these approaches should work.
>>
>> Or, are you thinking that there is never a situation in which Case 5 is
>> valid?
> 
> I don't think the page pinning approach is ever valid.  For file

Could you qualify that? Surely you don't mean that the entire pin_user_pages
story is a waste of time--I would have expected you to make more noise
earlier if you thought that, yes?

> mappings, the infiniband registration should take a lease on the inode,
> blocking truncation.  DAX shouldn't be using struct pages at all, so
> there shouldn't be anything there to pin.
> 
> It's been five years since DAX was merged, and page pinning still
> doesn't work.  How much longer before the people who are pushing it
> realise that it's fundamentally flawed?
> 

Is this a separate rant about *only* DAX, or is general RDMA in your sights
too? :)



thanks,
-- 
John Hubbard
NVIDIA
