Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040D72FE615
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhAUJPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:15:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728508AbhAUJOP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:14:15 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L92htO156301;
        Thu, 21 Jan 2021 04:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=1Jr/kjfOuL08Kj6328CD+2X9hiMaH/zoXULnI9YHL7o=;
 b=kf6gt8jmwa4gDfjJjej09fpqWvXkQA+wPWnv59UJibS9uYKBQGPAR5CVISRSmRza0i3D
 Ien4RgueoJpmz7VpHjWF6t6QO7nnYVSiPjvXs8C/U4UKY9/PnyOmWQSwL0tHugjNQakC
 okD/88FuIhLETUFpYoza1C7hleAWHJTUQgs/kECPm5PjYMt/fUckw3Bk45EVsjZSiw/O
 YKo97mqOwsRV2w6MpWDDwzE1tiWNHSsbS/bn0kucwMo7b/7Ufn5YK5Iei8GZMCtpRmaU
 if2y7lGMgfwQG4ZnTQk3VosmscT2NFxd3jcmAxhYBz0h69FB53+iPNDrQIgzjqo/qwPf 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3674v13yma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:13:20 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L92p2j156938;
        Thu, 21 Jan 2021 04:13:20 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3674v13yjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:13:20 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L96vGf022150;
        Thu, 21 Jan 2021 09:13:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3668p0sfvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:13:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9DFTn37290432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:13:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36D4E42049;
        Thu, 21 Jan 2021 09:13:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4BA242047;
        Thu, 21 Jan 2021 09:13:14 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:13:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/3] s390x: pv: implement routine to share/unshare memory
Date:   Thu, 21 Jan 2021 10:13:10 +0100
Message-Id: <1611220392-22628-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When communicating with the host we need to share part of
the memory.

Let's implement the ultravisor calls for this.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 4c2fc48..8400026 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -71,4 +71,42 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
+static inline int share(unsigned long addr, u16 cmd)
+{
+	struct uv_cb_share uvcb = {
+		.header.cmd = cmd,
+		.header.len = sizeof(uvcb),
+		.paddr = addr
+	};
+	int cc;
+
+	cc = uv_call(0, (u64)&uvcb);
+	if (!cc && uvcb.header.rc == 0x0001)
+		return 0;
+
+	report_info("cc %d response code: %04x", cc, uvcb.header.rc);
+	return -1;
+}
+
+/*
+ * Guest 2 request to the Ultravisor to make a page shared with the
+ * hypervisor for IO.
+ *
+ * @addr: Real or absolute address of the page to be shared
+ */
+static inline int uv_set_shared(unsigned long addr)
+{
+	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
+}
+
+/*
+ * Guest 2 request to the Ultravisor to make a page unshared.
+ *
+ * @addr: Real or absolute address of the page to be unshared
+ */
+static inline int uv_remove_shared(unsigned long addr)
+{
+	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
+}
+
 #endif
-- 
2.17.1

