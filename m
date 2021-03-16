Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9A33D078
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhCPJU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:20:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232584AbhCPJUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:20:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G93B0S047405;
        Tue, 16 Mar 2021 05:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=n98KZT57rRerIs5/wFjWGc8mi2iOF4J+0ZSNe9MRX70=;
 b=gwFCHn+n0c6y2FgQMXv7mXx30Vv7/eISyxqvT+sSIgkyQVLzeFakoOMKvMzXCYDIrTy6
 4j6F3D18RwgTqJOhWmZ6pbUiLN7tDdojKFg7LNe8wkLJ+TvIznABhxIIRKKpKpVXCSxj
 2ebGoLpW3u4dzHSmWoZUyvMCML57MilQZieBAQJfSh020jly9PsW9HrNZ3+Mkemo7XIH
 bNkYLHslnQBjEyEuXA9ACRxlMwZ2EBC4+xWVO3lL0T33NWoJtecG8l2kbDtFRo+tBFCi
 R8D7psKRHQusKcei16a5Im4C/ji9jRyHzYGNtbiGKweX/w1CfWibnL18iTfquVcmAgWG fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37arhuafmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:05 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G93Axr047299;
        Tue, 16 Mar 2021 05:20:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37arhuafkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9C3EP005481;
        Tue, 16 Mar 2021 09:20:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 378mnh2pfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:20:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9K02a2753156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:20:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271DA4C058;
        Tue, 16 Mar 2021 09:20:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E62464C040;
        Tue, 16 Mar 2021 09:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.146.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Mar 2021 09:19:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/6] s390x: uv-guest: Add invalid share location test
Date:   Tue, 16 Mar 2021 09:16:49 +0000
Message-Id: <20210316091654.1646-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210316091654.1646-1-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also test sharing unavailable memory.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99544442..a13669ab 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -15,6 +15,7 @@
 #include <asm/interrupt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
+#include <sclp.h>
 
 static unsigned long page;
 
@@ -99,6 +100,10 @@ static void test_sharing(void)
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
+	uvcb.paddr = get_ram_size() + PAGE_SIZE;
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
+	uvcb.paddr = page;
 	report_prefix_pop();
 
 	report_prefix_push("unshare");
-- 
2.27.0

