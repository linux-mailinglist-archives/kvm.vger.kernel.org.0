Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873BD10AD1A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 11:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK0KBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 05:01:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25159 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbfK0KBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 05:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574848883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=sISpN1mMF95NweUj7GbmLgocaV1uUfItkidIrb5clBI=;
        b=h7ZLEw3fns2uEpdvJxQIltRx2D3O2V4x2EvZ42KiSAwQTex/8vZFp7FfcqNvvWBe4LdQ6i
        mYOTBijxsZZJv4TZCMVdFkG0fltx3PHi+TfhoWoeuiGBYJb3JZXp6iPeFzVPDqW+4uSMvu
        wYCIY4B6ltgrcuhp0nM0Suu73bK4lr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-nXKqLYC7Pi-zw5oeJMvh0A-1; Wed, 27 Nov 2019 05:01:22 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08674593A5;
        Wed, 27 Nov 2019 10:01:19 +0000 (UTC)
Received: from [10.36.118.129] (unknown [10.36.118.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79C3608B9;
        Wed, 27 Nov 2019 10:01:03 +0000 (UTC)
Subject: Re: [PATCH v14 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
 <2cd804f781b55d5c20e970dcd67b472fba6e1387.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <905bf376-b8a5-d101-fb8e-ec8aa9ce500e@redhat.com>
Date:   Wed, 27 Nov 2019 11:01:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2cd804f781b55d5c20e970dcd67b472fba6e1387.camel@linux.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: nXKqLYC7Pi-zw5oeJMvh0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.11.19 17:45, Alexander Duyck wrote:
> On Tue, 2019-11-26 at 13:20 +0100, David Hildenbrand wrote:
>> On 19.11.19 22:46, Alexander Duyck wrote:
>>> This series provides an asynchronous means of reporting unused guest
>>> pages to a hypervisor so that the memory associated with those pages ca=
n
>>> be dropped and reused by other processes and/or guests on the host. Usi=
ng
>>> this it is possible to avoid unnecessary I/O to disk and greatly improv=
e
>>> performance in the case of memory overcommit on the host.
>>>
>>> When enabled it will allocate a set of statistics to track the number o=
f
>>> reported pages. When the nr_free for a given free area is greater than
>>> this by the high water mark we will schedule a worker to begin pulling =
the
>>> non-reported memory and to provide it to the reporting interface via a
>>> scatterlist.
>>>
>>> Currently this is only in use by virtio-balloon however there is the ho=
pe
>>> that at some point in the future other hypervisors might be able to mak=
e
>>> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
>>> currently using MADV_DONTNEED to indicate to the host kernel that the p=
age
>>> is currently unused. It will be zeroed and faulted back into the guest =
the
>>> next time the page is accessed.
>>
>> Remind me why we are using MADV_DONTNEED? Mostly for debugging purposes
>> right now, right? Did you do any measurements with MADV_FREE? I guess
>> there should be quite a performance increase in some scenarios.
>=20
> There are actually a few reasons for not using MADV_FREE.
>=20
> The first one was debugging as I could visibly see how much memory had
> been freed by just checking the memory consumption by the guest. I didn't
> have to wait for memory pressure to trigger the memory freeing. In
> addition it would force the pages out of the guest so it was much easier
> to see if I was freeing the wrong pages.
>=20
> The second reason is because it is much more portable. The MADV_FREE has
> only been a part of the Linux kernel since about 4.5. So if you are
> running on an older kernel the option might not be available.

I guess optionally enabling it (for !filebacked and !huge pages) in QEMU
after sensing would be possible. Fallback to ram_discard_range().

>=20
> The third reason is simply effort involved. If I used MADV_DONTNEED then =
I
> can just use ram_block_discard_range which is the same function used by
> other parts of the balloon driver.

Yes, that makes perfect sense.

>=20
> Finally it is my understanding is that MADV_FREE only works on anonymous
> memory (https://elixir.bootlin.com/linux/v5.4/source/mm/madvise.c#L700). =
I
> was concerned that using MADV_FREE wouldn't work if used on file backed
> memory such as hugetlbfs which is an option for QEMU if I am not mistaken=
.

Yes, MADV_FREE works just like MADV_DONTNEED only on anonymous memory.
In case of files/hugetlbfs you have to use

fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, ...).

E.g., see qemu/exec.c:ram_block_discard_range. You can do something
similar to this:


static bool madv_free_sensed, madv_free_available;
int ret =3D -EINVAL;

/*
 * MADV_FREE only works on anonymous memory, and especially not on
 * hugetlbfs. Older kernels don't support it.
 */
if (rb->page_size =3D=3D qemu_host_page_size && rb->fb !=3D -1 &&
    (!madv_free_sensed || madv_free_available)) {
    ret =3D madvise(start, length, MADV_FREE);
    if (ret) {
=09madv_free_sensed =3D true;
        madv_free_available =3D false;
    } else if (!madv_free_sensed) {
        madv_free_sensed =3D true;
=09madv_free_available =3D true;
    }
}

/* fallback to MADV_DONTNEED / FALLOC_FL_PUNCH_HOLE */
if (ret) {
    ram_block_discard_range(rb, start, length);
}


I agree that something like should be an addon to the current patch set.

>=20
>>> To track if a page is reported or not the Uptodate flag was repurposed =
and
>>> used as a Reported flag for Buddy pages. We walk though the free list
>>> isolating pages and adding them to the scatterlist until we either
>>> encounter the end of the list or have filled the scatterlist with pages=
 to
>>> be reported. If we fill the scatterlist before we reach the end of the
>>> list we rotate the list so that the first unreported page we encounter =
is
>>> moved to the head of the list as that is where we will resume after we
>>> have freed the reported pages back into the tail of the list.
>>
>> So the boundary pointer didn't actually provide that big of a benefit I
>> assume (IOW, worst thing is you have to re-scan the whole list)?
>=20
> I rewrote the code quite a bit to get rid of the disadvantages.
> Specifically what the boundary pointer was doing was saving our place in
> the list when we left. Even without that we still had to re-scan the
> entire list with each zone processed anyway. With these changes we end up
> potentially having to perform one additional rescan per free list.
>=20
> Where things differ now is that the fetching function doesn't bail out of
> the list and start over per page. Instead it fills the entire scatterlist
> before it exits, and before doing so it will advance the head to the next
> non-reported page in the list. In addition instead of walking all of the
> orders and migrate types looking for each page the code is now more
> methodical and will only work one free list at a time and do not revisit
> it until we have processed the entire zone.

Makes perfect sense to me.

>=20
> Even with all that we still take a pretty significant performance hit in
> the page shuffing case, however I am willing to give that up for the sake
> of being less intrusive.

Makes sense as well, especially for a first version.

>=20
>>> Below are the results from various benchmarks. I primarily focused on t=
wo
>>> tests. The first is the will-it-scale/page_fault2 test, and the other i=
s
>>> a modified version of will-it-scale/page_fault1 that was enabled to use
>>> THP. I did this as it allows for better visibility into different parts
>>> of the memory subsystem. The guest is running with 32G for RAM on one
>>> node of a E5-2630 v3. The host has had some power saving features disab=
led
>>> by setting the /dev/cpu_dma_latency value to 10ms.
>>>
>>> Test                page_fault1 (THP)     page_fault2
>>> Name         tasks  Process Iter  STDEV  Process Iter  STDEV
>>> Baseline         1    1203934.75  0.04%     379940.75  0.11%
>>>                 16    8828217.00  0.85%    3178653.00  1.28%
>>>
>>> Patches applied  1    1207961.25  0.10%     380852.25  0.25%
>>>                 16    8862373.00  0.98%    3246397.25  0.68%
>>>
>>> Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
>>>  MADV disabled  16    8870373.75  0.29%    3204989.75  1.08%
>>>
>>> Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
>>>                 16    8371359.75  0.65%    3233665.50  0.84%
>>>
>>> Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
>>>  page shuffle   16    8108719.75  0.58%    3218450.25  1.07%
>>>
>>> The results above are for a baseline with a linux-next-20191115 kernel,
>>> that kernel with this patch set applied but page reporting disabled in
>>> virtio-balloon, patches applied but the madvise disabled by direct
>>> assigning a device, the patches applied and page reporting fully
>>> enabled, and the patches enabled with page shuffling enabled.  These
>>> results include the deviation seen between the average value reported h=
ere
>>> versus the high and/or low value. I observed that during the test memor=
y
>>> usage for the first three tests never dropped whereas with the patches
>>> fully enabled the VM would drop to using only a few GB of the host's
>>> memory when switching from memhog to page fault tests.
>>>
>>> Most of the overhead seen with this patch set enabled seems due to page
>>> faults caused by accessing the reported pages and the host zeroing the =
page
>>> before giving it back to the guest. This overhead is much more visible =
when
>>> using THP than with standard 4K pages. In addition page shuffling seeme=
d to
>>> increase the amount of faults generated due to an increase in memory ch=
urn.
>>
>> MADV_FREE would be interesting.
>=20
> I can probably code something up. However that is going to push a bunch o=
f
> complexity into the QEMU code and doesn't really mean much to the kernel
> code. I can probably add it as another QEMU patch to the set since it is
> just a matter of having a function similar to ram_block_discard_range tha=
t
> uses MADV_FREE instead of MADV_DONTNEED.

Yes, addon patch makes perfect sense. The nice thing about MADV_FREE is
that you only take back pages from a process when really under memory
pressure (before going to SWAP). You will still get a pagefault on the
next access (to identify that the page is still in use after all), but
don't have to fault in a fresh page.

>=20
>>> The overall guest size is kept fairly small to only a few GB while the =
test
>>> is running. If the host memory were oversubscribed this patch set shoul=
d
>>> result in a performance improvement as swapping memory in the host can =
be
>>> avoided.
>>>
>>> A brief history on the background of unused page reporting can be found=
 at:
>>> https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.c=
amel@linux.intel.com/
>>>
>>> Changes from v12:
>>> https://lore.kernel.org/lkml/20191022221223.17338.5860.stgit@localhost.=
localdomain/
>>> Rebased on linux-next 20191031
>>> Renamed page_is_reported to page_reported
>>> Renamed add_page_to_reported_list to mark_page_reported
>>> Dropped unused definition of add_page_to_reported_list for non-reportin=
g case
>>> Split free_area_reporting out from get_unreported_tail
>>> Minor updates to cover page
>>>
>>> Changes from v13:
>>> https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost=
.localdomain/
>>> Rewrote core reporting functionality
>>>   Merged patches 3 & 4
>>>   Dropped boundary list and related code
>>>   Folded get_reported_page into page_reporting_fill
>>>   Folded page_reporting_fill into page_reporting_cycle
>>> Pulled reporting functionality out of free_reported_page
>>>   Renamed it to __free_isolated_page
>>>   Moved page reporting specific bits to page_reporting_drain
>>> Renamed phdev to prdev since we aren't "hinting" we are "reporting"
>>> Added documentation to describe the usage of unused page reporting
>>> Updated cover page and patch descriptions to avoid mention of boundary
>>>
>>>
>>> ---
>>>
>>> Alexander Duyck (6):
>>>       mm: Adjust shuffle code to allow for future coalescing
>>>       mm: Use zone and order instead of free area in free_list manipula=
tors
>>>       mm: Introduce Reported pages
>>>       mm: Add unused page reporting documentation
>>>       virtio-balloon: Pull page poisoning config out of free page hinti=
ng
>>>       virtio-balloon: Add support for providing unused page reports to =
host
>>>
>>>
>>>  Documentation/vm/unused_page_reporting.rst |   44 ++++
>>>  drivers/virtio/Kconfig                     |    1=20
>>>  drivers/virtio/virtio_balloon.c            |   88 +++++++
>>>  include/linux/mmzone.h                     |   56 +----
>>>  include/linux/page-flags.h                 |   11 +
>>>  include/linux/page_reporting.h             |   31 +++
>>>  include/uapi/linux/virtio_balloon.h        |    1=20
>>>  mm/Kconfig                                 |   11 +
>>>  mm/Makefile                                |    1=20
>>>  mm/memory_hotplug.c                        |    2=20
>>>  mm/page_alloc.c                            |  181 +++++++++++----
>>>  mm/page_reporting.c                        |  337 ++++++++++++++++++++=
++++++++
>>>  mm/page_reporting.h                        |  125 ++++++++++
>>>  mm/shuffle.c                               |   12 -
>>>  mm/shuffle.h                               |    6=20
>>>  15 files changed, 805 insertions(+), 102 deletions(-)
>>
>> So roughly 100 LOC less added, that's nice to see :)
>>
>> I'm planning to look into the details soon, just fairly busy lately. I
>> hope Mel Et al. can also comment.
>=20
> Agreed. I can see if I can generate something to get the MADV_FREE
> numbers. I suspect they were probably be somewhere between the MADV
> disabled and fully enabled case, since we will still be taking the page
> faults but not doing the zeroing.

Exactly.

--=20
Thanks,

David / dhildenb

