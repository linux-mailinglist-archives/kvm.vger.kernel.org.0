Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4BA2816FC
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388091AbgJBPoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387688AbgJBPo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092Fgtfs170844
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OBFmEtstBDrixjho+AObz9IFTju2w8vuHTINydbaTtY=;
 b=nCiv1hGBKTD+VmUq5V/XUQWX/FF62Qme6WSwf3O6euwt+eqFUvnBh44bvl1niiTsD2Ru
 A97adqQVrNgpPCipksB6Z5HQR5npl3VuyD9BmA/nUNfsNCHQuWKFAHEeX6TO1cYIPKYq
 uWgDBrOQjEv19kz1cgapB3f+qhV4540hk8EMe4idsOKMoc+wtedRBO99hjey24UzQ+SG
 XEcUz6xkG2RgGL2O/B+uA8CGaQiWs4T+ZNbWjU3vE+nML075BHoZAFrr9DXH9u3P0Dys
 gsn5h4M3t+sH7XvmJbxY6Z77VhsesZ+ghcAn4jQ2nCOXfSghokNNv3HSJivwh+7MrBQt KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73900xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:26 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FiQFS174521
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73900wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:25 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FhJkH031116;
        Fri, 2 Oct 2020 15:44:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97xqj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiLi927525380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69A654203F;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05DBB42042;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
Date:   Fri,  2 Oct 2020 17:44:13 +0200
Message-Id: <20201002154420.292134-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 clxscore=1011 adultscore=0 mlxlogscore=999 spamscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM unit tests are increasingly being used to test more than just
KVM. They are being used to test TCG, qemu I/O device emulation, other
hypervisors, and even actual hardware.

The existing memory allocators are becoming more and more inadequate to
the needs of the upcoming unit tests (but also some existing ones, see
below).

Some important features that are lacking:
* ability to perform a small physical page allocation with a big
  alignment withtout wasting huge amounts of memory
* ability to allocate physical pages from specific pools/areaas (e.g.
  below 16M, or 4G, etc)
* ability to reserve arbitrary pages (if free), removing them from the
  free pool

Some other features that are nice, but not so fundamental:
* no need for the generic allocator to keep track of metadata
  (i.e. allocation size), this is now handled by the lower level
  allocators
* coalescing small blocks into bigger ones, to allow contiguous memory
  freed in small blocks in a random order to be used for large
  allocations again

This is achieved in the following ways:

For the virtual allocator:
* only the virtul allocator needs one extra page of metadata, but only
  for allocations that wouldn't fit in one page

For the page allocator:
* page allocator has up to 6 memory pools, each pool has a metadata
  area; the metadata has a byte for each page in the area, describing
  the order of the block it belongs to, and whether it is free
* if there are no free blocks of the desired size, a bigger block is
  split until we reach the required size; the unused parts of the block
  are put back in the free lists
* if an allocation needs ablock with a larger alignment than its size, a
  larger block of (at least) the required order is split; the unused parts
  put back in the appropriate free lists
* if the allocation could not be satisfied, the next allowed area is
  searched; the allocation fails only when all allowed areas have been
  tried
* new functions to perform allocations from specific areas; the areas
  are arch-dependent and should be set up by the arch code
* for now x86 has a memory area for "lowest" memory under 16MB, one for
  "low" memory under 4GB and one for the rest, while s390x has one for under
  2GB and one for the rest; suggestions for more fine grained areas or for
  the other architectures are welcome
* upon freeing a block, an attempt is made to coalesce it into the
  appropriate neighbour (if it is free), and so on for the resulting
  larger block thus obtained

For the physical allocator:
* the minimum alignment is now handled manually, since it has been
  removed from the common struct


This patchset addresses some current but otherwise unsolvable issues on
s390x, such as the need to allocate a block under 2GB for each SMP CPU
upon CPU activation.

This patchset has been tested on s390x, amd64 and i386. It has also been
compiled on aarch64.

V1->V2:
* Renamed some functions, as per review comments
* Improved commit messages
* Split the list handling functions into an independent header
* Addded arch-specific headers to define the memory areas
* Fixed some minor issues
* The magic value for small allocations in the virtual allocator is now
  put right before the returned pointer, like for large allocations
* Added comments to make the code more readable
* Many minor fixes

Claudio Imbrenda (7):
  lib/list: Add double linked list management functions
  lib/vmalloc: vmalloc support for handling allocation metadata
  lib/asm: Add definitions of memory areas
  lib/alloc_page: complete rewrite of the page allocator
  lib/alloc: simplify free and malloc
  lib/alloc.h: remove align_min from struct alloc_ops
  lib/alloc_page: allow reserving arbitrary memory ranges

 lib/asm-generic/memory_areas.h |  11 +
 lib/arm/asm/memory_areas.h     |  11 +
 lib/arm64/asm/memory_areas.h   |  11 +
 lib/powerpc/asm/memory_areas.h |  11 +
 lib/ppc64/asm/memory_areas.h   |  11 +
 lib/s390x/asm/memory_areas.h   |  17 ++
 lib/x86/asm/memory_areas.h     |  22 ++
 lib/alloc.h                    |   3 +-
 lib/alloc_page.h               |  80 ++++-
 lib/list.h                     |  53 ++++
 lib/alloc.c                    |  42 +--
 lib/alloc_page.c               | 541 +++++++++++++++++++++++++++------
 lib/alloc_phys.c               |   9 +-
 lib/arm/setup.c                |   2 +-
 lib/s390x/sclp.c               |   6 +-
 lib/s390x/smp.c                |   6 +-
 lib/vmalloc.c                  | 121 ++++++--
 s390x/smp.c                    |   4 +-
 18 files changed, 789 insertions(+), 172 deletions(-)
 create mode 100644 lib/asm-generic/memory_areas.h
 create mode 100644 lib/arm/asm/memory_areas.h
 create mode 100644 lib/arm64/asm/memory_areas.h
 create mode 100644 lib/powerpc/asm/memory_areas.h
 create mode 100644 lib/ppc64/asm/memory_areas.h
 create mode 100644 lib/s390x/asm/memory_areas.h
 create mode 100644 lib/x86/asm/memory_areas.h
 create mode 100644 lib/list.h

-- 
2.26.2

