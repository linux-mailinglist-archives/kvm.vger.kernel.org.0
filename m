Return-Path: <kvm+bounces-32463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4899D8A2F
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51AB328264A
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8813F1B4144;
	Mon, 25 Nov 2024 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RtiV/79v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911964A1A
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551742; cv=none; b=Bd2b+4L2EaFRjOrkjonZ5oT4vxznWirBBKwVK4aqfCYRuGBZLuZT0uAMDCHV4HzSrrazyvEfuP6TmY6sIF4/1EI9QUBgd3hE1/J4F236y9Ek6gcrGTqnKhFmlUg7N0Kq4x58B3Rk09k3tEEPDf6D7lMwt2rgAP69eTUhe7YZi0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551742; c=relaxed/simple;
	bh=o6msSLuwmAM0q8oesPc2k5/iC0yDa4mNhKDRgz0JyAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j/s0QOAei1c+bjnGp3OLF7wv56Kt04luamnh5MuU8cu0QD2UkEzdRrqpeK+1j9xfSX53SY9nzIf8f5+Z69NyBEMYK/eZc+rUp5JZ4jo+tu8+NyAd2xYkuZx6j5RRMDyaSPon59ITGbzLU5EvlhDiLMJD68hkVW+dLuZfDbavAxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RtiV/79v; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7fbc29b3145so2859171a12.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551739; x=1733156539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=prqh5rCC8lTP0Cap8txhPpE2zdxqBYsT6wxf5PGH7iI=;
        b=RtiV/79vuTuJc2Gnj445hvbpwCzOneMu/mAuKoybXDT5KCmKormCXkEPGi4Uvb7094
         Dn3CrVXDRuA6RTa4K7/SNUo22/zVrC40t0JqGmqMgHLSKI2/HjuEycmeNhB75+XcFBYn
         fKdimrar3DgPR4wfXvIf+K7NeOmuCLg6Om/n0a+1mAGROPdn2FMLi3GhMOoXLpk409cC
         AKmldrBGdl76c+GmL0f34nx940r8YzE3TRG4dIB4HyURzfMVsMoVB5AcSU5EypICqbsU
         UKH82i+WNug/16x4NGt4WgsJoC7SYm0gCw7k9bZ53sdiNT/tgufvKPY/GjgnTtbQgSRJ
         ZihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551739; x=1733156539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prqh5rCC8lTP0Cap8txhPpE2zdxqBYsT6wxf5PGH7iI=;
        b=Gh/Jit4X7KSt540fd197C0FS3fampEuS5CMxEQPPuGeBQ2lvfM3qXs3RIJbgreQ9XI
         BJD3IMN/hceRnMdza59pQpF+Mj4crNNum2umdN3EyZX57aRTkhpC5QMBFmvm7ym5CXBL
         iRDTYXzREpF1/y2TsCpghmvD0KS8EdcqnISsV48+hPzNQj8N6Cwf0pZJ9FvpEZ2t4p71
         Afa1U+VBRQ9A9BNZOMAPnb5RbGwI1OCfPVBx4MFRSuFIWnDgp1Ckf6xpPrrZ2z4LeTD8
         oxMeyUvePA+xDEVMIU0bbge5ucXLr0UoWACShBAiS0LUSt2R9GVVInPP6hyuMXhkBSQR
         Vwfg==
X-Gm-Message-State: AOJu0YxQs7n6fz0gX1GJ/EYlHccPyy6R/PHDn+XEV4dUbFUezI4o9UVp
	mt7Sb2BD0QnrYtsPrThqNeSqozuDpqO/uV4t7PXjZfabWJsc0KQiKedDphfDDkHVZ+PkQn9prQb
	q
X-Gm-Gg: ASbGnctOd/dkydA5k6lMB/W4rELtsup7O+WOnpOHzwzD/YbzLvsAV6ih74xsJjFO0fK
	UKGMVV4McTyj/oH+UY+2x2JTI57nWPo88bB3nLXp5+gyD+mFJASrElCEUnii2cR55lkE8WSkpVp
	wJ4n8eS5aATukNCkvd3K6IBnT+fb9Iby3XrKVDhklMQa5xaA/Ip2qT2zlkYXs7R4jDygZoa5ubf
	FQEgz/CVaD0K7qFcAjcTW1rMo4S3gQz7KgRWOcy9pn28C2qvcQ=
X-Google-Smtp-Source: AGHT+IFm/WQA1EqhVdbJC6hWa0i0MwdQ1gCNZe1X4gRScYoy/cBPHUUvJabTwUHKzO/mpa728tWFGA==
X-Received: by 2002:a05:6a21:788f:b0:1d1:88bf:dff6 with SMTP id adf61e73a8af0-1dfa1a4ccf7mr25332825637.15.1732551739437;
        Mon, 25 Nov 2024 08:22:19 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:18 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v4 0/5] riscv: add SBI SSE extension tests
Date: Mon, 25 Nov 2024 17:21:49 +0100
Message-ID: <20241125162200.1630845-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
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

 scripts/asm-offsets.mak  |   22 +-
 riscv/Makefile           |   10 +-
 lib/riscv/asm/csr.h      |    2 +
 lib/riscv/asm/sbi.h      |   83 +++
 riscv/sbi-tests.h        |   12 +
 riscv/sbi-asm.S          |   96 +++-
 riscv/asm-offsets-test.c |   19 +
 riscv/sbi-sse.c          | 1043 ++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c              |    3 +
 riscv/.gitignore         |    1 +
 10 files changed, 1278 insertions(+), 13 deletions(-)
 create mode 100644 riscv/asm-offsets-test.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.45.2


