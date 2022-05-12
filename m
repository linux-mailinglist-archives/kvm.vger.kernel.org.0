Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D52852490D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352020AbiELJfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352008AbiELJff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1483D69B6B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:34 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C8t347011306
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=V/hfNGldDCXBHSzdOPEHOjDeJbejidS3NRWq7ksWb2U=;
 b=e0jfpgJd5khmMycAn+opROJocJx/GHQtafgTS2VHbwjzD4QYji1cEVJsRSnkZ6k9pPL9
 FBKmneX+MuewgHql4IsNLUZsFjzBHN8fMbrwm7TmlQuvxPc1S85/tYbvMXniq2ZvHG+2
 fpdkxp4LXrWn5OedOQsr1qLlYRpzko9C1If8eOrTgW+kzY+5IPRmoFjRIzPuZV0L4laK
 07lfIVYugStJsicsLdwA4vqr7cl04GVh5Jg3CR0VCgWBmh82uZjxHSNw+LYeDeRgZ9Qz
 25B70U7nuONNxztspmFsYgtEhD70yVkWkmzZ/o1DnsAPM+ISg45OORnGxEI7ywTFDenO lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y538wvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:33 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9MFwO008649
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y538wv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XRmw002113;
        Thu, 12 May 2022 09:35:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8w8x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9LoOB50594220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:21:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A0E11C052;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48EFC11C050;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/28] storage keys, attestation, migration tests
Date:   Thu, 12 May 2022 11:34:55 +0200
Message-Id: <20220512093523.36132-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LNbkKihR_bU8TrASqDuJgZiR6_AT3Yun
X-Proofpoint-ORIG-GUID: eE07ks_L_9Ikz_nm7zN6vU612oOKj7dH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* improved host detection
* overall cleanups
* storage key tests
* some migration tests
* attestation UV interface

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/30

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/537301867

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-05

Janis Schoetterl-Glausch (3):
  s390x: Give name to return value of tprot()
  s390x: Test effect of storage keys on some instructions
  Disable s390x skey test in GitLab CI

Janosch Frank (10):
  lib: s390x: hardware: Add host_is_qemu() function
  s390x: css: Skip if we're not run by qemu
  s390x: diag308: Only test subcode 2 under QEMU
  s390x: pfmf: Initialize pfmf_r1 union on declaration
  s390x: snippets: asm: Add license and copyright headers
  s390x: pv-diags: Cleanup includes
  s390x: css: Cleanup includes
  s390x: iep: Cleanup includes
  s390x: mvpg: Cleanup includes
  s390x: uv-host: Fix pgm tests

Nico Boehr (9):
  s390x: gs: move to new header file
  s390x: add test for SIGP STORE_ADTL_STATUS order
  s390x: epsw: fix report_pop_prefix() when running under non-QEMU
  s390x: tprot: use lib include for mmu.h
  s390x: smp: make stop stopped cpu look the same as the running case
  lib: s390x: add support for SCLP console read
  s390x: add support for migration tests
  s390x: don't run migration tests under PV
  s390x: add basic migration test

Steffen Eiden (6):
  s390x: uv-host: Add invalid command attestation check
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: Remove double report_prefix_pop
  s390x: uv-guest: add share bit test
  s390x: Add attestation tests

 scripts/s390x/func.bash                    |   2 +-
 s390x/run                                  |   7 +-
 s390x/Makefile                             |   4 +
 lib/s390x/asm/arch_def.h                   |  31 +-
 lib/s390x/asm/uv.h                         |  28 +-
 lib/s390x/asm/vector.h                     |  16 +
 lib/s390x/gs.h                             |  69 ++++
 lib/s390x/hardware.h                       |   5 +
 lib/s390x/sclp.h                           |   8 +
 lib/s390x/uv.h                             |   1 +
 lib/s390x/sclp-console.c                   |  79 +++-
 lib/s390x/sclp.c                           |   6 +-
 lib/s390x/uv.c                             |   8 +
 s390x/snippets/asm/snippet-pv-diag-288.S   |   9 +
 s390x/snippets/asm/snippet-pv-diag-500.S   |   9 +
 s390x/snippets/asm/snippet-pv-diag-yield.S |   9 +
 s390x/adtl-status.c                        | 408 +++++++++++++++++++++
 s390x/css.c                                |  18 +-
 s390x/diag308.c                            |  18 +-
 s390x/epsw.c                               |   4 +-
 s390x/gs.c                                 |  54 +--
 s390x/iep.c                                |   3 +-
 s390x/migration.c                          | 198 ++++++++++
 s390x/mvpg.c                               |   3 -
 s390x/pfmf.c                               |  39 +-
 s390x/pv-attest.c                          | 225 ++++++++++++
 s390x/pv-diags.c                           |  17 +-
 s390x/skey.c                               | 249 +++++++++++++
 s390x/smp.c                                |   5 +-
 s390x/tprot.c                              |  26 +-
 s390x/uv-guest.c                           |  51 ++-
 s390x/uv-host.c                            |   3 +-
 s390x/unittests.cfg                        |  30 ++
 .gitlab-ci.yml                             |   2 +-
 34 files changed, 1483 insertions(+), 161 deletions(-)
 create mode 100644 lib/s390x/asm/vector.h
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/adtl-status.c
 create mode 100644 s390x/migration.c
 create mode 100644 s390x/pv-attest.c

-- 
2.36.1

