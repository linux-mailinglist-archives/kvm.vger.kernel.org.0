Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205AD51FC36
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiEIMMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 08:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiEIMMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 08:12:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48FB941B5;
        Mon,  9 May 2022 05:08:12 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249Br9Vi039952;
        Mon, 9 May 2022 12:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=e3MVrrUER/haum1WD1rBQ/X7CHWpw7GdjhqB92Xv+qA=;
 b=DGejdM9qvMBvaRP6DCOy+NzjmMDcJXuD5sQ+OadyuqCuv7Pm4w+UqspTTVBHthgtltgl
 BgxbMbeeooZxIilFSo3j751guUtNlytmK7YWd0zNiMDsaJLBUhJOZiFm87+2aFztPOtD
 JJs3CDballTcvOO1KxQnhnnQjEiX0da5SNfiUvzoqVeSeRAsktkmiJnCWVEIzCUggK2D
 zW3vOVVRVo7dPuNBzPi/2Xt71YjyUzEJz7FHzx9lRZFf82Qf6q/XpdcZYy0/NMBK/90w
 xMQPaEno7J08NJiHxm4hr+iFyUlTQIgsOBMX2M4U0AsM8vXPUI8ahlVXX+nlcQMnQNef jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy2frgaqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249Bt9mT008327;
        Mon, 9 May 2022 12:08:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy2frgapu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249C3C4F025378;
        Mon, 9 May 2022 12:08:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8hx4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249C86jC33030508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 12:08:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A8B52057;
        Mon,  9 May 2022 12:08:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C595452051;
        Mon,  9 May 2022 12:08:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for CMM
Date:   Mon,  9 May 2022 14:08:03 +0200
Message-Id: <20220509120805.437660-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BaIV8PrIYAU1jmNu9epqJRmdddZWcK9B
X-Proofpoint-ORIG-GUID: SXo1FU_CMtlR2ZUrwejH16IhhDlmkIb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=725 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205090069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 s390x/cmm-migration.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 s390x/cmm.c           | 25 ++------------
 s390x/unittests.cfg   |  4 +++
 5 files changed, 136 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h
 create mode 100644 s390x/cmm-migration.c

-- 
2.31.1

