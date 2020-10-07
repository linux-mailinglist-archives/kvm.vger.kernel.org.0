Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB5E2867D0
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgJGS4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:56:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgJGS4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 14:56:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097IgHqd175165;
        Wed, 7 Oct 2020 14:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6cXZwO8A8fyHd2UtZgce3b4fdQtfCWWjVkpW0lKi17s=;
 b=pkigKMo3bYGso6n0tnRbmGqRjMMqbx/aReiU9nRvtJF6V94SoWjNPQPyPg8T1WCJ1x/U
 WWWvHJkVWgJfClxRrEqxsx4oeOZdxL6eZ3JDna4RO1dkIjSrVN3wrwlyAWtZhaIVEI6B
 giPI8puZeN9g8ddpfmzRNZ0+F8a+dxAe4s9zfObc+dHEc69H8o+CCrVw1p1DVdgZFdBW
 KAuj210Gwj2sI9S/s4DDhRI1gLbbuTzW+XI13N+XDS+Fq8+tS2RLjEKrpykQ/YVAblsG
 tveWe2PxtNHFgcy3uJh68KpmFBm3vyw+rEMiPs/uCa98GNfOensvzvrDku0QJOJWCK56 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341k6cgbct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:35 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097IgFOw175057;
        Wed, 7 Oct 2020 14:56:35 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341k6cgbcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:34 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IkiG6025460;
        Wed, 7 Oct 2020 18:56:34 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 33xgx9h8jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 18:56:34 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097IuQ3M53739810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 18:56:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C8787805F;
        Wed,  7 Oct 2020 18:56:31 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67A337805C;
        Wed,  7 Oct 2020 18:56:29 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 18:56:29 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] s390/pci: track whether util_str is valid in the zpci_dev
Date:   Wed,  7 Oct 2020 14:56:21 -0400
Message-Id: <1602096984-13703-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 phishscore=0 mlxlogscore=874 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need to keep track of whether or not the byte string in util_str is
valid and thus needs to be passed to a vfio-pci passthrough device.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/include/asm/pci.h | 3 ++-
 arch/s390/pci/pci_clp.c     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 882e233..fa1fed4 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -132,7 +132,8 @@ struct zpci_dev {
 	u8		rid_available	: 1;
 	u8		has_hp_slot	: 1;
 	u8		is_physfn	: 1;
-	u8		reserved	: 5;
+	u8		util_str_avail	: 1;
+	u8		reserved	: 4;
 	unsigned int	devfn;		/* DEVFN part of the RID*/
 
 	struct mutex lock;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 48bf316..322689b 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -168,6 +168,7 @@ static int clp_store_query_pci_fn(struct zpci_dev *zdev,
 	if (response->util_str_avail) {
 		memcpy(zdev->util_str, response->util_str,
 		       sizeof(zdev->util_str));
+		zdev->util_str_avail = 1;
 	}
 	zdev->mio_capable = response->mio_addr_avail;
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-- 
1.8.3.1

