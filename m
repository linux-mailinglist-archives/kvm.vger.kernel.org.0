Return-Path: <kvm+bounces-9859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B32808675D5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D8862860EC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DA286627;
	Mon, 26 Feb 2024 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcV106tS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA8680629;
	Mon, 26 Feb 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952295; cv=none; b=g2RBpkm4AIgfFPSxUEyr+rlyH9ql7tCO6q0bucuOkIDt10OxqL+f/Sk9k3PAr5Z2xb62QLnMxtCl2uU4I9XPEdRQGWQogBdxOOU8a51oNF9eExJgdKjEC1cG1qMMo54aGdL/MTdMQZBqYA4mhXDqyEEEsdQxmEVmb/n5GhgzuY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952295; c=relaxed/simple;
	bh=9hMw1pWZCMEGr6c/O5a2ja3PjJqhq7dZtedwhgnxJSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHnXWMFQcPyA8cV2EnRI/ihW+Af4sAxYKUUobh+MiSD4l2L+++xzVigjkpn4c12XW7qZ6pp+GBaZ0WgVRj2nHOyvaHxbFIEpfQGci2yvwMWiuFJutqLvkcZQ9q2dqjNYyVpkFA2IFzm9cZ9en46vU8nN9HH9RVq/70otk/s0Stg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcV106tS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F334DC433F1;
	Mon, 26 Feb 2024 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708952295;
	bh=9hMw1pWZCMEGr6c/O5a2ja3PjJqhq7dZtedwhgnxJSE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JcV106tSC9pQfMqBnrKI2AhSMuYnhRmbsaYExSV3BpCvlgXndRiLVa0inUPIjH043
	 UCFWRNaE8yPwKmk/J6ybUsCtLDviYzsADkAYGEXkLcu5jQRcdV3xJFB3S+0TvlkxF0
	 DR9JVXtP4DlqRTjiVjlf32UtJcX30V+eeZDOhZXBXPgP9JlJiH77xjrohhTEZ70lBZ
	 LXRmCTWRLQgSWM6jWylGDIcBAmIGKYDcPlJCZmiNjLgpsl5fadqJbdXgj/nWJACimA
	 FC2GviTPUvJmvAipmQQLp4K3rk3dG+yuysUSUTtogO8G4hdhSXsFupIccvRJtww85a
	 qRHwf3eK141cA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-512aafb3ca8so2909780e87.3;
        Mon, 26 Feb 2024 04:58:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWRUpCKjziCY2M7JbXBG3jJgaakcX9mdxdaH5+v6pPDsr8G6aQvKZim0G+cactnnteot1Tzr97HkNTLySWEc95QRTxzyEToyVErAH/e2SRftQ8oQ4fpDiMnlSBXaeZdF1tP
X-Gm-Message-State: AOJu0YwI5BadWRMZ+zfddE777EZtSAMHoRGXLuzr8VSSfnmdCkS1IkKi
	FAWpJ5EPOYuaInatUANdD6lBtUx2WzXQCbeEwA4tEgOPJ8sKuJZ2aCiSr4J8k15DxU8sU0gAueG
	yNeBNSkgLs/YiUXY3tr4yZ0zAvpU=
X-Google-Smtp-Source: AGHT+IHUAclGqfiEPEAMh7jRGiO7B5+ACzDWlgn4v4Hnf3VSqOQUlGu2yY0Qa3f/PbY4nZZKC1UTultRkuSU70vqmP8=
X-Received: by 2002:a05:6512:3d1f:b0:512:fb30:aae6 with SMTP id
 d31-20020a0565123d1f00b00512fb30aae6mr2813048lfv.30.1708952293160; Mon, 26
 Feb 2024 04:58:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112035039.833974-1-maobibo@loongson.cn> <b7c08e0d-bd7d-aea9-250e-1649e95599b7@loongson.cn>
 <fbd8b226-1972-322b-d884-bb41d262dd16@loongson.cn>
In-Reply-To: <fbd8b226-1972-322b-d884-bb41d262dd16@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 26 Feb 2024 20:58:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6wC95cgo=f2-kx6viSKUPo6Mty+Hrr7XJ=7pKJeHbQOA@mail.gmail.com>
Message-ID: <CAAhV-H6wC95cgo=f2-kx6viSKUPo6Mty+Hrr7XJ=7pKJeHbQOA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Remove unnecessary CSR register saving
 during enter guest
To: zhaotianrui <zhaotianrui@loongson.cn>
Cc: maobibo <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

LGTM, queued for loongarch-kvm.

Huacai

On Thu, Feb 1, 2024 at 11:30=E2=80=AFAM zhaotianrui <zhaotianrui@loongson.c=
n> wrote:
>
> Reviewed-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>
> =E5=9C=A8 2024/1/31 =E4=B8=8A=E5=8D=8811:48, maobibo =E5=86=99=E9=81=93:
> > slightly ping :)
> >
> > On 2024/1/12 =E4=B8=8A=E5=8D=8811:50, Bibo Mao wrote:
> >> Some CSR registers like CRMD/PRMD are saved during enter VM mode. Howe=
ver
> >> they are not restored for actual use, saving for these CSR registers
> >> can be removed.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/kvm/switch.S | 6 ------
> >>   1 file changed, 6 deletions(-)
> >>
> >> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> >> index 0ed9040307b7..905b90de50e8 100644
> >> --- a/arch/loongarch/kvm/switch.S
> >> +++ b/arch/loongarch/kvm/switch.S
> >> @@ -213,12 +213,6 @@ SYM_FUNC_START(kvm_enter_guest)
> >>       /* Save host GPRs */
> >>       kvm_save_host_gpr a2
> >> -    /* Save host CRMD, PRMD to stack */
> >> -    csrrd    a3, LOONGARCH_CSR_CRMD
> >> -    st.d    a3, a2, PT_CRMD
> >> -    csrrd    a3, LOONGARCH_CSR_PRMD
> >> -    st.d    a3, a2, PT_PRMD
> >> -
> >>       addi.d    a2, a1, KVM_VCPU_ARCH
> >>       st.d    sp, a2, KVM_ARCH_HSP
> >>       st.d    tp, a2, KVM_ARCH_HTP
> >>
> >> base-commit: de927f6c0b07d9e698416c5b287c521b07694cac
> >>
>
>

