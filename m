Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBC74C4C14
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 18:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243646AbiBYRYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 12:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbiBYRYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 12:24:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289DD19D743;
        Fri, 25 Feb 2022 09:24:07 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PHGPvY006507;
        Fri, 25 Feb 2022 17:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VtqGJjyvYkgfNdvmFGFNVRXmE2DVqgFN7yPq5Xbs6Zw=;
 b=IG9m/Kn8w9ztA8e7mV7bInN26f7oNlHs800PgK5iEjzzRDMEK+u311G/tnnFLKLoMBYj
 ihxNiNRKw9d3d/Ywc2QV8rLGXeZcQs6372bJWaQBDNqK9Sf9rbjSgj5nIj9FGTquXcwD
 G4+5w6EtMgTdppDgakFdaC+M1qlWR0TXw1mnvRAG3E/TpFwTdhPeLQQyCsscFMGrSVr0
 DYAHayeXW3bn4YxLJKkZn47NQG8hbIWZFnwHiBZ5+ej04vuZkkDmirLF0+GQV5q9DOuE
 VW+zdACzgkt1E7scPpQVo/xfsDeV8sD/d/uE6YZ1ee6zhPqaFoUFHewvP+cGEI9K8vHm 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eew872b8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 17:24:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21PGeBW2015606;
        Fri, 25 Feb 2022 17:24:06 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eew872b7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 17:24:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PHNqW9000769;
        Fri, 25 Feb 2022 17:24:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69qvfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 17:24:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PHNww734734548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 17:23:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 493EE52051;
        Fri, 25 Feb 2022 17:23:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0FB6652050;
        Fri, 25 Feb 2022 17:23:58 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] s390x: Add strict mode to specification exception interpretation test
Date:   Fri, 25 Feb 2022 18:23:55 +0100
Message-Id: <20220225172355.3564546-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hPJ1KN4z-GitkAa125J6ptyipC4ydtrG
X-Proofpoint-GUID: Xg1Z2N4RtSLezmFYktjUY1E08l_AkBry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_09,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
`--strict 8562,8561,3907,3906,2965,2964`
will enable it for models z15 - z13.
Alternatively, strict mode can be enabled for all but the listed machine
types by prefixing the list with a `!`, for example
`--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
will enable it for z/Architecture models except those older than z13.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
Range-diff:
1:  5d91f693 < -:  -------- s390x: Add specification exception interception test
2:  950eafd7 ! 1:  e9c36970 s390x: Add strict mode to specification exception interpretation test
    @@ s390x/spec_ex-sie.c: static void reset_guest(void)
     -static void test_spec_ex_sie(void)
     +static void test_spec_ex_sie(bool strict)
      {
    ++	const char *msg;
    ++
      	setup_guest();
      
    + 	report_prefix_push("SIE spec ex interpretation");
     @@ s390x/spec_ex-sie.c: static void test_spec_ex_sie(void)
      	report(vm.sblk->icptcode == ICPT_PROGI
      	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
      	       "Received specification exception intercept");
     -	if (vm.sblk->gpsw.addr == 0xdeadbeee)
     -		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
    --	else
    --		report_info("Did not interpret initial exception");
    -+	{
    -+		const char *msg;
    -+
    -+		msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
    -+		if (strict)
    -+			report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
    -+		else if (vm.sblk->gpsw.addr == 0xdeadbeee)
    -+			report_info(msg);
    -+		else
    -+			report_info("Did not interpret initial exception");
    -+	}
    ++	msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
    ++	if (strict)
    ++		report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
    ++	else if (vm.sblk->gpsw.addr == 0xdeadbeee)
    ++		report_info(msg);
    + 	else
    + 		report_info("Did not interpret initial exception");
      	report_prefix_pop();
      	report_prefix_pop();
      }
      
    -+static bool parse_strict(char **argv)
    ++static bool parse_strict(int argc, char **argv)
     +{
     +	uint16_t machine_id;
     +	char *list;
     +	bool ret;
     +
    -+	if (!*argv)
    ++	if (argc < 1)
     +		return false;
    -+	if (strcmp("--strict", *argv))
    ++	if (strcmp("--strict", argv[0]))
     +		return false;
     +
     +	machine_id = get_machine_id();
    -+	list = argv[1];
    -+	if (!list) {
    ++	if (argc < 2) {
     +		printf("No argument to --strict, ignoring\n");
     +		return false;
     +	}
    ++	list = argv[1];
     +	if (list[0] == '!') {
     +		ret = true;
     +		list++;
    @@ s390x/spec_ex-sie.c: int main(int argc, char **argv)
      	}
      
     -	test_spec_ex_sie();
    -+	test_spec_ex_sie(parse_strict(argv + 1));
    ++	test_spec_ex_sie(parse_strict(argc - 1, argv + 1));
      out:
      	return report_summary();
      }

 s390x/spec_ex-sie.c | 53 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5dea4115..071110e3 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -7,6 +7,7 @@
  * specification exception interpretation is off/on.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include <sclp.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
@@ -36,8 +37,10 @@ static void reset_guest(void)
 	vm.sblk->icptcode = 0;
 }
 
-static void test_spec_ex_sie(void)
+static void test_spec_ex_sie(bool strict)
 {
+	const char *msg;
+
 	setup_guest();
 
 	report_prefix_push("SIE spec ex interpretation");
@@ -61,14 +64,56 @@ static void test_spec_ex_sie(void)
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
+	} else
+		ret = false;
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
 	if (!sclp_facilities.has_sief2) {
@@ -76,7 +121,7 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	test_spec_ex_sie();
+	test_spec_ex_sie(parse_strict(argc - 1, argv + 1));
 out:
 	return report_summary();
 }

base-commit: 257c962f3d1b2d0534af59de4ad18764d734903a
-- 
2.33.1

