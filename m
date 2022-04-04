Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889D24F1F8A
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbiDDWyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiDDWxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E60C4BB9C;
        Mon,  4 Apr 2022 15:12:14 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234KdqpB014991;
        Mon, 4 Apr 2022 22:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=3kjsoRjvDKu1C9UwVFFUQn8L7ZFAY2Uoeo9bpzKpFvU=;
 b=puJkS3PwwHs9+a5BbGzMJchmj2QcRlql1glKIMo3smAxn272jPemDmL8Bhq622uX/SGV
 5MuRGokLMjpvtiVd0OfkOpom+y+Vnns2UbCHm7SYhbsPIbhnkncm9LTrn3s59U6FzyLV
 WVnze312uLWkkpzJBadxCrl2iWsth0A9Z3kGvfPNoDUGrBWd90ud2/6TWJzpdXxJvxLP
 WqowLl/6Pu+rqY56ySINKfLQjUwAfK363EPHlzM/FWI6vtFzbM8XPpviI/YrYjZ9Kj9n
 8aEdd9WgwCEKLWr/VOMAJ8u5iZYO3SxKexyGRsI98cwi5oScem/KjF3Bm4sa+sT6Ewk8 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7yn9suap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:11 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234Lso6u008646;
        Mon, 4 Apr 2022 22:12:11 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7yn9sua5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr7o7022045;
        Mon, 4 Apr 2022 22:12:09 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3f6e49jna0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:09 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MC8ed20709878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:12:08 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5C4E7805C;
        Mon,  4 Apr 2022 22:12:08 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DF278064;
        Mon,  4 Apr 2022 22:12:07 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:12:07 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 20/20] MAINTAINERS: pick up all vfio_ap docs for VFIO AP maintainers
Date:   Mon,  4 Apr 2022 18:10:39 -0400
Message-Id: <20220404221039.1272245-21-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: woP7XXwf4ME31OJ9cz50tOPGt5H-uEbr
X-Proofpoint-ORIG-GUID: yV7AEDOTAkoCva4P7b5tEsPb9IUNyDig
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=943 spamscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204040123
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
 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd768d43e048..c8d8637c184c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17239,8 +17239,10 @@ M:	Jason Herne <jjherne@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-F:	Documentation/s390/vfio-ap.rst
-F:	drivers/s390/crypto/vfio_ap*
+F:	Documentation/s390/vfio-ap*
+F:	drivers/s390/crypto/vfio_ap_drv.c
+F:	drivers/s390/crypto/vfio_ap_ops.c
+F:	drivers/s390/crypto/vfio_ap_private.h
 
 S390 VFIO-CCW DRIVER
 M:	Eric Farman <farman@linux.ibm.com>
-- 
2.31.1

