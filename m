Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684A625FAAA
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 14:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgIGMrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 08:47:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729236AbgIGMr3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 08:47:29 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087CVhaC183380;
        Mon, 7 Sep 2020 08:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b3n95222Gcc1687tCq8ox6Yb8t/K8SYm0AY+BMOX3/w=;
 b=m5NJJ0YltAqY4EKeHCkjQxahiCQ8XFQ0OQaHwBUeP4qA2/+MS6SBh5g6fGfTJz6CR5/E
 tq3uRheXYVCnCbTWHdn1Zr9RinmADw371DsnPgaEr6oHfEchz72AZLsfFDptzUheItOY
 K2bkiSQ0s4kqGkb7KUnzKVSqvGwspkbGgeyJdIyAJ9kfOa6Tx9nKIogLuKF2PlvUbfhs
 MyUn9fWOuTYbeVtJy82s+sXt2omkzdZJ6WZgF48kutZhnebYBBiqBWV9dxt01nVqINuT
 ptiupf+kWu59p9me++jyrsuRbgsbwg/I+T5WqWzxfwU5QIY2TNBaPOR1s+KRrqBby96B +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dms68mqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 08:47:10 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087CWTPx186430;
        Mon, 7 Sep 2020 08:47:10 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dms68mpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 08:47:10 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087Cglec012456;
        Mon, 7 Sep 2020 12:47:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 33c2a89f29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 12:47:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087Cl5Se25362848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 12:47:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 967594C040;
        Mon,  7 Sep 2020 12:47:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0FA24C04A;
        Mon,  7 Sep 2020 12:47:04 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 12:47:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, hca@linux.ibm.com
Subject: [PATCH v2 2/2] s390x: Add 3f program exception handler
Date:   Mon,  7 Sep 2020 08:47:00 -0400
Message-Id: <20200907124700.10374-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907124700.10374-1-frankja@linux.ibm.com>
References: <20200907124700.10374-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 suspectscore=1 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Program exception 3f (secure storage violation) can only be detected
when the CPU is running in SIE with a format 4 state description,
e.g. running a protected guest. Because of this and because user
space partly controls the guest memory mapping and can trigger this
exception, we want to send a SIGSEGV to the process running the guest
and not panic the kernel.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
CC: <stable@vger.kernel.org> # 5.7+
Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/pgm_check.S |  2 +-
 arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
index 2c27907a5ffc..9a92638360ee 100644
--- a/arch/s390/kernel/pgm_check.S
+++ b/arch/s390/kernel/pgm_check.S
@@ -80,7 +80,7 @@ PGM_CHECK(do_dat_exception)		/* 3b */
 PGM_CHECK_DEFAULT			/* 3c */
 PGM_CHECK(do_secure_storage_access)	/* 3d */
 PGM_CHECK(do_non_secure_storage_access)	/* 3e */
-PGM_CHECK_DEFAULT			/* 3f */
+PGM_CHECK(do_secure_storage_violation)	/* 3f */
 PGM_CHECK(monitor_event_exception)	/* 40 */
 PGM_CHECK_DEFAULT			/* 41 */
 PGM_CHECK_DEFAULT			/* 42 */
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 4c8c063bce5b..996884dcc9fd 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -859,6 +859,21 @@ void do_non_secure_storage_access(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
+void do_secure_storage_violation(struct pt_regs *regs)
+{
+	/*
+	 * Either KVM messed up the secure guest mapping or the same
+	 * page is mapped into multiple secure guests.
+	 *
+	 * This exception is only triggered when a guest 2 is running
+	 * and can therefore never occur in kernel context.
+	 */
+	printk_ratelimited(KERN_WARNING
+			   "Secure storage violation in task: %s, pid %d\n",
+			   current->comm, current->pid);
+	send_sig(SIGSEGV, current, 0);
+}
+
 #else
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -869,4 +884,9 @@ void do_non_secure_storage_access(struct pt_regs *regs)
 {
 	default_trap_handler(regs);
 }
+
+void do_secure_storage_violation(struct pt_regs *regs)
+{
+	default_trap_handler(regs);
+}
 #endif
-- 
2.25.1

