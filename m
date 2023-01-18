Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BFD67295D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjARUcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBC05EFAC;
        Wed, 18 Jan 2023 12:31:21 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJXt4b030516;
        Wed, 18 Jan 2023 20:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vdbuWZnwMezw/gbvgjJFXh/HqccZnKZWxamH7VX7DJo=;
 b=q3snMdP+n/7jQ+AcBu0uqU4u1XONEijzt/DuxGq/r4tRDE4n+McCt75uefYo+fVV7EZi
 bf/NMCG2YtIcttKrjvxhrxNkdiNb3nWL13a9zgn60dG92IeuHOBpTbWxaEkydLdyG1Ym
 tFkAz1eIKiIqgUQrhkGLWW2ssk/AUCzgkdCEUdHVN/QBgZ+gVpdPXUm+bHQryRvIq+QC
 MqYyhVNqdrsfVFd59k9FGthWJ/4ejiaivKq7J0W5jLzjarlzj4CbE1uZmhft//AUA1xH
 rNYktOsuo1YBJ6JwgK7Ui5gxZw9diXxqpENr2BeIOA2hAZ5ZTcxGTZ/8EMJQ+gjjKTcz 6Q== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hem2m32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:21 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IKBbA8019324;
        Wed, 18 Jan 2023 20:31:14 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3n3m17qrfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:14 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVCws56361288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:13 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF4095805D;
        Wed, 18 Jan 2023 20:31:12 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5916F58055;
        Wed, 18 Jan 2023 20:31:12 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:12 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 0/6] improve AP queue reset processing
Date:   Wed, 18 Jan 2023 15:31:05 -0500
Message-Id: <20230118203111.529766-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ujBq2Wrpiv5suPc_yeP87umUC-E6oyxq
X-Proofpoint-GUID: ujBq2Wrpiv5suPc_yeP87umUC-E6oyxq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=543 impostorscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301180173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces several improvements to the function that performs
AP queue resets:

* Breaks up reset processing into multiple smaller, more concise functions.

* Use TAPQ to verify completion of a reset in progress rather than mulitple
  invocations of ZAPQ.

* Check TAPQ response codes when verifying successful completion of ZAPQ.

* Fix erroneous handling of some error response codes.

* Increase the maximum amount of time to wait for successful completion of
  ZAPQ.
 
Change log v1 => v2:
-------------------
Remove patch 7/7 to restore original behavior since we don't know whether
interrupts are disabled when an unexpected response code is returned from 
ZAPQ. (Halil)

Tony Krowiak (6):
  s390/vfio-ap: verify reset complete in separate function
  s390/vfio_ap: check TAPQ response code when waiting for queue reset
  s390/vfio_ap: use TAPQ to verify reset in progress completes
  s390/vfio_ap: verify ZAPQ completion after return of response code
    zero
  s390/vfio_ap: fix handling of error response codes
  s390/vfio_ap: increase max wait time for reset verification

 drivers/s390/crypto/vfio_ap_ops.c | 104 +++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 32 deletions(-)

-- 
2.31.1

