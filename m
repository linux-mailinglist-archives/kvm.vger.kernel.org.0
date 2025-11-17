Return-Path: <kvm+bounces-63353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F30C63995
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EBC464ECEFC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02DE328B5B;
	Mon, 17 Nov 2025 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RkN8TNXh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587A4326D62
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375843; cv=none; b=BERYPIGu/x/J5n8SauIr3iIY1XJAVjgIuzEAMYlBBUPSnivv05Vmo2x1JedRC+dOlMZE2nddt9Shz2E2ZeVsdPztiH1zZXLMnnazkp3gs2P/a3k/6LHJR0cIhSTl8MikgeXSOjMYJFIM79QD1NTeDnJvLg5pF/7O0OcsvyHo+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375843; c=relaxed/simple;
	bh=jU6y13VHOFy3Pi7WNXNgmgLs1immGWngiyX609zJHLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMYI03MuGyFmJcEkoOb0BieHDhc/zVu4LLz3//zihe+pkqdL4AxhJOlRUMOxrih3z7WbgbUyTGIrpRUA4MXXFOIR5P7hZNIeOWOtVj6iHZyPgzvC75qA38S9/Xu9bWyK+wLFMt49axxW87WVV1IfIQrXwsSib6yfq8w6b0XTAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RkN8TNXh; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed67a143c5so543911cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 02:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763375841; x=1763980641; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCczuntyrjypJFmPl75f311GtN50oo2b0NuRkLWiBY=;
        b=RkN8TNXhHB6BaUrNdTcAxYk9WuflxcOzdlF5XPJpPPZ9IF0UywOcjCCyOrgFw3xB7t
         td4122mZHM7c5UUVpmi3OlBx4rYNTDMiZ5hPM6SWYBnQkGbq4AKdCVT4TyML3HqbImQt
         H8wCRKn1yS8VHOIa6NkKKCeQiQUyXc7iHcITTdqSX9EhGWqq8C6RiwYdZCoE4DpQG+hH
         w8pC+VHN7N90TwPFcgwIGENMb8a5VKXJJw4yv2KzaFUkKhBLj+qmdgk05cCN5LahQYgF
         MIryNRrkVI/+kn1eR5bO/w9iz6q864WmXuYCN4Z8HqQx4+qnanVPhBw4OrVB2Ccfekw5
         TWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375841; x=1763980641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSCczuntyrjypJFmPl75f311GtN50oo2b0NuRkLWiBY=;
        b=IgYY9V3aThOp7Y1b7OZcnNYTpVVw8/xcqSGItv7mzPxOc5KO0+02Jtxjh7+DA+qf5A
         9tOVtLXK8Zm9s1Ltpl1xb9TCgyKnCwV6KuyfEmI+WfalLvP+aMoNFv0Pn4yAFnSbnKLf
         vEJ6ObFmEPFEfKSOImE0QWoe7HhSklWvOP+jqBo4Sa+U1Yqjs+rfiwUBzU1sLrnY2ug3
         pATO1/HY1mMG7R2Imy7ryAeix0pYAF7rlFRKR0IKmfnqgp+Vh+wCRcy6RvMI0GrQ/Tmk
         2JsnS0AqUA7T84und8bS87C1FSQTpPEpB1GDrJpx54uQeS77/WcOyuZdssCR7NAPazVU
         n37Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxWY/qNhgHbGIQPqE2wjhfkntsRUnlI8ymy+jIAj2F5iAT0QaWnibju09ewMAF1wc628k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsatlY9qVIKDNJitqB8TOrzxAlVXwbtk2yb4u8mxnxHFyyRaAh
	SPhbyvHmm7CicSuOq3Fj9/V3EQaSZpkZD8pE11MEEL1ryzoMO6SDERtjPlQaHaDYWdUFP9wc3uJ
	RM+ZCpG0e+IynnQ/PaDaFXKBptO4XNy9wNJ1xe5Q9
X-Gm-Gg: ASbGncuD4s1LF81Y1/oGBmkAErl7ZlhV1z8sc94zC72j05d9kgG6YcZosylCd04GuDz
	4gfvO6jVrn47hmmMSUoAcDLWXB0Dd7O8CvM57krQ/jd5OzMnBeUfhZkQXPD11ZT7ZZ9g+vZ/aa7
	CEIghc0jHwt44CYulMz46KdDHJxQaz23U/Db4Bk4m35uEpu7Xqun2nlYJf/TecBFQUEhSrGCsj5
	H/XlbgnYvMU1leZ6LOR2TA6v5pBjzkXQFDD/mHrLfuz6C2bsOpdcl0M29oTkq7gk7IGHJtPNjiQ
	XJP7hA==
X-Google-Smtp-Source: AGHT+IFFM24GESKuymha8lz4kxmnQKTDe1ajE7ALZIAlCW3kwiBwOHxbJvkmtglaccu5bdOdgggOwWj6OAOtjgUpEJU=
X-Received: by 2002:a05:622a:1196:b0:4ed:7c45:9908 with SMTP id
 d75a77b69052e-4ee02abc1c8mr11423671cf.10.1763375841094; Mon, 17 Nov 2025
 02:37:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-3-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:36:44 +0000
X-Gm-Features: AWmQ_bkOHIvxxrAN0Ta8I3LCFjnIE-AQuTMgHtHd82ZTpr8YLnfGv1xtAWeYWMw
Message-ID: <CA+EHjTy-vmMrOR_-BAd4q2JG99afzd3cisvf-VP6uM+M9Pg2=g@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: GICv3: Completely disable trapping on
 vcpu exit
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:20, Marc Zyngier <maz@kernel.org> wrote:
>
> Fuad reports that on QEMU, the DIR trapping is still effective after
> a vcpu exit and that the host is running nVHE, resulting in a BUG()
> (we only expect DIR to be trapped for the guest, and never the host).
>
> As it turns out, this is an implementation-dependent behaviour, which
> the architecture allows, but that seem to be relatively uncommon across
> implementations.
>
> Fix this by completely zeroing the ICH_HCR_EL2 register when the
> vcpu exits.
>
> Reported-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
> Closes: https://lore.kernel.org/r/CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index e950efa225478..71199e1a92940 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -243,7 +243,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>                 cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
>         }
>
> -       write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
> +       write_gicreg(0, ICH_HCR_EL2);
>  }
>
>  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
> --
> 2.47.3
>
>

