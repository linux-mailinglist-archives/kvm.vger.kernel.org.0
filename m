Return-Path: <kvm+bounces-47732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5265AC4467
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 22:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5722816B0A3
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 20:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F41723ED63;
	Mon, 26 May 2025 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUdeQPeH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FCE1C84C4
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290961; cv=none; b=CoR0n3fbjPkB57f8hxX5hD+2t5+6vALUKzal4tfa3ztTpICGOrYdWWwaIgstvxA6uM+Vqt2TLxoJPz4cyaoAbVWJWAeg43oKdGgaAxJRlVlulPDUlh/iKFJJiik9KzCZLL2VSHH4hBfD8vFqwtHPvF4MkJHvJNEDoyfbnR+W3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290961; c=relaxed/simple;
	bh=K8U3xbhP1uhyQsgLX7OUYClzfffwAMwTt/2W10eH8vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qZN19F3zZFYNpN5D7/p0R2furKbeUpZYCrLC8S31F60UrUwqdw9TBP60dV3LU2fBTbcBVKYmUNZ9BKp6zu7o+pcRA7W2Eoevl+bwj8MG0mGl6g/mBBB7mdREnNb7O76CcESDTqANIriHxkztbVQSeClCxsXsHIUCK6Y9VgVxTl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUdeQPeH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748290958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xMGaQapG6+nm97TfKW/OCSgmi2X3lyhE0Z44n/TtsM0=;
	b=YUdeQPeHKYgFg9TJtBM3bm/fuqzVYvfMKjly7cNBhEsvKCH1EqesAZ7P6Pqz4gcmWdeSId
	yfSB/FYdjOZO+pQOqQgspGAlwYQdfG5bW6J+u24/Uf116CeM9FSy4JXHSqADAufg8oBBma
	sW7HS28bXi3CLy/4R7MpD5RCTj8HJSs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-r8AXBhnOOqGQDe8Elc3DsA-1; Mon, 26 May 2025 16:22:37 -0400
X-MC-Unique: r8AXBhnOOqGQDe8Elc3DsA-1
X-Mimecast-MFC-AGG-ID: r8AXBhnOOqGQDe8Elc3DsA_1748290956
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4cfda0ab8so793850f8f.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 13:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290956; x=1748895756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMGaQapG6+nm97TfKW/OCSgmi2X3lyhE0Z44n/TtsM0=;
        b=A089t9HXEL+4MXa3lLRZYbrPaSagvADtRa6a9RIO1DIL39cE9LStQFsv5DIRwEnPKj
         8GXXxMDj4sGiwtHShTCVNACq3x8p3G0eCyN8ZNTdyLvEQk8tBCBtlT14SwKF+q/KpVhH
         7lbSq7OxWqLXRuTZ4k5pchx7wKUm4QA9I+RWZhX547Jb3EEeBo7pboR/Ty5Aq9Vk9aOE
         3x0jC74h91zDiAZ8Xrn5Ai3z9Tv/KX0Qqe7cBiLAinocEDPHcDBMPCZ3t8F5Zd+fpjdV
         flMV6N+JnWGjLGrnQtvMAMuYQ8l2QzEK+m+y+5adKTU1yiD0R4Yz7zgbWqgIFdqeT/6H
         Y3ow==
X-Forwarded-Encrypted: i=1; AJvYcCVxjlgVfTxKit2N86wJUYl3PZuKhBK6RM0KzkUa7jF4/PT2YeXkz4RAF3SWVxJfvUn8hVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRBUB6jPjBBpSw9LoPT8jNCM8IxeY6lQOsp0qG9YPNs/5wOOrL
	TMyC6z6x54+r9AZYYCApplEijtqgHB3RRExpIqHHATVLpJVvvkg/IAx/meRZe0xzvqW5KxDFsph
	zlGRbr+UHgWWHWzRmL1f/7V5XNhD98eRzvWCBggfIi3JfS5alubJNjBulTUnVjqglap7b6towJn
	xGB7V4BaeOPTdz4TuLvQuEpDee3JUW
X-Gm-Gg: ASbGnct6tTtc8IhU074CheYmukpwpCg7ECBLRJqTpTWEHZq521I2sM/D3Qkv90QJ5Qg
	SQaAzOrXJ9bYhbkvkUh25bSB8qe9eg2RlEpuyE7M0/nIqtSxJfT+fK5VVC5EGyCUsBWA=
X-Received: by 2002:a05:6000:1814:b0:3a4:cb8e:d118 with SMTP id ffacd0b85a97d-3a4cb8ed307mr6669847f8f.24.1748290956048;
        Mon, 26 May 2025 13:22:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDiymxARCDcZPCHxy/Xz46jJP275t8/OtIIOm6ZkqfxnurlcmDMDRRtdCzNxlU2TSGevwUXa1uw0tO3yKwJTQ=
X-Received: by 2002:a05:6000:1814:b0:3a4:cb8e:d118 with SMTP id
 ffacd0b85a97d-3a4cb8ed307mr6669831f8f.24.1748290955743; Mon, 26 May 2025
 13:22:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0H6GEBaY1NfCyF5O1PsHAmuxgW4mQyoC47bVFmMjqk-Q@mail.gmail.com>
In-Reply-To: <CAAhSdy0H6GEBaY1NfCyF5O1PsHAmuxgW4mQyoC47bVFmMjqk-Q@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 26 May 2025 22:22:24 +0200
X-Gm-Features: AX0GCFuO9oYQV6T3lK7DsSjx0oOC2d8-4m0DKglynmA2n2l4ofByHtcVbnPU7QQ
Message-ID: <CABgObfa0P5gnNoqsh6d-Bg8s5otJxVK-5MHH4O47Z2k2WZL-8Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.16
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2025 at 6:53=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.16:
> 1) Add vector registers to get-reg-list selftest
> 2) VCPU reset related improvements
> 3) Remove scounteren initialization from VCPU reset
> 4) Support VCPU reset from userspace using set_mpstate() ioctl
>     (NOTE: we have re-used KVM_MP_STATE_INIT_RECEIVED
>      for this purpose since it is a temporary state. This way of
>      VCPU reset only resets the register state and does not
>      affect the actual VCPU MP_STATE. This new mechanism
>      of VCPU reset can be used by KVM user space upon
>      SBI system reset to reset the register state of the VCPU
>      initiating SBI system reset. )

Pulled, thanks. Note that KVM_CAP_RISCV_MP_STATE_RESET is 242 due to
conflicts with kvm-arm's assignment of capability numbers.

Paolo

> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 87ec7d5249bb8ebf40261420da069fa238c217=
89:
>
>   KVM: RISC-V: reset smstateen CSRs (2025-05-01 18:26:14 +0530)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.16-1
>
> for you to fetch changes up to 7917be170928189fefad490d1a1237fdfa6b856f:
>
>   RISC-V: KVM: lock the correct mp_state during reset (2025-05-24
> 21:30:47 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.16
>
> - Add vector registers to get-reg-list selftest
> - VCPU reset related improvements
> - Remove scounteren initialization from VCPU reset
> - Support VCPU reset from userspace using set_mpstate() ioctl
>
> ----------------------------------------------------------------
> Atish Patra (5):
>       KVM: riscv: selftests: Align the trap information wiht pt_regs
>       KVM: riscv: selftests: Decode stval to identify exact exception typ=
e
>       KVM: riscv: selftests: Add vector extension tests
>       RISC-V: KVM: Remove experimental tag for RISC-V
>       RISC-V: KVM: Remove scounteren initialization
>
> Radim Kr=C4=8Dm=C3=A1=C5=99 (5):
>       KVM: RISC-V: refactor vector state reset
>       KVM: RISC-V: refactor sbi reset request
>       KVM: RISC-V: remove unnecessary SBI reset state
>       RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
>       RISC-V: KVM: lock the correct mp_state during reset
>
>  Documentation/virt/kvm/api.rst                     |  11 ++
>  arch/riscv/include/asm/kvm_aia.h                   |   3 -
>  arch/riscv/include/asm/kvm_host.h                  |  17 ++-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |   3 +
>  arch/riscv/include/asm/kvm_vcpu_vector.h           |   6 +-
>  arch/riscv/kernel/head.S                           |  10 ++
>  arch/riscv/kvm/Kconfig                             |   2 +-
>  arch/riscv/kvm/aia_device.c                        |   4 +-
>  arch/riscv/kvm/vcpu.c                              |  64 +++++-----
>  arch/riscv/kvm/vcpu_sbi.c                          |  32 ++++-
>  arch/riscv/kvm/vcpu_sbi_hsm.c                      |  13 +-
>  arch/riscv/kvm/vcpu_sbi_system.c                   |  10 +-
>  arch/riscv/kvm/vcpu_vector.c                       |  13 +-
>  arch/riscv/kvm/vm.c                                |  13 ++
>  include/uapi/linux/kvm.h                           |   1 +
>  .../selftests/kvm/include/riscv/processor.h        |  23 +++-
>  tools/testing/selftests/kvm/lib/riscv/handlers.S   | 139 +++++++++++----=
------
>  tools/testing/selftests/kvm/lib/riscv/processor.c  |   2 +-
>  tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
>  tools/testing/selftests/kvm/riscv/ebreak_test.c    |   2 +-
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   | 132 +++++++++++++++=
++++
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  24 +++-
>  22 files changed, 374 insertions(+), 152 deletions(-)
>


