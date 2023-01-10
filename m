Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF09D664664
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbjAJQom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjAJQof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:44:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00A5133B;
        Tue, 10 Jan 2023 08:44:34 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AFsx4p008198;
        Tue, 10 Jan 2023 16:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Mm7QiQfcrQlNd7aT1hRWE0ugWylBhxP28PV93dzYYoU=;
 b=EJZEVBUm3trPACAm/3U9Vs4ue8TxyysUTVDuTMAJsz6Kwhr2/8SDB5qkMu19nTNEdeqU
 w1eARs6n+m3us13rTe8ibxdsArVhEzSuFQ7MjUsswhsa6j9xa4IUYbg+EwtKN6A+7zfY
 qThSLI2Dbr7Y4iIKaOb9VPefpVBl2P7g8EgBsTImUhtnqm0xkahhF3J7PgxJsLQ5fQW2
 YzlQ9kx9I8iWhgAZynsvtcaRp+KAI1CkXX3kQvbyHvvYpkFwzbq5YVFIbvtji7jbAbUa
 O8XadmLNIorzvtyHLkTNRkRso5u/z4dwP3Xjw6rNvd1v4wxQkJzGf52XNNYVnE+MmGGd OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1b339dc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AFu1Ft012082;
        Tue, 10 Jan 2023 16:44:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1b339dbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30A83ahp014076;
        Tue, 10 Jan 2023 16:44:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3my00fn750-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AGiRVM51511614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:44:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC3D82004F;
        Tue, 10 Jan 2023 16:44:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC0A20043;
        Tue, 10 Jan 2023 16:44:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 16:44:27 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH v3 0/1] vfio/type1: Fix vfio-pci pass-through of ISM devices
Date:   Tue, 10 Jan 2023 17:44:26 +0100
Message-Id: <20230110164427.4051938-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hWDIigv2QrdBU7DJ_jTp_MdeZKvfnCnq
X-Proofpoint-ORIG-GUID: qWBQ2p0Jec6qGatUywr1X1RA7NBi3YaU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes since v2:
- Don't require region->start to be aligned but instead just that we can fit an
  aligned allocation (Alex)
- Use Fixes tag for the introduction of reserved regions as that came
  after the fine grained super pages test (Alex)

Changes since v1:
- Reworded commit message to hopefully explain things a bit better and
  highlight that usually just mapping but not issuing DMAs for IOVAs in
  a resverved region is harmless but still breaks things with ISM devices.
- Added a check for PAGE_SIZE * 2 alignment (Jason)


Niklas Schnelle (1):
  vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

-- 
2.34.1

