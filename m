Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0274F1B2
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjGKOTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjGKOTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:19:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0630B10F0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:19:13 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BE8sIG025789;
        Tue, 11 Jul 2023 14:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=kFXxc93sOOpFcWpAveYJXHk2ls93KtmupstBT+NfbJ8=;
 b=A7pfbYvhzjluOR4lo9jHsdAuTSrNnaQqjq4cKbM/zM1noVbGlAKt33oMQj+4KQsun1oe
 Uc6bzzHOAUudUsppboKLLeGCJnp/qDMr8MkTg/6jsnPHma4IdtY3VaHTF9jPMXYy51Ka
 zqEkqccJMHfuzf0kjx7GRX+3ip0cHqas4YcCP48/yUZX1lDpIQ6NP9hqmUrCaNJw/Ww0
 0BVtC0c1U9y1i0o5xiXbKyzO4CIJDVFn2E9YmFm/NULqPsiYfWeeyMdY74qbrWwC2E46
 m2vVY8Vs+hnDSo+Wp+kUsqntR5vPqo2tgAYAInvaCUKsbRjkBWUZ8VCmtI8kKeoXfiuv /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrvxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:18:05 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE9DJp029211;
        Tue, 11 Jul 2023 14:16:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrvr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B3Thq7005550;
        Tue, 11 Jul 2023 14:16:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59ttx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEG9Vx53608802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3DBB20043;
        Tue, 11 Jul 2023 14:16:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60C4F20049;
        Tue, 11 Jul 2023 14:16:09 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:09 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 00/22] s390x: topology tests, SCLP fixes, UV host test improvements, PV test improvements and validity/IPL test and some small maintanence fixes 
Date:   Tue, 11 Jul 2023 16:15:33 +0200
Message-ID: <20230711141607.40742-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wKhEzKxkbirI5KZusJFypx-eIt4aURCg
X-Proofpoint-GUID: Pe4P8dlo9TibgcdlupXwq4NhCR7Iri0T
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and/or Thomas,

quite few tests have accumulated since the last pull request, so it's time for another one.

Changes in this pull request:

* Pierre contributed tests for his topology work. The QEMU related changes[1] aren't merged yet, so it's mostly skips right now. Since things seem to converge in QEMU and the kernel part[2] is merged, it makes sense to include this now in kvm-unit-tests.
* Pierre also contributed some fixes to the SCLP code when the size of the SCCV exceeds a page, e.g. when a certain number of vCPUs is exceeded. This also resolves an ugly loop of asserts() we can run into when SCLP fails early.
* Janosch contributed enhancements for the ultravisor host interface test, which fix some bugs
* Janosch also contributed more PV tests which cover certain vailidties the host can encounter when it tries to mess with the guest state, i.e. during IPL or SIE entry
* Finally, two small fixes from me fix compile with GCC 13 and a change in the runtime makes sure pv-host tests are only run when the respective tooling is available.

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/45

PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/927485818

PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git s390x-2023-07

[1] https://lore.kernel.org/kvm/20230425161456.21031-1-pmorel@linux.ibm.com/
[2] https://lore.kernel.org/kvm/20220701162559.158313-1-pmorel@linux.ibm.com/

---

The following changes since commit e7324a48acdf3776e9bd9d727e0c2319bc5bf356:

  powerpc/spapr_vpa: Add basic VPA tests (2023-07-03 15:15:45 +0200)

are available in the Git repository at:

  https://gitlab.com/Nico-Boehr/kvm-unit-tests.git s390x-2023-07

for you to fetch changes up to 6f33f0b7912953a2f8e6fde5a441dfef2d850cae:

  s390x: topology: Checking Configuration Topology Information (2023-07-11 13:13:36 +0200)

----------------------------------------------------------------
Janosch Frank (16):
      lib: s390x: sie: Fix sie_get_validity() no validity handling
      lib: s390x: uv: Introduce UV validity function
      lib: s390x: uv: Add intercept data check library function
      s390x: pv-diags: Drop snippet from snippet names
      lib: s390x: uv: Add pv host requirement check function
      s390x: pv: Add sie entry intercept and validity test
      s390x: pv: Add IPL reset tests
      s390x: pv-diags: Add the test to unittests.conf
      s390x: uv-host: Fix UV init test memory allocation
      s390x: uv-host: Check for sufficient amount of memory
      s390x: uv-host: Beautify code
      s390x: uv-host: Add cpu number check to test_init
      s390x: uv-host: Remove create guest variable storage prefix check
      s390x: uv-host: Properly handle config creation errors
      s390x: uv-host: Fence access checks when UV debug is enabled
      s390x: uv-host: Add the test to unittests.conf

Nico Boehr (2):
      lib: s390x: mmu: fix conflicting types for get_dat_entry
      runtime: don't run pv-host tests when gen-se-header is unavailable

Pierre Morel (4):
      s390x: sclp: treat system as single processor when read_info is NULL
      s390x: sclp: Implement extended-length-SCCB facility
      s390x: topology: Check the Perform Topology Function
      s390x: topology: Checking Configuration Topology Information

 lib/s390x/asm/uv.h                                 |   1 +
 lib/s390x/mmu.h                                    |   2 +-
 lib/s390x/pv_icptdata.h                            |  42 ++
 lib/s390x/sclp.c                                   |  23 +-
 lib/s390x/sclp.h                                   |   4 +-
 lib/s390x/sie.c                                    |   8 +-
 lib/s390x/snippet.h                                |   7 +
 lib/s390x/stsi.h                                   |  36 ++
 lib/s390x/uv.c                                     |  20 +
 lib/s390x/uv.h                                     |   8 +
 s390x/Makefile                                     |  14 +-
 s390x/pv-diags.c                                   |  70 ++-
 s390x/pv-icptcode.c                                | 376 +++++++++++++++
 s390x/pv-ipl.c                                     | 143 ++++++
 s390x/snippets/asm/icpt-loop.S                     |  15 +
 s390x/snippets/asm/loop.S                          |  13 +
 .../asm/{snippet-pv-diag-288.S => pv-diag-288.S}   |   0
 s390x/snippets/asm/pv-diag-308.S                   |  51 ++
 .../asm/{snippet-pv-diag-500.S => pv-diag-500.S}   |   0
 .../{snippet-pv-diag-yield.S => pv-diag-yield.S}   |   0
 s390x/snippets/asm/pv-icpt-112.S                   |  81 ++++
 s390x/snippets/asm/pv-icpt-vir-timing.S            |  21 +
 s390x/topology.c                                   | 514 +++++++++++++++++++++
 s390x/unittests.cfg                                |  29 ++
 s390x/uv-host.c                                    | 134 ++++--
 scripts/runtime.bash                               |   5 +
 26 files changed, 1533 insertions(+), 84 deletions(-)
 create mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/icpt-loop.S
 create mode 100644 s390x/snippets/asm/loop.S
 rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
 create mode 100644 s390x/snippets/asm/pv-diag-308.S
 rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)
 create mode 100644 s390x/snippets/asm/pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/pv-icpt-vir-timing.S
 create mode 100644 s390x/topology.c

-- 
2.41.0

