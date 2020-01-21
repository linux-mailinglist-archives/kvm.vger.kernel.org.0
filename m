Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB99D143E57
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAUNnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:43:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729199AbgAUNnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:43:23 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LDgWQH133507
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:22 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xp0s6unb0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:22 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 21 Jan 2020 13:43:20 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Jan 2020 13:43:17 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00LDhGL562587016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 13:43:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E198EA405C;
        Tue, 21 Jan 2020 13:43:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9D9A405F;
        Tue, 21 Jan 2020 13:43:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jan 2020 13:43:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 5/9] s390x: smp: Wait for cpu setup to finish
Date:   Tue, 21 Jan 2020 08:42:50 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200121134254.4570-1-frankja@linux.ibm.com>
References: <20200121134254.4570-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20012113-0012-0000-0000-0000037F5F97
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012113-0013-0000-0000-000021BB9FC4
Message-Id: <20200121134254.4570-6-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-21_04:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=1 mlxlogscore=995 phishscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001210114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We store the user provided psw address into restart new, so a psw
restart does not lead us through setup again.

Also we wait on smp_cpu_setup() until the cpu has finished setup
before returning. This is necessary for z/VM and LPAR where sigp is
asynchronous.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/smp.c  | 3 +++
 s390x/cstart64.S | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 84e681d..df8ed69 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -204,6 +204,9 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
 	/* Start processing */
 	smp_cpu_restart_nolock(addr, NULL);
+	/* Wait until the cpu has finished setup and started the provided psw */
+	while (lc->restart_new_psw.addr != psw.addr)
+		mb();
 out:
 	spin_unlock(&lock);
 	return rc;
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 86dd4c4..9af6bb3 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -159,6 +159,8 @@ smp_cpu_setup_state:
 	xgr	%r1, %r1
 	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
 	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
+	/* We should only go once through cpu setup and not for every restart */
+	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
 	br	%r14
 
 pgm_int:
-- 
2.20.1

