Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825C85979D6
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 00:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbiHQWww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 18:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiHQWwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 18:52:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92CCA0250;
        Wed, 17 Aug 2022 15:52:49 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27HMkSSQ014913;
        Wed, 17 Aug 2022 22:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3CkJreVjrSgeZEk74TyQB/PsrVK9ZT+3QKeZw0DEaI8=;
 b=CXGvHrQmco/KnJmSTMO8TckNSJCM0/ytWq2gvqFE5tR3UZitYpDYLmfMFw6iUh3ze/P8
 KbWQMBhb24qgP2S7Ai926sGSYxIM7reeIF9HqMfRBN/UC1z5wL8zIdf3LXLQizn6/SLZ
 ZdW1Q1+iDrQpLQCLgBbqVzOd2TvbAWoAb9NgYNAn6qdCQoVkZfLBkWUmlnUm8Aj/YRIW
 LQTnKq4DD8hHubWxyF4IACU3ieTMypXYK6JqUx+4jeUq8LZDUW6NW5+tlFhGBYixw4Op
 K9AjZdXq6EhQONEOVUyQOnlIfSFvECGXKW8rqk5BgLCushH1O3I/mmNRbvonktYgvTAJ Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j19dpg3gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:47 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27HMnloK026173;
        Wed, 17 Aug 2022 22:52:47 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j19dpg3g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:47 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27HMoiUt016850;
        Wed, 17 Aug 2022 22:52:45 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 3hx3k9udac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:45 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27HMqifi49742326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 22:52:45 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF9B6A04D;
        Wed, 17 Aug 2022 22:52:44 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D989D6A054;
        Wed, 17 Aug 2022 22:52:43 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.118.205])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 22:52:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: [PATCH 0/2] s390/vfio-ap: fix two problems discovered in the vfio_ap driver
Date:   Wed, 17 Aug 2022 18:52:40 -0400
Message-Id: <20220817225242.188805-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QgoTigFlPqRoTzluZDWZCrW6C58VFvmG
X-Proofpoint-ORIG-GUID: OawyeiUl_RsGTzP2pdN7E5wi07IVWXe6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_15,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208170084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two problems have been discovered with the vfio_ap device driver since the
hot plug support was recently introduced:

1. Attempting to remove a matrix mdev after assigning a duplicate adapter
   or duplicate domain results in a hang.

2. The queues associated with an adapter or domain being unassigned from
   the matrix mdev do not get unlinked from it.

Two patches are provided to resolve these problems.

Tony Krowiak (2):
  s390/vfio-ap: fix hang during removal of mdev after duplicate
    assignment
  s390/vfio-ap: fix unlinking of queues from the mdev

 drivers/s390/crypto/vfio_ap_ops.c | 36 +++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.31.1

