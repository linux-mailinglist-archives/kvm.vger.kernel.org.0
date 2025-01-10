Return-Path: <kvm+bounces-35003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C989A08AB7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 803E53A914A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D26B209691;
	Fri, 10 Jan 2025 08:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TTSLh5H6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411916DEA9
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499243; cv=none; b=Ao/KDYDwrqt8m8TZ6dB4x154x4Wq83/Mx50BSWKCkLCBQS45zsvuYlcrIo70pxTPkgnDcHVS08u8cdrkPhprC3VYcB5sGWmYW+tCz6SLcFdZej86udY9MGbBjjQMDacC5XABlXLMJ9O50NFtXY4P5eFYAvcap3GI3hI7+gdR5A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499243; c=relaxed/simple;
	bh=Li/GpzvgX0clmsLb8qEAToA9iMtROY9ZL/3aCIe8UqI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y089cTIOsmCARlqjqaNNpAsjcjVEgdELyfpitjBY4jVtTrajDaasic8jN70wQNHRva5zDtUPr/JK1VX4W1bnB/R9hWXb6cRzrCUp3bm4VR1NKoL4FGAqNcrhliALNBDBoYmgNzBlAUIMHQJSRZk4BMC211ipWzspxc6AAH4Fg+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TTSLh5H6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3862b40a6e0so989489f8f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736499239; x=1737104039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/vmys0EVuwB0xKk+EZlTCl6zKgMXosmjoUNe63DhnQ=;
        b=TTSLh5H6mC5HP3gyMdtUCxuMHMxk1cqd17y2PAvqp6MQ0gl8HjXmlHFhGnQ0Q2aYVP
         1owVcpsC2+xpgLm+9ic/d9WVjRcT5+fIGsNCCiCumZcggOEzmL/aBxJD/zdoiH9mKuzx
         JoxVSGavpCaGkb2J903PNvpXIwaIIOkRbTVBTHP7neAPA6lHWrjGIKL/Ca5wL0K7+5j7
         ExxgdEO+YomapXZJ+yJ9jfglqDaXLQrJJfJwaGtG1s4jvXjj1GZbUpYpaTrRK4WTkufE
         whaNDQ1t18+Frgl59r6i0+ICOZWFD3qEr6lbIvaDqZ/5px7b4cutcOSkraak4TuaMTk6
         5PrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499239; x=1737104039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/vmys0EVuwB0xKk+EZlTCl6zKgMXosmjoUNe63DhnQ=;
        b=hIgItVKHraPU4NPGGTqJaz/CntSBmMDNH+/+xdUUMu0TRqMg4oroH5Zs0KXS0EV9wW
         JRm/pQn0IWWdRTLiEtUbMIhKDY4Ji2qfoQ4mVaNhCWHt9mTc4i+XGBo27MUcrVTpxpXl
         sMNRYQalQ7XonFhGZv0xMtEV5I2xoW6Irv+UW3nhWJbRnUoJtYeBJV7K0SkzO0MfIGyb
         qvgnro7xu9FKtjnJmytRmYSitYkAFZWdPBO4m5O0rBFo8e1qaVEVz47N9In/RzlxZE9y
         pKuaf8rHXFvep/TD2wr5kkBDGnMNEXqRlKeZIoWCcK1gocQzXb7uIXWH1hLJlXu2e2LC
         ag6A==
X-Gm-Message-State: AOJu0YxMQpvT1Sdbxuqw1aRKtPH9TY5yQtg9LXUbkySClihyag+KpRm9
	Ei3s6hCpEefkWniTxZ1PbDT+4GzB3jqkfAabQATixyOFias4Tf6jIegVvSpWrzUR1sBsRb1iqno
	y
X-Gm-Gg: ASbGncuMs6AP+V0op94zNjJTxFGeSKxq4raTbfR2hKXUFkNr8kQR+D5CcV+u2Fn46pe
	U257YuwqOXnIZbECUrXb38LrUiaWDENRIo4vygTubiFuxH4AxtPhzwU+vR1wpmq/Xj0pBGIIthq
	WiajfAGgJyMJT2YTI2F+Kzsb7FmR4UfIOM5G4vJ4uqvKe68cDgYxtnAVcVkbTy7TzrsNupt4DRO
	boJV6eZ9Xs1M1/ML3xppOjtPEgHfLVgwhpJ7n1IUWORYHOlH2TMRu908A==
X-Google-Smtp-Source: AGHT+IHUDt07t5Oqoev2Rxl3n1F1zN41WKhamAhtCNOOIbQ11tERVZqurci5ma4ZojCPiSYV/OEFLg==
X-Received: by 2002:a5d:47a6:0:b0:385:f195:2a8 with SMTP id ffacd0b85a97d-38a87312734mr9091920f8f.30.1736499239125;
        Fri, 10 Jan 2025 00:53:59 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1ce5sm4009283f8f.94.2025.01.10.00.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:53:58 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v5 0/5] riscv: add SBI SSE extension tests
Date: Fri, 10 Jan 2025 09:51:13 +0100
Message-ID: <20250110085120.2643853-1-cleger@rivosinc.com>
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

 scripts/asm-offsets.mak |   22 +-
 riscv/Makefile          |   10 +-
 lib/riscv/asm/csr.h     |    2 +
 lib/riscv/asm/sbi.h     |   89 ++++
 riscv/sbi-tests.h       |   12 +
 riscv/sbi-asm.S         |   96 +++-
 riscv/sbi-asm-offsets.c |   19 +
 riscv/sbi-sse.c         | 1060 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    3 +
 riscv/.gitignore        |    1 +
 10 files changed, 1301 insertions(+), 13 deletions(-)
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.1


