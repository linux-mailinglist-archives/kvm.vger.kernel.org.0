Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18855140847
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAQKrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:47:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728739AbgAQKrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jan 2020 05:47:05 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00HAbwJu053163
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:47:05 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xk0qrrvwd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:47:04 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 17 Jan 2020 10:47:03 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Jan 2020 10:46:59 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00HAkwjt34865600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 10:46:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99DDDAE057;
        Fri, 17 Jan 2020 10:46:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2781CAE053;
        Fri, 17 Jan 2020 10:46:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.184.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jan 2020 10:46:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/9] s390x: smp: Loop if secondary cpu returns into cpu setup again
Date:   Fri, 17 Jan 2020 05:46:37 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200117104640.1983-1-frankja@linux.ibm.com>
References: <20200117104640.1983-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011710-0008-0000-0000-0000034A424F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011710-0009-0000-0000-00004A6A9EAE
Message-Id: <20200117104640.1983-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_02:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=834
 priorityscore=1501 suspectscore=1 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up to now a secondary cpu could have returned from the function it was
executing and ending up somewhere in cstart64.S. This was mostly
circumvented by an endless loop in the function that it executed.

Let's add a loop to the end of the cpu setup, so we don't have to rely
on added loops in the tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cstart64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 9af6bb3..5fd8d2f 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -162,6 +162,8 @@ smp_cpu_setup_state:
 	/* We should only go once through cpu setup and not for every restart */
 	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
 	br	%r14
+	/* If the function returns, just loop here */
+0:	j	0
 
 pgm_int:
 	SAVE_REGS
-- 
2.20.1

