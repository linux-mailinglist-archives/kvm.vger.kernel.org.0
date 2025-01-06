Return-Path: <kvm+bounces-34604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DB1A02C10
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:50:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C90DD3A76A3
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E8E1494C3;
	Mon,  6 Jan 2025 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="u6Tt7m48"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502A1514F6
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178548; cv=none; b=htDrQxkhPjLDAYEQoVzJVV4T2PU03QrV7JwhqYiYrdZM8RIpN5xuMU930MLen6rPlf41MMrQ4nmqkhxA/0nKRj7e1w4M742iJQt4SjwTSW8hvPmvRLCqkX5ZXgd5YBXbObcA6LyEZ8Rd3LN1ueZ+Yn2UQiqxbzMI0WPFJ0jv4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178548; c=relaxed/simple;
	bh=JZ9Ln44+aPQMGHaeH9RG9sPLSZu5/mvTEh5KN9zWmUU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VJYG3QFT/XVtTVmueCAhJk9yB/tLQsDNWW+sHh7LxvPx7xRx80v6bbk7B6JbY5+gNb9H3UudJXucYOIw3VRvyAoUH0NuL3xCRMmkGCWWkGOCT4deFb34EjCfF+g0vammPMc7JT0qjHNhjiRWg68Zre1fLasNGt55khCIMiKTnS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=u6Tt7m48; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216281bc30fso241374665ad.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178546; x=1736783346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3GGpStBvhQ5K8XseHJPb5by+BUYzACgXmQyCH18qmBg=;
        b=u6Tt7m48R9oI92Wn4jnlGssVcZBWZqgW+LI3hCo15nzZU8OAHLtZrD3gjJ61o2IP5s
         RABwfykUdyW4TnaJW0KXoo0QLpsPl7jLnHGr2x6JMhr9DZSzTTDvL68LvbifTWM+EiKn
         KghVe+uHfvP2X1wkBJwYsFOOlvgp30OdPOHeBwyn9zjLaKkBO/Cc/9fJhSoDdxDvEPAn
         EiqxBW1iv/TVaawNcAX1ODUxMG2ohvlENsEW2/PhvLGmZCCJXoeYow9sNimdxBMYwhYb
         qUoPhTIqnZeeb0Y6YZSOv5Ky1g94c82hhWrJl6EcNaUlLo/KHiirwQ6tzTUWPqGiZ/Nm
         ZwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178546; x=1736783346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GGpStBvhQ5K8XseHJPb5by+BUYzACgXmQyCH18qmBg=;
        b=Eq7tsHVzhKbcd39ICFVr0AJebuIv+H1gA5irvV1AzJ1SweRMV6ihDDpn6dV/QO2Fn3
         /tsnSF2T9c+5q2jpvNf0RbwfPSCDTAXdCJRppvanTuTKaqyjKpDcLArsz4z3Qub6lk7A
         G/lvncf3P8eaqEo/K+cELNjJiIdYxb4bWOBt+u4y+76PYt4MQ7V64ErebYVROua8sjjo
         /oukwAdz7iYfutn8D4/sFGOS5kTM9JPxJRJs/SeWXsTiekHHnu97FniRr4g38Vw3xSG3
         UG41/M3govNdtY+5xnlxJf/f9jV3PgIgzswgoSmYrnCep3szrYDQshBUCkkI4PefiiXn
         FIwA==
X-Forwarded-Encrypted: i=1; AJvYcCUdDiJJLjHVSBQjhszOkM5WoHRONRkVpqiR/wY6CMS4A/cYv+d8wH5GbfJ1Xi0O/VtYaCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOuVfmPAXTa4clSMTAfZStx7DNJzLxY206+mI++YOrCQ3qV4+
	FdHM4aTlhGzTxiCKLWdecyWx7WOMoj19liVvrS3pEy+1iAp22Wdt+YLPpNTD1rY=
X-Gm-Gg: ASbGncuxlfBfWke37xbts9KxC38EpJMXPk7ws398XqmKIL/0N9fpr9CW1tmIta9RhH/
	M4z7maDKArCefS8aB6N+8jm2SN5JM/I7/5SCkZP4bqJMy3raNz+XA0nejWrJ1heAWaNQyZ3zhuA
	TjLgu9Ub3XJrGcNATAtcszF1qCMPHWcFgetx8I3u/20LvPAsA0KvWIZfwA2jBxmtP2K+uLyzfSZ
	JKGY/9BuAPriszm2MdM927UD+szkAMgSYwlHx4BeQDL0Vz1L5T7x5WwYg==
X-Google-Smtp-Source: AGHT+IEPJYkB+GjJZ58TJzg7jlP2DmeS3NY6LvjoJXuDWaiGaC9bRpxjyB6+IigEUT+Axr/d/VfYnA==
X-Received: by 2002:a17:90b:2752:b0:2ee:fdf3:38ea with SMTP id 98e67ed59e1d1-2f452ec714amr77626971a91.23.1736178545785;
        Mon, 06 Jan 2025 07:49:05 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:05 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 0/6] riscv: add SBI FWFT misaligned exception delegation support
Date: Mon,  6 Jan 2025 16:48:37 +0100
Message-ID: <20250106154847.1100344-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SBI Firmware Feature extension allows the S-mode to request some
specific features (either hardware or software) to be enabled. This
series uses this extension to request misaligned access exception
delegation to S-mode in order to let the kernel handle it. It also adds
support for the KVM FWFT SBI extension based on the misaligned access
handling infrastructure.

FWFT SBI extension is part of the SBI V3.0 specifications [1]. It can be
tested using the qemu provided at [2] which contains the series from
[3]. kvm-unit-tests [4] can be used inside kvm to tests the correct
delegation of misaligned exceptions. Upstream OpenSBI can be used.

The test can be run using a small utility[5] as well as using kvm-tools:

$ qemu-system-riscv64 \
	-cpu rv64,trap-misaligned-access=true,v=true \
	-M virt \
	-m 1024M \
	-bios fw_dynamic.bin \
	-kernel Image
 ...

 # ./unaligned
 Buf base address: 0x5555756ff0f0
 Testing emulated misaligned accesses, size 2, offset 1
 Testing non-emulated misaligned accesses, size 2, offset 1
 Testing emulated misaligned accesses, size 4, offset 1
 Testing non-emulated misaligned accesses, size 4, offset 1
 Testing emulated misaligned accesses, size 4, offset 2
 Testing non-emulated misaligned accesses, size 4, offset 2
 Testing emulated misaligned accesses, size 4, offset 3
 Testing non-emulated misaligned accesses, size 4, offset 3
 Testing emulated misaligned accesses, size 8, offset 1
 Testing non-emulated misaligned accesses, size 8, offset 1
 Testing emulated misaligned accesses, size 8, offset 2
 Testing non-emulated misaligned accesses, size 8, offset 2
 Testing emulated misaligned accesses, size 8, offset 3
 Testing non-emulated misaligned accesses, size 8, offset 3
 Testing emulated misaligned accesses, size 8, offset 4
 Testing non-emulated misaligned accesses, size 8, offset 4
 Testing emulated misaligned accesses, size 8, offset 5
 Testing non-emulated misaligned accesses, size 8, offset 5
 Testing emulated misaligned accesses, size 8, offset 6
 Testing non-emulated misaligned accesses, size 8, offset 6
 Testing emulated misaligned accesses, size 8, offset 7
 Testing non-emulated misaligned accesses, size 8, offset 7

 # lkvm run -k sbi.flat -m 128
  Info: # lkvm run -k sbi.flat -m 128 -c 1 --name guest-97
  Info: Removed ghost socket file "/root/.lkvm//guest-97.sock".

 ##########################################################################
 #    kvm-unit-tests
 ##########################################################################

 ... [test messages elided]
 PASS: sbi: fwft: FWFT extension probing no error
 PASS: sbi: fwft: get/set reserved feature 0x6 error == SBI_ERR_DENIED
 PASS: sbi: fwft: get/set reserved feature 0x3fffffff error == SBI_ERR_DENIED
 PASS: sbi: fwft: get/set reserved feature 0x80000000 error == SBI_ERR_DENIED
 PASS: sbi: fwft: get/set reserved feature 0xbfffffff error == SBI_ERR_DENIED
 PASS: sbi: fwft: misaligned_deleg: Get misaligned deleg feature no error
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature invalid value error
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature invalid value error
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value no error
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value 0
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value no error
 PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value 1
 PASS: sbi: fwft: misaligned_deleg: Verify misaligned load exception trap in supervisor
 SUMMARY: 50 tests, 2 unexpected failures, 12 skipped

This series is available at [6].

Link: https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/vv3.0-rc2/riscv-sbi.pdf [1]
Link: https://github.com/rivosinc/qemu/tree/dev/cleger/misaligned [2]
Link: https://lore.kernel.org/all/20241211211933.198792-3-fkonrad@amd.com/T/ [3]
Link: https://github.com/clementleger/kvm-unit-tests/tree/dev/cleger/fwft_v1 [4]
Link: https://github.com/clementleger/unaligned_test [5]
Link: https://github.com/rivosinc/linux/tree/dev/cleger/fwft_v1 [6]
---

Clément Léger (6):
  riscv: add Firmware Feature (FWFT) SBI extensions definitions
  riscv: request misaligned exception delegation from SBI
  RISC-V: KVM: add SBI extension init()/deinit() functions
  RISC-V: KVM: add support for FWFT SBI extension
  riscv: export unaligned_ctl_available() as a GPL symbol
  RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG

 arch/riscv/include/asm/cpufeature.h        |   1 +
 arch/riscv/include/asm/kvm_host.h          |   4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h      |  10 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  37 ++++
 arch/riscv/include/asm/sbi.h               |  28 +++
 arch/riscv/include/uapi/asm/kvm.h          |   1 +
 arch/riscv/kernel/traps_misaligned.c       |  61 ++++++
 arch/riscv/kernel/unaligned_access_speed.c |   2 +
 arch/riscv/kvm/Makefile                    |   1 +
 arch/riscv/kvm/vcpu.c                      |   5 +
 arch/riscv/kvm/vcpu_sbi.c                  |  35 +++-
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 215 +++++++++++++++++++++
 12 files changed, 399 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

-- 
2.47.1


