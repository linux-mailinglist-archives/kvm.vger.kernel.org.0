Return-Path: <kvm+bounces-59185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF8FBAE0F8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F1331944A0D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102FC23F294;
	Tue, 30 Sep 2025 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xqD4moGi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF48C2472A8
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250216; cv=none; b=feRfAMlDF3gzAxtAa41FELOsJdlgnjksXZPex2pqfn1dUBpXziWWwwhVdHR3i14Qi/lCGrNzLV+04s/yIW/xYIJzw4cZKbvIyhruu3jtG7CJ8kCYAT7IEjvImzuzTTvFb2PFeVhE6X/f08aNhwxN4cp8vdmMOcrvU80lWV15sSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250216; c=relaxed/simple;
	bh=G97mnyJq28cSBFHDJuK3hFRlCkJ5T2LdJshTRF5pGPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OJBR4hJEBKqquw2mYUwkZhUOIfPCyYegUlN4Gzfkj/S4eO+xAg6W2kb9iNfqOeMGRAYTrhZEsKVgyLTTGV5DA43RPkmM5XfNcgHy8NnsaTRaKsV+WIyY5ccqJvNCTQvN62NmJierpxw4JxkswJyARaaBjII0GnkjYlZ4wgFKXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xqD4moGi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28973df6a90so27616505ad.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250214; x=1759855014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2Euv6clQfNxoRLfSL+cWKcybU5R4aSAzjQ7Pxx9veA=;
        b=xqD4moGiIi+WGrXApfAmL8VJiMEbqBSyHIPvKmyZJLOLfGeNagHxZZPRUjufEU5Yio
         2F8wDQAg7Siv25UznGFJd1+gTsUXzw8jl7qcWRLpuhOd4EKZvTk2PtKNdBQhQ5ZInKY6
         ZYT7mBv1pjVFqqDcDeAcq6c2Os1WJo0wJCnUjlZWZCOYjmBPNNwZIk0iNNGNw+pFHvhn
         V1ULYX+BjT7VxYW5VAUXbiJgQUd4P5tBqg3HQo74ExK9zuml5TlY4xkQCKJNg2t/DupS
         MuG1LVLCE9Cg+WR0ScNzDLmzdWlP3FLu8UGoeKfBXhpogQ5os9XRe+iLRF5eK/ptb5CK
         RV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250214; x=1759855014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2Euv6clQfNxoRLfSL+cWKcybU5R4aSAzjQ7Pxx9veA=;
        b=qMFrFoU3B2EkMcuzMy3eQenkm5pveD8AfO7tWcS6gJ1NN0I/B5z3gJaMIa125JMF42
         dxoRktcmwsfsCnhhDr92DK72DuxNwy4aKa5XU3T9qO5RdZB5uBsaoN25D1t55MlxDV9j
         7Cy9K9VNwjLJ9KYW85Q49o4BEAUwI5weLg3Lt7jcSDcgQibHy+Byaj1ZCLnS9tWKZzTB
         wLl94EvRTqpwWik4IiZmzEeMQkdse8j2X8OIlwA7EOOwVMqPz1lGV35gkB7sSCGULOzr
         z9XRnFwVZ6n1TZjrOLc+O7F4lLDX9Bpd70/GXcYeDZM6iN4ulwV3q1HRDxGJ4H3A68Oi
         iPdQ==
X-Gm-Message-State: AOJu0YzK1cNN4iMZhybv+T2Ksu1LEqlEBBh1yOHmjv2r/zE+RQFduyBq
	J9/3CIP44BjBgHglm1Ehe/EPyO8bvH7BAXG4BDam/wcYyx8t+sxZZViwEznszevk+DfJl3G7VV5
	jlYyPujRuFc8v7IsiKaecrMPKWV+zYhh2LSdWqPGyunYI8FYMiT1FHPj/SDwO7/OjaIjCZ413AJ
	2m/Ai+iEYg9/sor8V/5aRNtCjwDz0xzsGJautAIA==
X-Google-Smtp-Source: AGHT+IEUJogWYHXsmsuG3UsFdIVcKizfFNq9vULrceDQMPraAU5EEavtCr8SZ2YcitzUBBX0I97qyMqtVbSV
X-Received: from plpl2.prod.google.com ([2002:a17:903:3dc2:b0:27d:1f18:78ab])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b46:b0:252:1743:de67
 with SMTP id d9443c01a7336-28e7f318717mr3857185ad.44.1759250213581; Tue, 30
 Sep 2025 09:36:53 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:29 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-4-vipinsh@google.com>
Subject: [PATCH v3 3/9] KVM: selftests: Add timeout option in selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument in KVM selftest runner to limit amount of
time (seconds) given to a test for execution. Kill the test if it
exceeds the given timeout. Define a new SelftestStatus.TIMED_OUT to
denote a selftest final result. Add terminal color for status messages
of timed out tests.

Set the default value of 120 seconds for all tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  9 ++++-
 .../testing/selftests/kvm/runner/selftest.py  | 33 ++++++++++++-------
 .../selftests/kvm/runner/test_runner.py       |  2 +-
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 943c3bfe2eb6..5cedc5098a54 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -37,6 +37,11 @@ def cli():
                         default=".",
                         help="Finds the test executables in the given path. Default is the current directory.")
 
+    parser.add_argument("--timeout",
+                        default=120,
+                        type=int,
+                        help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
+
     return parser.parse_args()
 
 
@@ -44,6 +49,7 @@ def setup_logging():
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
         red_bold = "\033[31;1m"
+        red = "\033[31;1m"
         green = "\033[32m"
         yellow = "\033[33m"
         blue = "\033[34m"
@@ -52,7 +58,8 @@ def setup_logging():
             SelftestStatus.PASSED: green,
             SelftestStatus.NO_RUN: blue,
             SelftestStatus.SKIPPED: yellow,
-            SelftestStatus.FAILED: red_bold
+            SelftestStatus.FAILED: red_bold,
+            SelftestStatus.TIMED_OUT: red
         }
 
         def __init__(self, fmt=None, datefmt=None):
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index a94b6d4cda05..4783785ca230 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -17,6 +17,7 @@ class SelftestStatus(enum.IntEnum):
     NO_RUN = 22
     SKIPPED = 23
     FAILED = 24
+    TIMED_OUT = 25
 
     def __str__(self):
         return str.__str__(self.name)
@@ -28,7 +29,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, path):
+    def __init__(self, test_path, path, timeout):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -37,6 +38,7 @@ class Selftest:
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
         self.command = test_command
+        self.timeout = timeout
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
@@ -50,15 +52,24 @@ class Selftest:
             "universal_newlines": True,
             "shell": True,
             "stdout": subprocess.PIPE,
-            "stderr": subprocess.PIPE
+            "stderr": subprocess.PIPE,
+            "timeout": self.timeout,
         }
-        proc = subprocess.run(self.command, **run_args)
-        self.stdout = proc.stdout
-        self.stderr = proc.stderr
 
-        if proc.returncode == 0:
-            self.status = SelftestStatus.PASSED
-        elif proc.returncode == 4:
-            self.status = SelftestStatus.SKIPPED
-        else:
-            self.status = SelftestStatus.FAILED
+        try:
+            proc = subprocess.run(self.command, **run_args)
+            self.stdout = proc.stdout
+            self.stderr = proc.stderr
+
+            if proc.returncode == 0:
+                self.status = SelftestStatus.PASSED
+            elif proc.returncode == 4:
+                self.status = SelftestStatus.SKIPPED
+            else:
+                self.status = SelftestStatus.FAILED
+        except subprocess.TimeoutExpired as e:
+            self.status = SelftestStatus.TIMED_OUT
+            if e.stdout is not None:
+                self.stdout = e.stdout
+            if e.stderr is not None:
+                self.stderr = e.stderr
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index acc9fb3dabde..bea82c6239cd 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,7 +15,7 @@ class TestRunner:
         self.tests = []
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase, args.path))
+            self.tests.append(Selftest(testcase, args.path, args.timeout))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.51.0.618.g983fd99d29-goog


