Return-Path: <kvm+bounces-35215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E07A0A1D7
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 08:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C9D2188D891
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 07:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E3117B4EC;
	Sat, 11 Jan 2025 07:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ni6sDhlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF126FBF;
	Sat, 11 Jan 2025 07:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736580253; cv=none; b=ezvccxbNptXnLMD53vgEHEEBX6A3FHLzYEJ+4b9zO1B0o41/zlcZI2UvxZNN6VAIN7cFwkrt5dea0YllQd09IB23QLKZD7gMDxSMyF6NTByqk23bfbZP1mmJ5dreYkORNQ7Jqgj0pqckav2PibuZfJZyyNUlEhQlyvNMSOVpv4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736580253; c=relaxed/simple;
	bh=4eDODf6YVlMxxHhe8LGOO9x1o9/F2MO9Vs0a9pn6VBc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=T46KN5u7f9AeH+pUksGHtwaKptGQTZywxKzYJN1D54rF7rG/e+YvCvbuHx3bf2OYAYtYa78ht2wsO2IGZxm8R4wphp7jU+TN/7z1dExVZXzQ9IDo0Q99F08a+Q+FvMCZhISG/p/Z0ijKb2ppOxvjuNXn9xwmJeNNIUud5KXhaPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ni6sDhlU; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so4532625a91.3;
        Fri, 10 Jan 2025 23:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736580250; x=1737185050; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NH2/R/mmwYipmvjxTmPJfojr+0VZHua5pp0k9YchVg4=;
        b=ni6sDhlUqzb6WCs/izaUVnVlJtcxZGyShhaMISxoemFfFMLrgiUKiYGn2e+J9fhzes
         u//O88POs/hyhBVXWTuSY61OlFd6dwZm5vS80Y2mjfcIgzR1Gn6lp0E7oxbR20J0fUuz
         7C7ZzVlYFjjBju9uNLSz16LRrGneySCWlxCZo1PHFK+L+3D20erZQlGG1p8gEsDn/Khd
         gYUR+qwMk2Mju3Xm4gHQoHrdSjaH06yEETwvnaPdn1418Hm4KPnDupiypppqncr5EnVH
         aBcRC0/vAkXxRl+HOEGXL8OBTw7R92CrDA3ZNRLtVMQJG9Tps1017ngwQcPBKk/wwacV
         fMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736580250; x=1737185050;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NH2/R/mmwYipmvjxTmPJfojr+0VZHua5pp0k9YchVg4=;
        b=UVGHNmFCeKO0cNU6EjRe6SNOwOieKIUIp8fBDR5pGV+PacfH+67r5Tmu0XBlE2LwXS
         3gPHNfcviSjAGa5hHvgiQxaKGDAwdAfSda/Orq1z0VgaV9U1uMcY67QWsqd24I9scGdF
         4/4m2r/Bk29UypIZV4Ljwm53VuyEXtNBXzqD7q17i3xwQ6C/1OCfADDAReLTdxuu1Prv
         Ei0qw70Z3C32imIrOJ5x0IPPfmDBBRJ2DSWmmwSnNX637+HYqrcsotqA8l756N8UuKyi
         lNit0aogrQcp0yImu/gqKCML/hlpwPSBvpdvVkqmK963pItkZ7jaxkRFdbugLemPjYud
         jhug==
X-Forwarded-Encrypted: i=1; AJvYcCUOtFXlzxbOOr0PjyyDs8Ub6dnT7jOK6cscqKFe3XG0s8OXvwK+Gll1wxgSmGigmjtFszqSxpsK@vger.kernel.org, AJvYcCUVDQoml9UHf626Nt44vZ3BWK4aBgBfd5yS9en6UH9Yj4Wsjfj6nd/mB+Wi1zu8AQQ9+rza@vger.kernel.org, AJvYcCUzBXerfN3mDBhwGLSUjNgsk1dOkapdbWTKS3Xs4uJci5D4XF0KQ/Bv7wVYBNMm8FtDXSh7NwgL@vger.kernel.org, AJvYcCXzvDxDJGs3u0FVPd5HpoS3tGWXv3tCz9zaKqqMwrrkM9dQt4Idf8EGNtjoYSWSWfn05Gvu0vtghCJwpwyS@vger.kernel.org
X-Gm-Message-State: AOJu0Yz78KAmWq3GWHonYCK/jQArQ+Vf6mxJ9KPDEQL7Jp1NbfEijxr8
	hXWLwNPBvakjSx2c6EEO74Fveo1CKuwiQQUlXfYfyx5illH2/V2DmDWlkCGAD/s=
X-Gm-Gg: ASbGncs32uVflWZ4t22HccaR6fhldvt1R6vS8zKONmNRUzgpKadLmKY4EV3H3+OLgQK
	OikP4xLnts60Co6vIBzz2rQmDE2fjmtZSl2KkDxsvlX3p+iVcSzQDf0mi90CGhVOW5LLdzxOd96
	dzyEO0mJQcAK6gPrtA7NQNZaZaIWSV8g3a0X3ixZTLVkSyffYJTHHVATdmDHy+maAc6MGaWHw6q
	sMqbthuyejrxwD7ast/N7ZjVFFMJ5AIi/kuFKbMy94aU5LOLw==
X-Google-Smtp-Source: AGHT+IEgeQ0GUy0bLna4m1uiMu79PJdAeK7ijLAotzT9V4CjzfxBB6JltsCSAZHszPCb+4sri3ib1w==
X-Received: by 2002:a05:6a00:340c:b0:72a:9ddf:55ab with SMTP id d2e1a72fcca58-72d21f3ececmr18299223b3a.10.1736580250208;
        Fri, 10 Jan 2025 23:24:10 -0800 (PST)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40658c56sm2637590b3a.93.2025.01.10.23.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 23:24:09 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
In-Reply-To: <20250109132053.158436-1-amachhiw@linux.ibm.com>
Date: Sat, 11 Jan 2025 11:49:49 +0530
Message-ID: <87r059vpmi.fsf@gmail.com>
References: <20250109132053.158436-1-amachhiw@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Amit Machhiwal <amachhiw@linux.ibm.com> writes:

> Currently, on book3s-hv, the capability KVM_CAP_SPAPR_TCE_VFIO is only
> available for KVM Guests running on PowerNV and not for the KVM guests
> running on pSeries hypervisors. 

IIUC it was said here [1] that this capability is not available on
pSeries, hence it got removed. Could you please give a background on
why this can be enabled now for pSeries? Was there any additional
support added for this? 
[1]:
https://lore.kernel.org/linuxppc-dev/20181214052910.23639-2-sjitindarsingh@gmail.com/

... Ohh thinking back a little, are you saying that after the patch...
f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
 ...we can bring back this capability for kvm guest running on pseries
as well. Because all underlying issues in using VFIO on pseries were
fixed. Is this understanding correct? 


> This prevents a pSeries hypervisor from
> leveraging the in-kernel acceleration for H_PUT_TCE_INDIRECT and
> H_STUFF_TCE hcalls that results in slow startup times for large memory
> guests.

By any chance could you share the startup time improvements for above?
IIUC, other than the boot up time, we should also see the performance
improvements while using VFIO device in nested pSeries kvm guest too right?

>
> Fix this by enabling the CAP_SPAPR_TCE_VFIO on the pSeries hosts for the
> nested PAPR guests.
>
> Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
> ---
>  arch/powerpc/kvm/powerpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index ce1d91eed231..9c479c7381e4 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -554,7 +554,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = 1;
>  		break;
>  	case KVM_CAP_SPAPR_TCE_VFIO:
> -		r = !!cpu_has_feature(CPU_FTR_HVMODE);
> +		r = !!cpu_has_feature(CPU_FTR_HVMODE) || is_kvmppc_hv_enabled(kvm);
>  		break;

In above you said - "Fix this by enabling the CAP_SPAPR_TCE_VFIO on the pSeries hosts for the nested PAPR guests."
So why can't this simply be r = 1? Or maybe you meant only for HV KVM module is it?

-ritesh

>  	case KVM_CAP_PPC_RTAS:
>  	case KVM_CAP_PPC_FIXUP_HCALL:
>
> base-commit: eea6e4b4dfb8859446177c32961c96726d0117be
> -- 
> 2.47.1

