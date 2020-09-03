Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F625C24D
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgICOOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:14:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728910AbgICOO2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 10:14:28 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083D3HwY070668;
        Thu, 3 Sep 2020 09:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6Cw0JEv1jZT7no0DnmTQ+qpN112s9Nits6RfuEnvZ5w=;
 b=O0hfhNVs+3EJuhS9N0/EwptP/Ix7UaS9wrHqaUyPGQMAm+dtVXBh2BD4NH59UVVMxQaH
 5se15cMfwKEJpBSVLlySJUCWGyZ/jV0OyVHHhyX7oFXoIUnzV2D4DmpDv54o77f+Lp17
 sA+AmdnXpE2WPQvxbRDJltVmrqpxE1sVkLv3+CUJbw1vIJfHKZPAg+xCfSVuGmxLz8C9
 oV9y8PT4jWdHMYg6/gaDYQPKxiyuw7PLyduIjgySob22ci3kLq3cPh/p5JrQzffWbaHS
 +BHvaBX6wrCP/si+peFzq+d8aRIH4q+rvMa0K15q3gH0/OFLLVZ7p4pf68vbB/rj2Wsf dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33b0rbh3bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:06 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 083D3HJY070689;
        Thu, 3 Sep 2020 09:15:06 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33b0rbh3ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:06 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083D70qv004026;
        Thu, 3 Sep 2020 13:15:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 337en7kks0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:15:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083DF1uZ29032746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 13:15:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E272AE056;
        Thu,  3 Sep 2020 13:15:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3AF3AE051;
        Thu,  3 Sep 2020 13:15:00 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 13:15:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com
Subject: [PATCH 2/2] s390x: Add 3f program exception handler
Date:   Thu,  3 Sep 2020 09:14:35 -0400
Message-Id: <20200903131435.2535-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200903131435.2535-1-frankja@linux.ibm.com>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_06:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030122
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
---
 arch/s390/kernel/pgm_check.S |  2 +-
 arch/s390/mm/fault.c         | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

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
index 4c8c063bce5b..20abb7c5c540 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -859,6 +859,24 @@ void do_non_secure_storage_access(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
+void do_secure_storage_violation(struct pt_regs *regs)
+{
+	char buf[TASK_COMM_LEN];
+
+	/*
+	 * Either KVM messed up the secure guest mapping or the same
+	 * page is mapped into multiple secure guests.
+	 *
+	 * This exception is only triggered when a guest 2 is running
+	 * and can therefore never occur in kernel context.
+	 */
+	printk_ratelimited(KERN_WARNING
+			   "Secure storage violation in task: %s, pid %d\n",
+			   get_task_comm(buf, current), task_pid_nr(current));
+	send_sig(SIGSEGV, current, 0);
+}
+NOKPROBE_SYMBOL(do_secure_storage_violation);
+
 #else
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -869,4 +887,9 @@ void do_non_secure_storage_access(struct pt_regs *regs)
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

