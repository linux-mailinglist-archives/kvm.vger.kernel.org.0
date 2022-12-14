Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF2664C92E
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 13:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiLNMkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 07:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiLNMjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 07:39:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28679BE8
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 04:38:21 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEC2doF024692
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=og2VE7yQAjePbAxtUFBIuPhVs+yGoThqR1DGUj/pPxI=;
 b=cZYHJ6TB1VDYjae5/pJFSQcQRvgvnjcmMWO07k0T/vQ0hKcwLx17X1tb8JL29y5JhRPz
 XPsZQ6429HNdS5bQQqSwrxet1l4FN7BnM3JmU7PI1P5RqzlPjrD+euffWF54c7wQ/CFO
 /AOlPhRLv+FrirMV5tfIEMX9sWME/RktoRDJlLw4f4zqxFLXj8Nif+5Gbg0+0m/hyv2s
 xywZbXqYpVG736+8HU5LZMh5mMzFZkhkGsVzcjqC2fLAHKCB0l6pBHhUtPGOFbbDwk5v
 JfsKB24aqgw0nZjmcI/8erGPhRuoFxqitzKqCHdS0vB6j4Ut5b3tSr2l4N6QkHYP+RhQ tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfe4ygvys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:38:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEC4bXL032713
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:38:20 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfe4ygvy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 12:38:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEBg8mG030324;
        Wed, 14 Dec 2022 12:38:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mf0518y08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 12:38:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BECcEI021496334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 12:38:14 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF6D520049;
        Wed, 14 Dec 2022 12:38:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 756E320040;
        Wed, 14 Dec 2022 12:38:14 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 12:38:14 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/1] s390x: test storage keys during migration
Date:   Wed, 14 Dec 2022 13:38:13 +0100
Message-Id: <20221214123814.651451-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t6c78bn21jf3h_0A7NjeY5w9K_-I7z00
X-Proofpoint-GUID: ZIEuaSpPdyGh8cCtveeCOAHfKGL7HHca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=963 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

