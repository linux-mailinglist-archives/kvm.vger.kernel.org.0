Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E524648E811
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbiANKEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240254AbiANKEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:07 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9vLir005785;
        Fri, 14 Jan 2022 10:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JZmwABmvGvSVz+z8BSyABjon1gOgMk7gOYCoyrTqszc=;
 b=L/NjgK2ZKisA11K9RgSvL99Xuoh1PZjdJ5iMcYUfcAwyC0zlDUp7mB8Xhrp5GjzTmqnR
 osWZZXV+N4jpPqQ3LfAOf4WQxGqxmbBqL23Pw9dC0NZZYVD2EN2AzCJ99767YuzYBn5c
 c8/buP+cM5QsKRxPrld/FrX7XMf3ZAdHdOYIppxcMvsOJyw4Trl1AkKQ9ivBmgFApccA
 g+ZUnTQRkbpmmMSNQNzKqQJNWomuCO9MtoT9QjSFZQZHmYU0E0CkrWXcyBMWv+abhw7+
 +1nsCJky5up+9Jpd2D/D5h7RWIoWxXc7yVGNyHchf6uHebaUo9HJWzE6X49opCzOR6gx Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70g04qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:06 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20E9wVhr007897;
        Fri, 14 Jan 2022 10:04:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70g04q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9urWw014759;
        Fri, 14 Jan 2022 10:04:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28ad23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EA41Ys25559424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 10:04:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE1A11C054;
        Fri, 14 Jan 2022 10:04:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7DF611C050;
        Fri, 14 Jan 2022 10:03:59 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/5] s390x: firq: Fix sclp buffer allocation
Date:   Fri, 14 Jan 2022 10:02:45 +0000
Message-Id: <20220114100245.8643-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Akuu1s8MOKaovwutoUh-qUV1BMCrIpzO
X-Proofpoint-ORIG-GUID: aAjzdAFRrEhfgRyUeeKrL91VK8eJH4tT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=809
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need a 32 bit address for the sclp buffer so let's use a page from
the first 31 bits.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/firq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/firq.c b/s390x/firq.c
index 1f877183..a0ef1555 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -87,7 +87,7 @@ static void test_wait_state_delivery(void)
 	 */
 	while(smp_sense_running_status(1));
 
-	h = alloc_page();
+	h = alloc_pages_flags(1, AREA_DMA31);
 	h->length = 4096;
 	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
 	if (ret) {
-- 
2.32.0

