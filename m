Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8B27AFEF
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgI1OXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 10:23:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4348 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbgI1OXq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 10:23:46 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SE43CK048084;
        Mon, 28 Sep 2020 10:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=aKHOqJbIErGd8i7/37hT5d/Q0bQDKTiOhawMUJGtfxY=;
 b=e8uhV9DEzg+uHoCeOc796UjClfpt4RDJhNL9OkttZ5HjekKhCFMSQ+hRd5y+pYP9uCXO
 YGEJ6ELrNTzeHfkfizJIMjA794q2vbfr3Ueb9vJYeZW7hxs2ZP/En6v5qfS5w9ThkMnp
 eMIy7yakiEtSRyOgZqqygy2L4tRo0W/bzMtlgUbAjuaK0MhdLDzcrfU26Qfn3UN+Jg5y
 kItZUNk7xRK7JvUoZinTGCYTFFYpWK3YG+udb0nO+e+Dynpm4EBgtBk2ZyamJNCrWA9c
 seneEgFLNuzzO6G4cxazlE2e6mmlPAXHmNLYzgzjWss12RXuwoGjq5Yo+t5KFTo54JjB MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ugb0u2dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SEIXgU110641;
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ugb0u2d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SEN6YE029718;
        Mon, 28 Sep 2020 14:23:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw9827b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 14:23:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SENdnf11927920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 14:23:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A91034203F;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FBF442047;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.66.164])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: pv: implement routine to share/unshare memory
Date:   Mon, 28 Sep 2020 16:23:35 +0200
Message-Id: <1601303017-8176-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_14:2020-09-28,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=1 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When communicating with the host we need to share part of
the memory.

Let's implement the ultravisor calls for this.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Suggested-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 4c2fc48..f7690a2 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -71,4 +71,54 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
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
+	report(0, "cc %d response code: %04x", cc, uvcb.header.rc);
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
+	int ret;
+
+	report_prefix_push("PV Set Shared access");
+	ret = share(addr, UVC_CMD_SET_SHARED_ACCESS);
+	report_prefix_pop();
+
+	return ret;
+}
+
+/*
+ * Guest 2 request to the Ultravisor to make a page unshared.
+ *
+ * @addr: Real or absolute address of the page to be unshared
+ */
+static inline int uv_remove_shared(unsigned long addr)
+{
+	int ret;
+
+	report_prefix_push("PV Remove Shared access");
+	ret = share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
+	report_prefix_pop();
+
+	return ret;
+}
+
 #endif
-- 
2.25.1

