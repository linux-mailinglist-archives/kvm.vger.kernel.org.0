Return-Path: <kvm+bounces-34555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BFDA01523
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 15:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 569437A1C58
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 14:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6641E1B87C6;
	Sat,  4 Jan 2025 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uBxpycDE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FF156C6A;
	Sat,  4 Jan 2025 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735999493; cv=none; b=lj15c4p665Juvn/XYGJlUZkIjErcOrPeK8CsQGZjLNA7njIKshz8pwG43IQwDHC0GVV+RVxzLvBEpoIhDown/CcJ5L/bsZAMNy1Ynaui2xcW+Q0yNfJMfLLwYx61Hhd0YifDpUOt6B3ZxfThlvP7cqYCysNS9HxJzdIpplrUe1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735999493; c=relaxed/simple;
	bh=KYmyLdM4eK3NJuL/D9J9sGWeFSSBEfPKQ86wmsTb92s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SywTe0ZIn+fgO5qSb7rTFwgIr5J6s8A3fWioQyAIeQ8ucTESQVXPeoBfmXFCbRjqbFXDB4Yy7H6vf6SuNNxRbYZFnlPGgisac4plh0mag+0YrMi3Xzeb16oVwFfu8d8Jml2QgcZO538OO4Xcw5WWjiakAJxJA+8u4qm1MYXvCh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uBxpycDE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED6DC4CED1;
	Sat,  4 Jan 2025 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735999493;
	bh=KYmyLdM4eK3NJuL/D9J9sGWeFSSBEfPKQ86wmsTb92s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uBxpycDEIG79sXSfNEcQEyBreshROi3jEkpt3SJLYlOruXjN9/HZ3HmK1ucS/Kqrv
	 KhWXREMqWwH/qMHSsNqai++xCTVQ0/tQBbiZnLeMaCs+XOOItlebApwZh2dlZJAooi
	 6OcPlLXcLzXfVLI9O06Wa6r3nO9gF/RlGhX1epmXpmRral4BFgURk0Cz/esFJnd5Kp
	 3fiLek5U1YsyVzwTsjUGe4s5w1St0J4k3htQKw8C7ZQXE0dMDY43VH0T/Yq8ZYMFI7
	 47V5WYx0I/4uIe8H/IfZRNNKy3G4bgiNPxmEi8LZhSS0FaCN02d7rNZ2mW65/Z1/h5
	 UvPOpuU9PG5KQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so24322379a12.2;
        Sat, 04 Jan 2025 06:04:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV+X+gbvf6yCZDS8tWdnxcocpFjvySCRkybB05jEvJhXgIOraU+7E500kY/9ppAHk8ZPPQ=@vger.kernel.org, AJvYcCXERu9JZ78RVaAeOqlJizjFWIBVfQS+XlSzfkyDXs7y5tbYxAMPkLa9mKliObjXZqcHXpaYErKv2+Quh2AJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzZz+Aa71WQ69QQZ38zJaj14rC1I4Y2Yw9DnGgnpFoBWJGBKLB9
	fyGmwW9mr8HZtCqzZF9XOSYj2oBXE11qEeXM6SfhS8JallDD3zUR0zdA7nsDVPSgoiIPDrRva3R
	AFN/4JgGUSdnlnwhuBFCqZMsDXGY=
X-Google-Smtp-Source: AGHT+IE7eaiNLP8/CVkaV15LbcX2f8QDKfQ+WeBBb0Gd4pKtD9SZTUULOuHHfGeCOVy2gLiZWePDtz6XgNayapI3PeI=
X-Received: by 2002:a17:907:9805:b0:aaf:117f:1918 with SMTP id
 a640c23a62f3a-aaf117f1d51mr3134184466b.5.1735999491616; Sat, 04 Jan 2025
 06:04:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250102083625.2577378-1-maobibo@loongson.cn>
In-Reply-To: <20250102083625.2577378-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 4 Jan 2025 22:04:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H705XKtA0CrvWU5pneHcOST7WFWS=JTSc3oESDwvjxG-w@mail.gmail.com>
X-Gm-Features: AbW1kvYuv0xuOTS1EoqQW6oulAkjt_am5x2Mn1kJKws-8T1S3xFKhRWfRg40M7Q
Message-ID: <CAAhV-H705XKtA0CrvWU5pneHcOST7WFWS=JTSc3oESDwvjxG-w@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Clear LLBCTL if secondary mmu mapping is changed
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Queued, thanks.

Huacai

On Thu, Jan 2, 2025 at 4:36=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> Register LLBCTL is separated CSR register from host, host exception
> eret instruction will clear host LLBCTL CSR register, guest
> exception will clear guest LLBCTL CSR register.
>
> VCPU0 atomic64_fetch_add_unless     VCPU1 atomic64_fetch_add_unless
>      ll.d    %[p],  %[c]
>      beq     %[p],  %[u], 1f
> Here secondary mmu mapping is changed, host hpa page is replaced
> with new page. And VCPU1 executed atomic instruction on new
> page.
>                                        ll.d    %[p],  %[c]
>                                        beq     %[p],  %[u], 1f
>                                        add.d   %[rc], %[p], %[a]
>                                        sc.d    %[rc], %[c]
>      add.d   %[rc], %[p], %[a]
>      sc.d    %[rc], %[c]
> LLBCTL is set on VCPU0 and it represents the memory is not modified
> bt other VCPUs, sc.d will modify the memory directly.
>
> Here clear guest LLBCTL_WCLLB register when mapping is the changed.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/main.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 396fed2665a5..7566fa85f8e7 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -245,6 +245,24 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
>                 trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
>                 vcpu->cpu =3D cpu;
>                 kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
> +
> +               /*
> +                * LLBCTL is separated CSR register from host, general ex=
ception
> +                * eret instruction in host mode clears host LLBCTL regis=
ter,
> +                * and clears guest register in guest mode. eret in refil=
l
> +                * exception does not clear LLBCTL register.
> +                *
> +                * When second mmu mapping is changed, guest OS does not =
know
> +                * even if the content is changed after mapping is change=
d
> +                *
> +                * Here clear guest LLBCTL register when mapping is chang=
ed,
> +                * else if mapping is changed when guest is executing
> +                * LL/SC pair, LL loads with old address and set LLBCTL f=
lag,
> +                * SC checks LLBCTL flag and store new address successful=
ly
> +                * since LLBCTL_WCLLB is on, even if memory with new addr=
ess is
> +                * changed on other VCPUs.
> +                */
> +               set_gcsr_llbctl(CSR_LLBCTL_WCLLB);
>         }
>
>         /* Restore GSTAT(0x50).vpid */
>
> base-commit: fc033cf25e612e840e545f8d5ad2edd6ba613ed5
> --
> 2.39.3
>
>

