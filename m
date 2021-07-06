Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8C3BD6A1
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhGFMla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241564AbhGFMUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166CDXoT071057;
        Tue, 6 Jul 2021 08:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wml/Ty3GU8DrIDTCK3W1dd71JtbURo9gM1vGjidVhFY=;
 b=iqzBVZ8IR3q5E16jkH6o5Ha5TOUCl+qzs88akVMZa4eFL7U1JNEuPgg7sx50An8NpofA
 KH11iBSNNCbrylbl5Tv67tbo5Tc7vzVj7ZEvIkSqBCxHTWvSklyv6BFYNdanQxQQ0F3O
 lsUhI8zY5xuJ/eSIzqbQ1+CHnFUvnObJXBu5qekVvgU4IJlhExhcLeVi3UdRi5OFnKFM
 G0TW35iRjC1/Y4SonXZdgnggwq5QPPwzdktKajy6gcquKcqg4gvhRBnpGllxIF7C/HYR
 mkSZEYATSo+4uEoXcvRMjQGJLk1WirD+MTza/KuGbktKmDgE7ZBUAqAxkEsjgpzC37BS +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mq0604x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166CE9SB074993;
        Tue, 6 Jul 2021 08:18:09 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mq0604vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2vTY026212;
        Tue, 6 Jul 2021 12:18:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8s87a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CI4cb27459872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:18:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21CA242042;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D22C242057;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: sie: Fix sie.h integer types
Date:   Tue,  6 Jul 2021 12:17:54 +0000
Message-Id: <20210706121757.24070-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706121757.24070-1-frankja@linux.ibm.com>
References: <20210706121757.24070-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pA62HQ19o8Ualmk4EWfoDQCAWuHS6sKp
X-Proofpoint-ORIG-GUID: 2-wMgoMeNkVVMPwXN_eiI3p1nUHMnGet
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only use the uint*_t types.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sie.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index b4bb78c..6ba858a 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -173,9 +173,9 @@ struct kvm_s390_sie_block {
 } __attribute__((packed));
 
 struct vm_save_regs {
-	u64 grs[16];
-	u64 fprs[16];
-	u32 fpc;
+	uint64_t grs[16];
+	uint64_t fprs[16];
+	uint32_t fpc;
 };
 
 /* We might be able to nestle all of this into the stack frame. But
@@ -191,7 +191,7 @@ struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
 	/* Ptr to first guest page */
-	u8 *guest_mem;
+	uint8_t *guest_mem;
 };
 
 extern void sie_entry(void);
-- 
2.30.2

