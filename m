Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C746D6CA4
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbjDDSvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjDDSvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:51:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1035B3
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:50:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334IAklx007656;
        Tue, 4 Apr 2023 18:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nEx5DmcsyUgBG7N8YNe6yCohqKEL/Kvk6Utxw60yy6w=;
 b=oBZpVpM3b885BHcaRD5pzVgCcTi95da3phMqNnIg9+YN6yYxnw8V21931k4nw1P8X2hT
 ft0lz7ii5ASJcMGNfi1XWtwo/lHcf63Nb72F3priyeEb3ZNR4TlgH67WAa1f/VgcqMjr
 8jCKGG1s+G5mIYEamzm+RrSG2r+GFLzug8gq5ksRFfYG7mzQybpnZ/bkLoxh6MRtknwe
 2X8k0Y3v98SZS3WZNVyqpNbCUbjlQrZ3N8TV8fRrCEXgTCEPA2jprs/4zFNDRGsTNR36
 dug0YqCulSOjAKngEZeFsJQghqfvGHXUg/XlUPn4BJw5RA3MWnKjh9pijJ7MgkSYxL7s Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prrxq0y0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334IRNFB015794;
        Tue, 4 Apr 2023 18:50:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prrxq0y04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341PMMe004923;
        Tue, 4 Apr 2023 18:50:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87aqsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334IoqCt14352938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 18:50:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F24C020040;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C215920049;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/3] pretty_print_stacks: modify relative path calculation
Date:   Tue,  4 Apr 2023 20:50:47 +0200
Message-Id: <20230404185048.2824384-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230404185048.2824384-1-nsg@linux.ibm.com>
References: <20230404185048.2824384-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wKIGRCf34EPBJRdubiOcnENtl6WxVfTN
X-Proofpoint-GUID: 0iSqN_hsQ2NB-52POjkqapZkf1R2R7DM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_10,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040168
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't assume we can get a relative path by cutting of certain prefixes,
since this isn't guaranteed to work.
Instead use a library function.
Also normalize paths in order to take care of symlinks.

Fixes: a9143a24 ("scripts: pretty print stack traces")
Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 scripts/pretty_print_stacks.py | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index 1a27f309..90026b72 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -4,6 +4,7 @@ import re
 import subprocess
 import sys
 import traceback
+import os
 
 config = {}
 
@@ -25,8 +26,8 @@ def pretty_print_stack(binary, line):
             addrs[i] = '%lx' % max((int(addrs[i], 16) - 1), 0)
 
     # Output like this:
-    #        0x004002be: start64 at path/to/kvm-unit-tests/x86/cstart64.S:208
-    #         (inlined by) test_ept_violation at path/to/kvm-unit-tests/x86/vmx_tests.c:1719 (discriminator 1)
+    #        0x004002be: start64 at path/to/kvm-unit-tests-repo-worktree/x86/cstart64.S:208
+    #         (inlined by) test_ept_violation at path/to/kvm-unit-tests-repo-worktree/x86/vmx_tests.c:1719 (discriminator 1)
     cmd = [config.get('ADDR2LINE', 'addr2line'), '-e', binary, '-i', '-f', '--pretty', '--address']
     cmd.extend(addrs)
 
@@ -37,12 +38,13 @@ def pretty_print_stack(binary, line):
         return
 
     for line in out.splitlines():
-        m = re.match(b'(.*) at [^ ]*/kvm-unit-tests/([^ ]*):(([0-9]+)|\?)(.*)', line)
+        m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
         if m is None:
             puts('%s\n' % line)
             return
 
         head, path, maybeline, line, tail = m.groups()
+        path = os.path.relpath(os.path.realpath(path), start=os.path.realpath(os.getcwdb()))
         puts('%s at %s:%s%s\n' % (head.decode(), path.decode(), maybeline.decode(), tail.decode()))
         if line:
             line = int(line)
-- 
2.37.2

