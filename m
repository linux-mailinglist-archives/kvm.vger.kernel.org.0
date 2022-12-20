Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3FE651D13
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiLTJTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiLTJTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:19:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FA017E13
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 01:19:30 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK9FuDK031523
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=JNXMht38vIWzOHElqbS4c7XzZyHuPUUXiU6RUm5vDgM=;
 b=NWWVrK9N9ROW9Fjop0hF63olgBcmeBfaQ8ZzY4BBXlT71z1zuAp/gz2Iy6CZyTWRA91U
 AJCXhQAIh3xiOzP3xXxeDQ8fy8Oz9N0jlFUKXxLAsTIOfbtk21Bx8kCJDrBOegd6a0O2
 7ddylHKjKjAu/s+As9mTShmfBcFhxgCCKExRC3JsflUPVBeIbq5BRzJxmBLfJq0z/hQT
 z0ccZiogXimzpGXYrO16Zah87qrtfNAtMXQ8IzE5Wic7VmiagK92BAh/jo05ra/PkEkH
 ndTXW8LJcs+Yai3TmxSCpAR7VaDzKuYZkw20Q9+0U/svFidc5nUmlLoxygd09rPvSJvX qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mka9182r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BK9H7Jh003207
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mka9182qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 09:19:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6OZC6024486;
        Tue, 20 Dec 2022 09:19:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywkr4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 09:19:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BK9JNH738863284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 09:19:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8C2A20043;
        Tue, 20 Dec 2022 09:19:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A28CB2004B;
        Tue, 20 Dec 2022 09:19:23 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 09:19:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/1] s390x: test CMM during migration
Date:   Tue, 20 Dec 2022 10:19:22 +0100
Message-Id: <20221220091923.69174-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JS4To9_raBRrido39jdZzYoeABJPonFQ
X-Proofpoint-GUID: LMki9gUlLXfMVfEXFoPL9NqOlPId-3UG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=981
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4->v5:
---
* merge migration-during-cmm and migration-cmm into one file and remove
  the cmm library

v3->v4:
---
* rebase on top of Claudio's series
    [kvm-unit-tests PATCH v3 0/2] lib: s390x: add PSW and
    PSW_WITH_CUR_MASK macros
    https://lore.kernel.org/kvm/20221130154038.70492-1-imbrenda@linux.ibm.com/
* switch cmm.h to system includes
* move const qualifier before struct keyword

v2->v3:
---
* make allowed_essa_state_masks static (thanks Thomas)
* change several variables to unsigned (thanks Claudio)
* remove unneeded assignment (thanks Claudio)
* fix line length (thanks Claudio)
* fix some spellings, line wraps (thanks Thomas)
* remove unneeded goto (thanks Thomas)
* add migrate_once (thanks Claudio)
  I introduce migrate_once() only in migration-during-cmm.c for now, but
  I plan to send a future patch to move it to the library.
* add missing READ_ONCE (thanks Claudio)

v1->v2:
---
* cmm lib: return struct instead of passing in a pointer (thanks Claudio)
* cmm lib: remove get_page_addr() (thanks Claudio)
* cmm lib: print address of mismatch (thanks Claudio)
* cmm lib: misc comments reworked, added and variables renamed
* make sure page states change on every iteration (thanks Claudio)
* add WRITE_ONCE even when not strictly needed (thanks Claudio)

Add a test which changes CMM page states while VM is being migrated.

Nico Boehr (1):
  s390x: add CMM test during migration

 s390x/migration-cmm.c | 258 +++++++++++++++++++++++++++++++++++++-----
 s390x/unittests.cfg   |  15 ++-
 2 files changed, 240 insertions(+), 33 deletions(-)

-- 
2.36.1

