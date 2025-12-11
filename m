Return-Path: <kvm+bounces-65782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 889DACB641E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D7AEC3002158
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92412D23A3;
	Thu, 11 Dec 2025 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="de+9NgQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA5248F72
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464979; cv=pass; b=lsyLmGBM2RAIfBdPGmPqMWfjWy5gk3JfCvjGv873azx/MkLcwX5l498691C23puWrjprjuXexuU6SjYLISmu6uWp+O1l5GRO4xVC8QFrFpI0OhWwFgJnbQgMIh5nlVnTBX6XCZSyL0iuauzYoXDkBvp28QkKXQRCVi2/oiIywmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464979; c=relaxed/simple;
	bh=5k7G6/vHOZ/ZELJRWze07kLHkh4Upe+J24EgYvfN/uQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tzQhuAbfKegOYchdLVpXZqCiH3cmpVd3ZPr8OrhM09yg1cicClQ7c1ZminVvT7iEpSMl/hefi7InkxiJF580SJ1K6tObhLGWpiX2V43HeRVVNS72hw+IrE5Tkl4Y181HCfgY7BGJwjxQevRN6LQIsRnsgCieNCkMcyE4n0LM7WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=de+9NgQ8; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee147baf7bso446931cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:56:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765464976; cv=none;
        d=google.com; s=arc-20240605;
        b=Vgqak2TTP21G8Aa848uzoAj+E/yBgaqEkhtYk/43iCOTfJ9LfoMF+Q0f9qtQDwW/k6
         B89TbZZ9R2hRKJ9WZGnZj2mO7Nm0kDyNz1G/6B/Gowvh2RMqzv5koZbJTBwjNTRoxD1a
         W3ehyaVt307T8hGTyaa8XWnEyM/Q0F5zWP7nJxviQCK2/hpzfHgb4S3CD3AAqzpvP7UB
         EujymY4pJKJHNXWEkWoiUgwwr4ZZA8wJvVPxLf+71E+WODZxpyOtybgsfMwV4312JxdX
         Oeq0OLOFfDkbpArHDY1gcps87Jksbj4BFd+tQBhObwD7GmDE9QVHT4mlv4z717OhDQ0D
         9BqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        fh=FcscY30qHuuIJzL6oILgvpBIVGPoGQ8Vjx8QsEGyD8I=;
        b=Qe3q90gNEUGka10gIBv82/AdQdvGJPv+c2zPzhQ5jEDJrHzdZFxDn6UxDDKKMQ8lxm
         U3Po5byXyYq5mwJcL9RmdS9M0w75O4fVo0Ifpp/moc2Em++0pn0zbsNdu7uD8Fi/xghr
         TSgGZ/S4ha+8kiaHMMPWVwJFkrVFPL281YhOtyTENtWiZqZw3Qm3KYJ0uH6AU2a1sUGa
         mgbUTiQ+ECKENaTokWY9xJk2hj7LLThSBmiqEfXo6VTDo/gTdLZlT7iVliQctJ2Gcs7j
         AcB5kVNVbJ2R5DH3Q9l0+imk03P4dfJk3Hjww5i21TbSVxZLVQsaYk3ajuGOBsNJB8KV
         mhpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765464976; x=1766069776; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        b=de+9NgQ8tMhjBpLnboRfXuR3MTPyuiOemfiCEviCiJhW0LztqvkmD0u3laxEbfyQbN
         NxVWk/9cQe5w8hBTzjNNUr4Od2+/Pz7MAQvjRVwK9V2MzjD4bGcV1aI8rsdK8ze+w/MZ
         +WLUi6SyBkcZIdRcE5BIbxA+D0dbYMh7szCXPk7yBcGA1w2ufBF6pLpfsOJpq/PQgP0a
         VAD2pZOxzpqOZDeaGVwYc+9YKMF+sYkW2Nfz/WYD0i5Ja+2qOiFQYfl7GE23VCloC+rl
         CHVjkULkwSc0V/dx41GQN+R+unqUYW8S9KUx12h6ArjH3T2/nemctjSn9WLwogWgRsd7
         tRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464976; x=1766069776;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        b=A80QZaZ2xbjSnz/h8LXfO1b4jAliVOXte+326WrZuuwvDHT1XAaD3Gxw3kOpoNYM4u
         m00u7VbOXyttJua+Eo3CO8fqDg2i+/37+SP9GQ9PxZxI2gntjA62EwJy+D/9kdC4MrUT
         oPcOcwC8cUz8FTj1siteey1z/TayhkI+UAgM3+89MgVvLSyGlfVKOsEPjMaJlGlakUKR
         8Kt+6vS5G5VwsSz0XU345SErK5dPcHk4UxAAjQRk/ElFniNLUlzSYXylbLiKI9xgbaun
         9x4TG6gHPZIIpoK2DghYLDSmD+i6OLcYEJifoSqZeP2VeNENUYrUX7ZWc3QzcQkt226E
         qu8g==
X-Forwarded-Encrypted: i=1; AJvYcCUxDWghDKPy76cwnFrMUtf934Lo/+68QF/QOCakNHNgay/wWNV4Ja4F0tADBtknYEhKNAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa4GTmSksMVISdkk6Sdvr4hv1NQROiGPJ4HtiT84tmdRaxOqCt
	OCmoBao4O0V3edRNDewYdWjI0RaD4ynfNVSvcJWDNK0Gj5NdxwPnfroMCQ4JHKBkE8447m+Y18n
	EEhUymuZDRYYgw2YcrMbezn3QgFVGVmElnyhmUb81
X-Gm-Gg: AY/fxX6jeMSgMWVWzV9KUiQzmaeypaMUjRvcEkEAHNaFHpBKCCgWh6RHXjz44m4bS04
	zeRNE1BcRgEjLK2Tprtuubhriwa48y1euXvI7DzdefSM7Sn4NVsyLx4cWNl0f9oUnG++2lAaOUp
	A+Jtu9FifPnvWuh1aqTWTgBS43lcyThKm7FtoLFk0XnG2myZ8RXpXjcaBw8pxrO0mqYFX5Oqx04
	BBFFVhDV4OqradxOPfLYi0V/TvBfr92ZyayE8ZkrACTX8ALbidENT81RZvpl2KfzsXwgdDb
X-Google-Smtp-Source: AGHT+IFgjwqJGgZa7LZD4L5r7a6kWYEP7wTy3klGGOECrWDWiCBkWZLd3nH8UUUtuYTcOmHg8w6evp1g6WqoN0gf/WI=
X-Received: by 2002:a05:622a:106:b0:4f1:b41a:a38a with SMTP id
 d75a77b69052e-4f1bed269bdmr10288581cf.3.1765464976027; Thu, 11 Dec 2025
 06:56:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org>
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:55:39 +0000
X-Gm-Features: AQt7F2r2xUgOLmLbDl7ihpbE251_7xooz1URlan3WSuQuzZ8uzvAyHS3-gcFwgs
Message-ID: <CA+EHjTx8LYCCY=W+ifaQ4Ny3mJ_+u0GL5T2FaKWvaX-oqVPT6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: VTCR_EL2 conversion to feature
 dependency framework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> This is a follow-up on my VTCR_EL2 sanitisation series, with extra
> goodies, mostly as a consequence of Alexandru's patches and review.
>
> * From [1]:
>
>   - Added two patches fixing some FEAT_XNX issues: one dating back
>     from the hVHE introduction, and the other related to the newer
>     stuff in 6.19.
>
>   - Expanded the scope of the RES1 handling in DECLARE_FEAT_MAP() to
>     deal with FGTs, as we're about to get quality stuff thanks to
>     GICv5.
>
>   - Simplified the S2TGRANx detection slightly.
>
>   - Collected RBs, with thanks
>
> [1] https://lore.kernel.org/r/20251129144525.2609207-1-maz@kernel.org
>
> Marc Zyngier (6):
>   KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
>   arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
>   arm64: Convert VTCR_EL2 to sysreg infratructure
>   KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
>   KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
>   KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings

For the series, on qemu, hVHE and protected hVHE:
Tested-by: Fuad Tabba <tabba@google.com>


Cheers,
/fuad



>  arch/arm64/include/asm/kvm_arm.h     | 52 ++++-----------
>  arch/arm64/include/asm/kvm_host.h    |  1 +
>  arch/arm64/include/asm/kvm_pgtable.h |  2 +
>  arch/arm64/include/asm/sysreg.h      |  1 -
>  arch/arm64/kvm/config.c              | 94 ++++++++++++++++++++++++----
>  arch/arm64/kvm/emulate-nested.c      | 55 +++++++++-------
>  arch/arm64/kvm/hyp/pgtable.c         | 32 +++++++---
>  arch/arm64/kvm/nested.c              | 11 ++--
>  arch/arm64/tools/sysreg              | 63 ++++++++++++++++++-
>  9 files changed, 217 insertions(+), 94 deletions(-)
>
> --
> 2.47.3
>

