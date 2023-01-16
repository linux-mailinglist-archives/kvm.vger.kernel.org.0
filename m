Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B4866CE7D
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjAPSNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjAPSMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFDC193CD
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:03 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHp3B5026161
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tFFYrCsZI+zZazUiMMnDBsVnSmQDmRY0mylRMln3amQ=;
 b=Sz6MO/qADfnLz4eyGyK1oX8TQlpcVzOec30NzRT7/cT/9oRwHjkBob8kilDxNkeoyPyQ
 Sx0D84vvwHb6RhsqPe/cQTXMpdkp6i5or67jLFo5HFL+YNsq2nhgZFU3jAnOCDW5hixw
 DbDdYKyjsUc75JYE9HSSxt/CxuSBB0zz3av8svMOc7v6bH2kGd74zCC5FdWDYCcp8ALP
 uyercVrfCQnwwApVXQ4YCClRgAhL+jPkEgvXVUEqF0bStEDK8NYt2tw0D7yKSW76EJGe
 3jcHOusDXEOXSZLKlCBrMYkWpZbLzOGkk4dDC4wFMqTc6NkpUO85/o81FWEtki5c1lmd CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1unn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHrrrf028046
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1unmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GD7nPu002347;
        Mon, 16 Jan 2023 17:59:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16a09y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHwuKf44171742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:58:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A8612004B;
        Mon, 16 Jan 2023 17:58:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05E9820040;
        Mon, 16 Jan 2023 17:58:56 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:58:55 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 0/9] Some cleanup patches
Date:   Mon, 16 Jan 2023 18:57:48 +0100
Message-Id: <20230116175757.71059-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BrYnvXDMMAk_hCgeOxEvziE54mPtO1E-
X-Proofpoint-ORIG-GUID: F3e3E4OcTzC6JMG5lfBh9lnSagZUBNHb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series should be applied on top of Janosch's patch series
([kvm-unit-tests PATCH v2 1/7] s390x: Cleanup flat.lds).

Marc Hartmayer (9):
  .gitignore: ignore `s390x/comm.key` file
  s390x/Makefile: simplify `%.hdr` target rules
  s390x/Makefile: fix `*.gbin` target dependencies
  s390x/Makefile: refactor CPPFLAGS
  s390x/Makefile: remove unused include path
  s390x: define a macro for the stack frame size
  s390x: use C pre-processor for linker script generation
  s390x: use STACK_FRAME_SIZE macro in linker scripts
  lib/linux/const.h: test for `__ASSEMBLER__` as well

 .gitignore                                  |  2 ++
 lib/linux/const.h                           |  2 +-
 lib/s390x/asm-offsets.c                     |  1 +
 s390x/Makefile                              | 20 +++++++++++---------
 s390x/cstart64.S                            |  2 +-
 s390x/{flat.lds => flat.lds.S}              |  4 +++-
 s390x/snippets/asm/{flat.lds => flat.lds.S} |  0
 s390x/snippets/c/{flat.lds => flat.lds.S}   |  6 ++++--
 8 files changed, 23 insertions(+), 14 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (93%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (88%)

-- 
2.34.1

