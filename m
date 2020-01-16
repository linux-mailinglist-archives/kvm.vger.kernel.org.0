Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B9A13D9A3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgAPMFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 07:05:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726981AbgAPMFh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 07:05:37 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GBvZ5m085851
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:36 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xjkbm17d0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:36 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 12:05:34 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 12:05:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GC5VAA31719648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 12:05:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4925252063;
        Thu, 16 Jan 2020 12:05:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6D1AF52051;
        Thu, 16 Jan 2020 12:05:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 7/7] s390x: smp: Dirty fpc before initial reset test
Date:   Thu, 16 Jan 2020 07:05:13 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116120513.2244-1-frankja@linux.ibm.com>
References: <20200116120513.2244-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011612-4275-0000-0000-0000039813C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011612-4276-0000-0000-000038AC129E
Message-Id: <20200116120513.2244-8-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_03:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 suspectscore=1 spamscore=0 priorityscore=1501
 mlxlogscore=845 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001160103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's dirty the fpc, before we test if the initial reset sets it to 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index ce3215d..97a9dda 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -179,6 +179,9 @@ static void test_emcall(void)
 /* Used to dirty registers of cpu #1 before it is reset */
 static void test_func_initial(void)
 {
+	asm volatile(
+		"	sfpc	%0\n"
+		: : "d" (0x11) : );
 	lctlg(1, 0x42000UL);
 	lctlg(7, 0x43000UL);
 	lctlg(13, 0x44000UL);
-- 
2.20.1

