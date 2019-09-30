Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF0C21C1
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbfI3NUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730411AbfI3NUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDHx49001464
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:05 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vbhk7u4g7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:05 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:03 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:19:59 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJvHo60358700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A68D64C040;
        Mon, 30 Sep 2019 13:19:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E8A44C044;
        Mon, 30 Sep 2019 13:19:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 Sep 2019 13:19:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4802BE01C8; Mon, 30 Sep 2019 15:19:57 +0200 (CEST)
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
Subject: [PULL 06/12] s390x: sclp: Report insufficient SCCB length
Date:   Mon, 30 Sep 2019 15:19:49 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-0016-0000-0000-000002B21349
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-0017-0000-0000-00003312EE87
Message-Id: <20190930131955.101131-7-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Return the correct error code when the SCCB buffer is too small to
contain all of the output, for the Read SCP Information and
Read CPU Information commands.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Message-Id: <1569591203-15258-5-git-send-email-imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 hw/s390x/sclp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index abb6e5011f9c..f57ce7b73943 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -68,6 +68,12 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
 
     read_info->ibc_val = cpu_to_be32(s390_get_ibc_val());
 
+    if (be16_to_cpu(sccb->h.length) <
+            (sizeof(ReadInfo) + cpu_count * sizeof(CPUEntry))) {
+        sccb->h.response_code = cpu_to_be16(SCLP_RC_INSUFFICIENT_SCCB_LENGTH);
+        return;
+    }
+
     /* Configuration Characteristic (Extension) */
     s390_get_feat_block(S390_FEAT_TYPE_SCLP_CONF_CHAR,
                          read_info->conf_char);
@@ -118,6 +124,12 @@ static void sclp_read_cpu_info(SCLPDevice *sclp, SCCB *sccb)
     cpu_info->offset_configured = cpu_to_be16(offsetof(ReadCpuInfo, entries));
     cpu_info->nr_standby = cpu_to_be16(0);
 
+    if (be16_to_cpu(sccb->h.length) <
+            (sizeof(ReadCpuInfo) + cpu_count * sizeof(CPUEntry))) {
+        sccb->h.response_code = cpu_to_be16(SCLP_RC_INSUFFICIENT_SCCB_LENGTH);
+        return;
+    }
+
     /* The standby offset is 16-byte for each CPU */
     cpu_info->offset_standby = cpu_to_be16(cpu_info->offset_configured
         + cpu_info->nr_configured*sizeof(CPUEntry));
-- 
2.21.0

