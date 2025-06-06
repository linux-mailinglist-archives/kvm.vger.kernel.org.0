Return-Path: <kvm+bounces-48683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 168A8AD0A7C
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 622F23B4106
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABBD241CB7;
	Fri,  6 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I0WUHc6L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E85241680
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254200; cv=none; b=ard7LHm5jMaV3LR9vt63EgNCWRAwCygjoG9RqIh3lBo1aSvTEHX6K/Z2O71wjPjMFr8NQ9krVBwoi2vgLzF2AXzdQxGqI/OkLQ4z5xOduFEM0O4M2ylY7cO2gYZR9slIM+8V1ZgBT+9LGGiN6YVx96yqhviicvb/86CF6WOhLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254200; c=relaxed/simple;
	bh=Ihob1sHphXHSWGKCbUN9DBpSn9m5Jbo7b0e4RSyKcQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uX4/y4o/JM16Litt6fid5M9EQhre1OcZH+LhA9WbDRBe5cEzopGZHzkT1+/INpqKxeNpsIUHNWsBXEMkHBSlgITd52nTPmSUtG/ecVZE8fyILxkSC91E2oKWtBc7nOBXKr85bl2h/YXSdkLJNIYeYJeKl/GDRCgR8wQmX72cfoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I0WUHc6L; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235c897d378so24803765ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254198; x=1749858998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A+5Bd7zkjIDO1H+lfyodM1++vUZ5mljRsfn//VOCKL0=;
        b=I0WUHc6L6bGnKKmFq4yKIYGeFLLONEpCJ6DQ7RJGs3jtN1O4olmawDSx7oKmhxza7u
         nBmf+Jhjdl+WszXSjeELGXo/79CcaHZTmJF45/YPOG8YD1mrlEgczyTsmH9Ly2dWon6W
         DjEHxB575BOtZ75hDL26suwq7B9LToJS+2MB4Rq4o0hAvcmzVqQQ0p55MuiupFZwQ6MO
         wYwexqumsOQEgOipPOjE2cLEQQ0KqA4F50nVjZaHXTgamNrzarXJDnkHzav9sAdy9cup
         y8brrJPhl5uaAeZQ7+VHe5Tjq8x/dDPDa5Jetb4optZrLZbYSPyDXQujBfPiiQLpYaBT
         W4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254198; x=1749858998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+5Bd7zkjIDO1H+lfyodM1++vUZ5mljRsfn//VOCKL0=;
        b=h2v1tTN+CvmGTjw8LDQ6otzAzwe2EtZPweGMeRDHSGL2VLyfLLsUTRr2jDUqHEgZrp
         C59Gl/FhcXh73JcSMfs5q53Bb7J0vtIdZoHBGUoHJKq/C+f+oaKsku6vPXIrHDCHK+78
         tKMzPXkk1lRQ8sI5ocos9J+3GmHdCKRcDN04FdhVn1E5qrBD0MdfXBrzNxawMDKQp6RZ
         2RmjiGWePwf6Lpfk81dPNKP13rPmXgPWaCJP4ONicOGGJKTbpewaeeWkFrQlO7RvMVe5
         8hCNW0rL6Cbl2ArXkwt1i0rDgM7NrHBmcSKXAkj7oidRgkDezYQ6D4ZrJtu9qgq0sbxS
         OGpA==
X-Gm-Message-State: AOJu0YzSUYQFrPcV6rGM3YBxzkhADaaZX3v6NGlco1oYe2BbXFV+k9GB
	cc/0h/g7A06tQx13BMIY/Emp3aBKM/EpJsovMoJcCc7ZefNkW42V7EXiYGzFkzzfYtM8s7c96tJ
	jUdKu6KIq6G4B7Jh+e9MaNDjmTljkpgA4WMy8nD091nKgu8buiBcLY7oaTDkDh5afdJXPHiLnFd
	f8NUW0LQTiCNsXpifNqnRDIjHwtAjDC9hlplPvTw==
X-Google-Smtp-Source: AGHT+IHU/sU0ESGBwoHFbRLLuKr1fUnbJgHvmdDkRH8dhCDT6jHEHhlFqQcWVOeHKmjkrwzUfyxEHDaa/fs2
X-Received: from pjbsb7.prod.google.com ([2002:a17:90b:50c7:b0:312:391e:a230])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54c:b0:234:9066:c857
 with SMTP id d9443c01a7336-23601e50d77mr66571995ad.21.1749254198048; Fri, 06
 Jun 2025 16:56:38 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:08 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-5-vipinsh@google.com>
Subject: [PATCH v2 04/15] KVM: selftests: Add option to save selftest runner
 output to a directory
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, --output/-o, to selftest runner which enables to
save individual tests output (stdout & stderr) stream to a directory in
a hierarchical way. Create folder hierarchy same as tests hieararcy
given by --test-files and --test-dirs.

Also, add a command line flag, --append-output-time, which will append
timestamp (format YYYY.M.DD.HH.MM.SS) to the directory name given in
--output flag.

Example:
  python3 runner --test-dirs test -o test_result --append_output_time

This will create test_result.2025.06.06.08.45.57 directory.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 30 ++++++++++++++++--
 tools/testing/selftests/kvm/runner/command.py | 31 +++++++++++++++++--
 .../testing/selftests/kvm/runner/selftest.py  |  8 +++--
 .../selftests/kvm/runner/test_runner.py       | 17 +++++-----
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index f7f679be0e03..54bdc248b13f 100644
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
@@ -41,6 +43,16 @@ def cli():
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
 
 
@@ -71,12 +83,26 @@ def setup_logging(args):
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
 
 def fetch_tests_from_dirs(scan_dirs):
     test_files = []
diff --git a/tools/testing/selftests/kvm/runner/command.py b/tools/testing/selftests/kvm/runner/command.py
index 44c8e0875779..6f6b1811b490 100644
--- a/tools/testing/selftests/kvm/runner/command.py
+++ b/tools/testing/selftests/kvm/runner/command.py
@@ -4,6 +4,9 @@
 # Author: vipinsh@google.com (Vipin Sharma)
 
 import subprocess
+import pathlib
+import contextlib
+import os
 
 
 class Command:
@@ -12,17 +15,39 @@ class Command:
     Returns the exit code, std output and std error of the command.
     """
 
-    def __init__(self, command, timeout):
+    def __init__(self, command, timeout, output_dir):
         self.command = command
         self.timeout = timeout
+        self.output_dir = output_dir
 
-    def run(self):
+    def _run(self, output=None, error=None):
         run_args = {
             "universal_newlines": True,
             "shell": True,
-            "capture_output": True,
             "timeout": self.timeout,
         }
 
+        if output is None and error is None:
+            run_args.update({"capture_output": True})
+        else:
+            run_args.update({"stdout": output, "stderr": error})
+
         proc = subprocess.run(self.command, **run_args)
         return proc.returncode, proc.stdout, proc.stderr
+
+    def run(self):
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
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 4c72108c47de..664958c693e5 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -32,7 +32,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, executable_dir, timeout):
+    def __init__(self, test_path, executable_dir, timeout, output_dir):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -40,7 +40,11 @@ class Selftest:
         test_command = os.path.join(executable_dir, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
-        self.command = command.Command(test_command, timeout)
+
+        if output_dir is not None:
+            output_dir = os.path.join(output_dir, test_path.lstrip("/"))
+        self.command = command.Command(test_command, timeout, output_dir)
+
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 1409e1cfe7d5..0501d77a9912 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -13,19 +13,22 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, test_files, args):
         self.tests = []
+        self.output_dir = args.output
 
         for test_file in test_files:
-            self.tests.append(Selftest(test_file, args.executable, args.timeout))
+            self.tests.append(Selftest(test_file, args.executable,
+                                       args.timeout, args.output))
 
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
-        logger.info("************** STDOUT BEGIN **************")
-        logger.info(test_result.stdout)
-        logger.info("************** STDOUT END **************")
-        logger.info("************** STDERR BEGIN **************")
-        logger.info(test_result.stderr)
-        logger.info("************** STDERR END **************")
+        if (self.output_dir is None):
+            logger.info("************** STDOUT BEGIN **************")
+            logger.info(test_result.stdout)
+            logger.info("************** STDOUT END **************")
+            logger.info("************** STDERR BEGIN **************")
+            logger.info(test_result.stderr)
+            logger.info("************** STDERR END **************")
 
     def start(self):
         ret = 0
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


