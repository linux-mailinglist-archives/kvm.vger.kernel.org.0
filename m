Return-Path: <kvm+bounces-13328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAF4894A34
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E2FB1F242A3
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C9B175A6;
	Tue,  2 Apr 2024 03:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1OCQV/0g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE6917548
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 03:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030164; cv=none; b=vAEk4NDJLL2GLJWezUTbYjUSQMO064rQWXWK2cpZm25uwnYmwUeNiA17o1cfDwIQx4yGrNqp5Wwk9rwL7U8RDHCEs4Js/SRYOVKlOP9Y/Ygig33lzay5kdeSTec6RF5vtZ9fQcqPPH3lROkwSlonz3f1ZmhefgpQGpBkZnwlesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030164; c=relaxed/simple;
	bh=13qqTVs5qvQTvhhGTxxwjNjpmFLya58KSTCA+sBtbg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWRfzAiqsHTFSs0BtS7u7LCV0Dz9b8u7ibVzaQFpRLgDKsEBAxxvkdZbibqaf7dfZvJJ2iEHXEWC7Jw7I+ufFk5sjhgkIGbyKTbb72hLt9C12XykN6eh+55eXR5/27CqExlFXpw+KZICYjzvRS7p8ykSUY0BvMxgzlFwWDYkR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1OCQV/0g; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7d0262036afso253785539f.3
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 20:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712030160; x=1712634960; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgzcT8diqD8SjMaUsHz0fbx+24xnpS9fs/KPTfrhIMo=;
        b=1OCQV/0gNF9vVstZkg1sVG9LUFVMgCYRdn6aapm4aYldBqeaiUf94NAIBuLcc/mATR
         LAyeb296iiWQ0/u01ikP0oYPA6oeHTptwlbUid3liOMXyLMxWMdMqNB7eH6fTGbgYCnH
         2TqKVbPbbVOw3YPSwR9ZGAC1io3fsgM/2YE3FxaeCHjhva+ZOspZ5r5YyQi3QUxSApLY
         CEHypVwmamRm4DxTxaKSQCtLV6Urf4b62q7IftSl1E6yJyI/ittpdJvD6emTFbiNbrvW
         70mQEhd6XLEjdlhaW8A5Jlw0BR5Ginn/mUzkMOAtYfCyqxxSHFdeKFswi5QvbK9YOEpE
         Ey5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712030160; x=1712634960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wgzcT8diqD8SjMaUsHz0fbx+24xnpS9fs/KPTfrhIMo=;
        b=ElLf5g2gdDJelz/CwGNeMeNpKMFycEh/QcLXjybHn/QPCOzYlU5WBDDZuSlx3ejM3b
         uw2xXYNwUs5JF4fnBIESm+WZq5q8Np40owMCecXY72uXwBD7sdsvrUwjklz7NAMNHZdj
         O5n22lfyIuNmpv0skfFS+6Q97+GqbMByt3HT+kXfsj+65kDUrgEZn/XccSphZ3YzyE+P
         W1Qzp3yLjsRNC3fwnSDEH8018NbOgOgeZFsezwtE95LNIPrZ4/LVVgtuIAFCvnjpmDH3
         iqMKgPKNhxLWFtQRpKfW03jtSx0JI9mzgOjGmOeaDmIddoeMNVqQkUaJwSl+DDZsxzRH
         HxLQ==
X-Gm-Message-State: AOJu0YwJFQtVq2D9Jbt8RNvvvoDFbpuOHyZgeV3VwFqASp9/DjI3VVDv
	BzmvpvoRbddoJv+9TSNwVXDsobiXvjiADy2+MxOFyOG00VAg83gbKBmcC6OOLSDLmCKIrwQVlvY
	f2T4zLYHDNj3dY+qezyeoOi72ROEp1NmGhhvFuw==
X-Google-Smtp-Source: AGHT+IHALddo3V+35o7QnzL+/CMio88GeGCy3s4b39RTlB3iCS82xZM+5xWJnMCTg5/1c+zXZeeOkYNYpEfA6mN4inA=
X-Received: by 2002:a05:6e02:3a86:b0:368:8915:2bd0 with SMTP id
 cr6-20020a056e023a8600b0036889152bd0mr14895266ilb.25.1712030160365; Mon, 01
 Apr 2024 20:56:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327075526.31855-1-duchao@eswincomputing.com> <20240327075526.31855-2-duchao@eswincomputing.com>
In-Reply-To: <20240327075526.31855-2-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 2 Apr 2024 09:25:49 +0530
Message-ID: <CAAhSdy0Cv23WDx=3H863rqeAdqQ5wbWZC=qFS=RFwR9VFbD_og@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	haibo1.xu@intel.com, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 1:29=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG is
> been checked.
>
> kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
> from userspace accordingly. Route the breakpoint exceptions to HS mode
> if the VCPU is being debugged by userspace, by clearing the
> corresponding bit in hedeleg.
>
> Initialize the hedeleg configuration in kvm_riscv_vcpu_setup_config().
> Write the actual CSR in kvm_arch_vcpu_load().
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h | 12 ++++++++++++
>  arch/riscv/kvm/main.c             | 18 ++----------------
>  arch/riscv/kvm/vcpu.c             | 16 ++++++++++++++--
>  arch/riscv/kvm/vm.c               |  1 +
>  4 files changed, 29 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 484d04a92fa6..da4ab7e175ff 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -43,6 +43,17 @@
>         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
>
> +#define KVM_HEDELEG_DEFAULT            (BIT(EXC_INST_MISALIGNED) | \
> +                                        BIT(EXC_BREAKPOINT)      | \
> +                                        BIT(EXC_SYSCALL)         | \
> +                                        BIT(EXC_INST_PAGE_FAULT) | \
> +                                        BIT(EXC_LOAD_PAGE_FAULT) | \
> +                                        BIT(EXC_STORE_PAGE_FAULT))
> +
> +#define KVM_HIDELEG_DEFAULT            (BIT(IRQ_VS_SOFT)  | \
> +                                        BIT(IRQ_VS_TIMER) | \
> +                                        BIT(IRQ_VS_EXT))
> +
>  enum kvm_riscv_hfence_type {
>         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
>         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> @@ -169,6 +180,7 @@ struct kvm_vcpu_csr {
>  struct kvm_vcpu_config {
>         u64 henvcfg;
>         u64 hstateen0;
> +       unsigned long hedeleg;
>  };
>
>  struct kvm_vcpu_smstateen_csr {
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
> index b5ca9f2e98ac..f3c87f0c93ba 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>                                         struct kvm_guest_debug *dbg)
>  {
> -       /* TODO; To be implemented later. */
> -       return -EINVAL;
> +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> +               vcpu->guest_debug =3D dbg->control;
> +               vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> +       } else {
> +               vcpu->guest_debug =3D 0;
> +               vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
> +       }
> +
> +       return 0;
>  }
>
>  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> @@ -505,6 +512,10 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_v=
cpu *vcpu)
>                 if (riscv_isa_extension_available(isa, SMSTATEEN))
>                         cfg->hstateen0 |=3D SMSTATEEN0_SSTATEEN0;
>         }
> +
> +       cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> +       if (vcpu->guest_debug)
> +               cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
>  }
>
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> @@ -519,6 +530,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
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

