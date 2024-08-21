Return-Path: <kvm+bounces-24801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2654595A7C6
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 00:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEB81C2190A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BA617CA0B;
	Wed, 21 Aug 2024 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JupYPin7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98633165EEE
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724279424; cv=none; b=EkFxMb3Hu2AMr+gXlZmuQB8o26tIMbo+VGs4hWpOlHzJPUhu29ekkUkThDiQ1vxSd3Vxz8pWWl4ADZ476IeHguhEuJbByXNuO4W07ZDZTKpaAm257fjo/zbEdnNBUVxZzPHBMGvEE6J5WGfcwJWFhxEaAAisxf5kx3rv/RgIOC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724279424; c=relaxed/simple;
	bh=s9IsiDKVwYuT65wq319ugFV7IBLWrRQ+QIpTmFazwMA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ECz+5y17rTgzgl2/ojfTcv0eTW0jBlhGb6yPq+2NZnNpCqWrHtR6i30zje0zZPIUC5Qotv02LOApQ1oZ7uK35CXAViF2p9rsyZlbPnWCaX4hzLakRT6ubnu9MENg48rf9ei+ANudsERo6DX4KqgggdtaC88CrK6z0BAwIf9hc28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JupYPin7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1159159528so1736199276.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 15:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724279421; x=1724884221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nskIx7LfF1mBL9LnPca+VoAlBy/p/Mz7+Hqtgv8vqNA=;
        b=JupYPin7cRVgHgnrNWxpxMwUbZQpyxZcTXq5ubOGeCV2CfzvNiOMH575HRhjzub/pN
         lGgzHYH/MOCH3Cw2YElow6kK+5qG5rSK7LA4KOk/VKFDvXQXZckJk9zU2HDVrJ0oa45K
         a0H2mdtLmfzTohNGfOYsmRObOkZn9vb8jIJyWKnkMerCeHgZ7xuQ3E5o7SKd4s96ua/m
         3fXCKbioX89F6KxWcNTjk1c9obs1D0LjetiGin5tz/1MgubGx/YxJ12B8KGJ1jctGnLU
         VUB725s9Y48opOQIHjPUD1Off+kTakg3qPriJL6oUL84z9egrdUpWPtpvu/Zeig/hmdK
         A+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724279421; x=1724884221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nskIx7LfF1mBL9LnPca+VoAlBy/p/Mz7+Hqtgv8vqNA=;
        b=Xi5k6LAUz36aZARTvzGfG/EpZVfm7aRT/833fjiypTCalSB1Z8zrjPcUcH9ImxapPN
         fY2F51PP/1YZ/B+JmW2fLXls2QcOlFsBip9ERpSRBUd5Jq1N9qe7Jhz9P/b3KL/vBQpB
         Fo8KTD0/7Ikz/bZU/6DNS3ypyjj2tAakhqtzWz/yveZdcyDhmjHBPRf733qX1qYxAr3v
         u3wmGn+uxU6nmVTJZNE0kCGwWM7o01z+u47QtrqnecaXNPz5PQJkvPe5YvHH1ljGVfgb
         uAp0uCkX5Zwkx0fKbYJYOVjH9I3lHIhAN7v30d1qhqBk8khMyF9isvvcBGrdHvOipiM/
         51zg==
X-Gm-Message-State: AOJu0YxbQAXKlMIGrTk4DVQfdWoO1dhpdSgGGYTd4fKa6vof7wD2eAfH
	6B11eMfVcWT72lkEBlxcdgh38kQMwnuFYeBjk5tqT4tAPOcEFq+Iswz1Xf7v/O2vV2Ya37JA2N6
	1gMpXIVFsDzy8ndybLkQbH+15ms5gDBuuN7d/mp46vNiDRrfRt9NU+rYr2UrTDF9++NjQ84CM/2
	F1PI+p/FEjIc17XAFHLS4uUNk/vTc8ICVYhQ==
X-Google-Smtp-Source: AGHT+IEx/fflGc8igNbe+q+wUNIu1x2rTtD8YdTRpV70LrKtOPBWCDBKJVr7RXMNmvYd54bBlLnkLeaGLJAT
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a25:ce81:0:b0:e16:6c06:f809 with SMTP id
 3f1490d57ef6-e179013bb01mr213276.0.1724279421356; Wed, 21 Aug 2024 15:30:21
 -0700 (PDT)
Date: Wed, 21 Aug 2024 15:30:12 -0700
In-Reply-To: <20240821223012.3757828-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Message-ID: <20240821223012.3757828-2-vipinsh@google.com>
Subject: [PATCH 1/1] KVM: selftestsi: Create KVM selftests runnner to run
 interesting tests
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create a selftest runner "runner.py" for KVM which can run tests with
more interesting configurations other than the default values. Read
those configurations from "tests.json".

Provide runner some options to run differently:
1. Run using different configuration files.
2. Run specific test suite or test in a specific suite.
3. Allow some setup and teardown capability for each test and test suite
   execution.
4. Timeout value for tests.
5. Run test suite parallelly.
6. Dump stdout and stderror in hierarchical folder structure.
7. Run/skip tests based on platform it is executing on.

Print summary of the run at the end.

Add a starter test configuration file "tests.json" with some sample
tests which runner can use to execute tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner.py  | 282 +++++++++++++++++++++++++
 tools/testing/selftests/kvm/tests.json |  60 ++++++
 2 files changed, 342 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/runner.py
 create mode 100644 tools/testing/selftests/kvm/tests.json

diff --git a/tools/testing/selftests/kvm/runner.py b/tools/testing/selftests/kvm/runner.py
new file mode 100755
index 000000000000..46f6c1c8ce2c
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner.py
@@ -0,0 +1,282 @@
+#!/usr/bin/env python3
+
+import argparse
+import json
+import subprocess
+import os
+import platform
+import logging
+import contextlib
+import textwrap
+import shutil
+
+from pathlib import Path
+from multiprocessing import Pool
+
+logging.basicConfig(level=logging.INFO,
+                    format = "%(asctime)s | %(process)d | %(levelname)8s | %(message)s")
+
+class Command:
+    """Executes a command
+
+    Execute a command.
+    """
+    def __init__(self, id, command, timeout=None, command_artifacts_dir=None):
+        self.id = id
+        self.args = command
+        self.timeout = timeout
+        self.command_artifacts_dir = command_artifacts_dir
+
+    def __run(self, command, timeout=None, output=None, error=None):
+            proc=subprocess.run(command, stdout=output,
+                                stderr=error, universal_newlines=True,
+                                shell=True, timeout=timeout)
+            return proc.returncode
+
+    def run(self):
+        output = None
+        error = None
+        with contextlib.ExitStack() as stack:
+            if self.command_artifacts_dir is not None:
+                output_path = os.path.join(self.command_artifacts_dir, f"{self.id}.stdout")
+                error_path = os.path.join(self.command_artifacts_dir, f"{self.id}.stderr")
+                output = stack.enter_context(open(output_path, encoding="utf-8", mode = "w"))
+                error = stack.enter_context(open(error_path, encoding="utf-8", mode = "w"))
+            return self.__run(self.args, self.timeout, output, error)
+
+COMMAND_TIMED_OUT = "TIMED_OUT"
+COMMAND_PASSED = "PASSED"
+COMMAND_FAILED = "FAILED"
+COMMAND_SKIPPED = "SKIPPED"
+SETUP_FAILED = "SETUP_FAILED"
+TEARDOWN_FAILED = "TEARDOWN_FAILED"
+
+def run_command(command):
+    if command is None:
+        return COMMAND_PASSED
+
+    try:
+        ret = command.run()
+        if ret == 0:
+            return COMMAND_PASSED
+        elif ret == 4:
+            return COMMAND_SKIPPED
+        else:
+            return COMMAND_FAILED
+    except subprocess.TimeoutExpired as e:
+        logging.error(type(e).__name__ + str(e))
+        return COMMAND_TIMED_OUT
+
+class Test:
+    """A single test.
+
+    A test which can be run on its own.
+    """
+    def __init__(self, test_json, timeout=None, suite_dir=None):
+        self.name = test_json["name"]
+        self.test_artifacts_dir = None
+        self.setup_command = None
+        self.teardown_command = None
+
+        if suite_dir is not None:
+            self.test_artifacts_dir = os.path.join(suite_dir, self.name)
+
+        test_timeout = test_json.get("timeout_s", timeout)
+
+        self.test_command = Command("command", test_json["command"], test_timeout, self.test_artifacts_dir)
+        if "setup" in test_json:
+            self.setup_command = Command("setup", test_json["setup"], test_timeout, self.test_artifacts_dir)
+        if "teardown" in test_json:
+            self.teardown_command = Command("teardown", test_json["teardown"], test_timeout, self.test_artifacts_dir)
+
+    def run(self):
+        if self.test_artifacts_dir is not None:
+            Path(self.test_artifacts_dir).mkdir(parents=True, exist_ok=True)
+
+        setup_status = run_command(self.setup_command)
+        if setup_status != COMMAND_PASSED:
+            return SETUP_FAILED
+
+        try:
+            status = run_command(self.test_command)
+            return status
+        finally:
+            teardown_status = run_command(self.teardown_command)
+            if (teardown_status != COMMAND_PASSED
+                    and (status == COMMAND_PASSED or status == COMMAND_SKIPPED)):
+                return TEARDOWN_FAILED
+
+def run_test(test):
+    return test.run()
+
+class Suite:
+    """Collection of tests to run
+
+    Group of tests.
+    """
+    def __init__(self, suite_json, platform_arch, artifacts_dir, test_filter):
+        self.suite_name = suite_json["suite"]
+        self.suite_artifacts_dir = None
+        self.setup_command = None
+        self.teardown_command = None
+        timeout = suite_json.get("timeout_s", None)
+
+        if artifacts_dir is not None:
+            self.suite_artifacts_dir = os.path.join(artifacts_dir, self.suite_name)
+
+        if "setup" in suite_json:
+            self.setup_command = Command("setup", suite_json["setup"], timeout, self.suite_artifacts_dir)
+        if "teardown" in suite_json:
+            self.teardown_command = Command("teardown", suite_json["teardown"], timeout, self.suite_artifacts_dir)
+
+        self.tests = []
+        for test_json in suite_json["tests"]:
+            if len(test_filter) > 0 and test_json["name"] not in test_filter:
+                continue;
+            if test_json.get("arch") is None or test_json["arch"] == platform_arch:
+                self.tests.append(Test(test_json, timeout, self.suite_artifacts_dir))
+
+    def run(self, jobs=1):
+        result = {}
+        if len(self.tests) == 0:
+            return COMMAND_PASSED, result
+
+        if self.suite_artifacts_dir is not None:
+            Path(self.suite_artifacts_dir).mkdir(parents = True, exist_ok = True)
+
+        setup_status = run_command(self.setup_command)
+        if setup_status != COMMAND_PASSED:
+            return SETUP_FAILED, result
+
+
+        if jobs > 1:
+            with Pool(jobs) as p:
+                tests_status = p.map(run_test, self.tests)
+            for i,test in enumerate(self.tests):
+                logging.info(f"{tests_status[i]}: {self.suite_name}/{test.name}")
+                result[test.name] = tests_status[i]
+        else:
+            for test in self.tests:
+                status = run_test(test)
+                logging.info(f"{status}: {self.suite_name}/{test.name}")
+                result[test.name] = status
+
+        teardown_status = run_command(self.teardown_command)
+        if teardown_status != COMMAND_PASSED:
+            return TEARDOWN_FAILED, result
+
+
+        return COMMAND_PASSED, result
+
+def load_tests(path):
+    with open(path) as f:
+        tests = json.load(f)
+    return tests
+
+
+def run_suites(suites, jobs):
+    """Runs the tests.
+
+    Run test suits in the tests file.
+    """
+    result = {}
+    for suite in suites:
+        result[suite.suite_name] = suite.run(jobs)
+    return result
+
+def parse_test_filter(test_suite_or_test):
+    test_filter = {}
+    if len(test_suite_or_test) == 0:
+        return test_filter
+    for test in test_suite_or_test:
+        test_parts = test.split("/")
+        if len(test_parts) > 2:
+            raise ValueError("Incorrect format of suite/test_name combo")
+        if test_parts[0] not in test_filter:
+            test_filter[test_parts[0]] = []
+        if len(test_parts) == 2:
+            test_filter[test_parts[0]].append(test_parts[1])
+
+    return test_filter
+
+def parse_suites(suites_json, platform_arch, artifacts_dir, test_suite_or_test):
+    suites = []
+    test_filter = parse_test_filter(test_suite_or_test)
+    for suite_json in suites_json:
+        if len(test_filter) > 0 and suite_json["suite"] not in test_filter:
+            continue
+        if suite_json.get("arch") is None or suite_json["arch"] == platform_arch:
+            suites.append(Suite(suite_json,
+                                platform_arch,
+                                artifacts_dir,
+                                test_filter.get(suite_json["suite"], [])))
+    return suites
+
+
+def pretty_print(result):
+    logging.info("--------------------------------------------------------------------------")
+    if not result:
+        logging.warning("No test executed.")
+        return
+    logging.info("Test runner result:")
+    suite_count = 0
+    test_count = 0
+    for suite_name, suite_result in result.items():
+        suite_count += 1
+        logging.info(f"{suite_count}) {suite_name}:")
+        if suite_result[0] != COMMAND_PASSED:
+            logging.info(f"\t{suite_result[0]}")
+        test_count = 0
+        for test_name, test_result in suite_result[1].items():
+            test_count += 1
+            if test_result == "PASSED":
+                logging.info(f"\t{test_count}) {test_result}: {test_name}")
+            else:
+                logging.error(f"\t{test_count}) {test_result}: {test_name}")
+    logging.info("--------------------------------------------------------------------------")
+
+def args_parser():
+    parser = argparse.ArgumentParser(
+        prog = "KVM Selftests Runner",
+        description = "Run KVM selftests with different configurations",
+        formatter_class=argparse.RawTextHelpFormatter
+    )
+
+    parser.add_argument("-o","--output",
+                        help="Creates a folder to dump test results.")
+    parser.add_argument("-j", "--jobs", default = 1, type = int,
+                        help="Number of parallel executions in a suite")
+    parser.add_argument("test_suites_json",
+                        help = "File containing test suites to run")
+
+    test_suite_or_test_help = textwrap.dedent("""\
+                               Run specific test suite or specific test from the test suite.
+                               If nothing specified then run all of the tests.
+
+                               Example:
+                                   runner.py tests.json A/a1 A/a4 B C/c1
+
+                               Assuming capital letters are test suites and small letters are tests.
+                               Runner will:
+                               - Run test a1 and a4 from the test suite A
+                               - Run all tests from the test suite B
+                               - Run test c1 from the test suite C"""
+                               )
+    parser.add_argument("test_suite_or_test", nargs="*", help=test_suite_or_test_help)
+
+
+    return parser.parse_args();
+
+def main():
+    args = args_parser()
+    suites_json = load_tests(args.test_suites_json)
+    suites = parse_suites(suites_json, platform.machine(),
+                          args.output, args.test_suite_or_test)
+
+    if args.output is not None:
+        shutil.rmtree(args.output, ignore_errors=True)
+    result = run_suites(suites, args.jobs)
+    pretty_print(result)
+
+if __name__ == "__main__":
+    main()
diff --git a/tools/testing/selftests/kvm/tests.json b/tools/testing/selftests/kvm/tests.json
new file mode 100644
index 000000000000..1c1c15a0e880
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests.json
@@ -0,0 +1,60 @@
+[
+        {
+                "suite": "dirty_log_perf_tests",
+                "timeout_s": 300,
+                "tests": [
+                        {
+                                "name": "dirty_log_perf_test_max_vcpu_no_manual_protect",
+                                "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/cpuinfo) -g"
+                        },
+                        {
+                                "name": "dirty_log_perf_test_max_vcpu_manual_protect",
+                                "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/cpuinfo)"
+                        },
+                        {
+                                "name": "dirty_log_perf_test_max_vcpu_manual_protect_random_access",
+                                "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/cpuinfo) -a"
+                        },
+                        {
+                                "name": "dirty_log_perf_test_max_10_vcpu_hugetlb",
+                                "setup": "echo 5120 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages",
+                                "command": "./dirty_log_perf_test -v 10 -s anonymous_hugetlb_2mb",
+                                "teardown": "echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
+                        }
+                ]
+        },
+        {
+                "suite": "x86_sanity_tests",
+                "arch" : "x86_64",
+                "tests": [
+                        {
+                                "name": "vmx_msrs_test",
+                                "command": "./x86_64/vmx_msrs_test"
+                        },
+                        {
+                                "name": "private_mem_conversions_test",
+                                "command": "./x86_64/private_mem_conversions_test"
+                        },
+                        {
+                                "name": "apic_bus_clock_test",
+                                "command": "./x86_64/apic_bus_clock_test"
+                        },
+                        {
+                                "name": "dirty_log_page_splitting_test",
+                                "command": "./x86_64/dirty_log_page_splitting_test -b 2G -s anonymous_hugetlb_2mb",
+                                "setup": "echo 2560 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages",
+                                "teardown": "echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
+                        }
+                ]
+        },
+        {
+                "suite": "arm_sanity_test",
+                "arch" : "aarch64",
+                "tests": [
+                        {
+                                "name": "page_fault_test",
+                                "command": "./aarch64/page_fault_test"
+                        }
+                ]
+        }
+]
\ No newline at end of file
-- 
2.46.0.184.g6999bdac58-goog


