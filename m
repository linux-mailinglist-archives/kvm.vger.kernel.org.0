Return-Path: <kvm+bounces-60339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD50BEABF0
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C7974583D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901C932C92F;
	Fri, 17 Oct 2025 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FeTQgWZc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B1B330B20
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716778; cv=none; b=Oim8eAv4c078y8EX6xZE28TZYSRF7InxzEjfV+N6a3/6kqyy03FaInfRlZxZ/Ao5xy13/rf8+dWAQF1FzAGxjA1VoEXJIxihRr2G0EDWUg4JYhRlxU/PrENDsTJDdglv3MXmz55ra8UmR9GOzVVlO0YrQFLjvPhHFL+BbBGtdjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716778; c=relaxed/simple;
	bh=SiL9tMUEqqm31R8lR6ocLt10DXUHORIUaPfGbfxWyMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rOnNqw2LFK2sdM6LAJazsVKPSdpCk+zAIypADZpy3K8Dz+aZ/+BfFPv5QZcEAHqa88PE/b8txn0lALY4hl4q5ovyg74dV7LooXj9r3O0zLmsz9xAdj5rxEv8PsWZPC6vKazMBvBr1ia1U3z32ir02PW+q2gwix9pHA7XixMr3hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FeTQgWZc; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2066386b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 08:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760716776; x=1761321576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C3sebnt8lI1uLFunjh62A3i8Z6IjtTbQpyFes/e/NfQ=;
        b=FeTQgWZcGHJZPphb3NsAuJ8Uo/cTPIEfAlzdeNy2ZscfojwaPw0P58f8/7RXT7uO1Y
         AYOnKNFNvrRs7yfsGP/EsD3jExz+MIKHkS/FWf5j1fvZL+HnuVTNRx47yvsKhTAPLnpu
         LU1unRzYrF3Ffp67Hkdx10RzYyrsrlOXBx9HXGO2Y1VT5awf8GdSVn8nsX5oKpfXDqO2
         9Ek3G1NlXhofPkvkCG5qc7YXeS8p80C5X0ru6JoK3gYKGZkDiN+/wPwXDd5ytXbReVF/
         2dPYTcUDWmRkQT7Vn2jfZTwKKECp5LPY3uBq9qDwcMTACucDtmfyBNoS/ehukmz1LHjW
         dqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760716776; x=1761321576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C3sebnt8lI1uLFunjh62A3i8Z6IjtTbQpyFes/e/NfQ=;
        b=TPlblB8PQcx2ICtWrjM2z0uKPpI3kvsq3A9DDcXdxuIo/tGepeZaHIEQ+DIp6mCz6Z
         uHxM5DcXaU0CwqzObMQs9o6wKZ3+QDWhg7BBVd4N2w8W/aEIMpgocb5LriBpWHic3DaR
         Brmm+JaSvuRVrDqEEtGXRks8oso+R3WYPB4Td17j6WD8HmBNrSfQyZINurXeMdODQWVO
         OVX0ZNp2PRBQOTvZyu6n4Visd/eUgjAaINFEW1BoaPuHflk3GDMX5u4v4spg9HMhj+L6
         gDwGr0Dp+14y1rip6u3x6M8swrbW/A9LSM3C9s64vgk6TYVqofks4vc1ka+uqiQ0kg+H
         wfRg==
X-Forwarded-Encrypted: i=1; AJvYcCXSieNdsYTxq06GzuQ7KdauOkwL6+1iotSG6wUfGLH9kPWPXDEw7ZsCYNMjDZiVxDWEtKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQFGu/3aHfMmTgriRxfwMJGXTX2Wjd2e1D9pe8MyX15CGfsFEt
	bkUTixujTpOC1jzYuJQq23Vp6rCA5g+8aaky/NT9scA8itSzHMHq+brkV+m1F4CtQAE=
X-Gm-Gg: ASbGncuPrj7FedaQkMgd0mlbSAnosob5kIEVBrfkFxeW0Iy9XeCY9qUWo5Y3OEzQiUl
	UfM6y/hvMMBF8I48wCybmnh2y86EhImODy6E6QctxnBBsZECTBEWIgNYO5HF6IAfQ1eMJZVYQXm
	UXSq9uPCMwD0HkN/SFIQKXohMb5rMETw8lCZ2+BDM3e9dJaKQ48vTuEWjBZvnSg4XWSgi0Si7Po
	DzRmzYYLZoGU4hO1OHWYJxwiUjTzXwxdjRMJEvkVxxDVowDF2vqRdXHNz6L/HK6lVRILBsF/8MQ
	KmPICHkeovW1FepoeK+yNrVhCWQzcduJplj9hW1miqBslHAmy2sSgeHrJlhYTx57VTfFxowyZXC
	JoOafhsepuM5RTl4T18tO8UizOyPMwte1j30b1q/oxpi8GcFBOTRTLbqcrtRfZTHP0a3rdOB7MG
	vGWJ0XW/RWCRD3gHUF0roTRjDGBpSdsoNv38zqRaSLipM=
X-Google-Smtp-Source: AGHT+IGXVOTATy+D04tW0ZdHIUpLbiat0j1Zpq3tC7lF/XTd5JaW53iu75rTOxxNbuFmzr3SM4KXPg==
X-Received: by 2002:a05:6a21:6d99:b0:334:9861:ba67 with SMTP id adf61e73a8af0-334a85fd82amr5481874637.34.1760716776216;
        Fri, 17 Oct 2025 08:59:36 -0700 (PDT)
Received: from localhost.localdomain ([122.171.18.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a7669392csm151067a12.18.2025.10.17.08.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 08:59:35 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/4] SBI MPXY support for KVM Guest
Date: Fri, 17 Oct 2025 21:29:21 +0530
Message-ID: <20251017155925.361560-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds SBI MPXY support for KVM Guest/VM which will
enable QEMU-KVM or KVMTOOL to emulate RPMI MPXY channels for the
Guest/VM.

These patches can also be found in riscv_kvm_sbi_mpxy_v1 branch
at: https://github.com/avpatel/linux.git

Anup Patel (4):
  RISC-V: KVM: Convert kvm_riscv_vcpu_sbi_forward() into extension
    handler
  RISC-V: KVM: Add separate source for forwarded SBI extensions
  RISC-V: KVM: Add SBI MPXY extension support for Guest
  KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list

 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  5 ++-
 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kvm/Makefile                       |  1 +
 arch/riscv/kvm/vcpu_sbi.c                     | 10 +++++-
 arch/riscv/kvm/vcpu_sbi_base.c                | 28 +--------------
 arch/riscv/kvm/vcpu_sbi_forward.c             | 34 +++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_replace.c             | 32 -----------------
 arch/riscv/kvm/vcpu_sbi_system.c              |  4 +--
 arch/riscv/kvm/vcpu_sbi_v01.c                 |  3 +-
 .../selftests/kvm/riscv/get-reg-list.c        |  4 +++
 10 files changed, 56 insertions(+), 66 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c

-- 
2.43.0


