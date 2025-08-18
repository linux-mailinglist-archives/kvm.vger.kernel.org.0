Return-Path: <kvm+bounces-54889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D317B2AAE8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4587D5A0807
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCE7322759;
	Mon, 18 Aug 2025 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="UNyTYBSn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A6A322760
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526734; cv=none; b=gKjj88r9578wFbtRcikgLo+l+54Zq/nVuPYkmJiCqMV3NzyciUQvM2TbnDHi4gPiFczxU7JcwXQZb1EfbOlKj/3mpALcs2o3EqzMHOVphEctQjXeg5bQk8ujaAEnZMUT8QMGiCbGMLHLW3AVvESExUebbowK0LOLT1FOIpclFUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526734; c=relaxed/simple;
	bh=lfdMRn/uV9tLn3vOKRg4RShWFCamS+SfodjLk9JPqhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K1G1NRkMsXbElUAsB+AsROdhR+LQFOfvGhhGJP0/zoKNP4OV0XXHAVyhGaipDm8g0xbnDCfyLtyvjfIDxl8a44lH10j53scKcr13UCZ2is32vRFsBKdtc5Odxd9kmlOijwTndhsEf/4v+iMf8mTvv38dZ1jdx3v7lLEL6eoHz14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=UNyTYBSn; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e57010c2bbso25993765ab.3
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 07:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1755526731; x=1756131531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYOfhNBP3fLXotYDWFjRKcPRzvbpTIEaDDDJFw248X4=;
        b=UNyTYBSnCq6bBL8i4qE3QY30te5PrtZWG9vqca6Dub0SrFSUdW2kow4hfxudsEE7xp
         f1ep9hi/vRmnNG7jWdK/ld5JafJqijdE1l7Ol148DG7BTuWRha1JNyT59rqXOD5Dy/1/
         CTk6ihM0k5thQqCid2tKOUzQS8kj89CkFA5MVzvjpyZ+yP+hGmZE+HGY3CCbwpQ84CpR
         ttyHdh+0FjgT1oR6UW3pLGRTbv5/nGPnuCQ4WRlbaLnNSd9G8gBYarbyoXF56OvUmI3h
         utYtUVhIhDNLAtzFkcSUxpyK7Q5PI+lO2tlVu+mCT8ujllQ3n9eDi3WLgW/C0/BRd0Uc
         kDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526731; x=1756131531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AYOfhNBP3fLXotYDWFjRKcPRzvbpTIEaDDDJFw248X4=;
        b=YggWf6FrLXi7oZYCeBt1bwLAomRdGFrP2EP7TxP79UdmaqZv1uYHA7Vq89VH/heTaI
         4o6ivj9MpdKcT8RiSHaP5emrL6dXvF4OT7TLdTeeVTJfDOThoEf2sqgXf90jCY/9Ufqb
         5aZWOrB9oZ6PLx1Y5/w9pmti7OGAO4rILBD9GHJ26oKG4DVvE0VFrUR6dAIxsjAQ19W3
         wOL4PVdyiP/L+miR9OaVMX/4l2JiKkloDzmBN4tVGxvuw2bwxhrmSzQ8QN5BfS54OZuN
         QbLHvcQBrShRBzPxVlF7IOwkOT8W2kjlo2aVT6WU6Uwwbt4IhtmNCWUMSME8jVrcCRkG
         uHwA==
X-Forwarded-Encrypted: i=1; AJvYcCVhe/t8vCaUFjgFP0C4ChUFmjxQ3l2cjo1RJ2ElQDH8DlVs1HMqTZ6dknp2bhdkT5YbLLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YylCG3pBgdo16A2C6Zi5HSUyORyOZS6Odvhf/tE7Am0zsBkbhfi
	XBPi9tfvMyLJe5UpAK8r9l+WtsNJpVNCvt90owDTSi7TxlqbT7Cv+bmVFWaz1113N8gW5DkZhla
	YYVQb3hftXmigl1HHs35bMPQfnp6HQb4AJo4LsiUSQA==
X-Gm-Gg: ASbGnctR6SPcVdP/nBWgcoSklUSFqEKVjRIdvVLp51F4zm0u0rYfum8Z+BbB5+q9gzc
	ADrt6lmRZpHu8rqCUbBvRczO2P+pV05bTTKAT5z+20f2hXn0bTWp8p9jXAHNxzUABOxlkG2davF
	K2Cfv9raDKNrUt5gsQAHlE65snieI9+yfx6ZXMBVPhH++dSUEeVmbaZqZ12y/baOWlzAGFXp1d6
	1Pwdjs4
X-Google-Smtp-Source: AGHT+IFj/CqMCPnATLcRtW5vpKziqlXbmXhL2wmmOXkawwJHhjlum+QCcKdXnS+PQpPXSzExCCtbyPz6bmKR709p8ek=
X-Received: by 2002:a05:6e02:2148:b0:3e5:3ce4:6953 with SMTP id
 e9e14a558f8ab-3e57e9c4a78mr180851065ab.22.1755526731206; Mon, 18 Aug 2025
 07:18:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 18 Aug 2025 19:48:39 +0530
X-Gm-Features: Ac12FXxG0RSI1dIc2x76x-tlkVbmLS809vZnHg6zH0-npCpI10lDp4FSEF7jb90
Message-ID: <CAAhSdy3omyk7YGVHNV5mgR13cON1SxdpqsxGQJsWWE1Hoyw=5A@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within kvm_riscv_gstage_ioremap
To: fangyu.yu@linux.alibaba.com
Cc: atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@linux.alibaba.com, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 12:37=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
> guest interrupt file within IMSIC.
>
> The PAGE_KERNEL_IO property does not include user mode settings, so when
> accessing the IMSIC address in the virtual machine,  a  guest page fault
> will occur, this is not expected.
>
> According to the RISC-V Privileged Architecture Spec, for G-stage address
> translation, all memory accesses are considered to be user-level accesses
> as though executed in Umode.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Overall, a good fix. Thanks!

The patch subject and description needs improvements. Also, there is no
Fixes tag which is required for backporting.

I have taken care of the above things at the time of merging this patch.

Queued this patch as fixes for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..800064e96ef6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -351,6 +351,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t g=
pa,
>         int ret =3D 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> +       pgprot_t prot;
>         struct kvm_mmu_memory_cache pcache =3D {
>                 .gfp_custom =3D (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT =
: 0,
>                 .gfp_zero =3D __GFP_ZERO,
> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t =
gpa,
>         end =3D (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn =3D __phys_to_pfn(hpa);
>
> +       prot =3D pgprot_noncached(PAGE_WRITE);
> +
>         for (addr =3D gpa; addr < end; addr +=3D PAGE_SIZE) {
> -               pte =3D pfn_pte(pfn, PAGE_KERNEL_IO);
> +               pte =3D pfn_pte(pfn, prot);
> +               pte =3D pte_mkdirty(pte);
>
>                 if (!writable)
>                         pte =3D pte_wrprotect(pte);
> --
> 2.39.3 (Apple Git-146)
>

