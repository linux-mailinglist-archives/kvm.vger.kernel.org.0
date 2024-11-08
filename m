Return-Path: <kvm+bounces-31309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A7F9C22BF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 18:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2F1DB23AEF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CEF1974FE;
	Fri,  8 Nov 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zsxydqyn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A702208C4
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731086126; cv=none; b=mCJ81XdjiPhfvYdu0GLNEq4PXTLqFw6v00j31RlcEiqGwTAKWLnU0hf9u7wTG1pu217VYk7KB6EG1FU9d8r9fZP7v1frIobNo3HxCKUFQ8SAQ0ARV4MDww+YhnsyglyJCXBqJ6OJZ0vJ2azZ3YBcOmHSC8Czm2bSYVT1NxoISXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731086126; c=relaxed/simple;
	bh=+NSED2anQHSCIH9VG0CImvU7VIl3RkWJ2AASqvMXOw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BBm2FRcTwsFkkvEm6GGap9m+6hbgHS0IfNnFhXzhR49Cok0P8lR8BosAwnr1KUWkZCIfnd+sRknxoNfzuK+CAQpFkvmcVqgC9PIgI9WJXOZnI8udJQ1dCZ0bzAVPD5P74xE6huGVSTr+20XXV31ypPDeb7HIl81QeggE4l6eJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zsxydqyn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731086124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vCUjb2WEZwOmRQQdW6wTHl2QoTT0U5MTAqvrkfkoI7w=;
	b=ZsxydqynwKYOt9M8BKzNzJMCesFJ9K71GT1ujgSDSFkXyjtZFZILnNbu2thXGhvXV6Z9Ve
	2/JSW+RjusYc/DnZhReHJCzMbtfct+g+4+m6QfmxyO72jxaRwkkXpid56NCsNA8hKV7Acg
	U9JC+7EzUA20VYHHxRLD+vxfjH3NBBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-HuOnQv0UMeeKfQw9-5YwPA-1; Fri, 08 Nov 2024 12:15:22 -0500
X-MC-Unique: HuOnQv0UMeeKfQw9-5YwPA-1
X-Mimecast-MFC-AGG-ID: HuOnQv0UMeeKfQw9-5YwPA
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso16533055e9.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 09:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731086121; x=1731690921;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vCUjb2WEZwOmRQQdW6wTHl2QoTT0U5MTAqvrkfkoI7w=;
        b=ClEJDieqzZrhFeeQ8WT66vu8K1kPJiV0JUu86IrdvBVpL1lI1T7JUgF93p3oaBy5Es
         Y+KrF9Jj6XaBY35H98X9Mtf94zlUasU1svJIyOKWM/FZBUwpV46Ya/0hd6vob4DXt8Jr
         2Zi6yeS02CgEgUhjW9ZfaXg4j60Hzb013sObH3Mqq4VEBH15eIdQIG9uC6Dl8xgcC0CG
         P7zRkjqSXtqtVUVLoAowb4PSbFYdz3yXndqZN6JtkikmVnBiqKAxtxPTeWwQq1D9Ulp5
         WdedNz1P0KFhjl6qasSJ762/4kNZipXQUPFDDcJ2PaI/sA+4/A4Z5f9uI/11walzLVYx
         HgXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1So8xKT5MuBvE9vV/TBwu+3lGliE3PMDgIqy0ApnloBt9JwWZxruC/LiASuSziPMo7eQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn6BN74Jw8C0K8MudfZdrIoGILW2BtFXuNO86TCEtDKV0cF7Vc
	+h9sCnlrdjrmei/lF6umk/ZSDvA35YQivp0Aax9qluZhF51NCkx39cVNkruh+meuoLqOt8WggYZ
	G8ueODuysic98vlS63peCp9M8iMTJnhpWb/1nzyBIaCU8r1nlYA==
X-Received: by 2002:a05:600c:3b10:b0:430:5356:ac92 with SMTP id 5b1f17b1804b1-432b74fa9demr31004625e9.7.1731086121567;
        Fri, 08 Nov 2024 09:15:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCnrTYX2K2byT1T8BSP08QpvzCFgiW0vGHGjPTgymUI5Q/EeukAs/msDasqguquyNvm3rY0w==
X-Received: by 2002:a05:600c:3b10:b0:430:5356:ac92 with SMTP id 5b1f17b1804b1-432b74fa9demr31004265e9.7.1731086121172;
        Fri, 08 Nov 2024 09:15:21 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-381ed9ea653sm5426530f8f.65.2024.11.08.09.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 09:15:20 -0800 (PST)
Message-ID: <626d3780-73bd-496b-9503-e09bfb293bb0@redhat.com>
Date: Fri, 8 Nov 2024 18:15:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>,
 Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>,
 linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/8/24 12:37, Anup Patel wrote:
> Hi Paolo,
> 
> We have the following KVM RISC-V changes for 6.13:
> 1) Accelerate KVM RISC-V when running as a guest
> 2) Perf support to collect KVM guest statistics from host side
> 
> In addition, the pointer masking support (Ssnpm and
> Smnpm) for KVM guest is going through the RISC-V tree.
> 
> I also have Svade and Svadu support for host and guest
> in my queue which I will send in the second week of the
> merge window to avoid conflict with the RISC-V tree.
> 
> Please pull.

Pulled, thanks.

Paolo

> Regards,
> Anup
> 
> The following changes since commit 81983758430957d9a5cb3333fe324fd70cf63e7e:
> 
>    Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.13-1
> 
> for you to fetch changes up to 332fa4a802b16ccb727199da685294f85f9880cb:
> 
>    riscv: kvm: Fix out-of-bounds array access (2024-11-05 13:27:32 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv changes for 6.13
> 
> - Accelerate KVM RISC-V when running as a guest
> - Perf support to collect KVM guest statistics from host side
> 
> ----------------------------------------------------------------
> Anup Patel (13):
>        RISC-V: KVM: Order the object files alphabetically
>        RISC-V: KVM: Save/restore HSTATUS in C source
>        RISC-V: KVM: Save/restore SCOUNTEREN in C source
>        RISC-V: KVM: Break down the __kvm_riscv_switch_to() into macros
>        RISC-V: KVM: Replace aia_set_hvictl() with aia_hvictl_value()
>        RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
>        RISC-V: Add defines for the SBI nested acceleration extension
>        RISC-V: KVM: Add common nested acceleration support
>        RISC-V: KVM: Use nacl_csr_xyz() for accessing H-extension CSRs
>        RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
>        RISC-V: KVM: Use SBI sync SRET call when available
>        RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
>        RISC-V: KVM: Use NACL HFENCEs for KVM request based HFENCEs
> 
> Björn Töpel (1):
>        riscv: kvm: Fix out-of-bounds array access
> 
> Quan Zhou (2):
>        riscv: perf: add guest vs host distinction
>        riscv: KVM: add basic support for host vs guest profiling
> 
> Yong-Xuan Wang (1):
>        RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
> 
>   arch/riscv/include/asm/kvm_host.h   |  10 ++
>   arch/riscv/include/asm/kvm_nacl.h   | 245 ++++++++++++++++++++++++++++++++++++
>   arch/riscv/include/asm/perf_event.h |   6 +
>   arch/riscv/include/asm/sbi.h        | 120 ++++++++++++++++++
>   arch/riscv/kernel/perf_callchain.c  |  38 ++++++
>   arch/riscv/kvm/Kconfig              |   1 +
>   arch/riscv/kvm/Makefile             |  27 ++--
>   arch/riscv/kvm/aia.c                | 114 +++++++++++------
>   arch/riscv/kvm/aia_aplic.c          |   3 +-
>   arch/riscv/kvm/main.c               |  63 +++++++++-
>   arch/riscv/kvm/mmu.c                |   4 +-
>   arch/riscv/kvm/nacl.c               | 152 ++++++++++++++++++++++
>   arch/riscv/kvm/tlb.c                |  57 ++++++---
>   arch/riscv/kvm/vcpu.c               | 191 +++++++++++++++++++++-------
>   arch/riscv/kvm/vcpu_sbi.c           |  11 +-
>   arch/riscv/kvm/vcpu_switch.S        | 137 ++++++++++++--------
>   arch/riscv/kvm/vcpu_timer.c         |  28 ++---
>   17 files changed, 1022 insertions(+), 185 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_nacl.h
>   create mode 100644 arch/riscv/kvm/nacl.c
> 


