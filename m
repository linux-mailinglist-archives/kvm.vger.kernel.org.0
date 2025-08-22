Return-Path: <kvm+bounces-55499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7AD6B31653
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 13:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10EB1AC0E9E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 11:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738A32F90E9;
	Fri, 22 Aug 2025 11:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="uczrKuiH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3846A291C3F
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755862148; cv=none; b=IX9t1fOai1RVyrILUAZMHdfYJi2oN+6p6ijYu4EfTfOMvZsAUnke/VdhzDIjG00JQlPHYYTjboB7Ey7dixh0Xswxen861ihRBGOiJLc70UcMoTuXK7UbTwIWiaOdbbBGd5mupK72HsiBdW7DZyy1XvdCufgpGEHT+V9QoZSj3DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755862148; c=relaxed/simple;
	bh=74WLWB2wpFFNY5jfwXbte9fVpaHxcpj8qGdUfhbQV/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljOiiLAIdhHCkHHgrJ73fKzgod0SeZJlthEKiTZrppdwc1ZG+JW4DoNfAJcY8xq/3QvP8rKYJb4JXk9SrxrZ6vkgBBe1El+rM8ZaRb6kBaBPIT4PdRgNMS3pEIVRussEg/PmTMLCR9nD7Gr9jn9s9WFQDrCzzQvN2F+0Ftu9rNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=uczrKuiH; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e584a51a3fso10244595ab.2
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 04:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1755862145; x=1756466945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAj4MTsX9crtFaSUyO+PrnGMFjFfbBShLF1OedjML3o=;
        b=uczrKuiHTenWAgl7w12WD+sdSpNE8/Xed/gFkQ59lKvIG4wQfMKQLP1kmItdOjgYBi
         nAh1rm6cbOstc2S+qK5s4ZOLbhVD6hCV2DAbOQKrK0TYZ5A+DgGjQKFvDWMDsjgPM0vq
         rbzQod5I6k/ri9jqmIfvIMr8UrQmbklJcIV7IRdJOQ0KkNP5lZWYQy4rxnvKmy/TgTNe
         NizcN1r4rki7biKn0seg+KOQOaTt6f5Mn6Oh7/x9pnMDQq1++fGSClSqnQTCI0lkntHj
         TQusPC0rZpkNyZgwDvv77wNWH3gd36JyBnnm8I1NlaUMTjeeuXE4LEzpxkk4whaLs2NN
         YtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755862145; x=1756466945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAj4MTsX9crtFaSUyO+PrnGMFjFfbBShLF1OedjML3o=;
        b=bHqlDptmyqArmzo8ut0iQKWSvYRXX34CG2TcEIWv8IBQOPVJyDZ5xFoI5vqRdM9tXh
         SYMnXZX7u7prZMxRbyTdDeknQBObrLlAr8wY7WWmIo+PCI4kV6G1KdPvV+3/vo9EfIKy
         6odzZ56AFf1e3WbcYsSv0gkXN7F9WYztvVNlZK1iBOJPlp+m+ltkeSvA7dpEBtPUNrFt
         gQX2xj9EcFtfLxAz37mcTcdzpqP0IhqZRG1XHa7ocdqZNXyFO22QxrstdbToaFFrWI2H
         bqErfp9KIOzh6gP8Q1/qaV0yepNSYD8AbmY8ckFjxbxdGyRtST5vbXdpSH6HPYZvHic5
         fKkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc01+x1Pd8h+Q3ixQ2P8dkE4fDfhbGH8ii5z1NXisi+SWAgEZbrWhunAqG2IBsrH7Kj5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNrem+ecqCMJ44PRrHu4THWTNewhsLHZuipOJlnpmNNKxbt6vZ
	pilSkwJ5S+L+N9v1kB0MK+3hqHHL0VcfnczQqfPkRYpiyqWZmLbxzoC70vcNXqrWoL1Q57+yyHe
	YpU2+mm9iapON/oQUaCWTVjeyoH2juNHHFOnC77k1ZQ==
X-Gm-Gg: ASbGncshVkMrlhc67Nwb6pW2FjPfbIgsZsoLoGp64oWkfiNxNBzPvIF+yF+c8WcOlE9
	JXIyZUUpXWCMW6Z+Fo19Xsbgg4BL0ONjHPtYlRFaz10LqZedGJULQr/n2DWBHK3VYuG+G2oZuzH
	LJfS20Xa3gjOln+yq+7FEct3/YGbsQ8HjHSwD84IyvFHbQc4sgfDx0yMQE31Mca+zH/qiHfjlml
	8WxecRf
X-Google-Smtp-Source: AGHT+IFotCEaG3Imylyjy2m0DQxnH2th5L/KRoKnw2C+LytW2vVJKqgXGAwa/u5DAm0MxjMWmuNiRe1PyZgcFc/tw+c=
X-Received: by 2002:a05:6e02:2284:b0:3e9:e4ca:8f0a with SMTP id
 e9e14a558f8ab-3e9e4ca9b34mr9579755ab.25.1755862145223; Fri, 22 Aug 2025
 04:29:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250805104418.196023-4-rkrcmar@ventanamicro.com>
In-Reply-To: <20250805104418.196023-4-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 22 Aug 2025 16:58:52 +0530
X-Gm-Features: Ac12FXzA7OqPPvuSEUi3YmGf4O7XQNOfsrf-wXEXFi1rcASEvUu6djRNFKE82bo
Message-ID: <CAAhSdy1OcQBgV6T5z0K5mMv9pr23_oVVEJpimdzDjgAN3BhYeg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: fix stack overrun when loading vlenb
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 5, 2025 at 4:24=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> The userspace load can put up to 2048 bits into an xlen bit stack
> buffer.  We want only xlen bits, so check the size beforehand.
>
> Fixes: 2fa290372dfe ("RISC-V: KVM: add 'vlenb' Vector CSR")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

Queued this as a fix for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_vector.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
> index a5f88cb717f3..05f3cc2d8e31 100644
> --- a/arch/riscv/kvm/vcpu_vector.c
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -182,6 +182,8 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vc=
pu,
>                 struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_contex=
t;
>                 unsigned long reg_val;
>
> +               if (reg_size !=3D sizeof(reg_val))
> +                       return -EINVAL;
>                 if (copy_from_user(&reg_val, uaddr, reg_size))
>                         return -EFAULT;
>                 if (reg_val !=3D cntx->vector.vlenb)
> --
> 2.50.0
>

