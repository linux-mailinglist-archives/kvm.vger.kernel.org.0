Return-Path: <kvm+bounces-59184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3230DBAE0F7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E22FF4E2728
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6451823C506;
	Tue, 30 Sep 2025 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqByC0md"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A723D7F3
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250214; cv=none; b=Dqv1XfC9UsvkzDyB2qM1nD1zg8/sJu6z2ZeFkW8xAu+MVxBQ7iTiX25LT51rzHNtp76JVOcZlsJ97vn8+gHX1SQYLSVIHp8j7U+f8WDEYt9Scl8EK8KolryTeU4qK5Rc1NhgduBhoRop0w+lXre1bKvce4TkIShlkQP0VWG4OlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250214; c=relaxed/simple;
	bh=nycwqP6AhjxaXuzHDgYWDB/IbLSgAIDiRc2tUarsNhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=daoQRTSZKFH/Kotq28EKfCjNw7VdV2srzfUErsey773FTlJLcq3RtuCm7fSVnOLQfvwsS6LjFDD59o1KESyxZhmUlERQ7GFSnZF1oEGn9803y5xZ8J1uLREN4kUf6oL0B46dOzQ8zoPE5ItGewACpmthaYLp6Op8qqBazGidnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kqByC0md; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-272ed8c106eso39882855ad.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250211; x=1759855011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rc4ucMrZZLQgysJDwujeADN63tAlAVtHcaQvgLoGAb0=;
        b=kqByC0md5ZAUTJXx4gjyzYtui8qNyvU5uHDazTlRQC4lCUAMeUCFXP/wzPmz6g37YD
         TFGQYeYUGUdPOESijhkRb4ZUlPXc/7ah3HqjnG/qOWCNGIb4MEB8GdonUl0dZ2zUnaSE
         +c+5i84seEyczSHtabmEvvnzF8GWbedMKao3fOnlnZSPv2E5xXDeFODFwIPQEjVpumQC
         lZOXRE8RXSBDm/HUisnEDii96YQloKinCg95NvGc/qyPms3SjxYGbSrPBGIlLLv6TB3O
         NsBVbQnJ4n9qph9NEU/UBZG9Wb5vF2BQiptPQr0wyaMlxpIiF2jGzyY1h244q2CfEuBJ
         qpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250211; x=1759855011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rc4ucMrZZLQgysJDwujeADN63tAlAVtHcaQvgLoGAb0=;
        b=L7/xX0PgQoyEtvxqrweFckK1nBqvwbV1XNPLXsAeX0hdJF52yHjMvhHRGwNbdDiPyI
         9pyhkUb46Nvw47AZ4xTiq40R1gaWoiL+PazarbN9w4mBkFl2dqSA2ei2IepMUpg0KriM
         9G72I4Lxq6Ks1/opIglCrtYQ5CyIQd4Y8dP5KIZnbi3YbxbbSniHVeKpxQLIeNFKUVmL
         yyCrgS7CI9Muf8Umsye5RDtAiWpQiDdxJWzSqju/Ect22gu9rHHGbALB78lda7Wk6q47
         7EsxPYMsS5Q2n86zBHohBhM6PtilYfIiWsWDNNBqh3TvojvHBunCVCrZUcV3VWfkgLsX
         cs/A==
X-Gm-Message-State: AOJu0YyAlCfeNW9zj8q17MfJRQwEqkZoMbEy1LYrlofN2Se23jbjV2p1
	XQ0IK/GkUugMLC+jeVy2LP9kMJE86GMWaMnYDNpb/2watnmW1icszOYNYr3MXUozP74pDOe7EO/
	j5oSPaeGsb+Vr4rVPNhqEDNNSDDROjzGEA9gdk1B5KSBAqq59Rz3V+2OiiXLTQ6dinBL6NQ5gYj
	fXSyxXrVhKewQmja9X7K5GAGUTCljDs+0fgLMHjg==
X-Google-Smtp-Source: AGHT+IHLVHVPK97xGLpcLMiansWk7hFaSR+T9o/MXlCUi7oz8YlG+P3ooNANbdPhcTUhvNECCSwntR5R1+dy
X-Received: from pjbgm21.prod.google.com ([2002:a17:90b:1015:b0:330:88c4:627])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc8:b0:267:da75:e0f
 with SMTP id d9443c01a7336-28e7f276e18mr4968975ad.11.1759250210348; Tue, 30
 Sep 2025 09:36:50 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:27 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-2-vipinsh@google.com>
Subject: [PATCH v3 1/9] KVM: selftest: Create KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement a basic KVM selftest runner in Python to run selftests. Add
command line options to select individual testcase file or a
directory containing multiple testcase files.

After selecting the tests to run, start their execution and print their
final execution status (passed, failed, skipped, no run), stdout and
stderr on terminal.

Print execution status in colors on the terminals where it is supported
to easily distinguish different statuses of the tests execution.

If a test fails or times out, then return with a non-zero exit code
after all of the tests execution have completed. If none of the tests
fails or times out then exit with status 0

Provide some sample test configuration files to demonstrate the
execution of the runner.

Runner can be started from tools/testing/selftests/kvm directory as:

  python3 runner --dirs tests
OR
  python3 runner --testcases \
  tests/dirty_log_perf_test/no_dirty_log_protect.test

This is a very basic implementation of the runner. Next patches will
enhance the runner by adding more features like parallelization, dumping
output to file system, time limit, out-of-tree builds run, etc.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  4 +-
 .../testing/selftests/kvm/runner/__main__.py  | 94 +++++++++++++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 64 +++++++++++++
 .../selftests/kvm/runner/test_runner.py       | 37 ++++++++
 .../2slot_5vcpu_10iter.test                   |  1 +
 .../no_dirty_log_protect.test                 |  1 +
 6 files changed, 200 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1d41a046a7bf..95af97b1ff9e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,10 +3,12 @@
 !/**/
 !*.c
 !*.h
+!*.py
 !*.S
 !*.sh
+!*.test
 !.gitignore
 !config
 !settings
 !Makefile
-!Makefile.kvm
\ No newline at end of file
+!Makefile.kvm
diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
new file mode 100644
index 000000000000..8d1a78450e41
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import argparse
+import logging
+import os
+import sys
+
+from test_runner import TestRunner
+from selftest import SelftestStatus
+
+
+def cli():
+    parser = argparse.ArgumentParser(
+        prog="KVM Selftests Runner",
+        formatter_class=argparse.RawTextHelpFormatter,
+        allow_abbrev=False
+    )
+
+    parser.add_argument("-t",
+                        "--testcases",
+                        nargs="*",
+                        default=[],
+                        help="Testcases to run. Provide the space separated testcases paths")
+
+    parser.add_argument("-d",
+                        "--dirs",
+                        nargs="*",
+                        default=[],
+                        help="Run the testcases present in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
+
+    return parser.parse_args()
+
+
+def setup_logging():
+    class TerminalColorFormatter(logging.Formatter):
+        reset = "\033[0m"
+        red_bold = "\033[31;1m"
+        green = "\033[32m"
+        yellow = "\033[33m"
+        blue = "\033[34m"
+
+        COLORS = {
+            SelftestStatus.PASSED: green,
+            SelftestStatus.NO_RUN: blue,
+            SelftestStatus.SKIPPED: yellow,
+            SelftestStatus.FAILED: red_bold
+        }
+
+        def __init__(self, fmt=None, datefmt=None):
+            super().__init__(fmt, datefmt)
+
+        def format(self, record):
+            return (self.COLORS.get(record.levelno, "") +
+                    super().format(record) + self.reset)
+
+    logger = logging.getLogger("runner")
+    logger.setLevel(logging.INFO)
+
+    ch = logging.StreamHandler()
+    ch_formatter = TerminalColorFormatter(fmt="%(asctime)s | %(message)s",
+                                          datefmt="%H:%M:%S")
+    ch.setFormatter(ch_formatter)
+    logger.addHandler(ch)
+
+
+def fetch_testcases_in_dirs(dirs):
+    testcases = []
+    for dir in dirs:
+        for root, child_dirs, files in os.walk(dir):
+            for file in files:
+                testcases.append(os.path.join(root, file))
+    return testcases
+
+
+def fetch_testcases(args):
+    testcases = args.testcases
+    testcases.extend(fetch_testcases_in_dirs(args.dirs))
+    # Remove duplicates
+    testcases = list(dict.fromkeys(testcases))
+    return testcases
+
+
+def main():
+    args = cli()
+    setup_logging()
+    testcases = fetch_testcases(args)
+    return TestRunner(testcases).start()
+
+
+if __name__ == "__main__":
+    sys.exit(main())
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
new file mode 100644
index 000000000000..34005f83f0c3
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import pathlib
+import enum
+import os
+import subprocess
+
+class SelftestStatus(enum.IntEnum):
+    """
+    Selftest Status. Integer values are just +1 to the logging.INFO level.
+    """
+
+    PASSED = 21
+    NO_RUN = 22
+    SKIPPED = 23
+    FAILED = 24
+
+    def __str__(self):
+        return str.__str__(self.name)
+
+class Selftest:
+    """
+    Represents a single selftest.
+
+    Extract the test execution command from test file and executes it.
+    """
+
+    def __init__(self, test_path):
+        test_command = pathlib.Path(test_path).read_text().strip()
+        if not test_command:
+            raise ValueError("Empty test command in " + test_path)
+
+        test_command = os.path.join(".", test_command)
+        self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
+        self.test_path = test_path
+        self.command = test_command
+        self.status = SelftestStatus.NO_RUN
+        self.stdout = ""
+        self.stderr = ""
+
+    def run(self):
+        if not self.exists:
+            self.stderr = "File doesn't exists."
+            return
+
+        run_args = {
+            "universal_newlines": True,
+            "shell": True,
+            "stdout": subprocess.PIPE,
+            "stderr": subprocess.PIPE
+        }
+        proc = subprocess.run(self.command, **run_args)
+        self.stdout = proc.stdout
+        self.stderr = proc.stderr
+
+        if proc.returncode == 0:
+            self.status = SelftestStatus.PASSED
+        elif proc.returncode == 4:
+            self.status = SelftestStatus.SKIPPED
+        else:
+            self.status = SelftestStatus.FAILED
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
new file mode 100644
index 000000000000..4418777d75e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import logging
+from selftest import Selftest
+from selftest import SelftestStatus
+
+logger = logging.getLogger("runner")
+
+
+class TestRunner:
+    def __init__(self, testcases):
+        self.tests = []
+
+        for testcase in testcases:
+            self.tests.append(Selftest(testcase))
+
+    def _log_result(self, test_result):
+        logger.info("*** stdout ***\n" + test_result.stdout)
+        logger.info("*** stderr ***\n" + test_result.stderr)
+        logger.log(test_result.status,
+                   f"[{test_result.status.name}] {test_result.test_path}")
+
+    def start(self):
+        ret = 0
+
+        for test in self.tests:
+            test.run()
+            self._log_result(test)
+
+            if (test.status not in [SelftestStatus.PASSED,
+                                    SelftestStatus.NO_RUN,
+                                    SelftestStatus.SKIPPED]):
+                ret = 1
+        return ret
diff --git a/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
new file mode 100644
index 000000000000..5b8d56b44a75
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
@@ -0,0 +1 @@
+dirty_log_perf_test -x 2 -v 5 -i 10
diff --git a/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test
new file mode 100644
index 000000000000..ed3490b1d1a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test
@@ -0,0 +1 @@
+dirty_log_perf_test -g
-- 
2.51.0.618.g983fd99d29-goog


