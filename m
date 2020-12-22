Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11FD2DC787
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgLPUNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728533AbgLPUNF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:05 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK32qD080471
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hHo7bpbeDEZcxPJM7AREYpbKK7jPpoDEl9OMqA2Unjo=;
 b=djFLrdmSxg5sTOcNwYrhAxTah9vmiefmijJwsWPPKs+O7gv1GJJcusTXc9NzdwnZMisO
 nLOHzMliAPmpgONQXGxOnk3QSv+gBQFM8buuxGIfdjSY6XKZM60wwvZFOL83ZRcnepn5
 8yCnNbvDdHSVmaNfGTuJXE0jNK/yQZDq9gNvTeoAIAgDKcMJ0TZh7aN5tg8G5V5bn0UW
 0Vxtz4ki52Nijs/ENLjVVbdMN5mtvWyyRJsyvFnDsyUDjBslWDpTeyljTYOm7EETBJXG
 LSxp4TA5JSfMoNo3ajks75k6eXzWYuI3z9Nfvy399Avu5hUKGNjjNCVqs8fzq5rorZr9 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fqbqtvs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:24 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK35Zg080708
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:24 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fqbqtvrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:24 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK7DJl016243;
        Wed, 16 Dec 2020 20:12:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8adtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCK0734013564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E379242054;
        Wed, 16 Dec 2020 20:12:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A6904204B;
        Wed, 16 Dec 2020 20:12:19 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page allocator
Date:   Wed, 16 Dec 2020 21:11:48 +0100
Message-Id: <20201216201200.255172-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160120
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
  - zero flag: the allocation will be zeroed
  - fresh flag: the returned memory has never been read or written to before
* default flags: it's possible to specify which flags should be enabled
  automatically at each allocation; by default the zero flag is set.


I would appreciate if people could test these patches, especially on
strange, unusual or exotic hardware (I tested only on s390x)


GitLab:
  https://gitlab.com/imbrenda/kvm-unit-tests/-/tree/page_allocator_fixes
CI:
  https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/229689192


Claudio Imbrenda (12):
  lib/x86: fix page.h to include the generic header
  lib/list.h: add list_add_tail
  lib/vmalloc: add some asserts and improvements
  lib/asm: Fix definitions of memory areas
  lib/alloc_page: fix and improve the page allocator
  lib/alloc.h: remove align_min from struct alloc_ops
  lib/alloc_page: Optimization to skip known empty freelists
  lib/alloc_page: rework metadata format
  lib/alloc: replace areas with more generic flags
  lib/alloc_page: Wire up ZERO_FLAG
  lib/alloc_page: Properly handle requests for fresh blocks
  lib/alloc_page: default flags and zero pages by default

 lib/asm-generic/memory_areas.h |   9 +-
 lib/arm/asm/memory_areas.h     |  11 +-
 lib/arm64/asm/memory_areas.h   |  11 +-
 lib/powerpc/asm/memory_areas.h |  11 +-
 lib/ppc64/asm/memory_areas.h   |  11 +-
 lib/s390x/asm/memory_areas.h   |  13 +-
 lib/x86/asm/memory_areas.h     |  27 +--
 lib/x86/asm/page.h             |   4 +-
 lib/alloc.h                    |   1 -
 lib/alloc_page.h               |  66 ++++++--
 lib/list.h                     |   9 +
 lib/alloc_page.c               | 291 ++++++++++++++++++++-------------
 lib/alloc_phys.c               |   9 +-
 lib/s390x/smp.c                |   2 +-
 lib/vmalloc.c                  |  21 +--
 15 files changed, 286 insertions(+), 210 deletions(-)

-- 
2.26.2

