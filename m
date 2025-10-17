Return-Path: <kvm+bounces-60281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E267BE6E19
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2E29D503748
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 07:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6523101D5;
	Fri, 17 Oct 2025 07:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="zGBqGjwl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274FC18C011
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760684783; cv=none; b=UpuetpUJzHrXrevDdEbPy5lcC8/GaGOK6P6JeIudQyeeVwAUUun0U2fKnOfXJpVFdeCJW9MP7CLgseAPkEYehDZNTaYJ1DHzoKnenz7rdj7DUn1NA44Ov2MNbGJdXgwolLholeNqNKmlSb6rrKcpb4PFOxaRKr8fy0I9oa5oRIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760684783; c=relaxed/simple;
	bh=I3bc65zO/JWcs456H5HuVEZ4MsfMb6nc7AHpCv6K92c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAsOlItG2zgYr9i9n/A/9qMmOgD5dx9CgDHNgyEaU3Jm+Y7O0BEAm/A2Rn+3pqfsJAs6XLdGoWZbgRrj3kWCugvo/xYN/Qgs8/cTbxfmhZX/Vd/LmkMPw6BG2A3k4t+0VStqwu+x4uO4OVQgDZJ7tFlx63CJUgvSzO2CRkHIZNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=zGBqGjwl; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-78125ed4052so2119602b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1760684781; x=1761289581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tBllN1KPXGz1kwWkEqmZXoXM1+36pBPLJkHM98NsOQ=;
        b=zGBqGjwlnVhPwE4HP6Qu9n22/yTaPgE60onHvDLzWbXhLAkQg3Qk6XBC+mHy7SOlvY
         t2d2U74bXOLkDDbUut+8mLn24Zy9xTItoYlww/Rczr6pyxfBFegqKck+qJ48ckHXQpWT
         w6wGHxC1rhGDzdExPMhCdQkFUHMkbXho0TIJCYsQnGM2zVU9kNWnp9A6q+rvgZ6FSnO4
         AK/ejrBzuzP6IeIBD0i6mLhLevE+Xo/i8H2kKjkspVZpP8B3q7rymvRFwU0fNXi7wwec
         0SPWU2mbn2VkklmDw1vSNthTBiw3PMODOMvRAGLw5GTYN8poql7cGqK5Y1jg3RbaB/n0
         DV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760684781; x=1761289581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tBllN1KPXGz1kwWkEqmZXoXM1+36pBPLJkHM98NsOQ=;
        b=uNrJp1/BfRR3IGbZ1tujODyoaFBT7tkuG45lC7MS/V+aVAkJ7no/aCDcLYMCqTC32A
         LdZfHIE8EB88so9RXZBDmQTWcgAOYSA9Q7uVTR2u5mn2yKWE72w//3i75Jk5xl3jHMpG
         RXkwrT1Q/GSrMfzx6FucfSz7SCzF00NAeD+t8Nb0nApA+vOraa790sSwjVo/hdpo+iZS
         1OJDeAzDZNVNKrAMVh6Jx/sE5/5Cd7tGwGAdI7Mnvgxi9gyeTDV619SvjPGFOzqGnVPt
         oN/0LQ97TmFKCGt0uWPAO9LYlVNep0Xuc9FPnXQ2f71J2/ng0M6v3J0LynJUnrBk+m62
         oldA==
X-Forwarded-Encrypted: i=1; AJvYcCW2ur3WkqcExVSsXxiwr2vwmZ/v7hWUhTAIYZI2PPKKttQzgXLNNM1arSbMlt7ZZSkdm44=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya7E3eUWV6Zctu3F0kpjel1QJiSeKrNq3T03YtL+rAzaxXYrQT
	AnvyiT8K+5ngbWy4a9kBObuE1wJCczGLJXiOqLsWNrqMfdSSHUq1o3QAUwejtIOP3hXbIMRG+yE
	01+j9MMmGNUX9aypAVgHHTBohPEgvyNi+g6D1YLcokhL2maO5AeX0
X-Gm-Gg: ASbGncsYJ9sVVJNCyirDL08lr8RQw/xD77/zFudQWdYm2OuSLmf/Z3AVEneglYYsWQe
	QgBPZOmqgn/eWtYEDSBByWy8uXDdsQFXH7NNbUIO+CWXtmNXSNxzFxpe5zgl3StVNTpoHy4ihkz
	0z1ovXRZ014PUZVp8HYh32D1TdhXGlU4Qr7giTB9okRvV2PG2hX8YlkEJ3jR0sp5DNEGgElQ5ZR
	wgPRF9IldvSDp9tmYhprTAEg1iZ3944OX+OuFOU+8B16wbCsB0Nrpajrj3bQEF+1eirkcP85fo0
	+uUoQdJUcipjSDR3Qx1GH6ieyPiv
X-Google-Smtp-Source: AGHT+IFCshVxKTQarSYu+mbLMq9+cdps146TZixf/9pY/HK3AnNs9jHylKnsUq6JcPr+g9YcoZphbOzJ+VMIjriDxuQ=
X-Received: by 2002:a05:6e02:3e04:b0:430:c394:15a3 with SMTP id
 e9e14a558f8ab-430c528d628mr41557595ab.22.1760684336325; Thu, 16 Oct 2025
 23:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016012659.82998-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251016012659.82998-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 17 Oct 2025 12:28:44 +0530
X-Gm-Features: AS18NWDRRpVn-G-IgqIpz7eW2arnxdgcUvLxINosb7XYvEXa1letznEamlVSgow
Message-ID: <CAAhSdy2UcmoPLF0CGBrsF1bRdJe-X05YA7UQOVffxBjZTourMA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Read HGEIP CSR on the correct cpu
To: fangyu.yu@linux.alibaba.com
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, liujingqi@lanxincomputing.com, 
	guoren@kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 6:57=E2=80=AFAM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> When executing kvm_riscv_vcpu_aia_has_interrupts, the vCPU may have
> migrated and the IMSIC VS-file have not been updated yet, currently
> the HGEIP CSR should be read from the imsic->vsfile_cpu ( the pCPU
> before migration ) via on_each_cpu_mask, but this will trigger an
> IPI call and repeated IPI within a period of time is expensive in
> a many-core systems.
>
> Just let the vCPU execute and update the correct IMSIC VS-file via
> kvm_riscv_vcpu_aia_imsic_update may be a simple solution.
>
> Fixes: 4cec89db80ba ("RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC vir=
tualization")
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  arch/riscv/kvm/aia_imsic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index fda0346f0ea1..168c02ad0a78 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -689,8 +689,12 @@ bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct k=
vm_vcpu *vcpu)
>          */
>
>         read_lock_irqsave(&imsic->vsfile_lock, flags);
> -       if (imsic->vsfile_cpu > -1)
> -               ret =3D !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei))=
;
> +       if (imsic->vsfile_cpu > -1) {
> +               if (imsic->vsfile_cpu !=3D smp_processor_id())

Good catch !!!

I agree with Guo Ren. We should use "vcpu->cpu" over here
instead of smp_processor_id(). Also, I think we should add
some comments for future reference. I will take care of this
at the time of merging this patch.

Queued this as fixes for Linux-6.18

Thanks,
Anup

> +                       ret =3D true;
> +               else
> +                       ret =3D !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfil=
e_hgei));
> +       }
>         read_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         return ret;
> --
> 2.50.1
>

