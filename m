Return-Path: <kvm+bounces-26945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6866497981B
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 20:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8051F214FF
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 18:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B031C9DF2;
	Sun, 15 Sep 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcGpL6uP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE83017C77
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726425308; cv=none; b=nOC6zsHh2R3Vcj/HpT9xZyjFqzKshpcyjiqTsxXmMzgSXG8sEF13UQxHC3l1T/SDBnUThmCQ+SWqbQqLgChYGmgDKj5C1z3xWYwdk57h/QdqDaG50Yo6dSXR0YTcgF7E7bZnuO5kOMoWrCQAhvj7df7MEZO/ck2ux1odu2qcrsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726425308; c=relaxed/simple;
	bh=vM7rriBO0htzBz6LwMnUrG3bMjvqJCQIbLjevFiFogU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MveQuXkD+YI2lSb35zfOSKD1gTG8KdCZ5ZG8NDsPOMvwVqhuPiOvgZ1E/QvM1ntSnZRMjc/zne1fQvVGsY+DqUL5Jh/nldW0V7p3OcHcqWTSGZTAmDpeEA4SN0HCwRneSrM4Ky+5ceEK0HZzZQG3qDRT69tiUfKSwjt5li+sAnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcGpL6uP; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718e9c8bd83so3385741b3a.1
        for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726425305; x=1727030105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XHzWc27VniHN5wFKK0MX3aMBQziVDBssf+TC0rfD6z8=;
        b=YcGpL6uPDjFUdCS0HS2TSp/OIHFzfV0/vVKs3NlKYP7bSwgMdKmQqxzIlodBFrHsGp
         khJ8BIf3ybfgnUZk2zInVnp6N6XeR66dvaM+RZdIyJfCiFt9ZEJll/+0NTnhWfNP7alE
         JIFu55HljZOsh/82HCUCZ2oaYUQzImoLxvFiJUoHN9NUB4gNxA/xe1ORCJ2xk3hew7nO
         21yyyTi/3F7mERQhpW59A1nmG7LtbpGqwdXLcR2gH6CBsKT9SuLaogDgXxvSF/JespEh
         o8rRrRugPHoMqrX7CzxVkZtxT6Su/z0xNNJL1UQNXklYaov6E0webV7XEJFyF1rGVsFm
         3fZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726425305; x=1727030105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XHzWc27VniHN5wFKK0MX3aMBQziVDBssf+TC0rfD6z8=;
        b=AjFEMvzTuPSRoac+ozDpGZTgdSgzCAhNK5TXOTuSZlirKR7LI14VtRZGTrP0ok9Jz7
         3DkimfJEfQwcllJfA9kOZz5FfpygFOFRcM+S0cNU1W3+9oAwXosfT6KpqfxwzDqRXghg
         gnVD3cBpzK6Oq0H0QVlQ9XWhdZHHw40bDO0HjRUEoUUmRBo4THpCdJ81ENIw/aPzvVxf
         T3d5Fyv+vkPejnWoKbN2NrwwG0BZOn1MHWbRU4yE8me/FaOfNN35oj2rgUSQVssXAyiu
         FooM2lJZHRf0gZ+keHYhZD4bwTIR/F7flaZfvPLIhLziosK7Dm9DJvAdLCLAfQbsHv0w
         q4iA==
X-Gm-Message-State: AOJu0YxaShSf9f+saFagVOx2UAmVIN/JSce0YYrh9tCOm6d+0mMM/2dK
	9LkaULQUdo10Iq5MF7cDDrNRZ9/Oe3xtiDc/6UVkYtIeFGBIGZOh9/aPUWeC
X-Google-Smtp-Source: AGHT+IHc6v7n0fZKdJIncn+qR/bjYjJx1kFQLqTbSu/cl6lGeZ7XBGcXBmy9N9KkzXEcmuZQQED95Q==
X-Received: by 2002:a05:6a21:458b:b0:1cc:961f:33cb with SMTP id adf61e73a8af0-1cf755c6b81mr21882241637.6.1726425305277;
        Sun, 15 Sep 2024 11:35:05 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db498de2d5sm2358874a12.15.2024.09.15.11.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 11:35:04 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 0/3] riscv: sbi: Add support to test HSM extension
Date: Mon, 16 Sep 2024 02:34:56 +0800
Message-ID: <20240915183459.52476-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The first 2
patches adds some helper routines to prepare for the HSM test, while
the third patch adds the actual test for the HSM extension.

v4:
- Addressed all of Andrew's comments.
- Included the 2 patches from Andrew's branch that refactored some
  functions.
- Added timers to all of the waiting activities in the HSM tests.

v3:
- Addressed all of Andrew's comments.
- Split the report_prefix_pop patch into its own series.
- Added a new environment variable to specify the maximum number of
  CPUs supported by the SBI implementation.

v2:
- Addressed all of Andrew's comments.
- Added a new patch to add helper routines to clear multiple prefixes.
- Reworked the approach to test the HSM extension by using cpumask and
  on-cpus.

Andrew Jones (1):
  riscv: Rewrite hartid_to_cpu in assembly

James Raphael Tiovalen (2):
  riscv: sbi: Provide entry point for HSM tests
  riscv: sbi: Add tests for HSM extension

 riscv/Makefile          |   3 +-
 lib/riscv/asm-offsets.c |   5 +
 lib/riscv/setup.c       |  10 -
 riscv/sbi-tests.h       |  10 +
 riscv/sbi.h             |  10 +
 riscv/cstart.S          |  23 ++
 riscv/sbi-asm.S         |  71 +++++
 riscv/sbi.c             | 566 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 687 insertions(+), 11 deletions(-)
 create mode 100644 riscv/sbi-tests.h
 create mode 100644 riscv/sbi.h
 create mode 100644 riscv/sbi-asm.S

--
2.43.0


