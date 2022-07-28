Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6322258474B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiG1U5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiG1U5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:57:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A970E55;
        Thu, 28 Jul 2022 13:57:12 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKg6v4013246;
        Thu, 28 Jul 2022 20:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=CkA1m41JwSpgtRVk/eWbFUzksZzPXa269bZv9KOwmOk=;
 b=pJREUOwb4UrpmbtGFvGxV4BknNIXZMwTjp6NP3LKx4zEvNAcfQ4KK58yBiwDWkRTzty4
 uFi+0bemzkQkI5/mql4XFjhC7SE8t1ppDQc7UpPazvil3We2tlDI8elWxbAPhrweprZA
 Wn0LzU3KMEYLbB3/SY969r3hbmWR8ZhjI0Si5uKi9wdouqsKrS8whY5IkceXb7NKHVUT
 fvNfX+fh3Yy+S3PcmMvXlJwnMjQ32jJUuoaMDEkCTMgYiXRdF9TdN0Dy6a5b3a+F9yR1
 /Mc/HPsJNR6YXSLta2CCzPM/VsKA2uD2U5G/+KubbqoBLbNRT6st5LRqxXuj2ugJgsb4 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1qfrc03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SKgAbP013902;
        Thu, 28 Jul 2022 20:57:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1qfrby4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SKpblj027078;
        Thu, 28 Jul 2022 20:57:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3hg945n4ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SKt0DU34210212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 20:55:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DEADA405B;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B6C6A4054;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 07613E0911; Thu, 28 Jul 2022 22:49:16 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 0/3] vfio-ccw fixes for 5.20
Date:   Thu, 28 Jul 2022 22:49:11 +0200
Message-Id: <20220728204914.2420989-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j_Ep8N1b0tBleLGDB2JxgX0hTMjJLaLR
X-Proofpoint-GUID: 1RZ6RSP1cHUTP7YjTi4PxdiU2BsCAnk2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=869
 mlxscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matt, Alex,

Here are the (hopefully last) patches for the DMA UNMAP thing.

Changelog:
v2->v3:
 - [MR] Add r-b to Patch 1, 3 (Thank you!)
 - [MR] s/unsigned long/u64/
 - [EF] Add brackets to for(i) loop
v2: https://lore.kernel.org/r/20220728160550.2119289-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/r/20220726150123.2567761-1-farman@linux.ibm.com/

Eric Farman (3):
  vfio/ccw: Add length to DMA_UNMAP checks
  vfio/ccw: Remove FSM Close from remove handlers
  vfio/ccw: Check return code from subchannel quiesce

 drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++++++-----
 drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
 drivers/s390/cio/vfio_ccw_drv.c |  1 -
 drivers/s390/cio/vfio_ccw_fsm.c |  2 +-
 drivers/s390/cio/vfio_ccw_ops.c |  4 +---
 5 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.34.1

