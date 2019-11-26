Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74535109DC9
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 13:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfKZMUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 07:20:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727951AbfKZMUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 07:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574770850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0QicmIFZgcSaQ9HsIRb0rZI3UQa68hu10zVrXnNnFpg=;
        b=MyW/52A2iae4cmOmfOyrWtEfDRX6KoGCyxCEeEiX81ufy/Er+CHzt4apfblbaVi8AD+hEA
        9afpn6EhivH9zz9v7pj15mepcN9hDTf4HfLJugO5oyg6DLJwce4D04XO2RSdabnSM1p9q8
        o/9v0x9rWpOLWO0S69IuYpi/2bfGN4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-355O7T9NPBSsoMY5TCwDaQ-1; Tue, 26 Nov 2019 07:20:48 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 288381007269;
        Tue, 26 Nov 2019 12:20:46 +0000 (UTC)
Received: from [10.36.118.20] (unknown [10.36.118.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 776561001DC0;
        Tue, 26 Nov 2019 12:20:33 +0000 (UTC)
Subject: Re: [PATCH v14 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAj4EEwECACgFAljj9eoCGwMFCQlmAYAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEE3eEPcA/4Na5IIP/3T/FIQMxIfNzZshIq687qgG
 8UbspuE/YSUDdv7r5szYTK6KPTlqN8NAcSfheywbuYD9A4ZeSBWD3/NAVUdrCaRP2IvFyELj
 xoMvfJccbq45BxzgEspg/bVahNbyuBpLBVjVWwRtFCUEXkyazksSv8pdTMAs9IucChvFmmq3
 jJ2vlaz9lYt/lxN246fIVceckPMiUveimngvXZw21VOAhfQ+/sofXF8JCFv2mFcBDoa7eYob
 s0FLpmqFaeNRHAlzMWgSsP80qx5nWWEvRLdKWi533N2vC/EyunN3HcBwVrXH4hxRBMco3jvM
 m8VKLKao9wKj82qSivUnkPIwsAGNPdFoPbgghCQiBjBe6A75Z2xHFrzo7t1jg7nQfIyNC7ez
 MZBJ59sqA9EDMEJPlLNIeJmqslXPjmMFnE7Mby/+335WJYDulsRybN+W5rLT5aMvhC6x6POK
 z55fMNKrMASCzBJum2Fwjf/VnuGRYkhKCqqZ8gJ3OvmR50tInDV2jZ1DQgc3i550T5JDpToh
 dPBxZocIhzg+MBSRDXcJmHOx/7nQm3iQ6iLuwmXsRC6f5FbFefk9EjuTKcLMvBsEx+2DEx0E
 UnmJ4hVg7u1PQ+2Oy+Lh/opK/BDiqlQ8Pz2jiXv5xkECvr/3Sv59hlOCZMOaiLTTjtOIU7Tq
 7ut6OL64oAq+uQINBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCghCj/CA/lc/LMthqQ773ga
 uB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseBfDXHA6m4B3mUTWo13nid
 0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts6TZ+IrPOwT1hfB4WNC+X
 2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiuQmt3yqrmN63V9wzaPhC+
 xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKBTccu2AXJXWAE1Xjh6GOC
 8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvFFFyAS0Nk1q/7EChPcbRb
 hJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh2YmnmLRTro6eZ/qYwWkC
 u8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRkF3TwgucpyPtcpmQtTkWS
 gDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0LLH63+BrrHasfJzxKXzqg
 rW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4vq7oFCPsOgwARAQABiQIl
 BBgBAgAPBQJVy5+RAhsMBQkJZgGAAAoJEE3eEPcA/4NagOsP/jPoIBb/iXVbM+fmSHOjEshl
 KMwEl/m5iLj3iHnHPVLBUWrXPdS7iQijJA/VLxjnFknhaS60hkUNWexDMxVVP/6lbOrs4bDZ
 NEWDMktAeqJaFtxackPszlcpRVkAs6Msn9tu8hlvB517pyUgvuD7ZS9gGOMmYwFQDyytpepo
 YApVV00P0u3AaE0Cj/o71STqGJKZxcVhPaZ+LR+UCBZOyKfEyq+ZN311VpOJZ1IvTExf+S/5
 lqnciDtbO3I4Wq0ArLX1gs1q1XlXLaVaA3yVqeC8E7kOchDNinD3hJS4OX0e1gdsx/e6COvy
 qNg5aL5n0Kl4fcVqM0LdIhsubVs4eiNCa5XMSYpXmVi3HAuFyg9dN+x8thSwI836FoMASwOl
 C7tHsTjnSGufB+D7F7ZBT61BffNBBIm1KdMxcxqLUVXpBQHHlGkbwI+3Ye+nE6HmZH7IwLwV
 W+Ajl7oYF+jeKaH4DZFtgLYGLtZ1LDwKPjX7VAsa4Yx7S5+EBAaZGxK510MjIx6SGrZWBrrV
 TEvdV00F2MnQoeXKzD7O4WFbL55hhyGgfWTHwZ457iN9SgYi1JLPqWkZB0JRXIEtjd4JEQcx
 +8Umfre0Xt4713VxMygW0PnQt5aSQdMD58jHFxTk092mU+yIHj5LeYgvwSgZN4airXk5yRXl
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
Date:   Tue, 26 Nov 2019 13:20:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191119214454.24996.66289.stgit@localhost.localdomain>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 355O7T9NPBSsoMY5TCwDaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.11.19 22:46, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting unused guest
> pages to a hypervisor so that the memory associated with those pages can
> be dropped and reused by other processes and/or guests on the host. Using
> this it is possible to avoid unnecessary I/O to disk and greatly improve
> performance in the case of memory overcommit on the host.
>=20
> When enabled it will allocate a set of statistics to track the number of
> reported pages. When the nr_free for a given free area is greater than
> this by the high water mark we will schedule a worker to begin pulling th=
e
> non-reported memory and to provide it to the reporting interface via a
> scatterlist.
>=20
> Currently this is only in use by virtio-balloon however there is the hope
> that at some point in the future other hypervisors might be able to make
> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> currently using MADV_DONTNEED to indicate to the host kernel that the pag=
e
> is currently unused. It will be zeroed and faulted back into the guest th=
e
> next time the page is accessed.

Remind me why we are using MADV_DONTNEED? Mostly for debugging purposes
right now, right? Did you do any measurements with MADV_FREE? I guess
there should be quite a performance increase in some scenarios.

>=20
> To track if a page is reported or not the Uptodate flag was repurposed an=
d
> used as a Reported flag for Buddy pages. We walk though the free list
> isolating pages and adding them to the scatterlist until we either
> encounter the end of the list or have filled the scatterlist with pages t=
o
> be reported. If we fill the scatterlist before we reach the end of the
> list we rotate the list so that the first unreported page we encounter is
> moved to the head of the list as that is where we will resume after we
> have freed the reported pages back into the tail of the list.

So the boundary pointer didn't actually provide that big of a benefit I
assume (IOW, worst thing is you have to re-scan the whole list)?

>=20
> Below are the results from various benchmarks. I primarily focused on two
> tests. The first is the will-it-scale/page_fault2 test, and the other is
> a modified version of will-it-scale/page_fault1 that was enabled to use
> THP. I did this as it allows for better visibility into different parts
> of the memory subsystem. The guest is running with 32G for RAM on one
> node of a E5-2630 v3. The host has had some power saving features disable=
d
> by setting the /dev/cpu_dma_latency value to 10ms.
>=20
> Test                page_fault1 (THP)     page_fault2
> Name         tasks  Process Iter  STDEV  Process Iter  STDEV
> Baseline         1    1203934.75  0.04%     379940.75  0.11%
>                 16    8828217.00  0.85%    3178653.00  1.28%
>=20
> Patches applied  1    1207961.25  0.10%     380852.25  0.25%
>                 16    8862373.00  0.98%    3246397.25  0.68%
>=20
> Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
>  MADV disabled  16    8870373.75  0.29%=09   3204989.75  1.08%
>=20
> Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
>                 16    8371359.75  0.65%    3233665.50  0.84%
>=20
> Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
>  page shuffle   16    8108719.75  0.58%    3218450.25  1.07%
>=20
> The results above are for a baseline with a linux-next-20191115 kernel,
> that kernel with this patch set applied but page reporting disabled in
> virtio-balloon, patches applied but the madvise disabled by direct
> assigning a device, the patches applied and page reporting fully
> enabled, and the patches enabled with page shuffling enabled.  These
> results include the deviation seen between the average value reported her=
e
> versus the high and/or low value. I observed that during the test memory
> usage for the first three tests never dropped whereas with the patches
> fully enabled the VM would drop to using only a few GB of the host's
> memory when switching from memhog to page fault tests.
>=20
> Most of the overhead seen with this patch set enabled seems due to page
> faults caused by accessing the reported pages and the host zeroing the pa=
ge
> before giving it back to the guest. This overhead is much more visible wh=
en
> using THP than with standard 4K pages. In addition page shuffling seemed =
to
> increase the amount of faults generated due to an increase in memory chur=
n.

MADV_FREE would be interesting.

>=20
> The overall guest size is kept fairly small to only a few GB while the te=
st
> is running. If the host memory were oversubscribed this patch set should
> result in a performance improvement as swapping memory in the host can be
> avoided.
>=20
> A brief history on the background of unused page reporting can be found a=
t:
> https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.cam=
el@linux.intel.com/
>=20
> Changes from v12:
> https://lore.kernel.org/lkml/20191022221223.17338.5860.stgit@localhost.lo=
caldomain/
> Rebased on linux-next 20191031
> Renamed page_is_reported to page_reported
> Renamed add_page_to_reported_list to mark_page_reported
> Dropped unused definition of add_page_to_reported_list for non-reporting =
case
> Split free_area_reporting out from get_unreported_tail
> Minor updates to cover page
>=20
> Changes from v13:
> https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost.l=
ocaldomain/
> Rewrote core reporting functionality
>   Merged patches 3 & 4
>   Dropped boundary list and related code
>   Folded get_reported_page into page_reporting_fill
>   Folded page_reporting_fill into page_reporting_cycle
> Pulled reporting functionality out of free_reported_page
>   Renamed it to __free_isolated_page
>   Moved page reporting specific bits to page_reporting_drain
> Renamed phdev to prdev since we aren't "hinting" we are "reporting"
> Added documentation to describe the usage of unused page reporting
> Updated cover page and patch descriptions to avoid mention of boundary
>=20
>=20
> ---
>=20
> Alexander Duyck (6):
>       mm: Adjust shuffle code to allow for future coalescing
>       mm: Use zone and order instead of free area in free_list manipulato=
rs
>       mm: Introduce Reported pages
>       mm: Add unused page reporting documentation
>       virtio-balloon: Pull page poisoning config out of free page hinting
>       virtio-balloon: Add support for providing unused page reports to ho=
st
>=20
>=20
>  Documentation/vm/unused_page_reporting.rst |   44 ++++
>  drivers/virtio/Kconfig                     |    1=20
>  drivers/virtio/virtio_balloon.c            |   88 +++++++
>  include/linux/mmzone.h                     |   56 +----
>  include/linux/page-flags.h                 |   11 +
>  include/linux/page_reporting.h             |   31 +++
>  include/uapi/linux/virtio_balloon.h        |    1=20
>  mm/Kconfig                                 |   11 +
>  mm/Makefile                                |    1=20
>  mm/memory_hotplug.c                        |    2=20
>  mm/page_alloc.c                            |  181 +++++++++++----
>  mm/page_reporting.c                        |  337 ++++++++++++++++++++++=
++++++
>  mm/page_reporting.h                        |  125 ++++++++++
>  mm/shuffle.c                               |   12 -
>  mm/shuffle.h                               |    6=20
>  15 files changed, 805 insertions(+), 102 deletions(-)

So roughly 100 LOC less added, that's nice to see :)

I'm planning to look into the details soon, just fairly busy lately. I
hope Mel Et al. can also comment.

--=20
Thanks,

David / dhildenb

