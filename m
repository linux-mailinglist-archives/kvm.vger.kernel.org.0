Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2848E80B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbiANKED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237595AbiANKEC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:02 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9wRwn008610;
        Fri, 14 Jan 2022 10:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JfwNhFIWNEGjXR6onDve6lBQVbYkO/JtkGq6z/KfKgk=;
 b=QqfkpEMk2K+EPn6GtaN3dIKSVNhEn80QVGoau6djwntiyTidkVEtjII2byzKHrOZWDez
 jKsFCXoif0bgJPS0QNQuxQIzanXJeJFEwltPND3/TbMcm/ulG7S45JwLpwA4DDuPQRXW
 w6R+bdYTMSKsnUcKCWQwnkUhR3NaIT4YCA74QJBaSkMQV4+2f8s5pKhLF7ep0N57NGdl
 ous+1EdxzwJix1zsd4ltY7MOSH/GKtvcq64fhq6g9E00YyE7u47Rz65SsnB4x/OOCwAq
 dxOTdhRO7NTQNUPADUxUJdGo0VjX2zdMgllmAPRXgUm2LLF4ukfy5r0dr6CeaI+NaUBH Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70yr3xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:01 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EA06Kt013098;
        Fri, 14 Jan 2022 10:04:01 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70yr3x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:01 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9vVAC016863;
        Fri, 14 Jan 2022 10:03:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3df28aa8x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:03:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EA3ujq44564876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 10:03:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B04111C04C;
        Fri, 14 Jan 2022 10:03:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C60711C054;
        Fri, 14 Jan 2022 10:03:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm queries
Date:   Fri, 14 Jan 2022 10:02:41 +0000
Message-Id: <20220114100245.8643-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZfCmWmU2th5a1WQig_JT5GYh5vIrwTwt
X-Proofpoint-GUID: qjcv7KLQseMZ19xDDuALT2ZqfCFPqPao
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch will likely (in parts) be replaced by Pierre's patch from
his topology test series.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/vm.c | 39 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h | 23 +++++++++++++++++++++++
 s390x/stsi.c   | 21 +--------------------
 3 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
index a5b92863..266a81c1 100644
--- a/lib/s390x/vm.c
+++ b/lib/s390x/vm.c
@@ -26,6 +26,11 @@ bool vm_is_tcg(void)
 	if (initialized)
 		return is_tcg;
 
+	if (stsi_get_fc() < 3) {
+		initialized = true;
+		return false;
+	}
+
 	buf = alloc_page();
 	if (!buf)
 		return false;
@@ -43,3 +48,37 @@ out:
 	free_page(buf);
 	return is_tcg;
 }
+
+bool vm_is_kvm(void)
+{
+	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
+	struct stsi_322 *buf;
+	static bool initialized = false;
+	static bool is_kvm = false;
+
+	if (initialized)
+		return is_kvm;
+
+	if (stsi_get_fc() < 3) {
+		initialized = true;
+		return false;
+	}
+
+	buf = alloc_page();
+	if (!buf)
+		return false;
+
+	if (stsi(buf, 3, 2, 2))
+		goto out;
+
+	is_kvm = !(memcmp(&buf->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm))) && !vm_is_tcg();
+	initialized = true;
+out:
+	free_page(buf);
+	return is_kvm;
+}
+
+bool vm_is_lpar(void)
+{
+	return stsi_get_fc() == 1;
+}
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
index 7abba0cc..d4a82fc0 100644
--- a/lib/s390x/vm.h
+++ b/lib/s390x/vm.h
@@ -8,6 +8,29 @@
 #ifndef _S390X_VM_H_
 #define _S390X_VM_H_
 
+struct stsi_322 {
+	uint8_t reserved[31];
+	uint8_t count;
+	struct {
+		uint8_t reserved2[4];
+		uint16_t total_cpus;
+		uint16_t conf_cpus;
+		uint16_t standby_cpus;
+		uint16_t reserved_cpus;
+		uint8_t name[8];
+		uint32_t caf;
+		uint8_t cpi[16];
+		uint8_t reserved5[3];
+		uint8_t ext_name_encoding;
+		uint32_t reserved3;
+		uint8_t uuid[16];
+	} vm[8];
+	uint8_t reserved4[1504];
+	uint8_t ext_names[8][256];
+};
+
 bool vm_is_tcg(void);
+bool vm_is_kvm(void);
+bool vm_is_lpar(void);
 
 #endif  /* _S390X_VM_H_ */
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 391f8849..e66d07a1 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -13,27 +13,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <smp.h>
+#include <vm.h>
 
-struct stsi_322 {
-	uint8_t reserved[31];
-	uint8_t count;
-	struct {
-		uint8_t reserved2[4];
-		uint16_t total_cpus;
-		uint16_t conf_cpus;
-		uint16_t standby_cpus;
-		uint16_t reserved_cpus;
-		uint8_t name[8];
-		uint32_t caf;
-		uint8_t cpi[16];
-		uint8_t reserved5[3];
-		uint8_t ext_name_encoding;
-		uint32_t reserved3;
-		uint8_t uuid[16];
-	} vm[8];
-	uint8_t reserved4[1504];
-	uint8_t ext_names[8][256];
-};
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_specs(void)
-- 
2.32.0

