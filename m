Return-Path: <kvm+bounces-67942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F7BD198E0
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B09F309538F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 14:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D6A2BFC73;
	Tue, 13 Jan 2026 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Kfo9pME"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B3231858
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768315118; cv=pass; b=gGPBr5rci2bUqGDRN4GZ+zy04PcNR52dO9ZmVLSiZB4cIj7oqnNIhvQULgKQjMw0EcuvogqMJvFXq6wEruanCbWWEpvagyLCLtymt5jq5XS7+JnymJEBKWLekxGy2hHzbiY+gGZTTjA5kwkyVlmFuf9pAaLgCpIZyvVh1y8cINw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768315118; c=relaxed/simple;
	bh=HCdvS5NkY0vXw8KWKY8kVRjAzF9gX4xS/N5ZGLvpz88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E7tqU0k5sUcN9DmIAhRxw2LZEqF2lN2tRxNtCtgbwfR41Htm5TQVXnuE2YizGEtcP5cUN6HPnmNst61cHW9x0Fm02H7wIVQNi6quKKCuYtkMeCKg3eRJZkUR9aMXfuXlt8+I+yYWIcJcNyTLiiQVtguTTjgHC2SmCUpaMqke7Rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Kfo9pME; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ffbaaafac4so577841cf.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 06:38:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768315116; cv=none;
        d=google.com; s=arc-20240605;
        b=NEO8ooz50u8uh46CzyGQRhK/2WhfheBddvCMfdi4lgod3NuJ92pKZWzfYfpw41oGH5
         Y9VVq3rSuscZqoDT9h9Wpb0oN5RRZtc3g8PDR2TfQrYx8vy5r4k60KDtds1HzV6QS3tM
         iyuAf0O8JElydc/5VOAFelnRAaZs33GHgDDkznz7uywXRrViU7U7axh8Y/lut5XmlSK0
         TocCiCCEidsvNfBz4vN9nZ2kT5rpZtxPjmxrAUf4Wp4Ut4MBz7OjTHF0fzO3IxGPDeKh
         YTgXR9Zd/v7sBAyAWhLyuDddckBqsHdtWMOEl6iAvEfJk2evah7Gz6l0y+HI1Jfd0Mhe
         eAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        fh=S72rgodIWVswohjNNc7S4aXi2Qq/KnfBpKyVTnaLdsU=;
        b=UctJeJblARaVKevPlwMCHbYnV+4HdrnQ0qsbZnKQ1Bju/K2vhCEBcu1sVzNPVgjLCG
         mu3a9sqDWVbCqpqiwTKxkcynhh2UmjIoWWsXkRxZQGYm7J2wXf0vY1W+mmgCQiJQ0916
         6XxyTPTj6Qz0CozAGi065zbC8AX/1b0WQUNBZX4mjC9WzWQjzFRecY+uNgrfmVI5byHU
         5ai0ip3bp8b65y9vGEVJmMXgB4mMaHkXXG+MCg6E51QS7VZ6eB/W312MEU+48sPh8Tz9
         vOT7GtPxhS4rNFIECi9rWnuyvGjJd2v8WV8ooKsxiG8pBePQMKztYIdaLjSd5rf98rR9
         LiCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768315116; x=1768919916; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        b=3Kfo9pMEuU9AQPTMSP7KjhmahlErlXGn4E0euTU7WbUvjOk/93PI8BCBzWMJZdcMSX
         wHbxi88+CFd/plzvNFD5w9P/AXMhwLqveoVYT+y4ept78PTtXfYbreWsBsKUj9qhduHa
         M47aloV5zJIb7N0fYJz9ni7W1nwlyh04eZqiOXk0KK44AEXykqudsH9XkZ5vvI3hbPnq
         aSrt65yS6yKgBlHWYt7iZtldd5aD/d7F+7ivB7Jj91UP+BGAws/rknP1Hc/E5HU8eV7H
         XeVEXO6/tPY0tV1/sfe+X0nbsOxAZtGcJJav/dCtmdiIgFZFAgT7UJAAC/AeZGHSyG/q
         hoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768315116; x=1768919916;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        b=Q9f/PdhaKO3pNWXT/d5QPogVW6Uqqh+Kj3oYFYOmiJ35T3LNGfb3btRDdyJAd+GyrT
         1dL48cICXOvcGOGB/y0N/FURYMwW2OAePmCEBM29H5qsamxfC1U5GpNNwlpJa5QpRAyu
         F4fTYURmXT8LiKBJgyGfZYPcCTxHpCmHGWq5XU198uT+KjWPsLc+04bs8Q4Zh5A8CuEm
         LHFcXSI1bI/z52yp9dfqpGa/mm/aWBfvpVqNui52zjiynaJbKkGMb4GDn7YD9/VIefON
         KlvOU56Wf/GtFmCS6zEHc5+zhmaDLJHn20Xdw7jWG3YFC5xl16DYfE5s2apT2FK47MID
         7xyA==
X-Forwarded-Encrypted: i=1; AJvYcCVmajjQuTibjEMYDFpkPs7Enj/zfGWEtYmYarK1n6I+YVPXI1HtsFhUDckJsxQbJZjGJrw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6xkzk+YlqnpjaWsxzPCZgAGp7siRDk/dro7WMdIi6PX+J0dRM
	2PHlB4XYXRovVKqrRB52klxTBwDGaRAIvjs+g77BzGGv/XW/GLHM18k5cbbz9HMGzrYjODxvijE
	OHIiFA09BPHGl0WQ73jBxFFnAL/FT5qvgDga4u7HK
X-Gm-Gg: AY/fxX7Y8ZFA8L4j9ut4jjIaRnctO68RzcFHQHQ76QPFaGLD3+dDtmv759iJQgBBYGb
	kgNiexemXYAUnjwdDSnmah7JuW7pFN9/rIlQZ9L6AhzzXnUlRb8e5a7e2jFW7dlXs2bJBJYa8oi
	99bAZhJCUm2YG9R7iDm1lupmbO9cnIJyujpH8B0Onv0gsxo277e9ZJQs3bikqjEd1kJyzFq2Wf+
	wSx51Kvowgw/ZqW1jqPvjGicCXaOvK6p/LrQLue8Je0/H0+ALBqoOog7J6MMyj5pR1+QDuLJ7gD
	j6PNbpIB/S9pO5JFHxCN3ZRijQ==
X-Received: by 2002:a05:622a:90:b0:501:19ce:5bdd with SMTP id
 d75a77b69052e-5013a21b63dmr4606041cf.6.1768315114958; Tue, 13 Jan 2026
 06:38:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-25-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-25-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 13 Jan 2026 14:37:57 +0000
X-Gm-Features: AZwV_Qi2DCwvCxhy1IBJRUhKVRAZLawBqR0npBrkyjREHFYNX_l_ocigtzC7uIo
Message-ID: <CA+EHjTwZCcMFT6gAM2oaQz5V_vqEBmVuggFBbABbXPvC+U919Q@mail.gmail.com>
Subject: Re: [PATCH v9 25/30] KVM: arm64: Expose SME to nested guests
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> With support for context switching SME state in place allow access to SME
> in nested guests.
>
> The SME floating point state is handled along with all the other floating
> point state, SME specific floating point exceptions are directed into the
> same handlers as other floating point exceptions with NV specific handling
> for the vector lengths already in place.
>
> TPIDR2_EL0 is context switched along with the other TPIDRs as part of the
> main guest register context switch.
>
> SME priority support is currently masked from all guests including nested
> ones.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index cdeeb8f09e72..a0967ca8c61e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1534,14 +1534,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>                 break;
>
>         case SYS_ID_AA64PFR1_EL1:
> -               /* Only support BTI, SSBS, CSV2_frac */
> +               /* Only support BTI, SME, SSBS, CSV2_frac */
>                 val &= ~(ID_AA64PFR1_EL1_PFAR           |
>                          ID_AA64PFR1_EL1_MTEX           |
>                          ID_AA64PFR1_EL1_THE            |
>                          ID_AA64PFR1_EL1_GCS            |
>                          ID_AA64PFR1_EL1_MTE_frac       |
>                          ID_AA64PFR1_EL1_NMI            |
> -                        ID_AA64PFR1_EL1_SME            |

Should we also limit this to SME2, i.e.

+ val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR1_EL1, SME, SME2);

That said, we don't do anything similar to SVE, but it might also be
worth doing that there.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>                          ID_AA64PFR1_EL1_RES0           |
>                          ID_AA64PFR1_EL1_MPAM_frac      |
>                          ID_AA64PFR1_EL1_MTE);
>
> --
> 2.47.3
>

