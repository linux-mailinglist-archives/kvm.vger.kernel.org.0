Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A217193E6
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjFAHHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjFAHHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:07:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B07186;
        Thu,  1 Jun 2023 00:07:02 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3516nIop009677;
        Thu, 1 Jun 2023 07:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FOgfQV2T5DZ/XwNzZqT50g18EsiEg3gQ0l9v0k5Nwqs=;
 b=Va59x+9nY5xVDTgBoA4KA7mhs44kirQ3R9CMj5nVM0vofnX1xW03SEdAlITpRi0Lw1lj
 ZWNucRD/xoKbQvS8PMI7Cz/zI3Q8q5mLLuqW7pDbFJeS6QPWUXpZfwUDpMGf1taPbNs2
 yWi96dUs/1VDLDLS0/XlKbKCK5HttBLPWxNwnO099z4XfW0UzRQr0TcrFbSGnTKfPSwI
 IVhBLnDiy0nRpmOQ/7sK+AjlTw0SfJJy7fIc5oeF6pqPZjlC4Odh//aSpPAwpUHQaWUC
 WDyz+eZfU/gzKterFccny22AL3lsYbpcWwAqZnSi68U8pbAqTngdNz1SGK19W7dJettv hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpdb0d23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:07:01 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35174aUj026305;
        Thu, 1 Jun 2023 07:04:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpdb0bva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:04:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3513rYab009404;
        Thu, 1 Jun 2023 07:02:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g52cem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351723G017892018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 07:02:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD132004B;
        Thu,  1 Jun 2023 07:02:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C78EC20040;
        Thu,  1 Jun 2023 07:02:02 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 07:02:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/6] s390x: Add support for running guests without MSO/MSL
Date:   Thu,  1 Jun 2023 09:01:56 +0200
Message-Id: <20230601070202.152094-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mlHjGSBwri3pEIUdviL8gDlLi96cl-ua
X-Proofpoint-GUID: E2PKKyldjnIlTVLeUyqDhYE5fNmuZ8Sl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=562 mlxscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 lib/s390x/asm/arch_def.h   |  26 +++++++-
 lib/s390x/asm/interrupt.h  |  18 ++++++
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/interrupt.c      |  36 +++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  22 ++++++-
 s390x/Makefile             |   2 +
 s390x/selftest.c           |  40 +++++++++++++
 s390x/sie-dat.c            | 120 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 11 files changed, 327 insertions(+), 4 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

-- 
2.39.1

