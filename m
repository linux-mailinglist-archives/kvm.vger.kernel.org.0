Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B30A219A85
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 10:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGIIH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 04:07:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21738 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726124AbgGIIH6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 04:07:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06981beB166133;
        Thu, 9 Jul 2020 04:07:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325s3jh620-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 04:07:57 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06981nl5167358;
        Thu, 9 Jul 2020 04:07:56 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325s3jh61h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 04:07:56 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069865kN031929;
        Thu, 9 Jul 2020 08:07:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 325k1vgkd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 08:07:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06987rRK29556948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 08:07:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9A9A405B;
        Thu,  9 Jul 2020 08:07:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79DE1A405C;
        Thu,  9 Jul 2020 08:07:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 08:07:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v11 5/9] s390x: define function to wait for interrupt
Date:   Thu,  9 Jul 2020 10:07:44 +0200
Message-Id: <1594282068-11054-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_04:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=696
 suspectscore=1 malwarescore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the program to wait for an interrupt.

The interrupt handler is in charge to remove the WAIT bit
when it finished handling the interrupt.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 1b3bb0c..022a564 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -17,6 +17,7 @@ struct psw {
 
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_WAIT			0x0002000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 
 #define CR0_EXTM_SCLP			0x0000000000000200UL
@@ -246,6 +247,18 @@ static inline void load_psw_mask(uint64_t mask)
 		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
 }
 
+static inline void wait_for_interrupt(uint64_t irq_mask)
+{
+	uint64_t psw_mask = extract_psw_mask();
+
+	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
+	/*
+	 * After being woken and having processed the interrupt, let's restore
+	 * the PSW mask.
+	 */
+	load_psw_mask(psw_mask);
+}
+
 static inline void enter_pstate(void)
 {
 	uint64_t mask;
-- 
2.25.1

