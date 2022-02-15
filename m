Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302224B5F8D
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiBOAwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:52:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiBOAvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50047145624;
        Mon, 14 Feb 2022 16:51:09 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ENG4Kf017282;
        Tue, 15 Feb 2022 00:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=RSgTsmlZi+lR1QYv4S4YxGqvAN5AgPHUPs3Bm24XbzE=;
 b=HGgmqS6XjZtEDZGjSKmQw9TdAJJH7JTz3RMw9COVQqaLJxk1tVGY8S6RpEAu76h3OTV9
 qnI+EvEjTrLcV4nMHciNGNnxN7uKkSV/cHePaHuqgf/vq5Xx+RvaAqn2VpO1TjLtU7UM
 yQgmBwOI7kRDcRFIrFz1pZfLgT5IrtPpdDYz01LR461CB2OISXm2pmSy2+zg5sLIUNFC
 0C8adWvV6og8pci0So7jHDf707971OIZ3NhrFzUxoPO3O57l6c0itpcSnMJ24NqrVZpL
 u5JAJQ8s1hEd7Tq5IMrZHcnZSqF122+nEigk1567SJnho+bUB3MuwdDoZLYyVvgqf/jV EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785th6pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:51:01 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0gfvh014155;
        Tue, 15 Feb 2022 00:51:01 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785th6pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:51:01 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g5Oi021487;
        Tue, 15 Feb 2022 00:51:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3e64hbfhtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:51:00 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0ox2q35520966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:59 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04FBD124053;
        Tue, 15 Feb 2022 00:50:59 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3460A124052;
        Tue, 15 Feb 2022 00:50:58 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:58 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 18/18] MAINTAINERS: pick up all vfio_ap docs for VFIO AP maintainers
Date:   Mon, 14 Feb 2022 19:50:40 -0500
Message-Id: <20220215005040.52697-19-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BgnRGc88S4ucZvJFhB5Laz3tufIQSci8
X-Proofpoint-ORIG-GUID: vo5-CDbKvNgn4uvFZWBgoxjGYeiNT0fb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=979
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new document, Documentation/s390/vfio-ap-locking.rst was added. Make sure
the new document is picked up for the VFIO AP maintainers by using a
wildcard: Documentation/s390/vfio-ap*.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fca970a46e77..ece0968f9fa4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16908,7 +16908,7 @@ M:	Jason Herne <jjherne@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-F:	Documentation/s390/vfio-ap.rst
+F:	Documentation/s390/vfio-ap*
 F:	drivers/s390/crypto/vfio_ap_drv.c
 F:	drivers/s390/crypto/vfio_ap_ops.c
 F:	drivers/s390/crypto/vfio_ap_private.h
-- 
2.31.1

