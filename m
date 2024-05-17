Return-Path: <kvm+bounces-17601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 256DA8C8759
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4ED81F230B0
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3BC54BE9;
	Fri, 17 May 2024 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="oTLtafjd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B414B44C7A
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715953215; cv=none; b=e3FqF6RqaDW4a3Tk9e8UD7S0E6Jw+eAi8pndbL0DzKrfKZTu9ZavNfW/lZ190BNa11b8frGgVhSwrrK+RL9S7viN3D6A9D05iRPKRDMYxi6CPhCcPE4qzuHXfaydr+ksNJfhrm0oqlRhjG5HXMfHRHZ7bsmihHGP5Sa318mkDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715953215; c=relaxed/simple;
	bh=bCyy99oAYO+Sl58vnF2Pgi4oU4JvCkZcehN0R65MDjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=akTkj4tSPx0A/6zzFQs/Zs2to/wFiZoMK5+nztT7+WgrWEU5Z73D9rv2JLuB3FyRDGpQQMsUcDfFfUuDSBlmfHPO36TxiVchjmvjx+MHKbU5VNGGChdYwcK3YhXDE5a4CKG+H/v/ofhe1DOR9FkYgxUqLVZriukQRLiithkar30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=oTLtafjd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4202a1ead57so209885e9.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 06:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715953211; x=1716558011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pifZOlLkmKpu+783OFiBmmOvZANnETDfMlJESQQLsro=;
        b=oTLtafjdXEwbTh/Bnmlk40N6DFJraYmzx38NDgEcN2Ne5N0G3jyw02W1P5pqII2K6z
         EsIfonR33eVdXSNn8HiTj29dHnjA9QsAfGWSqzu0AKceyQmIVJdx8fh8wbnOvcmkBJwC
         uM+4elctx45FgRI58Hus6dDlzD6HnxwVl9BhNgegQTX+hPIom9U3B4KvEZb9InBuMZe9
         9GUdkZAEHrVucIytNTQJEX2qaa8idAmYPaJRTYHpDtn//0wUej+ZJE0mFYqMSQI75WAD
         fuBzj7Q43m7+og7El/4h0+gPePpfRniRXH1609OnIyKmF2n/8gjTpvQFb5JpeH8f1+Gp
         KEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715953211; x=1716558011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pifZOlLkmKpu+783OFiBmmOvZANnETDfMlJESQQLsro=;
        b=ZOwCzRcuipILbW7/4BjRvrg8bGoxJgdSBzqKw34Pztmqo0n0sO2LdCfm4Ul+ef5J8F
         kbxbhkadoO7pb/LJ5qsq88FUwIZA96KvRUzZqpRdLf4bDVumbB5cACUn1qrIagIQw2yJ
         eONprf4r94PkBo2j6ct2YyshWESGcBsD/cxW4u5QUPk81A/8n5bity8C+r+KR5lquKuH
         6NlcdzRLjNNOpsodmNMIShm4W7XTS6HmK5Mmh/BRykL3J4SESXNxbP+3u/tpMpKFVn3c
         3RkKEwzPTfR5o3XfN9AiVb04VGUxk3Yr7x+bZnf9s/gsHJav7GqVZhbEIOMwOK70ta91
         3xmw==
X-Gm-Message-State: AOJu0YyoO6EZIfaasNunFaiG8WHfhWiKm+s+XitE0v8Kt1GNSIms2pwK
	NHlDZVpmg6DTgcpPnn8FQc6mZkBuYh3tPPdvHXTi8IaHeMRSWc7U4RVv3aIjs5poODJapKWGLK5
	SnyQ=
X-Google-Smtp-Source: AGHT+IFZ3tHhLCFFF0l7g1hMkAN8Rh+AbZ2X2j0CokxbZwaFbtz9D+TccrNbsWJhcB+4akDij0AlTA==
X-Received: by 2002:a05:600c:511d:b0:41b:e83e:8bb with SMTP id 5b1f17b1804b1-41fead67274mr160548015e9.3.1715953210443;
        Fri, 17 May 2024 06:40:10 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4200e518984sm240669275e9.23.2024.05.17.06.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 06:40:10 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v1 0/4] riscv: add SBI SSE extension tests
Date: Fri, 17 May 2024 15:40:01 +0200
Message-ID: <20240517134007.928539-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
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

Clément Léger (4):
  riscv: move REG_L/REG_W in a dedicated asm.h file
  riscv: add SBI SSE extension definitions
  riscv: add SSE assembly entry handling
  riscv: add SBI SSE extension tests

 riscv/Makefile          |   2 +
 lib/riscv/asm/asm.h     |  19 +
 lib/riscv/asm/csr.h     |   2 +
 lib/riscv/asm/sbi.h     |  76 ++++
 lib/riscv/asm/sse.h     |  16 +
 lib/riscv/sse_entry.S   | 100 ++++
 lib/riscv/asm-offsets.c |   9 +
 riscv/cstart.S          |  14 +-
 riscv/sbi_sse.c         | 983 ++++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg     |   4 +
 10 files changed, 1212 insertions(+), 13 deletions(-)
 create mode 100644 lib/riscv/asm/asm.h
 create mode 100644 lib/riscv/asm/sse.h
 create mode 100644 lib/riscv/sse_entry.S
 create mode 100644 riscv/sbi_sse.c

-- 
2.43.0


