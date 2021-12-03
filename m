Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C13467C03
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382462AbhLCRCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:02:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382251AbhLCRB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GlUrY007617;
        Fri, 3 Dec 2021 16:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sN7ig15cTuudwMhjSIMPGl7CzWlQaYl4qV5UPqKOS2s=;
 b=IpV/KYlNHd6yaZ21NyYGwvxtlkYnA3dJZGLtzVXj8N89/PCCQd/9uiU1QExLOKGvU65I
 3aqtMJPLSHY0VcjsAzXnED/EhAVOsobemvzldtvFOsZhjF34cgyndsI4KTjEpPgzW0Rz
 e3rBTl4Qo/Swy5I7JrsIQh4Iu3e8M4BjEHbUk6pXuCPNSkVmGtvi02ZTaPIV6EV9OCzD
 bzUNaJvSsmGsvWDfZh2jIQULaX4wFL4P+JIJuqJ3kGCtQKsneJPtoERIFG2nYYDEFW1p
 YcQx8nhuWHbdFqVGrtEtnDLKISdrD88QkLZg2bZcXgd789YSEPpIyG+SQqBzX25zrpA1 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2qr5ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3Gn9Bj014194;
        Fri, 3 Dec 2021 16:58:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2qr5tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Gv4B8014034;
        Fri, 3 Dec 2021 16:58:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ckcadfrx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwPVH30867828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AD645204E;
        Fri,  3 Dec 2021 16:58:25 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E288F52057;
        Fri,  3 Dec 2021 16:58:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 17/17] KVM: s390: pv: avoid export before import if possible
Date:   Fri,  3 Dec 2021 17:58:14 +0100
Message-Id: <20211203165814.73016-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yvkz6aRIeorxeMs7fqmIuV6wLBZHuPxP
X-Proofpoint-ORIG-GUID: 1kyTWO5bzS4nyGnGD7R4QWG6GsgkS1ei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the appropriate UV feature bit is set, there is no need to perform
an export before import.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ec01c3f8b13c..a29c7b3085b1 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -236,7 +236,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 
 static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
 {
-	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
+	return !test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
+		uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
 		atomic_read(&mm->context.protected_count) > 1;
 }
 
-- 
2.31.1

