Return-Path: <kvm+bounces-8678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CAE78549A8
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:53:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 512A91F22C61
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A72F52F6D;
	Wed, 14 Feb 2024 12:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="GMN/CsU+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3F52F85
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707915088; cv=none; b=hafKB5kY3svZfnwj5uout/gydv9aBymAKkpbli789qAA7h/+L45Lh9s7XdmrDl3RSDKJlI5qDRjs/2dk60FPgjvWmCnT/Olu5grtTorCe7xeK47p2beU+ycmN5UFu+8DbuZPIHWmYeDCPyriq4pRK1mKu4shLYRkq3oagkgZmDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707915088; c=relaxed/simple;
	bh=NRKgQ5xd7aPjDmfzvh3+L8eHFdNy88jlx9DFG955+Dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JzlxfInkFKpF9F8aM6SF8r8nokZpQviBcVwpleVEjEKfQNq9a5cg0HhiE5W5AVWmKjv5YhWIyiP1b/XerWKQVGFRag+tIzGxo8H2/GceYAjPG6qjCYpXZkerUTEn8itF7Pi3YxMWOMqGaNnAVTyMMWfDBtZvL8Qu5mahotA3nUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=GMN/CsU+; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-363a76d0c71so28886545ab.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1707915086; x=1708519886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlE+5//qS+/xZnz7hlxef6HTqWg9D1lQXch4tJvR30k=;
        b=GMN/CsU+JtX/rxo+stTZpjzBVWaxS2Zjw8ryhnGudHOZuC7ryKiPBWNuofGyKdu8DX
         ziqitmfEG71A04j4AqFP6y/Pg4Ec9rAEuAw527zqjloO2YWG9aF6VIqMqm+tBckh6hlE
         2qWr2dJ7Qhw0vrzBEOScN7jZyBlqDBr3Ghu+WalhVEedMKZRsQnYIaFlOcD8Q0axbBDP
         UYdTnWyg9mTGYSA/RmbH8g9FMZspBd+PZUA/uZ5qt2qZWmHel6CaS4/nDOTK2AduGr7m
         HWuNs1SkPZdE4yiwZeuhEl88hSU1lu8g5eLxAlVJ2BLRW8d7Fail2SxeuwTFr6diRN3Q
         D9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707915086; x=1708519886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlE+5//qS+/xZnz7hlxef6HTqWg9D1lQXch4tJvR30k=;
        b=Lvpm0OdmlWKWRA+psAJtjq73GPCNfuqsbsd/bRnP+lXGFALjs/Q1bU7sc+x8Y1n7/m
         uYq3GUTBvRao70mM+xLOzb+74/sw/YA37tP6o4zPKBrR+R55YEC0lKLkN1tKg6/3iw/f
         M3a3xSly2Gm4MD3JzFwo8rsdvR9vrm/eJyRfLXf9sAZmGKFYjAFqFCqGU3flXF9+Zxon
         3/6n6lrx6GFYjF8gYiWMWcUC3P1mLopSJo0npxEFmJz1HMqZzfv0IEtQTbBJf9iKgkRW
         nF66PNvmDRQhrFvoRVyCKksTvfoLER7S01Vq+yrxVSV4g7ShHVpq7D36rXZ5kEm0H44m
         wMMg==
X-Gm-Message-State: AOJu0YzVMZ+S2ws48VAbfc66YXEQs9FM2PDSL42ULehWkX2tKW3gYvxH
	r+57CSS4lo8dc+53NtdlflsEHfqfLPH9d2LMqj4swwdf7lHMD4+iUmF8ogKDr4ATlWouwOJToUO
	FCD3F1r2a/hxacJMrq4KdIlWXHzbxr8APZq52MQza4cIKL1Yp
X-Google-Smtp-Source: AGHT+IH5toyAKQlgoY81U4oGqHLgZSdDjfNlcaKzl8FQBh03URGRSr3wa3VhmieTugA3aFbkkerPGoHhFFR6gmHxn34=
X-Received: by 2002:a05:6e02:52c:b0:363:c3d7:ad0f with SMTP id
 h12-20020a056e02052c00b00363c3d7ad0fmr3220365ils.28.1707915085769; Wed, 14
 Feb 2024 04:51:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206074931.22930-1-duchao@eswincomputing.com> <20240206074931.22930-3-duchao@eswincomputing.com>
In-Reply-To: <20240206074931.22930-3-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 14 Feb 2024 18:21:14 +0530
Message-ID: <CAAhSdy0xYr6jKRdYzTTGfTe26WUC352u1HFd727z7EXA+8AnCQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] RISC-V: KVM: Handle breakpoint exits for VCPU
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 1:22=E2=80=AFPM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> Exit to userspace for breakpoint traps. Set the exit_reason as
> KVM_EXIT_DEBUG before exit.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 2415722c01b8..5761f95abb60 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -204,6 +204,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu, run);
>                 break;
> +       case EXC_BREAKPOINT:
> +               run->exit_reason =3D KVM_EXIT_DEBUG;
> +               ret =3D 0;
> +               break;
>         default:
>                 break;
>         }
> --
> 2.17.1
>

