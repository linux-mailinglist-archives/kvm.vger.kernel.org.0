Return-Path: <kvm+bounces-34611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C93EAA02C9E
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE3A3A1222
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB5913AD20;
	Mon,  6 Jan 2025 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tiYHqaVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CA81728
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178820; cv=none; b=IoKztQZiZpKI9kFP+3Cshxs6wD8tQVCWapkSqPoR8TIBWBErquifc1YXudQE/1HBPc+0LE8Sqy7DV+3vSxo+5jL1Ejr2XIoPsISqsbYr9nIJVT6ykJTqlxA0YOLZkb23PBO2HU+N1nkv2j9zh/spaE2gULIOif4J2MI/04EVmdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178820; c=relaxed/simple;
	bh=q/Kj781zAkaZk1+DHCISv5/bg+rRWfVX56gf7aBQ/qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IQhnf8epX8pDTfTS2VP4J74d6B1OMq8KWGw2jTxpch2AXivkXVAHkb+5mkmufNsrIbBjDLIrGE1RTyNfBmnxzh5Ixmw137uyiEWCXFyV8vHjNegbmCBIS7mHyVUo4uAup5UcxmS5+OLAjkuZ2SInGmejRj8FsuNGVc+yAUM5VPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tiYHqaVm; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216634dd574so138670525ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178818; x=1736783618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Uh7Y4VyLnr5ahLh9pQ24pYzPC1g2Asrk4+KWI2rULw=;
        b=tiYHqaVmEqKPQAPCD3048KgF6x+4Yp7PU6jmulUoKhdXal86d8EG6dtT5lW97saueR
         8iFm04J+Tm6o3wIlaymFuUjvJAIzItMY3Kch/WEWyLtR7XWJ5Xp6x+jKdOWPhkR10jrf
         GYv2hsy5jMdOwCplaOSEle55sPxUdTyQWTSM7FXQSxVBxV62bAlsDGTs2l4+E9EsmoHr
         xoq1MyMZsuyMoLrJlGdUiHRRy9ZbelNV2nhiLI8uP7RLBiUMJ+eLaiIttKI/qmTy/m31
         Hb9ahSg29luaToIYan84pisIovqKHfFAJNBf35CxTvvl/dZ96Ew0nciXwRdGQCUgzLHf
         Jpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178818; x=1736783618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Uh7Y4VyLnr5ahLh9pQ24pYzPC1g2Asrk4+KWI2rULw=;
        b=I/4Qupo6RmqbblM4ZVzMIDej6v+5cVfVfNNfmP8yk3axPegpAidGwOPSsE2b5wM/pg
         jNA4cl1bHwqONUx/K8afDnimOAOWSjJ+GGA6wROtRh8BehJboXcjFkkb8wf0yT/MjAcg
         PfAr8JnBrYYECJPvCfPbdNft+P89QqEJXCij1EHB3VfbmoZG4/gSNPRwmB6ZzIQlzkpz
         KwwD+X4xzNLuPdGrI+joohkkuo25AuYiYovwV/L+zEZ6dLZoLvIKacBYOP14Qe/xS7W5
         LFCoWwSMBCGS6DuXq8UpB9ie5Z3kCAmd+AHxqbiKwBu4z3JX2Fl77nDvMDTGSKGwyDxh
         f/xg==
X-Gm-Message-State: AOJu0YywOgvMWF+i3UODVTa2ifFiHu2c19q33xFUflfKWhjxdf9R0tmY
	xN8XQoPIA7bG2nI3dQPKOxPzUmQfG+h1lBDQ1fckGNkD5tS7xhCVfA7EfSXj6pEUKdhwbUeoL8H
	P
X-Gm-Gg: ASbGnctgqGm84Ku+p68zEjrSXu2Mk3dOToirQQ9SQQP6yOpLqaqPaophoPMvfIoubDR
	/4/WKYt8nDSN7vl45P3diWCpcVqXM7UISmOK03FMoM7gcWQ0vhW184f0d541CZZqMgGjXuL6x8N
	YgQ54nxCqAd/6PvFgkTbzT4LaOtvMhkQBlTn/mmG8Okv2pc0z5funvCqv+kG0f3faKIcexApXCa
	o4En0CQBNxGjfqo/OyGIZXOCYO88a7Q6b2Wmz1qYlmtcpLlEtlMHA7b7w==
X-Google-Smtp-Source: AGHT+IE5yT8zpB30bHVTWusvGHsV94xvgRHgoYIxCBzgPXZm5tP1CmaA72t8RvSXRpdwnFZnvPhDJA==
X-Received: by 2002:a05:6a20:e68e:b0:1e1:becc:1c81 with SMTP id adf61e73a8af0-1e5e0801191mr100407325637.32.1736178818261;
        Mon, 06 Jan 2025 07:53:38 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b8e867ccsm28950200a12.47.2025.01.06.07.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:53:37 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 0/2] Add support for SBI FWFT extension testing
Date: Mon,  6 Jan 2025 16:53:18 +0100
Message-ID: <20250106155321.1109586-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds a minimal set of tests for the FWFT extension. Reserved
range as well as misaligned exception delegation. A commit coming from
the SSE tests series is also included in this series to add -deps
makefile notation.

Clément Léger (2):
  riscv: Add "-deps" handling for tests
  riscv: Add tests for SBI FWFT extension

 riscv/Makefile      |   8 ++-
 lib/riscv/asm/sbi.h |  31 +++++++++
 riscv/sbi-fwft.c    | 153 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 192 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-fwft.c

-- 
2.47.1


