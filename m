Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDF12F79E9
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbhAOMiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:38:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33404 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388151AbhAOMiU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:38:20 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCYfJe175231;
        Fri, 15 Jan 2021 07:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FfM/3CEd1frObqGH3db7krvBpA6LObXCxovIaDzO2Xk=;
 b=Eq8sqJUcn1GSM5R2nik+okA6IAJXl3+5xORBryrQRJaDiZHjZuqgTj/WxURrMMcjwXco
 arMKI+8l6ZyNtdiLFJDA3AXAGOikLtXW08Repw/L4oLxcOTBzWN9rCiTwLdrM8U5k+Ov
 crdCK/B5DAYav58gbOtdqb3aN1gPGBXgL8GBZ8f0h35OrgAjpkugqCkmnOQGciQ0pmPb
 iIzg8SQ3q8vOUb22ZsVXDax/FG4oW3efz/cNS/mTGhX5B5fJVXXFJ4qHYoV4ySYYSU/q
 fcj/23CrD0WN34e9389Rh4kWwgy/sd5kUXFkc2ikQPcL+/mN9M1/l0j9HTkoSHnKRkL6 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363axcgep8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCZ8SV177288;
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363axcgen1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCb9ZS032538;
        Fri, 15 Jan 2021 12:37:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447yp48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbVDM34275630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99D2EAE056;
        Fri, 15 Jan 2021 12:37:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C553AE05F;
        Fri, 15 Jan 2021 12:37:31 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 00/11] Fix and improve the page allocator
Date:   Fri, 15 Jan 2021 13:37:19 +0100
Message-Id: <20210115123730.381612-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My previous patchseries was rushed and not polished enough. Furthermore it
introduced some regressions.

This patchseries fixes hopefully all the issues reported, and introduces
some new features.

It also simplifies the code and hopefully makes it more readable.

Fixed:
* allocated memory is now zeroed by default

New features:
* per-allocation flags to specify not just the area (like before) but also
  other parameters
  - dontzero flag: the allocation will not be zeroed
  - fresh flag: the returned memory has never been read or written to before

I would appreciate if people could test these patches, especially on
strange, unusual or exotic hardware (I tested only on s390x)


GitLab:
  https://gitlab.com/imbrenda/kvm-unit-tests/-/tree/page_allocator_fixes
CI:
  https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/241819726


v1->v2
* have DONTZERO flag instead of a ZERO flag, this way there is no need
  for a default.
* drop the last patch, since there is no need for a default now.
* fixed a pre-existing bug that caused wrong allocations
* renamed alloc_pages_special to reserve_pages, to make it clear it is
  not a normal allocation. The function now returns 0 on success and -1
  on failure.
* added a NULL check in vm_free; freeing a NULL pointer is now a no-op.
* fix and improve some comments
* remove a spurious return 

Claudio Imbrenda (11):
  lib/x86: fix page.h to include the generic header
  lib/list.h: add list_add_tail
  lib/vmalloc: add some asserts and improvements
  lib/asm: Fix definitions of memory areas
  lib/alloc_page: fix and improve the page allocator
  lib/alloc.h: remove align_min from struct alloc_ops
  lib/alloc_page: Optimization to skip known empty freelists
  lib/alloc_page: rework metadata format
  lib/alloc: replace areas with more generic flags
  lib/alloc_page: Wire up FLAG_DONTZERO
  lib/alloc_page: Properly handle requests for fresh blocks

 lib/asm-generic/memory_areas.h |   9 +-
 lib/arm/asm/memory_areas.h     |  11 +-
 lib/arm64/asm/memory_areas.h   |  11 +-
 lib/powerpc/asm/memory_areas.h |  11 +-
 lib/ppc64/asm/memory_areas.h   |  11 +-
 lib/s390x/asm/memory_areas.h   |  13 +-
 lib/x86/asm/memory_areas.h     |  27 ++--
 lib/x86/asm/page.h             |   4 +-
 lib/alloc.h                    |   1 -
 lib/alloc_page.h               |  76 ++++++---
 lib/list.h                     |   9 ++
 lib/alloc_page.c               | 283 +++++++++++++++++++--------------
 lib/alloc_phys.c               |   9 +-
 lib/s390x/smp.c                |   2 +-
 lib/vmalloc.c                  |  23 +--
 15 files changed, 284 insertions(+), 216 deletions(-)

-- 
2.26.2

