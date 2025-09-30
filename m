Return-Path: <kvm+bounces-59188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6308BAE105
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B12C194491B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCCD24729C;
	Tue, 30 Sep 2025 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fwpRcENb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92418246795
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250221; cv=none; b=t3PY/8BScRTPSfNXaFGQ71Ji7xVWKvO1mfCaeIXGI+Nnw/kSlkMI0CiY86h/jYl4NVyQtSF8szHeFmZsvC95lLRPb0bgGCVd5Ih3XlNrZwJgTa0azyeJYPUKMeWhNNaJUqAGFghSchiOe9Zh0GWys1c4yp77/RcWE/Ce+RE1iJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250221; c=relaxed/simple;
	bh=lineM6Le2PSJRtKyCQTtrPVbmPz4X5IqFEqNVYi1TPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KtiLpYp+A/537B6ADohhOceQZ69F0eBvuYWUJ8yCkoauFRVziZ/PsnuucWvlOnGl9yWY2BYAOxxD0A0DyoF09VN3qhJrb7kz4w0bJYJRnj8Ws3jg60OW2L3o2i42Oyym46K5ENRpznbyRLRLJ3RqXJX6874yAwuMdNf8inSdEEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fwpRcENb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-78038ed99d9so8267467b3a.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250219; x=1759855019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTsqnY4+saNzCy5mGyriIvmSp6eaE/vqi0JjCPWBoU=;
        b=fwpRcENbYNAGvaLEBzD1JdvF1p0Lu1u4iUTzXH4s6LXL+km0L82hOyQbMS8p8AKCZh
         dR9P/86erYuj+h4NLDq+WS76vju/wH0z8AhtSN9powAbi51vmO4g2tZrjvDKLMBxc1ju
         50lCNUw6Du5EqxFRwfZEWiri0wnThyijoMIHnjvWNNIbBlAHQTts833E3vIHbYvGMhIM
         8D4dNYP/mEj+bAYSW85Eiyv71tuiFUbsERkhH6pccb7BvER5VVaDT27Yxr6EwhBmuIKl
         ucXGHNysPyJtRFAvhN3lj8VkNLq8YbT93mbXcAQDv7THXdRtBis+p5fxTUc7zNecbFR5
         A1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250219; x=1759855019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTsqnY4+saNzCy5mGyriIvmSp6eaE/vqi0JjCPWBoU=;
        b=m7+4PJLYQu4sj/2t6BxYYTZ7iqOZb5xG97Ow2Kypyqq4kiZYrxgEzghtvlSVem32bM
         8t2FWYdNORwns6RYPsOripor4/JVJYdRM8Q9QyzJ/98NOoMPIup8QfBZuwr1pMHocbft
         c/f0Wy6MEbLmTsi+yHQcBdNUnsWlWHOqbzJHE7QXEiIYmRJAGgQcwJHU2FI61dpD2QdF
         YWitTHOign02VeZeSRuRowAH7AfyylbQ58wI4osHvFPWUX6xdDNv2fNbCDGmxHylk4VE
         0MDFRIT9m3UTO3pqk1wqzVXKa64zmNT3AOy9zn4rtK8gdoU8kRfNjpUqvvY9FD6niwQr
         RhDQ==
X-Gm-Message-State: AOJu0YwR6kQIgAfcG3O7j/FOCUOdqS9Nf4Ry0y1j1Jp2TJhXXjGo04lV
	HqgLuDt0X5BX5t8iHz0co6kSmFND2SOGS2JLDOit04JSXFHWpzBMek+mwhc5jqqC06u/ef5itn9
	5KFrGuS0fZGeYxJr6agwEImI6Fm50IzY0DAUom80BZsE790HRjLoemiMrKMW5DZ+FtCjB2bxoDG
	YsB9hj9/G60fDDkFuVH/b13bn0sL1XJOpZ+6TdrQ==
X-Google-Smtp-Source: AGHT+IGhAsgZwOMvoWdZcUEtVVfFvQe5AhCplay9erkcPQTqVQZCmBY4Dt3zYWPsYtiBB7sDVDiH7IVgr5gK
X-Received: from pfoh11.prod.google.com ([2002:aa7:86cb:0:b0:77f:138f:8b8f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc4:b0:77b:5b58:34f7
 with SMTP id d2e1a72fcca58-78af4143e2amr69675b3a.9.1759250218647; Tue, 30 Sep
 2025 09:36:58 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:32 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-7-vipinsh@google.com>
Subject: [PATCH v3 6/9] KVM: selftests: Add various print flags to KVM
 selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add various print flags to selectively print outputs on terminal based
on test execution status (passed, failed, timed out, skipped, no run).

For each status provide further options (off, full, stderr, stdout,
status) to choose verbosity of their prints. Make "full" the default
choice.

Example: To print stderr for the failed tests and only status for the
passed test:

   python3 runner --test-dirs tests  --print-failed stderr \
   --print-passed status

Above command with disable print off skipped, timed out, and no run
tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 45 +++++++++++++++++++
 .../selftests/kvm/runner/test_runner.py       | 19 ++++++--
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index b98f72c9f7ee..4867e89c30f2 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -9,6 +9,7 @@ import os
 import sys
 import datetime
 import pathlib
+import textwrap
 
 from test_runner import TestRunner
 from selftest import SelftestStatus
@@ -60,6 +61,50 @@ def cli():
                         type=int,
                         help="Maximum number of tests that can be run concurrently. (Default: 1)")
 
+    status_choices = ["off", "full", "stdout", "stderr", "status"]
+    status_help_text = textwrap.dedent('''\
+                        Control output of the {} test.
+                        off   : dont print anything.
+                        full  : print stdout, stderr, and status of the test.
+                        stdout: print stdout and status of the test.
+                        stderr: print stderr and status of the test.
+                        status: only print the status of test execution and no other output.''');
+
+    parser.add_argument("--print-passed",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("passed"))
+
+    parser.add_argument("--print-failed",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("failed"))
+
+    parser.add_argument("--print-skipped",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("skipped"))
+
+    parser.add_argument("--print-timed-out",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("timed-out"))
+
+    parser.add_argument("--print-no-run",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("no-run"))
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 92eec18fe5c6..e8e8fd91c1ad 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -17,6 +17,13 @@ class TestRunner:
         self.tests = []
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.print_stds = {
+            SelftestStatus.PASSED: args.print_passed,
+            SelftestStatus.FAILED: args.print_failed,
+            SelftestStatus.SKIPPED: args.print_skipped,
+            SelftestStatus.TIMED_OUT: args.print_timed_out,
+            SelftestStatus.NO_RUN: args.print_no_run
+        }
 
         for testcase in testcases:
             self.tests.append(Selftest(testcase, args.path, args.timeout,
@@ -27,10 +34,14 @@ class TestRunner:
         return test
 
     def _log_result(self, test_result):
-        logger.info("*** stdout ***\n" + test_result.stdout)
-        logger.info("*** stderr ***\n" + test_result.stderr)
-        logger.log(test_result.status,
-                   f"[{test_result.status.name}] {test_result.test_path}")
+        print_level = self.print_stds.get(test_result.status, "full")
+
+        if (print_level == "full" or print_level == "stdout"):
+            logger.info("*** stdout ***\n" + test_result.stdout)
+        if (print_level == "full" or print_level == "stderr"):
+            logger.info("*** stderr ***\n" + test_result.stderr)
+        if (print_level != "off"):
+            logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
 
     def start(self):
         ret = 0
-- 
2.51.0.618.g983fd99d29-goog


