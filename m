Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3842FC069
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 20:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbhASTyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:54:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392020AbhASTxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 14:53:23 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJXpXK068391;
        Tue, 19 Jan 2021 14:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Nsj2S9g3UGYn0YL15B/RwQuQTozZIRIjXVlGiMkrA8U=;
 b=nm2UFjqdtv4KBUxLn9ZQI8kQQFGOVNZws21Yojyh3YtJ3oL9bwa8zZ9m9Sd3gDLCwz4c
 6ude27F+j+dEjG949bKYYNM/IH2zlGE1OrkVdGRqkcVjfgvP7PUOpy1qwK+H6OvosCOX
 17YT6rOGK0mcYLVTA3BUBYdKnuPj5yRxFc4guORqVuGK7SBD7PInFWjot/x9Ziao2Fyi
 fnkPgkO918/XuBEOVFzVMLz8ujYzpLH1LEU8zxxEp8Pn0H6gpB5XkvKho2hJkJ4R7hFo
 xl+w/vjvKZHF08LuS/8sq9AWu2PSFiX6SB/9EgWtlDlyw2sCubEtyhvvYevztgj5ZzYk TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36621p7nhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:32 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJncg2131754;
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36621p7ngp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJlq4l001790;
        Tue, 19 Jan 2021 19:52:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh9s7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 19:52:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JJqQvG46662098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 19:52:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5942742047;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DCB4203F;
        Tue, 19 Jan 2021 19:52:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 19:52:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/3] s390x: pv: implement routine to share/unshare memory
Date:   Tue, 19 Jan 2021 20:52:22 +0100
Message-Id: <1611085944-21609-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When communicating with the host we need to share part of
the memory.

Let's implement the ultravisor calls for this.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 4c2fc48..1242336 100644
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
+	if (!cc && (uvcb.header.rc == 0x0001))
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

