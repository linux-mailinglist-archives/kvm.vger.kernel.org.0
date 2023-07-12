Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B331750678
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 13:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjGLLmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 07:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbjGLLm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 07:42:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33B31FF6;
        Wed, 12 Jul 2023 04:42:05 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBaw54024503;
        Wed, 12 Jul 2023 11:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/4GtRaBwUSOUQD48Bug6GO3gNGxWDPrKqShbK1zQQDE=;
 b=eMNoTigLQla5FyloanZD8l2OrLv0ZChZ+A2RKB+ZsyoIpyg+GyQUVMOTtRAFwgwyfpoV
 2k9oAzM8JxpZDIpTUTJCHzOwirA336Jn+WFmN6R4eVjtPFmDYSnvFVe7/AE1cx1fUPB/
 BTq4Z8bOM0XUF2YYHqQjI8dfaOa+xqhqwBi/XW4sHaXAUbknxwjEpBiXTq8p65U94Tq8
 Sfok+ssJQ0RMeO02cDjkh70J38pbddySvdwSu8CTF5GS1PqIRPD94Z90vZ5hJTC6uqZE
 P1FmoDExTPOfQoViIzHGIxTmOAszzwbsfYFq/z6lk5mKTIi3+SeH8XHCD0HCc1fDJOXQ gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsuaugau1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 11:41:57 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CBbZ4h029890;
        Wed, 12 Jul 2023 11:41:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsuaugarf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 11:41:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CA5Rsa002837;
        Wed, 12 Jul 2023 11:41:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rpye5hwg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 11:41:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CBfnEp57606446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:41:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0C3420043;
        Wed, 12 Jul 2023 11:41:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF6220040;
        Wed, 12 Jul 2023 11:41:49 +0000 (GMT)
Received: from a83lp41.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 11:41:49 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 0/6] s390x: Add support for running guests without MSO/MSL
Date:   Wed, 12 Jul 2023 13:41:43 +0200
Message-Id: <20230712114149.1291580-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XaoCWlvKE0vWx4YrYrr3Wp-Pk1YdiFnC
X-Proofpoint-GUID: epOZp8XKgp5dUyOEASef1WrQKlzIFYMK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=911 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v5:
---
* fix a big oopsie in irq_set_dat_mode() which caused parts of lowcore being
  overwritten (thanks Claudio)

v4:
---
- add static assert for PSW bitfield (Janosch, Claudio)
- remove unneeded includes (Janosch)
- move variable decls to function start (Janosch)
- remove unneeded imports (Janosch)
- lowerocase hex (Janosch)
- remove unneeded attr (Janosch)
- tyop :-) fixes (Janosch)

v3:
---
* introduce bitfield for the PSW to make handling less clumsy
* some variable renames (Claudio)
* remove unneeded barriers (Claudio)
* remove rebase leftover sie_had_pgm_int (Claudio)
* move read_pgm_int_code to header (Claudio)
* squash include fix commit into the one causing the issue (Claudio)

v2:
---
* add function to change DAT/AS mode for all irq handlers (Janosch, Claudio)
* instead of a new flag in PROG0C, check the pgm int code in lowcore (Janosch)
* fix indents, comments (Nina)

Right now, all SIE tests in kvm-unit-tests (i.e. where kvm-unit-test is the
hypervisor) run using MSO/MSL.

This is convenient, because it's simple. But it also comes with
disadvantages, for example some features are unavailabe with MSO/MSL.

This series adds support for running guests without MSO/MSL with dedicated
guest page tables for the GPA->HPA translation.

Since SIE implicitly uses the primary space mode for the guest, the host
can't run in the primary space mode, too. To avoid moving all tests to the
home space mode, only switch to home space mode when it is actually needed.

This series also comes with various bugfixes that were caught while
develoing this.

Nico Boehr (6):
  lib: s390x: introduce bitfield for PSW mask
  s390x: add function to set DAT mode for all interrupts
  s390x: sie: switch to home space mode before entering SIE
  s390x: lib: don't forward PSW when handling exception in SIE
  s390x: lib: sie: don't reenter SIE on pgm int
  s390x: add a test for SIE without MSO/MSL

 lib/s390x/asm/arch_def.h   |  27 ++++++++-
 lib/s390x/asm/interrupt.h  |  18 ++++++
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/interrupt.c      |  37 ++++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  22 ++++++-
 s390x/Makefile             |   2 +
 s390x/selftest.c           |  40 +++++++++++++
 s390x/sie-dat.c            | 115 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 +++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 11 files changed, 324 insertions(+), 4 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

-- 
2.40.1

