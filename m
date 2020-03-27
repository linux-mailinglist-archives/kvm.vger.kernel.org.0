Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5E6195B27
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 17:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgC0QeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 12:34:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbgC0QeF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 12:34:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RGWYrP064700
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 12:34:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3017jufnng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 12:34:04 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02RGXSK1069567
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 12:34:04 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3017jufnn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 12:34:04 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02RGPQ6F024667;
        Fri, 27 Mar 2020 16:34:03 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 2ywawmrgr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 16:34:03 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RGY09C59310432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:34:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05FDE78063;
        Fri, 27 Mar 2020 16:34:00 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A09247805C;
        Fri, 27 Mar 2020 16:33:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 16:33:59 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [1/1] s390x/smp: fix detection of "running"
Date:   Fri, 27 Mar 2020 12:33:55 -0400
Message-Id: <20200327163355.24524-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_05:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 mlxlogscore=788 bulkscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390x hosts with a single CPU, the smp test case hangs (loops).
The check is our restart has finished is wrong.
Sigp sense running status checks if the CPU is currently backed by a
real CPU. This means that on single CPU hosts a sigp sense running
will never claim that a target is running. We need to check for not
being stopped instead.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 2555bf4..5ed8b7b 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -128,7 +128,7 @@ static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
 	 * The order has been accepted, but the actual restart may not
 	 * have been performed yet, so wait until the cpu is running.
 	 */
-	while (!smp_cpu_running(addr))
+	while (smp_cpu_stopped(addr))
 		mb();
 	cpu->active = true;
 	return 0;
-- 
2.25.1

