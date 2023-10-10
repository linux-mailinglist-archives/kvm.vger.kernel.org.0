Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4527BF67A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjJJIvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjJJIvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D64B8
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:20 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k1I0029516
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4aSl0CldSo1gjFmuXJoLac1WOQPuAQKm+3iNx2VqRtQ=;
 b=WU+Sfg0ibhEMukRQe/C5gNqBVUoFh2/m+8esHaHx9WGWnzvOhZztYxhRxIKkm+DigMU8
 8f0T2+9yAPiZG8uldUdr0Fus/48fPid3RfSJqUO6IsGacB/HMWpB/Mtt3FpvSwq1x0cc
 gEIyLDzLhnYfcLzKjFi481YYFNP3Ju722yyv6/8IwQdCAyQcQa85yPx9MDh3c9FwPDDz
 /wOJdKwj5S5CwyPvnpUDFRddqBGwIedukIvAh7W76adVJINOsbU6uSw64r7twmTQUxVO
 Avhy66k9l+I6YGg7ewv2z//W8In0Xb1wBoW6HS1z4HzY6VMQPkAe0YqH0u0osDV2EXaU pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug8bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:19 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8kGm8030518
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug7yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:13 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6i0PJ023094;
        Tue, 10 Oct 2023 08:51:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1enk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p5qV7144170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 363B12004D;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A67820043;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/7] s390x: Add base AP support
Date:   Tue, 10 Oct 2023 08:49:29 +0000
Message-Id: <20231010084936.70773-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: og752XlSnQ2YhDO-OzF4f-GgdMgEzLUG
X-Proofpoint-ORIG-GUID: Kc4uJT_M6enzEXV44DWUerei3q0YQ8C-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=900 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As KVM supports passing Adjunct Processor (AP) crypto devices to
guests, we should make sure that the interface works as expected.

Three instructions provide the interface to the AP devices:
 - nqap: Enqueues a crypto request
 - dqap: Dequeues a crypto request
 - pqap: Provides information and processes support functions

nqap & dqap work on crypto requests for which we currently don't want
to add tests due to their sheer complexity.

Which leaves us with pqap which is partly emulated for a guest 2 and
hence is a prime target for testing.

v2:
	- Re-worked the ap_check() function to test for stfle 12 since
          we rely on PQAP QCI in the library functions
	- Re-worked APQN management
	- Fixed faulty loop variable initializers in ap.c
	- Fixed report messages
	- Extended clobber lists
	- Extended length bit checks for nqap
	- Now using ARRAY_SIZE where applicabale
	- NIB is now allocated as IO memory


Janosch Frank (7):
  lib: s390x: Add ap library
  s390x: Add guest 2 AP test
  lib: s390x: ap: Add ap_setup
  s390x: ap: Add pqap aqic tests
  s390x: ap: Add reset tests
  lib: s390x: ap: Add tapq test facility bit
  s390x: ap: Add nq/dq len test

 lib/s390x/ap.c      | 278 ++++++++++++++++++++++
 lib/s390x/ap.h      | 119 ++++++++++
 s390x/Makefile      |   2 +
 s390x/ap.c          | 564 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 5 files changed, 966 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h
 create mode 100644 s390x/ap.c

-- 
2.34.1

