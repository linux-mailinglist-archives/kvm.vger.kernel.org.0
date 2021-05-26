Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57A391915
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhEZNo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:44:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233416AbhEZNoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:44:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QDYZjT151448;
        Wed, 26 May 2021 09:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=U/QEp8xBUK5dEWKSfdh7YiyItfNKZ2h1LqKavKSldAo=;
 b=FbEdRQCIlslG4zaR0ivWjLXi8ueA4gjO1EnallEWKizsiCOP5tLdsPhxgAH4qI7+UWDl
 88MBcH+/W+Yz4caUViT/rDdlVxUR80iUCZqK83iyiJi3s9PdxX/qdZfc5G8RYDCMtRkL
 d73mGjdZk1IRce8hrBzDKuq1eVxEI5u6PJnKiITSiG1PyzUPVg01uWFDi8u0uDKR6c1m
 K6tg6/BJsaOjdGq/vr2mP5Zy6hZ6Loiy8PL5//24dSzoFe4hfGJynS7S0pi6WrLAB23M
 HnoX9QZvACe56sRGQmmjA8Mr8QpaqKq4o+URcPb1pOFXrrKn9qF753tWjUvtdeUCfljp Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sqangan1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:51 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QDYdVZ151991;
        Wed, 26 May 2021 09:42:51 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sqangaky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:51 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QDc4hZ022584;
        Wed, 26 May 2021 13:42:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 38s1ht0akc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 13:42:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QDgGWb16449828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 13:42:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10F2942049;
        Wed, 26 May 2021 13:42:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B35B742042;
        Wed, 26 May 2021 13:42:45 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 13:42:45 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/7] s390: Add support for large pages
Date:   Wed, 26 May 2021 15:42:38 +0200
Message-Id: <20210526134245.138906-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4RnMfF1eHc8x0tx9bvtodUovmde5Ieme
X-Proofpoint-ORIG-GUID: W6tHegpxs03rIB-aw9MSdE-UKCIAL0pd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_08:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105260091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for large (1M) and huge (2G) pages.

Add a simple testcase for EDAT1 and EDAT2.

v3->v4
* replace macros in patch 5 with a union representing TEID fields
* clear the teid in expect_pgm_int and clear_pgm_int
* update testcase to use expect_pgm_int, remove expect_dat_fault
* update testcase to use teid union

v2->v3
* Add proper macros for control register bits
* Improved patch titles and descriptions
* Moved definition of TEID bits to library
* Rebased on the lastest upstream branch

v1->v2

* split patch 2 -> new patch 2 and new patch 3
* patch 2: fixes pgtable.h, also fixes wrong usage of REGION_TABLE_LENGTH
  instead of SEGMENT_TABLE_LENGTH
* patch 3: introduces new macros and functions for large pages
* patch 4: remove erroneous double call to pte_alloc in get_pte
* patch 4: added comment in mmu.c to bridge the s390x architecural names
  with the Linux ones used in the kvm-unit-tests
* patch 5: added and fixed lots of comments to explain what's going on
* patch 5: set FC for region 3 after writing the canary, like for segments
* patch 5: use uintptr_t instead of intptr_t for set_prefix
* patch 5: introduce new macro PGD_PAGE_SHIFT instead of using magic value 41
* patch 5: use VIRT(0) instead of mem to make it more clear what we are
  doing, even though VIRT(0) expands to mem

Claudio Imbrenda (7):
  s390x: lib: add and use macros for control register bits
  libcflat: add SZ_1M and SZ_2G
  s390x: lib: fix pgtable.h
  s390x: lib: Add idte and other huge pages functions/macros
  s390x: lib: add teid union and clear teid from lowcore
  s390x: mmu: add support for large pages
  s390x: edat test

 s390x/Makefile            |   1 +
 lib/s390x/asm/arch_def.h  |  12 ++
 lib/s390x/asm/float.h     |   4 +-
 lib/s390x/asm/interrupt.h |  26 +++-
 lib/s390x/asm/pgtable.h   |  44 +++++-
 lib/libcflat.h            |   2 +
 lib/s390x/mmu.h           |  73 +++++++++-
 lib/s390x/interrupt.c     |   2 +
 lib/s390x/mmu.c           | 260 ++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.c          |   4 +-
 s390x/diag288.c           |   2 +-
 s390x/edat.c              | 274 ++++++++++++++++++++++++++++++++++++++
 s390x/gs.c                |   2 +-
 s390x/iep.c               |   4 +-
 s390x/skrf.c              |   2 +-
 s390x/smp.c               |   8 +-
 s390x/vector.c            |   2 +-
 s390x/unittests.cfg       |   3 +
 18 files changed, 676 insertions(+), 49 deletions(-)
 create mode 100644 s390x/edat.c

-- 
2.31.1

