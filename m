Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EFE57D9E7
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiGVGAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 02:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiGVGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 02:00:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A871440BEA
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 23:00:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M5mpHZ002213
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ssOHIs8kE1BTtjg+B/BudwerE3GAQSPiUiZnx3QjyPo=;
 b=jdfsUQ3rqdcUhi6cMk5AIisq3t9Ai229mBQoN3RCaLzqffHTKyjIFi54rqjMMJTQ9ZOf
 bmbXte0uS/G+aRDPKSe73UE+LawJ3Bkb81gfvNXVYYFmVe97l3VGJ5kcO8hbSwvesfD9
 FYyI+dNdeABFQN4kAgPI6Z+TWpN/P/h95UJZKs/1iknzr2WCrAXYf7L/O5CKE/ykYAMy
 cQeIjHGJJ9GyAu3PuLeB2VcJTr/DvL1LyojQXMxJ6L08h0V2S8cx/RXT+X7dkYoaqIr+
 p8PjW1x9IrCCy5/E/gmZCRoNmNaXmIAp9xTMfysmbdk7Ikk0cMFGjPcldmnQmJS+jjl3 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp2y87ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M5nZYm003144
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp2y87m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M5p9vc018217;
        Fri, 22 Jul 2022 06:00:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj7v4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M60ihX19464548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:00:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4052652051;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0CB925204E;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/4] Add panic test support
Date:   Fri, 22 Jul 2022 08:00:39 +0200
Message-Id: <20220722060043.733796-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LvDqxAwuTWc-MsIdVCfVadtRuem8BgDh
X-Proofpoint-GUID: weKoO-STI6Nl2NeL7b5tLLntiPWHj5Ve
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=796 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
---
* rename TIMING_S390_SHIFT_US->S390_CLOCK_SHIFT_US (thanks Claudio)
* rename cpu_timer_set -> cpu_timer_set_ms (thanks Claudio)

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

 lib/s390x/asm/time.h      | 17 ++++++++++-
 s390x/Makefile            |  2 ++
 s390x/panic-loop-extint.c | 60 +++++++++++++++++++++++++++++++++++++++
 s390x/panic-loop-pgm.c    | 53 ++++++++++++++++++++++++++++++++++
 s390x/run                 |  2 +-
 s390x/unittests.cfg       | 12 ++++++++
 scripts/arch-run.bash     | 49 ++++++++++++++++++++++++++++++++
 scripts/runtime.bash      |  3 ++
 8 files changed, 196 insertions(+), 2 deletions(-)
 create mode 100644 s390x/panic-loop-extint.c
 create mode 100644 s390x/panic-loop-pgm.c

-- 
2.36.1

