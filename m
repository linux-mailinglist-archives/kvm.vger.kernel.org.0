Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5031725C38E
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgICOxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:53:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729348AbgICOxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 10:53:20 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083DCrXw190943;
        Thu, 3 Sep 2020 09:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mwtDiKbzMzLqIeuSUmKOUDweb6dyUA6eoU+zVUlhshI=;
 b=n8IunAJEevLM46Y5DjEaFv8XdQDHX0m44JjF+HdQytEwKbmeUgJeQmAD+CHDHmUUUTS7
 onSdKAZXBmFE4YDiGvEgnwgmtu24mP2YRcJgHKMY+B30c29Fvlx5EP0v3lIDwCPHVnLZ
 d6Kz0i95qEUVWBJOiDYtlpcO2hSOVJCEJZ7YWHM+Z879WI7Ltl+W9Gtbk7+v7pPCOdXK
 h/VK9bAtHfReFPcv6rU4L44bv6taucx1JDJ3UfXQPu6v0P5VcVm+5UckRBGaeFkW++5a
 Qy9aqpfxSCPbSNZcIELlGvfZtH74qHBmbxnruye+3t5kLZrtNUxG+qGwZplyIJvc+hfu Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b16081ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:06 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 083DCtQe191106;
        Thu, 3 Sep 2020 09:15:05 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b16081sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 09:15:05 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083D7dl8009160;
        Thu, 3 Sep 2020 13:15:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 337e9h3kmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:15:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083DF04u29098408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 13:15:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BFE1AE045;
        Thu,  3 Sep 2020 13:15:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8536AE053;
        Thu,  3 Sep 2020 13:14:59 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 13:14:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com
Subject: [PATCH 1/2] s390x: uv: Add destroy page call
Date:   Thu,  3 Sep 2020 09:14:34 -0400
Message-Id: <20200903131435.2535-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200903131435.2535-1-frankja@linux.ibm.com>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_06:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need to export pages if we destroy the VM configuration
afterwards anyway. Instead we can destroy the page which will zero it
and then make it accessible to the host.

Destroying is about twice as fast as the export.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  7 +++++++
 arch/s390/kernel/uv.c      | 21 +++++++++++++++++++++
 arch/s390/mm/gmap.c        |  2 +-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index cff4b4c99b75..0325fc0469b7 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -33,6 +33,7 @@
 #define UVC_CMD_DESTROY_SEC_CPU		0x0121
 #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
 #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_DESTR_SEC_STOR		0x0202
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
@@ -344,6 +345,7 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int uv_destroy_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
@@ -354,6 +356,11 @@ void adjust_to_uv_max(unsigned long *vmax);
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
 
+static inline int uv_destroy_page(unsigned long paddr)
+{
+	return 0;
+}
+
 static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c296e5c8dbf9..e07a5859f1ea 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -118,6 +118,27 @@ static int uv_pin_shared(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * Requests the Ultravisor to destroy a guest page and make it
+ * accessible to the host. The destroy clears the page instead of
+ * exporting.
+ *
+ * @paddr: Absolute host address of page to be destroyed
+ */
+int uv_destroy_page(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr
+	};
+
+	if (uv_call(0, (u64)&uvcb))
+		return -EINVAL;
+	return 0;
+}
+
+
 /*
  * Requests the Ultravisor to encrypt a guest page and make it
  * accessible to the host for paging (export).
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 373542ca1113..cfb0017f33a7 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2679,7 +2679,7 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
 	pte_t pte = READ_ONCE(*ptep);
 
 	if (pte_present(pte))
-		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
+		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
 	return 0;
 }
 
-- 
2.25.1

