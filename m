Return-Path: <kvm+bounces-32359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5422C9D601C
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D89CEB21E95
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 14:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEFF3A1B5;
	Fri, 22 Nov 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kzsE/ZZz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822BD79C0
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732284318; cv=none; b=B7zXFwCr6vTplrvLgP2oQMG7ZVWMQ3QLBlp9mumAW9RV+4LIebRTAzjU3d11c2GUo+XL0fW4zuxIvuoAj/I71WH9jfxa7xyavO1DndGkYGXtgqlObIVYjlIt0feE+O6nn2zaVvQU0nU0pMYQF13w4Yqy5B2n2e9Zd+u06CuDhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732284318; c=relaxed/simple;
	bh=UN9w0JopxL6iSFzpRnrC1QhLopdaRXDZ2L/h3QiJ/rE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n5qyb8j3ZT8mfC3xxh6LAZds1gZaFrT0cfxlflk826be9FfRsGFfWuKcaDwanNUZiezsXAc3R2z5ysoD504dypkA+yMt9RDS6wxpubFlbKcJ5C3QmSo1BmaAIYzAGcGVVFGJYMkL3ofsIYxs6QlzESn3MKOCN3lTFB0ceVioPMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kzsE/ZZz; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e3d523a24dso1772465a91.0
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 06:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732284315; x=1732889115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hLWb7ByulfiRahXB1aXlkyg1dQOHtWJr0ZtObgVqOas=;
        b=kzsE/ZZzRQCaoCkHxPUx9lvbXcNO/ybV6hVyJGfV3PliCahv8xVaQ7XhEFTiMLu4Xt
         if7c/K8O95fXHJIqwVjmlm26i+DIywzWotFcjouRoI6C6RZEHDHeQu4IOFMdN/gw/m3J
         vXcqYqvPhjU8oxOTUB+xG0IlXbhm6WEyMb5rTawqljyWbw+jwh7BBDjfVIty2o5zn1w9
         rObaSC+d7WheQfTpDVMhR4c/VSxshFOTeuK01cjXha9AsPmogXvuvJQUISzTcHWyowtN
         Ve6KlK3/fD2uupNXCrIpOmEFA2njlrr81hghgysLyDjTM2egJmwsSPNPhte62DvEh5HX
         Y7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732284315; x=1732889115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hLWb7ByulfiRahXB1aXlkyg1dQOHtWJr0ZtObgVqOas=;
        b=vJFK7zdTxYo/lXxsCD3aAjx0A5EhCUgQJvBy9CHbV0P06CMJGat9thnSx4F5Eqa5Ih
         RNxO4tS+h/wBP052vcvywLqzQ93FVRRknLZyaJaKC8mtMvKmzJUgzh42VJrP3URW2p1d
         skqcYiyAUwdmsjFPYi/lWUFN5lX5WmBviEwv6vFywxmtOa/A16t+xtpSU0YR9ebZosP5
         JApbOT82N+3QtX9tTbuw3MfNz51K+zKczhO22lngX/0joW8FkQ8v5uh4ScxzczRv9qSZ
         Y5bHfUmyIExHea5bRqLG4VYMJVP4d3KIYeBo4iwG5xszeYxrjXKRXu1nxCMS4h/KdJbG
         A6eQ==
X-Gm-Message-State: AOJu0YwZLeqdlDPQ7YedtAYQlEEMZOe3mEOW1MCUSWg5+ajgZb55YD8i
	ZqoKpmQ2etp6hGLhY6MNQ3yxvRb9Q06ugNQddwDbNQ4BN1jO4do7fQCoazsj6VErnUYf28tCuhr
	Z
X-Gm-Gg: ASbGncvtoTZuWn/tNzcd7XA84FYJTeFGuB43/pXlVcikvB6LoatX4g2zDdA9c2e6iVZ
	bWaIhhSnPkvgvpFRXluyrlqcxWpMG4j5QEIMmHvR8bxWBoJVDqVwyRkeD8MtX9bKJHSWDgbmgBc
	avT9OJu2JktYtoh89oDNAEU43BYDrM3WJl/cW/twLkVIlywW4b9pO2sP1dwOujLEj7IFg6egyKM
	+zlhtRfXVOAHkOG8wEaJGZPhcRQ6ZyEDqFllpJd9GqJgfFmAqk=
X-Google-Smtp-Source: AGHT+IEMfJUro0bhY2N6iFsjT3tWHVsEHebZlWAOOByL9Rn0Ne1v9sLEUrKeKDWpmXEcLMIn3tKX4g==
X-Received: by 2002:a17:90b:380c:b0:2ea:4c5f:923e with SMTP id 98e67ed59e1d1-2eb0e12578dmr3074634a91.5.1732284314559;
        Fri, 22 Nov 2024 06:05:14 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead04d2b9dsm5153370a91.33.2024.11.22.06.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 06:05:13 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v2 0/3] riscv: add SBI SSE extension tests
Date: Fri, 22 Nov 2024 15:04:54 +0100
Message-ID: <20241122140459.566306-1-cleger@rivosinc.com>
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
needed infrastructure for SSE support.

---

V2:
 - Rebased on origin/master and integrate it into sbi.c tests

Clément Léger (3):
  riscv: lib: Add SBI SSE extension definitions
  riscv: lib: Add SSE assembly entry handling
  riscv: sbi: Add SSE extension tests

 riscv/Makefile          |   2 +
 lib/riscv/asm/csr.h     |   2 +
 lib/riscv/asm/sbi.h     |  76 ++++
 lib/riscv/asm/sse.h     |  16 +
 lib/riscv/sse-entry.S   | 100 ++++
 lib/riscv/asm-offsets.c |   9 +
 riscv/sbi-tests.h       |   4 +
 riscv/sbi-sse.c         | 981 ++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |   1 +
 riscv/unittests.cfg     |   4 +
 10 files changed, 1195 insertions(+)
 create mode 100644 lib/riscv/asm/sse.h
 create mode 100644 lib/riscv/sse-entry.S
 create mode 100644 riscv/sbi-sse.c

-- 
2.45.2


