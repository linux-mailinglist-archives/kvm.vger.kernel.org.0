Return-Path: <kvm+bounces-49601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08734ADAFA8
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D03174BE5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8816E2ECE94;
	Mon, 16 Jun 2025 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Q9Nc8//Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029932DBF4A
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750075167; cv=none; b=s1vYNMTDvbXtr6GkKRT28rrENspPNbVdNsEYZ6oXbYU8XdYeNPsTtdqa1wrq7e1nbqvTh7N2J+VLAAFjV+1MxzF/q6VjtwMFf530MZUU2Dgs8kHi2zcRmJuo505p8B/OfpLcX9niIxZsqmwkkQPU3y49+oIhjhVMrN1jJ6Ge/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750075167; c=relaxed/simple;
	bh=Es4LrdPJiFwtVHwfj8p97Vd0MZRKgXxYb28P/rXoDhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pm1wigsJjVJbxOjmpzyNO9Q+SlXW6j0O18VwUwIHnhgiwazCNaMipqBFCqhxB1+KHXDnyJYcf+wgYJGwZbsbVbSG45p+INM1ZCBx6v6ZW0hVnrnjRHcPdGDg+QutS6y4pV2sPI4fNwDvkvnFca9Vsb5QR/+/yj3hnyojaUi6HV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Q9Nc8//Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-451e2f0d9c2so37944895e9.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 04:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750075163; x=1750679963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v7RJ7RnL5M/B3X2GFoans1bgjidQp403I4C/vgaiXPA=;
        b=Q9Nc8//YAf+bluTk6ANkG6LKf6Xdvt5WKGHGpywKDtLXKuJ8xYqLsPKaKbZqOqMCDe
         X/ZuNLL/W1J4caP3RNe4BFiI1NHAWwbgt6b+m8xkR0kLl/ZXeQc9y2UzGmUnZkMmAaVq
         nJSscD/eGvDsaeYQ7FzwysxAcjExMWlqO57WVjFj90PEKA+Gar1wAEHtpFegTz2mnNww
         nBIrAAojsgJPE+fEnb5A62DKC7CG6JJ5xOYiAAsU3mh+q2M0QS4sHZXY5cxrXp6VGF1e
         sHPUXhyaxrhqAppCwXNA2v8a7lSliDbJNXM//Tqlb9VWt2JNv9c6J/JIBFTSEiMAG3AJ
         4Rhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750075163; x=1750679963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7RJ7RnL5M/B3X2GFoans1bgjidQp403I4C/vgaiXPA=;
        b=TU9NA0XySwAOo1cWUDo5JUG/TDZ7TABSJCfiinS4mbOcaN3SkJE0K+KgufAJusxGLo
         U3jvx5lot9mgXEIcSieUOsPu03uDZY8OhThqHkhKmBc3Qsl2tYBhZT1eYvtRExRu6gf8
         wLa3ShTTmKVvgjFGMZjgrwTUYTTTcI3YE1g3nycRoTXNQFt3fQTLMGDd0jnYwTPjBoxD
         790LpvR6WyyipmA0ZaAwmnZ06JMP7gVXWRVkcqUdOELzhTnAd07D3HeqKvKMT7qfjYyZ
         6otTOYksDnnfZWyD9dnlGCpCy2wy7LO1AX9n2LU+132x91LH3qGzsS6pNzrjwgFcsgEz
         2dnQ==
X-Gm-Message-State: AOJu0YxUpJAaYsggGUFt5QjwItM/HaI2Ecc4xuFXRzricHoXTgM8HgDk
	9i1FDUqLhd67ZdhhulgB9/trgDAs4g8gTMMsw9CS2r+e1ApjaDon3TrBKHM2H/2xzLjir5Cd33D
	ExI3qi5U=
X-Gm-Gg: ASbGncuCRwW/+xrb3SjGMj8oQBKNMuMUIGx7R6myDDuF7iq/mkCVMvgUAaW6nnRWTLZ
	v85yfSyZUt5DL8NzC9HGVPUZRYyyOb8BGjV3237IG84jfmVK25JXiyWsKATL8iFmsSHez5812S4
	5TYPTwMrungDDOYZTtw8sYhO9LhAMFn5mSmK1z8xAJhwfIPOI8HwSj/dzUOsissNHtGk1HF1PCe
	H2KnwP2T04feoF8hkIrjWGaI82yk8zueTTUa37tI2xJFdmGumvf4KS6dR4UW2q/lwS4x7Y+HTpn
	khg5efmbK2HKKhXk0o73pOq29kI9x3zeV7OMSDsYSujEldcoLrSKRvE+MkYejqdG1lifdEc4qw=
	=
X-Google-Smtp-Source: AGHT+IELLNm92LFRldfmnL4vF0QIZqp/HsDDpvz3MyBbTA9HBXfroUmvQynilHVSzS3W30Ny6doK4Q==
X-Received: by 2002:a05:600c:5908:b0:453:827:d0b1 with SMTP id 5b1f17b1804b1-4533b235e16mr61208595e9.2.1750075162941;
        Mon, 16 Jun 2025 04:59:22 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a579808c24sm6198786f8f.43.2025.06.16.04.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 04:59:22 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [kvm-unit-tests v3 0/2] riscv: Add double trap testing
Date: Mon, 16 Jun 2025 13:58:58 +0200
Message-ID: <20250616115900.957266-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a test that triggers double trap and verify that it's behavior
conforms to the spec. Also use SSE to verify that an SSE event is
correctly sent upon double trap.

In order to run this test, one can use the following command using an
upstream version of OpenSBI:

$ QEMU=qemu-system-riscv64 \
  FIRMWARE_OVERRIDE=<opensbi>/fw_dynamic.bin \
  ./riscv-run riscv/isa-dbltrp.flat

---

v3:
 - Return an error only if SSE event wasn't unregistered successfully

v2:
 - Use WRITE_ONCE/READ_ONCE for shared variables
 - Remove locking flag for last test
 - Fix a few typos
 - Skip crash test if env var DOUBLE_TRAP_TEST_CRASH isn't set
 - Skip crash test if SSE event unregistering failed
 - Remove SDT clearing patch
 - Fix wrong check using ret.value nstead of ret.error

Clément Léger (2):
  lib/riscv: export FWFT functions
  riscv: Add ISA double trap extension testing

 riscv/Makefile            |   1 +
 lib/riscv/asm/csr.h       |   1 +
 lib/riscv/asm/processor.h |  10 ++
 lib/riscv/asm/sbi.h       |   5 +
 lib/riscv/sbi.c           |  20 ++++
 riscv/isa-dbltrp.c        | 210 ++++++++++++++++++++++++++++++++++++++
 riscv/sbi-fwft.c          |  49 +++------
 riscv/unittests.cfg       |   4 +
 8 files changed, 265 insertions(+), 35 deletions(-)
 create mode 100644 riscv/isa-dbltrp.c

-- 
2.49.0


