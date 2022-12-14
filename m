Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B4364CBA8
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiLNNzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 08:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiLNNzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 08:55:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521D79FDE
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 05:55:42 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEDfjwP007966
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GXQSgn3ZL9WpkSbM4TKCetfOUwb3xRKwC+7GNXhiMmM=;
 b=OVMSbPQTnDrh8tJYj6Vje6RlwufjsLcuZLMTHmRoxrMxz900b/qgkMbxGh91urDZj9w4
 rpK/0L5MgrXd3U/jLhUIwbYHUWLziDJaa95lrm+Y637iYyGiFzzg24WCT10rTGi5RJ3X
 7VEvuIVq7e8oXKgxeMRR+ATi0J44euIotEvYPQHzobZHn2fXfnU1rFUMDKV9SbI0KMoa
 43VGZNl933cfTOB/S23XX1jVtocy2Q6XZtqlUAuvCaNtWg1vi+EhcOoUJB8be7knGb6s
 Rj41WOHPhrRgJQHfX4ptgWe+NIGi1+M1QhqGwbxTdJJgxrGemo3YOFat4iyLReOJWl8h pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mffkjgc4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:55:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEDhbAI019278
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:55:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mffkjgc3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:55:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEA1us0023801;
        Wed, 14 Dec 2022 13:55:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3meypyhbku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:55:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEDtZ5R24117652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 13:55:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E9E32004B;
        Wed, 14 Dec 2022 13:55:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AFDB20040;
        Wed, 14 Dec 2022 13:55:35 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 13:55:35 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/1] s390x: test storage keys during migration
Date:   Wed, 14 Dec 2022 14:55:34 +0100
Message-Id: <20221214135535.704685-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qnsuulzKUsNIFAELxdTrYj17vRSt5lkv
X-Proofpoint-GUID: EJGwZvSwmkN1D-P_y5mNfLW5hOYR_LJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 mlxlogscore=967 impostorscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

