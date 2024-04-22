Return-Path: <kvm+bounces-15454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7A28AC3A0
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B66BB211D0
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 05:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FB217C9E;
	Mon, 22 Apr 2024 05:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="QTcc38Hv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF318C38
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 05:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713763505; cv=none; b=ojcXcVKKyydpgJdUlYEPYzRfI4l2iQmpdvmMTuCzvhMOI335nFHFasmR5ZleHAe9hhcm7OL4VVrWPNE4ly8CgWLJuR5DQcDEofhXXfwdsDYtA1fTj9Oh41nNpf2cuqOSh10zcBIsMC8fnCsDefHEo4Mqmxu66eD1lBPPiAyK3s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713763505; c=relaxed/simple;
	bh=Ik9DM1QNpRlU+dZ0CiUmfKQUt5GK17SQR7pdunVTi1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HM8OXm1XDeu40C6g8h7fNfrx2abK+cx0lMX5vza7bGutpKKKZbbYQIBkPWpTcCfRzrm07Xcb9A5lShgrRfHUnsfZhohqmDjSq6Vm7EHxEbaTBeQJfYwAEt1A/EWYpw9hpN3Qm/keusG1HiECdiqiVCeYqzv6u5zursdfChUlXSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=QTcc38Hv; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36c0ef5f7ebso1263675ab.0
        for <kvm@vger.kernel.org>; Sun, 21 Apr 2024 22:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1713763503; x=1714368303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF7iMXOY4VDDCKv5qNAPNo7XCDSpEYvkOWLnZnfiQso=;
        b=QTcc38HvYi+gmcROXNRPsN2+ACsXYSft+1UQ15tpXXXGoGqZlrz19XifTGmH4TgnQY
         Zof3ACGEUZ/cK87E0+XDCuiBkB+WplA5CAaxOwnxx2V6JthzB5/C3AmcataAjo6BWJSV
         k1pmen2KHTwR3Y5Ygo9ScVSJySmr3kzaXiyX7NEEB/h1/u9sx00ZJxSuXeJO2lzqdAdw
         c0eIU6EUtvTPi4STzxTw558iLQ7E7vV6VNAu/O3RWFC6vK1UjAK8KccfdVgeDNooDh6X
         AgxwUxgEW9A1CiY4wFERXwV2cZoCBxCqzCRldZFr0WxJVeuOVubx6zV1g3e77iPEYgTL
         NmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713763503; x=1714368303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dF7iMXOY4VDDCKv5qNAPNo7XCDSpEYvkOWLnZnfiQso=;
        b=iD0tuccN8nZtRJGKrpJfTKI/mEONLl3m0b1Od7MTCvwihixkh0Wwo0SfBjgj3JrcvM
         V0qwe+oiNeP8pZQUqigkH6+dRZeJUo+oFn+bcgKt9MrDNsJp9Zsogs37h5ZzSiK+do1X
         fENcLTSbZLe+eudWP/Or2KT5PfFH8uKaF07Dc1SjgY9aBTtzcW+SeX3QJS6uBcn1I7Bd
         70EEe+X4xQS+Oui5na4P+bPD8HPoe9CF5Q3AHZSdYRI08tXmzufL9rUi3gTWs1mZ4+Zc
         c+9SnysOft/B7alLGRnl6BQIsgQgz/2jADxhY6YPLaehd6Lq1yEBcPrHdu2LLdspdFH+
         +fpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV8HvbfPHc/fKvmTA3mK/DEceHTFufZxAK7Jg9CLjSu6aRs4WOffWEju5Nd3IWgnY18ezWeYKV5XpLgiLAAVjVH64N
X-Gm-Message-State: AOJu0Yyi0TfgdCrAgXkpO89Dvm4vUz1oATHZ+ibawDJ4yXDf8p29LsN6
	RiOmbanGyVnYveeE5JslsWyES+XAHijxJ1w2GzBOCdgdUrGNvl8JcWlTELgvBXbAUXhCcmPhsWk
	onCtpWqauHE0XdbaFJ9/mMFd+ND4sIk3TlGw4/w==
X-Google-Smtp-Source: AGHT+IHdn2npWqT6eXE8OXOJ8aeE+1uvyLE2k3jLpLR2kMrW4luyMtoF2cYuLh1aaMn2GPPBLemb20goD4jLZbNz7Kk=
X-Received: by 2002:a05:6e02:152e:b0:36c:a46:e018 with SMTP id
 i14-20020a056e02152e00b0036c0a46e018mr5159166ilu.24.1713763503545; Sun, 21
 Apr 2024 22:25:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240420151741.962500-1-atishp@rivosinc.com> <20240420151741.962500-11-atishp@rivosinc.com>
In-Reply-To: <20240420151741.962500-11-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 22 Apr 2024 10:54:52 +0530
Message-ID: <CAAhSdy34VhGY3v9h3cw167MafKHOF1dL6zqB7Wi6A9Z4fo7ZNg@mail.gmail.com>
Subject: Re: [PATCH v8 10/24] RISC-V: KVM: Fix the initial sample period value
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, samuel.holland@sifive.com, 
	Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	Will Deacon <will@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 20, 2024 at 5:18=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> The initial sample period value when counter value is not assigned
> should be set to maximum value supported by the counter width.
> Otherwise, it may result in spurious interrupts.
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 86391a5061dd..cee1b9ca4ec4 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -39,7 +39,7 @@ static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pm=
c)
>         u64 sample_period;
>
>         if (!pmc->counter_val)
> -               sample_period =3D counter_val_mask + 1;
> +               sample_period =3D counter_val_mask;
>         else
>                 sample_period =3D (-pmc->counter_val) & counter_val_mask;
>
> --
> 2.34.1
>

