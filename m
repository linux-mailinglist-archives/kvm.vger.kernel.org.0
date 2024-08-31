Return-Path: <kvm+bounces-25631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BE5967244
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 16:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93642B22186
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 14:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4DB208AD;
	Sat, 31 Aug 2024 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSfAqcss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ED41F959;
	Sat, 31 Aug 2024 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725116172; cv=none; b=KNqZSoSCLAi9SsNL0eH0juhWv8Apt8u7RDLVVffQOmavIIsgc3buXgSr1EY/+acQFqN5gVCxtmkKVyOSadpF1XrbSwar9FnYhCG5ovAwaCptefvyvB4Wp1k5SiIpYlGvWXhj5GpUW3jQ4M3IZ50saro/cUPCWmXpGTWI1oHcuI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725116172; c=relaxed/simple;
	bh=Dq+eBER6Wi/OhVJxWmmHUAOjADJsYbcEDCDMPaluXCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WdF/oSYWwMUSlvW6729biEE+zaraKWAxqAHWxTHKtAaz43iaGlC8ypZzbRBXlgERwAUnC9WOGjBWgU5ARhkULLtKy/y2okcnbTO3mMjxb+jSwtfMBqw3iApoCf/uvEypOli34tJSxlfYToWd5BjurGdbK8COjUzgozw1gQ8MU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSfAqcss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7ADC4CEC0;
	Sat, 31 Aug 2024 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725116171;
	bh=Dq+eBER6Wi/OhVJxWmmHUAOjADJsYbcEDCDMPaluXCI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NSfAqcss9HgBbxBPIvFYAZdTe0DQOzeij/u8KjABx+4jbt6vXiFBkKRdix8yIxI1u
	 hSNVcdAfrp7SA9dq143rPXNhJbP7TBorXR+SWSFvAPIfBxi3fFFG+rhSJtCBZeiG+X
	 lyRtl4lpAJBRqzxKS/8nF52OdONtniDP6EPbXrz6p6LALIrD6IpCUrnAN/6EljKNhn
	 BP+63mpkQ51TlMHlyGF636IlWta1Mmr6fDg+QVPhqgi07sgN2PNSlhxH+pdWQr/guB
	 FdBr29Fc0kVh6lGTXx8jdtCwbk1HNxkIz5qwkv/21nj/FlOo0d+SNA8+YuXaK1KiZS
	 qZMyCZs8ixnnA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5bef295a2b4so4741632a12.0;
        Sat, 31 Aug 2024 07:56:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUK+dWWT7+GcgyljAK0B5PvErjPIdPxSwewHM0c9o2SJ+ORqL3HxKJr6jwh4o57dW9P6rY=@vger.kernel.org, AJvYcCV65rzV2KNWHgroOsO8YDBFeBV/71Y8d+fcc9voovz1qaBRjviN0Ewrr0dq8rTiRwvsxhVagB7kBvrYkaso@vger.kernel.org
X-Gm-Message-State: AOJu0YwBH98sAzN/nMa5mrWQov7akgx+Q1VyTxc042enbQKjUeF+ajve
	AK8LS2OS0ItpYc/oH0ej+IElihGFzoYIIRnLL9pesWIypbaXuTP75KEI6IgK4n6A/FBIwh7GY+P
	HN9LsGVBF6uUtvodYzjSm1EQx4nM=
X-Google-Smtp-Source: AGHT+IFxskF7lIdpRwknhT3nSB4OC5bYvD6oGoNWeAErn2EM+YplzZd8VvXwDHOFoE+yL8ykFvIt/M2XZRP6CbcuLfw=
X-Received: by 2002:a05:6402:4303:b0:5c0:a8b8:dd6b with SMTP id
 4fb4d7f45d1cf-5c22f8a1797mr6686055a12.14.1725116170311; Sat, 31 Aug 2024
 07:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730075744.1215856-1-maobibo@loongson.cn> <CAAhV-H6dFBJ+dQE7qzK8aiTjx8NFJtzPWzEGpJ8dm7v4ExD8Ow@mail.gmail.com>
 <e898b732-71d5-c16f-93a5-de630820f06d@loongson.cn>
In-Reply-To: <e898b732-71d5-c16f-93a5-de630820f06d@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 31 Aug 2024 22:55:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H55SMmYvWSsGc6dHX6Dw=4fMe0+QJpQ_kzHUaU1zdux5Q@mail.gmail.com>
Message-ID: <CAAhV-H55SMmYvWSsGc6dHX6Dw=4fMe0+QJpQ_kzHUaU1zdux5Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] LoongArch: KVM: Add Binary Translation extension support
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 10:28=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/8/28 =E4=B8=8A=E5=8D=8810:08, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > I have consulted with Jiaxun offline, and he has tried his best to
> > propose a "scratch vcpu" solution. But unfortunately that solution is
> > too difficult to implement and he has nearly given up.
> >
> > So the solution in this series seems the best one, and I will queue it
> > for loongarch-kvm now.
> Thanks. There may be requirement such as there is different capability
> for different vCPUs, only that it is a little far from now. We can
> discuss and add that if there is such requirement. Because of limitation
> of human resource and ability, the implementation is not perfect however
> it can be used.
I have merged the first two patches, but the 3rd one seems to have
some problems. If you send V7, please keep the first two be the same
and only update the 3rd one, thanks.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Tue, Jul 30, 2024 at 3:57=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Loongson Binary Translation (LBT) is used to accelerate binary
> >> translation, which contains 4 scratch registers (scr0 to scr3), x86/AR=
M
> >> eflags (eflags) and x87 fpu stack pointer (ftop).
> >>
> >> Like FPU extension, here lately enabling method is used for LBT. LBT
> >> context is saved/restored during vcpu context switch path.
> >>
> >> Also this patch set LBT capability detection, and LBT register get and=
 set
> >> interface for userspace vmm, so that vm supports migration with BT
> >> extension.
> >>
> >> ---
> >> v5 ... v6:
> >>    1. Solve compiling issue with function kvm_get_one_reg() and
> >>       kvm_set_one_reg().
> >>
> >> v4 ... v5:
> >>    1. Add feature detection for LSX/LASX from vm side, previously
> >>       LSX/LASX feature is detected from vcpu ioctl command, now both
> >>       methods are supported.
> >>
> >> v3 ... v4:
> >>    1. Merge LBT feature detection for VM and VCPU into one patch.
> >>    2. Move function declaration such as kvm_lose_lbt()/kvm_check_fcsr(=
)/
> >>       kvm_enable_lbt_fpu() from header file to c file, since it is onl=
y
> >>       used in one c file.
> >>
> >> v2 ... v3:
> >>    1. Split KVM_LOONGARCH_VM_FEAT_LBT capability checking into three
> >>       sub-features, KVM_LOONGARCH_VM_FEAT_X86BT/KVM_LOONGARCH_VM_FEAT_=
ARMBT
> >>       and KVM_LOONGARCH_VM_FEAT_MIPSBT. Return success only if host
> >>       supports the sub-feature.
> >>
> >> v1 ... v2:
> >>    1. With LBT register read or write interface to userpace, replace
> >>       device attr method with KVM_GET_ONE_REG method, since lbt regist=
er is
> >>       vcpu register and can be added in kvm_reg_list in future.
> >>    2. Add vm device attr ctrl marcro KVM_LOONGARCH_VM_FEAT_CTRL, it is
> >>       used to get supported LBT feature before vm or vcpu is created.
> >> ---
> >> Bibo Mao (3):
> >>    LoongArch: KVM: Add HW Binary Translation extension support
> >>    LoongArch: KVM: Add LBT feature detection function
> >>    LoongArch: KVM: Add vm migration support for LBT registers
> >>
> >>   arch/loongarch/include/asm/kvm_host.h |   8 ++
> >>   arch/loongarch/include/asm/kvm_vcpu.h |   6 ++
> >>   arch/loongarch/include/uapi/asm/kvm.h |  17 ++++
> >>   arch/loongarch/kvm/exit.c             |   9 ++
> >>   arch/loongarch/kvm/vcpu.c             | 128 ++++++++++++++++++++++++=
+-
> >>   arch/loongarch/kvm/vm.c               |  52 ++++++++++-
> >>   6 files changed, 218 insertions(+), 2 deletions(-)
> >>
> >>
> >> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> >> --
> >> 2.39.3
> >>
> >>
>
>

