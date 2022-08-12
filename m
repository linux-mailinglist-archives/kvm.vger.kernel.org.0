Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4336590BEA
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 08:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiHLGWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 02:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLGV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 02:21:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9705690C6A
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 23:21:58 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C6DIk7030802
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GXr+OQYzb7C72YM1d0/56Ch66g1duYfVfAork19FSa0=;
 b=SZ6qR2DS8vlzUYwCprQUNVlJUMEUK0rclAp4rubbHowloIAr3XAgCkANBQc8JxfzHTsK
 mVLK+30ZpLoYPXE4FHMC8Cjx5KLBJgGvSFqfafyGu0DWInwvTdsIDxbFDktWqrBZp1V6
 oNNi59k04EhsDEE57Fz/LKbT9wZqr3mpW/5T/eJzQBC9S8LP/jaNb7PYw2sR35Lg41da
 IHwLPoY3uHtwGF/kg05efzAJjXyCyz2pcrkZBCcZJOb+4WLd1p9PrM18gf6zpPKgUHzC
 VXx4TON4uY92dIPPKL/76kuvuRIxl88sNGQZ2bPdeqCfHf9OuHwvaKLrUBTe208EK94X 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwhdar6hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:21:58 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C6FDkC003033
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:21:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwhdar6h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 06:21:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C6A9Kw014710;
        Fri, 12 Aug 2022 06:21:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hw3wfrnp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 06:21:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C6Lq0233292592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 06:21:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04D6842042;
        Fri, 12 Aug 2022 06:21:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C60104203F;
        Fri, 12 Aug 2022 06:21:51 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 06:21:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/4] Add panic test support
Date:   Fri, 12 Aug 2022 08:21:47 +0200
Message-Id: <20220812062151.1980937-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: stf1HYcyzjZVrfIaiEkjG12Sz1fss337
X-Proofpoint-GUID: UyU9NDLZi2uOIO-Fmvxn5Ne7QhhMjBqp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_04,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=867
 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120016
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
  s390x: add CPU timer related defines and functions
  s390x: add extint loop test
  s390x: add pgm spec interrupt loop test

 lib/s390x/asm/arch_def.h  |  1 +
 lib/s390x/asm/time.h      | 17 ++++++++++-
 s390x/Makefile            |  2 ++
 s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
 s390x/panic-loop-pgm.c    | 39 ++++++++++++++++++++++++++
 s390x/run                 |  2 +-
 s390x/unittests.cfg       | 12 ++++++++
 scripts/arch-run.bash     | 49 ++++++++++++++++++++++++++++++++
 scripts/runtime.bash      |  3 ++
 9 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 s390x/panic-loop-extint.c
 create mode 100644 s390x/panic-loop-pgm.c

-- 
2.36.1

