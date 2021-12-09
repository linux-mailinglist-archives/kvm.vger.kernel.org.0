Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2246E94D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhLINti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238125AbhLINtf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:35 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Bvfjb027997;
        Thu, 9 Dec 2021 13:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M+HJJ+GclnYfG39a/DsyCWCIMcB097QSz0MpdSMh0W0=;
 b=WdY0EgPeBS9jZlkc/xsRRCKMqA/c81A8MUCCDePEBjuP+000/sfJ0W++mjsNJJk0FOjF
 2Z7NlenP++K8yFwK1PSmHxIxiU7yyzx+LpcoyWc/SRrDfNF4GLbwez1A1AcP6ajpo64c
 4Vv+2wmTK6ixe8G1M0VZHyKf3RqtgbNT1Ntbil7VLV6o4PmO4lARgZgoEwkS0nBEfcmG
 C40ad4bzw5GH5YvRqgPc4VcJkZEmpkOb48VEe3PpFPjoqTrtl8wh0UNYCP4Eov+2REpk
 2rJjKXGjl8IjkNjXMvlMwgS1WAcZC6nmzurhXTFeiggHPWVBblemk2LvkXQQvUGD97Dj Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cuhcvt790-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DXVDV003012;
        Thu, 9 Dec 2021 13:45:53 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cuhcvt78b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Dbxe2009243;
        Thu, 9 Dec 2021 13:45:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyyahxx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9Dc2EM29884676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:38:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35A5B11C04A;
        Thu,  9 Dec 2021 13:45:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F9B811C050;
        Thu,  9 Dec 2021 13:45:47 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 02/12] s390x: SCLP: reporting the maximum nested topology entries
Date:   Thu,  9 Dec 2021 14:46:33 +0100
Message-Id: <20211209134643.143866-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aWv139w0_ONYinVpE0bcZf4UC_hZHFsM
X-Proofpoint-GUID: ul8qqHcWZFjsMt-SJkcudTdCKRR0vQk9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum nested topology entries is used by the guest to know
how many nested topology are available on the machine.

Currently, reporting SCLP reports 0, which is the equivalent of
reporting the default value of 2.
Let's use the default SCLP value of 2 and increase this value in the
future patches implementing higher levels.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/sclp.c         | 1 +
 include/hw/s390x/sclp.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 89c30a8a91..7797a45cef 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -125,6 +125,7 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
 
     /* CPU information */
     prepare_cpu_entries(machine, entries_start, &cpu_count);
+    read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
     read_info->entries_cpu = cpu_to_be16(cpu_count);
     read_info->offset_cpu = cpu_to_be16(offset_cpu);
     read_info->highest_cpu = cpu_to_be16(machine->smp.max_cpus - 1);
diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index d3ade40a5a..c86c2c6619 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -116,7 +116,9 @@ typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
     uint8_t rnsize;
-    uint8_t  _reserved1[16 - 11];       /* 11-15 */
+    uint8_t  _reserved1[15 - 11];       /* 11-15 */
+#define SCLP_READ_SCP_INFO_MNEST 2
+    uint8_t  stsi_parm;
     uint16_t entries_cpu;               /* 16-17 */
     uint16_t offset_cpu;                /* 18-19 */
     uint8_t  _reserved2[24 - 20];       /* 20-23 */
-- 
2.27.0

