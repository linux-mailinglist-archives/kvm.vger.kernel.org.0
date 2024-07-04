Return-Path: <kvm+bounces-20956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DE3927600
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 14:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 971E71F24098
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 12:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2ED1AE0AD;
	Thu,  4 Jul 2024 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YdyeszOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCA01AB8E3;
	Thu,  4 Jul 2024 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720096171; cv=none; b=STAvGsMyZgDdlwY5cnlXwWp1Wc6qtP0iHrAa2/eXBWpKdtRDP9LPwzEkn4g5uAm+LttWtk3hSThHc5W4U8o0tlzkorrYOkCXVpQeesEbJvxKRAa0m+4GyvjhceH2a5N0XTQaeR4aWZk9xW2H9v2/m6NEG+frd8qEVgzRlslGO5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720096171; c=relaxed/simple;
	bh=C19RkyfBb863RjbhnfgofWkO1KaRisT1rcCsjm7yjRI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=n2eyvmQQfh4ZBf5X+fte3XHLpAJyFpaUhjOutwvqJ5TlQNRWfdi0sFsRi/w82cspMwvwCVJ8AZ+dgUtfQFG9SFS1NoDKmiQdoLcSkhcZuqN2aOQOn78sJshP2NoR6xAywGzF2LvLS7jaDxITOeiN0yYbhEVcbWQ/kfxVWQFPbNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YdyeszOv; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70b0013cf33so413854b3a.2;
        Thu, 04 Jul 2024 05:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720096169; x=1720700969; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNfsnOEtHtVgBniAhgQdMy49K3wiZRS/wOfw9thsZks=;
        b=YdyeszOv9fVLWm3mLCuqfkrJaF814maE09ivpbglSs7gv9jn53W3mu/ashYiEZuB9T
         B7mzPO5SyWMOpNJ5Q4qM3NKjoGwrcU65rDCN5W4L5w/OP3CgZcgyX/XR5QKEMRwV3MXe
         ITP3WCtFsOu6goY5m70zeLrHfBDLPBjIfvjqLDPA+2esPbNt8qt56bTVvF6bA6Jb9y3M
         He0AGYeupJZszqwXTZcpit/q5aY0AeEPfBkVyzk1bWwFOVQ9ii+29MFkGxcOkKMXfQ3d
         z33Z3saTBr6rxNAVht4AiGUxbZbHlOmTTNFCT80nuFSKUSqOvZs+dLCLFqw+FvCMSd9f
         Tq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720096169; x=1720700969;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nNfsnOEtHtVgBniAhgQdMy49K3wiZRS/wOfw9thsZks=;
        b=PrJ4lcSQuHG6UlPvDsIJcxrFlYK+UB6SVMrr/WzsHsIFxpPyBacTY2Fq+FFV7gtZEw
         9zJK0DgiZGqGNhU1r+rsotO4w6CkwfgTOH+OSDlpb+nKE/cXY06eUCXaLCr1L0zWV4Ed
         EgsRjO8pDmxiDrV7x9woWZ3H1M/XiM1sHXccmOntgS9y8hB0T58IkbVJRbAHqtWOIn05
         SB9HGtkkFVU8BcQjLj41cwljijGEKrQNwcm32Ru0h30FMgSfNuQjlwE0NhZ3dgJCJYk2
         JdRLk5Ta0n7qbTinl1Q7KOIsX7K+3S7ySE7K7Sfe/2SOnd0jIRD1+Wj0gSZWQRMcm7B5
         INPA==
X-Forwarded-Encrypted: i=1; AJvYcCUWAofBjyUfniU9ftXhfkiRZghnt4VIrySEneVvfFhG2TdlDxFQC+r6GcAueZj3DkAEraqGU/1hPyKRXCJqzuej5daZeC/NZjJpSdGpfRpxluV/Q87Zlv6AJnthegw0QC3V
X-Gm-Message-State: AOJu0Yw+xkBR7emLB1bBihSHSInH8ab3LvRpvH1cbQ6RD3KgWljsiTdm
	5tpQ1+pVNCIYNatAFlfreu2edqSxZLRC/8MW5OXHitNRPpMhU7YS
X-Google-Smtp-Source: AGHT+IGt0/o2u3yrXRWsUqt7a7Glp/54cozH/TSSBsnH/uI+kft9JtdePRrBcEnY2gsuG47Od5JPcg==
X-Received: by 2002:a05:6a20:a10d:b0:1bd:2703:840 with SMTP id adf61e73a8af0-1c0cc75c736mr1502282637.33.1720096169473;
        Thu, 04 Jul 2024 05:29:29 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99a946f01sm1365436a91.11.2024.07.04.05.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jul 2024 05:29:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jul 2024 22:29:23 +1000
Message-Id: <D2GR78QR1Y7K.3I08I56HLWKFT@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] Revert "KVM: PPC: Book3S HV Nested: Stop
 forwarding all HFUs to L1"
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <naveen.n.rao@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240627180342.110238-1-gautam@linux.ibm.com>
 <20240627180342.110238-2-gautam@linux.ibm.com>
In-Reply-To: <20240627180342.110238-2-gautam@linux.ibm.com>

On Fri Jun 28, 2024 at 4:03 AM AEST, Gautam Menghani wrote:
> This reverts commit 7c3ded5735141ff4d049747c9f76672a8b737c49.
>
> On PowerNV, when a nested guest tries to use a feature prohibited by
> HFSCR, the nested hypervisor (L1) should get a H_FAC_UNAVAILABLE trap
> and then L1 can emulate the feature. But with the change introduced by
> commit 7c3ded573514 ("KVM: PPC: Book3S HV Nested: Stop forwarding all HFU=
s to L1")
> the L1 ends up getting a H_EMUL_ASSIST because of which, the L1 ends up
> injecting a SIGILL when L2 (nested guest) tries to use doorbells.

Yeah, we struggled to come up with a coherent story for this kind of
compatibility and mismatched feature handling between L0 and L1.

The L1 doorbell emulation shows a legitimate case the L1 wants to see
the HFAC to emulate it and the L0 does not permit the L1 to set it for
the L2.

Actually the L0 could just permit it (even if the L0 wanted to emulate
doorbells for the L1, it could still allow the L2 to run with doorbells
if that's what the L1 asked for). That would also solve this problem,
but there is a potential future hardware change where doorbells will be
able to address any thread in the core even in "LPAR-per-thread" mode
and the hypervisor *must* disable the doorbell HFSCR to the guest if it
runs in KVM style that schedules LPARs on a per-thread basis instead of
per-core. In that case the L0 must not permit the L2 to run with HFSCR
set. So this approach actually works better there.

In other cases where the L0 might deliberately prohibit some facility
in a way that we don't want the L1 to see HFAC. I think we just
cross that bridge when it comes. I'm sure the L0 would really need to
advertise that to the L1 properly via device-tree or similar, and we
could special case the HFAC->HEAI if necessary then.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 31 ++-----------------------------
>  1 file changed, 2 insertions(+), 29 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index daaf7faf21a5..cea28ac05923 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2052,36 +2052,9 @@ static int kvmppc_handle_nested_exit(struct kvm_vc=
pu *vcpu)
>  		fallthrough; /* go to facility unavailable handler */
>  #endif
> =20
> -	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
> -		u64 cause =3D vcpu->arch.hfscr >> 56;
> -
> -		/*
> -		 * Only pass HFU interrupts to the L1 if the facility is
> -		 * permitted but disabled by the L1's HFSCR, otherwise
> -		 * the interrupt does not make sense to the L1 so turn
> -		 * it into a HEAI.
> -		 */
> -		if (!(vcpu->arch.hfscr_permitted & (1UL << cause)) ||
> -				(vcpu->arch.nested_hfscr & (1UL << cause))) {
> -			ppc_inst_t pinst;
> -			vcpu->arch.trap =3D BOOK3S_INTERRUPT_H_EMUL_ASSIST;
> -
> -			/*
> -			 * If the fetch failed, return to guest and
> -			 * try executing it again.
> -			 */
> -			r =3D kvmppc_get_last_inst(vcpu, INST_GENERIC, &pinst);
> -			vcpu->arch.emul_inst =3D ppc_inst_val(pinst);
> -			if (r !=3D EMULATE_DONE)
> -				r =3D RESUME_GUEST;
> -			else
> -				r =3D RESUME_HOST;
> -		} else {
> -			r =3D RESUME_HOST;
> -		}
> -
> +	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
> +		r =3D RESUME_HOST;
>  		break;
> -	}
> =20
>  	case BOOK3S_INTERRUPT_HV_RM_HARD:
>  		vcpu->arch.trap =3D 0;


