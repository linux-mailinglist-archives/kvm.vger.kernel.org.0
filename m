Return-Path: <kvm+bounces-24800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9A895A7C4
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 00:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3E921C21931
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B37C17C21B;
	Wed, 21 Aug 2024 22:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="inYuHKxH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459DF79D1
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724279417; cv=none; b=EGAlnxLPm7h1aRUEQEIgf4zqpuX+72Za72nPvigat7xrvAw+6O8gjVfRID5qW+E1sLw1gOP2gIccgvaiohdMA4oOWxTCY3KEsOBw8n7aVGE+Q4QpSk6em430erP+LFA56JoSy20Otrv58WICT5wgq5ot77TRsyMmXV40EMW5IKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724279417; c=relaxed/simple;
	bh=LINO5MPLA0e2HOfaA3mzpeFHrwb/zReDbZ5vUHGTOCA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XZv39mH7ecpeexpFmRT5O+fI/L3ZRTSFZjCq2UEPcH51apcLI7dRpzjYI8JlVmJK/AxCMslvzeayB5t8Ia1xuMC+FwizGAUowq9cgNYUmgIOQgMriURXmPTP6NTLaMH+9kl48VyeNzQHKOhx1rSHCKkKQfDmDAMuf0KQAzW0Yi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=inYuHKxH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cd854e1869so157819a12.2
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 15:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724279415; x=1724884215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NTF01qBh7lxk3yAxPCS4iytPS54KEJvLAhYw6pzy16M=;
        b=inYuHKxHyrsVbnNYtAcgLuJ+XnGO1+ZdasE8tyMb0+A7Pb8AhurnA8TBrh/bp/8FIJ
         FfOeubYKTTliJV/11SMFB5HJjsTCJN80Qmqwuu59RaIb1SBSzWbTdW5agu4+b1pGm6of
         YS2xrB4BoGUjcod5v5WeCGleWNuGquIshn93i5iUNB2AXM10Whq+R9+u1ylxtReHcDGv
         hrivDaqM5E2+tKohyYdnHoHMBgyGkLvn15cmkoUf9ydD1YztV6dUeMYOfTIO5xKFBlcx
         LID52BR9dl0uEFncpwUHKtFjpZ8/8UfvZ9Zm4iYjdPXZvZgNNkAWjr2R9gmbtSb49WMN
         iLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724279415; x=1724884215;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTF01qBh7lxk3yAxPCS4iytPS54KEJvLAhYw6pzy16M=;
        b=UABBxqC/zWn/CKaOsc5s2WpjuUpuM8Qk4k0uP2vN2v05+c7VBKO9Hy6Gjw7hqk/Q88
         vRRVkarAqVP1paNMI+TrcDnOJoMkBTexupfjtfAqB0KgV3ZfQ3N9cTPbWMicKHQbp3xF
         /kiJipycV4i9ildfArYpDEnkL2KdGenniBoPBNYk3nZ7i039WqCmW0NtegFgo/R3olfX
         VaksoCEujDBXsi3AnrDodXJ58k2rFKu0q04luZAm7dF8OSQ2ZX9fN/m9DMbCGf54H3PO
         HSHBxnQR27I6Au2Ly8L3+pE23BekhdoBTNkQSmzuoWwMZnq2/vRQU3jIedhOJUswCO2E
         Gu5Q==
X-Gm-Message-State: AOJu0YxUkEut9k+86Y2xhPa+OsDmaMwLa8r/TcugmxmleriPlF/HB6wh
	ESgr83vZlUhBUqmB14cZFAdL3NdnHSnb1nUW4SyOy2j3vopVRDQdSlNsfuz56Y8Rk5Kimklj6RV
	Zo0ARrk1qWypt9xccCQ2XeBBC5E0kSLdN+3GrH6StNn377MoAfH2xaxZE4h/LyR4rz1t8//AFHe
	n7AGWS7bAC74z91j1aG7oxPT2UtvZdiFw34w==
X-Google-Smtp-Source: AGHT+IHBWLrR2nSaJVPq0C0IRhhM7THEwVie0fLgzN5n53xtMpR4lkAOhfRelMWmpnlNhG8Fuh7OuHO9veUu
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a17:903:22c4:b0:1fa:2ae7:cc6a with SMTP id
 d9443c01a7336-20367c0eebemr2593935ad.4.1724279415405; Wed, 21 Aug 2024
 15:30:15 -0700 (PDT)
Date: Wed, 21 Aug 2024 15:30:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Message-ID: <20240821223012.3757828-1-vipinsh@google.com>
Subject: [RFC PATCH 0/1] KVM selftests runner for running more than just default
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is introducing a KVM selftests runner to make it easier to
run selftests with some interesting configurations and provide some
enhancement over existing kselftests runner.

I would like to get an early feedback from the community and see if this
is something which can be useful for improving KVM selftests coverage
and worthwhile investing time in it. Some specific questions:

1. Should this be done?
2. What features are must?
3. Any other way to write test configuration compared to what is done here?

Note, python code written for runner is not optimized but shows how this
runner can be useful.

What are the goals?
- Run tests with more than just the default settings of KVM module
  parameters and test itself.
- Capture issues which only show when certain combination of module
  parameter and tests options are used.
- Provide minimum testing which can be standardised for KVM patches.
- Run tests parallely.
- Dump output in a hierarchical folder structure for easier tracking of
  failures/success output
- Feel free to add yours :)

Why not use/extend kselftests?
- Other submodules goal might not align and its gonna be difficult to
  capture broader set of requirements.
- Instead of test configuration we will need separate shell scripts
  which will act as tests for each test arg and module parameter
  combination. This will easily pollute the KVM selftests directory.
- Easier to enhance features using Python packages than shell scripts.

What this runner do?
- Reads a test configuration file (tests.json in patch 1).
  Configuration in json are written in hierarchy where multiple suites
  exist and each suite contains multiple tests.
- Provides a way to execute tests inside a suite parallelly.
- Provides a way to dump output to a folder in a hierarchical manner.
- Allows to run selected suites, or tests in a specific suite.
- Allows to do some setup and teardown for test suites and tests.
- Timeout can be provided to limit test execution duration.
- Allows to run test suites or tests on specific architecture only.

Runner is written in python and goal is to only use standard library
constructs. This runner will work on Python 3.6 and up

What does a test configuration file looks like?
Test configuration are written in json as it is easier to read and has
inbuilt package support in Python. Root level is a json array denoting
suites and each suite can multiple tests in it using json array.

[
  {
    "suite": "dirty_log_perf_tests",
    "timeout_s": 300,
    "arch": "x86_64",
    "setup": "echo Setting up suite",
    "teardown": "echo tearing down suite",
    "tests": [
      {
        "name": "dirty_log_perf_test_max_vcpu_no_manual_protect",
        "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/cpuinfo) -g",
        "arch": "x86_64",
	"setup": "echo Setting up test",
	"teardown": "echo tearing down test",
        "timeout_s": 5
      }
    ]
  }
]

Usage:
Runner "runner.py" and test configuration "tests.json" lives in
tool/testing/selftests/kvm directory.

To run serially:
./runner.py tests.json

To run specific test suites:
./runner.py tests.json dirty_log_perf_tests x86_sanity_tests

To run specific test in a suite:
./runner.py tests.json x86_sanity_tests/vmx_msrs_test

To run everything parallely (runs tests inside a suite parallely):
./runner.py -j 10 tests.json

To dump output to disk:
./runner.py -j 10 tests.json -o sample_run

Sample output (after removing timestamp, process ID, and logging
level columns):

  ./runner.py tests.json  -j 10 -o sample_run
  PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_no_manual_protect
  PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protect
  PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protect_random_access
  PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_10_vcpu_hugetlb
  PASSED: x86_sanity_tests/vmx_msrs_test
  SKIPPED: x86_sanity_tests/private_mem_conversions_test
  FAILED: x86_sanity_tests/apic_bus_clock_test
  PASSED: x86_sanity_tests/dirty_log_page_splitting_test
  --------------------------------------------------------------------------
  Test runner result:
  1) dirty_log_perf_tests:
     1) PASSED: dirty_log_perf_test_max_vcpu_no_manual_protect
     2) PASSED: dirty_log_perf_test_max_vcpu_manual_protect
     3) PASSED: dirty_log_perf_test_max_vcpu_manual_protect_random_access
     4) PASSED: dirty_log_perf_test_max_10_vcpu_hugetlb
  2) x86_sanity_tests:
     1) PASSED: vmx_msrs_test
     2) SKIPPED: private_mem_conversions_test
     3) FAILED: apic_bus_clock_test
     4) PASSED: dirty_log_page_splitting_test
  --------------------------------------------------------------------------

Directory structure created:

sample_run/
|-- dirty_log_perf_tests
|   |-- dirty_log_perf_test_max_10_vcpu_hugetlb
|   |   |-- command.stderr
|   |   |-- command.stdout
|   |   |-- setup.stderr
|   |   |-- setup.stdout
|   |   |-- teardown.stderr
|   |   `-- teardown.stdout
|   |-- dirty_log_perf_test_max_vcpu_manual_protect
|   |   |-- command.stderr
|   |   `-- command.stdout
|   |-- dirty_log_perf_test_max_vcpu_manual_protect_random_access
|   |   |-- command.stderr
|   |   `-- command.stdout
|   `-- dirty_log_perf_test_max_vcpu_no_manual_protect
|       |-- command.stderr
|       `-- command.stdout
`-- x86_sanity_tests
    |-- apic_bus_clock_test
    |   |-- command.stderr
    |   `-- command.stdout
    |-- dirty_log_page_splitting_test
    |   |-- command.stderr
    |   |-- command.stdout
    |   |-- setup.stderr
    |   |-- setup.stdout
    |   |-- teardown.stderr
    |   `-- teardown.stdout
    |-- private_mem_conversions_test
    |   |-- command.stderr
    |   `-- command.stdout
    `-- vmx_msrs_test
        |-- command.stderr
        `-- command.stdout


Some other features for future:
- Provide "precheck" command option in json, which can filter/skip tests if
  certain conditions are not met.
- Iteration option in the runner. This will allow the same test suites to
  run again.

Vipin Sharma (1):
  KVM: selftestsi: Create KVM selftests runnner to run interesting tests

 tools/testing/selftests/kvm/runner.py  | 282 +++++++++++++++++++++++++
 tools/testing/selftests/kvm/tests.json |  60 ++++++
 2 files changed, 342 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/runner.py
 create mode 100644 tools/testing/selftests/kvm/tests.json


base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.46.0.184.g6999bdac58-goog


