Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFACB4C3026
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiBXPo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiBXPoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:44:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F7622EDD2;
        Thu, 24 Feb 2022 07:43:45 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFFBTf031539;
        Thu, 24 Feb 2022 15:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pu9AstKRNHoIfgMGNQm32th3XhIKfJSwPX2Y6Y8L7yQ=;
 b=icSW8epKVqKe5/Lw693g5lRk8DN+fZG6PbpULssADovfUDxaeQien/qZYwS0G2YgA2vc
 6nnLnmIGRR04E7ZeAs5SlP/Dw0ChQv6OEcJdCccKesC3sF5fWgXsrFTCoK8wCZklkDvz
 XshPW9Aw6y6woe2Zage+7/X6iW6hIxah+3wNG0JEz+SrK5bDAVO+ARhYsMKoZ4FczJ3o
 9/cbWoaVqYxaGqSy2tk7RgKAACINWpV8+AXf3Xiktvtt26eZU9a7g1G0MMR56b9Dduyx
 C0UaQjQHhurCJs1jag60YjBTQwQLlu486mzfq62IBYGKkuUEadZnXqsW3Vi3YTefVkO9 OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6xnqkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OFd22v028652;
        Thu, 24 Feb 2022 15:43:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6xnqjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OFbpkB005306;
        Thu, 24 Feb 2022 15:43:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69jv5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OFhc6P54591934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:43:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8CC42041;
        Thu, 24 Feb 2022 15:43:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F3A942049;
        Thu, 24 Feb 2022 15:43:37 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:43:37 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/8] s390x: Add tests for STCRW
Date:   Thu, 24 Feb 2022 16:43:32 +0100
Message-Id: <20220224154336.3459839-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220224154336.3459839-1-nrb@linux.ibm.com>
References: <20220224154336.3459839-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xX6Ji5Hc-Jabq9ZpCww8EsVWYkKQsW_J
X-Proofpoint-ORIG-GUID: V5uB6s_SPz3NSLF8IW8cY50jswywi2z4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test consists of two parts: First a simple check to ensure we
enforce an aligned address. We test misalignment by 1 and 2 bytes.

The second part tests the handling of pending Channel Reports (CR). We
first assume no CR is initally pending and check STCRW returns
accordingly. Then, we generate a CR by resetting a Channel Path using
RCHP and make sure this results in exactly one CRW being generated which
has a Reporting-Source Code (RSC) corresponding to the Channel Path
facility.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 17 ++++++++++
 lib/s390x/css_lib.c | 60 +++++++++++++++++++++++++++++++++
 s390x/css.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0db8a28166f6..a6a68577248b 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -266,6 +266,20 @@ static inline int rchp(unsigned long chpid)
 	return cc;
 }
 
+static inline int stcrw(uint32_t *crw)
+{
+	int cc;
+
+	asm volatile(
+		"	stcrw	%[crw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
+		: [crw] "Q" (*crw)
+		: "cc", "memory");
+	return cc;
+}
+
 /* Debug functions */
 char *dump_pmcw_flags(uint16_t f);
 char *dump_scsw_flags(uint32_t f);
@@ -294,6 +308,9 @@ int css_residual_count(unsigned int schid);
 void enable_io_isc(uint8_t isc);
 int wait_and_check_io_completion(int schid);
 
+int css_find_installed_chpid(int sid, uint8_t *chpid_out);
+int css_generate_crw(int sid);
+
 /*
  * CHSC definitions
  */
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 80e9e078b0f6..a9f5097f3486 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -504,3 +504,63 @@ void enable_io_isc(uint8_t isc)
 	value = (uint64_t)isc << 24;
 	lctlg(6, value);
 }
+
+static int is_path_installed(struct schib *schib, int chp_idx)
+{
+	return schib->pmcw.pim & BIT(7 - chp_idx);
+}
+
+/*
+ * css_find_installed_chpid: find any installed CHPID
+ * @sid: subsystem-identification word
+ * @chpid_out: store the found chpid here, left alone if none found
+ *
+ * returns 0 on success, -1 if no chpid found any other value
+ * indicates the condition code of a failing STSCH instruction
+ */
+int css_find_installed_chpid(int sid, uint8_t *chpid_out)
+{
+	int cc;
+
+	cc = stsch(sid, &schib);
+	if (cc) {
+		report_fail("%s: sch %08x failed with cc=%d", __func__, sid, cc);
+		return cc;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(schib.pmcw.chpid); i++) {
+		if (is_path_installed(&schib, i)) {
+			*chpid_out = schib.pmcw.chpid[i];
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+/*
+ * css_generate_crw: Generate a CRW by issuing RCHP on any channel path
+ * @sid: subsystem-identification word
+ *
+ * returns 0 when a CRW was generated, -1 if no chpid found.
+ */
+int css_generate_crw(int sid)
+{
+	int ret, cc;
+	uint8_t chpid;
+
+	report_prefix_push("Generate CRW");
+
+	ret = css_find_installed_chpid(sid, &chpid);
+	if (ret) {
+		report_fail("No CHPID found: ret=%d", ret);
+		return -1;
+	}
+
+	cc = rchp(chpid);
+	report(!cc, "rhcp cc != 0");
+
+	report_prefix_pop();
+
+	return 0;
+}
diff --git a/s390x/css.c b/s390x/css.c
index 396007ed0074..fcc264eecd4b 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -388,6 +388,87 @@ static void test_msch(void)
 	schib.pmcw.flags = old_pmcw_flags;
 }
 
+static void check_stcrw_no_crw_available(void)
+{
+	uint32_t crw = 0xfeedc0fe;
+	int cc;
+
+	report_prefix_push("No CRW available");
+	cc = stcrw(&crw);
+	report(cc == 1, "cc == 1");
+	report(!crw, "stored zeroes in crw");
+	report_prefix_pop();
+}
+
+static int check_stcrw_crw_available(void)
+{
+	const uint32_t magic = 0xfeedc0fe;
+	uint32_t crw = magic;
+	int cc;
+
+	report_prefix_push("CRW available");
+	cc = stcrw(&crw);
+	report(!cc, "cc is zero");
+	report(crw != magic, "stored crw");
+	report_prefix_pop();
+
+	return crw;
+}
+
+static uint32_t crw_get_rsc(uint32_t crw)
+{
+	const int rsc_begin = 4;
+	const int rsc_end = 8;
+
+	return (crw & GENMASK(31 - rsc_begin, 31 - rsc_end)) >> 24;
+}
+
+#define CRW_RSC_CHP 4
+static void test_stcrw(void)
+{
+	const int align_to = 4;
+	int res;
+	uint32_t crw;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		stcrw((uint32_t *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("No CRW available initally");
+	check_stcrw_no_crw_available();
+	report_prefix_pop();
+
+	res = css_generate_crw(test_device_sid);
+	if (res) {
+		report_skip("Couldn't generate CRW");
+		report_prefix_pop();
+		return;
+	}
+
+	crw = check_stcrw_crw_available();
+
+	report_prefix_push("CRW available");
+	report(crw_get_rsc(crw) == CRW_RSC_CHP, "CRW has Channel Path RSC");
+	report_prefix_pop();
+
+	report_prefix_push("No more CRWs pending");
+	check_stcrw_no_crw_available();
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -401,6 +482,7 @@ static struct {
 	{ "measurement block format0", test_schm_fmt0 },
 	{ "measurement block format1", test_schm_fmt1 },
 	{ "msch", test_msch },
+	{ "stcrw", test_stcrw },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

