Return-Path: <kvm+bounces-21827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EFF934CEE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 706CB284787
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B30013B587;
	Thu, 18 Jul 2024 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pbtkc5b5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A812C473
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721304526; cv=none; b=rcEL6m8ru9Cx5QCp9/Ek5tOoMvIH/cfGIY6oocasu/jLNAcAlrBVxOklrSXLPDJXGJfGTwJAScb3ZgbaoS9L8yxs1TIImpRk9h5sa3pCwKuXNVWJ4MrjLTWf1wylMWn+VpM41SSvPjuTOk00/3V0hYUkbRwQxZs/f/DzowISZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721304526; c=relaxed/simple;
	bh=MYJZgbRdVl5ViYrgIzR/C8ywSj7c4Qqz3fsPPB6sq+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAYgiDwgWU3no1VB/5xJRZPUavr4k1hXohWnRFD4whOojerarXwh/TcpaDvBz96KLU+Yc3I9MxrbiPNkQsVjmgDUAKspjYxa04xRP6m4OXhNDdzNtcaH2DzKzljYHzDfpglsr5FnFh30aH5IPsqGO+VMAmSdneJn6QJYlDsRHgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pbtkc5b5; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-367990aaef3so413471f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 05:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721304523; x=1721909323; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GLztguu0/1A4o5v5HJNeEefOunzrp4ZbpPmNFDAgcPg=;
        b=Pbtkc5b5N2g5Y0c3C3Oj2bA/eiLeYnUJ9GwRrvjiyd/fau4DGmZzvOeRwVY3Fgkg2f
         cSnqEgGWXmIeNQAsnKr9+EjLjOA4eAvA6q5EtOCBsJlKMKvPThfG7UMxfgKb87ATQ45B
         XsrqAZv9A7TWglGmYJEwv1D4CHall2Lo/gmvtpoUh/h1XHLaK2utX/Osb0+m4JOVGPGy
         35PgowBCULG++aZtwisauBoaBpN3KZ821o2ZesuEtDhN18iFfq0/tGJDFbvZ4oPNyGTx
         x2Sg8EB2eykGqOU+kS4SMhkA9MHJUL+Lf4I5AloN7iY865AQ+dTnEg7m//vpP6VsyPO3
         BUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721304523; x=1721909323;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLztguu0/1A4o5v5HJNeEefOunzrp4ZbpPmNFDAgcPg=;
        b=eivxxvaa2eewAZwdM8DPcqcDWpHiKlzZfDaokT/xjdhwZOMO40yzTSP4BOWSgqmTX8
         AVqm/YZlunX6DahKn8D9gn+kZv/qHIGpxtHxcjsIs5/B/vQqGxcP6GHu21+jgv2XoeR1
         tTcqn3m1GkwPj2eEbktTFVoSwlkpY+nHSY69yzevafg5K4mmMPCk3KKsf3veH0GoHB5J
         E0xKcdg1ZKmh5UpPyIKQHUCUO8E6vEKFOkAOSG166phvhg0Juc0nZ5MUyIrKTg+CHxcF
         jkVUftMbZTdDPyjj8ylzQlD7LoBFI93hVqRY8WDX0sZW0LHSHVDO8aIZ8PJWgK5tOWtZ
         ogyw==
X-Forwarded-Encrypted: i=1; AJvYcCWTtOW/FwXU302g6UOw51QnbXawf1jm7fcBFtbEi2GFnIVI+dA2UyVxW7SguShflVrMnZFDCVngaNTZYQr5cq+U7iju
X-Gm-Message-State: AOJu0YxsVKO31gPGOiVnUVUrfJ4F+xilRTfqQrVWorHHAL+H7j5gqQhl
	RIrqczw8ujZ2+Xqtauqw61DFIZibk8Q6V2wKJSsfThZY/onwQXkAUpYDZYspqwrhFes19kGPvJV
	4j2zS7Iar2wDl5+REvyG/EvgvDrfm+m7mM3blBA==
X-Google-Smtp-Source: AGHT+IFZi/ClEd1999CMZYBhdXDHi2vXXiykQQ5Z65X5NS9p1qChrm7Xj9mXD3K9UBh7qPuKeG1NYWHBprbDW8HJ3DU=
X-Received: by 2002:a5d:54d2:0:b0:367:8847:5bf4 with SMTP id
 ffacd0b85a97d-368315f3197mr3207156f8f.10.1721304523412; Thu, 18 Jul 2024
 05:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com> <20240716-pmu-v3-3-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-3-8c7c1858a227@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 18 Jul 2024 13:08:32 +0100
Message-ID: <CAFEAcA-5J-ra-gHTcC54eOP9qUFCtXzKhePhkRhjj=Q7HyFqVA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] target/arm: Always add pmu property for Armv8
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 13:50, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> kvm-steal-time and sve properties are added for KVM even if the
> corresponding features are not available. Always add pmu property for
> Armv8. Note that the property is added only for Armv8 as QEMU emulates
> PMUv3, which is part of Armv8.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/arm/cpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 14d4eca12740..64038e26b2a9 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1744,6 +1744,8 @@ void arm_cpu_post_init(Object *obj)
>      }
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
> +        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> +
>          object_property_add_uint64_ptr(obj, "rvbar",
>                                         &cpu->rvbar_prop,
>                                         OBJ_PROP_FLAG_READWRITE);
> @@ -1770,7 +1772,6 @@ void arm_cpu_post_init(Object *obj)
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>          cpu->has_pmu = true;
> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>      }

This regresses the ability to disable the PMU emulation on
CPUs like "cortex-a8", which are not v8 but still set
ARM_FEATURE_PMU.

thanks
-- PMM

