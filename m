Return-Path: <kvm+bounces-63359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E80D9C63D02
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0B4E64E2190
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604BB328629;
	Mon, 17 Nov 2025 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vLRzdgEB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A2732824A
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378993; cv=none; b=lCfSCq3ZF+kHKOFLsw724iuBCvBU40Fer/grfj7PYmwS3vJ36DuoNQlGnnO4Lhdv4WPuLSuLlOzsOxaQLBv42x/SZA6dr0EWfYeDNbHfTLIbB+QNJIqKQZAL8dbBNWpx2RJCe4MohcBt1g80j7p8FFselMyQ+tVpu5O8LaXZ3Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378993; c=relaxed/simple;
	bh=l8wcHeWSdysycrv/3lpnqDHBw3TkLAFGkLfKnbgKX3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JN4ob1V+ZzTWASUUWpoeJLwqB1REhjfZiiNAWc0Z84LWKm+v4e3Lx23Ot9P2nmwnGZN8TKIN7UXL7cPYqljj6pIM2Kr7wXPF1p3V4zTbaaga6LQgAq0+nvZ9WXO74X1xitTfxIiXroRyKx42gY2xHE1FZIzJq+dnbpTFuXyAim0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vLRzdgEB; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb8d6e98aso673881cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 03:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763378991; x=1763983791; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hyqx4r4nQhUfWXnWTqZF9HfLyEHZr57gV1AR9j4NAXk=;
        b=vLRzdgEBShNr+6DtPze126aRAzJVl9mNPDvO+LMJBgpPpU8aP9DwQiZOVEcVT767ZQ
         2KVMAM0CvY6enRvYQ+q0ElmSTaLiEsaOCxZlH1yu4RZeJekQ4DusFELhvIvtSkCdHS63
         XasRu3o4VprMvODMEOrxdobwWJ660bvz8MSlP/D8PS163BxA9SZpGzD9MJ6QuszSKRIS
         5oaXrcx8/sNFDF+TDU8RVWdS03hKn/jxbNQp8/Fzcm0/L4dUoz9Lda9CfWcvJP1NKwTM
         w77FL2Kfi4vRSvWL7xBl7+0ukA7wR9iZBwbPcNtUgHpamKeA3iOkIYjL4fD2/IMxDjF2
         3PZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763378991; x=1763983791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyqx4r4nQhUfWXnWTqZF9HfLyEHZr57gV1AR9j4NAXk=;
        b=Igo5v8lggw1//uNiqkGNv70XX6fl0aBCMsZdwo/Kf3c5kMM5YT+lsa7MwHKLKUbHSc
         nlhMEj4e9GS4wb396vL7f6zUXmInxvuD/Yj/MiVuSKBuZh/gpe6ut1jqgcsvhXLVPh42
         RKDqZiO/PI2Cg+OHq3HjmxOTvXFhNS7Zr8CfV+Ni9oiAIZgiWKdY2t2aTc+gEFPF/GfN
         IQM5SLeGzaBqiVz37NScW2qSHqgFaR89SiW6uCBkSXTlhS6qMRkSwTvgN5di8cgyzQQt
         HdAFNb/66gTooYBD0o3esnYXvD9n+VifGH8HMpgh7vfcrI7SHYhmb0vWnFkcZPMoTtUr
         KVWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX36TvVQ9Q0KfTdbp+nkmDA1oqLWlU0edre74NspAdVoXaVe3JIars3GRETrJKqdkUH5Js=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaMliAJ1+tMmQWQeDH1OuvjdxdOiZ9vcxwM/a6yoV2JOamApvj
	hMuWg4ltd+FzCRFEQ4rGMrZp0c1359UMLZ7X91439I+Izvp8ngB9oyFCazJuSQWxLLdcSN9bym/
	C9Z7lcg1P/HGL6PLwaWa0YN0zmyNEBAa6l/4FDZdp
X-Gm-Gg: ASbGncsTXXqlzkPbiNfNci7OZ58pqYHXOZxqEgVh+ntnHxDDKkWY1YITZaVYzPnbHBX
	TUARbGgITD4o5JEeTgl+NyvEN+LSfj8nh59jtGKiB+wmiqt/v6xdRcT6x1x2BtWR40oSa59f+fr
	c4P/h5t65KvxN77O0x9d7AC0WM2/w5QkjjmNfFCnkU9r8I2baLEF06vbkIXhpITMWM7W+xZ2c/Z
	okGs0DVGlzSvZ54ferOf7zdsIAd0D65IuQ2xe1hGnNpK4uhDU+lIoqoDJC7PXy36bYoru/gTs7W
	DF804g==
X-Google-Smtp-Source: AGHT+IFIOxZ//wrmDM1cUR4nb6LDG7ma+elT+J0SRvK2XWzC5avyhLG6D40y3PR+JjZ4wC9eFj5753jVYjCTDfo9sNA=
X-Received: by 2002:a05:622a:4f13:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ee02a994a9mr8299811cf.19.1763378990715; Mon, 17 Nov 2025
 03:29:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-2-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:29:13 +0000
X-Gm-Features: AWmQ_bmzdmE29Dyex3S07XvvcAkxx0qUh2gMXUSYHUgIgZOO3S3AS3FjH6bjm7o
Message-ID: <CA+EHjTxUhpUT8s0v6P=TNTqwHnF32arTsd7SCXOU+9uJ3wO82Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: GICv3: Don't advertise
 ICH_HCR_EL2.En==1 when no vgic is configured
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

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

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

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
>         cpuif->vgic_hcr = ICH_HCR_EL2_En;
>
>         if (irqs_pending_outside_lrs(als))
> --
> 2.47.3
>
>

