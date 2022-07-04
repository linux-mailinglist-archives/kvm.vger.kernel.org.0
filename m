Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4193A5654A6
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiGDMNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiGDMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:13:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4B930A;
        Mon,  4 Jul 2022 05:13:35 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264BL6BW021533;
        Mon, 4 Jul 2022 12:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QFADMFF8TmSskz4J2Jl1S1Jr4GBpt8dmzrjr/Zdt8Aw=;
 b=ZonLRGLHkvBMNzPWKfwE3ksVeWTSRlI6R7oAtQdnmaI7HHmmLBak6Z9cm8zZrr9MXTcw
 MItrQyWwCJhQRupIViSiVqgB7LGy4U2ACf6Lza0dBc/pA4uoHfFPUeaqcikyaZIeYIY4
 fSrS+o88CIAXXr3O76xl0QwK/6z1YicIJq3JhaT1/vnfm0yo2WK9MpiEdgfTIkDzwpdc
 jaeSKSv4h79NZcfaiARYr/BdeC0Vw1WjiP7jYCJP89LLxt35ldTK5M0RP8qgTWrZw5U7
 byvu6ceUOv8KBId943+onwoMvYo2jKKiopRCYR6Yk5as5si2i1DMKinfYaPvid4T8SeG Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y8ps1pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:34 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264C7E9w027356;
        Mon, 4 Jul 2022 12:13:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y8ps1p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264C5kln020019;
        Mon, 4 Jul 2022 12:13:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn92p4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264CCGhc23200174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 12:12:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C435A52054;
        Mon,  4 Jul 2022 12:13:28 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8FDC35204E;
        Mon,  4 Jul 2022 12:13:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] Add panic test support
Date:   Mon,  4 Jul 2022 14:13:24 +0200
Message-Id: <20220704121328.721841-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wlmq0LNTPxjZ72FaJye6mu-4aLJIshU5
X-Proofpoint-GUID: KNsnt1zdUNJy98r4L3mibnJW-VEX1n9y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=750
 clxscore=1015 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* fix spelling mistakes/long lines (thanks Thomas)
* quoting improvments (thanks Thomas)
* smaller timeout for tests (thanks Thomas and Janis)
* move function and defines for cpu timer to time.h (thanks Janosch)
* fence tests for non-QEMU/KVM (thanks Janosch)

QEMU suports a guest state "guest-panicked" which indicates something in
the guest went wrong, for example on s390x, when an external interrupt
loop was triggered.

Since the guest does not continue to run when it is in the
guest-panicked state, it is currently impossible to write panicking
tests in kvm-unit-tests. Support from the runtime is needed to check
that the guest enters the guest-panicked state.

This series adds the required support to the runtime together with two
tests for s390x which cause guest panics.

Nico Boehr (4):
  runtime: add support for panic tests
  lib: s390x: add CPU timer functions to time.h
  s390x: add extint loop test
  s390x: add pgm spec interrupt loop test

 lib/s390x/asm/time.h      | 16 ++++++++++-
 s390x/Makefile            |  2 ++
 s390x/panic-loop-extint.c | 60 +++++++++++++++++++++++++++++++++++++++
 s390x/panic-loop-pgm.c    | 53 ++++++++++++++++++++++++++++++++++
 s390x/run                 |  2 +-
 s390x/unittests.cfg       | 12 ++++++++
 scripts/arch-run.bash     | 49 ++++++++++++++++++++++++++++++++
 scripts/runtime.bash      |  3 ++
 8 files changed, 195 insertions(+), 2 deletions(-)
 create mode 100644 s390x/panic-loop-extint.c
 create mode 100644 s390x/panic-loop-pgm.c

-- 
2.36.1

