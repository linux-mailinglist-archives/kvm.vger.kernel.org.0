Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE959D8A1
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243074AbiHWJ5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 05:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbiHWJxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 05:53:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC199F0F1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 01:46:16 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N7uaaW018212
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3iH96E4PurBkYcWYIuQId67KgRicp67zdFeVRCqJ7g4=;
 b=shQJ/Ng/SeX58mqGH15vdfu5DIlhsicGCgLKDbnu/SViZOff9FC9gSaBRUyds2Dd/Q6s
 XIxurKKJnqWShsrEHen6+pdRwXaZMwC3SD51gey393cHPQPENIsWy9cgZrlRMqNUYtHC
 S99rvh8V8RT/F/dWCeJ68rV4ccnFX9MqQOqVOfc+rkdcQngNv1LGVuiZplsXlz+0dZFl
 X6qa5E+phd0LROzka0BjKloZEl++44KFNS43G4LzDF6/xZQhqDrCEMCfliFGOvypKTUl
 QvBACvl0Z5mrNTXmcyRFh1uqkp3hDKgphSnDmoSYYebhWAZ7t/NGbRbKm0TLC2v7ADY9 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4txv1gcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:31 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N7vBD2024392
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4txv1gbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N8KxPK017848;
        Tue, 23 Aug 2022 08:45:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3j2pvj3ggd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N8jkLF36569350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 08:45:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3EB3AE051;
        Tue, 23 Aug 2022 08:45:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92E22AE04D;
        Tue, 23 Aug 2022 08:45:25 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 08:45:25 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/4] Add panic test support
Date:   Tue, 23 Aug 2022 10:45:21 +0200
Message-Id: <20220823084525.52365-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ottNbG-dFx9ammB8M9UgYks1QYL_dnoY
X-Proofpoint-GUID: WG8TR7skfFeWSs-x48gydO6PexPhby8a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=822
 suspectscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4->v5:
---
* use psw_mask_set_bits instead of load_psw_mask/extract_psw_mask (thanks
  Claudio)
* add missing space in pgm int (thanks Janosch)
* set bit 12 to cause a pgm int (thanks Janosch)

v3->v4:
---
* avoid backslash at line end in scripts wherever possible (thanks Claudio)
* remove selfmade interrupt handlers and use kvm-unit-test default
  handers. This simplifies the code quite a bit.
* fix cpu timer and clock comparator confusion

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
  lib/s390x: add CPU timer related defines and functions
  s390x: add extint loop test
  s390x: add pgm spec interrupt loop test

 lib/s390x/asm/arch_def.h  |  1 +
 lib/s390x/asm/time.h      | 17 ++++++++++-
 s390x/Makefile            |  2 ++
 s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
 s390x/panic-loop-pgm.c    | 38 +++++++++++++++++++++++++
 s390x/run                 |  2 +-
 s390x/unittests.cfg       | 12 ++++++++
 scripts/arch-run.bash     | 49 ++++++++++++++++++++++++++++++++
 scripts/runtime.bash      |  3 ++
 9 files changed, 181 insertions(+), 2 deletions(-)
 create mode 100644 s390x/panic-loop-extint.c
 create mode 100644 s390x/panic-loop-pgm.c

-- 
2.36.1

