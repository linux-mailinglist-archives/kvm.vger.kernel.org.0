Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389F052EDCC
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348054AbiETOH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350123AbiETOGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:06:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92EC4D625;
        Fri, 20 May 2022 07:05:54 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KDD8aq016276;
        Fri, 20 May 2022 14:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=cAuTtd+nj0jhArr6PJ9LjRWhoCED1E6gEqoFubFipnA=;
 b=jdueWvFeQFje4VPCDlJMmKPljBU5dHQSQ0FxVO0Vu2MtHWZD1mlSvl3cwKbfVSO/BOmQ
 QvwQG1IngeMB7JShCb1buJa/2Zv4Vin8tnm5VWHEqmp23/TBR/6O6wgMOZXeJ9NAn6YA
 CPgvVo3Heb6vWuBtsENhSDctDy/3hVv9SyRsolBzkznDP3TdczUkgdKMU1PROT7LjCMo
 XuWWm7+jRGkpQWovKU1KjxDaArBFqWWNOxDbNsRgOTOkkUFZILnJwSU1beAtH+8oZ77e
 glzb1tm0ABTvnCKHgXK0qrcySKxFzpA3Tcoe7Ff6/gDEO6JKweX2Wa1YvBQCpjdHs4d3 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6bp2s95n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:05:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KDl05T016192;
        Fri, 20 May 2022 14:05:53 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6bp2s94w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:05:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KDqmaI007787;
        Fri, 20 May 2022 14:05:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429gwug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:05:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KE5mrj48038344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 14:05:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44E3AAE051;
        Fri, 20 May 2022 14:05:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07E99AE045;
        Fri, 20 May 2022 14:05:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 14:05:47 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: Avoid gcc 12 warnings
Date:   Fri, 20 May 2022 16:05:44 +0200
Message-Id: <20220520140546.311193-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jl-E3R8KIbKrGQX1I-UmJu63KAQe3yot
X-Proofpoint-GUID: 1rzUP55Cx00tnA3pngPEycOn4UV-7I-m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gcc 12 warns if a memory operand to inline asm points to memory in the
first 4k bytes. However, in our case, these operands are fine, either
because we actually want to use that memory, or expect and handle the
resulting exception.

v1 -> v2
 * replace mechanism, don't use pragmas, instead use an extern symbol so
   gcc cannot conclude that the pointer is <4k

   This new extern symbol refers to the lowcore. As a result, code
   generation for lowcore accesses becomes worse.

   Alternatives:
    * Don't use extern symbol for lowcore, just for problematic pointers
    * Hide value from gcc via inline asm
    * Disable the warning globally
    * Use memory clobber instead of memory output
      Use address in register input instead of memory input
          (may require WRITE_ONCE)
    * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
      avoid the problem

Janis Schoetterl-Glausch (2):
  s390x: Introduce symbol for lowcore and use it
  s390x: Fix gcc 12 warning about array bounds

 lib/s390x/asm/arch_def.h   |  2 ++
 lib/s390x/asm/facility.h   |  4 +--
 lib/s390x/asm/mem.h        |  4 +++
 lib/s390x/css.h            |  2 --
 lib/s390x/css_lib.c        | 12 ++++----
 lib/s390x/fault.c          | 10 +++----
 lib/s390x/interrupt.c      | 61 +++++++++++++++++++-------------------
 lib/s390x/mmu.c            |  3 +-
 s390x/flat.lds             |  1 +
 s390x/snippets/c/flat.lds  |  1 +
 s390x/css.c                |  4 +--
 s390x/diag288.c            |  4 +--
 s390x/edat.c               |  5 ++--
 s390x/emulator.c           | 15 +++++-----
 s390x/mvpg.c               |  7 ++---
 s390x/sclp.c               |  3 +-
 s390x/skey.c               |  2 +-
 s390x/skrf.c               | 11 +++----
 s390x/smp.c                | 23 +++++++-------
 s390x/snippets/c/spec_ex.c |  5 ++--
 20 files changed, 83 insertions(+), 96 deletions(-)


base-commit: 8719e8326101c1be8256617caf5835b57e819339
-- 
2.33.1

