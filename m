Return-Path: <kvm+bounces-45857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B2FAAFB6C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA6C9B23459
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EA022D4FA;
	Thu,  8 May 2025 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KLrTbFlp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399BA22CBF4
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711153; cv=none; b=Fda2nD16h6nZYKomA3vcqvaQhcXQaNviiX6h5CNm3lamtS2aYuS1dAhW6e09OZjQgArwAcG0PVJNbv1VTN6g86zNp3vUMm7c01Q4mpw4tvRGqbAp5wyCShsv1vSHK1u5U0+7mrrvNPGWO5PAj6R+qnrUYErJYTqDfRYiHtrG61U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711153; c=relaxed/simple;
	bh=UaX7lHk6APGzrlNbZtyPi82/m8GJkmtjAztxLDCFxtM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Vddx9BCFmLvSxF6u4CBDfg13edtWeuInRgDfW0T7SyR/uIz0mjLynrc/08fhlrDNU/4mmFJHwNQEa1Or4UQ230N8HdxI7qDLUr80OEzk1TcrZttw0C2pb52MyS2ZAqbnSOR+thPFcDyPugrd4ubXkusGw3dFjW5zdn2HBdIezks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KLrTbFlp; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d16a01deaso384135e9.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746711149; x=1747315949; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ctop9M+S6pXp/ivb7RmdzyIsAM5dZO8eB9pvvIkCEbM=;
        b=KLrTbFlpR9vF/XiDJfMDK1ST0j/y9ahE3N6zOECj38aO3xGC8SSqB6BwFdrYf/2AjR
         Vk04OC7b0mTe1GYE8d+FEk0wXgArLp0AnZxLZcFsx0851Qz8qV8vdystFMGzGZbyU4RS
         X2rD5ZI6SweGZU+IGB9i6mUQ1UnQdpzKMG/cHqX7ncCQxgiMSqdTxhRxAj4W7Cb4DLvO
         JO7byWMbBm5+oFH1jeVkq0bMFq0Sh+4s0RnpRgqjUu5F+TE8tUVClYvtccDM5NtzLgQv
         dMbBHVPJ6hCPa0Q/6cIYBAHM0ANjIni0B4L3oR8aijJAuiISpIZWshRfgi3OtE5v/2XL
         hzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711149; x=1747315949;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ctop9M+S6pXp/ivb7RmdzyIsAM5dZO8eB9pvvIkCEbM=;
        b=I1ohQSeILJQQC6BLYIbh1bx9fNigYgLh4PR0DjxOVdIN2QQfbwBlfJO6Ie0Or6bxMS
         L0257jGIhuh0twh1FxF/lHyTnBDtp9B5hVCBPp/rgxU6A9wyCes3+625tn1miYqBH/TM
         x6dwklaNyR5XkY8v6P3EckmTzQlWy0FFBjRlnzQwAWxn19gxJ9tvmut14GnWAsYDEglp
         A2ccg7VAWRLNqJnTL/71vZE/s8s7tvq1GybDJGGhkh2GDi8D13I/C6cuYngjNevDTc+L
         fpUiQFTzBRBKeNZ1rBFunMJVZQNwsrJnmhQker2XohgXjW2To2fqolr8rBv8PlVkboQF
         pEfg==
X-Gm-Message-State: AOJu0YyoUlG3cnQNoF/GhAYd1K3NUaTBaYKzVTEMUJNdagtml7RBTKMN
	62xkFP1Nd3E1SVXdEbhHRxZ4zUHL9igLrw8hWLD3Is8Ksfokr2vfzuZUy9YobLw=
X-Gm-Gg: ASbGncurJ8s3L8qgB7rd8ccrQ0fSGl2QdhMOa/lAKdkAv0x5o+qAPrJjgycFk+ykzS1
	2CTF1iut0WUxe/+mOjvkWMhjlJ2BUKzpqBtk2Dn5Aw0TggLAF62Hej6Wx3VAsLfADJ+LViQ7mPI
	/Y1CmAtnvZ9vbk3lSnSeiZyy/zU/LnOYg6ZgbCgFfZCDmGepUro5fjMt/RQe39Y5obXrKk41JU+
	BpG1ELCRNPFCGof7QrAS5L5nqIS0EBvrRBri/3RJM+VhwvaMKDLSce9rFBTI+puMSSUdQ4Y7JVp
	THpD4HtnGwgdzX4poeRsWZMTHaBxuA4GmvkvbONOA8bMAEn7
X-Google-Smtp-Source: AGHT+IFV8Gdwh/t9ZunwZV8yC9Gjd4YDqTg8K4dFRuyEe/kGcOgQumaKBu9osZaWckRfANKTr0Qn6g==
X-Received: by 2002:a05:600c:cca:b0:439:a3df:66f3 with SMTP id 5b1f17b1804b1-441d44e57d6mr24537645e9.6.1746711149535;
        Thu, 08 May 2025 06:32:29 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:a451:a252:64ea:9a0e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd32b0c8sm37984755e9.3.2025.05.08.06.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 06:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2025 15:32:25 +0200
Message-Id: <D9QTFAE7R84D.2V08QTHORJTAH@ventanamicro.com>
Subject: Re: [PATCH 4/5] RISC-V: KVM: Enable envcfg and sstateen bits lazily
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atishp@rivosinc.com>, "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atishp@atishpatra.org>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com> <20250505-kvm_lazy_enable_stateen-v1-4-3bfc4008373c@rivosinc.com>
In-Reply-To: <20250505-kvm_lazy_enable_stateen-v1-4-3bfc4008373c@rivosinc.com>

2025-05-05T14:39:29-07:00, Atish Patra <atishp@rivosinc.com>:
> SENVCFG and SSTATEEN CSRs are controlled by HSENVCFG(62) and
> SSTATEEN0(63) bits in hstateen. Enable them lazily at runtime
> instead of bootime.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> @@ -256,9 +256,37 @@ int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm_v=
cpu *vcpu, unsigned int csr_
>  	return KVM_INSN_CONTINUE_SAME_SEPC;
>  }
> =20
> +static int kvm_riscv_vcpu_hstateen_enable_senvcfg(struct kvm_vcpu *vcpu,
> +						  unsigned int csr_num,
> +						  unsigned long *val,
> +						  unsigned long new_val,
> +						  unsigned long wr_mask)
> +{
> +	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_HS=
ENVCFG);
> +}

Basically the same comments as for [1/5]:

Why don't we want to set the ENVCFG bit (62) unconditionally?

It would save us the trap on first access.  We don't get anything from
the trap, so it looks like a net negative to me.

> +
> +static int kvm_riscv_vcpu_hstateen_enable_stateen(struct kvm_vcpu *vcpu,
> +						  unsigned int csr_num,
> +						  unsigned long *val,
> +						  unsigned long new_val,
> +						  unsigned long wr_mask)
> +{
> +	const unsigned long *isa =3D vcpu->arch.isa;
> +
> +	if (riscv_isa_extension_available(isa, SMSTATEEN))
> +		return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_S=
STATEEN0);
> +	else
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +}

The same argument applies to the SE0 bit (63) when the guest has the
sstateen extension.

KVM doesn't want to do anything other than stop trapping and reenter, so
it seems to me we could just not trap in the first place.

Thanks.

