Return-Path: <kvm+bounces-50310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED92AE3FBE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECD763BFCB6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7418A258CE5;
	Mon, 23 Jun 2025 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Cwfwesk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAAA257AC6
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750680767; cv=none; b=cx4t83YrDdIrDpvTKQmkzSy/mLZjvbURfVCrRyFOwpQA+GrVwST5S0APDG+OjdCcDXLXc44lzRs0N8CwZhwb8hMD0sUJJSb4tQdq+iZtH73hgMsfhjrxYg/oWiIIYpoqomImTMio9+S9CCHAch+jypajz4pa6GqFc2zwsqhGYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750680767; c=relaxed/simple;
	bh=f+PlxvlYNV73EmEGSpMuoIOzazgAgDQRPjz34OV9/Zg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jExkeZ74laghbMrzec2cAOjUwHmI0bBBk0cdyySvt/8G6R9uojwLuQEme5vg5opJV9dHYeWqojM8tp+DJ1fHLn9OVbVBSkCKgIGznKTZG51FtRd1g/6IPAdw9uS7+vGlgka46nhAGdMdru8LaSDV8qOm409zZHApg+c9wuHOhQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Cwfwesk8; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3122368d7c4so3464561a91.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750680762; x=1751285562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHyOQjUXQ/n7o6SDLI9e+lRQsNueNKsItK2jIA0gB9c=;
        b=Cwfwesk8mv4t1j5XCd3uAZavQoAy0tPVCrZkTk15k6GialZ3riFxEChFl15O3h+VP3
         CN7NOyWfb6h2Uf915hdu0RIkWDyHekYXargoEw3zjyMS63uriZU/SV/c5oJbSIP3i6Mt
         yPNXLmMsSj+SS1HkHIqmxZYggoLY8EMbeLlUEd/VPIih8hvbPfOiNakyG5+b0Wwe7tR8
         BgDkML5kPMns1boSTJgzocR1+38Fwu49+FAp9DRLdOMBPoxiv7IltMQth9chbBwpR/v6
         tmDAw6zSbWlnQMsffvExrnmcgsxV+ghwZScfeMmmDv3pDyAL9yGFfEC7o9gwaDxfVeC4
         Ktdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750680762; x=1751285562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHyOQjUXQ/n7o6SDLI9e+lRQsNueNKsItK2jIA0gB9c=;
        b=mO8E8VZrtCIxHOaAL1DQwQIDLLdcmiwvw3i1hql2nj027t9uz5QY3T9HjEST/NJlrA
         CuUWcekn/UjGiyGHcuANLro9m2iPwwv+9sgoyNUq8dbT8jiDoK5HMt2vlrMCvZkFlBS2
         joHa2b+sndvBjNpMhrqSJtPY6xIRXfdfcsaugyTkqD7ApFtL2Ws+VMrodBW7kcSEsxCz
         zVkO3aq9/u9LBxkZ8Vfcb/f42HoFCdq52uuCsKomuaJIy46gi2ouIDKYpiGUof8s3klh
         Y3OWhHZPDIsNIaL/rp6ajCZA3OxS4tmaOfXFk5468bHtMwptqaecxoEGZfWv0nNxiVdI
         0sRA==
X-Forwarded-Encrypted: i=1; AJvYcCWqF0+QMW+/amKba9e8Y5ki3VPv79rcmyOuIl+pI7GKI23V9IRnTwdOFjSOuuLw5aUUq0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqZseBDQ6kQCzZz/4SMoY293iLp/b4Jl4Pl7Gd0lL/l+JeDOlD
	GTDi2wbydkZQg0FHJSG3p48pFGEimGPBA9um0nfXgX9CamLhsX75PG8ehNvDq2kUZ65uCqxMogl
	9J/T8UPZpzcl2XA5MleGYJ1M3y1o4FUQAkrKIsSb451GsFPwcZDvzZrBsg2fV
X-Gm-Gg: ASbGncvNRv/XZEvsq2gmj9tm+W7EgiY8TPPwjdSoHZ0DMD6bkDLwlZvUGGrulE+ZyCm
	V2voJI5+0vY0avaQsFKOAMYIWbxAo6Zt0V9bwouPnRav0+3gq5yfUQv6ajX4fCXQB3iX81puKQP
	yPNAGbcQfdm1tIEeF/G3+34XJ2R8REb27yyKRXuQMJ/3whhL4eCOx+0m0ea9GFvHDcUoU=
X-Google-Smtp-Source: AGHT+IG6HZ/8Fi0eQ+rXE+47WUzLt+zmbjPe+C1XDxRfNdt32Ri4/qwaBYXVXZGqFfIan5V1AhcN8nK7xhtxwnbINxY=
X-Received: by 2002:a17:90b:2dd0:b0:311:9c1f:8522 with SMTP id
 98e67ed59e1d1-3159d6466bfmr19690671a91.10.1750680762455; Mon, 23 Jun 2025
 05:12:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com> <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
In-Reply-To: <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 23 Jun 2025 20:12:31 +0800
X-Gm-Features: AX0GCFtYKxGqlHuJJ47JAXMxUFhLXnT6cZnnppHiAtMF1rC-04ON37kUhYiGk7I
Message-ID: <CAPYmKFs7tmMg4VQX=5YFhSzDGxodiBxv+v1SoqwTHvE1Khsr_A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Cl=C3=A9ment,

On Mon, Jun 23, 2025 at 4:05=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
>
>
> On 20/06/2025 14:04, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> > 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> >> Delegate illegal instruction fault to VS mode in default to avoid such
> >> exceptions being trapped to HS and redirected back to VS.
> >>
> >> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> >> ---
> >> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/as=
m/kvm_host.h
> >> @@ -48,6 +48,7 @@
> >> +                                     BIT(EXC_INST_ILLEGAL)    | \
> >
> > You should also remove the dead code in kvm_riscv_vcpu_exit.
> >
> > And why not delegate the others as well?
> > (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
> >  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
>
> Currently, OpenSBI does not delegate misaligned exception by default and
> handles misaligned access by itself, this is (partially) why we added
> the FWFT SBI extension to request such delegation. Since some supervisor
> software expect that default, they do not have code to handle misaligned
> accesses emulation. So they should not be delegated by default.

It doesn't matter whether these exceptions are delegated in medeleg.
KVM in HS-mode does not handle illegal instruction or misaligned
access and only redirects them back to VS-mode. Delegating such
exceptions in hedeleg helps save CPU usage even when they are not
delegated in medeleg: opensbi will check whether these exceptions are
delegated to VS-mode and redirect them to VS-mode if possible. There
seems to be no conflicts with SSE implementation. Please correct me if
I missed anything.

Best Regards,
Xu Lu

>
> Thanks,
>
> Cl=C3=A9ment
>
> >
> > Thanks.
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>

