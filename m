Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AFA281C75
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJBUBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:01:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725778AbgJBUA4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:00:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092JWNCL044702;
        Fri, 2 Oct 2020 16:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=zf0ZU259TRrG7+1YX6LgQU73KZtpqYoHYvJVqnfbkto=;
 b=nSPGQ5xorGWKG1/QLAHryE2OspGvHofUC8zzzzk00T9NJ6xl8G1thw/iRmaotk0joNi1
 EOPP4+qnlUIibUG4gRJyaBBogA/P8f+QwZRtzrUGPKprZkx5TOZTG565QvZCm2/Ppp8Y
 Xly5agFPHjm4cEUSThs6iBpmWeNvcOXBUefrdasuk07vztjEhRf0MJZVlJ2DpM22XHD7
 W6HQ8dXxaQy0vwKi53RUznAD2k/v/idxTw0MRQ69nLUcYE2s2Y1ZNYuEOTma1fQuVBeC
 czvfbWopXFlHsbkF6gwOWbQVR68RvtOfj17ZIm7rGwpEexE4mJjOQU32Op+Qlf4/AjyH sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x8ufu6kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092Jq85P116123;
        Fri, 2 Oct 2020 16:00:55 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x8ufu6k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:55 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JlEj7006672;
        Fri, 2 Oct 2020 20:00:54 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 33sw9a087y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:00:54 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K0ipj23527824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:00:44 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 171EF6E052;
        Fri,  2 Oct 2020 20:00:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C39F6E058;
        Fri,  2 Oct 2020 20:00:49 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:00:49 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] s390/pci: track whether util_str is valid in the zpci_dev
Date:   Fri,  2 Oct 2020 16:00:41 -0400
Message-Id: <1601668844-5798-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=872 impostorscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need to keep track of whether or not the byte string in util_str is
valid and thus needs to be passed to a vfio-pci passthrough device.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
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

