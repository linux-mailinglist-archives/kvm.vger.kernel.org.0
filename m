Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDAE30B7
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439128AbfJXLmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30744 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439132AbfJXLmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:01 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb73E103729
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt3kjvh2t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:00 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:41:57 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:41:56 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfsvM53936262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 922FB52051;
        Thu, 24 Oct 2019 11:41:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 05CDC52050;
        Thu, 24 Oct 2019 11:41:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 06/37] s390: UV: Add import and export to UV library
Date:   Thu, 24 Oct 2019 07:40:28 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0008-0000-0000-00000326C817
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0009-0000-0000-00004A45FB21
Message-Id: <20191024114059.102802-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The convert to/from secure (or also "import/export") ultravisor calls
are need for page management, i.e. paging, of secure execution VM.

Export encrypts a secure guest's page and makes it accessible to the
guest for paging.

Import makes a page accessible to a secure guest.
On the first import of that page, the page will be cleared by the
Ultravisor before it is given to the guest.

All following imports will decrypt a exported page and verify
integrity before giving the page to the guest.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0bfbafcca136..99cdd2034503 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/bug.h>
 #include <asm/page.h>
+#include <asm/gmap.h>
 
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
@@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
 	return rc ? -EINVAL : 0;
 }
 
+/*
+ * Requests the Ultravisor to encrypt a guest page and make it
+ * accessible to the host for paging (export).
+ *
+ * @paddr: Absolute host address of page to be exported
+ */
+static inline int uv_convert_from_secure(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr
+	};
+	if (!uv_call(0, (u64)&uvcb))
+		return 0;
+	return -EINVAL;
+}
+
+/*
+ * Requests the Ultravisor to make a page accessible to a guest
+ * (import). If it's brought in the first time, it will be cleared. If
+ * it has been exported before, it will be decrypted and integrity
+ * checked.
+ *
+ * @handle: Ultravisor guest handle
+ * @gaddr: Guest 2 absolute address to be imported
+ */
+static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
+{
+	int cc;
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = gmap->se_handle,
+		.gaddr = gaddr
+	};
+
+	cc = uv_call(0, (u64)&uvcb);
+
+	if (!cc)
+		return 0;
+	if (uvcb.header.rc == 0x104)
+		return -EEXIST;
+	if (uvcb.header.rc == 0x10a)
+		return -EFAULT;
+	return -EINVAL;
+}
+
 void setup_uv(void);
 void adjust_to_uv_max(unsigned long *vmax);
 #else
@@ -286,6 +335,8 @@ void adjust_to_uv_max(unsigned long *vmax);
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
 static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { return 0; }
+static inline int uv_convert_from_secure(unsigned long paddr) { return 0; }
+static inline int uv_convert_to_secure(unsigned long handle, unsigned long gaddr) { return 0; }
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
-- 
2.20.1

