Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0F70036D
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbjELJKl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 12 May 2023 05:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbjELJKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:10:40 -0400
Received: from senda.mailex.chinaunicom.cn (senda.mailex.chinaunicom.cn [123.138.59.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C125B11635
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 02:10:34 -0700 (PDT)
Received: from M10-XA-MLCEN01.MailSrv.cnc.intra (unknown [10.236.3.197])
        by senda.mailex.chinaunicom.cn (SkyGuard) with ESMTPS id 4QHjjF531Qz3Dthn
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:13:05 +0800 (CST)
Received: from smtpbg.qq.com (10.237.2.96) by M10-XA-MLCEN01.MailSrv.cnc.intra
 (10.236.3.197) with Microsoft SMTP Server id 15.0.1497.47; Fri, 12 May 2023
 17:10:29 +0800
X-QQ-mid: Ymail-xx24b003-t1683882626tqw
Received: from localhost.localdomain (unknown [10.3.224.193])
        by smtp.qq.com (ESMTP) with 
        id ; Fri, 12 May 2023 17:10:26 +0800 (CST)
X-QQ-SSF: 0190000000000060I730050A0000000
X-QQ-GoodBg: 0
From:   =?gb18030?B?yM7D9MP0KMGqzai8r83FwarNqMr919a/xry809A=?=
         =?gb18030?B?z965q8u+sb6yvyk=?= <renmm6@chinaunicom.cn>
To:     =?gb18030?B?a3Zt?= <kvm@vger.kernel.org>
CC:     =?gb18030?B?cGJvbnppbmk=?= <pbonzini@redhat.com>,
        =?gb18030?B?YW5kcmV3LmpvbmVz?= <andrew.jones@linux.dev>,
        =?gb18030?B?cm1tMTk4NQ==?= <rmm1985@163.com>
Subject: [kvm-unit-tests PATCH v3] run_tests: add list tests name option on command line
Date:   Fri, 12 May 2023 17:09:28 +0800
Message-ID: <20230512090928.3437244-1-renmm6@chinaunicom.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: Ymail-xx:chinaunicom.cn:mail-xx:mail-xx24b003-zhyw44w
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: rminmin <renmm6@chinaunicom.cn>

Add '-l | --list' option on command line to output
all tests name only, and could be filtered by group
with '-g | --group' option.

E.g.
  List all vmx group tests name:
  $ ./run_tests.sh -g vmx -l

  List all tests name:
  $ ./run_tests.sh -l

Signed-off-by: rminmin <renmm6@chinaunicom.cn>
---
 run_tests.sh | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index f61e005..baf8e46 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -15,7 +15,7 @@ function usage()
 {
 cat <<EOF

-Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
+Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]

     -h, --help      Output this help text
     -v, --verbose   Enables verbose mode
@@ -24,6 +24,7 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
     -g, --group     Only execute tests in the given group
     -j, --parallel  Execute tests in parallel
     -t, --tap13     Output test results in TAP format
+    -l, --list      Only output all tests list

 Set the environment variable QEMU=/path/to/qemu-system-ARCH to
 specify the appropriate qemu binary for ARCH-run.
@@ -42,7 +43,8 @@ if [ $? -ne 4 ]; then
 fi

 only_tests=""
-args=$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*)
+list_tests=""
+args=$(getopt -u -o ag:htj:v:l -l all,group:,help,tap13,parallel:,verbose:,list -- $*)
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
@@ -73,6 +75,9 @@ while [ $# -gt 0 ]; do
         -t | --tap13)
             tap_output="yes"
             ;;
+        -l | --list)
+            list_tests="yes"
+            ;;
         --)
             ;;
         *)
@@ -154,6 +159,20 @@ function run_task()
 : ${unittest_run_queues:=1}
 config=$TEST_DIR/unittests.cfg

+print_testname()
+{
+    local testname=$1
+    local groups=$2
+    if [ -n "$only_group" ] && ! find_word "$only_group" "$groups"; then
+        return
+    fi
+    echo "$testname"
+}
+if [[ $list_tests == "yes" ]]; then
+    for_each_unittest $config print_testname
+    exit
+fi
+
 rm -rf $unittest_log_dir.old
 [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
 mkdir $unittest_log_dir || exit 2
--
2.33.0

如果您错误接收了该邮件，请通过电子邮件立即通知我们。请回复邮件到 hqs-spmc@chinaunicom.cn，即可以退订此邮件。我们将立即将您的信息从我们的发送目录中删除。 If you have received this email in error please notify us immediately by e-mail. Please reply to hqs-spmc@chinaunicom.cn ,you can unsubscribe from this mail. We will immediately remove your information from send catalogue of our.
