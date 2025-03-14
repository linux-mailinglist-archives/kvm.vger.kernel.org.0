Return-Path: <kvm+bounces-41041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0008A60FA1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2082B4601F7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8980B1FCFE3;
	Fri, 14 Mar 2025 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xxE1Ah62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B11A5B82
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950640; cv=none; b=L5aCEkqLXLi2lggRkxeSfp/rafG91189xUDXwBjlwxNqOHV5mL8lxIrR3aOWIXNTnOxQZhi2Zgw9FKfWBEfnjnvt59UaJniLQ1E0QpHpuB9/wCaUp1WnBe1j2k6usrM+GDer3X1xGmNr7TgKi6/G09LupzqWxQztVe6YUELdZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950640; c=relaxed/simple;
	bh=He+VPdwcwfevz84IQeZQEj3uDDsU8UEtPfJyHlM28HU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ff7zBPa5OukJztDlE93G4QiH440GptskOq6oJtxRUIZ8w1yGJqF40jZMZGH7LritwxAcx1D23dktLLsa6XaDAVgx9LhNvPaXjrD8XqTd0O3RybZ3sRt+pi0GOdsIV8trGqo6sbDt3tC4njbvjnZd9BrJw83/3eCIqzvyN0Q0Hzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xxE1Ah62; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so18818125e9.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741950636; x=1742555436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T7npoQ+lAZF+jhadyDUdozIqVWY5cY+s4DzjRASfiDo=;
        b=xxE1Ah62EdyAlaCsbnVQL1zV0d2XgOUCzR49lzpZvtv49CPF/4+ih3QIMeglmCcaYM
         ZcR6T3jzH7F4CUd1sMr+CIOims2XRWeF+5n3GfyzA7WjxPsuxv3br1lAmJEpCyry4WU+
         BXP0GCOmxlmlH7n+/25WHfkEVmp6wPQS7s2XmRboDi1tORrwV8ajK0Jp8psDYT/H3/yi
         LD3/YKy+BC/Nf4LtvgxeQd+kDrT1Awe8djKKgz/ydtaaWfV0z9l+95/rd4S0Wsmc7TJS
         xSuS9NWCSoba5fNbzp/AmZt+0315L0pv0J2CyKclKbgbFNvcyPOW2XCcX1JTEeJQ4Wi6
         w39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741950636; x=1742555436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7npoQ+lAZF+jhadyDUdozIqVWY5cY+s4DzjRASfiDo=;
        b=qaclDFlo4eRQ2tuxUHas5WYYHsXXzRysD2pDgbKi+AzKj5Q2IGWvajiCY+dlbivR5u
         75Lm9jEGe4+e3pgxGu16wKmSINYu8TYDYp8WqnDanvAmnDmtQhwTT61X9bt+rerI3ujB
         5C1m7J28z+y6mcRAEuPyBRg5xbDgVarA+Xy88Kv6eUUhNpN5gXbrHCUJQ4UvHMZjVeI8
         1HC2Ath90SxSmqfZhHyOwKMrjUoEmK9a0kUCTP3WrB7r6JaKCUHImdRufjX3btubA4q/
         hcesMgUVWhIolF6ixY+/2JdijPmygY3xQapQYAoOBstZIiJdDLe2GiAuZ3jZha/Xu2UX
         hW6w==
X-Gm-Message-State: AOJu0Yyp++gAi/YEwkZZyIZyyTAuoy3YQroU4ayOkWH0UY1DFcQsdZYn
	0KAYzkD0mfC3gZBK6ENLdd2bBAWXLKfsiCvQFq0kDZBTcBVCEAk2WT7o85PGGbMb3JJ2bxOKvza
	aEFs=
X-Gm-Gg: ASbGncv2oS7XVAjnfG/1vfqYCpLq7cRrkNc7Bdbfol7iCgSc9m4ZcMJJp5QgvYD0yzi
	QhwbHQLyUGnNsLgFJq9sVLHq26alZ9qIkTcF+vjWTTxMbBK06TQou3a6QMmlUUuXCN3+Xsx9joz
	LEP4SsmyK2CEgbynFWBdvRPFuxu4KJjrCGi5zkON2Mm3BUwoIsr0IO6fUhwClkPYjIZssKXGPgd
	qsfzX8xxfTLA7m2Z8jXYaV8v7+B5mNkiM+rz5O8oYFhutt0oiI3UrAV2SuQL6IBKZhCtDa/iEcd
	mxn2duVsms7oCGVDkzaD/k/eC3OLMLMrDd7dB4iKXHcm6A==
X-Google-Smtp-Source: AGHT+IG2zI60J3Qf9j4BDnR5L7rK81GHKTGeEIYHibpuXiVq5lNxg0JtPjrYedTVrFPgsRNi7D8V/A==
X-Received: by 2002:a05:600c:4fd4:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-43d1ec8e682mr27038625e9.18.1741950635911;
        Fri, 14 Mar 2025 04:10:35 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb3188e8sm5299203f8f.65.2025.03.14.04.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 04:10:35 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v9 0/6] riscv: add SBI SSE extension tests
Date: Fri, 14 Mar 2025 12:10:23 +0100
Message-ID: <20250314111030.3728671-1-cleger@rivosinc.com>
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

---

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

Clément Léger (6):
  kbuild: Allow multiple asm-offsets file to be generated
  riscv: Set .aux.o files as .PRECIOUS
  riscv: Use asm-offsets to generate SBI_EXT_HSM values
  riscv: lib: Add SBI SSE extension definitions
  lib: riscv: Add SBI SSE support
  riscv: sbi: Add SSE extension tests

 scripts/asm-offsets.mak |   22 +-
 riscv/Makefile          |    5 +-
 lib/riscv/asm/csr.h     |    1 +
 lib/riscv/asm/sbi.h     |  142 ++++-
 lib/riscv/sbi-sse-asm.S |  102 ++++
 lib/riscv/asm-offsets.c |    9 +
 lib/riscv/sbi.c         |   76 +++
 riscv/sbi-tests.h       |    1 +
 riscv/sbi-asm.S         |    6 +-
 riscv/sbi-asm-offsets.c |   11 +
 riscv/sbi-sse.c         | 1263 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    2 +
 riscv/.gitignore        |    1 +
 13 files changed, 1630 insertions(+), 11 deletions(-)
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.2


