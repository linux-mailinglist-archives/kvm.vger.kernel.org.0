Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AEF6F43A3
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbjEBMVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjEBMVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:21:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DD3198A;
        Tue,  2 May 2023 05:21:29 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342C8fqY012217;
        Tue, 2 May 2023 12:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ZH5LA3k+da28kAmr0kwJspn9DIhYOmAOqFOL0lpNmAw=;
 b=V7aYmg3fXp7Q6leSfbfWUBmHlg0rPhf/VzRCPT1VPLZI2/fAOIVPPPJYoxZsXIMDlY85
 atbopbCPbAzif73Y8PLESpjlv3UlM32LsqGfNQn4DkuV1ox0qrDh7HYPYUYaxbYCHwp5
 cz9AcdMzCVGeeNpHjfQIUe27uOYhCPnyWW9bbp1UeOuVIPZaOv5t6AMF0cEgRgHrz1sJ
 NIHNr8KFPbQHyLdu3LGWHZIriMjtpl/XrTZVCC13+uvRw9+O3zRH2QVn2DSKCegBT2g/
 KCRHTiPsCAr6C4GNxOd5g5GpxaqsRl+eplwBx39xeb3VrmoodkjPoN5N/+NNshlX+rQ3 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1w896pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:28 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342CLSLf008962;
        Tue, 2 May 2023 12:21:28 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1w896ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:28 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3428snIs031369;
        Tue, 2 May 2023 12:00:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6s9pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:00:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342C0gtV35914040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:00:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C2D320065;
        Tue,  2 May 2023 12:00:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE1020040;
        Tue,  2 May 2023 12:00:41 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:00:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/7] s390x: Add PV SIE intercepts and ipl tests
Date:   Tue,  2 May 2023 11:59:24 +0000
Message-Id: <20230502115931.86280-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 84tu22lcZgbY7y1QztYoFfRzQgKvQMUa
X-Proofpoint-GUID: OUJjH5sJ0dJg_Hcg0n7Q37VLZTH0EVAb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020103
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



Janosch Frank (7):
  lib: s390x: uv: Introduce UV validity function
  lib: s390x: uv: Add intercept data check library function
  s390x: pv-diags: Drop snippet from snippet names
  lib: s390x: uv: Add pv host requirement check function
  s390x: pv: Add sie entry intercept and validity test
  s390x: pv: Add IPL reset tests
  s390x: pv-diags: Add the test to unittests.conf

 lib/s390x/pv_icptdata.h                       |  42 ++
 lib/s390x/snippet.h                           |   7 +
 lib/s390x/uv.c                                |  20 +
 lib/s390x/uv.h                                |   8 +
 s390x/Makefile                                |  13 +-
 s390x/pv-diags.c                              |  70 ++--
 s390x/pv-icptcode.c                           | 373 ++++++++++++++++++
 s390x/pv-ipl.c                                | 143 +++++++
 s390x/snippets/asm/icpt-loop.S                |  15 +
 s390x/snippets/asm/loop.S                     |  13 +
 .../{snippet-pv-diag-288.S => pv-diag-288.S}  |   0
 s390x/snippets/asm/pv-diag-308.S              |  51 +++
 .../{snippet-pv-diag-500.S => pv-diag-500.S}  |   0
 ...nippet-pv-diag-yield.S => pv-diag-yield.S} |   0
 s390x/snippets/asm/pv-icpt-112.S              |  81 ++++
 s390x/snippets/asm/pv-icpt-vir-timing.S       |  21 +
 s390x/unittests.cfg                           |  13 +
 17 files changed, 828 insertions(+), 42 deletions(-)
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

