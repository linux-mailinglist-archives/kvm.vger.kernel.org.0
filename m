Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4BB704EA9
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbjEPNFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjEPNF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:05:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8207EE6;
        Tue, 16 May 2023 06:05:14 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GCcecL014930;
        Tue, 16 May 2023 13:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=InV0wzE/hmnvNbld4gJlyZ/LP3jJNfjJEPl1q236sx4=;
 b=QGBKBq0FhaDQnvJTkcIZ9wbHFfcrAtTQL1M6OFTjqekcxk02kBBtW8JyMnRJSL9mXE5w
 ZnyEevoP7kR6Ki+5tTlbJsrpMjSaZmKOzH52JIsuxpG6g3/PEgssdxDuRc1kjNN0ULzM
 uyfphXl/4CX7DtfbjyQ/WS3CRDS/LMk81CcrJ9nv0R7Il8tWvSVyaOTbEeskrwywlH8N
 gTczDY4z3w9vavQw7gUUHA5lh2N4R+NkIA9jf1TtfTGNT5RvXMG7/xMblziM04QpADxb
 XezRRx6gi63xSBrW2xzqDao6Ec7lru5mpUGG4kjG8gjzUzn//RT5X7x+6+GNzJSqJ8rx hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63weh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:10 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GD4dPR022094;
        Tue, 16 May 2023 13:05:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63w6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G67uQs005223;
        Tue, 16 May 2023 13:05:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264sn3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:04:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GD4uds14418566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 13:04:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8380D20043;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C87720040;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/6] s390x: Add support for running guests without MSO/MSL
Date:   Tue, 16 May 2023 15:04:50 +0200
Message-Id: <20230516130456.256205-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dKYclYBw29ye41LYAa9p1R-pEaGDVUql
X-Proofpoint-ORIG-GUID: K0m8TdrN1Hexc-yBktm0T9DW4fFl0h1t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_06,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=538
 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
  s390x: add function to set DAT mode for all interrupts
  s390x: sie: switch to home space mode before entering SIE
  s390x: lib: don't forward PSW when handling exception in SIE
  s390x: fix compile of interrupt.c
  s390x: lib: sie: don't reenter SIE on pgm int
  s390x: add a test for SIE without MSO/MSL

 lib/s390x/asm/arch_def.h   |   1 +
 lib/s390x/asm/interrupt.h  |   5 ++
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/interrupt.c      |  54 +++++++++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  22 ++++++-
 s390x/Makefile             |   2 +
 s390x/sie-dat.c            | 120 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 10 files changed, 268 insertions(+), 3 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

-- 
2.39.1

