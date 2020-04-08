Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243781A1B71
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgDHFHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:07:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgDHFHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:07:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038531q8179572;
        Wed, 8 Apr 2020 05:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ssuzsbfGr+UP4f7vc9tDGOuDdiCw4ECans2QkELpN/o=;
 b=DF5tG1seAt9KkNyuEPs859A3/N7Z5Dar4IGAhqpC5aYgjyyzMmHQn2AgDX0IqU+sT+1N
 VPSFr3N9FFpywMgFiXOwNJjP4KRUz4E5dqFIQBBgcTeN1XDH/Qf2MIeCw3oHJPnZQR5g
 RbYyfAucvn8uNWXH1a4jczS6/aI/30fojyT6nK27iuR0uBc5uRV90g0xQnw4FSOy05rY
 bgc6dDRPE5jDAtPuXWv/w9+qGvQ4KpKgqOVtIJQygxNkOe5o/CLl7AlTk33O5iSA1q2l
 kDYYEav/L+kMFa1SgqKpRk657rjE6DP7bVbfSKLT00HjKegvGXYtTFrR4+7WFCtIugbS RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3091mnh19q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:07:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852fSY148154;
        Wed, 8 Apr 2020 05:05:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3091kgj6st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03854xi6007309;
        Wed, 8 Apr 2020 05:04:59 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:04:59 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 03/26] x86/paravirt: PVRTOP macros for PARAVIRT_RUNTIME
Date:   Tue,  7 Apr 2020 22:03:00 -0700
Message-Id: <20200408050323.4237-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=752
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=813 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define PVRT* macros which can be used to put pv-ops in
.parainstructions.runtime.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/paravirt_types.h | 49 +++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 00e4a062ca10..f1153f53c529 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -337,6 +337,12 @@ struct paravirt_patch_template {
 extern struct pv_info pv_info;
 extern struct paravirt_patch_template pv_ops;
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+#define PVRT_SUFFIX ".runtime"
+#else
+#define PVRT_SUFFIX ""
+#endif
+
 /* Sub-section for .parainstructions */
 #define PV_SUFFIX ""
 
@@ -693,6 +699,49 @@ int paravirt_disable_iospace(void);
 #define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
 	_PVOP_VCALL4(PV_SUFFIX, op, arg1, arg2, arg3, arg4)
 
+/*
+ * PVRTOP macros for .parainstructions.runtime
+ */
+#define PVRTOP_CALL0(rettype, op)					\
+	_PVOP_CALL0(PVRT_SUFFIX, rettype, op)
+#define PVRTOP_VCALL0(op)						\
+	_PVOP_VCALL0(PVRT_SUFFIX, op)
+
+#define PVRTOP_CALLEE0(rettype, op)					\
+	_PVOP_CALLEE0(PVRT_SUFFIX, rettype, op)
+#define PVRTOP_VCALLEE0(op)						\
+	_PVOP_VCALLEE0(PVRT_SUFFIX, op)
+
+#define PVRTOP_CALL1(rettype, op, arg1)					\
+	_PVOP_CALL1(PVRT_SUFFIX, rettype, op, arg1)
+#define PVRTOP_VCALL1(op, arg1)						\
+	_PVOP_VCALL1(PVRT_SUFFIX, op, arg1)
+
+#define PVRTOP_CALLEE1(rettype, op, arg1)				\
+	_PVOP_CALLEE1(PVRT_SUFFIX, rettype, op, arg1)
+#define PVRTOP_VCALLEE1(op, arg1)					\
+	_PVOP_VCALLEE1(PVRT_SUFFIX, op, arg1)
+
+#define PVRTOP_CALL2(rettype, op, arg1, arg2)				\
+	_PVOP_CALL2(PVRT_SUFFIX, rettype, op, arg1, arg2)
+#define PVRTOP_VCALL2(op, arg1, arg2)					\
+	_PVOP_VCALL2(PVRT_SUFFIX, op, arg1, arg2)
+
+#define PVRTOP_CALLEE2(rettype, op, arg1, arg2)				\
+	_PVOP_CALLEE2(PVRT_SUFFIX, rettype, op, arg1, arg2)
+#define PVRTOP_VCALLEE2(op, arg1, arg2)					\
+	_PVOP_VCALLEE2(PVRT_SUFFIX, op, arg1, arg2)
+
+#define PVRTOP_CALL3(rettype, op, arg1, arg2, arg3)			\
+	_PVOP_CALL3(PVRT_SUFFIX, rettype, op, arg1, arg2, arg3)
+#define PVRTOP_VCALL3(op, arg1, arg2, arg3)				\
+	_PVOP_VCALL3(PVRT_SUFFIX, op, arg1, arg2, arg3)
+
+#define PVRTOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)		\
+	_PVOP_CALL4(PVRT_SUFFIX, rettype, op, arg1, arg2, arg3, arg4)
+#define PVRTOP_VCALL4(op, arg1, arg2, arg3, arg4)			\
+	_PVOP_VCALL4(PVRT_SUFFIX, op, arg1, arg2, arg3, arg4)
+
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {
 	PARAVIRT_LAZY_NONE,
-- 
2.20.1

