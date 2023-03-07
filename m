Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544536AD9F1
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 10:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjCGJLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 04:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCGJLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 04:11:17 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE91252906
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 01:11:09 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3278SXJR011056
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lQ9ClxPgWnmVuGBmdpOZHjyCVHiIgsCgfVsYRjiCdgM=;
 b=MG41GCG2Z215p07KPqu0qQoMcibC/vkykTK8yr7M8ZfYAaRYzWQA+rPv9HDsrJ4BFTer
 q6OuxvX/m26y+fJppyBNfEuMvl7ybwHZhvnl+KTpYfS4/xcCUrFxKwnJgll2WOZ61ECh
 /gKLcfYf30pRZ6CoBFxJJumNvxuOgOdTdfXEvp09qEqONAn+BwHZsekOUCxr3CqdaM74
 /GdRwnVfAiZ8ssikp3wmcQAiEQGkT5EC6+6Ex1AtkNkCbBCb7iL1bRpBt6iD1I+tHDbI
 XZB9gunFKgFEsTPGkTVjfj2owyCHArmQ7FhqOyc2XFqxRQiu6zIVlCqkl/BObwTsljn8 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4yrd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:11:08 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32798gdl025358
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4yrcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326M4nu9001834;
        Tue, 7 Mar 2023 09:11:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p4192b4ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3279B2I7983574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 09:11:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1B3420043;
        Tue,  7 Mar 2023 09:11:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1003020040;
        Tue,  7 Mar 2023 09:11:02 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.61.17])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 09:11:01 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 0/7] Some cleanup patches
Date:   Tue,  7 Mar 2023 10:10:44 +0100
Message-Id: <20230307091051.13945-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pisiHjRkVHsEMFCYhesu-wNHFKULA-j5
X-Proofpoint-GUID: pKQlBC61LqBxGvp1iqoMaQJ0oa2XiFcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_02,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:
v2->v3:
 + rebased
 + added r-b's from Janosch, Nico, and Nina
 + reworked patch 5
 + worked in comments from Nina (patch 6) 
 + droppped old patch "[kvm-unit-tests PATCH v2 8/8] s390x/Makefile: add
   an extra `%.aux.o` target" (will send a separate patch for it because
   I've changed it for ARM, Power, and s390x)
v1->v2:
 + worked in comments from Claudio and Janosch
 + added r-b's from Janosch
 + added a new patch: `s390x/Makefile: add an extra `%.aux.o` target`

Marc Hartmayer (7):
  .gitignore: ignore `s390x/comm.key` file
  s390x/Makefile: simplify `%.hdr` target rules
  s390x/Makefile: fix `*.gbin` target dependencies
  s390x/Makefile: refactor CPPFLAGS
  s390x: use preprocessor for linker script generation
  s390x: define a macro for the stack frame size
  lib/linux/const.h: test for `__ASSEMBLER__` as well

 .gitignore                                  |  2 ++
 lib/linux/const.h                           |  2 +-
 lib/s390x/asm-offsets.c                     |  1 +
 s390x/Makefile                              | 25 ++++++++------
 s390x/cstart64.S                            |  2 +-
 s390x/{flat.lds => flat.lds.S}              |  4 ++-
 s390x/gs.c                                  | 38 ++++++++++++---------
 s390x/macros.S                              |  4 +--
 s390x/snippets/asm/{flat.lds => flat.lds.S} |  0
 s390x/snippets/c/{flat.lds => flat.lds.S}   |  6 ++--
 10 files changed, 50 insertions(+), 34 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (93%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (88%)

-- 
2.34.1

