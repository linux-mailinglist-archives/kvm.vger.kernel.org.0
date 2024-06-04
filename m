Return-Path: <kvm+bounces-18721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F76E8FAA16
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423F21C2358E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B8B13F429;
	Tue,  4 Jun 2024 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OcZeWNDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898527735;
	Tue,  4 Jun 2024 05:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717479805; cv=none; b=Y2f+DnQUTBAO3xf1hJq6Ar2sOq6rnoIcmQMpd0wdriYZj2S222/JeN6HsiIPNHj7oJAdK8broRGjbg5yEY9gTlzdCjDlhW4+NSzzERTdXzYXykz5LLCjUaSHgkANmVXn4jrAR9KoURHt1a8RuZ6KU1c164QYtsFVPZzxp8GNaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717479805; c=relaxed/simple;
	bh=94pr6mja6RET09OSlFzqamlX1Yqde8yukT9lCk+ycKw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=sg90gpWJa9b/78mUKuQOF2DV9f5AEfdboCQMEnq7Y7dMwHp8x/TBID7dM4J/cZc6roLgPEygG8s5bWcaV22JI+YAtqBsq0ytQXHJ5GpANjqsPhVdpKUIRnjoD8n4ybvNPgfFo9ZTm2Gjb4O6BLIg9TpNT2owU8yMGrxheZN0JvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OcZeWNDg; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f44b45d6abso6121195ad.0;
        Mon, 03 Jun 2024 22:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717479804; x=1718084604; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMZI3zkaSwcqdd78+yzxe31y+FOMl2y7kr8jaeztLAE=;
        b=OcZeWNDgwwpE0B3zB+PEaZeqp7ASDKCNltSYJ57/atPPlZrEJgvNYsMd5jURKa1VA7
         oHVcYTuscBWOqe7Q0l7Y6uNCPEy9w97ALK1aL0V1/o30hTlhhspIONXPNHaSnjEudgFD
         kitHiwsX7C+0/bSjYXMj+F8HJdPea6stTI/4IRG7d0NsB+SLWKY4bR1jXqIBokdxI+jH
         ZQF0SvM0jNAbXZESwz6mKNNfljlX4SY3OMKDayZntKeau+o9uHo0zVPosGCTa0qBcPFR
         AIA4vkVRhlyJkMiz2AyKvDPHfwRjNL4GeAS6FUcsn1pb7JpzWetCqYs8ndjDuBavvpS6
         043A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717479804; x=1718084604;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hMZI3zkaSwcqdd78+yzxe31y+FOMl2y7kr8jaeztLAE=;
        b=CAYLRh8/Y3g/M+IzRpQP3Xs7+QLKluQkVtlZXGuAju1hi8jAdcCT2aKXPSF+z5JVz8
         8oYZvxZhxKdxuqIxR2GWJXy2Y8Q8sy7kYFiqEJ6ZMhbuavOGrlUdYwUieynzLTQG872V
         4KT2kj8yBwpnFgb7Kwjeaq+6ZRq+Mue4vWaoX/Z+GqH5zDkXvwL9Ll3x3Nbv3YWAMbU7
         TRzPGfWkP6nYBs+unv1dNAvxLnvIj2EjmnH4GJNrLhuleZoOoEUraTdArTGiw9pkIGFe
         FWyZ38wDF1uQKIYKaf4l6NDBWnHzWzqphvwpv8JXAl/tM4zB4xEXsXjpAKyM9WVDupu8
         485w==
X-Forwarded-Encrypted: i=1; AJvYcCXiJNN07o65DpyhKGZ7KiOXoz9kPcfaiPjR5eJ6vAtWyoFMVVs2+SidbUS7IsTlAFmog7sBbRXwsBmuSm9tGxKZoMg6vWEfTiktGk00lEEe0GzZxQTPfrxLKstAzooKXrVKhJbiI7K7eU7L45BDwb5PdafoQ+gkBBjLPC6z
X-Gm-Message-State: AOJu0YydiMQNzotYsVR9Bhv6fFiK4xhr3VyttAFQ6seIFA4uLPBWwluR
	jsIzEF5Ch9u6oxMwhCLX2OaZud2F0n8S857zgXb5hn6dYuteUlCY
X-Google-Smtp-Source: AGHT+IGM8f/is09yOrScZQFiLhzRjIF8KXB5oZ0fJ6eQPy8HEQtZ3rnCf8+ghDsA/19r/3L7vU6BCA==
X-Received: by 2002:a17:903:1cc:b0:1f6:74f3:ac0a with SMTP id d9443c01a7336-1f674f3b0b9mr65335635ad.64.1717479803719;
        Mon, 03 Jun 2024 22:43:23 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f632358519sm75196065ad.82.2024.06.03.22.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:43:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:43:16 +1000
Message-Id: <D1QZRY6L192K.12B6FYKGAHZH8@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: PPC: Book3S HV: Add one-reg interface for
 HASHKEYR register
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741330411.6631.10739157625274499060.stgit@linux.ibm.com>
In-Reply-To: <171741330411.6631.10739157625274499060.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:15 PM AEST, Shivaprasad G Bhat wrote:
> The patch adds a one-reg register identifier which can be used to
> read and set the virtual HASHKEYR for the guest during enter/exit
> with KVM_REG_PPC_HASHKEYR. The specific SPR KVM API documentation
> too updated.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst            |    1 +
>  arch/powerpc/include/uapi/asm/kvm.h       |    1 +
>  arch/powerpc/kvm/book3s_hv.c              |    6 ++++++
>  tools/arch/powerpc/include/uapi/asm/kvm.h |    1 +
>  4 files changed, 9 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 81077c654281..0c22cb4196d8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2439,6 +2439,7 @@ registers, find a list below:
>    PPC     KVM_REG_PPC_PSSCR               64
>    PPC     KVM_REG_PPC_DEC_EXPIRY          64
>    PPC     KVM_REG_PPC_PTCR                64
> +  PPC     KVM_REG_PPC_HASHKEYR            64
>    PPC     KVM_REG_PPC_DAWR1               64
>    PPC     KVM_REG_PPC_DAWRX1              64
>    PPC     KVM_REG_PPC_DEXCR               64
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/u=
api/asm/kvm.h
> index fcb947f65667..23a0af739c78 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -646,6 +646,7 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
>  #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
>  #define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
> +#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
> =20
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1294c6839d37..ccc9564c5a31 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2352,6 +2352,9 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *v=
cpu, u64 id,
>  	case KVM_REG_PPC_DEXCR:
>  		*val =3D get_reg_val(id, kvmppc_get_dexcr_hv(vcpu));
>  		break;
> +	case KVM_REG_PPC_HASHKEYR:
> +		*val =3D get_reg_val(id, kvmppc_get_hashkeyr_hv(vcpu));
> +		break;
>  	case KVM_REG_PPC_CIABR:
>  		*val =3D get_reg_val(id, kvmppc_get_ciabr_hv(vcpu));
>  		break;
> @@ -2598,6 +2601,9 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *v=
cpu, u64 id,
>  	case KVM_REG_PPC_DEXCR:
>  		kvmppc_set_dexcr_hv(vcpu, set_reg_val(id, *val));
>  		break;
> +	case KVM_REG_PPC_HASHKEYR:
> +		kvmppc_set_hashkeyr_hv(vcpu, set_reg_val(id, *val));
> +		break;
>  	case KVM_REG_PPC_CIABR:
>  		kvmppc_set_ciabr_hv(vcpu, set_reg_val(id, *val));
>  		/* Don't allow setting breakpoints in hypervisor code */
> diff --git a/tools/arch/powerpc/include/uapi/asm/kvm.h b/tools/arch/power=
pc/include/uapi/asm/kvm.h
> index fcb947f65667..23a0af739c78 100644
> --- a/tools/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/tools/arch/powerpc/include/uapi/asm/kvm.h
> @@ -646,6 +646,7 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
>  #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
>  #define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
> +#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
> =20
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs


