Return-Path: <kvm+bounces-43793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF0EA9620F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 425FE18867D6
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D94928D83A;
	Tue, 22 Apr 2025 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gYMUr2E/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2E28E616
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 08:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310370; cv=none; b=OyPFJ7mXxJP+2D1VLMIrJp354/VRqHB33C/JcyVx6JPFLbzgt57oNaJXRGyhoip39DxSPR8V135tZiKGomnSZ6QIdZ7m7Gi1YefwjAV5acdCYPlV5GaJrEVa4nndAfUb7wtz5lHNJd9w0JzUdh7I/e2FHx589OIRCGGsGnpserI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310370; c=relaxed/simple;
	bh=bQe59A9azQVJqinMp0+l3jtvX9SIwHQ4hfIDHa5112A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VTPo6pQ4J0bRZN/uMI9DkvOCGA12vQiWzgqUXwfhg0tSRSIxYEW+C/MGc4NFozv+KqXjmUkhUCM3flr/YLXrt0TXQyP/P7BjBieHCBrlfHSePCMYJsuFYhXD38MUOi2UQo2VfEimvIqjLafFNYMjSZ1xUxgm8XpJdqt/iMDDhwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gYMUr2E/; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3995ff6b066so2523652f8f.3
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 01:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745310366; x=1745915166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V/cAgNjQa95gQP7B/B/snS+8c4HbJCPXR5Eh8cVo7zg=;
        b=gYMUr2E/GetuiLt9uIuYO2RHM1W85FEnHqFOEl3z+lhJiNkmABS3SG/KpuEenHAbW0
         EsTw2FuCl13+9edAcvvdJHfExOdPJZwdJ1Gxewn519elxNbGTzlocB+3xJI/P8BA0zcx
         LlubrBXiOsE3rAODylnRWu2wuU3cH6m4j1vvxQR/2e/oBXcEMsS2YOWCNr86TqGijJ8y
         ccabahVrf67Jogt2DoYpJ7wajogsibD40BdhlxLJrvA34BY7Rnyn2Mt9NzrnZg0VXkUH
         F5z9IxbxBlTwvl3PhSTEeyY6kv40BKnqNoKq24BGpwCxjswJflp0Pgu6i4hZHSAKn5uG
         HRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745310366; x=1745915166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V/cAgNjQa95gQP7B/B/snS+8c4HbJCPXR5Eh8cVo7zg=;
        b=C9XQu8JfJI5IwwBYxdfc47XS84s3AmK8H1UjuMd0Lkh0RC9lvt1qCcLqDMDwrn5b73
         cCPvf9CZ3Jn+fGOeKbMo4mInUlp+5Emcr69WBMKE9BgSGulpzyLeMjjQIvudhT6JobZd
         mht16kFYG0IVerQVg5X96/3WJlsOg7WHZnm+qmgszUZCZjznply4qCTIdfYaKaLmw/Zg
         o+xFsNHKaUawIsWCz9rOqzGwuGq1u3akeCElzrYdo3N7w09wtMXYn+pZw2GWsXMsCcrR
         C8/BCfNkOz2OOuj0QdbOVit2JjRMt1N16Yh3+vHkVJUZgJJATde6mzMpMU7/BzsFoF2n
         rODw==
X-Forwarded-Encrypted: i=1; AJvYcCX3e45+6VjRxpDZdiH0GkYXRz3tW1P6AmPk1LqRXka12mr4+jasE991OKpgBSWlnoFhjA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnlZ0Ck3h735Ps8T+Xdzfgq6r2aRa6Rwu84G/NifnwWP4DBh3M
	IYhkgX1ZYpP5KF2X/RwTXTpxW/1ppDadQ+K13T2Vjol+G+FW5qWK8bJhSatGWH8=
X-Gm-Gg: ASbGncvRJAt09fAKH04XGgKXYMb79d0/ip7pC00dvEyrgY1rDetcEckl8zvEKmrtrWQ
	vU2BNksXrlugEogUnJgQ2+8f4PJ5kw7hzMjy7rLSNOt9fc8kafvRC5NTMvkz96pjRU+0/WzzTAE
	kHmbuZVc/tMW6QMW+LqOP9DhTtskl3B7kwM+UroEKVf+iE0kGr3cj5/3kUPB+Sscijcr2GVfBy2
	sCzl3Em4fo/A3dFsDeJFM4HV1NykHrRJlpLrpfc+yoO1hWURv/PNQ+1Z6qWbl8aTn3I5HIT+TIk
	s3B4sYdOTgBmytYL24gGJs/G1SPd5o/Wn7/GsUsF6Nqi8Jt66BNYTA+hce0N
X-Google-Smtp-Source: AGHT+IE5rRNC75MFtRNKzdS288HbyuZMTD2nZQBhaznTRZ3kRoPBwHGrzOWpkgGI+7InsS8Jm3kQ6Q==
X-Received: by 2002:a05:6000:1846:b0:39a:cd84:a77a with SMTP id ffacd0b85a97d-39efbae005amr10068227f8f.37.1745310365805;
        Tue, 22 Apr 2025 01:26:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:861:3382:ef90:9fbe:20e3:2fc3:8d19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43314fsm14735392f8f.39.2025.04.22.01.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 01:26:05 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 0/3] Move duplicated instructions macros into asm/insn.h
Date: Tue, 22 Apr 2025 10:25:42 +0200
Message-Id: <20250422082545.450453-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The instructions parsing macros were duplicated and one of them had different
implementations, which is error prone.

So let's consolidate those macros in asm/insn.h.

Alexandre Ghiti (3):
  riscv: Fix typo EXRACT -> EXTRACT
  riscv: Strengthen duplicate and inconsistent definition of RV_X()
  riscv: Move all duplicate insn parsing macros into asm/insn.h

 arch/riscv/include/asm/insn.h        | 205 ++++++++++++++++++++++++---
 arch/riscv/kernel/elf_kexec.c        |   2 +-
 arch/riscv/kernel/traps_misaligned.c | 137 +-----------------
 arch/riscv/kernel/vector.c           |   2 +-
 arch/riscv/kvm/vcpu_insn.c           | 128 +----------------
 5 files changed, 189 insertions(+), 285 deletions(-)

-- 
2.39.2


