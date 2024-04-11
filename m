Return-Path: <kvm+bounces-14231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5998A0BE1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7D5D1F2789D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A4E143C51;
	Thu, 11 Apr 2024 09:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RlREm/a+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D813CF91
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712826410; cv=none; b=bRYjAUmjzhhM4FhfHN606TtHEIEgjaLsd1ntBK+50yjXfoDjdFstDK6C74HwIst3KKuIXr1akl8ETmPefyKQp2vkkqkLFwUE5m6qSgF90iiXT3X0rgH2ioMIDho4Kgu8OPHoVxkoJPysidl+zoOUqlnsbDu77vZJIKcU3V6+dw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712826410; c=relaxed/simple;
	bh=6DbO2IfX4foKh9Xb3n4eNqJb7FJipbHuEUEhvFPlwPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ihfArm9yVLB3q//TBJem2OfZ9VzU5lK22r6G55aW8poIelLYxl+RZCVQzMD4hOtbvCp0SVi9P9M225VRRjKnc+mOsGbQZ4wejMScm1L4baYDjD4awVmIFjNsYNqR1dOWPdGLgsZ/xxw/Q3TXqcEXXustYRjwenU60wCi7Nc3VDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RlREm/a+; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-22edb0ca19bso3906555fac.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 02:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712826408; x=1713431208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CBhqQGQ9V37via17GNYW/9Ko6M+5Uqp4L2VsS7G79oA=;
        b=RlREm/a+ZFZ67ldxqDWSLX0njC+wMkESc9RDwWLmT+TgPzD0ReMrHav/xfTvBNZOsi
         VhHvIH3kRagoWCO4QOJuLOO+9uVrq5SvsWKJTZ//b/ShwVJZpax0eBYG1DW9P6WXHMVt
         KcfAgScxDtdj9UYoI+4kN9xlBZ2su7qBGgqSIcXyvpghy3Y4YH7JG93EH3DWvBBdkoe5
         DNpmgjkqDS1stZRt3qDE7s9hJov2HVLozBJLAJTvjOIpo9UQa8xftWUsJP0Z4JFasH9x
         lWpfgcr1pO1CWqEBVSpGlddspXcGHzXuQPN3I8M6zrjf6fmPJ3jPT84Um0z8jGyhq1m1
         o1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712826408; x=1713431208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CBhqQGQ9V37via17GNYW/9Ko6M+5Uqp4L2VsS7G79oA=;
        b=GiCMG9yNqBeQp2PUZ8b0X84z8Ii+WKMx6BWBaduKHS/q/nJeIXDgdmEzd2Nenu+8/I
         c6kyT2D4BvvFI3ScLMUicg8X+TJlzxrOFvgZ5mH+be7qYBFUeycr5TJhQ4oxkcHroNZh
         +R6USwNnE1t8PKQiqiTjIgsKyGFDrjXmFTwgzcWEMR+6hREygOUeOpkWLjr4BekGDsGe
         dfZ5onb/U3Nznx0A4Y3LxfAqV4SNyRX1Ot2ZgxroO1PA94skdwJE6M5bpKbiFIDFmoMB
         PusEObi3dNaoMhR1KtIpI5NSbBvDPkpQNpWRWUXKqw3MWpELp4F7ZU3Cp7yu/shAohD6
         xjOg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ9tiukXhlwNpOzkjVM3tWzHSlpm+ZppJUvdpBxzov1O++DIMfUcTNSt33YSAmtySRP+YGy4otpBIGHs+NBbAtBZPw
X-Gm-Message-State: AOJu0YxHwSDF1ZD3nLqzpAJ2X1u+Qym63LUSO9bWzrbBvZZw4X24Ksl7
	8KTBLjfvzw7fTqKKK9xUVMBW8sD/3ssw69XCD/xYYW6rhtc3+AJH/2yjd9HnXzA=
X-Google-Smtp-Source: AGHT+IHdV+Ixn8TwQhwDHZf5ScDldFNUD5vTYYRbuxDbqU8SomJtrIceDwDNi2J3aMwBPVQwYLhmIA==
X-Received: by 2002:a05:6871:5c6:b0:22e:c48a:bfda with SMTP id v6-20020a05687105c600b0022ec48abfdamr5675910oan.28.1712826408430;
        Thu, 11 Apr 2024 02:06:48 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.118])
        by smtp.gmail.com with ESMTPSA id e21-20020aa78c55000000b006e729dd12d5sm816738pfd.48.2024.04.11.02.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 02:06:48 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/2] KVM RISC-V HW IMSIC guest files
Date: Thu, 11 Apr 2024 14:36:37 +0530
Message-Id: <20240411090639.237119-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series extends the HWACCEL and AUTO modes of AIA in-kernel irqchip
to use HW IMSIC guest files whenever underlying host supports it.

This series depends upon the "Linux RISC-V AIA support" series which
is already queued for Linux-6.10.
(Refer, https://lore.kernel.org/lkml/20240307140307.646078-1-apatel@ventanamicro.com/)

These patches can also be found in the riscv_kvm_aia_hwaccel_v1 branch
at: https://github.com/avpatel/linux.git

Anup Patel (2):
  RISC-V: KVM: Share APLIC and IMSIC defines with irqchip drivers
  RISC-V: KVM: Use IMSIC guest files when available

 arch/riscv/include/asm/kvm_aia_aplic.h | 58 --------------------------
 arch/riscv/include/asm/kvm_aia_imsic.h | 38 -----------------
 arch/riscv/kvm/aia.c                   | 35 +++++++++-------
 arch/riscv/kvm/aia_aplic.c             |  2 +-
 arch/riscv/kvm/aia_device.c            |  2 +-
 arch/riscv/kvm/aia_imsic.c             |  2 +-
 6 files changed, 24 insertions(+), 113 deletions(-)
 delete mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 delete mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h

-- 
2.34.1


