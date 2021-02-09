Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF0315778
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 21:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhBIUHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 15:07:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233714AbhBITqE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 14:46:04 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119IpQB3038065
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aEytD9WRlnGhVpxq85ibOkYbg29iC4fqSqmHYnlSezI=;
 b=kdR8U60bGh2DGcgbrrFDXtfnIgJ6ySfI5w4mU7Ew0vHFP0Bp+sa6PpUpgEDek/nMEjBE
 DDmRpXrrsOCaWzNWrGcqOBKiPj1aWvvKwTxCBqEw6EI/vozkuvzTZ40eQLEkNxjZ33Ia
 V3QCAMwXbnRUIoh4yqG/pD7pN6PUOWfcKEbm+tYYbyKid5OziE1P2zszk8OcFLJyOssA
 5zlHrER5t809inOFQH91LYH4Y86TtSfxPdVF2KnsAWl9E6Wdc5XiG8RfwniXS8knOnBO
 W03Lm9hn20WYTFiwTMWiLbWV8N+WlcAEIILOi7POZQPnsoiG/68/FajSJsZHaoJt9bIc vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kywqr6wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 13:52:01 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119IpW61040886
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:52:00 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kywqr6vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:52:00 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119IkdFN028448;
        Tue, 9 Feb 2021 18:51:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36hqda3hu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 18:51:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Ipjob36176150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 18:51:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82FDDA4060;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A18BA405C;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/3] s390x: introduce leave_pstate to leave userspace
Date:   Tue,  9 Feb 2021 19:51:52 +0100
Message-Id: <20210209185154.1037852-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_05:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=857 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In most testcases, we enter problem state (userspace) just to test if a
privileged instruction causes a fault. In some cases, though, we need
to test if an instruction works properly in userspace. This means that
we do not expect a fault, and we need an orderly way to leave problem
state afterwards.

This patch introduces a simple system based on the SVC instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  5 +++++
 lib/s390x/interrupt.c    | 12 ++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 9c4e330a..9902e9fe 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -276,6 +276,11 @@ static inline void enter_pstate(void)
 	load_psw_mask(mask);
 }
 
+static inline void leave_pstate(void)
+{
+	asm volatile("	svc 1\n");
+}
+
 static inline int stsi(void *addr, int fc, int sel1, int sel2)
 {
 	register int r0 asm("0") = (fc << 28) | sel1;
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 1ce36073..59e01b1a 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -188,6 +188,14 @@ int unregister_io_int_func(void (*f)(void))
 
 void handle_svc_int(void)
 {
-	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
-		     stap(), lc->svc_old_psw.addr);
+	uint16_t code = lc->svc_int_code;
+
+	switch (code) {
+	case 1:
+		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
+		break;
+	default:
+		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
+			      code, stap(), lc->svc_old_psw.addr);
+	}
 }
-- 
2.26.2

