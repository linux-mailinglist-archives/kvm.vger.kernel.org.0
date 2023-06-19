Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A9734E0C
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjFSIhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjFSIhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:37:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDCD3596;
        Mon, 19 Jun 2023 01:35:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8H67G028996;
        Mon, 19 Jun 2023 08:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5scqh/KxB/bN1xh7IkneaEkRuht+JMxhI6SBB9ApHOY=;
 b=JGAwsvJzM48g1xFtJ1NaGwgvvhssnYpbPvfimKCfX2Yi/Kl1yA0maOs1R5pZSEzSuDPe
 1WCk/KDFNdFpXpMxTH7pWAZJM7lNq5eWRR/exN2SSk6IrqUFT4ZeUa0lu6iBlroO/ACf
 dSF2ygrKoDMnDrt9FW7OSgUIPls0G702UMz70uh/DdLU8c2YUWz8geyfZK33her6nuEq
 iLhaJXMcVvI63ClZ7n7S7A4eUXOuKEzY7PUKq0lCJ1effvQqNipJLK+sAw/pZaRNhGpp
 WYoYtF2+u3tN3UBU+h4rX+wMeciR3vFFjozgQV1nBBolE/E80EzAObwPigDmf8mpZQej Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:57 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J8Jjrv003441;
        Mon, 19 Jun 2023 08:33:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J5BQax025864;
        Mon, 19 Jun 2023 08:33:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r943e18cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8Xqn017957504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E77D32004D;
        Mon, 19 Jun 2023 08:33:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E46420043;
        Mon, 19 Jun 2023 08:33:51 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:50 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/8] s390x: Add PV SIE intercepts and ipl tests
Date:   Mon, 19 Jun 2023 08:33:21 +0000
Message-Id: <20230619083329.22680-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rYQF3-89hSb1A4XKx02wF9IE5UQS-bCV
X-Proofpoint-ORIG-GUID: E_BUtTgkDQzfeWqCtloXJLCzZxUBHpHN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the coverage of the UVC interface.
The patches might be a bit dusty, they've been on a branch for a while.

v5:
	- Added "lib: s390x: uv: Introduce UV validity function"
	- Added "groups = pv-host" to unittests.cfg entries
	- Added pv-icptcode wrong vm handle test
	- Smaller fixes due to review
	- Added revs/acks
v4:
	- Renamed uv_guest_requirement_checks() to uv_host_requirement_checks()
	- Now using report_prefix_pushf()
	- Smaller fixes due to review
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

Janosch Frank (8):
  lib: s390x: sie: Fix sie_get_validity() no validity handling
  lib: s390x: uv: Introduce UV validity function
  lib: s390x: uv: Add intercept data check library function
  s390x: pv-diags: Drop snippet from snippet names
  lib: s390x: uv: Add pv host requirement check function
  s390x: pv: Add sie entry intercept and validity test
  s390x: pv: Add IPL reset tests
  s390x: pv-diags: Add the test to unittests.conf

 lib/s390x/pv_icptdata.h                       |  42 ++
 lib/s390x/sie.c                               |   8 +-
 lib/s390x/snippet.h                           |   7 +
 lib/s390x/uv.c                                |  20 +
 lib/s390x/uv.h                                |   8 +
 s390x/Makefile                                |  13 +-
 s390x/pv-diags.c                              |  70 ++--
 s390x/pv-icptcode.c                           | 376 ++++++++++++++++++
 s390x/pv-ipl.c                                | 143 +++++++
 s390x/snippets/asm/icpt-loop.S                |  15 +
 s390x/snippets/asm/loop.S                     |  13 +
 .../{snippet-pv-diag-288.S => pv-diag-288.S}  |   0
 s390x/snippets/asm/pv-diag-308.S              |  51 +++
 .../{snippet-pv-diag-500.S => pv-diag-500.S}  |   0
 ...nippet-pv-diag-yield.S => pv-diag-yield.S} |   0
 s390x/snippets/asm/pv-icpt-112.S              |  81 ++++
 s390x/snippets/asm/pv-icpt-vir-timing.S       |  21 +
 s390x/unittests.cfg                           |  16 +
 18 files changed, 841 insertions(+), 43 deletions(-)
 create mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/icpt-loop.S
 create mode 100644 s390x/snippets/asm/loop.S
 rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
 create mode 100644 s390x/snippets/asm/pv-diag-308.S
 rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)
 create mode 100644 s390x/snippets/asm/pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/pv-icpt-vir-timing.S

-- 
2.34.1

