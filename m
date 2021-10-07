Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F736424F80
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhJGIxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:53:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240485AbhJGIxy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:53:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19786hWm021775;
        Thu, 7 Oct 2021 04:52:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wu/UXCJ9rEYWnVBOPmJXB29t8tJSe8kkCQ0naLkPsT8=;
 b=fTwIIt/L8QVvik8v49WEIzEr0xyKTlilfi+78wHnCrex3eYgRGY+bDHEd0C1+wvxdJm+
 hp9qBzvdJwF32n/7BgqguNZqO5cC5bB82DoQ2MjtDBINTa2Y9w1hCTi49DqUEdyehGUY
 mnKbvBgFgSuSyAX3llSr2iW2DK7KrBNgDi35cpsuPzoork5ifNY6PtCo1V9z5ic8CwXG
 a29cHHDHRZOIzf4bLEU6/RMLOPWROH4/UIgeiAEeDrOtLaPev30rlqnQpHXtM0QNVtBm
 9nZOSltR5IYbnciqPGuAlSXNHoTDsR9lF+tWyj+g0Fgq7qtSNtBnJRBl+2Jx7YrdBN63 EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhkcx4fgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:01 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978kOvZ001010;
        Thu, 7 Oct 2021 04:52:00 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhkcx4fg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:00 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978hB5f015790;
        Thu, 7 Oct 2021 08:51:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3beepk2u4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:51:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978pnO754526274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:51:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6B1AAE077;
        Thu,  7 Oct 2021 08:51:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E61EAE089;
        Thu,  7 Oct 2021 08:51:45 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 2/9] s390x: uv-host: Fence a destroy cpu test on z15
Date:   Thu,  7 Oct 2021 08:50:20 +0000
Message-Id: <20211007085027.13050-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q2Et1E5nz3Wre3fsQ7X5wbNN8Iqs6faq
X-Proofpoint-ORIG-GUID: bIsaKRY1Hgt6RE7yZIXoZyKHuNjdb1fk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Firmware will not give us the expected return code on z15 so let's
fence it for the z15 machine generation.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
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
index 4b72c24d..92a41069 100644
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

