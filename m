Return-Path: <kvm+bounces-45692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 759FAAAD639
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 08:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A50591B686E6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 06:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059E821147B;
	Wed,  7 May 2025 06:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tw13pxsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C034F1F3BA9
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 06:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746599915; cv=none; b=djyZoXakXYiuRk4xDJSXD7vHexIuDWZQgQqH+kLeYaMSroosr/rZLP8wkTH5nCKXvZ2obW6fZ+7R8WADOKMwO+YmCQLZkcn7k1qCUuZDIM8+7GXVbirQIXTmFROv/gbzyG8WQAonA8FCsbSvY46zueGE6GC9d8Zy75fotb2KF/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746599915; c=relaxed/simple;
	bh=FMz0xL1Cwnszn0V3OnOQdvE86LJBrAEHmyJ8pPb9gko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJ2yKX0S9wgkvMxgi68biTnC3mDNvAcEWsc01PTn8CFDN7Jq9iJ7tnQV4SpB4h8wzIft9uXDKRZbVM4zBlNNlkEnJHG8Mku17ImBQUOXjtnJFWJXyoyX7sdseYphCJpRet60Ps7j8SASiCZi4kChFdiT+Vo6dW3sDY27jOHs9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tw13pxsB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d4436ba324so57578305ab.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 23:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746599913; x=1747204713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLSCTSvU1Pu3KZzXKgSBgnw1+cmm1sdq2UzaECQAViA=;
        b=tw13pxsBDZFlG2oOiQZjyah41ZFT4uuuUUBkuVgBXTR/MycERvyapnQnUuW/wtjw/k
         OABCRMCq1tf5rdOqmu68OXQaNzZfIEp/UY5HTjymD6VNuFTi9SL8eLvCspc6TWhd52MJ
         Zgkp/ksmZTI/knVqvr38DfMxMsm3ZvtpP6dItf39Th3ROKv9qv9SZ7egg738reIKQdH1
         s73DYQljbAcMCV8ZUawvRDk1NyJeagKpXsYGnMOLm0AVLdvDX1KFYosBKGxr+SjtSvb0
         gwWd2c1ID9q2K3zGBTTI1VyHNS9efbIAagHxuUh0J1DmUNm5GabTExjdOJz19yo9ZjFE
         QVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746599913; x=1747204713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SLSCTSvU1Pu3KZzXKgSBgnw1+cmm1sdq2UzaECQAViA=;
        b=woF9wu99Rm0oJXRiUIGB/FOqcQw+v5sup4dqnkXki289J5sYBAAvoj0YAzB0t10D5a
         x0HNEv6U9K17KDYKFtU+VgsdbBrnu2GooEpTny9PrJY1eohiS4YyVXo/MzSNqZyT67fn
         U9Qb8+5bpInZzjWHdfk93kUgyUkxqVHL5bpMTS5+Tj8zE7p3g2wwB12TB8Tf32B5fUsJ
         qKg9sC1kDxPjarIaldQx6d5e0hY4piL3rJPgr8dU6HQmVAymH5UYrKWJ2I/R8r6DP+1W
         lW2azh+byl1FO9SS03H7N6pYHfv9T18EPypl/BAUAFX7dH2VLleHNFGBPxOp8teww9dD
         ZcjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiPkvHJYJOwJM5OR4uo7NCd/jTZcWdcDdU3iKNa7qEKtALFNHMJdhtoZYEEoCInYHbytY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx177Ns4McMNRAgzhbi/u8Ni4K1Zo0OCyRRXQkzNS4C1zvYDuae
	2wDXYPNXi+9dIVq9hAdBi+ayjDJP1lX54qiHhEzQauXTM24Z634B01AiGS955KhFOLUjCpo4V11
	qDQvmXv3aKtH9RNnto/kCAeHMv7vuqaV65rauvcdgDxDvD9Ed
X-Gm-Gg: ASbGnct8YkG3UT/WlikSoi0OF7k4W4uE87m+KugF7k7GCGcy8FXYwjg/ZGPWAqPPUX2
	WNVkA0hB4Wz++xJgjO0P80eBfqG51yc79aBraniLWQsZWlPHkThm3EyO5zl0QV5q9+0DQ8pA4mW
	VH+EjwTl8vg4t2gSA5md8A
X-Google-Smtp-Source: AGHT+IHf27rispqj66mqizfYO/3jAKoO4k+nD2tMDDWQ6j9J0hfCfqo5ejjOrQE39XLxzrAH6W+8xBqOHYZ/XCR2Qq0=
X-Received: by 2002:a05:6e02:3d83:b0:3d9:2ca8:dda0 with SMTP id
 e9e14a558f8ab-3da7393603amr23647845ab.22.1746599912818; Tue, 06 May 2025
 23:38:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250505-kvm_tag_change-v1-1-6dbf6af240af@rivosinc.com>
In-Reply-To: <20250505-kvm_tag_change-v1-1-6dbf6af240af@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 7 May 2025 12:08:22 +0530
X-Gm-Features: ATxdqUEEO9ElPqopLSdn1cGhHTcD6oP-eNKU_g5Vu-IabLPJnfhIVALu0OXu3ns
Message-ID: <CAAhSdy0pdqnUa-GWiGHG3H_J9=J2yGXcRLfzsZgDzaZv+6r=jQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove experimental tag for RISC-V
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 1:17=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> RISC-V KVM port is no longer experimental. Let's remove it to avoid
> confusion.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Queued for Linux-6.16

Thanks,
Anup

>
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 0c3cbb0915ff..704c2899197e 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -18,7 +18,7 @@ menuconfig VIRTUALIZATION
>  if VIRTUALIZATION
>
>  config KVM
> -       tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTA=
L)"
> +       tristate "Kernel-based Virtual Machine (KVM) support"
>         depends on RISCV_SBI && MMU
>         select HAVE_KVM_IRQCHIP
>         select HAVE_KVM_IRQ_ROUTING
>
> ---
> base-commit: f15d97df5afae16f40ecef942031235d1c6ba14f
> change-id: 20250505-kvm_tag_change-dea24351a355
> --
> Regards,
> Atish patra
>

