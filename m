Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D063566902
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 13:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiGELRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 07:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiGELRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 07:17:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1D11402B;
        Tue,  5 Jul 2022 04:17:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2659FITj029257;
        Tue, 5 Jul 2022 11:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=I36b3F611wmvBT+hAeI5/d8HXSvCoWzHSDh1HROzQEQ=;
 b=MsRFGN7q06WGdbLUb7EbA53x3p4AGrd82SD4FC9Yo83M9VnMRzTkapwZ/tIJQMCZm/6w
 uUY86qKGJBzvA0R9Ui5boiGMVfJVCzFHdVKRxirvYCdPnsNvw4kTmpp3GwQ/cx1kOrMG
 V/cfOtnNEsGu+MydUA6ijvpJz6+mgFbjmPkGWRE7v8e+qBgsc89dru8H4BU+2TEVQZjX
 i54Q6miVjDGZkJQJhjkl9iwRB9VOzEZFftzHD6LyZOuWc9FbmaqFBq/puiigXNhSsu+i
 5V5leL/85lrL9wPkpvOaC6JnW+xoteXq84kT3AeCJG9JZTEWqbbeZ+4hmVcA2IfBegC/ hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4jgs2m5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:17:15 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265AW9aR006741;
        Tue, 5 Jul 2022 11:17:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4jgs2m4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:17:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265B7Y8g011627;
        Tue, 5 Jul 2022 11:17:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3h2dn8uwkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:17:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265BH9cg23265734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 11:17:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDFDFA404D;
        Tue,  5 Jul 2022 11:17:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EDC7A4040;
        Tue,  5 Jul 2022 11:17:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 11:17:09 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3] s390x: Add strict mode to specification exception interpretation test
Date:   Tue,  5 Jul 2022 13:17:07 +0200
Message-Id: <20220705111707.3772070-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R5KFu4WyYBLn9usniyhVMAFLGX-MvF78
X-Proofpoint-GUID: eRDlA1VjQXgQrFC0oCLzPtOv0IfUfwfz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
v2 -> v3
 * rebase on master
 * global strict bool
 * fix style issue

Range-diff against v2:
1:  e9c36970 ! 1:  c707481c s390x: Add strict mode to specification exception interpretation test
    @@ Commit message
         Add a `--strict` argument to enable this.
         `--strict` takes a list of machine types (as reported by STIDP)
         for which to enable strict mode, for example
    -    `--strict 8562,8561,3907,3906,2965,2964`
    -    will enable it for models z15 - z13.
    +    `--strict 3931,8562,8561,3907,3906,2965,2964`
    +    will enable it for models z16 - z13.
         Alternatively, strict mode can be enabled for all but the listed machine
         types by prefixing the list with a `!`, for example
         `--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
    @@ s390x/spec_ex-sie.c
      #include <sclp.h>
      #include <asm/page.h>
      #include <asm/arch_def.h>
    + #include <alloc_page.h>
    + #include <sie.h>
    + #include <snippet.h>
    ++#include <hardware.h>
    + 
    + static struct vm vm;
    + extern const char SNIPPET_NAME_START(c, spec_ex)[];
    + extern const char SNIPPET_NAME_END(c, spec_ex)[];
    ++static bool strict;
    + 
    + static void setup_guest(void)
    + {
     @@ s390x/spec_ex-sie.c: static void reset_guest(void)
    - 	vm.sblk->icptcode = 0;
    - }
      
    --static void test_spec_ex_sie(void)
    -+static void test_spec_ex_sie(bool strict)
    + static void test_spec_ex_sie(void)
      {
     +	const char *msg;
     +
    @@ s390x/spec_ex-sie.c: static void test_spec_ex_sie(void)
     +	if (list[0] == '!') {
     +		ret = true;
     +		list++;
    -+	} else
    ++	} else {
     +		ret = false;
    ++	}
     +	while (true) {
     +		long input = 0;
     +
    @@ s390x/spec_ex-sie.c: static void test_spec_ex_sie(void)
     +
      int main(int argc, char **argv)
      {
    ++	strict = parse_strict(argc - 1, argv + 1);
      	if (!sclp_facilities.has_sief2) {
    -@@ s390x/spec_ex-sie.c: int main(int argc, char **argv)
    + 		report_skip("SIEF2 facility unavailable");
      		goto out;
    - 	}
    - 
    --	test_spec_ex_sie();
    -+	test_spec_ex_sie(parse_strict(argc - 1, argv + 1));
    - out:
    - 	return report_summary();
    - }

 s390x/spec_ex-sie.c | 53 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index d8e25e75..e5f39451 100644
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
+		report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
+	else if (vm.sblk->gpsw.addr == 0xdeadbeee)
+		report_info(msg);
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

base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d
-- 
2.36.1

