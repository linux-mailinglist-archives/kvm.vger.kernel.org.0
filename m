Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C843B6D6CA3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjDDSvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbjDDSvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:51:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C563A8C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:50:59 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334IN0H3013119;
        Tue, 4 Apr 2023 18:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9458fRqGvawhXKhRtBEmwff0uc3JYyVWDuBZndf/Z/I=;
 b=tB8RLrRGLbgVVIWh1nZkoRGLynd380c7/guiDcJNWeSeDCTLsuiclA1s+vofj2Nv0Z74
 UQcWBTzZDmUpKd5wXLPegt3bnWYahDAl5EX63LbWzV9yzdkCqLfYYNcLyh903D/PfHPz
 uWlk5F1IQMhcsJcefYE+b5IbUzMrzRgLR6jSvDNlpBA9p9NXUWL2k61jX+UOqKTKppTr
 NsE9nVQuyyZld9MYI3FMnvsGMdEXpXj4+sK61OOpQq0TB6atdMGQ7exeNmO+dbtEDhRb
 aChf/EXnMgUFcp9dAN3wIZrH0SvepFxivbTGJi5nhma9LrxSLUgoOHdWyyNbdlDx1U7H pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prs47gm7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334IjVDX018592;
        Tue, 4 Apr 2023 18:50:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prs47gm73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342vgs5016631;
        Tue, 4 Apr 2023 18:50:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86t2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334IopxB41287990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 18:50:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3AD320043;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 730482004B;
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
Subject: [kvm-unit-tests PATCH v2 2/3] pretty_print_stacks: support unknown line numbers
Date:   Tue,  4 Apr 2023 20:50:46 +0200
Message-Id: <20230404185048.2824384-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230404185048.2824384-1-nsg@linux.ibm.com>
References: <20230404185048.2824384-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nW7awKY8BnfLvGX1QMg8lWvCi4fMuoua
X-Proofpoint-ORIG-GUID: GGLz548QLaRI0b0ocXfCKU-bQEbxHoR_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_10,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304040168
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle the case where addr2line cannot determine a line number.
Skip printing lines for this frame in this case.

Fixes: a9143a24 ("scripts: pretty print stack traces")
Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 scripts/pretty_print_stacks.py | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index ba6f0825..1a27f309 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -37,23 +37,24 @@ def pretty_print_stack(binary, line):
         return
 
     for line in out.splitlines():
-        m = re.match(b'(.*) at [^ ]*/kvm-unit-tests/([^ ]*):([0-9]+)(.*)', line)
+        m = re.match(b'(.*) at [^ ]*/kvm-unit-tests/([^ ]*):(([0-9]+)|\?)(.*)', line)
         if m is None:
             puts('%s\n' % line)
             return
 
-        head, path, line, tail = m.groups()
-        line = int(line)
-        puts('%s at %s:%d%s\n' % (head.decode(), path.decode(), line, tail.decode()))
-        try:
-            lines = open(path).readlines()
-        except IOError:
-            continue
-        if line > 1:
-            puts('        %s\n' % lines[line - 2].rstrip())
-        puts('      > %s\n' % lines[line - 1].rstrip())
-        if line < len(lines):
-            puts('        %s\n' % lines[line].rstrip())
+        head, path, maybeline, line, tail = m.groups()
+        puts('%s at %s:%s%s\n' % (head.decode(), path.decode(), maybeline.decode(), tail.decode()))
+        if line:
+            line = int(line)
+            try:
+                lines = open(path).readlines()
+            except IOError:
+                continue
+            if line > 1:
+                puts('        %s\n' % lines[line - 2].rstrip())
+            puts('      > %s\n' % lines[line - 1].rstrip())
+            if line < len(lines):
+                puts('        %s\n' % lines[line].rstrip())
 
 def main():
     if len(sys.argv) != 2:
-- 
2.37.2

