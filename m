Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE73665D762
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 16:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbjADPmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 10:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjADPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 10:42:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829381B1D0;
        Wed,  4 Jan 2023 07:42:10 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FBjxC035752;
        Wed, 4 Jan 2023 15:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hzdIPsHOHJXcUVKMFhjURC+BqA8lXi2B5863P44BNdA=;
 b=DEgmcK/ndJtCzUiprBCpwIJaReDsv/3xsFUB60kl0LPoykWeB1XEKUk53rtE7ICPjxho
 EHTR7UCeBwdRS+8+A8C55TupJvQo1TxpTxV3qZ1R9pyBsDjIOGbOQ+pj8jLC9AG0HfEK
 wbMRU7SBeeEI81EvH08Ad53V6C8bFAowlBC/WJhCgZ3Hr1hNxc/f/oVz71rMMaOtiZym
 CTtgAafa3jCcqX2A42yPi5MgTeSIjLkvM22C9ytrXlsoH6r/pG05IzbDb62LXCqR2kL+
 Bc2PVqOCP3zL+r5aMdd64SdW1mB2qwnbKxVaUzZpIbjNARuAbNXLTQsWQ9jn9G3lixjD AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwbvr0s8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:09 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304Fg9EZ029613;
        Wed, 4 Jan 2023 15:42:09 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwbvr0s7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3049ctYr009626;
        Wed, 4 Jan 2023 15:42:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mtcbfm261-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:06 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304Fg3gl51183980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 15:42:03 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D58F2004D;
        Wed,  4 Jan 2023 15:42:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9BD220043;
        Wed,  4 Jan 2023 15:42:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 15:42:02 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH v2 0/1] vfio/type1: Fix vfio-pci pass-through of ISM devices
Date:   Wed,  4 Jan 2023 16:42:01 +0100
Message-Id: <20230104154202.1152198-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sys2aJXcLW9NJ81VHPID0KbvzNk8qQY2
X-Proofpoint-GUID: OGdhn91Kk3zCE4EVPHFMicgyoLVfqx1u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301040130
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

This is v2 of my attempt of fixing an issue we have on s390 with vfio-pci
pass-through of the s390 specific virtual PCI device called ISM and used for
cross LPAR communication. As the patch tries to explain the fact that
vfio_test_domain_fgsp() uses an IOMMU mapping at IOVA 0 irrespective of any
reserved regions causes the ISM device to go into an error state and thus
becomes unusable for a KVM guest breaking pass-through. I tried to improve
the background and explanation compared to v1 hope its more clear now.

As for testing, I tested this based on current master on both on s390 where it
skips the reserved 0x0-0x100000000 range and on an AMD Ryzen 3990X where it
continues to do the test on DMA address 0 and sets domain->fgsp to true.

Thanks,
Niklas Schnelle

Changes since v1:
- Reworded commit message to hopefully explain things a bit better and
  highlight that usually just mapping but not issuing DMAs for IOVAs in
  a resverved region is harmless but still breaks things with ISM devices.
- Added a check for PAGE_SIZE * 2 alignment (Jason)

Niklas Schnelle (1):
  vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

-- 
2.34.1

