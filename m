Return-Path: <kvm+bounces-18887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C28608FCB49
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 248A81F21FE0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75F419B598;
	Wed,  5 Jun 2024 11:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfV2yxqx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F6C19AD95
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 11:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588228; cv=none; b=UMAJnxM7juidJbFpivevz5t7CCrvZVvhchas0y1WxgtnXhy+E9y/9s1oMOXsO8KrZINEtFUHZooVCcsUTe2hXt+DG5lyUFVBRt+5OBhsrzzpTrKpur1Wjpwu3ZlUnXJlY9Mr8qvXHjnvKunuRPJNiRNna1k3tG9mVJU5b5zM7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588228; c=relaxed/simple;
	bh=ONrEo9FNO/9LJSKku7iv/BrnTzWIK6mPQb5zmZ6p3ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oMByMlhs3i/e7dgnQI3rLvY6cvCFhUZhIPwbpUCrJa1K9z07dSem6h2COaS4bJtl3LVOncvKUeM69z/6nPEOaQMCOjz6Sd1pxIImtFGpiU8GqcFE833DuxH5QX+2AmA6kVhwgR8cMSOCZECCnp71PdAEaQP3FX37CdBj0HrCw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfV2yxqx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717588226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3YlG1Bw2xgnk32skP33PtoFJXnD9dZT+4APyJtar36o=;
	b=WfV2yxqxxBCAbV6sz4tkByV3OPN1RWY5zL4zjozPABGj49ZgX1VC+C1ebrdtILX7XiJGB1
	ZbKO5W8PGwshHd5pDZQpfx7ujumKH8ypp4dXaEFrNBqyth8in6u3urr4mjFbql69Ds6+oB
	hvCNtmdu2uyO8gKNMA0OTaOWrnmVI/Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-3D6WEFo5OHe7-HZOue6RJg-1; Wed, 05 Jun 2024 07:50:24 -0400
X-MC-Unique: 3D6WEFo5OHe7-HZOue6RJg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4212a4bb9d7so52449495e9.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 04:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717588223; x=1718193023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3YlG1Bw2xgnk32skP33PtoFJXnD9dZT+4APyJtar36o=;
        b=GC9/zAVTXfSny+G4JflIKUOOkP0nZJlTmgg4Gyze00c4hi2f5GjESJg33ZkXrHTgoO
         Q5X2I8rADus3bPQx9NiWQMUPXlFoPi34NBHuFS025GaQ8sJ4nUcYkEpBihMSy813BShY
         YaL65URibOOZ5OhQr1sAQK1MHJq7yhhEIo4IwJO7FTniNABmXIJlqxQW3wqEZFxL8s8k
         m+eGMjQG24eLCOpBXI6QUs1+oiv8iDEijHz/XJd6HKBMUU+XcIwMyeMFPzhiVpaJIGN0
         PFAF8v84bpZJ2O7aw8C3kjOgxLS72RSMryT5lD3wdl2LCBtWoHE7JLLcqnSsKknx7aB8
         LqPA==
X-Forwarded-Encrypted: i=1; AJvYcCXlKihygBmWOgUpaZ97AeeU6RlnOtB63+A3gtfJHewrGwrkIpTvrC2ZB05weFoW4SBg2a5o/tHwtR8Hxj+9wlVSi0jx
X-Gm-Message-State: AOJu0Yy+OY+2aWRXmik9Gxh65JsCWxu7coSVxgzBoiQZp/K7RYekhBx5
	lHWqGr+83NXurRBKuS20lHrnpzi7Zq2bIIuvtMErO/ptkCutokAVkX/fHOacHI8wvLhsjyG4T6z
	zFjsR8Il546KBvS4Z9xPofTmWsesBaIK30xosMkV4mAt+NO9LbJBHHcZECC63pZbP+eXXg0UcUy
	4httHgEHTzf6QKBk9tAtF69n/s
X-Received: by 2002:a05:6000:e8c:b0:35a:62e3:7103 with SMTP id ffacd0b85a97d-35e8406df3fmr2232089f8f.2.1717588223657;
        Wed, 05 Jun 2024 04:50:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1hBpVkwUAsy5NCJn3bUgFRhVOdiW5gUbZZW6lmADP3rMiS2Grtmju2yHiy1M7tLme7GF6GfKPF6kT8CkEllU=
X-Received: by 2002:a05:6000:e8c:b0:35a:62e3:7103 with SMTP id
 ffacd0b85a97d-35e8406df3fmr2232070f8f.2.1717588223353; Wed, 05 Jun 2024
 04:50:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240531044644.768-4-ravi.bangoria@amd.com> <20240605114810.1304-1-ravi.bangoria@amd.com>
In-Reply-To: <20240605114810.1304-1-ravi.bangoria@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 5 Jun 2024 13:50:11 +0200
Message-ID: <CABgObfbq2sZ9U=8650EJq4FqiO=Dz2_mivOj_GponeNn2KyAVQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SNP: Fix LBR Virtualization for SNP guest
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: seanjc@google.com, nikunj.dadhania@amd.com, sraithal@amd.com, 
	thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 1:49=E2=80=AFPM Ravi Bangoria <ravi.bangoria@amd.com=
> wrote:
>
> SEV-ES and thus SNP guest mandates LBR Virtualization to be _always_ ON.
> Although commit b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization
> to the processor") did the correct change for SEV-ES guests, it missed
> the SNP. Fix it.
>
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Fixes: b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization to the pro=
cessor")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
> - SNP support was not present while I prepared the original patches and
>   that lead to this confusion. Sorry about that.

No problem, this is a semantic conflict and your original patches will
go in 6.10. Applied to kvm/next.

Paolo

>  arch/x86/kvm/svm/sev.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7d401f8a3001..57291525e084 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2395,6 +2395,14 @@ static int snp_launch_update_vmsa(struct kvm *kvm,=
 struct kvm_sev_cmd *argp)
>                 }
>
>                 svm->vcpu.arch.guest_state_protected =3D true;
> +               /*
> +                * SEV-ES (and thus SNP) guest mandates LBR Virtualizatio=
n to
> +                * be _always_ ON. Enable it only after setting
> +                * guest_state_protected because KVM_SET_MSRS allows dyna=
mic
> +                * toggling of LBRV (for performance reason) on write acc=
ess to
> +                * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not=
 set.
> +                */
> +               svm_enable_lbrv(vcpu);
>         }
>
>         return 0;
> --
> 2.45.1
>


