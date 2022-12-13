Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985DE64B8D6
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiLMPor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiLMPoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B7A5F61;
        Tue, 13 Dec 2022 07:44:43 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF9Y5n028455;
        Tue, 13 Dec 2022 15:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vUIvTfnfTAj8T26MaoLAUf7I4zk2YP28InrrSR0U0F8=;
 b=qRVZDKVjtEfzvSI9rWB+6KIVonLhE/WcYA0UrBtAaagOC+ZG9K45SgTHgC9fQgv20J21
 TC8KUaMg/r+pZwoHCCjo/2w8Z4s3rq+vE/sGKggvHSQHkdJuab6IIh6pJaSh02WjJ8wC
 jNqXa1dAXc2cyg8HMxv5DYJRwhWWVyozXH4yVOlr0kDCQRa/Q4TPqjtZafSCZjPRbFY6
 kw0b16T5qq4MCAijH0VTp9zB5YM/WnpocFdWGcg0sOfYxw1FlIoHWS1nQYIZNYx3Qlf8
 hrRQXMkTcgTEHyTQ5iO+4JF2evfEqFxK5Cxv8tAqB4nhnNrZmKT1owSxnToU2RSDwnMf Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mesmxd4fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFRj9j005717;
        Tue, 13 Dec 2022 15:44:41 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mesmxd4ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:41 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF01Fn014276;
        Tue, 13 Dec 2022 15:44:39 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mchr71aqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:39 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFic0G2163368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:38 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73BA958058;
        Tue, 13 Dec 2022 15:44:38 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FCC658061;
        Tue, 13 Dec 2022 15:44:37 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:37 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 0/7] improve AP queue reset processing
Date:   Tue, 13 Dec 2022 10:44:30 -0500
Message-Id: <20221213154437.15480-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XZQ9b_nuV_Ulm5p9MGiE1wsaW7sA2ljH
X-Proofpoint-ORIG-GUID: vTHPHg9cmRvLuTFeAAMOY-Kd4joDitx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=771 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

* Always clean up IRQ resources when the ZAPQ response code indicates an
  error.

* Consider reset complete when ZAPQ response code indicates the adapter to
  which a queue is connected is deconfigured. All queues associated with an
  adapter are reset when it is deconfigured. 

Tony Krowiak (7):
  s390/vfio-ap: verify reset complete in separate function
  s390/vfio_ap: check TAPQ response code when waiting for queue reset
  s390/vfio_ap: use TAPQ to verify reset in progress completes
  s390/vfio_ap: verify ZAPQ completion after return of response code
    zero
  s390/vfio_ap: fix handling of error response codes
  s390/vfio_ap: increase max wait time for reset verification
  s390/vfio_ap: always clean up IRQ resources

 drivers/s390/crypto/vfio_ap_ops.c | 106 ++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 33 deletions(-)

-- 
2.31.1

