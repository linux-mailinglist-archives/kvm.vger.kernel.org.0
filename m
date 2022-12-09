Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3C76480D6
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 11:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLIKVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 05:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIKVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 05:21:33 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788235447F
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 02:21:32 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B99U8eN013087
        for <kvm@vger.kernel.org>; Fri, 9 Dec 2022 10:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kFjpJbtD63fT4nj8JbPzxh7z8HgiCSA00BM4H1HFsXs=;
 b=RyjVWwmzZSsIzKls3/ePwbjKHOFCS+M/LJyw6HDLj/JXJEzg4MD6Qc7tk45ecE5Qz1nE
 xTdFxxTm2dcbAh3jXGZE3Ec40nk31iDUUYNdOTDYDFSFQTH8LxXMEeglpS2Yuus0iOkG
 e1sz92OXsMGs6LC51+vZzPXePpBnPetH3+keOMtyZp6I5T1YCDSk2KvF++3PSLK+yM/I
 lJaOaf4r2M9G8ovH+GzG3CyyyzeTA6ON+nBC8oOqYhXeKyo7S+lh3VPn7X+d8MqIi2g4
 9n6y+JNB8tEXWRQueuCyo5my9GzgFvZhIH+xzCudPVvsQepFlESoVukki/qLBtbcQOIw sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbh9che11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 10:21:31 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B99c9eT028753
        for <kvm@vger.kernel.org>; Fri, 9 Dec 2022 10:21:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbh9che0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 10:21:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8LMIiM004699;
        Fri, 9 Dec 2022 10:21:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3m9kvbdtc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 10:21:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9ALP7N46334302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 10:21:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9100720065;
        Fri,  9 Dec 2022 10:21:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F262C20049;
        Fri,  9 Dec 2022 10:21:22 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 10:21:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/1] s390x: test storage keys during migration
Date:   Fri,  9 Dec 2022 11:21:21 +0100
Message-Id: <20221209102122.447324-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3YRdShL8pFpwpGr8g8ut-diWgZcMp8FZ
X-Proofpoint-GUID: PeSQN99__dRcpz3RAXszktJES4DTHyyG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=724 adultscore=0 impostorscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
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
* remove the skey library and move both versions of the skey migration
  test to a single file
* rename skey_set_keys/verify_keys to set_test_pattern/verify_test_pattern
* add a few comments

Add a test which changes storage keys while VM is being migrated.

This series bases on Claudio's new PSW macros ("[PATCH v3 0/2] lib:
s390x: add PSW and PSW_WITH_CUR_MASK macros").

Nico Boehr (1):
  s390x: add parallel skey migration test

 s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
 s390x/unittests.cfg    |  15 ++-
 2 files changed, 198 insertions(+), 31 deletions(-)

-- 
2.36.1

