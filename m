Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86F07170C3
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjE3Wfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjE3Wfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:35:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C7C9;
        Tue, 30 May 2023 15:35:44 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UM8sf9032181;
        Tue, 30 May 2023 22:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tPYaKnQ7SMeZMYNrdYpQjkUth4bn7YaBwUTTakG0I28=;
 b=TBIwU7MrsLFOu71rmwwnJ3U+7Z04zvqSN20Mc0Q1RNyVdIVlG7YmRJggQulPG4QyiKkU
 E1++GnAv8Pk4n7UBciKHLp453poQ4FkuqIMiFLKMc341VMpy2/eO+7rWQuZ1WvMdW1u8
 miItCqE21bF2B6YzDdA/v2hBVfqY9IzImWeJsF4ZLmNMYkQoBHRLgmUmj/8jfGrPummY
 A1JbgnDASTuiIrKlHkLTuK3/MW5vlTij7TmcrB7vPaTbYNrACvMhbJ6eSatEbjLmc+bZ
 rZrEBnESW1JhiBvVF2ZPcCrL4Um7mjas3livjOXN5l09BkWb3nI8q6Df0Xh9bpBuAgDo Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwj0enmgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:43 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UMZher008241;
        Tue, 30 May 2023 22:35:43 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwj0enmgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:43 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UKQoHc019395;
        Tue, 30 May 2023 22:35:42 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3qu9g6j2sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:42 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UMZeow30212410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 22:35:40 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3C3158101;
        Tue, 30 May 2023 22:35:40 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 155DC580FE;
        Tue, 30 May 2023 22:35:40 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.88.233])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 22:35:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
Subject: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest is removed
Date:   Tue, 30 May 2023 18:35:35 -0400
Message-Id: <20230530223538.279198-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vtBORcWIpYCeH2bpLuDBXRoXujzL3okF
X-Proofpoint-ORIG-GUID: nBEDf3-TsGvbdbg9OoU24RJMHIgrjvad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0
 adultscore=0 clxscore=1011 mlxlogscore=932 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300184
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a user attempts to remove a vfio-ap mediated device attached to a
guest, the operation hangs until the mdev's fd is closed by the guest
(i.e., the hostdev is detached or the guest is shut down). This patch 
series provides kernel-side code that allows userspace to set up a 
communication channel that will allow the vfio_ap device driver to notify 
userspace when a request to release the mdev is received, so that userspace
can close the mdev fd and avoid the hang. The patch series provides the 
following:  

1. Introduces code to handle the VFIO_DEVICE_GET_IRQ_INFO and 
   VFIO_DEVICE_SET_IRQS ioctl calls to set the eventfd_ctx for signaling a
   device request to userspace. 

2. Wires up the VFIO bus driver callback to request a release of the mdev.
   When invoked, the vfio_ap device driver will use the eventfd_ctx set up
   in #1 to signal a request to userspace to release the mdev.


Note:
----
If a user subsequently attempts to restart the guest or re-attach the mdev,
the operation will fail with a message indicating the domain is already
active. This is a libvirt problem resolved with the following commit:

commit ebd004a03dbd ("security: do not remember/recall labels for VFIO 
MDEVs") 

Tony Krowiak (3):
  vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
  vfio: ap: realize the VFIO_DEVICE_SET_IRQS ioctl
  s390/vfio-ap: Wire in the vfio_device_ops request callback

 drivers/s390/crypto/vfio_ap_ops.c     | 134 +++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |   3 +
 include/uapi/linux/vfio.h             |   9 ++
 3 files changed, 145 insertions(+), 1 deletion(-)

-- 
2.31.1

