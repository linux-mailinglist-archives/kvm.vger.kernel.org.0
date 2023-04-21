Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F866EA966
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjDULjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjDULjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:39:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BF2D326;
        Fri, 21 Apr 2023 04:38:32 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LBX9da022121;
        Fri, 21 Apr 2023 11:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wCggQcHnHQ8YBjgRsQiuLelij/tpcpAd4IeMGYQ/YJU=;
 b=KEEZkZHgT8vYjxr12qkyWJYze6SP5wlA0U9GQzGH6RAYnfB1Jyu94oJLmytxLrHO51Xb
 JNUwdN8GKuQnE01EmKqsVtOii6HkwI3cXbfRNaLpBMEII8RPuxpoZypGo+GfU6rv4fsH
 kuM5oWZdhAeWnhG3VUsOYH6yzRCdgsovo1C4ugbIVOc0Zhzz7QrJZVA50RbVEEdJJ1PQ
 jA0mU+2Ls/f3UhMTE5U3vo+MeOQvKM7L44c3yhOvXbhbo7Oii21EqMMG8AE158EQ32KJ
 CjIx7p28vjBcGAQWn7tyOSJHyoleZvQnpub3LSYEHS/bC9oHFkiD9pCtLWdziLxVnm66 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrtae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LBY0wc028674;
        Fri, 21 Apr 2023 11:37:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrt79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K7UVJN031974;
        Fri, 21 Apr 2023 11:37:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fm0yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LBbG2r34669280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 11:37:16 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD3372004D;
        Fri, 21 Apr 2023 11:37:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE3322004B;
        Fri, 21 Apr 2023 11:37:15 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 11:37:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/7] s390x: Add PV SIE intercepts and ipl tests
Date:   Fri, 21 Apr 2023 11:36:40 +0000
Message-Id: <20230421113647.134536-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mfzcsP-NA_sYVfxB2cujsuFKpxPgm02H
X-Proofpoint-ORIG-GUID: bYRyOXZ9XIyH-rQgpLsNr4Y6lUM6nlr0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_04,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the coverage of the UVC interface.
The patches might be a bit dusty, they've been on a branch for a while.

v3:
	- Reworked a large portion of the tests
	- Introduced a new function that checks for required
          facilities and memory for tests that start PV guests
	- Shortened snippet file names
	- Moved checks from report to asserts to decrease test noise
	- Introduced diag PV intercept data check function

v2:
	- Re-worked the cpu timer tests
	- Testing both pages for 112 intercept
	- Added skip on insufficient memory
	- Fixed comments in pv-ipl.c

Janosch Frank (7):
  lib: s390x: uv: Introduce UV validity function
  lib: s390x: uv: Add intercept data check library function
  s390x: pv-diags: Drop snippet from snippet names
  lib: s390x: uv: Add pv guest requirement check function
  s390x: pv: Add sie entry intercept and validity test
  s390x: pv: Add IPL reset tests
  s390x: pv-diags: Add the test to unittests.conf

 lib/s390x/pv_icptdata.h                       |  42 ++
 lib/s390x/snippet.h                           |   7 +
 lib/s390x/uv.c                                |  20 +
 lib/s390x/uv.h                                |   8 +
 s390x/Makefile                                |  13 +-
 s390x/pv-diags.c                              |  70 ++--
 s390x/pv-icptcode.c                           | 370 ++++++++++++++++++
 s390x/pv-ipl.c                                | 145 +++++++
 s390x/snippets/asm/icpt-loop.S                |  15 +
 s390x/snippets/asm/loop.S                     |  13 +
 .../{snippet-pv-diag-288.S => pv-diag-288.S}  |   0
 .../{snippet-pv-diag-500.S => pv-diag-500.S}  |   0
 ...nippet-pv-diag-yield.S => pv-diag-yield.S} |   0
 s390x/snippets/asm/pv-icpt-vir-timing.S       |  22 ++
 s390x/unittests.cfg                           |  13 +
 15 files changed, 696 insertions(+), 42 deletions(-)
 create mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/icpt-loop.S
 create mode 100644 s390x/snippets/asm/loop.S
 rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)
 create mode 100644 s390x/snippets/asm/pv-icpt-vir-timing.S

-- 
2.34.1

