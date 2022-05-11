Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F88522ECD
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 10:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbiEKI5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 04:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiEKI5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 04:57:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E1539694;
        Wed, 11 May 2022 01:57:00 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B7TGte016135;
        Wed, 11 May 2022 08:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4btaQcojH/jz8+L4hJdo0dGgg2nq1Decsu48xk0KvxU=;
 b=PQeeAhJeKWagBqRHtBXOnlMavH+MR3RAw7avW05opbNmsJRR7aoZoTGHaOo8nfjpmVum
 JoSeF7i/Hp/+lpJjOygFjWFVspBmourbK95UbSI67xSsvXWeHf1vVq3VW+G//WzWzlsw
 EiVZANLom1DxovDkkUCpCbk7YLrrkcSBq+lR1COmsx7N39Iy962smCf5EWpmVFC1FjLG
 NRSroGJYtDJEXtIXkJ+Y9wHdQIL3rWbYuS7koSPjScxEYhPLW2lyCp6DADiDstCiVNzy
 /wteujt+Vc5FHGeyLS0mDq+cS7vkJ+AVKr303LKQoWF5b2pF7VwL/AZ7UojGVlDNveDV aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g08t21ea9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24B8NY7w004423;
        Wed, 11 May 2022 08:56:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g08t21e9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24B8r1n6021557;
        Wed, 11 May 2022 08:56:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8w6tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24B8ur7a21168612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 08:56:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EB4852050;
        Wed, 11 May 2022 08:56:53 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F17625204F;
        Wed, 11 May 2022 08:56:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: add migration test for CMM
Date:   Wed, 11 May 2022 10:56:50 +0200
Message-Id: <20220511085652.823371-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u7Ij_hnE6ueg4JgwJk4Dy2B2l_yRkXRm
X-Proofpoint-GUID: Qads6pcP70b98IuhozsYzLGblOcAQ_gR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_02,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=776 mlxscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* Rename cmm-migration.c to migration-cmm.c (Thanks Janosch)
* Replace switch-case with unrolled loop (Thanks Claudio)
* Migrate even when ESSA is not available so we don't hang forever

Upon migration, we expect the CMM page states to be preserved. Add a test which
checks for that.

The new test gets a new file so the existing cmm test can still run when the
prerequisites for running migration tests aren't given (netcat). Therefore, move
some definitions to a common header to be able to re-use them.

Nico Boehr (2):
  lib: s390x: add header for CMM related defines
  s390x: add cmm migration test

 lib/s390x/asm/cmm.h   | 50 +++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/cmm.c           | 25 ++------------
 s390x/migration-cmm.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 +++
 5 files changed, 136 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h
 create mode 100644 s390x/migration-cmm.c

-- 
2.31.1

