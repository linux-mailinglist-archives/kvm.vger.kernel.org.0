Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5A313ADB0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 16:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgANPbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 10:31:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728977AbgANPbS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 10:31:18 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EFROc2022948
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 10:31:17 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xhbprc1hk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 10:31:16 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 14 Jan 2020 15:31:15 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 Jan 2020 15:31:11 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00EFVA6p53346326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 15:31:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9143411C054;
        Tue, 14 Jan 2020 15:31:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F9B211C04C;
        Tue, 14 Jan 2020 15:31:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.115])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jan 2020 15:31:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 4/4] s390x: smp: Dirty fpc before initial reset test
Date:   Tue, 14 Jan 2020 10:30:53 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114153054.77082-1-frankja@linux.ibm.com>
References: <20200114153054.77082-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011415-0020-0000-0000-000003A099ED
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011415-0021-0000-0000-000021F80F37
Message-Id: <20200114153054.77082-5-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_04:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=805 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001140133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's dirty the fpc, before we test if the initial reset sets it to 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 11ab425..cd32342 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -177,6 +177,9 @@ static void test_emcall(void)
 
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

