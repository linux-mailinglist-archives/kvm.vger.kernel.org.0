Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F56127B39A
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1RuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1RuL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:11 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bPuzcrXA+QedfFcsSU+I+K2bCWBlmWFD4+SCNXa3vrc=;
        b=K7B1rTkmbOORZ3XjF32POSz6av3Ti5XKrQMrJR4OsIrd9KfKkJ1V6pd6XAUaxbwtIsgZbh
        v+a1MFPCslI6Xrt1viLsTk4XnMN855p2G24RiDqY6WqhMb2weHAsD3Gy9Y7JVyD5dt3QC+
        ksvO3FLnZNa8Wzcmsnw3FMDyqMAmHNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-Fsv7P-UkP0ShJtDEzwRn2Q-1; Mon, 28 Sep 2020 13:50:07 -0400
X-MC-Unique: Fsv7P-UkP0ShJtDEzwRn2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B257D801AE3;
        Mon, 28 Sep 2020 17:50:06 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46742100238C;
        Mon, 28 Sep 2020 17:50:04 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 02/11] Use same test names in the default and the TAP13 output format
Date:   Mon, 28 Sep 2020 19:49:49 +0200
Message-Id: <20200928174958.26690-3-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Use the same test names in the TAP13 output as in the default output
format. This makes the output more consistent. To achieve this, we
need to pass the test name as an argument to the function
`process_test_output`.

Before this change:
$ ./run_tests.sh
PASS selftest-setup (14 tests)
...

vs.

$ ./run_tests.sh -t
TAP version 13
ok 1 - selftest: true
ok 2 - selftest: argc == 3
...

After this change:
$ ./run_tests.sh
PASS selftest-setup (14 tests)
...

vs.

$ ./run_tests.sh -t
TAP version 13
ok 1 - selftest-setup: selftest: true
ok 2 - selftest-setup: selftest: argc == 3
...

While at it, introduce a local variable `kernel` in
`RUNTIME_log_stdout` since this makes the function easier to read.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200825102036.17232-3-mhartmay@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 run_tests.sh         | 15 +++++++++------
 scripts/runtime.bash |  6 +++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index fc4b3c2..d7cad9b 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -88,18 +88,19 @@ if [[ $tap_output == "no" ]]; then
     postprocess_suite_output() { cat; }
 else
     process_test_output() {
+        local testname="$1"
         CR=$'\r'
         while read -r line; do
             line="${line%$CR}"
             case "${line:0:4}" in
                 PASS)
-                    echo "ok TEST_NUMBER - ${line#??????}" >&3
+                    echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
                     ;;
                 FAIL)
-                    echo "not ok TEST_NUMBER - ${line#??????}" >&3
+                    echo "not ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
                     ;;
                 SKIP)
-                    echo "ok TEST_NUMBER - ${line#??????} # skip" >&3
+                    echo "ok TEST_NUMBER - ${testname}: ${line#??????} # skip" >&3
                     ;;
                 *)
                     ;;
@@ -121,12 +122,14 @@ else
     }
 fi
 
-RUNTIME_log_stderr () { process_test_output; }
+RUNTIME_log_stderr () { process_test_output "$1"; }
 RUNTIME_log_stdout () {
+    local testname="$1"
     if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
-        ./scripts/pretty_print_stacks.py $1 | process_test_output
+        local kernel="$2"
+        ./scripts/pretty_print_stacks.py "$kernel" | process_test_output "$testname"
     else
-        process_test_output
+        process_test_output "$testname"
     fi
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index caa4c5b..294e6b1 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -140,10 +140,10 @@ function run()
     # extra_params in the config file may contain backticks that need to be
     # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
     # preserve the exit status.
-    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr) \
-                             > >(tee >(RUNTIME_log_stdout $kernel) | extract_summary))
+    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
+                             > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
     ret=$?
-    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $kernel)
+    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
 
     if [ $ret -eq 0 ]; then
         print_result "PASS" $testname "$summary"
-- 
2.18.2

