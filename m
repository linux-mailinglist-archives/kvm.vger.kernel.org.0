Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E14E79E899
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbjIMNHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 09:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjIMNHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 09:07:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4275219B4;
        Wed, 13 Sep 2023 06:07:05 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DD3qjf019307;
        Wed, 13 Sep 2023 13:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0PW8J0jqS3NWJDC4hhYOTOy1L3EEUPTYe5GhYHkYhc8=;
 b=Bqf4ra9YG0NUxECLWgYemDf6mNDYVXNKZ08oFHeZV5rANYQuQPpBTpKOmDOqGqGQZWaD
 vm28JzZXCvCp8DTGAd1Kr8fOB5acbTLOXVT/u5zdUrMYwbyWPTK1zQiF5Yoolfcg92hp
 M0vgY5HU0ZB6NhU/aU17ufdD6TdZJiGUPiy3AP7ejZyv46Tt6e1OE/B8vM8xUoxNXvjH
 KqZ3nhxqcXeP69UUZmqU2gEAWi+52lkwHMu18oW4Ucfw0ArXrPD0XAOyXdeTVPfMH045
 W4lobyZfYlbhAHl0oy4x5Hn0ruKw77ccK3EhxfEekWLAcCUPfIvW2jS3OpxyerrqMkm9 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3d3qs68t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:07:03 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DCc9Gf002970;
        Wed, 13 Sep 2023 13:06:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3d3qs61g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:38 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DBhrfF024103;
        Wed, 13 Sep 2023 13:06:29 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t131tbk9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:29 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DD6SKC63635890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 13:06:28 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AA1758057;
        Wed, 13 Sep 2023 13:06:28 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FF1058058;
        Wed, 13 Sep 2023 13:06:27 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.101.13])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 13:06:27 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: [PATCH 0/2] a couple of corrections to the IRQ enablement function
Date:   Wed, 13 Sep 2023 09:06:20 -0400
Message-ID: <20230913130626.217665-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fiu6_inD9PswxEmSo8iS9ZVuh0ENmY7M
X-Proofpoint-ORIG-GUID: hANl24CrnL8LvlEcVuntdb3oX2BTV0c8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_06,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=930 lowpriorityscore=0 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2309130101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series corrects two issues related to enablement of interrupts in 
response to interception of the PQAP(AQIC) command:

1. Returning a status response code 06 (Invalid address of AP-queue 
   notification byte) when the call to register a guest ISC fails makes no
   sense.
   
2. The pages containing the interrupt notification-indicator byte are not
   freed after a failure to register the guest ISC fails.

Anthony Krowiak (2):
  s390/vfio-ap: unpin pages on gisc registration failure
  s390/vfio-ap: set status response code to 06 on gisc registration
    failure

 drivers/s390/crypto/vfio_ap_ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.41.0

