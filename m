Return-Path: <kvm+bounces-18720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D246A8FAA12
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED1871C235B4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E8A13DDDB;
	Tue,  4 Jun 2024 05:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mffh8IOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C3B27735;
	Tue,  4 Jun 2024 05:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717479796; cv=none; b=AC4YzeO+Pn9+XUKTI5nNeYupy5jp+yHXlba0Yo900G/ARqBBIw6VLTy7szx0QG6yBAYjAto88SFNPQsdgxiADRa+HMxdoB9htsfjmX1lvXVSjdl42EsiB3Z2FOXw+lQfUZhko6eNJgoAvToUoo1MZKItINjNF/AF2iv1jdm5NY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717479796; c=relaxed/simple;
	bh=Wc7N0BP4LUwBJNjgaM5afps9asVwOI8idTvrQObY+LM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Rayco40fIY3dKhLNzSr6NTB6n1iLfJrjrxYsw4L8ZDH8Cl7RUv1aPGOI+aq4s/sLYKF/gDZvRK98Dkngdd+hESr2kQ4c1+Q6OnFzXlXporGKcBeOAHZNFBauwamHvLmlEsrjwcixgm3/raxht5HkNsf9KUGh5Esiu0EixtAUBcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mffh8IOo; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f44b42d1caso39051295ad.0;
        Mon, 03 Jun 2024 22:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717479794; x=1718084594; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cPsbNHYB/deYy9oBYDkilLDFLxslyD43geIq+u0ocg=;
        b=mffh8IOoIFqaTjCGH1k5fxmdXn2NKXTrjgkrTllwfHVi4myOwmpohZxmdj73xFWGlT
         CaTaN1FnOrQfpm2Xjv3mNraIgsLiehV/Z5vPscLNLbO2OpALNMiJAeKPn7QMMbhuVRk9
         nTknUe+07dnm0blrsUErPu81HHQ2r3Q+NY9sjOwO+S47WonQkfol2vgeVc/iL8vq9XSy
         mfuAGJERWpsMpKjB0I6WbfD7WlMlLwNicCVujKeUwbJJEe9k7wx6VP3Cc3j3Uijeim+8
         QtUR56Z96OUFVCB3D6/4nRkXvdYi49py3JrJXg3pj8UHzZbCwDbVrdqq9qYgROwYKvhJ
         dfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717479794; x=1718084594;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1cPsbNHYB/deYy9oBYDkilLDFLxslyD43geIq+u0ocg=;
        b=flczFdX/1bYVnc/btbFDqu7pBaQbfdGJ5YbBl/hNojnoJT4CGLcjxpeUDr+0WcDWvy
         XJ/IFjUZqFE1EMv/xnPZ+CYwfUu83DJxhD+JbjRTAju9rYZ/yFJgB8t9Uqnyb85bbMJ6
         ckwuouqkVKe464afpuL9FMYVAb1VIYaVu5+3F2+hRePsVAdxiAL5595Zll0NaYz1HHga
         A6YfVbROB2OuuQAJbjrXFDRy+1mpDZCy2fSFSKv8aW+Z9BX8s4y8yOt57mjrtQIjT68U
         a2wT9H85HkybcuwS4fH8/2e1LcVxNVKOoZBMqE++OrVRwEo1hNU41y6rN6u+tZh6revI
         jtog==
X-Forwarded-Encrypted: i=1; AJvYcCWCm8PaZWILsc0wYwTBzB0th8Ci3oCrFRFsNfwMjN+YNOCXgplkzGb5kydftIn5r4iEQM92Gj7cIjGVw8j8ty+vDZVlrvGU92hiG8QQbcELlPEW33vrHvf+NBfn0k74egS+PMQjMFKjgWPWQLB/adYBXeIckx/tEy4v/dzI
X-Gm-Message-State: AOJu0Yx/g9GHFVNa9g2Ohksp5K2FSEqGH2SKkAKmfAkmFgwkR6QkcBcE
	8UPzvTIlR/ZH4wWrPvD0Uh6KCMeFgkbs8/9ycTYqlGHULWkd26AG
X-Google-Smtp-Source: AGHT+IHdULvM/UoX71VpmSro0BVG2S25hAJs5rPoN0XzL1Vuyeuwb3p6V/lc/pV9Udr55ns8zfQHzw==
X-Received: by 2002:a17:902:d2d2:b0:1f6:857b:b5c with SMTP id d9443c01a7336-1f6857b4df3mr34853835ad.32.1717479794361;
        Mon, 03 Jun 2024 22:43:14 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f683d1a770sm21936025ad.13.2024.06.03.22.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:43:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:43:06 +1000
Message-Id: <D1QZRTRK2WWI.20TJKC3RK1K9C@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] KVM: PPC: Book3S HV: Add one-reg interface for
 DEXCR register
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>
In-Reply-To: <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:14 PM AEST, Shivaprasad G Bhat wrote:
> The patch adds a one-reg register identifier which can be used to
> read and set the DEXCR for the guest during enter/exit with
> KVM_REG_PPC_DEXCR. The specific SPR KVM API documentation
> too updated.

I wonder if the uapi and documentation parts should go in their
own patch in a ppc kvm uapi topic branch? Otherwise looks okay.

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
> index a71d91978d9e..81077c654281 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2441,6 +2441,7 @@ registers, find a list below:
>    PPC     KVM_REG_PPC_PTCR                64
>    PPC     KVM_REG_PPC_DAWR1               64
>    PPC     KVM_REG_PPC_DAWRX1              64
> +  PPC     KVM_REG_PPC_DEXCR               64
>    PPC     KVM_REG_PPC_TM_GPR0             64
>    ...
>    PPC     KVM_REG_PPC_TM_GPR31            64
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/u=
api/asm/kvm.h
> index 1691297a766a..fcb947f65667 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -645,6 +645,7 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
>  #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
>  #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
> +#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
> =20
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index b576781d58d5..1294c6839d37 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2349,6 +2349,9 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *v=
cpu, u64 id,
>  	case KVM_REG_PPC_DAWRX1:
>  		*val =3D get_reg_val(id, kvmppc_get_dawrx1_hv(vcpu));
>  		break;
> +	case KVM_REG_PPC_DEXCR:
> +		*val =3D get_reg_val(id, kvmppc_get_dexcr_hv(vcpu));
> +		break;
>  	case KVM_REG_PPC_CIABR:
>  		*val =3D get_reg_val(id, kvmppc_get_ciabr_hv(vcpu));
>  		break;
> @@ -2592,6 +2595,9 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *v=
cpu, u64 id,
>  	case KVM_REG_PPC_DAWRX1:
>  		kvmppc_set_dawrx1_hv(vcpu, set_reg_val(id, *val) & ~DAWRX_HYP);
>  		break;
> +	case KVM_REG_PPC_DEXCR:
> +		kvmppc_set_dexcr_hv(vcpu, set_reg_val(id, *val));
> +		break;
>  	case KVM_REG_PPC_CIABR:
>  		kvmppc_set_ciabr_hv(vcpu, set_reg_val(id, *val));
>  		/* Don't allow setting breakpoints in hypervisor code */
> diff --git a/tools/arch/powerpc/include/uapi/asm/kvm.h b/tools/arch/power=
pc/include/uapi/asm/kvm.h
> index 1691297a766a..fcb947f65667 100644
> --- a/tools/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/tools/arch/powerpc/include/uapi/asm/kvm.h
> @@ -645,6 +645,7 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
>  #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
>  #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
> +#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
> =20
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs


