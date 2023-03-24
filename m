Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459566C7DAC
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjCXMF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCXMFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:05:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBDB90
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:05:54 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBp2Xo022418
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GjOss02CHBA0hI6Iu1TcbvLnf5knDXVFXsBaItk7ZQ4=;
 b=Ssm4GVGNh0vQW/+p8NH6OUbePAQAP2ePCGnOWcC9v6Qj5OwkfCQCQGCz1PpRntNBr7BT
 JegF8Dpjp51g+RokkXQqMO6tr+G3HuzxwUMbMJBXbvF+XPgs61DPd60aZ5dRrqWAkIA4
 8ePedxxzGC09jI39IQyizhgtTMrAxpkKPl0exRZLsVvF9wSn52hbRKuPk2j3RcOHlBmA
 8R1S7J58zgP2zOmdiAciSqeNix3aX64an5eAtA/5dRZsS19xq9Wv4/JiZMnqZYPhB5Kd
 BmywOeRQNlhZCagplYDJSM4X0ebs2wGUzjGRf0cQz6UE7ocmS+ziBweHqi28YH7BZNUT Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbbr8bb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:05:53 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBrQbn029697
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:05:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbbr8bam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:05:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLsobY012706;
        Fri, 24 Mar 2023 12:05:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0sq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:05:51 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OC5lXc29098574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:05:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9F6A2004D;
        Fri, 24 Mar 2023 12:05:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B84920040;
        Fri, 24 Mar 2023 12:05:47 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:05:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Add PV SIE intercepts and ipl tests
Date:   Fri, 24 Mar 2023 12:04:28 +0000
Message-Id: <20230324120431.20260-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QFtIX2fMN5J8uWSZf716Rq2Swb2u96kt
X-Proofpoint-GUID: JrwG71a--p-21lpD5hRQZMAPe09H-fQt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Extend the coverage of the UVC interface.
The patches might be a bit dusty, they've been on a branch for a while.

v2:
	- Re-worked the cpu timer tests
	- Testing both pages for 112 intercept
	- Added skip on insufficient memory
	- Fixed comments in pv-ipl.c

Janosch Frank (3):
  lib: s390x: Introduce UV validity function
  s390x: pv: Test sie entry intercepts and validities
  s390x: pv: Add IPL reset tests

 lib/s390x/uv.h                                |   7 +
 s390x/Makefile                                |   7 +
 s390x/pv-icptcode.c                           | 403 ++++++++++++++++++
 s390x/pv-ipl.c                                | 246 +++++++++++
 s390x/snippets/asm/snippet-loop.S             |  12 +
 s390x/snippets/asm/snippet-pv-diag-308.S      |  67 +++
 s390x/snippets/asm/snippet-pv-icpt-112.S      |  77 ++++
 s390x/snippets/asm/snippet-pv-icpt-loop.S     |  15 +
 .../snippets/asm/snippet-pv-icpt-vir-timing.S |  22 +
 9 files changed, 856 insertions(+)
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/snippet-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-308.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-vir-timing.S

-- 
2.34.1

