Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B955651C56
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 09:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiLTIak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 03:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLTIai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 03:30:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C00178AC
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 00:30:37 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK8Djwk001504
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=K3iZCXDG3fv3kI/syJOOwmkA1yi8nIoI/Y+3OQwcpsw=;
 b=SbZnR8Lg2tAyizxBBnWEmMfXmIb55Hx9Yb6qZliJOdkpPFIY0a629UfNBlgAMuuEq+wl
 QkBhmpc/eYOYYYi5xnasJ+/969vMubIdS68TaZQWEkRqlYm1k1Lq6tDm2q7YC+NWLdcE
 KSCXhxZZ44acnm1BlJitu5OziMIqH2MWq8bI4OUg63TZUlbU3nLHV7XiHCoi5J2Tn8Gk
 Zwer8BLPB0McJs1Jc0t5SatUB9hkDWEfd+DOzz4DXQ5Ixgqjvit+sw/qlcoPLzrybzj7
 GBgayGXj68ej9wCVQC9vMGh/06zDlSLHBy5EGG0JXBGQRBYzsatmBoEtNoEOv73jr5ny 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mk9bqgd5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:30:36 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BK8GBsf010586
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:30:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mk9bqgd4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 08:30:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK5jIq0020676;
        Tue, 20 Dec 2022 08:30:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yy3pk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 08:30:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BK8UUCp48759132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 08:30:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80E7F20043;
        Tue, 20 Dec 2022 08:30:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58FD420040;
        Tue, 20 Dec 2022 08:30:30 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 08:30:30 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/1] s390x: test storage keys during migration
Date:   Tue, 20 Dec 2022 09:30:29 +0100
Message-Id: <20221220083030.30153-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G7t9PVKiwvZX5DfS2imKYLn-jJ8qamF_
X-Proofpoint-GUID: fjttBjuHnXHemUeb141GnwYxxjq5Z8O6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200065
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
* fix indent (thanks Nina)
* fix printf of skeys (thanks Nina)
* fix constness of verify_result (thanks Nina)
* indent breaks (thanks Nina)

v3->v4:
---
* comment fixups (thanks Claudio)
* fix usage (thanks Claudio)

v2->v3:
---
* remove some now useless arguments to get shorter function signatures
  (thanks Claudio)
* fix barriers (thanks Nina)
* improve command line arg parser (thanks Claudio)
* use posix-style arguments (thanks Claudio)
* factor out argument parsing into own function (thanks Claudio)
* cleanup includes a bit (thanks Nina)

v1->v2:
---
* remove the skey library and move both versions of the skey migration
  test to a single file
* rename skey_set_keys/verify_keys to set_test_pattern/verify_test_pattern
* add a few comments

Add a test which changes storage keys while VM is being migrated.

This series bases on Claudio's new PSW macros ("[PATCH v3 0/2] lib:
s390x: add PSW and PSW_WITH_CUR_MASK macros").

Nico Boehr (1):
  s390x: add parallel skey migration test

 s390x/migration-skey.c | 218 +++++++++++++++++++++++++++++++++++++----
 s390x/unittests.cfg    |  15 ++-
 2 files changed, 210 insertions(+), 23 deletions(-)

-- 
2.36.1

