Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68183467BF6
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382333AbhLCRB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1382259AbhLCRBu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:50 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GHDtF003272;
        Fri, 3 Dec 2021 16:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=INK0bOaIxho7IcjyGgDTLLRTIxzvAT6KfknSvKOWgos=;
 b=MpPqjmbF7SQUCXspMnipHsvQY6X8722kpg/rYLh6nt9sbgyKK5Y73eukY3co/Q0MUyei
 z0dcCaqQA+0TOv6OuIHJllnu6yToFOiQs92WGVxupwYFfbj5GXGec7bQS2GZ5yB15AHz
 xrHhYcJIDybp2J2z3T160Xqw0Dp2KBSd+ariyByu+kBbNCCqVKd+LB6mdPugFH+P/jGC
 o2WR9NObXgwjh5yxWE7AB1TdLW/y6CkApDNCj4uHOosbYPE+kiUl72PV1mbN5688FgwK
 aHMKhnG5gbDR9XGgCczLWDc3EvoCuyx6CScKZZWbWnDY1p+KKdPillM7h3UnkAzel++U tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqpmegstq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:25 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3Gsb21014499;
        Fri, 3 Dec 2021 16:58:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqpmegstc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Gvkv3004803;
        Fri, 3 Dec 2021 16:58:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaan3dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwJLk26083602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93F9452052;
        Fri,  3 Dec 2021 16:58:19 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 06DD352054;
        Fri,  3 Dec 2021 16:58:18 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/17] KVM: s390: pv: module parameter to fence lazy destroy
Date:   Fri,  3 Dec 2021 17:58:04 +0100
Message-Id: <20211203165814.73016-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mOZ_likkeGrCtqwwEIMG3LXUa6cNprsn
X-Proofpoint-ORIG-GUID: NtYtopSgDymNsGLEICEW9L84_xJHLKqj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=941 clxscore=1015 mlxscore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "lazy_destroy", to allow the asynchronous destroy
mechanism to be switched off. This might be useful for debugging purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 14a18ba5ff2c..0c08066067e8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -207,6 +207,11 @@ unsigned int diag9c_forwarding_hz;
 module_param(diag9c_forwarding_hz, uint, 0644);
 MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
 
+/* allow asynchronous deinit for protected guests */
+static int lazy_destroy = 1;
+module_param(lazy_destroy, int, 0444);
+MODULE_PARM_DESC(lazy_destroy, "Asynchronous destroy for protected guests");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
-- 
2.31.1

