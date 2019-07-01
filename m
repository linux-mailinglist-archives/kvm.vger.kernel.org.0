Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31B1335F4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfFCREC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 13:04:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfFCREB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 13:04:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D267AC028353;
        Mon,  3 Jun 2019 17:03:55 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9238960C66;
        Mon,  3 Jun 2019 17:03:41 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com
Subject: [RFC][Patch v10 0/2] mm: Support for page hinting 
Date:   Mon,  3 Jun 2019 13:03:04 -0400
Message-Id: <20190603170306.49099-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 03 Jun 2019 17:04:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series proposes an efficient mechanism for communicating free memory
from a guest to its hypervisor. It especially enables guests with no page cache
(e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
rapidly hand back free memory to the hypervisor.
This approach has a minimal impact on the existing core-mm infrastructure.

Measurement results (measurement details appended to this email):
* With active page hinting, 3 more guests could be launched each of 5 GB(total 
5 vs. 2) on a 15GB (single NUMA) system without swapping.
* With active page hinting, on a system with 15 GB of (single NUMA) memory and
4GB of swap, the runtime of "memhog 6G" in 3 guests (run sequentially) resulted
in the last invocation to only need 37s compared to 3m35s without page hinting.

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

The key changes made in this series compared to v9[1] are:
* Pages only in the chunks of "MAX_ORDER - 2" are reported to the hypervisor to
not break up the THP.
* At a time only a set of 16 pages can be isolated and reported to the host to
avoids any false OOMs.
* page_hinting.c is moved under mm/ from virt/kvm/ as the feature is dependent
on virtio and not on KVM itself. This would enable any other hypervisor to use
this feature by implementing virtio devices.
* The sysctl variable is replaced with a virtio-balloon parameter to
enable/disable page-hinting.

Pending items:
* Test device assigned guests to ensure that hinting doesn't break it.
* Follow up on VIRTIO_BALLOON_F_PAGE_POISON's device side support.
* Compare reporting free pages via vring with vhost.
* Decide between MADV_DONTNEED and MADV_FREE.
* Look into memory hotplug, more efficient locking, possible races when
disabling.
* Come up with proper/traceable error-message/logs.
* Minor reworks and simplifications (e.g., virtio protocol).

Benefit analysis:
1. Use-case - Number of guests that can be launched without swap usage
NUMA Nodes = 1 with 15 GB memory
Guest Memory = 5 GB
Number of cores in guest = 1
Workload = test allocation program allocates 4GB memory, touches it via memset
and exits.
Procedure =
The first guest is launched and once its console is up, the test allocation
program is executed with 4 GB memory request (Due to this the guest occupies
almost 4-5 GB of memory in the host in a system without page hinting). Once
this program exits at that time another guest is launched in the host and the
same process is followed. It is continued until the swap is not used.

Results:
Without hinting = 3, swap usage at the end 1.1GB.
With hinting = 5, swap usage at the end 0.

2. Use-case - memhog execution time
Guest Memory = 6GB
Number of cores = 4
NUMA Nodes = 1 with 15 GB memory
Process: 3 Guests are launched and the ‘memhog 6G’ execution time is monitored
one after the other in each of them.
Without Hinting - Guest1:47s, Guest2:53s, Guest3:3m35s, End swap usage: 3.5G
With Hinting - Guest1:40s, Guest2:44s, Guest3:37s, End swap usage: 0

Performance analysis:
1. will-it-scale's page_faul1:
Guest Memory = 6GB
Number of cores = 24

Without Hinting:
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,315890,95.82,317633,95.83,317633
2,570810,91.67,531147,91.94,635266
3,826491,87.54,713545,88.53,952899
4,1087434,83.40,901215,85.30,1270532
5,1277137,79.26,916442,83.74,1588165
6,1503611,75.12,1113832,79.89,1905798
7,1683750,70.99,1140629,78.33,2223431
8,1893105,66.85,1157028,77.40,2541064
9,2046516,62.50,1179445,76.48,2858697
10,2291171,58.57,1209247,74.99,3176330
11,2486198,54.47,1217265,75.13,3493963
12,2656533,50.36,1193392,74.42,3811596
13,2747951,46.21,1185540,73.45,4129229
14,2965757,42.09,1161862,72.20,4446862
15,3049128,37.97,1185923,72.12,4764495
16,3150692,33.83,1163789,70.70,5082128
17,3206023,29.70,1174217,70.11,5399761
18,3211380,25.62,1179660,69.40,5717394
19,3202031,21.44,1181259,67.28,6035027
20,3218245,17.35,1196367,66.75,6352660
21,3228576,13.26,1129561,66.74,6670293
22,3207452,9.15,1166517,66.47,6987926
23,3153800,5.09,1172877,61.57,7305559
24,3184542,0.99,1186244,58.36,7623192

With Hinting:
0,0,100,0,100,0
1,306737,95.82,305130,95.78,306737
2,573207,91.68,530453,91.92,613474
3,810319,87.53,695281,88.58,920211
4,1074116,83.40,880602,85.48,1226948
5,1308283,79.26,1109257,81.23,1533685
6,1501987,75.12,1093661,80.19,1840422
7,1695300,70.99,1104207,79.03,2147159
8,1901523,66.85,1193613,76.90,2453896
9,2051288,62.73,1200913,76.22,2760633
10,2275771,58.60,1192992,75.66,3067370
11,2435016,54.48,1191472,74.66,3374107
12,2623114,50.35,1196911,74.02,3680844
13,2766071,46.22,1178589,73.02,3987581
14,2932163,42.10,1166414,72.96,4294318
15,3000853,37.96,1177177,72.62,4601055
16,3113738,33.85,1165444,70.54,4907792
17,3132135,29.77,1165055,68.51,5214529
18,3175121,25.69,1166969,69.27,5521266
19,3205490,21.61,1159310,65.65,5828003
20,3220855,17.52,1171827,62.04,6134740
21,3182568,13.48,1138918,65.05,6441477
22,3130543,9.30,1128185,60.60,6748214
23,3087426,5.15,1127912,55.36,7054951
24,3099457,1.04,1176100,54.96,7361688

[1] https://lkml.org/lkml/2019/3/6/413


