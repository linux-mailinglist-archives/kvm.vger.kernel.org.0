Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E894BE628
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358559AbiBUNIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:08:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358544AbiBUNIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:08:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E95C1EC4B;
        Mon, 21 Feb 2022 05:07:54 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LBZ3rx011692;
        Mon, 21 Feb 2022 13:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KrHgcefxFkJNDSHdEUfFE4b1KWfOLQhgZfB62ZWZEGw=;
 b=EwQVeSpRmmOTBhOkHMRk+7xC04MWtgw8ZZq8Wlyzj2225DBJbYhVwrxhzBjNDyuspKfV
 i9W747nfW/Q5jEF+r9BQcaLASlXVwMRriNo/uIl8TIkXo/kkqADFzsf27LILMuAhTOAX
 vW1DDgpwSDtJLVkKq9fK/mLdL+aAoeVnIwqPpWINjUH6P1ngz5smLXql27LqfaZvD5Mn
 hGqc06wBbyllOZ7fjUaLtcI5yP8K50HeYebCuGTW1YZ9hWCIHCleX3hYtVRSbxjBTZYE
 mhhdKUy41uE5vzks2coQcyNyVI33mhKoGFffial0aHfphOsPNAGCy+Fz9rm6czTPMQW/ Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ec5sff589-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:53 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LCsNPF022537;
        Mon, 21 Feb 2022 13:07:53 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ec5sff57t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LCwqIi012801;
        Mon, 21 Feb 2022 13:07:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3ear68stgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LD7mPU45351260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:07:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1794E4C04A;
        Mon, 21 Feb 2022 13:07:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA16A4C040;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/8] s390x: Add test for PFMF low-address protection
Date:   Mon, 21 Feb 2022 14:07:40 +0100
Message-Id: <20220221130746.1754410-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221130746.1754410-1-nrb@linux.ibm.com>
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YHyYkl5jxMAN4qGZxIi6_7zH92rfpcTt
X-Proofpoint-ORIG-GUID: cUQwGYNBkWqWD6CvGIfJ00uWLgRNMjpo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_06,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 mlxlogscore=707
 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
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

