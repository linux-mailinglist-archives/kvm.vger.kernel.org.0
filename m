Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD65843D7
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiG1QMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiG1QMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:12:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943B83CBD2;
        Thu, 28 Jul 2022 09:12:14 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SFhaAn004230;
        Thu, 28 Jul 2022 16:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=YTJF86K2aF+EwcqsXaPB9tGTnC/ytyDgb/V3NltOci8=;
 b=b2vZd5PeGxgJpwejtp66RYmSUN5OnNTddAaKueqCnZTEUefLtl49M5dIAZ5cWRIsJgNH
 /Z7c1l4RZ3JPgAITAXRXoOtoFyRIHpuvlLHo1Zj27RRp7dLDtf73caPhJ8oB6xRazTK7
 xOSFXBHcXtiFst3X/lPrb8/FQJK65c2xnlNnig5/zoTuMIhPm8hqSBxnUpzyjlmWDdDw
 Sta6oBFC0DxPpyG8F6Ymwpm2Z4ZVXs1+qzwIisFMMYQsdv+mjJEJKS+i+ekQnDjqpKQC
 r7nwRPVE4Y3mfOdnQ9HllOYsEQmGmPt3C/ellAA+z6GizE5V9CX8rFedpLK8GY0wapAe 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkwbh94bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:11 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SFipIm007527;
        Thu, 28 Jul 2022 16:12:10 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkwbh94a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SG6Y5Y019410;
        Thu, 28 Jul 2022 16:12:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3hg94ecytf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SGC5Pq27001226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 16:12:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53E13AE057;
        Thu, 28 Jul 2022 16:12:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40CECAE055;
        Thu, 28 Jul 2022 16:12:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 16:12:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 0F098E0121; Thu, 28 Jul 2022 18:05:52 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/3] vfio-ccw fixes for 5.20
Date:   Thu, 28 Jul 2022 18:05:47 +0200
Message-Id: <20220728160550.2119289-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yOu4J9AA-6hU696Phr7Y8oDCfZSzXy9Z
X-Proofpoint-ORIG-GUID: CvMHrlJskq8SPCXpI9xcdmz3Y-heLulo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 spamscore=0 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxlogscore=711 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207280073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matt, Alex,

Here is an updated series for the DMA UNMAP length problem.
As before, it is built on Alex' vfio-next tree, and contains
two small fixes identified while testing this.

Changelog:
v1->v2:
 - [MR] Rework the boundary checking of page_array_iova_pinned,
   to compare against pfns instead of iovas.
 - [MR] Add r-b to Patch 2 (Thank you!)
 - [EF] (NEW) Noticed a missing return code check in the close routine
v1: https://lore.kernel.org/r/20220726150123.2567761-1-farman@linux.ibm.com/

Eric Farman (3):
  vfio/ccw: Add length to DMA_UNMAP checks
  vfio/ccw: Remove FSM Close from remove handlers
  vfio/ccw: Check return code from subchannel quiesce

 drivers/s390/cio/vfio_ccw_cp.c  | 14 ++++++++++----
 drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
 drivers/s390/cio/vfio_ccw_drv.c |  1 -
 drivers/s390/cio/vfio_ccw_fsm.c |  2 +-
 drivers/s390/cio/vfio_ccw_ops.c |  4 +---
 5 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.34.1

