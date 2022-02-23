Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902644C1057
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239598AbiBWKfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiBWKfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:35:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E5F692A7
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 02:34:53 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8FwAG025097
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cxmMYJYFVhk4IHnneokE4nkJ1kIT3KikGrN/d/RihM4=;
 b=iN3eknnzVONjNPjlUvqxjKLLAo70ljuFKptCtbrvMzQr4wN7xnLwpyy14ryKDhYagq9a
 ikpea3bkTfZ0/JRcAOdq2l1HVLRJU3cKtpn0t7DlCjjkSrhRSQhKKvavXA0WTbDbcC7O
 Rud1JkodmkVB+gQ1hDc3eYaSHVsebEiuyvAzjMebB3SJpvcqYR14kUKD/W0bNtrokMJh
 AhQ3sDN+lDcAu+BgNtIVGqbbpmBJGO/yJWqOlx7Fyd3lTh+exIIopY5Q9hel7XcPGbnh
 N9BB3fl34JJa+kq0o52kpH/sFMbU6J6ap4XIIStlU7bPmymKr7RXW31a64qxM84tnEvK oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edh8xjg75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:52 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NAYqpT010364
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:52 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edh8xjg6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:34:52 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NAX4B9014733;
        Wed, 23 Feb 2022 10:34:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear697k83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:34:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NAYl2w45416938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 10:34:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CA6DA406F;
        Wed, 23 Feb 2022 10:34:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B8C4A4071;
        Wed, 23 Feb 2022 10:34:47 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 10:34:46 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH 1/1] scripts/runtime: add test result to log and TAP output
Date:   Wed, 23 Feb 2022 11:34:46 +0100
Message-Id: <20220223103446.2681293-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223103446.2681293-1-nrb@linux.ibm.com>
References: <20220223103446.2681293-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ja6ltMd9QIgrcEuYNJG29qU93z7SjEzO
X-Proofpoint-GUID: gwSh7kimgrDLCjisQSggcuOlx9N48cbg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_03,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, when a test exits prematurely for whatever reason (crash, guest
exception, ...) the test is correctly reported as FAIL by run_tests.sh - even
when all report()s up to that point passed.

The failure is reported by print_result which checks (among others) the exit
code of the arch-specific run script.

But, as soon as one enables the TAP output in run_tests.sh, there is no way to
see that any more, as the print_result is discarded and only the run script's
output is converted to TAP.

External test runners relying on TAP output will thus believe everything is
fine even though we got a crash.

The same also applies to the logfiles.

As a simple fix, have print_result also print to RUNTIME_log_stderr.  For each
test, we will then get an additional test line in the TAP which reports the
test's result:

  not ok 36 - css: (35 tests, 2 unexpected failures)

The log files will also contain the result:

  FAIL: (35 tests, 2 unexpected failures)

This makes it easy to see whether we had a premature exit in the test. The
disadvantage being the number of test lines in the TAP will no longer match the
number of report()s in a test.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/runtime.bash | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6d5fced94246..7bb70d50012a 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -60,8 +60,10 @@ function print_result()
 
     if [ -z "$reason" ]; then
         echo "`$status` $testname $summary"
+        RUNTIME_log_stderr "$testname" <<< "$status: $summary"
     else
         echo "`$status` $testname ($reason)"
+        RUNTIME_log_stderr "$testname" <<< "$status: $reason"
     fi
 }
 
-- 
2.31.1

