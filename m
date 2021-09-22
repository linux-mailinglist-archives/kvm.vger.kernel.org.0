Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A075414280
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhIVHVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233224AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M6CHju002230;
        Wed, 22 Sep 2021 03:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4ss7HmEsyat2vGelfcJ0IuW7pbqUh/m+mu/4ID9rTB0=;
 b=rAoweTDssqsmwtA1eoVfORnooYPChli+xkEW5rccQFX2nMweakt/Irg01tiMH32rQxrf
 jsXcLAxHV5Vqju/Qq6Kuj9JE6JBmq2vl8j2G6+EXJZtzXQWB4S+t7Ykjca+ZLipkd/Oc
 +KXFgIJEAJ5uxMN0ZsxemrOd0b6tK55npAaF11jhOjetxt56KHUvU8uQ6umsMXh6JGlK
 aVSe7iklKcv1pDzXzQNG3sLbf57MmircB4GX0BK5zFAIECBJ43PcTZqAgXprRHrbM9Ub
 xaTNRL3ItQLy6CEWIZ8gcBRnfFhf5wWhqoQl7FmXlAG4L8ADBOLviu75vFIN5Y0566Df sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y0t1ahp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:02 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M70V0H018920;
        Wed, 22 Sep 2021 03:19:02 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y0t1agu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M78EDM013391;
        Wed, 22 Sep 2021 07:18:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pkgrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:18:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7Iu9x42205584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:18:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB426A404D;
        Wed, 22 Sep 2021 07:18:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F1A6A4040;
        Wed, 22 Sep 2021 07:18:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/9] s390x: uv-host: Fence a destroy cpu test on z15
Date:   Wed, 22 Sep 2021 07:18:05 +0000
Message-Id: <20210922071811.1913-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tQpmIP8SfBchTBUfPtpm75MFW-gGVf0v
X-Proofpoint-ORIG-GUID: WifSacb_KyzC-N-9ZMy8coHxAY3Y0U0-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Firmware will not give us the expected return code on z15 so let's
fence it for the z15 machine generation.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 14 ++++++++++++++
 s390x/uv-host.c          | 11 +++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index aa80d840..c8d2722a 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -219,6 +219,20 @@ static inline unsigned short stap(void)
 	return cpu_address;
 }
 
+#define MACHINE_Z15A	0x8561
+#define MACHINE_Z15B	0x8562
+
+static inline uint16_t get_machine_id(void)
+{
+	uint64_t cpuid;
+
+	asm volatile("stidp %0" : "=Q" (cpuid));
+	cpuid = cpuid >> 16;
+	cpuid &= 0xffff;
+
+	return cpuid;
+}
+
 static inline int tprot(unsigned long addr)
 {
 	int cc;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 66a11160..5e351120 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -111,6 +111,7 @@ static void test_config_destroy(void)
 static void test_cpu_destroy(void)
 {
 	int rc;
+	uint16_t machineid = get_machine_id();
 	struct uv_cb_nodata uvcb = {
 		.header.len = sizeof(uvcb),
 		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
@@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
 	       "hdr invalid length");
 	uvcb.header.len += 8;
 
-	uvcb.handle += 1;
-	rc = uv_call(0, (uint64_t)&uvcb);
-	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
-	uvcb.handle -= 1;
+	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
+		uvcb.handle += 1;
+		rc = uv_call(0, (uint64_t)&uvcb);
+		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
+		uvcb.handle -= 1;
+	}
 
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(rc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "success");
-- 
2.30.2

