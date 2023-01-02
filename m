Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A4265AEB8
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 10:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjABJfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 04:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjABJfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 04:35:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D094A3898;
        Mon,  2 Jan 2023 01:34:59 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3025MRCG022970;
        Mon, 2 Jan 2023 09:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ddP5q66i/12v8EQc0U4gwr/x0xY5pITKs1O1r42nYFg=;
 b=qXZVCPdN+BXLvm6Y8HRwnYhc5/DEuqpeGACe8IjoPZPY3ABqm4POYz334a/P0wvBrbGJ
 EErEpEyA7NkzEMomS5fZM0gFnJP7X+QWjIzRK3DlpyrSgFeAeqcRrSNWDcVrMJd+zBBn
 1qlk7Zmr9V0kIDlop3kmILQJ5qoB5h5B1CFys01Lubbp/i8dHZ5GBl3UQxlC0C8dz0yh
 vXrzequuoqkeZcDzrgT4fSnhkr6k3d3DfgaplL+BfJCNitzJFmZaReJDhvSin4k3ZmSL
 xzNd2Ph7E8VN4R1pYFD+q1r7oNPy5ng7+6Ag5x+rwIYnNmznPgzVG6DWgYj7CLvGtDqp zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mtxnqwr18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:58 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3029Pacb004783;
        Mon, 2 Jan 2023 09:34:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mtxnqwr0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3029OvOU004235;
        Mon, 2 Jan 2023 09:34:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6hmxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3029Yqie43188530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Jan 2023 09:34:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9039A2004B;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BCE920043;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH 0/1] vfio/type1: Fix vfio-pci pass-through of ISM devices
Date:   Mon,  2 Jan 2023 10:34:51 +0100
Message-Id: <20230102093452.761185-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -z9M2Ix92QaTuiIfZD1cMZNoiVOgTmAi
X-Proofpoint-GUID: 8OpXm3nV8b6YMWYCUPC4XIURxRC8t9kh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-02_05,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=711 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301020086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain aperture
shrinking") the s390 IOMMU driver uses a reserved region instead of an
artificially shrunk aperture to restrict IOMMU use based on the system provided
DMA ranges of devices. While this is more aligned with the common code use
of apertures and reserved regions it turns out this currently breaks vfio-pci
pass-through of our special virtual ISM PCI device. Investigation showed that
this is due to vfio_test_domain_fgsp() ignoring the IOMMU reserved regions and
mapping IOVA address 0 even if that falls within a reserved region. Thus
I propose the below patch to make vfio_test_domain_fgsp() find a region to do
its mapping test instead of blindly using IOVA 0. 

I did post the below patch independently already on December 22 but the subject
wording didn't make it clear that this fixes a real problem and of course the
holidays contribute to making things easier to miss so I wanted to post again
with a bit more background and a more catchy/clear subject on the cover letter.

As for testing, I tested this based on current master on both on s390 where it
skips the reserved 0x0-0x100000000 range and on an AMD Ryzen 3990X where it
continues to do the test on DMA address 0 and sets domain->fgsp to true.

Thanks,
Niklas Schnelle

Niklas Schnelle (1):
  vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

 drivers/vfio/vfio_iommu_type1.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

-- 
2.34.1

