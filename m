Return-Path: <kvm+bounces-13881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C8589BE72
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7314A281755
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 11:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406A06A010;
	Mon,  8 Apr 2024 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="MgG93mK+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0D6657CB
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712577114; cv=none; b=inxlus1tPwujuIP316ikLmXtzflNlVbC2I1gUBWuPCw5DpY0pPF5Q5KsytOiiez7UX+GECqu8sb19Mug0a9SzEsHDCUYYgiGqkzNBdrA9/BPBB75xVtaLusHJeqWVpa1/Mc4/r6YrR4RGeoK78SChlvLaiYywcodG4Tm3S+Db6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712577114; c=relaxed/simple;
	bh=wv8ksI68mLQKc6ARafGjQKqd1GfEpCoO4muu1aYD9d8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GEhaj6wlufuBSXU57y5X1m6/bXpO2VJtxBoxhaC/90LyqPtHOBGAst7f6Cx5LnGzPVOp0cRkqxPUqr1NAF2Puan9AsiZ0DY3tFgnX8IJXb4dlKxJISDvQive3xtmFiRJGQtqWj6uXcPLovBCdi2WwMX+bMNgx4JrCMROXlx3nxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=MgG93mK+; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36a165b8845so4518575ab.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 04:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712577111; x=1713181911; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HDnET1ICXbiSWI4eekvnAuzBIOvWCq79VgIDRhs0OM=;
        b=MgG93mK+la1BLbxyO/YrfGqxjBOHvSAHttA11zdkotdQ+ARXuOo54M81DmnGw+tY+q
         srlbrHMCfVClRLiT216ejnnjmfsQA8tWlcZ3FBjTpf9Z/VgKRsYTwwVfM1Rt1WOCD6cz
         HpCNRZn6E0yuoVbaTFfiDEJGDwib98hRxUgcfL7HYJybQrYbJK++fqJcknC20wO68lMV
         VuID158P6o7XC3jlnvW6Nk0JGhYVbRRtzubfzubNCasL7ipvrX6eRupgu2zDRBMP5GSk
         NYD4lDgRpgNd0lXKAwbZqGClx7+tCl37THGSPL0QCbA+okzB9rr5ucEpX1oZ/jhAK7IO
         /huQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712577111; x=1713181911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HDnET1ICXbiSWI4eekvnAuzBIOvWCq79VgIDRhs0OM=;
        b=h7zHp2CVwmKtzzbWYjtcUUWugqqBTP0uhMgRK2BC+8WjQ6WPxJqH+ji5WeR8of09ip
         rEUEbD580Tx0rj99iOHlYqYAdekctv3YfRr48BeJ1UPfIGGqjZFqKKewtXsXwyDHrzyh
         /iNZR0ckDQzXU3F4p4i7yX3c7TJB7FEaGPyqhFg45aS6zIpna+SK8OKQCvxC0BuYtW7Z
         XGehSaTFeOfYM8PYltyndiU5wRXg7BExpZQSNrSoxTbJkt4M/aYa+3Xl0Ccp1OmBMiEG
         lT5YbTjgDWHC8+Y8KOVFB01ULgrYivHjH5CdCNQUMcF1VNQm2smYiNlAs7/FI/Ij1FTB
         BPqw==
X-Gm-Message-State: AOJu0Yy7cTUisSLFhFcDZGBRVZXrjrbLyO37ULaNkeAawmsPZdghRQ3e
	Dl83B5HN+nZdP9ry0UaSxEeOjVE1x5k/Bx9GkXU3xAmLdjiUW233JhHdP/c7EA3S25JQZQx+qV0
	JLOEd8//BUHLTIC47cLofMb419gSw5cTLizAw1g==
X-Google-Smtp-Source: AGHT+IE+ywRAniHmrIJjs7prm8vzXnQmBgIRLehtoMef03SesPmyPrWKYeKG1cVObBOia7W64ziHmnYb2cvB4CK86FQ=
X-Received: by 2002:a05:6e02:339b:b0:368:920b:e211 with SMTP id
 bn27-20020a056e02339b00b00368920be211mr6460688ilb.5.1712577111050; Mon, 08
 Apr 2024 04:51:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402062628.5425-1-duchao@eswincomputing.com>
In-Reply-To: <20240402062628.5425-1-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 8 Apr 2024 17:21:40 +0530
Message-ID: <CAAhSdy0yVN91P5-B0bBibEB1-53L4wAiOdCWeBP3cxPzOacyXA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] RISC-V: KVM: Guest Debug Support - Software
 Breakpoint Part
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	haibo1.xu@intel.com, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 12:00=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> This series implements the "KVM Guset Debug" feature on RISC-V. This is
> an existing feature which is already supported by some other arches.
> It allows us to debug a RISC-V KVM guest from GDB in host side.
>
> As the first stage, the software breakpoints (ebreak instruction) is
> implemented. HW breakpoints support will come later after a synthetically
> consideration with the SBI debug trigger extension.
>
> A selftest case was added in this series. Manual test was done on QEMU
> RISC-V hypervisor emulator. (add '-s' to enable the gdbserver in QEMU)
>
> This series is based on Linux 6.9-rc1 and also available at:
> https://github.com/Du-Chao/kvm-riscv/tree/guest_debug_sw_v3_6.9-rc1
>
> The matched QEMU is available at:
> https://github.com/Du-Chao/qemu/tree/riscv_gd_sw
>
>
> Changes from v3->v4:
> - Some optimization on the testcase as per review comments.
>
> Changes from v2->v3:
> - Rebased on Linux 6.9-rc1.
> - Use BIT() in the macro definition.
> - set/clear the bit EXC_BREAKPOINT explicitly.
> - change the testcase name to ebreak_test.
> - test the scenario without GUEST_DEBUG. vm_install_exception_handler()
>   is used thanks to Haibo's patch.
>
> Changes from v1->v2:
> - Rebased on Linux 6.8-rc6.
> - Maintain a hedeleg in "struct kvm_vcpu_config" for each VCPU.
> - Update the HEDELEG csr in kvm_arch_vcpu_load().
>
> Changes from RFC->v1:
> - Rebased on Linux 6.8-rc2.
> - Merge PATCH1 and PATCH2 into one patch.
> - kselftest case added.
>
> v3 link:
> https://lore.kernel.org/kvm/20240327075526.31855-1-duchao@eswincomputing.=
com
> v2 link:
> https://lore.kernel.org/kvm/20240301013545.10403-1-duchao@eswincomputing.=
com
> v1 link:
> https://lore.kernel.org/kvm/20240206074931.22930-1-duchao@eswincomputing.=
com
> RFC link:
> https://lore.kernel.org/kvm/20231221095002.7404-1-duchao@eswincomputing.c=
om
>
> Chao Du (3):
>   RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
>   RISC-V: KVM: Handle breakpoint exits for VCPU
>   RISC-V: KVM: selftests: Add ebreak test support

Queued this series for Linux-6.10

Thanks,
Anup

>
>  arch/riscv/include/asm/kvm_host.h             | 12 +++
>  arch/riscv/kvm/main.c                         | 18 +---
>  arch/riscv/kvm/vcpu.c                         | 16 +++-
>  arch/riscv/kvm/vcpu_exit.c                    |  4 +
>  arch/riscv/kvm/vm.c                           |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/ebreak_test.c | 82 +++++++++++++++++++
>  7 files changed, 116 insertions(+), 18 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
>
> --
> 2.17.1
>

