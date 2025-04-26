Return-Path: <kvm+bounces-44399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 498FBA9DA19
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 609DD1BA34E4
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 10:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611122512D3;
	Sat, 26 Apr 2025 10:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqfannGs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4D52253BB;
	Sat, 26 Apr 2025 10:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745662838; cv=none; b=PCBPdDZPmAEHiFfULMLVa1vTNhwMMqVCLU7AtpCySggR341u8wFLuEHMAYVAbZ8q6z2y2N2stHOIAt6KhU6FjR36AvZ+FjLK34AtdfqQlPC3aNyZbNL3yC7SJowMRQBIJ7avYs1+qSbhs4fqlXZ5hFl1MPNbdTL0GoRAmE4yqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745662838; c=relaxed/simple;
	bh=J0IVOamRtrEwebpPssA/s7vqpaWQ0K5BTUXVlvbRbpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1ad9lKvJnR0LlkWC4jiKhviLcTCun1kgPjcXuXSZBvs1iLwyyP+3fptuSYzFsyraTgrmfhEeWlCXjLv6utzAbpTUd0sSesxOFnBoGwG6CcE+uzosNYmvasCjGL2d0LAzHftuUnB8fb4nuVq4DcarTn302I3tMdRD7nPzbf54Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqfannGs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B834C4CEE8;
	Sat, 26 Apr 2025 10:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745662838;
	bh=J0IVOamRtrEwebpPssA/s7vqpaWQ0K5BTUXVlvbRbpA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TqfannGsc847LZ415CcqamX2DzRFPG/745zA1n+SAdhRpMVH55xyPOVFUf0e+QeBN
	 yaVNjf0Wb3UnzaNcrrpF8AG9dy2eMm0Doq0iIBcVEWp7i8k87xmxqTExbzodS6HHZF
	 eh5hIHGFQXlhlMDgG5Ytm0KVs0xqc28pvq2IM4HDgDpsTvKqGgz5pItXYhubHg93pR
	 NcJ+bSCSgh5QQrIHBf77bt/zQ2REi6BvF/mQgipqzYahOCBmYBCkSKOgIBEUWjCYT/
	 FWKVd91n9joSvinH11KMqYaAk+HNg6+fgo0+KKfHAz10w+omRup0LGHFENTGMnmIke
	 Goxw0id/qclpQ==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso5974333a12.3;
        Sat, 26 Apr 2025 03:20:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWBFX6+iIF3F/BGNzD3kkE6b3lB+yskW0lBPUElprRrroPa1GhLnp7sQFTPPMxiKjpYEzw=@vger.kernel.org, AJvYcCWLm7tHkugv4rGjUFrEpo+hiUCYzAFMLmBaCIFO4iMuygtt4ydOevBn7nRb5+HaXeTd2XdPiAaPtHj2hhQh@vger.kernel.org
X-Gm-Message-State: AOJu0YySeQJoVlqN1SYBoIAg/LKCXX7u4ENktXeeG8e1Txlyugh+kFGO
	fqr6W52SZAo/vqOyXQoOO7dj80P8FmOy4v6Kbxm6VGghv0BmmbndUiI/yqjwc5jQ+EM33jyWebC
	ZwbfKGV6o+xqb42lYdmNfQ+Q5S6w=
X-Google-Smtp-Source: AGHT+IG0JSoI/9csQDToJsqixpc9m30oFxZhXnBHDawfqs1Hti0fHSWkHLQiIwPvqUOjeOS1ISkRnVT4USGgxCKmAPE=
X-Received: by 2002:a17:906:478a:b0:ac7:3a23:569c with SMTP id
 a640c23a62f3a-ace7104e2famr468282566b.1.1745662836648; Sat, 26 Apr 2025
 03:20:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424063846.3927992-1-maobibo@loongson.cn> <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
 <883cb562-9236-f161-71fa-0b963db22a11@loongson.cn>
In-Reply-To: <883cb562-9236-f161-71fa-0b963db22a11@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 26 Apr 2025 18:20:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5taW2fAGW8CQ7MF5wjW8nuYREcNd6SSmvBmCtoJta5rQ@mail.gmail.com>
X-Gm-Features: ATxdqUE83xWiQmsYV-4d8DwC7o1S1lTCjJ1Did9qTBk8OjCdGcuV70ezpTzZ0K4
Message-ID: <CAAhV-H5taW2fAGW8CQ7MF5wjW8nuYREcNd6SSmvBmCtoJta5rQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fully clear some registers when VM reboot
To: bibo mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2025 at 3:07=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/4/24 =E4=B8=8B=E5=8D=882:53, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Thu, Apr 24, 2025 at 2:38=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Some registers such as LOONGARCH_CSR_ESTAT and LOONGARCH_CSR_GINTC
> >> are partly cleared with function _kvm_set_csr(). This comes from hardw=
are
> > I cannot find the _kvm_set_csr() function, maybe it's a typo?
> oop, it is _kvm_setcsr(), will refresh in next version.
>
> > And the tile can be "LoongArch: KVM: Fully clear some CSRs when VM rebo=
ot"
> yeap, this title is more suitable.
Already applied with those modifications.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> specification, some bits are read only in VM mode, and however it can =
be
> >> written in host mode. So it is partly cleared in VM mode, and can be f=
ully
> >> cleared in host mode.
> >>
> >> These read only bits show pending interrupt or exception status. When =
VM
> >> reset, the read-only bits should be cleared, otherwise vCPU will recei=
ve
> >> unknown interrupts in boot stage.
> >>
> >> Here registers LOONGARCH_CSR_ESTAT/LOONGARCH_CSR_GINTC are fully clear=
ed
> >> in ioctl KVM_REG_LOONGARCH_VCPU_RESET vCPU reset path.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/kvm/vcpu.c | 8 ++++++++
> >>   1 file changed, 8 insertions(+)
> >>
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 8e427b379661..80b2316d6f58 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -902,6 +902,14 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
> >>                          vcpu->arch.st.guest_addr =3D 0;
> >>                          memset(&vcpu->arch.irq_pending, 0, sizeof(vcp=
u->arch.irq_pending));
> >>                          memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu-=
>arch.irq_clear));
> >> +
> >> +                       /*
> >> +                        * When vCPU reset, clear the ESTAT and GINTC =
registers
> >> +                        * And the other CSR registers are cleared wit=
h function
> >> +                        * _kvm_set_csr().
> >> +                        */
> >> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CS=
R_GINTC, 0);
> >> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CS=
R_ESTAT, 0);
> >>                          break;
> >>                  default:
> >>                          ret =3D -EINVAL;
> >>
> >> base-commit: 9d7a0577c9db35c4cc52db90bc415ea248446472
> >> --
> >> 2.39.3
> >>
> >>
>

