Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258194E3FC4
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiCVNpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiCVNpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:45:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F3C2612F
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:44:15 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MC6LZd016075
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=a+7MHo7UW4CIFdpbbnVaBKjeSPshmvRQvUb0x4qFX40=;
 b=ZPGYH9lw3hIWby/UQQElWSjWCm+mQpoUzwRaLmSjMnpiXDAObXzuj7Aa0f/fcNFP1kcF
 06U1sHIT48dVTVijHcm+anJ0KynXdFGIOhkZeE/wgjmdMFgXSBnVxp9Yj20fN7+cOolT
 1xdhXZTQ8FUcRY2wVEIBOBAJwVawQ8EiVFj+Yj4R8e+jwx7f1J53a9uz+Wq6fNN0B35v
 k2dmqXA4/FmjAhYqKfPzVpwGxTQ53XWwCvG5K3t47hmEFQK3hmVxGquAzORv7EkA4HYa
 hyr6koAwu8KZ/A1olphni9fn4dej5cg6IMviO6JSbOM9wDzCfTptFU2GE6g/54O3cr+D /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86ut8ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:14 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MChQ1e005351
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:14 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86ut8km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:44:14 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MDYwtF005878;
        Tue, 22 Mar 2022 13:44:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8nebd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:44:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDWRnT47710578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:32:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AA01A4040;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6505EA4053;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/1] runtime: indicate failure on crash/timeout/abort in TAP
Date:   Tue, 22 Mar 2022 14:44:07 +0100
Message-Id: <20220322134407.614587-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220322134407.614587-1-nrb@linux.ibm.com>
References: <20220322134407.614587-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NsbykabdVvacwnthQbO6AAK0BRVG95Z_
X-Proofpoint-ORIG-GUID: qeNqKwpIJiOxVOFIgT118LTzsy26cvsd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=955
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we have crashes, timeouts or aborts, there is currently no indication for
this in the TAP output. When all reports() up to this point succeeded, this
might result in a TAP file looking completely fine even though things went
terribly wrong.

For example, when I set the timeout for the diag288 test on s390x to 1 second,
it fails because it takes quite long, which is properly indicated in the
normal output:

$ ./run_tests.sh diag288
FAIL diag288 (timeout; duration=1s)

But, when I enable TAP output, I get this:

$ ./run_tests.sh -t diag288
TAP version 13
ok 1 - diag288: diag288: privileged: Program interrupt: expected(2) == received(2)
ok 2 - diag288: diag288: specification: uneven: Program interrupt: expected(6) == received(6)
ok 3 - diag288: diag288: specification: unsupported action: Program interrupt: expected(6) == received(6)
ok 4 - diag288: diag288: specification: unsupported function: Program interrupt: expected(6) == received(6)
ok 5 - diag288: diag288: specification: no init: Program interrupt: expected(6) == received(6)
ok 6 - diag288: diag288: specification: min timer: Program interrupt: expected(6) == received(6)
1..6

Which looks like a completely fine TAP file, but actually we ran into a timeout
and didn't even run all tests.

With this patch, we get an additional line at the end which properly shows
something went wrong:

not ok 7 - diag288: timeout; duration=1s

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6d5fced94246..86405604522d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -163,8 +163,17 @@ function run()
         print_result "SKIP" $testname "$summary"
     elif [ $ret -eq 124 ]; then
         print_result "FAIL" $testname "" "timeout; duration=$timeout"
+        if [ "$tap_output" = "yes" ]; then
+            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=$timeout" >&3
+        fi
     elif [ $ret -gt 127 ]; then
-        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $(($ret - 128)))"
+        signame="SIG"$(kill -l $(($ret - 128)))
+        print_result "FAIL" $testname "" "terminated on $signame"
+        if [ "$tap_output" = "yes" ]; then
+            echo "not ok TEST_NUMBER - ${testname}: terminated on $signame" >&3
+        fi
+    elif [ $ret -eq 127 ] && [ "$tap_output" = "yes" ]; then
+        echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
     else
         print_result "FAIL" $testname "$summary"
     fi
-- 
2.31.1

