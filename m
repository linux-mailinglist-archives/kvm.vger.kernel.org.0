Return-Path: <kvm+bounces-18723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 627238FAA27
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CEB51C22959
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F74113DDD7;
	Tue,  4 Jun 2024 05:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXLtA+n7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4154C199BC;
	Tue,  4 Jun 2024 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717479994; cv=none; b=WoMxHLD9ioldlI5FpElilrg8LrMQWZZr3T+Mr3wt/rzWCTRxESTTgWezzBnavKhgefD14OJomQPLlb1OYiwQmPcx/m8T/DUdS33gF6SjM146CACr1/5t0uxS94pj6EjY0xQcm2UZHlb7JfW5sV50xSdV8bT2y1nRF4gVRcw4B7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717479994; c=relaxed/simple;
	bh=pJmFo26RmhZf0dZBD12QS9OS0JWIMyYkSp0+glvkFXY=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=D1c10R+CrETvSDe08JhOZ5rAln7y5FFHp4jpyzPCIiE+7fS1QgAFWl8jVIDsJ0XbN/pW78tS1hsRmQZqpq1z9QyKSSNe1GAloqR3+pWE/bIQKwGiw3n8KjcHPUFH2n6HXY2wNWWLeN14RdLVZMCv3tvReoAUieW+y/Tmv0KxDbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXLtA+n7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f65a3abd01so19973295ad.3;
        Mon, 03 Jun 2024 22:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717479992; x=1718084792; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeU4vs9qcvhQs2pgjN02cESWYhtrhJkRZ0uDe9+oP04=;
        b=LXLtA+n7nJXs29909VCaue8OpcgR+HBoIQBVYaVrpVTFGC0yfJkpQNldYoW1LOIGNh
         Y+L4gYMBJwTbAdzSSYUD9sJQNVS793qsMI4dSAv/qe7tddXDLYpxLK3BTgltQ/Kd8QfG
         ZpQcQDofhLtuqzgdv5sDuEu1VgI3mCuIHoWvjj7QyU047mdZjIyZPRCtzKBpJ/bBBcH3
         6YTr91zeOeWJJ4c0t+lcpvHv6RphYcYSQSlNzhCrxY1EkaqtrDduaVp/tNj/a05WWNTQ
         LcDz7O7gQm3gGLhiu72sfO6LYoozKnI/vC5WFQ+3BY6tFVpZiRew5WmGzIaTfcbsUiiE
         8A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717479992; x=1718084792;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LeU4vs9qcvhQs2pgjN02cESWYhtrhJkRZ0uDe9+oP04=;
        b=DxmLe33aKeKr6aZ42GSfUM+Vq67/jmUmx0VoNpgA7zvqnMW2HBqDtcXSU1LRF2SWOb
         Xr4rZ7gTonWxnz7nx+qfMtWqm2ofMsPxKGZQQxEeTLOMcWqe9QCbBYHsEzs9tdy23cfF
         6OSXOAhiEhgbdUBHvnd6xoWT2bwq8O85C2Clmb0UBxhK//MNf298PEJ+V0YGGH2emRXc
         oNiCET7c2EgLlIXWaT0TGXxhrjiJk7C7M/zK8d7Omfcy5gZK6Ksm9GA/ZCOU1Wmcxg5v
         oj+HRMxsqlXZYwTK7doj9QTKIrV848oiJm4vwdzlbIGElLbn3em1/Ya9cMX/M707gf8H
         cKMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQfGRcXepBXclVwFYfG6fcgcfl5cZlmmxjhyGbM0PPn9WY81CHa6dpnp70jzRnnSz6Cce4/JTCr8FvxrmFYHjyR+ggsvbK4y3IDPBQJLwys/00m/oQx8B5YdSO7nQjExnTUygWtDgt8GrYMmW2JE0B0rZDrhW6TCt4cLOg
X-Gm-Message-State: AOJu0YwYWnd80Ld9OkUoxR4DaB9sixDjdp5X1GFJPt0+dNFvHxg2a4O4
	rW558qwg4PXjnIYYhK9rU5X8Tstvxg+5lX60/2+gkmT9nE/6NE0x
X-Google-Smtp-Source: AGHT+IFcTDvyrQflTU74FbFM840eY3KntUMbq2Bo1DKCHEzkJ0awM+YeaTrnABc3dgcJ96EjCJacoA==
X-Received: by 2002:a17:902:d50f:b0:1f6:838f:c70b with SMTP id d9443c01a7336-1f6838fc914mr42020405ad.51.1717479992495;
        Mon, 03 Jun 2024 22:46:32 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63241d378sm74388155ad.301.2024.06.03.22.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:46:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:46:24 +1000
Message-Id: <D1QZUCKP1YIR.3FYPGS64LOMAT@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: PPC: Book3S HV nestedv2: Keep nested guest
 HASHKEYR in sync
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741329242.6631.7779344904083076707.stgit@linux.ibm.com>
In-Reply-To: <171741329242.6631.7779344904083076707.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:14 PM AEST, Shivaprasad G Bhat wrote:
> The nestedv2 APIs has the guest state element defined for HASHKEYR for
> the save-restore with L0. However, its ignored in the code.
>
> The patch takes care of this for the HASHKEYR GSID.
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
> index 1e2fdcbecffd..a0cd9dbf534f 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -600,6 +600,7 @@ struct kvm_vcpu_arch {
>  	ulong dawr1;
>  	ulong dawrx1;
>  	ulong dexcr;
> +	ulong hashkeyr;
>  	ulong ciabr;
>  	ulong cfar;
>  	ulong ppr;

Same comment applies

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
> index 7b0fd282fe95..c073fdfa7dc4 100644
> --- a/arch/powerpc/kvm/book3s_hv.h
> +++ b/arch/powerpc/kvm/book3s_hv.h
> @@ -117,6 +117,7 @@ KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr1, 64, KVMPPC_GSID=
_DAWR1)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx0, 64, KVMPPC_GSID_DAWRX0)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx1, 64, KVMPPC_GSID_DAWRX1)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dexcr, 64, KVMPPC_GSID_DEXCR)
> +KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(hashkeyr, 64, KVMPPC_GSID_HASHKEYR)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ciabr, 64, KVMPPC_GSID_CIABR)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(wort, 64, KVMPPC_GSID_WORT)
>  KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ppr, 64, KVMPPC_GSID_PPR)
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/boo=
k3s_hv_nestedv2.c
> index d207a6d936ff..bbff933f2ccc 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -196,6 +196,9 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs=
_buff *gsb,
>  		case KVMPPC_GSID_DEXCR:
>  			rc =3D kvmppc_gse_put_u64(gsb, iden, vcpu->arch.dexcr);
>  			break;
> +		case KVMPPC_GSID_HASHKEYR:
> +			rc =3D kvmppc_gse_put_u64(gsb, iden, vcpu->arch.hashkeyr);
> +			break;
>  		case KVMPPC_GSID_CIABR:
>  			rc =3D kvmppc_gse_put_u64(gsb, iden, vcpu->arch.ciabr);
>  			break;
> @@ -447,6 +450,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc=
_gs_msg *gsm,
>  		case KVMPPC_GSID_DEXCR:
>  			vcpu->arch.dexcr =3D kvmppc_gse_get_u64(gse);
>  			break;
> +		case KVMPPC_GSID_HASHKEYR:
> +			vcpu->arch.hashkeyr =3D kvmppc_gse_get_u64(gse);
> +			break;
>  		case KVMPPC_GSID_CIABR:
>  			vcpu->arch.ciabr =3D kvmppc_gse_get_u64(gse);
>  			break;


