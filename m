Return-Path: <kvm+bounces-32260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB87B9D4D3C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BD67B27D94
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D0F1D6DB5;
	Thu, 21 Nov 2024 12:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="RJkR1Plo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D551D319B
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 12:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732193751; cv=none; b=r6l1rKg6fE3rHNHH/LWv1qk1PkiqUFDX5y685DU9asXa3VAh3SGjdzjCL6QaVF9M4Pf8/mo01ymFHBce7wM823QdcUdDtLmdaj6C2TRc9Srh1lfoIz17dE2uGyYLJmyK44qCLzGkr/un/tUW/NztNLsbuyikqszGsz9IGS0pTLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732193751; c=relaxed/simple;
	bh=/RiKqab/sYwYnu50KHRh5wcOqN++KRMxhwkCSEH/rLA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=R2+zSItudDdN6VaqIQr3hoZ5NT2BPoQeRe/tR7YiIt1Lld8EhwhYq6RKRyi9/GmSW6UC627rhsmGlMkpEdjDYs/NQFGdae7pDGaJy7DWleBWQWq81WohVJ2LtwwVCVMx+cWU7h4uaW6iMOXIug6NuSMSYFjVCuLfjWtvPpX82UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=RJkR1Plo; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83aae6aba1aso30661339f.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 04:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1732193749; x=1732798549; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4OPqzXMUHnyZ1Qfz8WKePkWvYvx6EvXlEnQMdWX7vBk=;
        b=RJkR1Plot2sgh/c08prhRzxJqXevrzvKw3x/emduKRKzv+j9akv5LbosqOBxBeAF4o
         c1eBn9eqGMHQJ43lf3S7cJ9+kKgkxTxhOO0ktwbQVI6n+soAKxH0TrTnW9ZwjOmwZq2W
         2hm0Gav0NFkawxRyI8cHh+INledNyEW+25kZnZXKvsJXGJsVFaxHqQ3UhyUPjLgLSF0U
         1f5TJO8JfZr9PrVaXTlgtrU2xZ3sAhwaWlrv72Io5BjUtb8NVS233uSf+7mu+zu/pdua
         1O0seBdhtIN7YFkITHtTvGI2doCQIPPELyPnHNOoesexthLBHgxF6rge5ZAUWBEA2NiP
         bLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732193749; x=1732798549;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4OPqzXMUHnyZ1Qfz8WKePkWvYvx6EvXlEnQMdWX7vBk=;
        b=r9JPO5fAEE3PwvOH9Ub+mmrmHRqJ2EWWJr1/WYdwsISwTWbyQl2nC7YLoff3wHjBvF
         FX0bQVx+3q/263KIvX3Mt6fcnjN2FI4+DxBKf2lPl+Fa1C5v2YfXZV0Xt3VOSldvECH6
         oiGJgoiZLlpzssFWr3mTkxcM/KWgzALFiBNJoFxkdSUWEE7l0dX3rzggUfE/3h9Yfqmm
         7/380maHCp+PYXoQvFcxLabIqxFBmp9eXu7zjouyxgAAxGnUbAcWqG1pzOKFN78b1UOt
         ABGHeEmE7eNtLi3IGEK3kll0rgV0rK1mLSjdM/LembfTtHLAc0H63A4pFwhIzUQMEl99
         w2Wg==
X-Forwarded-Encrypted: i=1; AJvYcCW9t8MsdFku0pEDrnl0w3rvwXMWpSJJTEXeo8fop7F/uEynLlJQeiH9qDOwvoH9G0VIgf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjOO0H7zxKFSvDnnLlRFc/k3tCPqv85l3C1p1mP0EHZQMplMR0
	TfoXRpQI7koLFj6hm4Rpft+J/TRvRCoP1QXyUwY2pBa26HAfNvYQ6/9JU40ct9UkIJGPflMTFL0
	gDIvc8SMLBsqnymmUP4VXNI+L4rAtsFq9ybAmiY9B+AGaZxrF+IY=
X-Gm-Gg: ASbGnctavawn3NHaoYy90BWrrbSVrxZJjk1OkdlxbmPD2ky43uwKmA1nAM3kQ81Xi6G
	FqbFNi5ylMJtVXzCHDMrecOvRAkZsS9UO
X-Google-Smtp-Source: AGHT+IFzME82wtFhiLZQ0596FmC/IrmouUnXxIXvNfGhgZBmJbZiykpTW4VRwU84h8kkvIZO3+9/SLoaGrJsnt6/bD4=
X-Received: by 2002:a05:6602:15cd:b0:83a:a305:d9f3 with SMTP id
 ca18e2360f4ac-83eb6028fb1mr880276339f.12.1732193749094; Thu, 21 Nov 2024
 04:55:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Thu, 21 Nov 2024 18:25:38 +0530
Message-ID: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

As mentioned in the last PR, here are the remaining KVM RISC-V
changes for 6.13 which mainly consists of Svade/Svadu extension
support for Host and Guest/VM.

Please note that Palmer has not yet sent the RISC-V PR for 6.13
so these patches will conflict with the RISC-V tree.

Please pull.

Regards,
Anup

The following changes since commit 332fa4a802b16ccb727199da685294f85f9880cb:

  riscv: kvm: Fix out-of-bounds array access (2024-11-05 13:27:32 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.13-2

for you to fetch changes up to c74bfe4ffe8c1ca94e3d60ec7af06cf679e23583:

  KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
test (2024-11-21 17:40:16 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.13 part #2

- Svade and Svadu extension support for Host and Guest/VM

----------------------------------------------------------------
Yong-Xuan Wang (4):
      RISC-V: Add Svade and Svadu Extensions Support
      dt-bindings: riscv: Add Svade and Svadu Entries
      RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
      KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test

 .../devicetree/bindings/riscv/extensions.yaml      | 28 ++++++++++++++++++++++
 arch/riscv/Kconfig                                 |  1 +
 arch/riscv/include/asm/csr.h                       |  1 +
 arch/riscv/include/asm/hwcap.h                     |  2 ++
 arch/riscv/include/asm/pgtable.h                   | 13 +++++++++-
 arch/riscv/include/uapi/asm/kvm.h                  |  2 ++
 arch/riscv/kernel/cpufeature.c                     | 12 ++++++++++
 arch/riscv/kvm/vcpu.c                              |  4 ++++
 arch/riscv/kvm/vcpu_onereg.c                       | 15 ++++++++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  8 +++++++
 10 files changed, 85 insertions(+), 1 deletion(-)

