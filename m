Return-Path: <kvm+bounces-10573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE6686DAAE
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 05:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3C341C20B94
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 04:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CD84F60D;
	Fri,  1 Mar 2024 04:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tUPu3cpg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42D94F5EA
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 04:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267436; cv=none; b=TonP2zQQpQG7u9ZdEqhkUvmc55xAx1mtrYqxbqXkUhMl+3N6RqvmAExLB+fji6akN7Gd+urSuA6KwDx6RcX8qRcbfYf36VsF9zWOVYjp186VyA9mrBWfmkf75kSiPeHLFiXOO/W0kO3Qoq+wHAtTAMKQi5nrQF8vXP/byvPixEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267436; c=relaxed/simple;
	bh=6ZSwzvZa7/QWt6Zts/1a0e38aM9Z/Bh3yx29QjyPgbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1WGjXLy61Sr7zl841/EHV4oA7eQBf3bOnN3ZbavBkcKFAws4BC2Z48mPlIIVgKpG84RxAhFd6gWZzNwYF/WfYNy0qDZmpGk5AxWakJvb1LRbSnNdjs5fHNrsumI/AJuiu1wXZQVB18Bq7FJC3wzahExGq223OFZJQ7RcrN+QaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tUPu3cpg; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7c78b520bc3so63772039f.0
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 20:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709267434; x=1709872234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9fQ7RC4xc34ND181p/Cmnn+gjK6g/XMfKjErmffW8s=;
        b=tUPu3cpgrCtuTUanD6s7x0yX9UwixVc2zjEkXaI+MHv6QDP5ThvUPs3OivBMvoTNoG
         UI6CwM0oETtH/knoI3SdjKPi6Sj2XnUy3TPojYAtWLh8g8gBorSSxjmQjApD0EX4x3td
         z2lA30h/h6Q0O4jJaccJuSmuFJm+bjlcDCkMT6ZCOzesSoYoPd4eFD+l4TFSOHbmNCQp
         6Of3JkaOq7kd7z6Qtpgo/R3q7YoACskF8KTlA4AYBCTn0kdxUPKyZ5g2KOG5INQBWLGM
         P05jVEW/jMoZlenvATohehDSuyg5TVtjxNlqNCa3B8wYqKyURHGr8wsW5LKJeBQEG3/k
         R2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709267434; x=1709872234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9fQ7RC4xc34ND181p/Cmnn+gjK6g/XMfKjErmffW8s=;
        b=E7ikrq5OmVfMdNMclUuNQ5FRkGRcUxYi7iaO+3BWUyER5gfKFsnbLpzyYSeP/0IAmJ
         Yzel2KCf6lhPJIcVBx7aUtA2JWwkp3XC5MVAs58dJqzhsoKIDyTVvtJgWP1ZCwzBxan3
         RNaIs9pukaz3PNiaJwKMHtDYXXouUUDRM4x2j9JXr6Dv4ipzEzL5OC+Zpy9qjzV6iLhu
         +tlqH2bDDhHpuD8WIXSHO/SFVMxxio9rutWd/mJzrTm8zWeI1uNvakW3lrEjKRdPitMy
         Jlu2TgR1/G9cFjJZT/xpfrKRDiiSq8cMNCoJu0Hs+ASqFXOCXpdJ0Zv/PTAPn3dmR4Ri
         aQKw==
X-Gm-Message-State: AOJu0YxA/BNebjOB1mlMM6PNw7T4cwYckNxfaZ7EUn6hAIM43R158mb+
	6BbDOE32XWgJLUsjD3McVkFHGCg3Bh477ifGQi3WW+j18wEkgxskJqyX7sjgLCKx23befEKKkpD
	ivPnOK7agIGTu1yo4m3Ue8YXl55a8EMth4WVURA==
X-Google-Smtp-Source: AGHT+IFpk9oSfyH0+nbWbG5EGwPri9Z/SnwPWj4nbuD7lxMy9Z3pXe9DZQfsb92pnvOjE1EJs2eRaPBwCygerDMkWJk=
X-Received: by 2002:a92:cda9:0:b0:364:216e:d1dc with SMTP id
 g9-20020a92cda9000000b00364216ed1dcmr909152ild.22.1709267433859; Thu, 29 Feb
 2024 20:30:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com> <20240301013545.10403-2-duchao@eswincomputing.com>
In-Reply-To: <20240301013545.10403-2-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 10:00:23 +0530
Message-ID: <CAAhSdy2+_+t4L8LHmYcJQZBGJHj6pyFm26_KwFBahFxz7eV1fQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG is
> been checked.
>
> kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
> from userspace accordingly. Route the breakpoint exceptions to HS mode
> if the VCPU is being debugged by userspace, by clearing the
> corresponding bit in hedeleg. Write the actual CSR in
> kvm_arch_vcpu_load().
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  arch/riscv/include/asm/kvm_host.h | 17 +++++++++++++++++
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/main.c             | 18 ++----------------
>  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
>  arch/riscv/kvm/vm.c               |  1 +
>  5 files changed, 34 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 484d04a92fa6..9ee3f03ba5d1 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -43,6 +43,22 @@
>         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
>
> +#define KVM_HEDELEG_DEFAULT            ((_AC(1, UL) << EXC_INST_MISALIGN=
ED) | \
> +                                        (_AC(1, UL) << EXC_BREAKPOINT) |=
 \
> +                                        (_AC(1, UL) << EXC_SYSCALL) | \
> +                                        (_AC(1, UL) << EXC_INST_PAGE_FAU=
LT) | \
> +                                        (_AC(1, UL) << EXC_LOAD_PAGE_FAU=
LT) | \
> +                                        (_AC(1, UL) << EXC_STORE_PAGE_FA=
ULT))

Use BIT(xyz) here. For example: BIT(EXC_INST_MISALIGNED)

Also, BIT(EXC_BREAKPOINT) should not be part of KVM_HEDELEG_DEFAULT.

> +#define KVM_HEDELEG_GUEST_DEBUG                ((_AC(1, UL) << EXC_INST_=
MISALIGNED) | \
> +                                        (_AC(1, UL) << EXC_SYSCALL) | \
> +                                        (_AC(1, UL) << EXC_INST_PAGE_FAU=
LT) | \
> +                                        (_AC(1, UL) << EXC_LOAD_PAGE_FAU=
LT) | \
> +                                        (_AC(1, UL) << EXC_STORE_PAGE_FA=
ULT))

No need for KVM_HEDELEG_GUEST_DEBUG, see below.

> +
> +#define KVM_HIDELEG_DEFAULT            ((_AC(1, UL) << IRQ_VS_SOFT) | \
> +                                        (_AC(1, UL) << IRQ_VS_TIMER) | \
> +                                        (_AC(1, UL) << IRQ_VS_EXT))
> +

Same as above, use BIT(xyz) here.

>  enum kvm_riscv_hfence_type {
>         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
>         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> @@ -169,6 +185,7 @@ struct kvm_vcpu_csr {
>  struct kvm_vcpu_config {
>         u64 henvcfg;
>         u64 hstateen0;
> +       unsigned long hedeleg;
>  };
>
>  struct kvm_vcpu_smstateen_csr {
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 7499e88a947c..39f4f4b9dede 100644
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
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 225a435d9c9a..bab2ec34cd87 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
>
>  int kvm_arch_hardware_enable(void)
>  {
> -       unsigned long hideleg, hedeleg;
> -
> -       hedeleg =3D 0;
> -       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> -       hedeleg |=3D (1UL << EXC_BREAKPOINT);
> -       hedeleg |=3D (1UL << EXC_SYSCALL);
> -       hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
> -       hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
> -       hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
> -       csr_write(CSR_HEDELEG, hedeleg);
> -
> -       hideleg =3D 0;
> -       hideleg |=3D (1UL << IRQ_VS_SOFT);
> -       hideleg |=3D (1UL << IRQ_VS_TIMER);
> -       hideleg |=3D (1UL << IRQ_VS_EXT);
> -       csr_write(CSR_HIDELEG, hideleg);
> +       csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
> +       csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
>
>         /* VS should access only the time counter directly. Everything el=
se should trap */
>         csr_write(CSR_HCOUNTEREN, 0x02);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..242076c2227f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>                                         struct kvm_guest_debug *dbg)
>  {
> -       /* TODO; To be implemented later. */
> -       return -EINVAL;

if (vcpu->arch.ran_atleast_once)
        return -EBUSY;


> +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> +               vcpu->guest_debug =3D dbg->control;
> +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBUG;
> +       } else {
> +               vcpu->guest_debug =3D 0;
> +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
> +       }

Don't update vcpu->arch.cfg.hedeleg here since it should be only done
in kvm_riscv_vcpu_setup_config().

> +
> +       return 0;
>  }
>
>  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> @@ -505,6 +512,9 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vc=
pu *vcpu)
>                 if (riscv_isa_extension_available(isa, SMSTATEEN))
>                         cfg->hstateen0 |=3D SMSTATEEN0_SSTATEEN0;
>         }
> +
> +       if (!vcpu->guest_debug)
> +               cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;

This should be:

cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
if (vcpu->guest_debug)
        cfg->hedeleg |=3D BIT(EXC_BREAKPOINT);

>  }
>
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> @@ -519,6 +529,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
>         csr_write(CSR_VSEPC, csr->vsepc);
>         csr_write(CSR_VSCAUSE, csr->vscause);
>         csr_write(CSR_VSTVAL, csr->vstval);
> +       csr_write(CSR_HEDELEG, cfg->hedeleg);
>         csr_write(CSR_HVIP, csr->hvip);
>         csr_write(CSR_VSATP, csr->vsatp);
>         csr_write(CSR_HENVCFG, cfg->henvcfg);
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

Regards,
Anup

