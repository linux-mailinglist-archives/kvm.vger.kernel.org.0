Return-Path: <kvm+bounces-63361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45591C63E04
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 704003B1E48
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EEA32BF38;
	Mon, 17 Nov 2025 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xJqVTnSe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F6032A3EC
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379358; cv=none; b=cf/0JKlUlnDbU3IJtUk4QbKTKseQXLVtQceuszMgRfaQ0RRFj2sIACbxx97uK5iVafb/eUwrtPvCPGp9wR6gmQkxl7xvnM7GEGMie+gn9+9zhQu+8QjVKd8Yoc5PQmurkiXBotYpTuaz+vkHuUSb8bN/zb8kAt3RD6JWcUsGKGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379358; c=relaxed/simple;
	bh=FiVg8HIoSq1vAMera7LlyWAWAwVwtwqzruYByVnF+ss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2wTmFCXnjz5K90nblGGoreGEPxkAHS35pUtPtWPyRmGUgjK1o3GRYzh6z3qZl4HdB6/zqC3NFOWTCgNIq/pXT+GdSOvgqdEtDp15Ygu0DuvXlkG/trncKbU4Z7TEjdkRfFhTbIli6SuTR2QPoUwJ1is9YEc+MdiC7sVXTSFejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xJqVTnSe; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed67a143c5so563051cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 03:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763379355; x=1763984155; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=InxzUv4fZ1uU4fFpdnx0a5dxJKeuOiNcfcnGKmmDKis=;
        b=xJqVTnSeg84JQYp5tSq21wo56OXUX//V+ZLVfGdlpebWIeAxOklb8IPjrFW0sne6lT
         BfIcFAQ/HRyv73GmKDSSMjXPtNt3+7XmBHaSairSHDrp+Ubx78XKYaQw5Zxm+F3ZWyJC
         9tWmM0/OC7Ty+ItFHfQBoKGEssp6keL+eSB1Zg2h2QW9n+9swufC+b/u2LMrdzujbmdM
         LI/M7T0ln0aWxipcSXZUgs4F0ullgDWhSIdymW+vwJGnRuVjjLwucwWhjo9VBEkBH+Pi
         WytDlmmJ+uhdFylsEMmEPJzKQb1FoUyUPr6syIqF51UWU9qvK+bmGhNKqn9Pf4o4cZ7K
         cUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763379355; x=1763984155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InxzUv4fZ1uU4fFpdnx0a5dxJKeuOiNcfcnGKmmDKis=;
        b=ie93C+eiq7byjuTs43Z0jnQjtTAALJnzEwnE7T+U+D4GqbwPnuPVPHNIjh3L+fdrOM
         FIbe1LtfdqLDXCqic1vmFO6xUZY80Jxqoo528FYTM+qKUAd5JjlreqpUAdpFKmEHDsgM
         YJ1DNdIA6myNnVjT1/j5vEJn4X57rQBvZRjOpXBDOHFAhODRLsGmiCfJfNRtmpuFZMk7
         A0+AO79W1vhX3MxYEGuuVbnT7A3xIwiQTtKJbOkf/HgM489dnSqImXG90ShB62v+TD20
         5u3sFRXWhQGNanD+B50gglGJWt21r8tU8Q1xluSnreHP48eZZjdgLpofI3zzaLdL1HeC
         GpNw==
X-Forwarded-Encrypted: i=1; AJvYcCXY+DQZ7GU724BumluWMv1anl3IFYQvvsojc4ik8I/dgyx0E/2qw4qU1iRutUoaLyKeZRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YygBZZj8kYCyjk5c1G+2pB9f+OShUuWMhh7yJwgZ2A5W6dAhg4W
	pWg64bhDTOEeQvHAT8PBzG82FVSnTwdH/1freH0QodFVvYvuhJCjqcWgxQxuzg+5uY/VwVdpv6s
	8yJxT1qhZkroh82+vAPuOnPmMOB+0aD4EHlBehxi2
X-Gm-Gg: ASbGncuA8t1ig/WTcgqp20C6hjM0Lew3vCWsKuGmuv7Ju96Nw6z/HXpwLGfWvxiXjRu
	bZsFgIYP3S3/Az/ypn6BG47WqTtdC3dFNv1ChIcGgO7OKnM/RkrL8g4V1CtvgzcFHJ2A8thkWwC
	qPGdgTwaeDK9XrCoq3d2AY03veJsNGmLASxnG25f0XybcSAk9beBqVJqNjvpnteLEknOegxMEf0
	qIz6k5bSWgEB6nG8t72qboFoWj6yOeN2ySTpQKKSmffg7GchhjhdJWjKar/qfqAxloodtUt5CnB
	e/00IQ==
X-Google-Smtp-Source: AGHT+IEeSiW3i7KxR/7PtZwLbRJe4Rt/AuAzXIflTZcma7G9RYj/Byd8sqTWf75xRzlbievXcmfG+TwcqMMRZMTyoY0=
X-Received: by 2002:ac8:7fcd:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-4ee02b0dba6mr11656171cf.18.1763379355279; Mon, 17 Nov 2025
 03:35:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-6-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:35:18 +0000
X-Gm-Features: AWmQ_bnrhZokZgmcow0lXNWcucVmFJ-Nro-VXQIq3EmXDZs9hFHaUagkAg0JMFQ
Message-ID: <CA+EHjTxVr7uk8Ofhb2VHjDw+LfC4ZSz4dDun5+xLcnRQy5AKaQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:22, Marc Zyngier <maz@kernel.org> wrote:
>
> FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
> effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
> interrupt is vain. This only hits memory, and the guest hasn't cleared
> anything -- the MI will fire.
>
> For example, running the vgic_irq test under NV results in about 800
> maintenance interrupts being actually handled by the L1 guest,
> when none were expected.
>
> As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
> ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
> the host in NV, giving it the opportunity to retire the pending
> MI. With this, the above test tuns to completion without any MI
> being actually handled.

nit: tuns->runs


>
> Yes, this is really poor...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 99342c13e1794..f503cf01ac82c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>         }
>
>         write_gicreg(0, ICH_HCR_EL2);
> +
> +       /*
> +        * Hack alert: On NV, this results in a trap so that the above
> +        * write actually takes effect...
> +        */
> +       isb();
> +       read_gicreg(ICH_MISR_EL2);
>  }

nit: is it worth gating this with "ARM64_HAS_NESTED_VIRT"?

Otherwise,
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




>  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index 40f7a37e0685c..d6797632157a0 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -94,8 +94,10 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
>   *
>   * - because most of the ICH_*_EL2 registers live in the VNCR page, the
>   *   quality of emulation is poor: L1 can setup the vgic so that an MI would
> - *   immediately fire, and not observe anything until the next exit. Trying
> - *   to read ICH_MISR_EL2 would do the trick, for example.
> + *   immediately fire, and not observe anything until the next exit.
> + *   Similarly, a pending MI is not immediately disabled by clearing
> + *   ICH_HCR_EL2.En. Trying to read ICH_MISR_EL2 would do the trick, for
> + *   example.
>   *
>   * System register emulation:
>   *
> --
> 2.47.3
>
>

