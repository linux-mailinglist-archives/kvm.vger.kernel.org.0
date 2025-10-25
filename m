Return-Path: <kvm+bounces-61085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E564C08EF0
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 12:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC6C14EEB98
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 10:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006CA2EA724;
	Sat, 25 Oct 2025 10:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ojNwwH4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9B2D8363
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 10:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387253; cv=none; b=AdmCTMx+2DdpIDxoZI+yaI2TjFdHYqM9b4x2xlVwGe6m3288pdtZ8YY/3ydma/F7JgTkgZ4xvSEJGYotcTBuOn/5j/M0lwOcvVgUvepgvVr0YMKjzVzki0AP9nQFyyJGZp1Qt/aw6k/pBmzXnuG/v/qmPrd+d5jj9l8YgjEzkN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387253; c=relaxed/simple;
	bh=S8rJn35FaHheeba6IKtIhLBkHvArKY05pNobCQBVRrM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NFGmG1pHf0rZAqk54Dg8XMuCTw6DhZp/GL/cWZZhaT4quayeJxniAyF0f7+QhXNdNvGFHyITELF7QyclGC3aG9qTd7XSWXsNHB9xqqJv6ogq4jlQ2XVDAbtAn2SZrtst9gEZlH6JVfJVMzQiuGtdojPkl8NL3kFmS+RDLBgiKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ojNwwH4Z; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-940dbb1e343so192018539f.0
        for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 03:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761387250; x=1761992050; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wN5MsaqKfRbeYqcIv/KVHd41EL8Y3jzy/bgpR/o5GyI=;
        b=ojNwwH4Z8wHoY5anRaqcPJSn9wmERz9ipfhGgFYgTjQG2vTrymI//i2MGcbKlHWhiC
         gJSiWnjs/2iYcuz8JSJt0IujOyHjnQajch5RQN8Fss0s6wtHWVQZjVnyRLxtnWL29WPh
         zTrbQ8/PlS2Z0pMYGNq3GYwOK0xAIC9LF0U6o99dyBK9xdBMV7sZlzoIuLs9SfxvdeTl
         fvZPsFDfT4jo/oAnxRwu2vcbrFyvFNL27fyrKvF5D0ATopcH0HfO909QFQsBI/8/WYNN
         PXbWly/93IR1nalyfStpGvOCu1uRZ0bEFF+OvFRvlCMyE3fk1q50J8LCCpt//1lwMdts
         QO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761387250; x=1761992050;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wN5MsaqKfRbeYqcIv/KVHd41EL8Y3jzy/bgpR/o5GyI=;
        b=jtaWJ+bnkkgtz7pM9nXZG65kHT3fo0uPI681r1I4iKXS285XtYnMmA9BJLckAb0/vn
         BYTgx4D2G0Wj2cYFCkA79N90lgc/hGUGAXUsWRfNOPNh5I5vc78QAp7e9nNbQ4lLAPKr
         Ctn2xoD9TKSWElCActuUdHp+uP5EPr4cZ5IjsL8wZKRmRae2q0MVqek8iTc5uRqeI8wK
         x9Hs2HWFDu6QeFNEOUJIgZbIeEE1okTaO7sNWyVWta1Vx0YyrNpzb8/T5nZQfSZ3VQ0q
         uSl3vA0pEYTYYZP6prnYZLXcZh5gxPHql4jr1Scu/qcppKaDFjnL/NzdB7gru8o8QXan
         6qng==
X-Forwarded-Encrypted: i=1; AJvYcCX0VwgjQZgk6vnDUVP/5I25QamBj6skhwjVz7slSpu3THo93twsTpDQTeSbflS0KaljiV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT4jXx0CEQD0T2aB2CuCFVAV625zB4nJXWk12WOEipAV4AwTXh
	wS9EVO5MsRJekujumyj0TkUMCb8CGkWMi6yaCXsznHAPvf70ZTaLf4E4FKIJMSRo4JolAO82O2i
	sJ4vdER0lqcGjbvvHbUVuDGNNWwovRpCEg+aJ856rQ+vpAyKSRDogx9lUAg==
X-Gm-Gg: ASbGncudFHLX21s/LrqQ/6S1XXbEM/itThN1uy99muN6qJVMG7YI6HMipGCoEnug77N
	Lt1Rk8PnUyVdulcKQM7gLIlKBuhVton2Zber9L2Y77/a9T7dHo8gZ0INSfWTXx1cb7/tH8XUkvO
	mHNkFHhII09S2YBuHQa0uY8ZEU0dSKASpv3oJvAEpPPC7BTptjTDmwDhP0gFlnc1vxRcANgBT9a
	e7NtrnHhwCH/gzoFqNyWbAvgXL9lzjpj11L5JLoDoXM5fANBRUN8RvDFxOVt4hJbM6GlDyt3KhW
	fkZKxc4uhadcC347cUMgzjVoQEZj
X-Google-Smtp-Source: AGHT+IFpWZVjRCuwhb4DtOufiG7BXJsKl5vIHXR0e6zokP9kahb0yrltoaSSXtmlHhJhQihxphgaQ1Awrp0N48kr/R0=
X-Received: by 2002:a05:6e02:1786:b0:430:bf84:e94c with SMTP id
 e9e14a558f8ab-431eb67c444mr59866215ab.13.1761387250503; Sat, 25 Oct 2025
 03:14:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 25 Oct 2025 15:43:58 +0530
X-Gm-Features: AWmQ_bmwq2oGHjBSLEnWv7bNvD-fJRrO3lgDsBq83C5kNERHDGX9jLhLgFP3WlI
Message-ID: <CAAhSdy1jcXypH3yCUBaci2EbOy2cbr2qNtdYriKa-vcyFFeCzg@mail.gmail.com>
Subject: [GIT PULL v2] KVM/riscv fixes for 6.18 take #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have three fixes for the 6.18 kernel. Two of these
are related to checking pending interrupts whereas
the third one removes automatic I/O mapping from
kvm_arch_prepare_memory_region().

Please pull.

Regards,
Anup

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.18-2

for you to fetch changes up to 8c5fa3764facaad6d38336e90f406c2c11d69733:

  RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP (2025-10-24
21:24:36 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.18, take #2

- Fix check for local interrupts on riscv32
- Read HGEIP CSR on the correct cpu when checking for IMSIC interrupts
- Remove automatic I/O mapping from kvm_arch_prepare_memory_region()

----------------------------------------------------------------
Fangyu Yu (2):
      RISC-V: KVM: Read HGEIP CSR on the correct cpu
      RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP

Samuel Holland (1):
      RISC-V: KVM: Fix check for local interrupts on riscv32

 arch/riscv/kvm/aia_imsic.c | 16 ++++++++++++++--
 arch/riscv/kvm/mmu.c       | 25 ++-----------------------
 arch/riscv/kvm/vcpu.c      |  2 +-
 3 files changed, 17 insertions(+), 26 deletions(-)

