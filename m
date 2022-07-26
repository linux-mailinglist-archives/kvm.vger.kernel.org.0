Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7C58160E
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbiGZPHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiGZPHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:07:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F6331208;
        Tue, 26 Jul 2022 08:07:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QEq8mF014764;
        Tue, 26 Jul 2022 15:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=S5LEiSZ2oeEjiaVBrD4iyE7vfe1A8bUtxBOupp0TjAE=;
 b=Z7ATU2O6amRdy0ODaNvUK0KT636CQbuZVOQKJMtCgqMrlR/b893D8c2LZqXDqC3MZFnp
 OEh+MipAxVcjGBanoq1ukBOu8fpX3ceLEkqeIx49RBbRFulGF9In6XqlAoFOuFRVYdTN
 0qvJtutZ2jLziWNtJfDTi7bHiN5zBp3C/UW2sUn0wdK/KW5+5oeq3eIH4vnvX971Bd9Q
 751EUfwNSCEKUrEoIWmu6zC/bMcU0ChvQE3FU79I983yBceN2JM3ifXysL7SqnY7wpAN
 RTpHnFo+f8qWuS1T27ex2+w70h/Ma8pjRK5WbNhfn+AgyewL2h+O7y13Clxx/qECFRXu fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjjdn0gqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:07:01 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QErFf5017722;
        Tue, 26 Jul 2022 15:07:01 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjjdn0gpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:07:01 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26QEpVLJ006002;
        Tue, 26 Jul 2022 15:06:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3hg945jy49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 15:06:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QF6uVi19530170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 15:06:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1865AA4054;
        Tue, 26 Jul 2022 15:06:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06AFBA405F;
        Tue, 26 Jul 2022 15:06:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 15:06:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1F2EEE022E; Tue, 26 Jul 2022 17:01:25 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH 0/2] vfio-ccw fixes for 5.20
Date:   Tue, 26 Jul 2022 17:01:21 +0200
Message-Id: <20220726150123.2567761-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UBiytDWKXtKNbu15pLLbP4O3sGGJ6xAn
X-Proofpoint-ORIG-GUID: 1fFfcu2QJTHfrEMp79GsQ8CIdkQ62ZF7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 mlxlogscore=898 malwarescore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207260058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matt, Alex, Jason,

Here's two vfio-ccw patches for 5.20, built on Alex' vfio-next
tree (now that Nicolin's series has landed). One addresses the
DMA unmap problem that was identified last week, and another
was something I stumbled across while testing it.

Hopefully no big surprises in here; look forward to hearing
what you think.

Eric Farman (2):
  vfio/ccw: Add length to DMA_UNMAP checks
  vfio/ccw: Remove FSM Close from remove handlers

 drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++----
 drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
 drivers/s390/cio/vfio_ccw_drv.c |  1 -
 drivers/s390/cio/vfio_ccw_ops.c |  4 +---
 4 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.34.1

