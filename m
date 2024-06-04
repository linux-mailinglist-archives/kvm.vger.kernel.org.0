Return-Path: <kvm+bounces-18722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EEA8FAA23
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BC9028534E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8074713DDC3;
	Tue,  4 Jun 2024 05:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBIkBlVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506A937C;
	Tue,  4 Jun 2024 05:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717479976; cv=none; b=b6Jd2S8D7gjuSL52OyLOZjiDVBCycRQPaAoSjJ3KNSoibE0u9VHBMMjcFH/M0PvvT6uzHD8omlRVTHKr9oZgysnqo1PQUlVEEZ7sauqJF10+fPVhPmKam5VI/Rv7OSTn5CTpBrHGo9swKQ+ps3I5v+PjTarYWQ7WwXFL+Ib2VBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717479976; c=relaxed/simple;
	bh=O+1QblrTsjvq+O2XG5HDvlUvaAjZhRuYjw7zeHzoTDY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=dBgiaxS9gtWZLbAFoPayJbK+rtnzoXrDRFAbT/dYm81NQw6cf//zbMTKM3q+FoboqJklFwwxDXICr8ertylZ6tb3BdhGTk8VU/kqr1Oe6657CuGtb/G2NciVRK7xmwnPdBe4X9R7XRn2TlS65HdQG7X69yoi+uANbvu20rbNFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBIkBlVm; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2506fc3a6cfso1468684fac.2;
        Mon, 03 Jun 2024 22:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717479974; x=1718084774; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPLpxATmddmokVXF3C8IrkY43EERs2VVStOX1Q1SJ+I=;
        b=JBIkBlVmBvs9v3l6YHion8QJqWdTIPJrAyyHuEZpuLneVQYgn6qFpxK6Xeq5QDk4/Y
         xWxi53EnO8xJuYfp7V8/kDpuETg+RvU4re0vIf4ECcU4Y473cHh/ZFN/l1SCniZ2qNsR
         +oo0rVxtPaQCMGoHu1bwfl50dI77at1+1LAdpk73brtN5Ye069sT21mTKJKEm7tAvK1X
         p95NgKPZTgvQb4tJZ3feqUXDx6tflI/yKRg0SnCQKh6/3Z/lFGm71lvVzxlKGHQM79Qm
         AoCQXA+1Igh41YnUvPSxysOLEmwgM4CWORd9wWgtBCxVt7W5Vo8sL1P0r/AFDJM3TSqH
         zXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717479974; x=1718084774;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uPLpxATmddmokVXF3C8IrkY43EERs2VVStOX1Q1SJ+I=;
        b=LY00am/2qCtslsqcrpygCfefPmiTRygpgg6v1mg5ms73RlQ7glmZolUaJd0g1g4Leh
         /wAdDAkfd826mSHJLk/SSl2lfQZkiDXj24asZvD/x6Pi/6CKgACoVtt+EwFpcjOf+a5x
         uJDkIsTXhWsFNrygKELAcnUjcX5sr9XG3uzGe15LeBzyS4hLPNgCrEOjT8iLtGLoAtWe
         9v+nlypCpBF5WxB+7Lr+Hq1RzpUohW0V66LfE6eIZ1zViR1vv9YnQJWbyy6YmJbpOqet
         JKY30wOZtgxTvq5Welv/UsKEXqgFHdf9XlAX9F2/imAtFdefIPLnPjVLIyUWps5fS2Md
         IuCA==
X-Forwarded-Encrypted: i=1; AJvYcCW5BvlGd9IBcPz7DO8aA0hKvMb8fezeeGDuoGDPtjDpWOmPxDV2vt6VzLpSsOPLMiPVAIbaiphhVwbCY6N4em3oXI7owsSKOwETVb6Nb++A/Rgcz4gubTkVv5q9Ll7Cic5P5sRVM+1WJXSKyh8szJcJMV3KXBUKDx1hAEhU
X-Gm-Message-State: AOJu0Yy2bWB92on5nGRksJo/gTN3SSmck73SpxT7YGTdzzhQ8916uDPL
	p1teeP9Rj2KtKLXW+wqtZrUk2ckE+oe6sNRhYuCOFYVMaqwZ01d2
X-Google-Smtp-Source: AGHT+IEOLE4f64WHbpwwp9WVIXILo2lZZTZnZw9eBIwpn5RGDA714gckoGK8yqM2bo18SDDzsz1CNg==
X-Received: by 2002:a05:6871:5d3:b0:250:8248:7ea7 with SMTP id 586e51a60fabf-2508ba8e2e8mr11644460fac.27.1717479974273;
        Mon, 03 Jun 2024 22:46:14 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c35a2d0ffasm6290700a12.77.2024.06.03.22.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:46:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:46:06 +1000
Message-Id: <D1QZU4EE41OU.2OWQD6HHQDTPR@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM: PPC: Book3S HV nestedv2: Keep nested guest
 DEXCR in sync
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741326679.6631.5332298610543769487.stgit@linux.ibm.com>
In-Reply-To: <171741326679.6631.5332298610543769487.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:14 PM AEST, Shivaprasad G Bhat wrote:
> The nestedv2 APIs has the guest state element defined for DEXCR
> for the save-restore with L0. However, its ignored in the code.
>
> The patch takes care of this for the DEXCR GSID.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h   |    1 +
>  arch/powerpc/kvm/book3s_hv.h          |    1 +
>  arch/powerpc/kvm/book3s_hv_nestedv2.c |    6 ++++++
>  3 files changed, 8 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/a=
sm/kvm_host.h
> index 8abac532146e..1e2fdcbecffd 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -599,6 +599,7 @@ struct kvm_vcpu_arch {
>  	ulong dawrx0;
>  	ulong dawr1;
>  	ulong dawrx1;
> +	ulong dexcr;
>  	ulong ciabr;
>  	ulong cfar;
>  	ulong ppr;

Actually I would reorder the patches so you introduce the KVM reg
first, and put this hunk there.

The nested v2 bits look okay. For them,

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
> index 47b2c815641e..7b0fd282fe95 100644
> --- a/arch/powerpc/kvm/book3s_hv.h
> +++ b/arch/powerpc/kvm/book3s_hv.h
> @@ -116,6 +116,7 @@ KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr0, 64, KVMPPC_GSID=
_DAWR0)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr1, 64, KVMPPC_GSID_DAWR1)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx0, 64, KVMPPC_GSID_DAWRX0)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx1, 64, KVMPPC_GSID_DAWRX1)
> +KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dexcr, 64, KVMPPC_GSID_DEXCR)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ciabr, 64, KVMPPC_GSID_CIABR)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(wort, 64, KVMPPC_GSID_WORT)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ppr, 64, KVMPPC_GSID_PPR)
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/boo=
k3s_hv_nestedv2.c
> index 1091f7a83b25..d207a6d936ff 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -193,6 +193,9 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs=
_buff *gsb,
>  		case KVMPPC_GSID_DAWRX1:
>  			rc =3D kvmppc_gse_put_u32(gsb, iden, vcpu->arch.dawrx1);
>  			break;
> +		case KVMPPC_GSID_DEXCR:
> +			rc =3D kvmppc_gse_put_u64(gsb, iden, vcpu->arch.dexcr);
> +			break;
>  		case KVMPPC_GSID_CIABR:
>  			rc =3D kvmppc_gse_put_u64(gsb, iden, vcpu->arch.ciabr);
>  			break;
> @@ -441,6 +444,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc=
_gs_msg *gsm,
>  		case KVMPPC_GSID_DAWRX1:
>  			vcpu->arch.dawrx1 =3D kvmppc_gse_get_u32(gse);
>  			break;
> +		case KVMPPC_GSID_DEXCR:
> +			vcpu->arch.dexcr =3D kvmppc_gse_get_u64(gse);
> +			break;
>  		case KVMPPC_GSID_CIABR:
>  			vcpu->arch.ciabr =3D kvmppc_gse_get_u64(gse);
>  			break;


