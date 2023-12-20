Return-Path: <kvm+bounces-4929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA64F81A008
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 14:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB3531C20FA9
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717EC38DD5;
	Wed, 20 Dec 2023 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZ3R/mVI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281D38DD4
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so9937a12.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 05:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703079788; x=1703684588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0VqvfM44w9Bp0l1Nb3eurGMgXjCyoVBwTkqclK7t8s=;
        b=WZ3R/mVI6sqq3gCCY6NpSWjknIS4q0PO83C9lnjIWA072tLA4F4l+dCdr2ZI9hMuxq
         XLPOe0mzoAfU/j7QhGKkTV/V1wvNEHheX8ovnmTKX+ymN0dGWI6gldMEayKInST6LgOJ
         z9HytLYPYiOcR/Osa9ffvjUWjuAAow9KTUEzSB2E+N94nSfO3x2LaDuNRjSDhibeIHS8
         cbrWE3Vkj2NRdoz1XeJMWM85sRJ0oWlJxgs4wtJwYBu/gXO4hazhqQoaBYBEC4sO5miX
         VvZslTWeitjznj63NmpAAFZ/tWYWQO6xOUAyLSmNbNyJJJNSoc6HNxUDGZwKUsNx32rS
         gCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703079788; x=1703684588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0VqvfM44w9Bp0l1Nb3eurGMgXjCyoVBwTkqclK7t8s=;
        b=lxKTkpR0vYfz3pUp45W8Cb3Jwc8Ed5R7u572Eizep8Ur4nu8yvt36SpoC/SO4tPxlj
         OIJZqlSIZ6duSzHqBMx317Q9siEL943seaw0k7W3dA1ZyFGsyg6tzHsacJXQQz4KkIkJ
         weopbqGlyw7epyv6e/ApBIEryM5utpSaywPKB0wsWU+lswHDzEC/+x8Bg5Disd2XOYap
         OfemFtfGeX+/Mr3onbNovF4G5MHpkWfQQ44nHy549nj7tR2rVLDMaLoc1JusNdserH1W
         u6Ud0mu3w5iTc6PDKzH/C5brENBWy00VhSLWitFxtlGENNv0tTFPygCBmk46fxFah8BM
         zVog==
X-Gm-Message-State: AOJu0Yz4nQWoBOnwRTk4ICzCub6Jzjy20hNB85PXmwrfTzUzT476ifJb
	WxnuQi5Ef8lVCn6seHhSz5DcyifBcLR1daw2SYkBjIu4OAtB
X-Google-Smtp-Source: AGHT+IELw9u7uHWWQfDyX3CsyCFGN4yXGPaBGMRfjMaZIcbDiU/640e/7PE0ly2BIWtB1hmfj1LfEEJyTMiphMDfxgc=
X-Received: by 2002:a05:6402:51d3:b0:553:faf5:6841 with SMTP id
 r19-20020a05640251d300b00553faf56841mr55787edd.5.1703079788330; Wed, 20 Dec
 2023 05:43:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com> <20231218140543.870234-3-tao1.su@linux.intel.com>
In-Reply-To: <20231218140543.870234-3-tao1.su@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 20 Dec 2023 05:42:56 -0800
Message-ID: <CALMp9eT=s7eifhmJZ4uQNTABQi+r9-JyjjUVt-Rj-B=y0+mbPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be
 translated by EPT
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	eddie.dong@intel.com, chao.gao@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 6:08=E2=80=AFAM Tao Su <tao1.su@linux.intel.com> wr=
ote:
>
> With 4-level EPT, bits 51:48 of the guest physical address must all
> be zero; otherwise, an EPT violation always occurs, which is an unexpecte=
d
> VM exit in KVM currently.
>
> Even though KVM advertises the max physical bits to guest, guest may
> ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
> Rejecting invalid guest physical bits on KVM side is a choice, but it wil=
l
> break current KVM ABI, e.g., current QEMU ignores the physical bits
> advertised by KVM and uses host physical bits as guest physical bits by
> default when using '-cpu host', although we would like to send a patch to
> QEMU, it will still cause backward compatibility issues.
>
> For GPA that can't be translated by EPT but within host.MAXPHYADDR,
> emulation should be the best choice since KVM will inject #PF for the
> invalid GPA in guest's perspective and try to emulate the instructions
> which minimizes the impact on guests as much as possible.
>
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be20a60047b1..a8aa2cfa2f5d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5774,6 +5774,13 @@ static int handle_ept_violation(struct kvm_vcpu *v=
cpu)
>
>         vcpu->arch.exit_qualification =3D exit_qualification;
>
> +       /*
> +        * Emulate the instruction when accessing a GPA which is set any =
bits
> +        * beyond guest-physical bits that EPT can translate.
> +        */
> +       if (unlikely(gpa & rsvd_bits(kvm_mmu_tdp_maxphyaddr(), 63)))
> +               return kvm_emulate_instruction(vcpu, 0);
> +

This doesn't really work, since the KVM instruction emulator is
woefully incomplete. To make this work, first you have to teach the
KVM instruction emulator how to emulate *all* memory-accessing
instructions.

>         /*
>          * Check that the GPA doesn't exceed physical memory limits, as t=
hat is
>          * a guest page fault.  We have to emulate the instruction here, =
because
> --
> 2.34.1
>
>

