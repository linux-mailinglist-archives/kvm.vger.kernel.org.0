Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06B1976F7
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 10:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgC3ItY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 04:49:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728759AbgC3ItY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 04:49:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U8Zitg139107;
        Mon, 30 Mar 2020 04:49:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 303bgdk8g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 04:49:22 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02U8accv141964;
        Mon, 30 Mar 2020 04:49:22 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 303bgdk8fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 04:49:22 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02U8nKcu021247;
        Mon, 30 Mar 2020 08:49:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 301x767d5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 08:49:20 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02U8nJEr43909464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 08:49:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6712B7805E;
        Mon, 30 Mar 2020 08:49:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C007805F;
        Mon, 30 Mar 2020 08:49:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 08:49:18 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests 1/2] s390x/smp: fix detection of "running"
Date:   Mon, 30 Mar 2020 04:49:10 -0400
Message-Id: <20200330084911.34248-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330084911.34248-1-borntraeger@de.ibm.com>
References: <20200330084911.34248-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=992 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300076
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

