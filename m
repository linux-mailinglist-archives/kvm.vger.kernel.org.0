Return-Path: <kvm+bounces-41249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1935FA65941
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC1AC3B503B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817C61EB5CC;
	Mon, 17 Mar 2025 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xXCPuzPw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BBA1A0BF3
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230184; cv=none; b=nYugFuMNv5l5hDKwvMR0NvPpwiD0Vx8NGjvpwxBE3VJVMKWpgdYxgC2UvkMBp1UtPcfGZT04J+nhVFdm7/gb6I2A7JPBA8xsnpjQhwHdPHEp5FwazqpwvDgR3e9de7hCVUzlVinrVw8I3MBS7Naxh09Wv+PfX7Q1V9RyEBGX2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230184; c=relaxed/simple;
	bh=zKY2O+h44vg2AZUyM+fybeTrhOsDX/DE1x+MEN0imN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hzjKk6HdZynvcvils8IDIq+dEZNIrE0um4EbwSFj+3KfKMciykBWJsNgUY771S4uLbR8+JlpZ+MmdbKAv0BeshlZvaIElNUJksv7jWc7Khpo4QJf54qvH2W0uvVrx/8LxlY4j483nUxiDDOwRgYoDuoJT4MI05Sk16DjqCLI4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xXCPuzPw; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3912baafc58so4054515f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230178; x=1742834978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u7ZptfcVywAs5S9WPv2/GeL62BfGTfGlQVZZ9GYrYds=;
        b=xXCPuzPwRdZcCGVhJJsIWj4cjrFj3PSClUMQaM2QspF/R/PiLFVmfQyKa3kWP2UE9v
         fMDG5Rqq0ZFM9vmDII6FUq4EkQZXl5vo3DIvgPSZNmpYwCbCnTWle3jvvhZnvuvhHT4q
         5A1rFfBbGjizyFWtUPsO3qP/ZlnsLHAFKRNy6X1pF5kDhVGNRfc/O32YpyjZzVDZePiK
         nEX8/PEEq08VSLkFs428VaDruKG0hqTpm+UKx4ICufeGn2N+Ra4llNF6Lbad9JbXHGXb
         ttWKzMqafPIb1tlQNq+tkG0DBxyL0d3PSajfhCrZ2kPUaA8IO5qcVrRnVP+6cNLqoKEP
         QMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230178; x=1742834978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7ZptfcVywAs5S9WPv2/GeL62BfGTfGlQVZZ9GYrYds=;
        b=BcrB3nHHRrd9jxc2IK8sDxdvEXhYYoKVz3u1221SIbeAKmQUDlb14Bexi99+CHzAz6
         JzhPufeMn923gLwvCpwkuhRd6kkE5JPsNSg4QqYt7Txj7jM1sSJWtpCrsAffvYklMzlo
         6xTLHZJy5EmykVFbcq+5EEYCOHSNRGt7YQNmgjfltx8pH2p3nvrHOig+aVu21EHVq6EK
         tCvzhLanqwuGh9iwfqLrQyS562PUyYdTy2EuAfypf6WZkFtMn4ZKcFbsjE0gyiItTs4/
         d0TI9I2Yz9EeKqNny9uZ13gmENipaELLaUN75MPqVYhX91qGjx0vQ1Un6+7MoBrSR/pa
         W8Sw==
X-Gm-Message-State: AOJu0YwVdKyxw/pJ8j4mnuGlP32NVl6iDgF17z1WqtONQfGfjl94wbYF
	OHplGWx4cV2QyRWYNXPwmPxRW1nXFaUx+9fV4iHxpQ6nZUJV5fVNyVGx5w/sM0ES2q0F9y4tQ8w
	jiqw=
X-Gm-Gg: ASbGncvy/guMjzOcg3holyk9ttAxedNYPShRlRzneXT5rmsJRKb+spsj3nQtuVxKLQr
	kmhhsi3ZMIbU0pS3ybR5p3DmoJM4zmkmtrL4h/u+HFan9cqMUnuAFYzF8eGvHj0XhmoNpt1J9QS
	BMu+4KJghUpMBZ2lVDjcfmBdahfzRQN7JmCm/H3Ouc0LyKE3lwPnmi2T9F+Nfyuc0jtRdr8yGwK
	SHPd46SGYi5aBoeVasxg9xhA19EnmHrMR7s9RBx9Mk3jNbe4AeNc1b2+IjxNKl/F67RkCihTaOc
	02M/tC9CNvOfsGatnMDn7kolO70oLqfZis5OAHT0dlW9UQ==
X-Google-Smtp-Source: AGHT+IFvFLEtNts4+EjupQj7tKz7Ub/sfS5CRz526ULsf0t9rBwSNgpmM3LhpFRnB8TblPnkZ0kchg==
X-Received: by 2002:a5d:47ac:0:b0:391:13d6:c9f0 with SMTP id ffacd0b85a97d-3971f9e7813mr13297922f8f.47.1742230178319;
        Mon, 17 Mar 2025 09:49:38 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:37 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v11 0/8] riscv: add SBI SSE extension tests
Date: Mon, 17 Mar 2025 17:46:45 +0100
Message-ID: <20250317164655.1120015-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds tests for SBI SSE extension as well as needed
infrastructure for SSE support. It also adds test specific asm-offsets
generation to use custom OFFSET and DEFINE from the test directory.

These tests can be run using an OpenSBI version that implements latest
specifications modification [1]

Link: https://github.com/rivosinc/opensbi/tree/dev/cleger/sse [1]

---

V11:
 - Use mask inside sbi_impl_opensbi_mk_version()
 - Mask the SBI version with a new mask
 - Use assert inside sbi_get_impl_id/version()
 - Remove sbi_check_impl()
 - Increase completion timeout as events failed completing under 1000
   micros when system is loaded.

V10:
 - Use && instead of || for timeout handling
 - Add SBI patches which introduce function to get implementer ID and
   version as well as implementer ID defines.
 - Skip injection tests in OpenSBI < v1.6

V9:
 - Use __ASSEMBLER__ instead of __ASSEMBLY__
 - Remove extra spaces
 - Use assert to check global event in
   sse_global_event_set_current_hart()
 - Tabulate SSE events names table
 - Use sbi_sse_register() instead of sbi_sse_register_raw() in error
   testing
 - Move a report_pass() out of error path
 - Rework all injection tests with better error handling
 - Use an env var for sse event completion timeout
 - Add timeout for some potentially infinite while() loops

V8:
 - Short circuit current event tests if failure happens
 - Remove SSE from all report strings
 - Indent .prio field
 - Add cpu_relax()/smp_rmb() where needed
 - Add timeout for global event ENABLED state check
 - Added BIT(32) aliases tests for attribute/event_id.

V7:
 - Test ids/attributes/attributes count > 32 bits
 - Rename all SSE function to sbi_sse_*
 - Use event_id instead of event/evt
 - Factorize read/write test
 - Use virt_to_phys() for attributes read/write.
 - Extensively use sbiret_report_error()
 - Change check function return values to bool.
 - Added assert for stack size to be below or equal to PAGE_SIZE
 - Use en env variable for the maximum hart ID
 - Check that individual read from attributes matches the multiple
   attributes read.
 - Added multiple attributes write at once
 - Used READ_ONCE/WRITE_ONCE
 - Inject all local event at once rather than looping fopr each core.
 - Split test_arg for local_dispatch test so that all CPUs can run at
   once.
 - Move SSE entry and generic code to lib/riscv for other tests
 - Fix unmask/mask state checking

V6:
 - Add missing $(generated-file) dependencies for "-deps" objects
 - Split SSE entry from sbi-asm.S to sse-asm.S and all SSE core functions
   since it will be useful for other tests as well (dbltrp).

V5:
 - Update event ranges based on latest spec
 - Rename asm-offset-test.c to sbi-asm-offset.c

V4:
 - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
 - Add proper asm-offset generation for tests
 - Move SSE specific file from lib/riscv to riscv/

V3:
 - Add -deps variable for test specific dependencies
 - Fix formatting errors/typo in sbi.h
 - Add missing double trap event
 - Alphabetize sbi-sse.c includes
 - Fix a6 content after unmasking event
 - Add SSE HART_MASK/UNMASK test
 - Use mv instead of move
 - move sbi_check_sse() definition in sbi.c
 - Remove sbi_sse test from unitests.cfg

V2:
 - Rebased on origin/master and integrate it into sbi.c tests

Clément Léger (8):
  kbuild: Allow multiple asm-offsets file to be generated
  riscv: Set .aux.o files as .PRECIOUS
  riscv: Use asm-offsets to generate SBI_EXT_HSM values
  lib: riscv: Add functions for version checking
  lib: riscv: Add functions to get implementer ID and version
  riscv: lib: Add SBI SSE extension definitions
  lib: riscv: Add SBI SSE support
  riscv: sbi: Add SSE extension tests

 scripts/asm-offsets.mak |   22 +-
 riscv/Makefile          |    5 +-
 lib/riscv/asm/csr.h     |    1 +
 lib/riscv/asm/sbi.h     |  177 +++++-
 lib/riscv/sbi-sse-asm.S |  102 ++++
 lib/riscv/asm-offsets.c |    9 +
 lib/riscv/sbi.c         |  105 +++-
 riscv/sbi-tests.h       |    1 +
 riscv/sbi-asm.S         |    6 +-
 riscv/sbi-asm-offsets.c |   11 +
 riscv/sbi-sse.c         | 1278 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    2 +
 riscv/.gitignore        |    1 +
 13 files changed, 1707 insertions(+), 13 deletions(-)
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.2


