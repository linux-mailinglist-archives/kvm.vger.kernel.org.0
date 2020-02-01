Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9DB14F87D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 16:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBAP3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 10:29:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726998AbgBAP3J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 10:29:09 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 011FExb2182032
        for <kvm@vger.kernel.org>; Sat, 1 Feb 2020 10:29:08 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xw7qdeam7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:29:08 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Sat, 1 Feb 2020 15:29:06 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 1 Feb 2020 15:29:04 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 011FT3Pt5505172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 Feb 2020 15:29:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5092A52051;
        Sat,  1 Feb 2020 15:29:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8C0205204E;
        Sat,  1 Feb 2020 15:29:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 7/7] s390x: smp: Wait for cpu setup to finish
Date:   Sat,  1 Feb 2020 10:28:51 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200201152851.82867-1-frankja@linux.ibm.com>
References: <20200201152851.82867-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020115-4275-0000-0000-0000039D0ED6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020115-4276-0000-0000-000038B1311E
Message-Id: <20200201152851.82867-8-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_03:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010113
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
index 4578003..3f86243 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -210,6 +210,9 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
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

