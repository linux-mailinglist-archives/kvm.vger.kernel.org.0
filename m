Return-Path: <kvm+bounces-46346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60870AB53AF
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0C9819E41A5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3BD28D8D1;
	Tue, 13 May 2025 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="hTxXE5Ye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF840273FD
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747135097; cv=none; b=fmO6HLT25HQHt2YwN4Xmdg0xL//elmbXAAM6FA5AscpM3v00bory6OH6F0dKTzXBQyhyPFThhonXVf4ffy3iUwyMndoASPkKk/ZOKFkNMuZ5Cprd9lpV8fOkP2LMn6+B/g1nx/l9yM+T997ne7BFiOQIBXVziA6CRnslmvY/qx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747135097; c=relaxed/simple;
	bh=bt3PcsKgfQ9j3zmMb3mcRAdFY5r4VES5fQ5CB5RXHsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ge2jUCWABaBLWri7F3N3fqap0NmVuUypgaZ8ruccZ9cuZTih9Tv7nWbGfR+LpmCMfX0EuMR5ToimmUW+k+BICjQLlays4wVnk31jfrdcOy4jtCZ4zkVqh+6SArcpFvIbO+NVv4sEfBE5l94TRKKRDRUO8ZKPEZPiNWnYVN9aX3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=hTxXE5Ye; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3da74959554so14738295ab.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 04:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747135094; x=1747739894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CO3XD8l6ux1EVBnvjNxNYVBqO7/BMtxK8+QVey7D+08=;
        b=hTxXE5YekHmYrUAQ40gUa8ItCN/yJJBbt+CDr+YP21ggsb3iz2OZN3mzlMAAKS2csU
         Elo75Eus3DZgZGTfWb6cl3LbZGXbCpRe4uLyMPneJSU8g6sXm2w7MahT4w5W06aFI/ft
         1sMAgGS2iZZvcwhjBrsUQz4cfpvdrDyD3N6e9fqdlW3zuJ+14FOJDWpQ3h+rtdG5jsDJ
         z/1/iysfbz/acFMsEsm+p8IlYhEqhsDRjzW0AQrQ+kK2Ms0xZE8tyP9Hym95iXlEqjOj
         YA65in3hNmWNhOsK12HZGwTVk8ouFhyQp/kHwk/LNTBz2LZnVCugGcv1o88W9m3AS9ro
         gBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747135094; x=1747739894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CO3XD8l6ux1EVBnvjNxNYVBqO7/BMtxK8+QVey7D+08=;
        b=YJVtDRYiOXbUlGf6c7O/DrrgqzeDgLMJ64/ZVwdtCr6+8Ysu5ufrMNSdaSw2ADxp1a
         lyaKRwH2GOEdWaItiq+R9hebaiQhNBE5BR7SSMuPJWq6XYdEvg5U9z8nlk7qlP5bYrYm
         nxAO70cMtGktwdhHAgbzD6ToZeLy5KCKl3B6jaeXRWRNljpB6dG8XVMpJYBjdSIdoOHn
         VtgxnYDQH3yPAbOQ1NrgQZWjslCxWJfrg/ULlcCwchgtzIbSg2ynysNuncjh9W97x5hz
         ASuGUd1g3AN09MR/18l2QrBUaRAQfnQD/zUwzyEqT1ZQ6ZmMRJf1L0kQgktWFIjuSVBX
         V1Ew==
X-Gm-Message-State: AOJu0YwdkEwezFrAIPwxplnbItqEXmwu1Sgk/kCjrgUDvQTyvZtR+8ZX
	VqNqyHD5wjLUlY8HvQDN2UjWG1zN4JdMI9VIa0If18Nshrq34el4AcfjaydVCHxIz3q7HR4u923
	I8TXZCu8bzKpvwbWAZMwIT/kt3cE4JAOVTIRYvw==
X-Gm-Gg: ASbGnctfiQ5QVmeItZsDoCxbJSpdXh72lyRxHQGmh0BjsSAqIbksQ1uFl9pNUdejBX6
	gT34qzEVOH8wIpEFaj7cWENucPc9B/Co92IFiojB+4aN1VrvUgkW89P7w1dR0umxMd6+JQ9+n7K
	t601zWl3kvbp/iuQvrU22IqPU1jJeSeKntpg==
X-Google-Smtp-Source: AGHT+IF0TFlq7FI2UFso/yWVI99zcgMhkSX+i8735DmLyH2X4sWMpcDOU2yubNACzzbHeqk7+uSqM/W5xKTfdB5E+cI=
X-Received: by 2002:a05:6e02:2282:b0:3d6:cbed:330c with SMTP id
 e9e14a558f8ab-3da7e1efc2amr168845325ab.11.1747135093673; Tue, 13 May 2025
 04:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250512180407.659015-1-mlevitsk@redhat.com> <20250512180407.659015-7-mlevitsk@redhat.com>
In-Reply-To: <20250512180407.659015-7-mlevitsk@redhat.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 13 May 2025 16:48:02 +0530
X-Gm-Features: AX0GCFuh9Grm7ZDwE_uX_FG0oRRGo90WBh2IG8oJVp8cnWQQL4gcnv0Sdw9D2vw
Message-ID: <CAAhSdy3H8LaDHJq6H0rFirsWhC8tnE+bWwmWFtO8Eag-kcXcSA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] RISC-V: KVM: use kvm_trylock_all_vcpus when
 locking all vCPUs
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sebastian Ott <sebott@redhat.com>, Shusen Li <lishusen2@huawei.com>, 
	Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>, 
	Borislav Petkov <bp@alien8.de>, Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexander Potapenko <glider@google.com>, kvmarm@lists.linux.dev, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Zenghui Yu <yuzenghui@huawei.com>, 
	Peter Zijlstra <peterz@infradead.org>, Atish Patra <atishp@atishpatra.org>, 
	Joey Gouly <joey.gouly@arm.com>, x86@kernel.org, Marc Zyngier <maz@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Andre Przywara <andre.przywara@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>, linux-riscv@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	kvm-riscv@lists.infradead.org, Ingo Molnar <mingo@redhat.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 11:35=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.co=
m> wrote:
>
> Use kvm_trylock_all_vcpus instead of a custom implementation when locking
> all vCPUs of a VM.
>
> Compile tested only.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

For KVM RISC-V:
Tested-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_device.c | 34 ++--------------------------------
>  1 file changed, 2 insertions(+), 32 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 39cd26af5a69..6315821f0d69 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -12,36 +12,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
>
> -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -
> -       for (; vcpu_lock_idx >=3D 0; vcpu_lock_idx--) {
> -               tmp_vcpu =3D kvm_get_vcpu(kvm, vcpu_lock_idx);
> -               mutex_unlock(&tmp_vcpu->mutex);
> -       }
> -}
> -
> -static void unlock_all_vcpus(struct kvm *kvm)
> -{
> -       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> -}
> -
> -static bool lock_all_vcpus(struct kvm *kvm)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -       unsigned long c;
> -
> -       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> -               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> -                       unlock_vcpus(kvm, c - 1);
> -                       return false;
> -               }
> -       }
> -
> -       return true;
> -}
> -
>  static int aia_create(struct kvm_device *dev, u32 type)
>  {
>         int ret;
> @@ -53,7 +23,7 @@ static int aia_create(struct kvm_device *dev, u32 type)
>                 return -EEXIST;
>
>         ret =3D -EBUSY;
> -       if (!lock_all_vcpus(kvm))
> +       if (kvm_trylock_all_vcpus(kvm))
>                 return ret;
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> @@ -65,7 +35,7 @@ static int aia_create(struct kvm_device *dev, u32 type)
>         kvm->arch.aia.in_kernel =3D true;
>
>  out_unlock:
> -       unlock_all_vcpus(kvm);
> +       kvm_unlock_all_vcpus(kvm);
>         return ret;
>  }
>
> --
> 2.46.0
>

