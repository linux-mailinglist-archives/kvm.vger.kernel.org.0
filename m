Return-Path: <kvm+bounces-48682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B297CAD0A7B
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1308D1895980
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC7C23FC7D;
	Fri,  6 Jun 2025 23:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oag179pb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BB5241689
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254198; cv=none; b=X3cfu1qwrCQ3Ch5IYFXqpwYjxhFK4HU6T0tfdMZaNMSETNzdyBeBU9gdgVWIlQ4++7LUpLgvOZLMhwa7M2ei3nw9BTDE3bc42Io46KUjt6MFklAKly7B6Rk3PhevGvPpoHCcHp1GHDqhkiUFyIWSsZAn4DdBxo65ruCsk3OlAXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254198; c=relaxed/simple;
	bh=MsMd5ugpIJnnhoj3mBKfAsw8Ef8ZbW04Tf42BZUJhys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dl3wCXmmyonPHoNgdQBg4fxQdQzfx4PomSoLB9ONhd+1p6tvw9M5sWVj/gVIQU/4mE6S5UU3goIdAG0Q7P8PQmS5LxyOku8F5wT5Y+PTX+hUHKNYO+m0X/3mHZISmO8YPv88xKxP1mqEY3eApHhEocq7XwBZI9dzwv5WWkKYdd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oag179pb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7429fc0bfc8so3066874b3a.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254196; x=1749858996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGljYTvaXC7QnacTzvG5Nj4iX8W+IqA3xJgvnGBwRTM=;
        b=Oag179pb8AzN5tDrJd5Ns8wNZ46Ph43NTwndVC8cW85w+mDoGS3H5TRJWCk52NiAuv
         QF8lJq0t+79KsujAogX0NCgJj+i/iG9SKKNcTs7jH6KencFsQPQdcHrKsaGVH6h5vKSG
         h2nR3Xp686KgHu1hQ/Z/V75mPQh9681Ny/8UlSWrsq0iAuQykFMEhpPKD0wMyN+Icf3e
         lk9aXZ3iIoTX38vIi4heY2qArdXS81ybIz1uboJKIBppYPPFolNCMl1rs6OMoPoWzSFW
         lgNnwb1gY5rJ1R785U6ey5hDnOMCEbDhRQdleQpPUfjE53EkHZy99mvq3zr7L+jNPrQ6
         praQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254196; x=1749858996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGljYTvaXC7QnacTzvG5Nj4iX8W+IqA3xJgvnGBwRTM=;
        b=ZNLkmdLjLQCM7RwLbyuGxi7KlIEIyl6zLnNqmKSLhqWkgsA7f2UQXa3HWHbNobwdTo
         KCB0F05WKYxcp314ELtI5xXdbS+P0/4KDkmC6v1/zUZ09+rR96vM274KgrJ3Xj+7AwJx
         wddALKxRnKmhogWxcmFcTgat/4D8SNK5ph3XjUatrYLDC+GXF8e5M1e8XG7VGVMwFpJh
         aPzBl1oJAPXmtjUv4c2igUH5E0RmtlWXsWTyHJojuqauQ0jYe877u1yarzbV6JjM8WOz
         W+ELqkMBE9/YsKOGejJdvakQoJ5w661AmG28bkaORhSzG+ahVyNLAJiTwWOFnR+4YO46
         l9aw==
X-Gm-Message-State: AOJu0YxW+S6wHhhHW5MRTZa0StkBiSueMgLrnzDjo2vIqsOq/tjPp8iJ
	PpjPs1nEjpND01hLD76a8ZgP1LGC3xXAhQH4nMUKMYjztE7PJyPdoZDaSqaEof2sZTcjyJRX1LJ
	AvI42Z4UCuB5WUEBkbq+C1DqqHoH4fp1cc83AZMyjsAYyl61FY18/V6HGoDRLpyxvvjLz+fVKyV
	Akcuu2++phjVbbcelRoJ6UWwRDuFi8wqWbBhO0yw==
X-Google-Smtp-Source: AGHT+IEf6/EQQaFCn2+ilqOXhsd43GYZymP8LG9LnvyyGFrCPkId69cOH/yRMcziE3S42F6gZpobhUsXtO4j
X-Received: from pfhx2.prod.google.com ([2002:a05:6a00:1882:b0:747:abae:78e8])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3942:b0:215:e44c:831f
 with SMTP id adf61e73a8af0-21ee2559924mr7260991637.4.1749254196463; Fri, 06
 Jun 2025 16:56:36 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:07 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-4-vipinsh@google.com>
Subject: [PATCH v2 03/15] KVM: selftests: Add timeout option in selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument in KVM selftest runner to limit amount of
time (seconds) given to a test for execution. Kill the test if it exceeds the
given value. Define a new SelftestStatus.TIMED_OUT to denote a selftest
final result. Add terminal color for status messages of timed out tests.

Set the default value of 120 seconds for all tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 10 +++++++-
 tools/testing/selftests/kvm/runner/command.py |  4 +++-
 .../testing/selftests/kvm/runner/selftest.py  | 23 +++++++++++--------
 .../selftests/kvm/runner/test_runner.py       |  2 +-
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 599300831504..f7f679be0e03 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -35,6 +35,12 @@ def cli():
                         default=".",
                         help="Finds the test executables in the given directory. Default is the current directory.")
 
+    parser.add_argument("-t",
+                        "--timeout",
+                        default=120,
+                        type=int,
+                        help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
+
     return parser.parse_args()
 
 
@@ -42,6 +48,7 @@ def setup_logging(args):
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
         red_bold = "\033[31;1m"
+        red = "\033[31;1m"
         green = "\033[32m"
         yellow = "\033[33m"
         blue = "\033[34m"
@@ -50,7 +57,8 @@ def setup_logging(args):
             SelftestStatus.PASSED: green,
             SelftestStatus.NO_RUN: blue,
             SelftestStatus.SKIPPED: yellow,
-            SelftestStatus.FAILED: red_bold
+            SelftestStatus.FAILED: red_bold,
+            SelftestStatus.TIMED_OUT: red
         }
 
         def __init__(self, fmt=None, datefmt=None):
diff --git a/tools/testing/selftests/kvm/runner/command.py b/tools/testing/selftests/kvm/runner/command.py
index a63ff53a92b3..44c8e0875779 100644
--- a/tools/testing/selftests/kvm/runner/command.py
+++ b/tools/testing/selftests/kvm/runner/command.py
@@ -12,14 +12,16 @@ class Command:
     Returns the exit code, std output and std error of the command.
     """
 
-    def __init__(self, command):
+    def __init__(self, command, timeout):
         self.command = command
+        self.timeout = timeout
 
     def run(self):
         run_args = {
             "universal_newlines": True,
             "shell": True,
             "capture_output": True,
+            "timeout": self.timeout,
         }
 
         proc = subprocess.run(self.command, **run_args)
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index a0b06f150087..4c72108c47de 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -7,6 +7,7 @@ import command
 import pathlib
 import enum
 import os
+import subprocess
 
 
 class SelftestStatus(enum.IntEnum):
@@ -18,6 +19,7 @@ class SelftestStatus(enum.IntEnum):
     NO_RUN = 22
     SKIPPED = 23
     FAILED = 24
+    TIMED_OUT = 25
 
     def __str__(self):
         return str.__str__(self.name)
@@ -30,7 +32,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, executable_dir):
+    def __init__(self, test_path, executable_dir, timeout):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -38,7 +40,7 @@ class Selftest:
         test_command = os.path.join(executable_dir, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
-        self.command = command.Command(test_command)
+        self.command = command.Command(test_command, timeout)
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
@@ -48,10 +50,13 @@ class Selftest:
             self.stderr = "File doesn't exists."
             return
 
-        ret, self.stdout, self.stderr = self.command.run()
-        if ret == 0:
-            self.status = SelftestStatus.PASSED
-        elif ret == 4:
-            self.status = SelftestStatus.SKIPPED
-        else:
-            self.status = SelftestStatus.FAILED
+        try:
+            ret, self.stdout, self.stderr = self.command.run()
+            if ret == 0:
+                self.status = SelftestStatus.PASSED
+            elif ret == 4:
+                self.status = SelftestStatus.SKIPPED
+            else:
+                self.status = SelftestStatus.FAILED
+        except subprocess.TimeoutExpired as e:
+            self.status = SelftestStatus.TIMED_OUT
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 104f0b4c2e4e..1409e1cfe7d5 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,7 +15,7 @@ class TestRunner:
         self.tests = []
 
         for test_file in test_files:
-            self.tests.append(Selftest(test_file, args.executable))
+            self.tests.append(Selftest(test_file, args.executable, args.timeout))
 
     def _log_result(self, test_result):
         logger.log(test_result.status,
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


