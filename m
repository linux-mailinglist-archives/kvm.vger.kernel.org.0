Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C7B1506FA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgBCNVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:21:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727864AbgBCNUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:04 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013D9XMT028931
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:03 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xx935ug85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:03 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DAoDQ035377
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:03 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xx935ug75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:03 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DGrO1019779;
        Mon, 3 Feb 2020 13:20:01 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 2xw0y6d8f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:01 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DJxLQ44695996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:00 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D385028068;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE2F28073;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 07/37] KVM: s390: add new variants of UV CALL
Date:   Mon,  3 Feb 2020 08:19:27 -0500
Message-Id: <20200203131957.383915-8-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

This add 2 new variants of the UV CALL.

The first variant handles UV CALLs that might have longer busy
conditions or just need longer when doing partial completion. We should
schedule when necessary.

The second variant handles UV CALLs that only need the handle but have
no payload (e.g. destroying a VM). We can provide a simple wrapper for
those.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 58 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 4eaea95f5c64..3448f12ef57a 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
+#include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/gmap.h>
 
@@ -92,6 +93,18 @@ struct uv_cb_cfs {
 	u64 paddr;
 } __packed __aligned(8);
 
+/*
+ * A common UV call struct for the following calls:
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
@@ -99,6 +112,31 @@ struct uv_cb_share {
 	u64 reserved28;
 } __packed __aligned(8);
 
+/*
+ * Low level uv_call that takes r1 and r2 as parameter and avoids
+ * stalls for long running busy conditions by doing schedule
+ */
+static inline int uv_call_sched(unsigned long r1, unsigned long r2)
+{
+	int cc = 3;
+
+	while (cc > 1) {
+		asm volatile(
+			"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
+			"		ipm	%[cc]\n"
+			"		srl	%[cc],28\n"
+			: [cc] "=d" (cc)
+			: [r1] "a" (r1), [r2] "a" (r2)
+			: "memory", "cc");
+		if (need_resched())
+			schedule();
+	}
+	return cc;
+}
+
+/*
+ * Low level uv_call that takes r1 and r2 as parameter
+ */
 static inline int uv_call(unsigned long r1, unsigned long r2)
 {
 	int cc;
@@ -114,6 +152,26 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
+/*
+ * special variant of uv_call that only transport the cpu or guest
+ * handle and the command, like destroy or verify.
+ */
+static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
+{
+	int rc;
+	struct uv_cb_nodata uvcb = {
+		.header.cmd = cmd,
+		.header.len = sizeof(uvcb),
+		.handle = handle,
+	};
+
+	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
+	rc = uv_call_sched(0, (u64)&uvcb);
+	if (ret)
+		*ret = *(u32 *)&uvcb.header.rc;
+	return rc ? -EINVAL : 0;
+}
+
 struct uv_info {
 	unsigned long inst_calls_list[4];
 	unsigned long uv_base_stor_len;
-- 
2.24.0

