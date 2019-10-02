Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45764C482B
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 09:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfJBHNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 03:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfJBHNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 03:13:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FC043084031;
        Wed,  2 Oct 2019 07:13:48 +0000 (UTC)
Received: from [10.36.117.58] (ovpn-117-58.ams2.redhat.com [10.36.117.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C84D6012C;
        Wed,  2 Oct 2019 07:13:35 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
 <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
 <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <0603ca4a-d667-f461-4ba7-ff3c0e9fd4df@redhat.com>
Date:   Wed, 2 Oct 2019 09:13:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 02 Oct 2019 07:13:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.10.19 02:55, Alexander Duyck wrote:
> On Tue, Oct 1, 2019 at 12:16 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>
>>
>> On 10/1/19 12:21 PM, Alexander Duyck wrote:
>>> On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
>>>> On 01.10.19 17:29, Alexander Duyck wrote:
>>>>> This series provides an asynchronous means of reporting to a hypervisor
>>>>> that a guest page is no longer in use and can have the data associated
>>>>> with it dropped. To do this I have implemented functionality that allows
>>>>> for what I am referring to as unused page reporting. The advantage of
>>>>> unused page reporting is that we can support a significant amount of
>>>>> memory over-commit with improved performance as we can avoid having to
>>>>> write/read memory from swap as the VM will instead actively participate
>>>>> in freeing unused memory so it doesn't have to be written.
>>>>>
>>>>> The functionality for this is fairly simple. When enabled it will allocate
>>>>> statistics to track the number of reported pages in a given free area.
>>>>> When the number of free pages exceeds this value plus a high water value,
>>>>> currently 32, it will begin performing page reporting which consists of
>>>>> pulling non-reported pages off of the free lists of a given zone and
>>>>> placing them into a scatterlist. The scatterlist is then given to the page
>>>>> reporting device and it will perform the required action to make the pages
>>>>> "reported", in the case of virtio-balloon this results in the pages being
>>>>> madvised as MADV_DONTNEED. After this they are placed back on their
>>>>> original free list. If they are not merged in freeing an additional bit is
>>>>> set indicating that they are a "reported" buddy page instead of a standard
>>>>> buddy page. The cycle then repeats with additional non-reported pages
>>>>> being pulled until the free areas all consist of reported pages.
>>>>>
>>>>> In order to try and keep the time needed to find a non-reported page to
>>>>> a minimum we maintain a "reported_boundary" pointer. This pointer is used
>>>>> by the get_unreported_pages iterator to determine at what point it should
>>>>> resume searching for non-reported pages. In order to guarantee pages do
>>>>> not get past the scan I have modified add_to_free_list_tail so that it
>>>>> will not insert pages behind the reported_boundary. Doing this allows us
>>>>> to keep the overhead to a minimum as re-walking the list without the
>>>>> boundary will result in as much as 18% additional overhead on a 32G VM.
>>>>>
>>>>>
>>> <snip>
>>>
>>>>> As far as possible regressions I have focused on cases where performing
>>>>> the hinting would be non-optimal, such as cases where the code isn't
>>>>> needed as memory is not over-committed, or the functionality is not in
>>>>> use. I have been using the will-it-scale/page_fault1 test running with 16
>>>>> vcpus and have modified it to use Transparent Huge Pages. With this I see
>>>>> almost no difference with the patches applied and the feature disabled.
>>>>> Likewise I see almost no difference with the feature enabled, but the
>>>>> madvise disabled in the hypervisor due to a device being assigned. With
>>>>> the feature fully enabled in both guest and hypervisor I see a regression
>>>>> between -1.86% and -8.84% versus the baseline. I found that most of the
>>>>> overhead was due to the page faulting/zeroing that comes as a result of
>>>>> the pages having been evicted from the guest.
>>>> I think Michal asked for a performance comparison against Nitesh's
>>>> approach, to evaluate if keeping the reported state + tracking inside
>>>> the buddy is really worth it. Do you have any such numbers already? (or
>>>> did my tired eyes miss them in this cover letter? :/)
>>>>
>>> I thought what Michal was asking for was what was the benefit of using the
>>> boundary pointer. I added a bit up above and to the description for patch
>>> 3 as on a 32G VM it adds up to about a 18% difference without factoring in
>>> the page faulting and zeroing logic that occurs when we actually do the
>>> madvise.
>>>
>>> Do we have a working patch set for Nitesh's code? The last time I tried
>>> running his patch set I ran into issues with kernel panics. If we have a
>>> known working/stable patch set I can give it a try.
>>
>> Did you try the v12 patch-set [1]?
>> I remember that you reported the CPU stall issue, which I fixed in the v12.
>>
>> [1] https://lkml.org/lkml/2019/8/12/593
> 
> So I tried testing with the spin_lock calls replaced with spin_lock
> _irq to resolve the IRQ issue. I also had shuffle enabled in order to
> increase the number of pages being dirtied.
> 
> With that setup the bitmap approach is running significantly worse
> then my approach, even with the boundary removed. Since I had to

It would make sense to share the setup+benchmark+performance indication
that you measured. You don't have to share the actual numbers.

> modify the code to even getting working I am not comfortable posting
> numbers. My suggestion would be to look at reworking the patch set and
> post numbers for my patch set versus the bitmap approach and we can
> look at them then. I would prefer not to spend my time fixing and
> tuning a patch set that I am still not convinced is viable.

I agree, I think Nitesh should work on his patch set and try to
reproduce what you are seeing.

Also, I think to make a precise statement of "which overhead comes with
external tracking", Nitesh should switch to an approach (motivated by
Michal) like

1. Sense lockless if a page is still free
2. start_isolate_page_range()
-> Failed? Skip
3. test_pages_isolated()
-> No? undo_isolate_page_range(), skip
4. Repeat for multiple pages + report
5. undo_isolate_page_range()

That is the bare minimum any external tracking will need = some overhead
for the tracking data. As a nice side effect, it get's rid of taking the
zone lock manually AFAIKS.

But that's unrelated to your series, only to quantify "how much" does
external tracking actually cost.

-- 

Thanks,

David / dhildenb
