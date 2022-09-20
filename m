Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378C45BDE3B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiITHcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiITHcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:32:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819C15FF45;
        Tue, 20 Sep 2022 00:32:16 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7C0Im005810;
        Tue, 20 Sep 2022 07:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=whKim/Xq+IG5qT1dAB6h70ws4IH7R5f+Ji5JDcPeiPI=;
 b=cvlo4D/UAnRtUOTmdLH6mKKvTAD+kxekEAxCdPiTG9UeaerOIouAzFTG1FS+ufIi8syR
 MEqXQ9YqbrpgtlptAElnlIZEJOuJ+I0F2rgsyWWvlAQuIlokoTRKR6wXjH9TIEti50pw
 IWEUn16oIRU5sOPZV9ieFZRZ4FqV6yDTD8yIh6JoaiVSYRTRW5rR7a63tVw062zvNo6U
 MoZZSN8WbNyOHx4yfVqfddjyXkuEWNIhma2WV0x4hklUeUQdEvSywTB8n5XNrQdg9kKt
 +fRbaAMxRKFUfcQUCWpsXlBZ/gOBAmo+M+zhfZm5xah//MorXz09O7dPJQ1LKHVGg+Vg UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8j0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:15 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7JROG008354;
        Tue, 20 Sep 2022 07:32:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8hy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7KweW030734;
        Tue, 20 Sep 2022 07:32:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3jn5gj3fqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7W9MD31588810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9916911C050;
        Tue, 20 Sep 2022 07:32:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D3EC11C04A;
        Tue, 20 Sep 2022 07:32:08 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 09/11] s390x: Add strict mode to specification exception interpretation test
Date:   Tue, 20 Sep 2022 07:30:33 +0000
Message-Id: <20220920073035.29201-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e0xb8d737ReSJbrlngs_bieMseVPddqP
X-Proofpoint-GUID: zhjYdaNKEMAE1lTYGlog4mOERrA5b3tW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

While specification exception interpretation is not required to occur,
it can be useful for automatic regression testing to fail the test if it
does not occur.
Add a `--strict` argument to enable this.
`--strict` takes a list of machine types (as reported by STIDP)
for which to enable strict mode, for example
`--strict 3931,8562,8561,3907,3906,2965,2964`
will enable it for models z16 - z13.
Alternatively, strict mode can be enabled for all but the listed machine
types by prefixing the list with a `!`, for example
`--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
will enable it for z/Architecture models except those older than z13.
`--strict !` will enable it always.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220825112047.2206929-1-scgl@linux.ibm.com
Message-Id: <20220825112047.2206929-1-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/spec_ex-sie.c | 53 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index d8e25e75..5fa135b8 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -7,16 +7,19 @@
  * specification exception interpretation is off/on.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include <sclp.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
 #include <sie.h>
 #include <snippet.h>
+#include <hardware.h>
 
 static struct vm vm;
 extern const char SNIPPET_NAME_START(c, spec_ex)[];
 extern const char SNIPPET_NAME_END(c, spec_ex)[];
+static bool strict;
 
 static void setup_guest(void)
 {
@@ -37,6 +40,8 @@ static void reset_guest(void)
 
 static void test_spec_ex_sie(void)
 {
+	const char *msg;
+
 	setup_guest();
 
 	report_prefix_push("SIE spec ex interpretation");
@@ -60,16 +65,60 @@ static void test_spec_ex_sie(void)
 	report(vm.sblk->icptcode == ICPT_PROGI
 	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
 	       "Received specification exception intercept");
-	if (vm.sblk->gpsw.addr == 0xdeadbeee)
-		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
+	msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
+	if (strict)
+		report(vm.sblk->gpsw.addr == 0xdeadbeee, "%s", msg);
+	else if (vm.sblk->gpsw.addr == 0xdeadbeee)
+		report_info("%s", msg);
 	else
 		report_info("Did not interpret initial exception");
 	report_prefix_pop();
 	report_prefix_pop();
 }
 
+static bool parse_strict(int argc, char **argv)
+{
+	uint16_t machine_id;
+	char *list;
+	bool ret;
+
+	if (argc < 1)
+		return false;
+	if (strcmp("--strict", argv[0]))
+		return false;
+
+	machine_id = get_machine_id();
+	if (argc < 2) {
+		printf("No argument to --strict, ignoring\n");
+		return false;
+	}
+	list = argv[1];
+	if (list[0] == '!') {
+		ret = true;
+		list++;
+	} else {
+		ret = false;
+	}
+	while (true) {
+		long input = 0;
+
+		if (strlen(list) == 0)
+			return ret;
+		input = strtol(list, &list, 16);
+		if (*list == ',')
+			list++;
+		else if (*list != '\0')
+			break;
+		if (input == machine_id)
+			return !ret;
+	}
+	printf("Invalid --strict argument \"%s\", ignoring\n", list);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
+	strict = parse_strict(argc - 1, argv + 1);
 	if (!sclp_facilities.has_sief2) {
 		report_skip("SIEF2 facility unavailable");
 		goto out;
-- 
2.34.1

