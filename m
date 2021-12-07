Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07B46C5CA
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhLGVE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241675AbhLGVET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:04:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KqXEk014714;
        Tue, 7 Dec 2021 21:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jKstb7eCss79aMNv7G0vE7HmIIDG/1vtHjB1k8mVvO0=;
 b=jdoLaYnbgGWU/S3H/oE4IY0uUiMuWG2IrCaLvLWZ1qYQeKBftnaUbW9mbWyPHo0kYY0K
 v2UOmvB8TeBSROWPasy4QQUABONAd+t+ew/+7ImmRHeBix8BUtpAiwOJRVCVOupoaNYw
 FD3hFI7swFYVGxgoyaSEGNJcZ/jaqmj81akEGfEFKl+zX/3R6mR/7dqmeFrwF3s7DNrn
 dG6FB7zEq7se7UhdoOSqVcESamjDNzRJ8F7ca1ugqK+dEQPz+0fLgIQ4XfnOMhtU4B5A
 qMTUluAl1fiCR5TSoKz/xA29ZQjkkJnUyWAyZW6HGo4pamQm0Eemdb4t5QjbSj+Pq65C Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctf1kr4uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:48 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KqrWA016126;
        Tue, 7 Dec 2021 21:00:48 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctf1kr4ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:48 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvsFN010215;
        Tue, 7 Dec 2021 21:00:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3cqyyamm3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L0jVl20579160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590E2AE06B;
        Tue,  7 Dec 2021 21:00:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6FAAE07E;
        Tue,  7 Dec 2021 21:00:40 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:00:40 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 32/32] MAINTAINERS: additional files related kvm s390 pci passthrough
Date:   Tue,  7 Dec 2021 15:57:43 -0500
Message-Id: <20211207205743.150299-33-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MJuB5npUhDVIgCp3fJHpfDzS68Yym8GG
X-Proofpoint-GUID: qnUP7bOUqbzAVPq7kkfQEM-5-3kAYfTN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=990 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add entries from the s390 kvm subdirectory related to pci passthrough.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 43007f2d29e0..a88f8e4f2c80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16689,6 +16689,8 @@ M:	Eric Farman <farman@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	kvm@vger.kernel.org
 S:	Supported
+F:	arch/s390/include/asm/kvm_pci.h
+F:	arch/s390/kvm/pci*
 F:	drivers/vfio/pci/vfio_pci_zdev.c
 F:	include/uapi/linux/vfio_zdev.h
 
-- 
2.27.0

