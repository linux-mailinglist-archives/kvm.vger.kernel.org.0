Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7214961C8
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381520AbiAUPJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:09:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1381492AbiAUPJk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:40 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEpNwg028909;
        Fri, 21 Jan 2022 15:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Gz1oOT0+sJTfDUghGM81jbDa/7xEBzyalt4CzfgUJJ4=;
 b=ZEsPt1Y0lZVeITtlsUBhKtJP8fpoun0+aGA/akc5YpoD/ue1rkuO2Xtgzn7+fGcOu9w0
 pkyBemq7je5fk7BaIXzOPK15/9mRl9AJEtPmnwQkPOi32ewBapVvXdvz4PfkEaXlUWhg
 5k1BM+SmqDvEidVkUHnKG7ryLtKT1B7KXNB4ZGvYcIU9CG5MgYi50F9I+sDyiTQWYuiS
 r4DVIhWp1GzBOW5S+/xv/mCS7/VNNHVcZL0r/X9u4I+ZgmO2lm0ZR2g251UhzKP2fLVL
 Ha5BW6SC1C3AYd0jeFBrrInjnjdzh/m5xWUCGeMnAnoGgcpaef0LyJz5f96YRhoHBfrp 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:38 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LEpTUH029450;
        Fri, 21 Jan 2022 15:09:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF1x6e013928;
        Fri, 21 Jan 2022 15:09:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dqj37wx3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9WEr37486996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEE4E4203F;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CB4842042;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 2/8] s390x: Add test for PFMF low-address protection
Date:   Fri, 21 Jan 2022 16:09:25 +0100
Message-Id: <20220121150931.371720-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CwCFev-lZ4nkDVki-GSLOek3xKq8CwOK
X-Proofpoint-ORIG-GUID: yRgMDvfXJrLVJrWifUe_YyLGiGGH-Szt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=667
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PFMF should respect the low-address protection when clearing pages, hence
add some tests for it.

When low-address protection fails, clearing frame 0 is a destructive
operation. It messes up interrupts and thus printing test results won't
work properly. Hence, we first attempt to clear frame 1 which is not as
destructive.

Doing it this way around increases the chances for the user to see a
proper failure message instead of QEMU randomly quitting in the middle
of the test run.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/pfmf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 2f3cb110dc4c..aa1305292ee8 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -113,6 +113,34 @@ static void test_1m_clear(void)
 	report_prefix_pop();
 }
 
+static void test_low_addr_prot(void)
+{
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_4K
+	};
+
+	report_prefix_push("low-address protection");
+
+	report_prefix_push("0x1000");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, (void *)0x1000);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_push("0x0");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, 0);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_edat = test_facility(8);
@@ -124,6 +152,7 @@ int main(void)
 	}
 
 	test_priv();
+	test_low_addr_prot();
 	/* Force the buffer pages in */
 	memset(pagebuf, 0, PAGE_SIZE * 256);
 
-- 
2.31.1

