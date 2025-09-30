Return-Path: <kvm+bounces-59198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 484B0BAE24D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D0477AA488
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6859030BF59;
	Tue, 30 Sep 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nyn//4Mn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77AB21CC4B
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252593; cv=none; b=ab8bNI2+Y7iOARYBI+1CP/YW1qblNjaGCDCirxekSuOwWU7tPlCEyPZD/ZXaEu1eoqR0dNhkcdxJTk0HBnDt3Xc9X+P6wgNlcRSPYtOBhdNzGbjbR+CyFTYBGykfpe2dWtUMgGS8W4RFYOXkINl17fastrub9eKVrV0QSj+od+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252593; c=relaxed/simple;
	bh=EdP6JctddnnMGSrPTKq/dDC5GKYmCdkzmF3VqHqQF5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MwRJ503IZ7LByOhWlYHLmgEwgkG4pg5RhmMTxl0UhviuKBxSbVNSlH4OcRyRmcDha0L0RsqPgyix1FfUjo+pv5CX9rzNlE8/QEA+z1UOb8k42Qmzka1u6x/3OcNHUwJgHN58wq9Q/D7vJ0LeUZESZaUNNJ4FQtimmLwb4PQ1gyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nyn//4Mn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759252590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/kJayDu1eB3BIwIHLTJDNrwZ7PeITeFX4tp0qkJLcw=;
	b=Nyn//4MneCy94eoNWAYKTBjRglg49jqQB2LKmVDBy7x36/IuVUSGGG3xQpWy4ukoF6D+w6
	w5fdLJk9GsKUjR2TIqYiR3OmSr/kKubjv19NtgzWwmh6bqtxRQ0/A8EN2tp2LWx+QaAqol
	uFN9EKXnPVzXbtjEcX1Ci8RTNyx1WtY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-qJy0Ybv1O2CAd9w7ZGu9pA-1; Tue, 30 Sep 2025 13:16:29 -0400
X-MC-Unique: qJy0Ybv1O2CAd9w7ZGu9pA-1
X-Mimecast-MFC-AGG-ID: qJy0Ybv1O2CAd9w7ZGu9pA_1759252588
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f384f10762so3937622f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759252588; x=1759857388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/kJayDu1eB3BIwIHLTJDNrwZ7PeITeFX4tp0qkJLcw=;
        b=TGAbKd02rygqXgJHzCIZJ3LRbaIpafZ1n9im7YfpZOxkyxwHi8FKKaUxM2+IJ8AZ4s
         EPPXxearfUvdG+n/jk7LjqT0Yb7D+gX4JyNmM/KTBxF5o5SZNLczTa4bbTgtfulTBd1D
         xJRDwd3v5j7VYnqpJz8AB+HLMVTuzftV1NhCI1MyS50+zUnAjaVttsQIVVZvb/2emaUn
         g00Wdt/U7y8o+aQhOgqA7FC8e0V1KLdMgMff8PNBE5aUHqWvam6QXq8CX5IKZKIqRoCj
         /hnVsi1MvBYgOKD8trWEc4GYP8GcPmbGx4HtYI/FHsM1kgrk0jEbA7pRLMq49zHrJ33K
         7Pjw==
X-Forwarded-Encrypted: i=1; AJvYcCV1BC9gGSIxZOhPZ6YftKmm9luZEh5Ny6+zwGQCF7vnbt/ynEvLPYMovdVfz1P/gJvCVd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZWSI9+fDUBc/KlZhGNbBNp+34MEvIOadakvdzvomqkw1aV0RN
	Fe2ozu+e3dGszNdxWUGDz8EybXs80eqEw+Z6y+7LmQd7bKEfiwBUaM8Vp6SEeQRl6B+u9vdOLzk
	9n5WJQuG8RAuKqxlul7MBH8rmF0nv64PBIMaq8YX2O8yqM4Hnip9UW+qrq6mA5KArfIiFChsgCk
	FOGytDMD8cR6SLyGIbZD0OiVQQs7Ch
X-Gm-Gg: ASbGncs+ja5gowOQg5upSDTId66nWObDr1vmVqecvfEKBcgoPEUgdFHx0Ay/qeeYm8L
	yvm8rl8/46mKk67RdW/qEW3xHefmU7aaGLd4o5E5aKVgQ4hNQFROp1RSDKSZtTeuLuHfF2II0Oz
	m0PsGCrOogbp+3avTW6F6mmUjmirTURh9/vIYyvpuQPrtwxtcCLuPuj2C2pYiM54jyPLUCe+vLG
	ed2VHotHSQP4s9Acrz+PUwfH/rasc6O
X-Received: by 2002:a05:6000:2f87:b0:3ea:2290:7cc6 with SMTP id ffacd0b85a97d-4255781e65amr495689f8f.56.1759252587776;
        Tue, 30 Sep 2025 10:16:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZBgZJriB3qJinE93AtqxjRIjg8X3/AcdaGIjfcs5vWyuAtob5vAt/+MblfaN9mXeKuR3BE4dxUdrC4pzQ7RU=
X-Received: by 2002:a05:6000:2f87:b0:3ea:2290:7cc6 with SMTP id
 ffacd0b85a97d-4255781e65amr495652f8f.56.1759252587264; Tue, 30 Sep 2025
 10:16:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3pXsGfFi-A1jFsO3UJsjomJ1y3Z8F73xe0xuftzLHBLA@mail.gmail.com>
In-Reply-To: <CAAhSdy3pXsGfFi-A1jFsO3UJsjomJ1y3Z8F73xe0xuftzLHBLA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:16:15 +0200
X-Gm-Features: AS18NWAHk8LGnPopmi7IzSPzymgWmNfo7kdPFNGa7YlCpP2N1nymx1V23eSeai8
Message-ID: <CABgObfaukO_krpCkBZwKX27KcFk5Hth4jh7xV0mrq3vfY3qsug@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.18
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 9:00=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.18:
> 1) Added SBI FWFT extension for Guest/VM along with
>     corresponding ONE_REG interface
> 2) Added Zicbop and bfloat16 extensions for Guest/VM
> 3) Enabled more common KVM selftests for RISC-V
> 4) Added SBI v3.0 PMU enhancements in KVM and
>     perf driver
>
> The perf driver changes in #4 above are going through
> KVM RISC-V tree based discussion with Will and Paul [1].

Pulled, thanks.

Paolo

> Please pull.
>
> [1] - https://lore.kernel.org/all/CAAhSdy3wJd5uicJntf+WgTaLciiQsqT1QfUmrZ=
1Jk9qEONRgPw@mail.gmail.com/
>
> Regards,
> Anup
>
> The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c=
6c:
>
>   Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.18-1
>
> for you to fetch changes up to dbdadd943a278fb8a24ae4199a668131108034b4:
>
>   RISC-V: KVM: Upgrade the supported SBI version to 3.0 (2025-09-16
> 11:49:31 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.18
>
> - Added SBI FWFT extension for Guest/VM with misaligned
>   delegation and pointer masking PMLEN features
> - Added ONE_REG interface for SBI FWFT extension
> - Added Zicbop and bfloat16 extensions for Guest/VM
> - Enabled more common KVM selftests for RISC-V such as
>   access_tracking_perf_test, dirty_log_perf_test,
>   memslot_modification_stress_test, memslot_perf_test,
>   mmu_stress_test, and rseq_test
> - Added SBI v3.0 PMU enhancements in KVM and perf driver
>
> ----------------------------------------------------------------
> Anup Patel (6):
>       RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
>       RISC-V: KVM: Introduce feature specific reset for SBI FWFT
>       RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extension=
s
>       RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
>       RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
>       KVM: riscv: selftests: Add SBI FWFT to get-reg-list test
>
> Atish Patra (8):
>       drivers/perf: riscv: Add SBI v3.0 flag
>       drivers/perf: riscv: Add raw event v2 support
>       RISC-V: KVM: Add support for Raw event v2
>       drivers/perf: riscv: Implement PMU event info function
>       drivers/perf: riscv: Export PMU event info function
>       RISC-V: KVM: No need of explicit writable slot check
>       RISC-V: KVM: Implement get event info function
>       RISC-V: KVM: Upgrade the supported SBI version to 3.0
>
> Cl=C3=A9ment L=C3=A9ger (2):
>       RISC-V: KVM: add support for FWFT SBI extension
>       RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
>
> Dong Yang (1):
>       KVM: riscv: selftests: Add missing headers for new testcases
>
> Fangyu Yu (1):
>       RISC-V: KVM: Write hgatp register with valid mode bits
>
> Guo Ren (Alibaba DAMO Academy) (2):
>       RISC-V: KVM: Remove unnecessary HGATP csr_read
>       RISC-V: KVM: Prevent HGATP_MODE_BARE passed
>
> Quan Zhou (8):
>       RISC-V: KVM: Change zicbom/zicboz block size to depend on the host =
isa
>       RISC-V: KVM: Provide UAPI for Zicbop block size
>       RISC-V: KVM: Allow Zicbop extension for Guest/VM
>       RISC-V: KVM: Allow bfloat16 extension for Guest/VM
>       KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
>       KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test
>       KVM: riscv: selftests: Use the existing RISCV_FENCE macro in
> `rseq-riscv.h`
>       KVM: riscv: selftests: Add common supported test cases
>
> Samuel Holland (1):
>       RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN
>
>  arch/riscv/include/asm/kvm_host.h                  |   4 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h              |   3 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |  25 +-
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  34 ++
>  arch/riscv/include/asm/sbi.h                       |  13 +
>  arch/riscv/include/uapi/asm/kvm.h                  |  21 +
>  arch/riscv/kvm/Makefile                            |   1 +
>  arch/riscv/kvm/gstage.c                            |  27 +-
>  arch/riscv/kvm/main.c                              |  33 +-
>  arch/riscv/kvm/vcpu.c                              |   3 +-
>  arch/riscv/kvm/vcpu_onereg.c                       |  95 ++--
>  arch/riscv/kvm/vcpu_pmu.c                          |  74 ++-
>  arch/riscv/kvm/vcpu_sbi.c                          | 176 ++++++-
>  arch/riscv/kvm/vcpu_sbi_fwft.c                     | 544 +++++++++++++++=
++++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c                      |   3 +
>  arch/riscv/kvm/vcpu_sbi_sta.c                      |  72 +--
>  arch/riscv/kvm/vmid.c                              |   8 +-
>  drivers/perf/riscv_pmu_sbi.c                       | 191 ++++++--
>  include/linux/perf/riscv_pmu.h                     |   1 +
>  tools/testing/selftests/kvm/Makefile.kvm           |   6 +
>  .../selftests/kvm/access_tracking_perf_test.c      |   1 +
>  .../selftests/kvm/include/riscv/processor.h        |   1 +
>  .../kvm/memslot_modification_stress_test.c         |   1 +
>  tools/testing/selftests/kvm/memslot_perf_test.c    |   1 +
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   |  60 +++
>  tools/testing/selftests/rseq/rseq-riscv.h          |   3 +-
>  26 files changed, 1188 insertions(+), 213 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
>


