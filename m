Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558077193EB
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjFAHJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjFAHJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:09:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E4A128;
        Thu,  1 Jun 2023 00:09:09 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3516llai028300;
        Thu, 1 Jun 2023 07:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v2mWS9PnrRos01+X86+497eEHaveKDfcYONjUoVvHAU=;
 b=AkDoZ4va7eJY2431CzLOSSs0Y1bDPoiLvn2rJcRuZGnfeBTXqlbEqQH2nm5s7kBHXDyg
 iUZOd3RohzcMvqvSmxnoCui1V1WW8a0rEGiKtU17ZlnEHTzMJQSekay8kPmstcjAPX9t
 JFVP1cIL78pHxBjODLol8nhU9dm4XeyJ5+Ea67Hoofbxb81UlEUK822I/33terjRQz7r
 LdFmxDqpIUfBnzmByK9XiZlucsiQ3R9bZgmpPS6JJbXwVR0CfV/k/K0Vb8VaKdCx8/Zb
 nM3fdl/qUicy3xtN1lhWpS7OP/7o0JC7U0cFkmJdz9/ot64+iA0sg6tTwhE3Y2o3JluU vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpcagsmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:09:08 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3516mtwS030329;
        Thu, 1 Jun 2023 07:08:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpcagr3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:08:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3513PKt0017606;
        Thu, 1 Jun 2023 07:02:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5acb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351723gj12124722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 07:02:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2236120040;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F20522004E;
        Thu,  1 Jun 2023 07:02:02 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 07:02:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield for PSW mask
Date:   Thu,  1 Jun 2023 09:01:57 +0200
Message-Id: <20230601070202.152094-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230601070202.152094-1-nrb@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FDpE-iKVb6wKuTlKyBQtYBcbho2VW_YL
X-Proofpoint-ORIG-GUID: HQzHi45RdGPpr79Ipe-d2--YJPiEq7bZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxlogscore=737 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changing the PSW mask is currently little clumsy, since there is only the
PSW_MASK_* defines. This makes it hard to change e.g. only the address
space in the current PSW without a lot of bit fiddling.

Introduce a bitfield for the PSW mask. This makes this kind of
modifications much simpler and easier to read.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 25 ++++++++++++++++++++++++-
 s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bb26e008cc68..84f6996c4d8c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -37,12 +37,35 @@ struct stack_frame_int {
 };
 
 struct psw {
-	uint64_t	mask;
+	union {
+		uint64_t	mask;
+		struct {
+			uint8_t reserved00:1;
+			uint8_t per:1;
+			uint8_t reserved02:3;
+			uint8_t dat:1;
+			uint8_t io:1;
+			uint8_t ext:1;
+			uint8_t key:4;
+			uint8_t reserved12:1;
+			uint8_t mchk:1;
+			uint8_t wait:1;
+			uint8_t pstate:1;
+			uint8_t as:2;
+			uint8_t cc:2;
+			uint8_t prg_mask:4;
+			uint8_t reserved24:7;
+			uint8_t ea:1;
+			uint8_t ba:1;
+			uint32_t reserved33:31;
+		};
+	};
 	uint64_t	addr;
 };
 
 #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
 
+
 struct short_psw {
 	uint32_t	mask;
 	uint32_t	addr;
diff --git a/s390x/selftest.c b/s390x/selftest.c
index 13fd36bc06f8..8d81ba312279 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -74,6 +74,45 @@ static void test_malloc(void)
 	report_prefix_pop();
 }
 
+static void test_psw_mask(void)
+{
+	uint64_t expected_key = 0xF;
+	struct psw test_psw = PSW(0, 0);
+
+	report_prefix_push("PSW mask");
+	test_psw.dat = 1;
+	report(test_psw.mask == PSW_MASK_DAT, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
+
+	test_psw.mask = 0;
+	test_psw.io = 1;
+	report(test_psw.mask == PSW_MASK_IO, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
+
+	test_psw.mask = 0;
+	test_psw.ext = 1;
+	report(test_psw.mask == PSW_MASK_EXT, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
+
+	test_psw.mask = expected_key << (63 - 11);
+	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);
+
+	test_psw.mask = 1UL << (63 - 13);
+	report(test_psw.mchk, "MCHK matches");
+
+	test_psw.mask = 0;
+	test_psw.wait = 1;
+	report(test_psw.mask == PSW_MASK_WAIT, "Wait matches expected=0x%016lx actual=0x%016lx", PSW_MASK_WAIT, test_psw.mask);
+
+	test_psw.mask = 0;
+	test_psw.pstate = 1;
+	report(test_psw.mask == PSW_MASK_PSTATE, "Pstate matches expected=0x%016lx actual=0x%016lx", PSW_MASK_PSTATE, test_psw.mask);
+
+	test_psw.mask = 0;
+	test_psw.ea = 1;
+	test_psw.ba = 1;
+	report(test_psw.mask == PSW_MASK_64, "BA/EA matches expected=0x%016lx actual=0x%016lx", PSW_MASK_64, test_psw.mask);
+
+	report_prefix_pop();
+}
+
 int main(int argc, char**argv)
 {
 	report_prefix_push("selftest");
@@ -89,6 +128,7 @@ int main(int argc, char**argv)
 	test_fp();
 	test_pgm_int();
 	test_malloc();
+	test_psw_mask();
 
 	return report_summary();
 }
-- 
2.39.1

