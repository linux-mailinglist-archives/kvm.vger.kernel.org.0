Return-Path: <kvm+bounces-18545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2D48D674A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 18:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 566E01F27032
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1308F2135B;
	Fri, 31 May 2024 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LsukXzNt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7815D5AA
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717174328; cv=none; b=diJAnz/7fBC7u1P5nMBPgK+hWtAq8I600K6BdLXgR81q690IsLTZrFnilFlFlzA4UalyQixD/z6uZBcChkK+wStNsBnp5YSOTpZ8N/Y0Z4q9zhH/45eyBguLzn8SjLgk4et2L1KzhynB0bdq1hWCSuEAMpsCIRw7sDLNZhkpFv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717174328; c=relaxed/simple;
	bh=4ACEjwXhGV2kvBYx7LebKDtbKnzknHOi+n06robM2Z0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EA6bi6G5oLOV/2pU6sh1AorWVLJQIihOSQI9Kj9gStDnuKM/bXTLBaOJ2U0HPiBU2csfaoye2W7QrJg4LtHul8xAs1xmENaIRflRpOm/bo3Ua3qTd69F1TBU36ojq5ptlgD6gWMnFu0wFYeAWTcaqjQHNxU2AVhsNOFIEvFejjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LsukXzNt; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3737dc4a669so10146365ab.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 09:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717174324; x=1717779124; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pTNg6zMiXRkJXri9kOZIRbdVDUfZydQpGNpHvB31YmM=;
        b=LsukXzNtss0I3FZjC0oAzDPSATRrUKkeNbXRtpA0seKLkUf88j5Vx1sArbh6odqnaX
         6zfOYcp6wk/krXpiQlTWu1dTadeB/hEd05PjBBs9MV891ppnN85IKSA4bHRSVV26Y9Q9
         TuhBGd8rqYxapzOtUbEV+xeWQNt77oRJdlgmLKXxQmpWuZIBE+Mu3UoCjHACa/XS6AD+
         AKbF1a2obPm1uwDbFVSTdKPIZ+5nsYebuviengq+t/6hnhPCNqNNN9gs+y+GCiZ4ZNRk
         YQao48Azuz9TQMMMKC52Asu0TxjPg1JS0zdeXWNXESN6/8wGhGmm4VpwTO4gBQ1XaUBS
         sWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717174324; x=1717779124;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pTNg6zMiXRkJXri9kOZIRbdVDUfZydQpGNpHvB31YmM=;
        b=CWq+vMMG48yiXhtNqyIt8bbD5OsYHkxT8yRHva1jE6d3Pr1HhZK/2H4lR1mhjXp/ub
         3j+DO3O2ezMAl2O+LksngDEcPgvY7KnX6C/cCtXWFpTHz1zqt3K+3IRzh1p4Qs9yPJFm
         ZxGw1pdE/cyMfvLCqLF8T62hsPidF/22BpuihPC0FFDWBxw45S+IqmxUH6pm/pDA8zF6
         m886yoXFSmIOos3EC+PQaDUAPR/LNWQw4vh3hEF/7aQPFOcqBM6YhgcLE+j0Aep51ZxX
         fZTTQtOTIi3Wec+SM9/LmaNj5SapcXuQciiG0tfTQqmRuwSBTUiykdv2QmyyvSTdml6v
         /0iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDZuF2q0GzusrXmY2l3m5krUK3OnaKDGL3RnQIDPC1Mqy90ijRlZE/j7szgmspFbRA8YubsQOHr66agvornXqkF8gy
X-Gm-Message-State: AOJu0Yzw53Jw4SN2Tdhgc/YI0e7ion+lni1lI8QDZg5rWmNLK1UVcJf+
	xV2x3kT8GFMXTA7TZAIg1eozTDV5DAWcrIEETJLAaGlLi26Nv4bWw+ZndpdXk1VHdxSVMsHzmWX
	kO1ssNG1Q2kBMCrHenWkS8nX2PmKNLTdtPEQDMw==
X-Google-Smtp-Source: AGHT+IH23fWU350+O/Ga1ZOOHV+eDByH+luo7mLUsI3si2RtDZKDd2qThEgwWzavJJFJ6WXu0YhwdsQAKR/symM78II=
X-Received: by 2002:a05:6e02:1d81:b0:374:70ae:e86a with SMTP id
 e9e14a558f8ab-3748b9d0239mr28334425ab.22.1717174324429; Fri, 31 May 2024
 09:52:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 31 May 2024 22:21:52 +0530
Message-ID: <CAAhSdy1mug8sUpNc=RaXYQWJoHNBQahAv5_rLRp0vOdT=xrHNg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.10 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have two minor fixes for 6.10. One is a special case
handling for hart-index-bits = 0 in IMSIC virtualization and
another one is a typo fix in kvm_riscv_vcpu_set_reg_isa_ext().

Please pull.

Regards,
Anup

The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.10-1

for you to fetch changes up to c66f3b40b17d3dfc4b6abb5efde8e71c46971821:

  RISC-V: KVM: Fix incorrect reg_subtype labels in
kvm_riscv_vcpu_set_reg_isa_ext function (2024-05-31 10:40:39 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.10, take #1

- No need to use mask when hart-index-bits is 0
- Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext()

----------------------------------------------------------------
Quan Zhou (1):
      RISC-V: KVM: Fix incorrect reg_subtype labels in
kvm_riscv_vcpu_set_reg_isa_ext function

Yong-Xuan Wang (1):
      RISC-V: KVM: No need to use mask when hart-index-bit is 0

 arch/riscv/kvm/aia_device.c  | 7 ++++---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

