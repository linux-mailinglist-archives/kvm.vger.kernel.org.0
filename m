Return-Path: <kvm+bounces-49268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B53AD71E0
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F3543B481F
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 13:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5459244677;
	Thu, 12 Jun 2025 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="USL7PAmy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11B23D2AE
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749734696; cv=none; b=fYEPDwFXm6aI3SKrfL1YQI1YwMBEnhLSbZv9p20kbrEw+9pPp8250PreRNKSun/tK3XvGNamWIHKByZuWtrXzFs0di86YU5PL4aIfX662BXmgAiT6RxJeSIjRKBGhJm0pCp3rns1EHc6P8mYtuNAAEuswBv/oAX2UcqMlmROBHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749734696; c=relaxed/simple;
	bh=nSjx51XwsDM238FSIikQC+yI/Iljj0NBnR2BVO64huc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZQiY6FFUk73U6yAABFkxGmbTkWSuCgovNBnF7Np8mZA2obZlh4388V3ZV9IMRURZBQATqXGUWPJX9RcMYps0M7Bt9ZbZLojypNPiLHOlsZNxggn0GLE1KEdjf0ukNX22V7iZwoy533/Kji4MavT72b9gDozwG5BIKq46xNTVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=USL7PAmy; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7d3900f90f6so92958485a.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 06:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1749734694; x=1750339494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yO42KCFFAU1JaE5snqlMD+WeNGQUfTluFPre84YIRbg=;
        b=USL7PAmyjBqjvLTTZ0N7ITv/cMyLL/ILxBJdSWH5hw0LBRwJik1N7ohefT3h/drDIg
         mIeL1iWWS4F4aTMqLU+BEp2/Z3bOzTQf9inqk8cZhqM5dNRNwjBbNnEmNSuQAQ+9S9YH
         q1pzlGs5zBKIt8wiEr3qvX3LmaXqh4KlTN87e+7gO+f1ZbtP8f3u94iwBZ6dxNEZvsQz
         3MPGVksFhtrDEyZtnJXSEVZmxsMUzuJDecfyxsX0hZK64xii5W2/FjMQJOqOOLIYdqEJ
         mP7byCXZwyA7yFAbdp/u/DSOU4dAdeHW1XAnwvkHg6Wq7rJcfX4BEPt7vNbnjNXwnDAm
         A+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749734694; x=1750339494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yO42KCFFAU1JaE5snqlMD+WeNGQUfTluFPre84YIRbg=;
        b=DyLyZJadnL194SVO9uNqiA8AAML20mMk7lMI6PukiwYa5POjrWbTD4ZUe3zn21Z33c
         YqHQGXfOEGOCFLZ4QTZY5OxLQxgq9FNRivRG/DqQOwHMiAsDzbb9FrScY4ldWiDubtpm
         xAmAUf9qjt576C/udrnsFHN4JNyihJz1I+X13zNDqKiyIB483x4r9tHsi+rPhNLkd+6f
         93GqNMBvcAXMT7ZSV3Kj4+1LezGHbT3U04oFLmq9XLVhvIueyl159BtwJJ7rXZyDf8g9
         cwu1gQpaZOxA06/IHTr7bi8t8chMrRLlhb13F6KbgupVNzMuewTqedq6CLx5nLyu/EEB
         y9Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXTPy5BpWgGghPSoXbclewsM8F6Ash/Xp7Nt355Qnmnoe14OvQ/W0vy1ztvOre4jMr4nlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfWkpHUDuk/55cf22XbDKcvagK5b0q6yZ+y5JuC7cB5/21SOVd
	dTVDpNpgbQT6xSkKVotJh64/c+weMVlcvL+30jf4cw9oPUs0NQifsnrTDW/sC2c3ehjGf5qi8mG
	TaYGQa0htlA2TveDtWUYTAZ9uTxHigov8aOOtXNtjZaxQ8eP+k3NQ
X-Gm-Gg: ASbGncv0hiR2yUoXn1AfM+rFXXxOEPDqOkm7XJHy/VCt9/DTXu/xXplZf0tJQ9LQZOE
	vcGlAK4bn5OoKSX01N9DAKsUkM56ips0vHzAWtMDSL8zuEulS7jGI8lTAHlMpX56t76BeBStWbn
	vY5eKQjabDbeIlHL7vmXHFMUHM8fnvXq7zk5smKafN5sde
X-Google-Smtp-Source: AGHT+IEQ8/gBtL0M7nfyYdA1Q09mRUvmfJss0qUxYGME0df67gFne3lBmXn745akWi2zsvhSTtgFKgn2YK7q1n6XKl8=
X-Received: by 2002:a05:6e02:2783:b0:3dd:c40d:787e with SMTP id
 e9e14a558f8ab-3ddfa80be5fmr50613855ab.2.1749734681937; Thu, 12 Jun 2025
 06:24:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523101932.1594077-1-cleger@rivosinc.com> <20250523101932.1594077-12-cleger@rivosinc.com>
In-Reply-To: <20250523101932.1594077-12-cleger@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 12 Jun 2025 18:54:30 +0530
X-Gm-Features: AX0GCFu-M1pG9OAlM2fvsx7DbIa0rvE-jQkn0nAnykhBaLvlREw8Qci06BqSqC4
Message-ID: <CAAhSdy10FcQxWR3PCA0502AAEQ7S=TxkX-Jtuh+yVDh5ZgNnSg@mail.gmail.com>
Subject: Re: [PATCH v8 11/14] RISC-V: KVM: add SBI extension init()/deinit() functions
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Deepak Gupta <debug@rivosinc.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 3:52=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> The FWFT SBI extension will need to dynamically allocate memory and do
> init time specific initialization. Add an init/deinit callbacks that
> allows to do so.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
>  arch/riscv/kvm/vcpu.c                 |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 26 ++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 4ed6203cdd30..bcb90757b149 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
>
>         /* Extension specific probe function */
>         unsigned long (*probe)(struct kvm_vcpu *vcpu);
> +
> +       /*
> +        * Init/deinit function called once during VCPU init/destroy. The=
se
> +        * might be use if the SBI extensions need to allocate or do spec=
ific
> +        * init time only configuration.
> +        */
> +       int (*init)(struct kvm_vcpu *vcpu);
> +       void (*deinit)(struct kvm_vcpu *vcpu);
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *r=
un);
> @@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_=
ext(
>  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
>
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long =
reg_num,
>                                    unsigned long *reg_val);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 02635bac91f1..2259717e3b89 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -187,6 +187,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +       kvm_riscv_vcpu_sbi_deinit(vcpu);
> +
>         /* Cleanup VCPU AIA context */
>         kvm_riscv_vcpu_aia_deinit(vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d1c83a77735e..3139f171c20f 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -508,5 +508,31 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>                 scontext->ext_status[idx] =3D ext->default_disabled ?
>                                         KVM_RISCV_SBI_EXT_STATUS_DISABLED=
 :
>                                         KVM_RISCV_SBI_EXT_STATUS_ENABLED;
> +
> +               if (ext->init && ext->init(vcpu) !=3D 0)
> +                       scontext->ext_status[idx] =3D KVM_RISCV_SBI_EXT_S=
TATUS_UNAVAILABLE;
> +       }
> +}
> +
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> +       const struct kvm_riscv_sbi_extension_entry *entry;
> +       const struct kvm_vcpu_sbi_extension *ext;
> +       int idx, i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +               entry =3D &sbi_ext[i];
> +               ext =3D entry->ext_ptr;
> +               idx =3D entry->ext_idx;
> +
> +               if (idx < 0 || idx >=3D ARRAY_SIZE(scontext->ext_status))
> +                       continue;
> +
> +               if (scontext->ext_status[idx] =3D=3D KVM_RISCV_SBI_EXT_ST=
ATUS_UNAVAILABLE ||
> +                   !ext->deinit)
> +                       continue;
> +
> +               ext->deinit(vcpu);
>         }
>  }
> --
> 2.49.0
>

