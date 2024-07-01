Return-Path: <kvm+bounces-20792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A561D91DE68
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 13:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04754B229C9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52311422CF;
	Mon,  1 Jul 2024 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHAJrN4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE731422A6
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 11:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719834854; cv=none; b=ErIto9du/4T6IA+4MqlYtlyNeXfLZZDLzqeI+/GOXUZx9FM8hvP+VTrduguUGHlaogDCgFs9ooDH6zfRddNQFNplntN4F0L36Ogl6oFp56wmfoCHLtfOqQ6ppYlc+xuanZBkUF7OmjCzbchpUyzvSKv08ZpriCQFYnl5/hRDhO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719834854; c=relaxed/simple;
	bh=NSnqOxAMkGMmE4H/fXnInK6p9njlkXFIBNS7QC24gkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bGGJQ6nYpTebwmRDTOq1q1xzThkbHUm48pPbJ0ouzvSsIlyC5V4FVPAQkJWuRO/sOciRzGd8rShC8kJly0DuKBBzWqYrHK97JSL9OE7srX6+9xqTGzlReky1QnpaqpT1cMm+606ML79Q+GkWaVb80jSW8Aezc0slmIljrQvgbPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jHAJrN4x; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5854ac8168fso154867a12.2
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2024 04:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719834851; x=1720439651; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=diWGSKEJHDwNS9/KY+g5WzBWyzvSwg7wbXFwFcc2MUU=;
        b=jHAJrN4xlZloEv/+LoFP8+uQYUjC1JMciLJeooR74OyUqvSIXxu1SXfDude5J+4hyK
         KBp3p2uyHtvNh0FwNyLwbjVFtg5yPnDseNLOtjPcUXzOPr4erf0KfPWMCHzvS+yEuXAt
         UNiA81Cnbyvnv5dg8yuf5SRHTcWfJpum/Qs1QVOXc1+xQDeg4uQ0GH47AKHBr6EGb8iZ
         saaeMGqyC9yS6xpa++hXSPz05xndDUaRL7GiQtlKN1U1XrXvLA8eV6UW18Ej15zAos8L
         zY121DrtvAri0bwYVIto0dISocf124o4EoQ4gqmIAbeh0EsjBJVDO14aTuDogxNZDoqD
         tHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719834851; x=1720439651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=diWGSKEJHDwNS9/KY+g5WzBWyzvSwg7wbXFwFcc2MUU=;
        b=tp+pvQyRQ3QY2WzTEnAo9YPBnLoXRupavpAvRuYq6T+M2pbnhaDTcYGrUZjtX3Hgf8
         z+GXiJK15yTJmaLxZrNfYA4me6w99H4h/sKqaD7MML4fMkHWZyQj1RmNbzlOHiQl/6u6
         kkIJDnIs1eMioclV0m09N+2CnP58aFg/rqNOq7IE2aHPhZ6mmAQNUvbfERGks/ZX6L77
         A6mAoKB1sboJPOM7FArkkdZyFVqG2jWA+t4SsBnw0KTJW7IfsTe41GGQwFu1QuuzxZcp
         UhWntAGVzisBxfpL35eYQS6xDxRC+Kz1MeFgVrH13FbFSGuV5qyPD/+jXXTBHZz2ZnKH
         xcOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrSxeh7CInw7jQWqeVJWKeFrddsuuDosgYntN3aM/1w/Y9Tl6wZRdvjirP2P2egUk5LsKMOsmsLdh+hLIeAPO7mowh
X-Gm-Message-State: AOJu0YyL0+VNBEKiFB20jPGzW5zedvEMUPsYUq870tQY2hcNS0pQQJro
	eb+g7QQMPM4dGzBi8LOHntD5ntJoXSb8ZQZ0OmriwYhtHVzi3T/i9kJeaRphLC/QyGfOesKk+Cx
	VZpNR5gI00zF4IcmkkKRYlyEL2MpWpy2s0wqbwQ==
X-Google-Smtp-Source: AGHT+IHijEQAOAUqWvxvsqstKl8oRdB2qisbNKZcyxSfqTzMzvglDMVuDwrww+L0z/qQ6Q56iIe2cXQ35tP0iJAOC4Y=
X-Received: by 2002:a05:6402:908:b0:584:2314:e8a0 with SMTP id
 4fb4d7f45d1cf-587a0b0377dmr3235232a12.28.1719834851320; Mon, 01 Jul 2024
 04:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com> <20240629-pmu-v1-2-7269123b88a4@daynix.com>
In-Reply-To: <20240629-pmu-v1-2-7269123b88a4@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 1 Jul 2024 12:54:00 +0100
Message-ID: <CAFEAcA8FQLQF69XZmbooBThA=LeeRPDZq+WYGUCS7cEBiQ+Bsg@mail.gmail.com>
Subject: Re: [PATCH 2/3] target/arm: Always add pmu property
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Jun 2024 at 13:51, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> kvm-steal-time and sve properties are added for KVM even if the
> corresponding features are not available. Always add pmu property too.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/arm/cpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 35fa281f1b98..0da72c12a5bd 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1770,9 +1770,10 @@ void arm_cpu_post_init(Object *obj)
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>          cpu->has_pmu = true;
> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>      }
>
> +    object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);

This will allow the user to set the ARM_FEATURE_PMU feature
bit on TCG CPUs where that doesn't make sense. If we want to
make the property visible on all CPUs, we need to make it
be an error to set it when it's not valid to set it (probably
by adding some TCG/hvf equivalent to the "raise an error
in arm_set_pmu()" code branch we already have for KVM).

thanks
-- PMM

