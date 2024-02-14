Return-Path: <kvm+bounces-8677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D55448549A4
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B14E1F22461
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D95953E2D;
	Wed, 14 Feb 2024 12:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WcdFLlaa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14E01A731
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707915015; cv=none; b=CqgucXYFGFuwYPDDXZKv6eWsl4FL3K2Wsw/10bftL6JTJnL648EYvKeIQ9Ylh44E1vf0eRWv/ZG6qwQW8CVz7UMyvZUWLWJjrQQG0rcbzjcClC7s3eeFNUA55wjjYY/kZUBj8tNAazxL1CL0Qjysnn5mx9yF55jzRnlhLbYnEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707915015; c=relaxed/simple;
	bh=KpjBVrl5aQuEGzI803dJi8LHosgzPGbHu6PQfze70eM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XdBLLoawnc7rsLa7YCkPSaBU8NwalLJ1pYJyGe6GsLZuGSZcqA+pc7HN2Ox3zQqIfgsi6N4FHW2AdWluBg9oSDp4LO0xM19egoaZ1pmUXEZX+dpTPZM39ddVM76r/B0b23M5ixYvneiipZwrGK1tjWtaPF9Wtm5EW6g2uZ5i2Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WcdFLlaa; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-511570b2f49so645916e87.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707915012; x=1708519812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AMykLLGhEQwe/ayb8QFjtzszmK1UF91DSb771zya9A=;
        b=WcdFLlaawsWV863AQOogIuEimZPu/S4Tct6X/YzPAWE1D+YHNUI217k/5EJgvcju1k
         vMBlD+p7qWdC+kPN8eHZlLtV2ehhM5mL60EtLsrYovz4GTzNctx+BjNZFAvdsS+vQl6Q
         y4cQweTO9EcwvnTz9XIvB24JNLT/uEoOiV4cjLat2nm7R2GceF0e7kMT7KYtBYqyfUBF
         h1BUGLslZkMJrmpFGLsKyXqFdtMXL985hdKNKuVRxaSHs8+KBov7yfCy7rwpvjd5DEOB
         uFWTwySr2EWUZvp0bdB5ZjEOjByIbvXXSzJA4sgtvOTEDvwK3I4jUVTSokySKXVjZ0K3
         TBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707915012; x=1708519812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1AMykLLGhEQwe/ayb8QFjtzszmK1UF91DSb771zya9A=;
        b=Khmg1uQRcuCz2az/CKSYZRvRcwvI4cc/8cWsiQVEVQWwXErG7cQwkLitXG/yOQY2+L
         mRwgiYwfyNL6WohjYQ3aALbPo/EGYwCJh1libQazWUoCR2jdtlr90YQw2PNl+zp8jXrL
         TkXFsjFILNdYNVm37BhRTsL3PceiGYV66j3MkktKvIimNCS8jq4hGHsiIe7ONWFaFQn2
         3xjPDT/JFtgOS8n4BK/4m/+QnV4jQfZFuSC5Um+vMQa6hnBbgLCZ5fAVRMN0SiUJkc7D
         nvVe2QcZE/H346Un301U264j+Qs5tKiFNPqyQu1pINQrgcV8h8pczd11lBL775rgYE7k
         kYFA==
X-Gm-Message-State: AOJu0YyxJVMR8MhynsxCaGP0yByVEk1VGwfmuYpG82wnwc40MznguUj6
	ecm8AHjrbLIi8psVSzEI7oI+qQU9Qhknh7mPpUDnAUvwZqbLohhRKsG1VQf4nG3mYEu2J1CelpG
	favli+HrEvgDW9hCZ53Gt0krRS94F01MqlDeaIw==
X-Google-Smtp-Source: AGHT+IF7lALDcbF5Q4R3nObQ/8vNabeZYsaSldg7JH1sBIcNmbrPAvYfOnO2znsaCZflsROdJRWeT9t+nrpLeoSNNk8=
X-Received: by 2002:a05:6512:3d17:b0:511:ac5c:e02f with SMTP id
 d23-20020a0565123d1700b00511ac5ce02fmr531327lfv.8.1707915011510; Wed, 14 Feb
 2024 04:50:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206074931.22930-1-duchao@eswincomputing.com> <20240206074931.22930-2-duchao@eswincomputing.com>
In-Reply-To: <20240206074931.22930-2-duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 14 Feb 2024 18:19:59 +0530
Message-ID: <CAK9=C2VZ1t3ctTWKiqeKOALjLh0kJgzVEsZvM=xfc2j7yQOEcQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 1:22=E2=80=AFPM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG is
> being checked.
>
> kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
> from userspace accordingly. Route the breakpoint exceptions to HS mode
> if the VM is being debugged by userspace, by clearing the corresponding
> bit in hedeleg CSR.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
>  arch/riscv/kvm/vm.c               |  1 +
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index d6b7a5b95874..8890977836f0 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -17,6 +17,7 @@
>
>  #define __KVM_HAVE_IRQ_LINE
>  #define __KVM_HAVE_READONLY_MEM
> +#define __KVM_HAVE_GUEST_DEBUG
>
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..6cee974592ac 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -475,8 +475,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>                                         struct kvm_guest_debug *dbg)
>  {
> -       /* TODO; To be implemented later. */
> -       return -EINVAL;
> +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> +               if (vcpu->guest_debug !=3D dbg->control) {
> +                       vcpu->guest_debug =3D dbg->control;
> +                       csr_clear(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
> +               }
> +       } else {
> +               if (vcpu->guest_debug !=3D 0) {
> +                       vcpu->guest_debug =3D 0;
> +                       csr_set(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
> +               }
> +       }

This is broken because directly setting breakpoint exception delegation
in CSR also affects other VCPUs running on the same host CPU.

To address the above, we should do the following:
1) Add "unsigned long hedeleg" in "struct kvm_vcpu_config" which
   is pre-initialized in kvm_riscv_vcpu_setup_config() without setting
   EXC_BREAKPOINT bit.
2) The kvm_arch_vcpu_ioctl_set_guest_debug() should only set/clear
    EXC_BREAKPOINT bit in "hedeleg" of "struct kvm_vcpu_config".
3) The kvm_riscv_vcpu_swap_in_guest_state() must write the
     HEDELEG csr before entering the Guest/VM.

Regards,
Anup

> +
> +       return 0;
>  }
>
>  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index ce58bc48e5b8..7396b8654f45 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>         case KVM_CAP_READONLY_MEM:
>         case KVM_CAP_MP_STATE:
>         case KVM_CAP_IMMEDIATE_EXIT:
> +       case KVM_CAP_SET_GUEST_DEBUG:
>                 r =3D 1;
>                 break;
>         case KVM_CAP_NR_VCPUS:
> --
> 2.17.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

