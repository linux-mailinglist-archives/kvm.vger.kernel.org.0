Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A9D349335
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 14:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCYNmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 09:42:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230095AbhCYNmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 09:42:04 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PDWjXn009630;
        Thu, 25 Mar 2021 09:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version; s=pp1;
 bh=s+fdqLXlJZN9zhPNr5jqz7cIFYyY/irUMYt684eSHV4=;
 b=gyLV1z8WOcYoWNPuuqp9AcmDYVkKawEGR7I5no/gTmhUyvbC6EwsO7TDCpVMMJl1LaUu
 UpO5e8iekMzvKm6woOysu3nQtMeDoIzIq3SrrHRGSXjbv/NceJ5y/+CjL4OQxf/D5gLg
 W69hwvKE83ymCMizesX3AGdT5WQucWKjH6uIepS0Rkc6D9PDMKIUkGrcrpaEmUu+GYYR
 +r7MVO17RhzC++Vb+NlFyTfe7guQJFaCCUi69HVHy3BME7RBzI2GY7SYTfXCGV9kuNbu
 CvZTkLfzEESiGmvDfr1tiii9LDoKUvX+dw1m0ZOCfwAU9uLTTOwS60jh+CLHSxdSaj4/ aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ggpksab7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:42:02 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PDYweK023607;
        Thu, 25 Mar 2021 09:42:01 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ggpksaax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:42:01 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PDbQin031411;
        Thu, 25 Mar 2021 13:42:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 37d9dae0fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 13:42:00 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PDfxLu19530020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 13:41:59 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7697FAC05F;
        Thu, 25 Mar 2021 13:41:59 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DAC2AC059;
        Thu, 25 Mar 2021 13:41:56 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.67.166])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 13:41:56 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, farman@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, cohuck@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, alex.williamson@redhat.com
Subject: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
Date:   Thu, 25 Mar 2021 09:41:52 -0400
Message-Id: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_03:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 clxscore=1011 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103250101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
and replace the backup for vfio-ap as Pierre is focusing on other
areas.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e87692..68a5623 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15634,8 +15634,8 @@ F:	Documentation/s390/pci.rst
 
 S390 VFIO AP DRIVER
 M:	Tony Krowiak <akrowiak@linux.ibm.com>
-M:	Pierre Morel <pmorel@linux.ibm.com>
 M:	Halil Pasic <pasic@linux.ibm.com>
+M:	Jason Herne <jjherne@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -15647,6 +15647,7 @@ F:	drivers/s390/crypto/vfio_ap_private.h
 S390 VFIO-CCW DRIVER
 M:	Cornelia Huck <cohuck@redhat.com>
 M:	Eric Farman <farman@linux.ibm.com>
+M:	Matthew Rosato <mjrosato@linux.ibm.com>
 R:	Halil Pasic <pasic@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	kvm@vger.kernel.org
@@ -15657,6 +15658,7 @@ F:	include/uapi/linux/vfio_ccw.h
 
 S390 VFIO-PCI DRIVER
 M:	Matthew Rosato <mjrosato@linux.ibm.com>
+M:	Eric Farman <farman@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	kvm@vger.kernel.org
 S:	Supported
-- 
1.8.3.1

