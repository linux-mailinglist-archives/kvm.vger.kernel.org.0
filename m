Return-Path: <kvm+bounces-63352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D51AC6393B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 581993B4B52
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BAE30E0ED;
	Mon, 17 Nov 2025 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3QeYsx3b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7557123BF9F
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375717; cv=none; b=L9UeOW7X94X7q3geoLAE00o3xeC4okAEG1W6G1c3Tdc48xdpbJ23vcK2g3UkBVrlY+fan6hqAKLPwpbVZraGfvbNre0oNZhVj087Qi2W/62m3nqV5fVPWGJGyhacKgHtSD9w7V6hoS+jE5rHM9Q18f/snBVdasF3uAF8mS6cfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375717; c=relaxed/simple;
	bh=1amoj1sKKYr1XLj2M/noyNE2YeQgsGaERFXZC4W3TJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZRF3mIA2snK1b1gT7w/jMFluz/73oMrX/PifAbDYvok2Iul/gqBLQFFxLLQ+MmLvPRLAYbceT83DLZ1M4pqSiiCdlmT+ZeZWWZV54iXgSQ3QRWPldTePPzbkAAizDZnsx1+9ft1LdvRmglz1RaaJWsY4+cGNyT420DifsJAS9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3QeYsx3b; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed67a143c5so543591cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 02:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763375713; x=1763980513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6UMb76mn8fRdulKyLx/a7XYom3+koOQ6PHrThZtOCmE=;
        b=3QeYsx3becYc4/cwxcb6VdAJJt5ku8YHCJDk/q8cM+8v8Q2kGxuUQFeewe+il9OWLX
         8PpJ/j7q/lvk/hK9kx47aaZ12dMdnr2gNQ9eTBUBfgP6PvaRc+I9wFBgugwnMsD5F/5u
         PLutAHupJzGFrpWV9cq+tKcE6JPadBeXB9ZimQ1Ufysb1tSUceGiV98LDLkse/bX3lar
         Ux5FUODLz4VTpie47gVoxAxXIpaAmPE6lr/6rmWmeO1bxX++vehSfIC92HmoENfxsnSI
         Nxd7/9jIqS2/WtjtE9XYsVM6xVfLFFgXTuJu091poR7h1TJudvicovTUgokpfGgEWhcn
         yVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375713; x=1763980513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UMb76mn8fRdulKyLx/a7XYom3+koOQ6PHrThZtOCmE=;
        b=CQZ9UisANiGnm/zSFaJbmzwE8EPbWsTs/xKkm6ICrmO95CwNYiWafbZrXq26SpnJtM
         /gBP70fRuSRL79LNHGVNUMo5gUV2dTo6B7eJcRPx5eNqb/sfo8MB6evMqfhOBb+p5xNN
         JKa6ZmO4FZ/xITrGIn6Auu0kFcXDBM6kN7clQZNDqyAxUg8mvVmm+imFc6RB2afV+rDF
         bSrIurNGu/bJY9ReswP8kvShHAvyqga/IM7NIi99mtz7X5E4LZTONKisOf3XpHyyzpuG
         4Xmd70QLDsM/0RlxRj4WyTVo3dqYNdKlfTi9k/xY8xtUAxzTVtAoUAkejcCZBxNU9Z2Y
         wPKw==
X-Forwarded-Encrypted: i=1; AJvYcCWMQV6ifJsq3kjyT3tv2SSs7/fvNiXaqd3NaEVe61jsU6RCEfTwbNE9/IrGmCdIdVUMLck=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkJeduCfCgdOSiue9LCsXsNqqT1yHUIGC8FCh1JUrVsSFzwafY
	XkYRJoFTeLi/MEnC4aAU8Ge5AYjt6MbrVodqQMztrZF95hw/aYcUeDKtTQoSC0Zeg/v70rb7MSb
	Buzkd3iKblxjAc3ovuvYk0SuVPwenm60BVa93XTv0
X-Gm-Gg: ASbGnctPVxqu4lu5BZ0a7c8XfyKc01SjkTYtb/KKFKd9UX3L29WPaUbYuTrJPgITRFF
	XpZltTqdt2rYLCf9Q466xAcfRpOzxFb3hYI84lVkqKFYjT1gBPEc4Hy8Sl+aYf/5ROgKkA8NRWu
	z4gW0e4llJlNcJZb450JuQd+V6kQfxSugzv6K8WVTbwS7SULQVGvRz2mquHkBly/IhPKHH86JUP
	vjkuXLilidQeyIOChpJTbWmMRBW6XpPkU5gIrIKCemZ31Rirgq4fxyTdmlUHU9oeu+jfGY=
X-Google-Smtp-Source: AGHT+IEeDf8TqrvbNoWWGhOaSKTbd2JM8FcWY8tyPNdC251IWOGGbR4OQunLQUmX2T6cgbU3MIvYtVGTrvUN+xb9V7A=
X-Received: by 2002:a05:622a:647:b0:4e6:eaee:a944 with SMTP id
 d75a77b69052e-4ee02febe71mr10646641cf.4.1763375713065; Mon, 17 Nov 2025
 02:35:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-2-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:34:36 +0000
X-Gm-Features: AWmQ_blgezKjAAmHyIWXBoJZICk6tQG5D6YP6HkWhKHbDls8Zob-nCh13_5IZ4w
Message-ID: <CA+EHjTy93dmoTysS91+jFmey8ei55VWNUf-FsqVz9Ho4W1NWBQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: GICv3: Don't advertise
 ICH_HCR_EL2.En==1 when no vgic is configured
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
>
> Configuring GICv3 to deal with the lack of GIC in the guest relies
> on not setting ICH_HCR_EL2.En in the shadow register, as this is
> an indication of the fact that we want to trap all system registers
> to report an UNDEF in the guest.
>
> Make sure we leave vgic_hcr untouched in this case.
>
> Reported-by: Mark Brown <broonie@kernel.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/r/72e1e8b5-e397-4dc5-9cd6-a32b6af3d739@sirena.org.uk
> Fixes: 877324a1b5415 ("KVM: arm64: Revamp vgic maintenance interrupt configuration")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 598621b14a30d..1d6dd1b545bdd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -26,6 +26,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
>  {
>         struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>
> +       if (!irqchip_in_kernel(vcpu->kvm))
> +               return;
> +

Bear with me, since I'm not too familiar with this code. This is the
only function that initializes cpuif->vgic_hcr. Should we be
explicitly setting it to 0, or warn if ICH_HCR_EL2_En is set?

Cheers,
/fuad

>         cpuif->vgic_hcr = ICH_HCR_EL2_En;
>
>         if (irqs_pending_outside_lrs(als))
> --
> 2.47.3
>
>

