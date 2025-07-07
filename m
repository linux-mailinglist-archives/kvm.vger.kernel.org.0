Return-Path: <kvm+bounces-51643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AD6AFAA6C
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A439E1787D5
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2281825A337;
	Mon,  7 Jul 2025 03:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o1vQ2ZeV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D39242D9A
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860437; cv=none; b=lS7HLn+T49kmxYVdzm+levn3wzWCpaOjxMO2Ur4Jd2SeCh2rFJe5DHACF9aksCCiZZdR2yB8t6FLLjeoMsqIKDUpmmrqgE5ifv8z9be49QLjgqhAE2UBiOcAy+tDmBfMMFQLry1J9cAc65JK48IIsF7eSEJEyxJgNHVI9vJi7+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860437; c=relaxed/simple;
	bh=L3zNIEBUJGar6s3zpXt8LnbzVSyh0BYXS9gj5vPYO3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=II0PZDTRnN32iIm4r7k8kgvvE44IAJOJw8WIRj0GMeyMPTAyvxwiB3FKMExix3BS3CtWdTO58R3EU6PaKhCpUxJCuGsYDWMEVg/bvpoyctWVi3JN7Hi9NDXqd7s8Xkh1jxg+a4LWtzO6+i5ZZqIVkrwLn8vz7O2Af4lAbrzhapc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=o1vQ2ZeV; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b26f7d2c1f1so3680106a12.0
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751860435; x=1752465235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i5wHfXXQ4zEBMf9atQWdwXzfnG4mDo9qjXuqOPXqkyY=;
        b=o1vQ2ZeVy8XivPaXub0K2AIcLoF9Y2V/1dXeWO9Gs6JUQLrPrwSIU1tiAiSqcX3ByL
         GRW/J/UhJpU/y055HZcJB++dZiIfgO9c1wX/Wsxle5NPnY9fEhZz8jMYjvMx0hwW1APs
         uga8dCf1QIaMgmut3K+RqBLeNBSbaBM7lsf6ufRc3nD6HLYMnKbk3MpDSTetC+kZ49qm
         jSiKNeF8mLH1pHiUxSmzb2PlsIiQrhoulnjY58E2mKsmXcSMxztnMx1g5eRTx8X9k7m1
         HRoHR/XY4dYKgCGWpScDvUw9+JU62VH7OpmArwclySotixprTecxoJT3dvCIw+oF/tG5
         /g4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751860435; x=1752465235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5wHfXXQ4zEBMf9atQWdwXzfnG4mDo9qjXuqOPXqkyY=;
        b=h06Ytha2X53yg6CJUE3bv/GiNuG1fjQPOXnTJY7W6TopTtEaMgOYecTivzy9X7t2jU
         ftofyAFkPBisO6Qz4IXQUuWUdlEaEtySxg5iQfLjk0hhzhrPET3P6KVwzEo9VUk4GIA/
         73CmNCUCfnZM6c7whjW8ZBpIhHG9IX+fVtBtGW/M0Z6PKT55mMPxdOFARgzy7U2AZlIy
         t6FZFhy9iiEwb3AyGa1bmjofzmySLux1VdPgoIgx0pZEfAU2AYVGGIZHnEap8g3lEsxP
         Nmf2wMoZTaPOM0+gHHXaWRCnt2kIyFOR90/ySfehQRn4FM95IL8kH5WsEdjo4kxwuufC
         yqCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOUaqyTqfRLD59/PdqKjVQgV3Vo7aevaOapsc8jPVtJmH24csT2eoE1aVGm8L6Xc/pLDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuN4kJ6DAl4z8zp1oNkeLtAmA3A7+4QGe/JBFntgKnSFMtN5Hp
	K3PFPUAgCvj2C3RODhSDrMdOHWPUVC6SegwKoBZL7LdfFvRSH/w3jy/rBSJjSoCjjws=
X-Gm-Gg: ASbGnctZDyW/4k4E4Y3TB/NAkw3Wjrv9pbDEsyqfhzUeDTgj2tY28DZgoanKIon8/SO
	+v7UIwyAxVP68aAv/MyKgnhLeX5Kw1eUKRDUMDKlRNZKKL/hZXmiaE8XT7FMOOO9M4WYNeKe/FB
	QL05jrKvssibcaHXjcZJAT6KfRy2T9d6sauXjWsRabDtuR3FKAJTSBzZ5wOli7nMecYwQQcR4l1
	cx0ligIJ8xGBBCXSH3xvDZGfa6dJRsE+RTB9MG4XqyXjcRIrdVKxc5+CQq2YBoKnYHNt8PdtL5Y
	OLtXaRkxxNMesHBQiyJg7dFemFy9g/zNM9z0oJSlaOTMXU4EuAIqUJnO+HM5OMkQ9fvRUunVVov
	cN/0XDwFvx4pVkqn0YRQ=
X-Google-Smtp-Source: AGHT+IH3PnAiGTyAZ+6qYrNH6yhveNJVZ6r8Z9td+wti94tqoIsXso9lzCWFTyC7yioqYXSlTSnKJw==
X-Received: by 2002:a17:90b:3c50:b0:311:d28a:73ef with SMTP id 98e67ed59e1d1-31aac447bc9mr17532339a91.10.1751860435085;
        Sun, 06 Jul 2025 20:53:55 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.152])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaae80ae0sm8159137a91.21.2025.07.06.20.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 20:53:54 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 0/2] Few timer and AIA fixes for KVM RISC-V
Date: Mon,  7 Jul 2025 09:23:42 +0530
Message-ID: <20250707035345.17494-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RISC-V Privileged specificaiton says the following: "WFI is also
required to resume execution for locally enabled interrupts pending
at any privilege level, regardless of the global interrupt enable at
each privilege level."

Based on the above, if there is pending VS-timer interrupt when the
host (aka HS-mode) executes WFI then such a WFI will simply become NOP
and not do anything. This result in QEMU RISC-V consuming a lot of CPU
time on the x86 machine where it is running. The PATCH1 solves this
issue by adding appropriate cleanup in KVM RISC-V timer virtualization.

As a result PATCH1, race conditions in updating HGEI[E|P] CSRs when a
VCPU is moved from one host CPU to another are being observed on QEMU
so the PATCH2 tries to minimize the chances of these race conditions.

Changes since v1:
 - Added more details about race condition in PATCH2 commit description.

Anup Patel (2):
  RISC-V: KVM: Disable vstimecmp before exiting to user-space
  RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization

 arch/riscv/include/asm/kvm_aia.h |  4 ++-
 arch/riscv/kvm/aia.c             | 51 +++++---------------------------
 arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c            |  2 --
 arch/riscv/kvm/vcpu_timer.c      | 16 ++++++++++
 5 files changed, 71 insertions(+), 47 deletions(-)

-- 
2.43.0


