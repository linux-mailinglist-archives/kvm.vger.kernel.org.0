Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D976514EEEF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgAaPCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:02:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729111AbgAaPCT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:02:19 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF0JQl143129
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:18 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xv7e2x7d8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:17 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:13 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:11 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF2ADH43778388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:02:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 404BD5205A;
        Fri, 31 Jan 2020 15:02:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 375CB52059;
        Fri, 31 Jan 2020 15:02:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D8664E03BC; Fri, 31 Jan 2020 16:02:09 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 05/12] s390x: sclp: fix error handling for oversize control blocks
Date:   Fri, 31 Jan 2020 16:02:00 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150207.73127-1-borntraeger@de.ibm.com>
References: <20200131150207.73127-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0016-0000-0000-000002E28F26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0017-0000-0000-000033455F22
Message-Id: <20200131150207.73127-6-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Requests over 4k are not a spec exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Message-Id: <1569591203-15258-4-git-send-email-imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 hw/s390x/sclp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 73244c938b10..abb6e5011f9c 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -213,8 +213,7 @@ int sclp_service_call(CPUS390XState *env, uint64_t sccb, uint32_t code)
     cpu_physical_memory_read(sccb, &work_sccb, sccb_len);
 
     /* Valid sccb sizes */
-    if (be16_to_cpu(work_sccb.h.length) < sizeof(SCCBHeader) ||
-        be16_to_cpu(work_sccb.h.length) > SCCB_SIZE) {
+    if (be16_to_cpu(work_sccb.h.length) < sizeof(SCCBHeader)) {
         r = -PGM_SPECIFICATION;
         goto out;
     }
-- 
2.21.0

