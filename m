Return-Path: <kvm+bounces-41193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3AE1A6499A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A21BB166444
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52CA237185;
	Mon, 17 Mar 2025 10:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AFSjQf6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E162343B5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206815; cv=none; b=J2WeKNyQ4tyR4A40KnJu64prupP90+vAJ8lRUpEaQMhp84+OcfCG8N2FGj5W2da98Xj2S+SS7f5Q57spRxdb+Qvnj3zz3l/ET9seQFu2PeuB8ea9ujgfeSz2zPSOHRsakIlsW3xu+9ciQ20gkkJ7W4dQhhejv4eX50bCWyiq0dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206815; c=relaxed/simple;
	bh=IVr8ji9E7+MrwwWwU/TyFzqkrhimDK9rKt0ajVH5P58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pGaEsngQW8MK8qQLm7ZAyV4cHW8ECxqk6+M+S60QjNVfG0Fhm0F5+h5b3KeYpKGsMHMrYh3X7gCDlIgihQQJyBdIgboQeqpLrxcULunjnwSvYDs1krkqEvdXvDNhGTYuEgTPiixqr1cezqykH9HJkBlpIaC+HX5jRPUUXunwNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AFSjQf6R; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3912baafc58so3645931f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206810; x=1742811610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V7YMV+JZ6BIdacMpDlgwQ3lr6Io+aBiXLOqXA4jr1cs=;
        b=AFSjQf6R7ktftAefqq5zr9nIJmq53lCvuYvspAoY3SGuWSxKoG8bSiz1/GhZHXyEkM
         fW/M26//SBOAm2+gK9JpW9OVzDGCb0tP/TWCAcrYC5F7R7SrPbyNZQ5VJN3XwBfD8PXK
         H3klWIxNHuO7oybpGn9ZmSy5BEeYgl/fYeP7EizBDx575AuJZs7gYeYuoqDJ7/GlozeV
         m6drCD4NlLgtBSmA40Vtb1mcPAq0pIekmDrhSfg1MLJXAqCT1mLuBbEkCvXvQsmq3euD
         B1hEizFmxd2EyBT/OALmyx6eD8lkbakFoxWq4j1ig2X5qQLejmW7u/gntJLwu6sxlEuw
         WbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206810; x=1742811610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V7YMV+JZ6BIdacMpDlgwQ3lr6Io+aBiXLOqXA4jr1cs=;
        b=wo7Db0tSNUrUZZbulAoDcjKTOylyz21Cx5S4jVDiAuNj9HuGzL+BolE6lIazEjhfLR
         eJZI/AECs7KU2zTjHryRr6osB9uIqXwIaVev24NC8be/NIZgnMRlsPv3eR5RsyDpmTRe
         4Yw/rVYB1r+iau49Izsy5HoKG7TsNTWXN8h0TI/LHoUDozULgtBprOL9Z3kWftEUr3Ti
         nH3uqc1iQL3C9PAPLCrHpzFk3ighCMUK1Vc4wIwqnZiXMPYwlMcZDA5CvDnE5vZTc/ti
         1bjeLa51+DdfF5HIRp7YooodQ+3PQEfuGzV4NrwYaa/zWqnjmJ0Rlahyllp2ApyH72r0
         N/CQ==
X-Gm-Message-State: AOJu0Yy9bF3IG99kDfLNv5ecDTlxNYM+sqGAbW/cLcJzBe5bE0qiyism
	swRHYqjBGlu5lXRtYh/HelB0gGDS2ul3+NO57lJTV1INamdTg+Q9WybJL4zJiV+X5qa5sOKxu2L
	mfBk=
X-Gm-Gg: ASbGncstWH1dGa0aO2s8pav27EtYNH+Vct1Pws1SV0gYzZYJt/t5mKvv9cO7aNgzm3m
	IpsAaKV/IyayOR0Zw/1/hOE1ObI+fI6fEyTgEXcUug4Lyrh3TqJLsEU1MFaqd13w09tiaIxqm8J
	JR+ZwGciUSn0lMvAxsKUmCMvAqdoCSjCDlrOCOkRkyscFjNonyvwTi5sJBTlDj6piZrWWyXQXYj
	wGYB/h0fYOOv/6bd2JMs4GOnygR/zEQbOn+HdgOyI07vtzRY5gSFtp6n04WLLVy/waaY7//PWM0
	jD4CvTmCjkz9HB3vVAZ5g94F/cpXr174wStfSAPFGtzFXQ==
X-Google-Smtp-Source: AGHT+IGB0yHt2wBIw/462+iVCrcdpb1AXU0/1jVzuJx2gVAvTV2tfhGeP63NL8dy7sY2qzSw+SbxPQ==
X-Received: by 2002:a05:6000:1acc:b0:38f:39e5:6b5d with SMTP id ffacd0b85a97d-3971f7fa1e8mr11120342f8f.44.1742206809700;
        Mon, 17 Mar 2025 03:20:09 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:09 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v10 0/8] riscv: add SBI SSE extension tests
Date: Mon, 17 Mar 2025 11:19:46 +0100
Message-ID: <20250317101956.526834-1-cleger@rivosinc.com>
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
  riscv: sbi: Add functions for version checking
  lib: riscv: add functions to get implementer ID and version
  riscv: lib: Add SBI SSE extension definitions
  lib: riscv: Add SBI SSE support
  riscv: sbi: Add SSE extension tests

 scripts/asm-offsets.mak |   22 +-
 riscv/Makefile          |    5 +-
 lib/riscv/asm/csr.h     |    1 +
 lib/riscv/asm/sbi.h     |  187 +++++-
 lib/riscv/sbi-sse-asm.S |  102 ++++
 lib/riscv/asm-offsets.c |    9 +
 lib/riscv/sbi.c         |   95 ++-
 riscv/sbi-tests.h       |    1 +
 riscv/sbi-asm.S         |    6 +-
 riscv/sbi-asm-offsets.c |   11 +
 riscv/sbi-sse.c         | 1280 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    2 +
 riscv/.gitignore        |    1 +
 13 files changed, 1709 insertions(+), 13 deletions(-)
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.2


