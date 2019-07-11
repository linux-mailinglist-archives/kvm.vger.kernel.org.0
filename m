Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E09964D05
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 21:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfGJTw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 15:52:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJTw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 15:52:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4734C3005159;
        Wed, 10 Jul 2019 19:52:25 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80D2019C69;
        Wed, 10 Jul 2019 19:52:16 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com,
        john.starks@microsoft.com, dave.hansen@intel.com, mhocko@suse.com
Subject: [RFC][PATCH v11 0/2] mm: Support for page hinting
Date:   Wed, 10 Jul 2019 15:51:56 -0400
Message-Id: <20190710195158.19640-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 10 Jul 2019 19:52:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series proposes an efficient mechanism for reporting free memory
from a guest to its hypervisor. It especially enables guests with no page cache
(e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
rapidly hand back free memory to the hypervisor.
This approach has a minimal impact on the existing core-mm infrastructure.

Measurement results (measurement details appended to this email):
*Number of 5GB guests (each touching 4GB memory) that can be launched
without swap usage on a system with 15GB:
unmodified kernel - 2, 3rd with 2.5GB   
v11 page hinting - 6, 7th with 26MB    
v1 bubble hinting[1] - 6, 7th with 1.8GB (bubble hinting is another series
proposed to solve the same problems)

*Memhog execution time (For 3 guests each of 6GB on a system with 15GB):
unmodified kernel - Guest1:21s, Guest2:27s, Guest3:2m37s swap used = 3.7GB       
v11 page hinting - Guest1:23s, Guest2:26s, Guest3:21s swap used = 0           
v1 bubble hinting - Guest1:23, Guest2:11s, Guest3:26s swap used = 0           


This approach tracks all freed pages of the order MAX_ORDER - 2 in bitmaps.
A new hook after buddy merging is used to set the bits in the bitmap.
Currently, the bits are only cleared when pages are hinted, not when pages are
re-allocated.

Bitmaps are stored on a per-zone basis and are protected by the zone lock. A
workqueue asynchronously processes the bitmaps as soon as a pre-defined memory
threshold is met, trying to isolate and report pages that are still free.

The isolated pages are reported via virtio-balloon, which is responsible for
sending batched pages to the host synchronously. Once the hypervisor processed
the hinting request, the isolated pages are returned back to the buddy.

Changelog in v11:
* Added logic to take care of multiple NUMA nodes scenarios.
* Simplified the logic for reporting isolated pages to the host. (Eg. replaced
dynamically allocated arrays with static ones, introduced wait event instead of
the loop in order to wait for a response from the host)
* Added a mutex to prevent race condition when page hinting is enabled by
multiple drivers.
* Simplified the logic responsible for decrementing free page counter for each
zone.
* Simplified code structuring/naming.

Known work items for the future:
* Test device assigned guests to ensure that hinting doesn't break it.
* Follow up on VIRTIO_BALLOON_F_PAGE_POISON's device-side support.
* Decide between MADV_DONTNEED and MADV_FREE.
* Look into memory hotplug, more efficient locking, better naming conventions to
avoid confusion with VIRTIO_BALLOON_F_FREE_PAGE_HINT support.
* Come up with proper/traceable error-message/logs and look into other code
simplifications. (If necessary).

Benefit analysis:
1. Number of 5GB guests (each touching 4GB memory) that can be launched without
swap usage on a system with 15GB:
unmodified kernel - 2, 3rd with 2.5GB   
v11 page hinting - 6, 7th with 26MB    
v1 bubble hinting - 6, 7th with 1.8GB   

Conclusion - In this particular testcase on using v11 page hinting and
v1 bubble-hinting 4 more guests could be launched without swapping compared
to an unmodified kernel.
For the 7th guest launch, v11 page hinting is slightly better than v1 Bubble
hinting as it touches lesser swap space.

Setup & procedure - 
Total NUMA Node Memory ~ 15 GB (All guests are run on a single NUMA node)
Guest Memory = 5GB
Number of CPUs in the guest = 1
Host swap = 4GB
Workload = test allocation program that allocates 4GB memory, touches it via
memset and exits.
The first guest is launched and once its console is up, the test allocation
program is executed with 4 GB memory request (Due to this the guest occupies
almost 4-5 GB of memory in the host in a system without page hinting). Once
this program exits at that time another guest is launched in the host and the
same process is followed. It is continued until the swap is not used.

2. Memhog execution time (For 3 guests each of 6GB on a system with 15GB):
unmodified kernel - Guest1:21s, Guest2:27s, Guest3:2m37s swap used = 3.7GB       
v11 page hinting - Guest1:23s, Guest2:26s, Guest3:21s swap used = 0           
v1 bubble hinting - Guest1:23, Guest2:11s, Guest3:26s swap used = 0           

For this particular test-case in a guest which doesn't require swap access
"memhog 6G" execution time lies within a range of 15-30s.
Conclusion -
In the above test case for an unmodified kernel on executing memhog in the
third guest execution time rises to above 2minutes due to swap access.
Using either page-hinting or bubble hinting brings this execution time to a
a normal range of 15-30s.

Setup & procedure -
Total NUMA Node Memory ~ 15 GB (All guests are run on a single NUMA node)
Guest Memory = 6GB
Number of CPUs in the guest = 4
Process = 3 Guests are launched and the ‘memhog 6G’ execution time is monitored
one after the other in each of them.
Host swap = 4GB

Performance Analysis:
1. will-it-scale's page_faul1
Setup -
Guest Memory = 6GB
Number of cores = 24

Unmodified kernel -
0,0,100,0,100,0
1,514453,95.84,519502,95.83,519502
2,991485,91.67,932268,91.68,1039004
3,1381237,87.36,1264214,87.64,1558506
4,1789116,83.36,1597767,83.88,2078008
5,2181552,79.20,1889489,80.08,2597510
6,2452416,75.05,2001879,77.10,3117012
7,2671047,70.90,2263866,73.22,3636514
8,2930081,66.75,2333813,70.60,4156016
9,3126431,62.60,2370108,68.28,4675518
10,3211937,58.44,2454093,65.74,5195020
11,3162172,54.32,2450822,63.21,5714522
12,3154261,50.14,2272290,58.98,6234024
13,3115174,46.02,2369679,57.74,6753526
14,3150511,41.86,2470837,54.02,7273028
15,3134158,37.71,2428129,51.98,7792530
16,3143067,33.57,2340469,49.54,8312032
17,3112457,29.43,2263627,44.81,8831534
18,3089724,25.29,2181879,38.69,9351036
19,3076878,21.15,2236505,40.01,9870538
20,3091978,16.95,2266327,35.00,10390040
21,3082927,12.84,2172578,28.12,10909542
22,3055282,8.73,2176269,29.14,11429044
23,3081144,4.56,2138442,24.87,11948546
24,3075509,0.45,2173753,21.62,12468048

page hinting -
0,0,100,0,100,0
1,491683,95.83,494366,95.82,494366
2,988415,91.67,919660,91.68,988732
3,1344829,87.52,1244608,87.69,1483098
4,1797933,83.37,1625797,83.70,1977464
5,2179009,79.21,1881534,80.13,2471830
6,2449858,75.07,2078137,76.82,2966196
7,2732122,70.90,2178105,73.75,3460562
8,2910965,66.75,2340901,70.28,3954928
9,3006665,62.61,2353748,67.91,4449294
10,3164752,58.46,2377936,65.08,4943660
11,3234846,54.32,2510149,63.14,5438026
12,3165477,50.17,2412007,59.91,5932392
13,3141457,46.05,2421548,57.85,6426758
14,3135839,41.90,2378021,53.81,6921124
15,3109113,37.75,2269290,51.76,7415490
16,3093613,33.62,2346185,48.73,7909856
17,3086542,29.49,2352140,46.19,8404222
18,3048991,25.36,2217144,41.52,8898588
19,2965500,21.18,2313614,38.18,9392954
20,2928977,17.05,2175316,35.67,9887320
21,2896667,12.91,2141311,28.90,10381686
22,3047782,8.76,2177664,28.24,10876052
23,2994503,4.58,2160976,22.97,11370418
24,3038762,0.47,2053533,22.39,11864784

bubble-hinting v1 - 
0,0,100,0,100,0
1,515272,95.83,492355,95.81,515272
2,985903,91.66,919653,91.68,1030544
3,1475300,87.51,1353723,87.65,1545816
4,1783938,83.36,1586307,83.78,2061088
5,2093307,79.20,1867395,79.95,2576360
6,2441370,75.05,2055421,76.65,3091632
7,2650471,70.89,2246014,72.93,3606904
8,2926782,66.75,2333601,70.41,4122176
9,3107617,62.60,2383112,68.46,4637448
10,3192332,58.44,2441626,65.84,5152720
11,3268043,54.32,2235964,62.92,5667992
12,3191105,50.18,2449045,60.49,6183264
13,3145317,46.05,2377317,57.80,6698536
14,3161552,41.91,2395814,53.26,7213808
15,3140443,37.77,2333200,51.42,7729080
16,3130866,33.65,2150967,46.11,8244352
17,3112894,29.52,2372068,45.93,8759624
18,3078424,25.39,2336211,39.85,9274896
19,3036457,21.27,2224821,35.25,9790168
20,3046330,17.13,2199755,37.43,10305440
21,2981130,12.98,2214862,28.67,10820712
22,3017481,8.84,2195996,29.69,11335984
23,2979906,4.68,2173395,25.90,11851256
24,2971170,0.52,2134311,21.89,12366528

Conclusion -
For an unmodified kernel, with every fresh boot, there is 3-4% delta observed
in the results wrt the numbers mentioned above. For both bubble-hinting and
page-hinting, there was no noticeable degradation observed other than the
expected variability mentioned earlier. 

Page hinting vs bubble hinting:
From the benefits and performance perspective, both solutions look quite similar
so far. However, unlike bubble-hinting which is more invasive, the overall core
mm changes required for page hinting are minimal.

[1] https://lkml.org/lkml/2019/6/19/926

Nitesh Narayan Lal (2):
  mm: page_hinting: core infrastructure
  virtio-balloon: page_hinting: reporting to the host

 drivers/virtio/Kconfig              |   1 +
 drivers/virtio/virtio_balloon.c     |  91 +++++++++-
 include/linux/page_hinting.h        |  45 +++++
 include/uapi/linux/virtio_balloon.h |  11 ++
 mm/Kconfig                          |   6 +
 mm/Makefile                         |   1 +
 mm/page_alloc.c                     |  18 +-
 mm/page_hinting.c                   | 250 ++++++++++++++++++++++++++++
 8 files changed, 414 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/page_hinting.h
 create mode 100644 mm/page_hinting.c

-- 


