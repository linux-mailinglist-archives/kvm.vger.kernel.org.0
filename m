Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2646D5F25
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbjDDLhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbjDDLhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0301E2D64
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:52 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349oxhr015598;
        Tue, 4 Apr 2023 11:36:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=dliiwjiuqk8xsvVveTTtKn4GmqHcf18lGFidSmTE+CE=;
 b=HaIunLfdFknHfiEZL7bovThJ4YPAFZ4rX4wy20qrjJqmSstp0NsWAQ7cj4zxekCXfJKD
 hrcVdeCQXpecdrLapNHL5TmW/mEvbU6Gi1VdNgIc5Ox9vtLGBQg5t0g+eEIlvyrOM6Kx
 dba/r4yrVmSvAhuAZTaUkbFC9ihR/xiZPfpGTnAlAASDTa3xqPHPQQl0WSyRqZ7WOlJS
 FF38P7QqPgu9AGT5BFwBgghPxLBzwJhyNXrugNBR64lXxYuwqnyVx7rlv5WUykt3u0yv
 naF4TZw+TdgcbYv27slovQ8TetHrclelCr5Y2jqodPE6s1iAx3QgJ+TQ5eJiqtzcDCFv gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg2eve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:49 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BSFlc031458;
        Tue, 4 Apr 2023 11:36:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg2euv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333Mejit004036;
        Tue, 4 Apr 2023 11:36:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2fs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BahPb17302202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCEB820040;
        Tue,  4 Apr 2023 11:36:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B40B2004B;
        Tue,  4 Apr 2023 11:36:43 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL v2 00/14] s390x: new maintainer, refactor linker scripts, tests for misalignments, execute-type instructions and vSIE epdx
Date:   Tue,  4 Apr 2023 13:36:25 +0200
Message-Id: <20230404113639.37544-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GtP36W5b85QbRx9atgXGcPZuRI0gsjvu
X-Proofpoint-GUID: oSzozZfeMLCZbeyZvZXOCW4K0QbMrMNz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and/or Thomas,

so, here's the second try of the first pull request from me :)

v2:
---
* pick up a new version of Nina's spec_ex series to fix clang compiler issue and
  missing barrier.

Changes in this pull request:

* Marc contributed a series with a few fixes. Most importantly, it generates
  linker scripts for s390x with the assembler, permitting the use of defines in
  linker scripts.
  It is worth noting that it also touches lib/linux/const.h to check for
  __ASSEMBLY__ and __ASSEMBLER__.
* Nina contributed quite a few tests for misalignments in various instructions.
  As well as tests for execute-type instructions. Note that a few of her tests
  will require recent QEMUs under TCG. Upstream fixes are available [1, 2].
* Thomas contributed a test for vSIE on s390x, where the g3 clock might
  sometimes we wrong after reboot. A kernel patch is required[3].
* And, finally, the patch where I get the honor to work as maintainer.

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/42

PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/827521196

PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git s390x-2023-03

[1] https://lists.gnu.org/archive/html/qemu-devel/2023-03/msg04860.html
[2] https://lists.gnu.org/archive/html/qemu-devel/2023-03/msg04896.html
[3] https://lore.kernel.org/kvm/20221123090833.292938-1-thuth@redhat.com/

The following changes since commit 5b5d27da2973b20ec29b18df4d749fb2190458af:

  memory: Skip tests for instructions that are absent (2023-04-03 18:44:24 +0200)

are available in the Git repository at:

  https://gitlab.com/Nico-Boehr/kvm-unit-tests.git s390x-2023-03

for you to fetch changes up to 215923b163742f167dd118664af638389e5ada59:

  s390x: sie: Test whether the epoch extension field is working as expected (2023-04-04 13:10:33 +0200)

----------------------------------------------------------------
Janosch Frank (1):
  MAINTAINERS: Add Nico as s390x Maintainer and make Thomas reviewer

Marc Hartmayer (7):
  .gitignore: ignore `s390x/comm.key` file
  s390x/Makefile: simplify `%.hdr` target rules
  s390x/Makefile: fix `*.gbin` target dependencies
  s390x/Makefile: refactor CPPFLAGS
  s390x: use preprocessor for linker script generation
  s390x: define a macro for the stack frame size
  lib/linux/const.h: test for `__ASSEMBLER__` as well

Nina Schoetterl-Glausch (5):
  s390x/spec_ex: Use PSW macro
  s390x/spec_ex: Add test introducing odd address into PSW
  s390x/spec_ex: Add test of EXECUTE with odd target address
  s390x: Add tests for execute-type instructions
  s390x: spec_ex: Add test for misaligned load

Thomas Huth (1):
  s390x: sie: Test whether the epoch extension field is working as
    expected

 MAINTAINERS                                 |   3 +-
 s390x/Makefile                              |  28 +--
 lib/linux/const.h                           |   2 +-
 lib/s390x/asm-offsets.c                     |   1 +
 s390x/cstart64.S                            |   2 +-
 s390x/{flat.lds => flat.lds.S}              |   4 +-
 s390x/macros.S                              |   4 +-
 s390x/snippets/asm/{flat.lds => flat.lds.S} |   0
 s390x/snippets/c/{flat.lds => flat.lds.S}   |   6 +-
 s390x/ex.c                                  | 188 ++++++++++++++++++++
 s390x/gs.c                                  |  38 ++--
 s390x/sie.c                                 |  28 +++
 s390x/spec_ex.c                             | 106 +++++++++--
 s390x/unittests.cfg                         |   3 +
 .gitignore                                  |   2 +
 .gitlab-ci.yml                              |   1 +
 16 files changed, 370 insertions(+), 46 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (93%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (88%)
 create mode 100644 s390x/ex.c

-- 
2.39.2

