Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49187440E20
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhJaMNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhJaMNp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VC7xJC006827;
        Sun, 31 Oct 2021 12:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=o1AkJoilHF3dOOK4p/fmawOniW07Ur2RQ9zkgppLfu4=;
 b=cSBiwgH7QmlnsTp6n32Pj9BefnMEY+neQ0+wbDmNH5hVFLsLmdsuzkPa49PsBgF5EgaP
 fvkZ1rwVMf8BPbSHWfNcMjJI7U0qOKfIudcB6AwZgIUIDdDIzC2mYhcSVz2RDaf1Ka2H
 GSUbTnsajJvBWnJ7Opx9S02bm19dOcIrZZCJ1hhPEJNXSGFcNMTXDE65pqjOpEHH/vXX
 6Kr9WC39iHLvmWxeIVK7TmyGt4Zwb2v+JBqBY+XkdSBJMRt2zTVf817XKawPgfqR8Iwl
 TPpSxcMoijL9uOD0c6jVkJu6DXC6EEMNsxsVpiBO+9nhpe1TRIQXrtcImlO+iqCF7o3b Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1s75s1kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:14 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCBDeY018445;
        Sun, 31 Oct 2021 12:11:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1s75s1kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9L0C006431;
        Sun, 31 Oct 2021 12:11:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3c0wp957uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:11 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB8Lc49938788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04CD652051;
        Sun, 31 Oct 2021 12:11:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id E6E6B5204E;
        Sun, 31 Oct 2021 12:11:07 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A5B49E056B; Sun, 31 Oct 2021 13:11:07 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 09/17] KVM: s390: pv: add macros for UVC CC values
Date:   Sun, 31 Oct 2021 13:10:56 +0100
Message-Id: <20211031121104.14764-10-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VAWCcq6k5hkRd0r_IGf6vvfB05lmYvta
X-Proofpoint-ORIG-GUID: q6jR_HDc4cf3BIKw9EjDpI6L93RWuJ2X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=874 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add macros to describe the 4 possible CC values returned by the UVC
instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210920132502.36111-2-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/uv.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index fe92a4caf5ec..9ab1914c5b95 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -18,6 +18,11 @@
 #include <asm/page.h>
 #include <asm/gmap.h>
 
+#define UVC_CC_OK	0
+#define UVC_CC_ERROR	1
+#define UVC_CC_BUSY	2
+#define UVC_CC_PARTIAL	3
+
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
 #define UVC_RC_INV_STATE	0x0003
-- 
2.31.1

