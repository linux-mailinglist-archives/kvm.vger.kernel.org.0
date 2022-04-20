Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A83508999
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347575AbiDTNsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378989AbiDTNsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:48:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7256C1EAC3;
        Wed, 20 Apr 2022 06:46:04 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KCAaRN024573;
        Wed, 20 Apr 2022 13:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=F0ule8dV5gUrJl2Unq6QAdyik+oYYIgK2K8Hb18EVa8=;
 b=tTDel6OYsr9d2eF7AD1RaRoWUBkYNPwogRKSNAzpL0vihtwxB4Kqxmh63uz8EfCPwIvo
 NQwsGfnXYvVWAA93g5f9ETuLqaN8p94lCwSNc3JX6c8IcABO7DagPOsxa+1euiKW8oqz
 QRyhFyD7e2OXCMoDffVXEQiBttia/uswA43F5B3+SFEot+qgu/8leZkc4CojN/twFXoJ
 iJ2DpApBD8+e7Xz9jX/2D4H5AuVHNPl6r+A5mZ4FeAZfS12MiccNYJ9vsHTY7UySLJEZ
 QtuoDxdgDwcxRTYc0A6bLWRwHmGegsXK0b+IlABalmkra8QauBKzhZDA0oczaJx0888b AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2wb1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:03 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KDc6tK018357;
        Wed, 20 Apr 2022 13:46:03 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2wb0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:03 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KDh7am027812;
        Wed, 20 Apr 2022 13:46:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8w23x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KDjvSj48169452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 13:45:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4C6DAE055;
        Wed, 20 Apr 2022 13:45:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 786B3AE04D;
        Wed, 20 Apr 2022 13:45:57 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 13:45:57 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/4] s390x: add migration test support
Date:   Wed, 20 Apr 2022 15:45:53 +0200
Message-Id: <20220420134557.1307305-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5TeSwTzeG0FBCRpTaMziiWGktSpyiZYF
X-Proofpoint-ORIG-GUID: ToC6kpWGGTFtG-u59hbQH94BskSAZ8z4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v2:
---
- Cosmetic fixes, typo in comments (thanks Thomas)
- Improve migration prompt when tests are run manually (thanks Thomas)
- Whitespace fixes

This series depends on my SIGP store additional status series to have access to
the guarded-storage and vector related defines
("[kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status").

Add migration test support for s390x.

arm and powerpc already support basic migration tests.

If a test is in the migration group, it can print "migrate" on its console. This
will cause it to be migrated to a new QEMU instance. When migration is finished,
the test will be able to read a newline from its standard input.

We need the following pieces for this to work under s390x:

* read support for the sclp console. This can be very basic, it doesn't even
  have to read anything useful, we just need to know something happened on
  the console.
* s390/run adjustments to call the migration helper script.

This series adds basic migration tests for s390x, which I plan to extend
further.

Nico Boehr (4):
  lib: s390x: add support for SCLP console read
  s390x: add support for migration tests
  s390x: don't run migration tests under PV
  s390x: add basic migration test

 lib/s390x/sclp-console.c |  79 ++++++++++++++++--
 lib/s390x/sclp.h         |   8 ++
 s390x/Makefile           |   2 +
 s390x/migration.c        | 172 +++++++++++++++++++++++++++++++++++++++
 s390x/run                |   7 +-
 s390x/unittests.cfg      |   5 ++
 scripts/s390x/func.bash  |   2 +-
 7 files changed, 267 insertions(+), 8 deletions(-)
 create mode 100644 s390x/migration.c

-- 
2.31.1

