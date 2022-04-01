Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A474EEC3A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345491AbiDALTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbiDALSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ACA1877FF
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:43 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318tXZ5008580
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hk7jCuI9ezhjIg/8wY3JH0tZ6Tz5LizZU+YcN1Dfiys=;
 b=SY/ZNZ6iW/GnqICREZwjIg0MSsljzBdKrJ5feKJDS4heqGt9x23rcFEWT/r9WND4Cq1E
 WSNmDG44ZBpah09tIVz8ZAVuhJjzxq1WdpQno9NQCXNsBedb1vQhKhVo9YZenIp2zSCD
 nEUgo8/O0AoQ0t07unVm6hmU9GaXE4ulf3EYmKhdNQ0iwaPsJbff/QH4N5lpR1Q00w+h
 07nt1eZYrnkqq9UmAdVlpzq75ltWRHovxB3vFHi6rm6J9O2SN01COJ7b6aNnifOLBR4D
 U2n6uwPx+3BMH3J38kmO/1bOD3sl8NZ6+3LkGtP0PKzRBuZNqGRv9gZmYjbsAnsr21Gx gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5xab2tcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:42 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2319wAig027539
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:42 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5xab2tbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:42 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7Pwv020761;
        Fri, 1 Apr 2022 11:16:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf92wqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGbAH33227094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7DFC4C040;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BEF14C06D;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 26/27] lib: s390x: functions for machine models
Date:   Fri,  1 Apr 2022 13:16:19 +0200
Message-Id: <20220401111620.366435-27-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Lz4Mngf3wnDwrEjpGL_xFQ7vMTXzSlBM
X-Proofpoint-GUID: ygtux8NARI6VTxbdztbreYql46IXhlYb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 adultscore=0 mlxlogscore=635 phishscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* move existing macros for machine models to hardware.h
* add machine_is_* functions

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  3 ---
 lib/s390x/hardware.h     | 10 ++++++++++
 s390x/uv-host.c          |  4 ++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 40626d72..8d860ccf 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -219,9 +219,6 @@ static inline unsigned short stap(void)
 	return cpu_address;
 }
 
-#define MACHINE_Z15A	0x8561
-#define MACHINE_Z15B	0x8562
-
 static inline uint16_t get_machine_id(void)
 {
 	uint64_t cpuid;
diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index e5910ea5..af20be18 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -13,6 +13,9 @@
 #define _S390X_HARDWARE_H_
 #include <asm/arch_def.h>
 
+#define MACHINE_Z15	0x8561
+#define MACHINE_Z15T02	0x8562
+
 enum s390_host {
 	HOST_IS_UNKNOWN,
 	HOST_IS_LPAR,
@@ -37,4 +40,11 @@ static inline bool host_is_lpar(void)
 	return detect_host() == HOST_IS_LPAR;
 }
 
+static inline bool machine_is_z15(void)
+{
+	uint16_t machine = get_machine_id();
+
+	return machine == MACHINE_Z15 || machine == MACHINE_Z15T02;
+}
+
 #endif  /* _S390X_HARDWARE_H_ */
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index de2e4850..d3018e3c 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <hardware.h>
 #include <alloc.h>
 #include <vmalloc.h>
 #include <sclp.h>
@@ -111,7 +112,6 @@ static void test_config_destroy(void)
 static void test_cpu_destroy(void)
 {
 	int rc;
-	uint16_t machineid = get_machine_id();
 	struct uv_cb_nodata uvcb = {
 		.header.len = sizeof(uvcb),
 		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
@@ -126,7 +126,7 @@ static void test_cpu_destroy(void)
 	       "hdr invalid length");
 	uvcb.header.len += 8;
 
-	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
+	if (!machine_is_z15()) {
 		uvcb.handle += 1;
 		rc = uv_call(0, (uint64_t)&uvcb);
 		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
-- 
2.34.1

