Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4C416A511
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBXLlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727282AbgBXLlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:14 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBck0a107664;
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18ukf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBcmJO107821;
        Mon, 24 Feb 2020 06:41:13 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18ukf4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:13 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZA1I021350;
        Mon, 24 Feb 2020 11:41:12 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 2yaux5yvf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:12 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfAJX51183980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CFAF2805E;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66AC72806A;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v4 08/36] KVM: s390: add new variants of UV CALL
Date:   Mon, 24 Feb 2020 06:40:39 -0500
Message-Id: <20200224114107.4646-9-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

This adds two new helper functions for doing UV CALLs.

The first variant handles UV CALLs that might have longer busy
conditions or just need longer when doing partial completion. We should
schedule when necessary.

The second variant handles UV CALLs that only need the handle but have
no payload (e.g. destroying a VM). We can provide a simple wrapper for
those.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/uv.h | 65 +++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 7956868340c1..a81af06507a9 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
+#include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/gmap.h>
 
@@ -91,6 +92,19 @@ struct uv_cb_cfs {
 	u64 paddr;
 } __packed __aligned(8);
 
+/*
+ * A common UV call struct for calls that take no payload
+ * Examples:
+ * Destroy cpu/config
+ * Verify
+ */
+struct uv_cb_nodata {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 handle;
+	u64 reserved20[4];
+} __packed __aligned(8);
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -98,21 +112,62 @@ struct uv_cb_share {
 	u64 reserved28;
 } __packed __aligned(8);
 
-static inline int uv_call(unsigned long r1, unsigned long r2)
+static inline int __uv_call(unsigned long r1, unsigned long r2)
 {
 	int cc;
 
 	asm volatile(
-		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
-		"		brc	3,0b\n"
-		"		ipm	%[cc]\n"
-		"		srl	%[cc],28\n"
+		"	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
 		: [cc] "=d" (cc)
 		: [r1] "a" (r1), [r2] "a" (r2)
 		: "memory", "cc");
 	return cc;
 }
 
+static inline int uv_call(unsigned long r1, unsigned long r2)
+{
+	int cc;
+
+	do {
+		cc = __uv_call(r1, r2);
+	} while (cc > 1);
+	return cc;
+}
+
+/* Low level uv_call that avoids stalls for long running busy conditions  */
+static inline int uv_call_sched(unsigned long r1, unsigned long r2)
+{
+	int cc;
+
+	do {
+		cc = __uv_call(r1, r2);
+		cond_resched();
+	} while (cc > 1);
+	return cc;
+}
+
+/*
+ * special variant of uv_call that only transports the cpu or guest
+ * handle and the command, like destroy or verify.
+ */
+static inline int uv_cmd_nodata(u64 handle, u16 cmd, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_nodata uvcb = {
+		.header.cmd = cmd,
+		.header.len = sizeof(uvcb),
+		.handle = handle,
+	};
+	int cc;
+
+	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
+	cc = uv_call_sched(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	return cc ? -EINVAL : 0;
+}
+
 struct uv_info {
 	unsigned long inst_calls_list[4];
 	unsigned long uv_base_stor_len;
-- 
2.25.0

