Return-Path: <kvm+bounces-24853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB12595BFFB
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F5C91F23A5F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F368F1D1726;
	Thu, 22 Aug 2024 20:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KBkkxk21"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5941C9ECE
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 20:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360195; cv=none; b=livhr0/9/kNNWJ/uyobDOh2XHhDrp+1XjFRsTSklO3oU9R4dVS9yuIjy3ZaGemeseKKLhtRrASfZIi42mdbGduDQVrIZm8oatAlNCkmi1r+u6bbA580q+Hh7uzCjaXXAr51kRCYurXjJWVMhKxwcOV1J8tCcWxADpnFBXwroS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360195; c=relaxed/simple;
	bh=8CopyTKSL1XJRyLPsu28ciQkolQndACBLxFByVay1/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXicZSPhkXCMi4ZeCHZXmTbz5rr96ZvloK6W/qQ6ukNBTIsY0bE6HV3a0dLYQCiCqRwfMh9fJ1kb4N1vYSfy5cbt2l3lY2nwSwTIM3Wgv6laFauzAB5wvKTlAmHs06a2OwEvP0AF3xOyJikTA4JKyd3etlgLjv+bdceDQOLwd3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KBkkxk21; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5bec507f4ddso5734a12.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 13:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724360191; x=1724964991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=td79jgMjWx4Orz9AL6SJH05EMU9DfYAEJ300uGx7uoE=;
        b=KBkkxk21vJg5lbeeH3DqvJD3sN2Z4Atg5+py8v60foCV5QLjL1m9gFjFR77CisZd2U
         GMOcvlUcG19Sl6CVbU+aN7+8Uhgts0pHDkbrgQ2MIylqF2LdZTd84PM1d/Ug8u7TP0Og
         x5LW5ggfnifbQ5H61i+ShnjwE7UDPGGO6zSldKXNcE/ZMqfI/wN6156xPcPQGgd1ablV
         qLS76KkkEEOor63aFWTsfK/0rKrxE5N/7/cqOqrMDeHUPEn3b+r9prIRN1VrcpX7y+aS
         sjo6obF4ZRaW5PF6HhCuhR1A9poX/8K3WLOJkl8eG3Yi3e1cmEZ8PtaFjkc7amB5RBs2
         PEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724360191; x=1724964991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=td79jgMjWx4Orz9AL6SJH05EMU9DfYAEJ300uGx7uoE=;
        b=azYJhjqXqMWEWiGMavFcsBX8qmsyoS4uHRDWa3peENMsddWOsofQ6WFb+yH6H1jYB4
         AtwYR+/XrTR6/PA2QlvaZ1Hp9qv33MWOfCUbg2bfNRheOfT66lUZ49UoT5Lx7tZEaBn9
         0p/xD2qqS43gRhcSLFExZbgNYkB8nZKmbQoUdp4fHHnaxID0J5++LvpL+7et1qO1HE4f
         OxHxQu88VNZGYbM1roB0wXdNJMW0eGiaHSbZLiGbnDBs8AHawn0HUhD31AUpKNorLnYe
         Kte2UNxwLGoTny3RjHMD4S2zDnT2AMuzIMskuCZSdRnRCG+P5CNtiNTKAndpl1rRRu0R
         nndg==
X-Gm-Message-State: AOJu0YwdgEYZyh0P3lEcxcXbyd+r4BcPvIJVYnkLa3aXaiAWPFviQ6e/
	Xs5zse+HbwudpG7zDCFHWpSpm+cm0n8Ex9LOxU2Keu/lMLKVG9RTYWwcuUrlqJDJyi+Zp0y0nO7
	K5h+9/wunFXMhgHlsEH0/M99vLQhsXgiH7ULtjFh38RouzYD2mV5ldx0=
X-Google-Smtp-Source: AGHT+IHo5tJteyr4d1a/DUKU7A9PBB0j6bhzWnkCmBM6x6M3MSRCZRGoEClRJv71KXRc/RKfYDKJvWl16Yr4u3Ha/UI=
X-Received: by 2002:a05:6402:1e8f:b0:58b:93:b624 with SMTP id
 4fb4d7f45d1cf-5c088db5028mr5636a12.1.1724360190911; Thu, 22 Aug 2024 13:56:30
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com>
In-Reply-To: <20240821223012.3757828-1-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Thu, 22 Aug 2024 13:55:54 -0700
Message-ID: <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just default
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oops! Adding archs mailing list and maintainers which have arch folder
in tool/testing/selftests/kvm

On Wed, Aug 21, 2024 at 3:30=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> This series is introducing a KVM selftests runner to make it easier to
> run selftests with some interesting configurations and provide some
> enhancement over existing kselftests runner.
>
> I would like to get an early feedback from the community and see if this
> is something which can be useful for improving KVM selftests coverage
> and worthwhile investing time in it. Some specific questions:
>
> 1. Should this be done?
> 2. What features are must?
> 3. Any other way to write test configuration compared to what is done her=
e?
>
> Note, python code written for runner is not optimized but shows how this
> runner can be useful.
>
> What are the goals?
> - Run tests with more than just the default settings of KVM module
>   parameters and test itself.
> - Capture issues which only show when certain combination of module
>   parameter and tests options are used.
> - Provide minimum testing which can be standardised for KVM patches.
> - Run tests parallely.
> - Dump output in a hierarchical folder structure for easier tracking of
>   failures/success output
> - Feel free to add yours :)
>
> Why not use/extend kselftests?
> - Other submodules goal might not align and its gonna be difficult to
>   capture broader set of requirements.
> - Instead of test configuration we will need separate shell scripts
>   which will act as tests for each test arg and module parameter
>   combination. This will easily pollute the KVM selftests directory.
> - Easier to enhance features using Python packages than shell scripts.
>
> What this runner do?
> - Reads a test configuration file (tests.json in patch 1).
>   Configuration in json are written in hierarchy where multiple suites
>   exist and each suite contains multiple tests.
> - Provides a way to execute tests inside a suite parallelly.
> - Provides a way to dump output to a folder in a hierarchical manner.
> - Allows to run selected suites, or tests in a specific suite.
> - Allows to do some setup and teardown for test suites and tests.
> - Timeout can be provided to limit test execution duration.
> - Allows to run test suites or tests on specific architecture only.
>
> Runner is written in python and goal is to only use standard library
> constructs. This runner will work on Python 3.6 and up
>
> What does a test configuration file looks like?
> Test configuration are written in json as it is easier to read and has
> inbuilt package support in Python. Root level is a json array denoting
> suites and each suite can multiple tests in it using json array.
>
> [
>   {
>     "suite": "dirty_log_perf_tests",
>     "timeout_s": 300,
>     "arch": "x86_64",
>     "setup": "echo Setting up suite",
>     "teardown": "echo tearing down suite",
>     "tests": [
>       {
>         "name": "dirty_log_perf_test_max_vcpu_no_manual_protect",
>         "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/c=
puinfo) -g",
>         "arch": "x86_64",
>         "setup": "echo Setting up test",
>         "teardown": "echo tearing down test",
>         "timeout_s": 5
>       }
>     ]
>   }
> ]
>
> Usage:
> Runner "runner.py" and test configuration "tests.json" lives in
> tool/testing/selftests/kvm directory.
>
> To run serially:
> ./runner.py tests.json
>
> To run specific test suites:
> ./runner.py tests.json dirty_log_perf_tests x86_sanity_tests
>
> To run specific test in a suite:
> ./runner.py tests.json x86_sanity_tests/vmx_msrs_test
>
> To run everything parallely (runs tests inside a suite parallely):
> ./runner.py -j 10 tests.json
>
> To dump output to disk:
> ./runner.py -j 10 tests.json -o sample_run
>
> Sample output (after removing timestamp, process ID, and logging
> level columns):
>
>   ./runner.py tests.json  -j 10 -o sample_run
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_no_manual_pro=
tect
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protec=
t
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protec=
t_random_access
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_10_vcpu_hugetlb
>   PASSED: x86_sanity_tests/vmx_msrs_test
>   SKIPPED: x86_sanity_tests/private_mem_conversions_test
>   FAILED: x86_sanity_tests/apic_bus_clock_test
>   PASSED: x86_sanity_tests/dirty_log_page_splitting_test
>   -----------------------------------------------------------------------=
---
>   Test runner result:
>   1) dirty_log_perf_tests:
>      1) PASSED: dirty_log_perf_test_max_vcpu_no_manual_protect
>      2) PASSED: dirty_log_perf_test_max_vcpu_manual_protect
>      3) PASSED: dirty_log_perf_test_max_vcpu_manual_protect_random_access
>      4) PASSED: dirty_log_perf_test_max_10_vcpu_hugetlb
>   2) x86_sanity_tests:
>      1) PASSED: vmx_msrs_test
>      2) SKIPPED: private_mem_conversions_test
>      3) FAILED: apic_bus_clock_test
>      4) PASSED: dirty_log_page_splitting_test
>   -----------------------------------------------------------------------=
---
>
> Directory structure created:
>
> sample_run/
> |-- dirty_log_perf_tests
> |   |-- dirty_log_perf_test_max_10_vcpu_hugetlb
> |   |   |-- command.stderr
> |   |   |-- command.stdout
> |   |   |-- setup.stderr
> |   |   |-- setup.stdout
> |   |   |-- teardown.stderr
> |   |   `-- teardown.stdout
> |   |-- dirty_log_perf_test_max_vcpu_manual_protect
> |   |   |-- command.stderr
> |   |   `-- command.stdout
> |   |-- dirty_log_perf_test_max_vcpu_manual_protect_random_access
> |   |   |-- command.stderr
> |   |   `-- command.stdout
> |   `-- dirty_log_perf_test_max_vcpu_no_manual_protect
> |       |-- command.stderr
> |       `-- command.stdout
> `-- x86_sanity_tests
>     |-- apic_bus_clock_test
>     |   |-- command.stderr
>     |   `-- command.stdout
>     |-- dirty_log_page_splitting_test
>     |   |-- command.stderr
>     |   |-- command.stdout
>     |   |-- setup.stderr
>     |   |-- setup.stdout
>     |   |-- teardown.stderr
>     |   `-- teardown.stdout
>     |-- private_mem_conversions_test
>     |   |-- command.stderr
>     |   `-- command.stdout
>     `-- vmx_msrs_test
>         |-- command.stderr
>         `-- command.stdout
>
>
> Some other features for future:
> - Provide "precheck" command option in json, which can filter/skip tests =
if
>   certain conditions are not met.
> - Iteration option in the runner. This will allow the same test suites to
>   run again.
>
> Vipin Sharma (1):
>   KVM: selftestsi: Create KVM selftests runnner to run interesting tests
>
>  tools/testing/selftests/kvm/runner.py  | 282 +++++++++++++++++++++++++
>  tools/testing/selftests/kvm/tests.json |  60 ++++++
>  2 files changed, 342 insertions(+)
>  create mode 100755 tools/testing/selftests/kvm/runner.py
>  create mode 100644 tools/testing/selftests/kvm/tests.json
>
>
> base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
> --
> 2.46.0.184.g6999bdac58-goog
>

