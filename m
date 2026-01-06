Return-Path: <kvm+bounces-67145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FECCF965B
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 17:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4C74301EC62
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 16:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E7427F724;
	Tue,  6 Jan 2026 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="EGe3wF3I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBEB139579
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767717311; cv=none; b=bJ0Zr/ooB/NpZHbUEWXVsPY+8Zq7MPVCivY+9zGCOi/pD2OUo3g9A+FF/eLqzEYomHtzkClRzG4Y8J2p4LuJQ2p3iQASbOEtKrAKmJJSnjxUQoPxsqpsuTSggizX7UqFZkGr3ALroMl2727npOvPhT2JMCuoqwr0hpp6W1dqB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767717311; c=relaxed/simple;
	bh=nHZN3WhshIL9tfcBxNee2eEsjokCfxiC2OJfBl0pXjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sn/86oXiQuE8Z4X2gwnDsdTrVFOH1whU7h09fExDAOuMbZn+2vM0AdyhxIJRE8PRHmvchJLCcN0f/PyzeEloWhW7B38/LihATa5KwYjkKPZeNIt/txgO9uH8DuzU20J/kQ/fj0WHdhleyHYHuJCPldLsO4Dxf9N7fLB4VhotwSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=EGe3wF3I; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-65cfddebfd0so640061eaf.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 08:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767717309; x=1768322109; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNrz9UQpAZyojBAeX05y5M58klvOpfZIZjcce2E7lpQ=;
        b=EGe3wF3ILWaL5d6NKaW8vAqYW1irxTJdf9fUOWnsb+CZB34suIPK8XwTpQNOhtZH8x
         ke3NFMx9o6HbdJlhob+SrmTUXyKBsm3CFh4ZBDPfgI22NvSrMebLv0yz/kEvAgZJI0sW
         pEQztpi0fJoFV2TnJrhlbFjfDgVZpR0hQiLX7tzMhdwqc23upLVGfsYVM+g4CQYN47db
         DHgZtitqKGLtFgGfUrVks2Xs26GeZifXHXqOnB9BJI/oplfAqxZ1nIKMh9urQ9c4pkP5
         rJl9OGzd5mzsOBgdwMT6Uq8LB82UQch7tAT/T1+hwaKRgSzFPkQTchro9f+qdJDjTNsV
         H+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767717309; x=1768322109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNrz9UQpAZyojBAeX05y5M58klvOpfZIZjcce2E7lpQ=;
        b=UEkmXVIfIVDGB7Qi6WxkoeUALn1ia71uATPgAKQgX4WKvf7TMNAwi6UxA+lSDag8rF
         1NtjLZO4471xPXi60GPpTJGkBLr2LUVApCzA3LJiXI9lwnM7iqAdCoGdqzPAASZnUn+g
         tG9Fj4zwTK5qEQbRAEcXLRoEzlZ2KXszHJgj32Yg73XGAF7APhTHaBGjN9W4Ik0Nf2EH
         GzBcgr+oDuvTfZHQ2bWTuA0uC2pX1Qm5x5Rf5z8SG5n3YrXMs7k1FYSopouWRfc+TwLz
         RkSsnrqsffEtVmRFtXsNMpSYWx3vg/F5KGNeUL9lXZg+zSpK3up2p+lMFYgu2O9j1x95
         K1Bw==
X-Forwarded-Encrypted: i=1; AJvYcCX/0AF5Mi6rf2ubadqUdf1anDWww6iQPfkT+f6je1uOXyGmlD4l2oiHiQQoV5A6lhTSyxc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs8IYeCbSdODF+ek8do+yTiNHcwWab1m4gentd1mZfA9KB54kN
	Blh1B05HNJTmByhob4aCV6woeaL6Icgz8wDHIK8IOOf4qCdIG5seHz9bw+XBPjjrzMvf/pEQjYL
	JIqn8l7BZ0PujctHsoyxG6c6SHusOkoQhJJbd/LeRwQ==
X-Gm-Gg: AY/fxX4h8t3afGBMFKtBP67/sDa7TLMkC9uVi29ONEdF8YAuI6MonAFbjsWLLWcN1D7
	mT9mwBqQEJLoBdO39AsjMOXn9bPLSWOCpVbEAZUFQuNNigp2pEJqr0u9Cdj+hqQCrZQeootA5Bu
	UouqVSKp/fgxBEuU5xZSdILI3yq/YnaEEBYXQCZ3nKZKUVGE+XdTr/Z4CPoRMLM68T9G0oUudq7
	VCZc2ESgHGUzm3QL2Qj6FfWFuD8/fXjoD+9kmuMy/a6a5txjO6J76NJGFnRLqI28dUmmodo9KLK
	N4XLhdiZKvWtFjMSadOOPovJAACy3YTu7lSjyqyBze+3w0Hsn66qjpoLeA==
X-Google-Smtp-Source: AGHT+IEqXxTBeH3LP0fUVizISuCkdADz10TXUBGRVWD+OKCNI8kCKzHUOCYj5zq7rrrDTSe7deN3OOyJ+Sim2FJxOUk=
X-Received: by 2002:a05:6820:4908:b0:65d:2f7:6eb5 with SMTP id
 006d021491bc7-65f47a9ac10mr1471540eaf.66.1767717309018; Tue, 06 Jan 2026
 08:35:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106162848.22866-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20260106162848.22866-1-ben.dooks@codethink.co.uk>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Jan 2026 22:04:55 +0530
X-Gm-Features: AQt7F2om0UlRUlewDfBuWexms2k5z-xmHfO0JSMf-AgqjjVg_PjC4qOz0utW3LY
Message-ID: <CAAhSdy1w485+mTNCmX+KgQVnLr5iyDyPLm5+w2QwA+SxQ-2mVw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: fix __le64 type assignments
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, palmer@dabbelt.com, 
	pjw@kernel.org, atish.patra@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 9:59=E2=80=AFPM Ben Dooks <ben.dooks@codethink.co.uk=
> wrote:
>
> The two swaps from le32/le64 in arch/riscv/include/asm/kvm_nacl.h
> are generating a number of type assingment warnings in sparse, so

s/assingment/assignment/

> fix by using __force and assuming the code is correct.
>
> Fixes a number of:

s/... number of:/... number of sparse warnings:/

>
> arch/riscv/kvm/vcpu.c:371:21: warning: cast to restricted __le64
> arch/riscv/kvm/vcpu.c:374:16: warning: cast to restricted __le64
> arch/riscv/kvm/vcpu.c:586:17: warning: incorrect type in assignment (diff=
erent base types)
> arch/riscv/kvm/vcpu.c:586:17:    expected unsigned long
> arch/riscv/kvm/vcpu.c:586:17:    got restricted __le64 [usertype]
>

Please add a Fixes tag.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  arch/riscv/include/asm/kvm_nacl.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/k=
vm_nacl.h
> index 4124d5e06a0f..2483738029cb 100644
> --- a/arch/riscv/include/asm/kvm_nacl.h
> +++ b/arch/riscv/include/asm/kvm_nacl.h
> @@ -58,11 +58,11 @@ void kvm_riscv_nacl_exit(void);
>  int kvm_riscv_nacl_init(void);
>
>  #ifdef CONFIG_32BIT
> -#define lelong_to_cpu(__x)     le32_to_cpu(__x)
> -#define cpu_to_lelong(__x)     cpu_to_le32(__x)
> +#define lelong_to_cpu(__x)     le32_to_cpu((__force __le32)__x)
> +#define cpu_to_lelong(__x)     (__force unsigned long)cpu_to_le32(__x)
>  #else
> -#define lelong_to_cpu(__x)     le64_to_cpu(__x)
> -#define cpu_to_lelong(__x)     cpu_to_le64(__x)
> +#define lelong_to_cpu(__x)     le64_to_cpu((__force __le64)__x)
> +#define cpu_to_lelong(__x)     (__force unsigned long)cpu_to_le64(__x)
>  #endif
>
>  #define nacl_shmem()                                                   \
> --
> 2.37.2.352.g3c44437643
>

Regards,
Anup

