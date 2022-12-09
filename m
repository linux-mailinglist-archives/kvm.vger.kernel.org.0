Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5291E6482E7
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiLINsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLINsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:48:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1E0663DF
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:48:18 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9BFDYA002313;
        Fri, 9 Dec 2022 13:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=xPc88VnNq1QRYDwRA6J8WmzfDSyDxcnZffmL4+eFNpE=;
 b=fwYVUXBToHUUiyzjC2xNrNPXNj2i2POlOIWdTGA2wt8PuMrO7LUuettyxg7wZ7lZszUk
 57rbjN0ydvhrhIkklr3KZd84IFup+z02mkgjAVxQkxj0AbM0qE5bW0Eg25dvqMGS44Og
 /+q/NVfkn/6SCpme3Ki92wdpJ9JK7ZCbvLmJbdZefRr7Jn4UD1Cfij0rddwXegnJ/plG
 YRecFoVUK7jK6clnX0ro1JBapBqd43UuO37OI8VyQBmaaObpPAm7+6lY/UUH49/Aa15A
 VoXOwnd8cwiWN6DdC3+5EizAxUCjzMYRzn7psMwj5iUF1dwwoDacsn25xiF8xpEmx/6u Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbuw95vt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:16 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9DAA18008032;
        Fri, 9 Dec 2022 13:48:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbuw95vs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9CCMP5016423;
        Fri, 9 Dec 2022 13:48:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y61mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9DmAfV39322016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 13:48:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0673420043;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFD9720040;
        Fri,  9 Dec 2022 13:48:09 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 13:48:09 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] lib: add function to request migration
Date:   Fri,  9 Dec 2022 14:48:05 +0100
Message-Id: <20221209134809.34532-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SmUIQEJ5ArYCqQtkO-0M7wIwoSmeGkjj
X-Proofpoint-ORIG-GUID: _jLlfRIVORUUBrtHXvEYbFW8RgocMHUR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_07,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxlogscore=730 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* arm: commit message gib->gic (thanks Andrew)
* arm: remove unneeded {} (thanks Andrew)
* s390x: make patch less intrusive (thanks Claudio)

With this series, I pick up a suggestion Claudio has brought up in my
CMM-migration series[1].

Migration tests can ask migrate_cmd to migrate them to a new QEMU
process. Requesting migration and waiting for completion is hence a
common pattern which is repeated all over the code base. Add a function
which does all of that to avoid repetition.

Since migrate_cmd currently can only migrate exactly once, this function
is called migrate_once() and is a no-op when it has been called before.
This can simplify the control flow, especially when tests are skipped.

[1] https://lore.kernel.org/kvm/20221125154646.5974cb52@p-imbrenda/

Nico Boehr (4):
  lib: add function to request migration
  powerpc: use migrate_once() in migration tests
  s390x: use migrate_once() in migration tests
  arm: use migrate_once() in migration tests

 arm/Makefile.common     |  1 +
 powerpc/Makefile.common |  1 +
 s390x/Makefile          |  1 +
 lib/migrate.h           |  9 ++++++++
 lib/migrate.c           | 34 ++++++++++++++++++++++++++++
 arm/debug.c             | 17 +++++---------
 arm/gic.c               | 49 ++++++++++++-----------------------------
 powerpc/sprs.c          |  4 ++--
 s390x/migration-cmm.c   | 25 +++++++--------------
 s390x/migration-sck.c   |  4 ++--
 s390x/migration-skey.c  | 15 +++++--------
 s390x/migration.c       |  7 ++----
 12 files changed, 84 insertions(+), 83 deletions(-)
 create mode 100644 lib/migrate.h
 create mode 100644 lib/migrate.c

-- 
2.36.1

