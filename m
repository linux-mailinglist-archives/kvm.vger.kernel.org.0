Return-Path: <kvm+bounces-59182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E16C2BAE0F3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C66E4A8010
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A3A242D60;
	Tue, 30 Sep 2025 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pp2l3RCb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C944323ABAF
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250212; cv=none; b=YwZyb3iJUXRWP67egkcxwZ1NTVrbYHH+XrJ9sFLAN3tIuK2U7JFB8h1rfa+zOj2jgjexlL74W5WRGsNonMjWfdxwRb0ZDVokQTIl5ceig1D2PDd1k4xcvIf4ygUdShnYD8Ga2SOvvR0ggGS7O78Lo6smOk86r8l9N902TZe1f8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250212; c=relaxed/simple;
	bh=6kgZ+o75xEJ9EbdBpm/V0tjYB3JQHgta7TJivYfMla0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a3Vi+IqhMwprvCwqjsvhkXvThOEmPFDjMx9DhK4WYXW7jK+lh+HiP1VMbl6MX4Zm8khqQhcWX4AgmWYzVh1EtPOLimC9dKmp46dEmfVRPSONQ197JmAZsIOBnFCaWlD/JDlSN+5EhYFDPJfa99u4WKBIxYDIIs7COUb5lhSdf7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pp2l3RCb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f68c697d3so4373794b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250209; x=1759855009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q5LgePzkRxjmi424htLltNXg1q5zxRKaifVE5Syh82s=;
        b=Pp2l3RCbo7sMeuEw8/RcMgSvwTd3/41KS7O+IO4rlNeTLiiu+S9+pwQ7NqRlV5hIdf
         0QRNCvXFgAWFqgWgsy1sS4Jy9y7SutIbSbjgT51boxG/sQG/hEY7uM7djWTJycPVtMLy
         qoZma2Dq6XLdkSZSRrrhavFuBZP/+U9ph2Uq8FbNH9bfLCsMZBVqRWfqBNRLoqVLIBtg
         AYxa1C64fUyp8gKNpCDyQMgDV98BktaEoEMtyj4Uk2ldaiz8ebj0XMvHl3k2OPBx4s08
         AYdyq2RKdzAKD2LcQD40nlPMa1ICHcRhS/s2CXa9HQOjmcwDyBbeVWPvFc9b9IC1Tr2p
         5i/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250209; x=1759855009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5LgePzkRxjmi424htLltNXg1q5zxRKaifVE5Syh82s=;
        b=D0b0eAdMd9eI2COBiX7dHVI4r/1YO9KU7A92MHZpketnm4FZg7ic49P7KClpj0Ujfk
         flheYJmlgllduO9i/ThUs7AQ3RjOetaRqZWyihQSfhb/sldWrw8wvNhL2gvpGEnUkGn3
         7FptowqkFdPA2fnHCYNAdTsD05WsRfQWqJaaUYcJpV5HCJGzQdqz29VvAQVJwv/fy0O0
         4Ki0mTnNXVzYFhGTZfQIjwVl2BfY8TCkSMVOclpsQdwEKQ3tgD1HNRQ8AtGqrQ65K4QA
         AWt9126lBsuWlKZavazjEjRqXpq0RXK+pqZH2n3OW//wfr2Di4hUNhfFw8oqI++WlDWP
         7dDw==
X-Gm-Message-State: AOJu0Yxr0dnY+7kvT9ScGpe1zuc7Mi65e6tWRzSNtip2/2oAGGUpcfoS
	lGgogDubli1bWY8X/mJJHu0p1yDq7gGZGRlQjjY3eIxrPL+cC4VzNE5m9aP2hV15RyXMKfzG8qT
	G2En8n1IxtoOjoFCbI5CrRNyuWvaDvUuEvGwLeGIOMh7xMlmX/h5IN2qhzqdympsZT1ww+e9RI3
	GDGyQoeqHO0hmRoRRRGYD3qyj3EWzkj1DCqUqSyQ==
X-Google-Smtp-Source: AGHT+IFfwV3VactE4ba6FoRVHzTuew8H79oNEwJxTcAq0uf0cCqCG98iICrJcj6DOYhQRbECloIyWc7dk2Ej
X-Received: from pfoh10.prod.google.com ([2002:aa7:86ca:0:b0:77c:4a2a:9783])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa3:b0:2e8:6bf6:7d6c
 with SMTP id adf61e73a8af0-321d8452cb1mr555553637.2.1759250208788; Tue, 30
 Sep 2025 09:36:48 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-1-vipinsh@google.com>
Subject: [PATCH v3 0/9] KVM Selftest Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This is v3 of KVM selftest runner. After making changes on feedback
given in v2, this series has reduced from 15 patches to 9 patches. I
have tried to address all of the comments from v2. There are none left
open and are incorporated to best of my understanding. 

To recap (copied from v2), KVM Selftest Runner allows running KVM
selftests with added features not present in default selftest runner
provided by selftests framework.

This Runner has two broad goals:
1. Make it easier for contributors and maintainers to run various
   configuration of tests with features like preserving output,
   controlling output verbosity, parallelism, different combinations of
   command line arguments.
2. Provide common place to write interesting and useful combinations of
   tests command line arguments to improve KVM test coverage. Default
   selftests runner provide little to no control over this.

Future patches will add features like:
- Print process id of the test in execution.
- CTRL+C currently spits out lots of warning (depending on --job value).
  This will be fixed in the next version.
- Add more tests configurations.
- Provide a way to set the environment in which runner will start tests. For
  example, setting huge pages, stress testing based on resources
  available on host.

This series is also available on github at:

https://github.com/shvipin/linux kvm/sefltests/runner-v3

v3:
- Created "tests_install" rule in Makefile.kvm to auto generate default
  testcases, which will be ignored in .gitignore.
- Changed command line option names to pass testcase files, directories,
  executable paths, print based on test status, and what to print.
  Removed certain other options based on feedback in v2.
- Merged command.py into selftest.py
- Fixed issue where timed out test's stdout and stderr were not printed.
- Reduced python version from 3.7 to 3.6.
- Fixed issue where test status numerical value was printed instead of
  text like PASSED, FAILED, SKIPPED, etc.
- Added README.rst.

v2: https://lore.kernel.org/kvm/20250606235619.1841595-1-vipinsh@google.com/
- Automatic default test generation.
- Command line flag to provide executables location
- Dump output to filesystem with timestamp
- Accept absolute path of *.test files/directory location
- Sticky status at bottom for the current state of runner.
- Knobs to control output verbosity
- Colored output for terminals.

v1: https://lore.kernel.org/kvm/20250222005943.3348627-1-vipinsh@google.com/
- Parallel test execution.
- Dumping separate output for each test.
- Timeout for test execution
- Specify single test or a test directory.

RFC: https://lore.kernel.org/kvm/20240821223012.3757828-1-vipinsh@google.com/

Vipin Sharma (9):
  KVM: selftest: Create KVM selftest runner
  KVM: selftests: Provide executables path option to the KVM selftest
    runner
  KVM: selftests: Add timeout option in selftests runner
  KVM: selftests: Add option to save selftest runner output to a
    directory
  KVM: selftests: Run tests concurrently in KVM selftests runner
  KVM: selftests: Add various print flags to KVM selftest runner
  KVM: selftests: Print sticky KVM selftests runner status at bottom
  KVM: selftests: Add rule to generate default tests for KVM selftests
    runner
  KVM: selftests: Provide README.rst for KVM selftests runner

 tools/testing/selftests/kvm/.gitignore        |   6 +-
 tools/testing/selftests/kvm/Makefile.kvm      |  20 ++
 tools/testing/selftests/kvm/runner/README.rst |  54 +++++
 .../testing/selftests/kvm/runner/__main__.py  | 184 ++++++++++++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 105 ++++++++++
 .../selftests/kvm/runner/test_runner.py       |  79 ++++++++
 .../2slot_5vcpu_10iter.test                   |   1 +
 .../no_dirty_log_protect.test                 |   1 +
 8 files changed, 449 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test

-- 
2.51.0.618.g983fd99d29-goog


