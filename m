Return-Path: <kvm+bounces-35031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE58A08EEC
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B357188D19B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EA920ADC9;
	Fri, 10 Jan 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WwCoc8GU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742B1E32C5
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507584; cv=none; b=WII/hTaFFwxbT4Mjo221kHX09XGFKoNgn4rLoCi/em+BSTbvqGZC+c1upX5D5V+H8pnUE8YBrdtUvkStdQNGQWqh6pfMEozUkyaN3UhUSg0qzGdkKuUMxq9MbdjrPekn+w4/CrVRIZWMOM9x8NdxchJiq9qHJNVgiT9LNwfDCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507584; c=relaxed/simple;
	bh=kcHd074yr4RuAP/SgM1YMZNeMlBLf2mbqT1677uVoZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bww5H084BHbYeQIPIqsMA3vlO++om4S5BYcBHm3Xn7r8NkLMI4ykpTix96ma7vJEZQUyRzbYFCGwyLgVHpPz+i8Y/HWvBqMFcjiYCq77BxiGbxFWe+Op2xjzVaYk4w+6qX29n4hIeyjKBEiBEllco4rwKaj6uMtOtQ0S09SYdt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WwCoc8GU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so14600295e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736507580; x=1737112380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cvtjhmhnFALzHo5ylM2nYcQXcJNhmIYsbqZ49LuOAJM=;
        b=WwCoc8GUDWFj5eyBILTd4DIgsTWCbGs4HfY0xmOJOh4eaZQ+VvTaWTHduhMNob9fAC
         pBDWNfkoeNgY1WrZa4w8BDrx0GgBTB8FSanW3WmGIN7/G70W7HFEWl0ihftA7pz2WmSO
         mKOluC5M208Otq9buw13KAuijHJNyPAsPHpS4qJ31x+sHAhRuBmh/PbbKvqd99tGMeyL
         crAfDSvE3K7i99Hqar/gLMyWeOyCSqxKskqLMALCn6uKnYS8b3rKtsLDJyCQv59HB8zB
         iuk5ksK0Ik7H5/ljS1xA1En5FNIvk8ze9Tt5bbh9vjk/n2d3K+6lmORHlX3nMAcAo/LO
         yHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507580; x=1737112380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cvtjhmhnFALzHo5ylM2nYcQXcJNhmIYsbqZ49LuOAJM=;
        b=TkoXfGIIr0ycLW1fzmJpqX/zAqC+fCBuBRp6R/04aftrYRHCILRjnqcEtPLmeARwfp
         fblMysQX9kt6+NfLJpyxx8gkVHWS1iBIo6pDlOCQlWQjYZU+2XzfvtzDdUK8ognyhRnq
         Rnvy/Of+0/GTcfxUlcwmbnqby30F0Bm3fOcB4CDMStpF7VqOvpybtA64JPqxCl/AJMkh
         iGMJbmwQlk8MwLlFX+evmu47Nq0dm8M47OrciqayvIAxYtsOqXKaWLNwY+6z8GdjtyCn
         hqHrF6CpTAmMBSbl/FuifsveTtO9TkImcJ3xB9qk6Axc4KLGDW5lOfJPgBymnsBIu5/a
         jupQ==
X-Gm-Message-State: AOJu0YzbRrydYFfKyjjVdPYn96y+chFlgoVacJxdtWBNKybdQIiv7SgX
	Gkc5AH7iTML5FQFq/Zfa/1sQKhsUPFlfB+LLE2190r2iNYjM8Kko296zssmoKneAagWCPcMpO65
	O
X-Gm-Gg: ASbGncs2xomhi0ZbopR/eoKu4QjpHc1YZBipbpx5+xzDCUs3glcWfivprEtdWELXdX3
	+FFWh3aHwWoTYk2nJBmKTCMpY5+tQ8bX75f7zw0YoazTf8e26C4v4z6C0vbEv8K9uvErw5XD0mQ
	ndGoR6CmEYM3naahDCZkcUAb3dGqwWmObwwsheSnW/XNlogbazGYQxX3V4nleFnHOkRtRU5qXlH
	pNQQj3Sifd3xOwKo+h/9ccg1RBglb03BeO65Kp8QN3K0KrMcEh1TxT/Ww==
X-Google-Smtp-Source: AGHT+IFxrA4TF3MNStiKx6CJDnq7rdlWFFux+wCJ2jGt4Y3FYGe8jIz1FVZj/htS+4CyB+m8FRfm2Q==
X-Received: by 2002:a05:600c:19ce:b0:42c:bb96:340e with SMTP id 5b1f17b1804b1-436e26f857fmr101269725e9.31.1736507580056;
        Fri, 10 Jan 2025 03:13:00 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c1d6sm4344459f8f.50.2025.01.10.03.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:12:59 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v6 0/5] riscv: add SBI SSE extension tests
Date: Fri, 10 Jan 2025 12:12:39 +0100
Message-ID: <20250110111247.2963146-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds an individual test for SBI SSE extension as well as
needed infrastructure for SSE support. It also adds test specific
asm-offsets generation to use custom OFFSET and DEFINE from the test
directory.

---

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

Clément Léger (5):
  kbuild: allow multiple asm-offsets file to be generated
  riscv: use asm-offsets to generate SBI_EXT_HSM values
  riscv: Add "-deps" handling for tests
  riscv: lib: Add SBI SSE extension definitions
  riscv: sbi: Add SSE extension tests

 scripts/asm-offsets.mak |  22 +-
 riscv/Makefile          |  12 +-
 lib/riscv/asm/csr.h     |   2 +
 lib/riscv/asm/sbi.h     |  89 ++++
 riscv/sse.h             |  41 ++
 riscv/sbi-asm.S         |   6 +-
 riscv/sse-asm.S         | 104 +++++
 riscv/sbi-asm-offsets.c |  20 +
 riscv/sbi-sse.c         | 936 ++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |   3 +
 riscv/sse.c             | 132 ++++++
 riscv/.gitignore        |   1 +
 12 files changed, 1355 insertions(+), 13 deletions(-)
 create mode 100644 riscv/sse.h
 create mode 100644 riscv/sse-asm.S
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.1


