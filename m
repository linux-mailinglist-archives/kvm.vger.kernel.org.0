Return-Path: <kvm+bounces-59186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7AABAE0F9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20BF24C09A3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58BC255F2C;
	Tue, 30 Sep 2025 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t96WfmKU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABED246796
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250217; cv=none; b=YsOYOHK6o1E9O3VZ54oc21+eDWxjewyt29QLp4/MeGeqmlDDFbnLdxshREEnqw2dDK48qF9+s53mD9MhKGtWs/qsjA4xqDDUy/iuahA6DOeo7T+jHhbTE9z7Bzs0Y1qetaho8ezODWJf/yw+eKBE+CGPQ0hxneDvQIwX53wdpLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250217; c=relaxed/simple;
	bh=e/8GekqR7lq1KIRfT3CYCh/IeXU0XhWbKZ6t240aQcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g7gtZoQMwaptel9vu2lmZHGTKxRG2B9DVJzV85tIvdz6uEAMX6/ZQBwOOMrL3TKtwy1lPmljRwIZtiF1jnmzHlJL8nRoRO5qRNnRhgKOq3M0pVycO9HLmgm0x/mc5DlTvMMPA2ch3oKqR1pXB/uWcnP7YTbQG9D/lt03Fm+GsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t96WfmKU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so8692790a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250215; x=1759855015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/QRF3FFgseL8D0g15ww2uGbub0UU/EJdFmqDVXw9oU=;
        b=t96WfmKUtpg3A1sWHP9qoIv2V+6x9FUiKIYBLw419FJ2+6ZbviWbKreIj1CHcqBdv3
         eTRgaTPaVhhqDzrCvhcVWVerjx+WYtn+tIF9ReVB61fPZOJ9KICPXHkJ8fVbTE/ujCOt
         aeMfmPOyvqmSdQw/y8ec9bjFBHDZ56RW5rJ8DcV8YOSmSxvS4tGLWhaUY/q4e/8we+UJ
         dDO4dnNxLutxI1HgHnXmKNZ//HIRIqgWFutNQujyBRVupmsdL7IGk+ADiLrbWAVu8Fkj
         YkVm//7xoy1SY4tv34+k9cMax4vu8UMTUCwq8moA2CW3p9yaeMyuMkA9ym8O+sWZfjLj
         eNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250215; x=1759855015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/QRF3FFgseL8D0g15ww2uGbub0UU/EJdFmqDVXw9oU=;
        b=Vsmx1/R6w6TG80ZuN6zo2kiE6GkjnVg6qHJh5/fayQhFGgK7BdZD5Bo/GgPBDhG/I0
         8n7IYXtzywsAt5UBEweTgt/IQDhK/VSU50I/d7D7qk2sPnAUJ2w+qz9BoF1DO/hsOmZR
         Oaw3iJevYC8FMvlb6no9OXCClZ9r5GpuLG0PMJQq6qyEj7nBb1JBvUEl3B3GIdXAPzhV
         3mndJ8pVTHVrRF6RfK4ZiqnU4zSzU839YaLBYDuIb3JobjpabUr0lTN805X9k+L+FI4s
         MUQovk47Avn9cJhkVBiIcmaGHthFCG+T/G+13YtGao+Y+gugVyVzkmXG20dKssyxnosR
         0V+g==
X-Gm-Message-State: AOJu0YzzufvqBOFqHIDzLicYHpeAgR50oIJFELQ8uUldjZQiz4proP68
	dmcYpf5Z5/43k4tjDcoLcdqfSj/HSYzdlovdneBB8qy4RA7wqvygWoAsWBMqNkwmJNRJ8jUYAIA
	r7nb2jEZxB2SKDkfHqskgiK5gIaSI4VwVWtS8esVBwYgcg7FGkb6fKS/c+in9oZIpP3zx18QN+/
	moMrI/ZjaJcb2LswDSSun8zKrqEUN/8uKkPUKtKQ==
X-Google-Smtp-Source: AGHT+IEdeV+S3AOsumfo+VA7YBUiHc/nL5ezOQx5Foo8J1Cq3HgpIz3y8FReXq936G/8G4+cCaSjSkfD+N8w
X-Received: from pjbpg12.prod.google.com ([2002:a17:90b:1e0c:b0:32b:50cb:b92f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c83:b0:338:3221:9dc0
 with SMTP id 98e67ed59e1d1-339a6f69812mr102527a91.37.1759250215269; Tue, 30
 Sep 2025 09:36:55 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:30 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-5-vipinsh@google.com>
Subject: [PATCH v3 4/9] KVM: selftests: Add option to save selftest runner
 output to a directory
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, -o/--output, to selftest runner which enables
it to save individual tests output (stdout & stderr) stream to a
directory in a hierarchical way. Create folder hierarchy same as tests
hieararcy given by --testcases and --dirs.

Also, add a command line flag, --append-output-time, which will append
timestamp (format YYYY.M.DD.HH.MM.SS) to the directory name given in
--output flag.

Example:
  python3 runner --dirs test -o test_result --append_output_time

This will create test_result.2025.06.06.08.45.57 directory.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 34 +++++++++++++--
 .../testing/selftests/kvm/runner/selftest.py  | 42 ++++++++++++++++---
 .../selftests/kvm/runner/test_runner.py       |  4 +-
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 5cedc5098a54..b27a41e86271 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -7,6 +7,8 @@ import argparse
 import logging
 import os
 import sys
+import datetime
+import pathlib
 
 from test_runner import TestRunner
 from selftest import SelftestStatus
@@ -42,10 +44,20 @@ def cli():
                         type=int,
                         help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
 
+    parser.add_argument("-o",
+                        "--output",
+                        nargs='?',
+                        help="Dumps test runner output which includes each test execution result, their stdouts and stderrs hierarchically in the given directory.")
+
+    parser.add_argument("--append-output-time",
+                        action="store_true",
+                        default=False,
+                        help="Appends timestamp to the output directory.")
+
     return parser.parse_args()
 
 
-def setup_logging():
+def setup_logging(args):
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
         red_bold = "\033[31;1m"
@@ -72,12 +84,26 @@ def setup_logging():
     logger = logging.getLogger("runner")
     logger.setLevel(logging.INFO)
 
+    formatter_args = {
+        "fmt": "%(asctime)s | %(message)s",
+        "datefmt": "%H:%M:%S"
+    }
+
     ch = logging.StreamHandler()
-    ch_formatter = TerminalColorFormatter(fmt="%(asctime)s | %(message)s",
-                                          datefmt="%H:%M:%S")
+    ch_formatter = TerminalColorFormatter(**formatter_args)
     ch.setFormatter(ch_formatter)
     logger.addHandler(ch)
 
+    if args.output != None:
+        if (args.append_output_time):
+            args.output += datetime.datetime.now().strftime(".%Y.%m.%d.%H.%M.%S")
+        pathlib.Path(args.output).mkdir(parents=True, exist_ok=True)
+        logging_file = os.path.join(args.output, "log")
+        fh = logging.FileHandler(logging_file)
+        fh_formatter = logging.Formatter(**formatter_args)
+        fh.setFormatter(fh_formatter)
+        logger.addHandler(fh)
+
 
 def fetch_testcases_in_dirs(dirs):
     testcases = []
@@ -98,7 +124,7 @@ def fetch_testcases(args):
 
 def main():
     args = cli()
-    setup_logging()
+    setup_logging(args)
     testcases = fetch_testcases(args)
     return TestRunner(testcases, args).start()
 
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 4783785ca230..1aedeaeb5e74 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -7,6 +7,7 @@ import pathlib
 import enum
 import os
 import subprocess
+import contextlib
 
 class SelftestStatus(enum.IntEnum):
     """
@@ -29,7 +30,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, path, timeout):
+    def __init__(self, test_path, path, timeout, output_dir):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -39,15 +40,14 @@ class Selftest:
         self.test_path = test_path
         self.command = test_command
         self.timeout = timeout
+        if output_dir is not None:
+            output_dir = os.path.join(output_dir, test_path.lstrip("./"))
+        self.output_dir = output_dir
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
 
-    def run(self):
-        if not self.exists:
-            self.stderr = "File doesn't exists."
-            return
-
+    def _run(self, output=None, error=None):
         run_args = {
             "universal_newlines": True,
             "shell": True,
@@ -59,7 +59,12 @@ class Selftest:
         try:
             proc = subprocess.run(self.command, **run_args)
             self.stdout = proc.stdout
+            if output is not None:
+                output.write(proc.stdout)
+
             self.stderr = proc.stderr
+            if error is not None:
+                error.write(proc.stderr)
 
             if proc.returncode == 0:
                 self.status = SelftestStatus.PASSED
@@ -71,5 +76,30 @@ class Selftest:
             self.status = SelftestStatus.TIMED_OUT
             if e.stdout is not None:
                 self.stdout = e.stdout
+                if output is not None:
+                    output.write(e.stdout)
             if e.stderr is not None:
                 self.stderr = e.stderr
+                if error is not None:
+                    error.write(e.stderr)
+
+    def run(self):
+        if not self.exists:
+            self.stderr = "File doesn't exists."
+            return
+
+        if self.output_dir is not None:
+            pathlib.Path(self.output_dir).mkdir(parents=True, exist_ok=True)
+
+        output = None
+        error = None
+        with contextlib.ExitStack() as stack:
+            if self.output_dir is not None:
+                output_path = os.path.join(self.output_dir, "stdout")
+                output = stack.enter_context(
+                    open(output_path, encoding="utf-8", mode="w"))
+
+                error_path = os.path.join(self.output_dir, "stderr")
+                error = stack.enter_context(
+                    open(error_path, encoding="utf-8", mode="w"))
+            return self._run(output, error)
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index bea82c6239cd..b9101f0e0432 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -13,9 +13,11 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
+        self.output_dir = args.output
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase, args.path, args.timeout))
+            self.tests.append(Selftest(testcase, args.path, args.timeout,
+                                       args.output))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.51.0.618.g983fd99d29-goog


