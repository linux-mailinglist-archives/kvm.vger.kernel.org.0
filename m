Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F674E818
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjGKHfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 03:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjGKHf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 03:35:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E9D133;
        Tue, 11 Jul 2023 00:35:27 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7AGw4007486;
        Tue, 11 Jul 2023 07:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8x3L47iFbmJnO4aeJ59CdAZ79QG8MfO5wljgjhjeYN4=;
 b=Uxspd0+WppfkLnEdvZKM+ZlPyfknZv+c47HmYg3KV1sZ64zFWyp6n8/jIdiYC2FzTfZW
 LoonNdPqhDmIfN1IT7FdvK+sz66smbxNjUkQgdzkP5NWw67HUvrjcSnJbXZh/ZN7wPto
 rOb4IM5W6n2D+VdR0t/yA+p4iO8pLk3OSNoWMZrpPVlCsv/d1NyEPwQ5Ei+wLMJrUEj7
 I72VvpGalQPT0eZU95mf7Wk5R6ed03XuOzJmxz233FvY+tyRd7yWPvkavR4F4apLpRqp
 kdwJNXSOVlF/ONay1gvZNxZFGvUE03eQbtZbfhqmDWiKbXujltGZarHpojzRpS2LNE1X dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs28ugvnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:25 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36B7BR0X011002;
        Tue, 11 Jul 2023 07:35:23 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs28ugvg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B1JqSt008095;
        Tue, 11 Jul 2023 07:35:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rpye597we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36B7ZFox38404386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 07:35:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17D3D2004E;
        Tue, 11 Jul 2023 07:35:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE1282004F;
        Tue, 11 Jul 2023 07:35:14 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 07:35:14 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/6] s390x: Add support for running guests without MSO/MSL
Date:   Tue, 11 Jul 2023 09:35:08 +0200
Message-Id: <20230711073514.413364-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SzYtUcP3JFuOGnLzWrIlI1ecOEuZoLwn
X-Proofpoint-ORIG-GUID: 3fCGWn5UPjqWsoe4Ex-zc1EENMLBEsoQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=900 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 lib/s390x/interrupt.c      |  36 ++++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  22 ++++++-
 s390x/Makefile             |   2 +
 s390x/selftest.c           |  40 +++++++++++++
 s390x/sie-dat.c            | 115 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 +++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 11 files changed, 323 insertions(+), 4 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

-- 
2.39.1

