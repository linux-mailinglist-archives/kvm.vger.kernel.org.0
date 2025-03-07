Return-Path: <kvm+bounces-40342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84AD2A56D4F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 601877A51CC
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B37B23A998;
	Fri,  7 Mar 2025 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="dbCjVbPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C76F239072
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364156; cv=none; b=a/Mu9EOTiAdv0rwF2zBUuiNY7W9pS+OJEnRM/KpvUYMkXfE+4bILGJ0ylNlMlNSbEqiw6wbzDxqTD/6eGDUr0ixoJDu9gNw3jTIF5RlLu8ePWox6dbHgGpaJ4rIcu8yRiHomlRg23bII1dWqho2wVpoTmm/P8OJq05+CeUOpl+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364156; c=relaxed/simple;
	bh=TVZyG+uvvJqH79JhGYh67F5wQeGPPJPyTH5+w3/Wz90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rpKf2LqJZWjdg/EqR/erEUfYs+ijdZLZJdhlqJa1qXMKFqdzKAJ0I7F6HQx/yLf4j6dxLU8gDbCzNLq0HqBbDkmhO7RkRO7VJawNblZKk8QDfdxX7UT43yMoEi0oTpBtWr/mCWTyk5W4lClpdTLrTnh4ujUe2FMfRGgkwDnyzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=dbCjVbPN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43bbb440520so23850065e9.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 08:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741364151; x=1741968951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ma6UNYm4yNX/ZvXcUmutWIxQKtLrtbmF18vjvUMyo+0=;
        b=dbCjVbPNnjV+Cz7RGr3VP2vOTahYkvCQvjx6jOjEbEbFF+J/6fFHtVafsx0UGmNGn7
         Lypw7QWwBUXYh37c4KkICcPfjrhSNVxBWpjw03lH+LxX8tyfCaOUrcP9v3REsQ5KM8+c
         L5/+CDvjQ3AacST4h2NtYw0/5oG8rfbbJSkL4kAcdRpQTnMlciYGvsd6LmQlbqLoTOEm
         1BiIEAE+Fm6q51ZlYlhRyojX8WOT4u5DadoAXUHOWr/AIdsOpl9cCndNUyblwZxp0BIG
         NMe8t0iBGezS1nWVd3p43aFwRH/iuzeS734sgY4q0oEhowS+Nb19xrB5TSxLewAFgL8n
         riQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364151; x=1741968951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ma6UNYm4yNX/ZvXcUmutWIxQKtLrtbmF18vjvUMyo+0=;
        b=Af/qB0PBowIXdj8ef/FJwbF9ZDe0XmKmt3WVdzi+orPll+PSUcADUl7w2DKC0b2DFx
         HIXyN2C0QuaMximcUFMg4cM87FIH14p9wLVVbb+gUpOIfJnd6OSIMy014ozTiirpAJEp
         yAfObJkHlcF6t6Ft3sHdQ/msbeDYx+5iH0DR1GNvkRRFFu6oX6JS8LVsjEfmayHWkiK8
         /ZooGIev4ugfVf+enlU+4wmT3woW30Izw4S0SvAaW2Jh2u/LrzAxiZIxU2TyWtqR5xkJ
         0fYqkrs3bRabmEZtWZIKMkmlw4t7DQ1X93nc7h7Feu2VHoT24CwWIq53jIkC7dvSx5Lm
         dN/Q==
X-Gm-Message-State: AOJu0Yz/75WSgCO3vxLByYVt8gEWBa0XFv6eQE5knKMTRBamz7jTm0tE
	KsGji9iL9VjI+G3531RQX0AunttvpNINxI22Tr2qt4G2Ns1XM7j74jX8YX6RwJ6CR72clWvntSk
	C
X-Gm-Gg: ASbGncutVXgAUBnZiWYPM9sX6Kszb3//Kqu+aOqCTCpbR2dDka7zSlZmKjiKTc7vX9I
	qXE1HygULXdh/m5gRv5Dw9nQ3sVul+26sNLD26g1VNE98rejwrEjWrrdLsT3p3VusChWUPZosyD
	U43q+LQ9HjYOOHm9QTcr0QaU5EtLsv5l7uOoBB/6qWPu2KuYdc2HIO72F+Qic0IblCvdz6ov3G7
	NdLAxna/2kQeqI+gbVAS+FjGdcuEHniei4OgQvrBJIlImJOuKOhZglnEsXbZI7GXCwmCI3tbTkW
	24mGy8P7nIfm771NpZSItc6nH0E2XgaHTnEc/qZgwbL2Sw==
X-Google-Smtp-Source: AGHT+IF7XbE04CqOvEX8W4K9LRBGFZNizyeeIKygHO9HjdO9iwyVbPTpDERhNgQ3kKf0mPYmzxYulg==
X-Received: by 2002:a05:600c:3544:b0:43b:ce36:756e with SMTP id 5b1f17b1804b1-43c601ccce3mr37788095e9.12.1741364151285;
        Fri, 07 Mar 2025 08:15:51 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8daadbsm55496245e9.21.2025.03.07.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:15:50 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v8 0/6] riscv: add SBI SSE extension tests
Date: Fri,  7 Mar 2025 17:15:42 +0100
Message-ID: <20250307161549.1873770-1-cleger@rivosinc.com>
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
 lib/riscv/asm/sbi.h     |  144 ++++-
 lib/riscv/sbi-sse-asm.S |  103 ++++
 lib/riscv/asm-offsets.c |    9 +
 lib/riscv/sbi.c         |   76 +++
 riscv/sbi-tests.h       |    1 +
 riscv/sbi-asm.S         |    6 +-
 riscv/sbi-asm-offsets.c |   11 +
 riscv/sbi-sse.c         | 1215 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    2 +
 riscv/.gitignore        |    1 +
 13 files changed, 1584 insertions(+), 12 deletions(-)
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.2


