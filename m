Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9C9C21C0
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfI3NUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731089AbfI3NUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDIGJR134011
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:04 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vbjd70bra-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:03 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:01 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:19:58 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJSFG29360536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05B2C11C04C;
        Mon, 30 Sep 2019 13:19:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E419711C04A;
        Mon, 30 Sep 2019 13:19:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 Sep 2019 13:19:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A5A91E01C8; Mon, 30 Sep 2019 15:19:56 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 04/12] s390x: sclp: boundary check
Date:   Mon, 30 Sep 2019 15:19:47 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-4275-0000-0000-0000036C8D84
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-4276-0000-0000-0000387F14A9
Message-Id: <20190930131955.101131-5-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=869 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

All sclp codes need to be checked for page boundary violations.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Message-Id: <1569591203-15258-3-git-send-email-imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 hw/s390x/sclp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 95ebfe7bd2f1..73244c938b10 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -234,6 +234,11 @@ int sclp_service_call(CPUS390XState *env, uint64_t sccb, uint32_t code)
         goto out_write;
     }
 
+    if ((sccb + be16_to_cpu(work_sccb.h.length)) > ((sccb & PAGE_MASK) + PAGE_SIZE)) {
+        work_sccb.h.response_code = cpu_to_be16(SCLP_RC_SCCB_BOUNDARY_VIOLATION);
+        goto out_write;
+    }
+
     sclp_c->execute(sclp, &work_sccb, code);
 out_write:
     cpu_physical_memory_write(sccb, &work_sccb,
-- 
2.21.0

