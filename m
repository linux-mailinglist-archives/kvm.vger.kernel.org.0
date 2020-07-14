Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D63721EEEA
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgGNLRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:17:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727818AbgGNLQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:16:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EB3aFm043341;
        Tue, 14 Jul 2020 07:16:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3276agqcee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:16:15 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EB3rFI044928;
        Tue, 14 Jul 2020 07:16:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3276agqcdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:16:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EBAbUd024598;
        Tue, 14 Jul 2020 11:16:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 327527u8wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:16:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EBGAfJ11469258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 11:16:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F5E3A405B;
        Tue, 14 Jul 2020 11:16:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7ED37A405F;
        Tue, 14 Jul 2020 11:16:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.162.148])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 11:16:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v12 5/9] s390x: define function to wait for interrupt
Date:   Tue, 14 Jul 2020 13:15:44 +0200
Message-Id: <1594725348-10034-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594725348-10034-1-git-send-email-pmorel@linux.ibm.com>
References: <1594725348-10034-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=703 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 suspectscore=1 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140085
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

