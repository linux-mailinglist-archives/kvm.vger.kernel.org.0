Return-Path: <kvm+bounces-21700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5591F9325AE
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 13:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E28B285562
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 11:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169B7199249;
	Tue, 16 Jul 2024 11:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gKeX6m7D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790C515491
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 11:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721129565; cv=none; b=QEcxQqYA6Q9iijuYAVg9yGdIKf9JPmO/lUj2KrHTTb15oIVEPmIwZz8LsXzZY2Xp5O53iDCX1+ETWjhmmigUmqbtK30lujz/NyOFL5eGysJHRwsdzxV8+2rm3z/rBh9KKy6xzLM1eG7XJGMKpmoeI538SCvFbNDOyxVDt3gcWSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721129565; c=relaxed/simple;
	bh=7eKp7AYkI86hZTovQJ1MoDAKgtvNK5kKrmMGmO/VAnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ytg18O9alqDOLo6ECgrVk4aorGWrPD4OPVp+rMaTU7tmLsqL1anialiGXmIVzX6wS+SHb21yY3+JaN9ZkDaQ7ELVoJX1WmFzbZcnx17kTlWg3R8bzqwQCNtJ8CX5C41c5TJh8rcz0RC3XfVyj//O8spG5pSW2g3WmecsHh6p8bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gKeX6m7D; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58c947a6692so6929647a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721129562; x=1721734362; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v+UbT74xhk+b2SVYVJW8InGMelgItyrvL9jYPz+CIMg=;
        b=gKeX6m7D0gLraRgFGsXPonB8Vqk1cF5HyRsNvgPcjaXaqwyS1Ycwze7ZvOrvsRGGhB
         KCPOLVQUoz753Y3Er2rb3vogYKZKNDV/7dZJWkqsRyg02VU5yYamKPUod+Kft/il1Pdz
         decCeCxnYJdUOAGOUayDFajTxIcuO6pfbTmz86GTxfi40cdzoln9cDHvOYqwqvPmkrUu
         hbWdqfX3uFeBH41Iwbw4FqbCkA6UquxwaWSafpII5SbsNSYwUckuIPTMNWeVFWgs9lE4
         6g2iCKYCFLye9WB+LNNhxVjhCYZaj3h1Tyn8sj9iQvQs7R1clCCTq5EWUMsnSZvT9NXt
         zm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721129562; x=1721734362;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+UbT74xhk+b2SVYVJW8InGMelgItyrvL9jYPz+CIMg=;
        b=fv4nwyvQOnpzP3mNANTLisCZzEevKCiRJuxurtNS/+IJ9Ap+HvrYZrJa6c7+SALZje
         vbo9TgEvpnb//mYDXAvmbZMWRXGs0VUUeKFaiUxlsPiudZG5FOWUPeQxFG20OfDUKvyD
         p3fFxER53lIHOx1Xl4Zp2tf6IxuhACcMczMQQmlWGWwjVCUda2KcsUSRCklpKObYi5tp
         gE3QKYnpqvzUyFDwB/aceLY2geoQTTXhSm0GQuZq5Y/AwFGSn4Z6Q4Qhw3zqpFg8+6fv
         Ag2t+sFOstyxzK5cQH7yvP9PSMqrSQlEAc7goYDy1t0PQswM4qlJz/DaEVsCox5qDHzL
         Fr1g==
X-Forwarded-Encrypted: i=1; AJvYcCVnMJIDgFct/ET7UXPrs9D1w+MroC+7XGC1gC8AbVjuv6kIt5m6V30jdIFn/A73fFfq4sOvWqWYEPjUG+75tPYu00jm
X-Gm-Message-State: AOJu0YwgR/Vq726/78ipMAhQpy07HMOMrvzzeEDjAMMGPsWT4o1MUS+D
	ejS/VKXpTEx+qIRtC8TzAlIeL9tEyD0lbOLia7RUK8ZQ5SLvbVCzVC63vYiNbbOrjh5lBm+LZn7
	Vu69FCsvHc1/ca/bsMx7/ZJ0m3pEvHGtYl0qRRg==
X-Google-Smtp-Source: AGHT+IE+O8dqUI/OG0kgY2BNmik8WSmu7vBcnDW2s3w9tfiJgcv6WUep5/b41oRdvvBiFsk2mgfhVG4zmvbSX7UPnZI=
X-Received: by 2002:a05:6402:3582:b0:58d:ebf9:4e2d with SMTP id
 4fb4d7f45d1cf-59eee833de0mr1345309a12.2.1721129561829; Tue, 16 Jul 2024
 04:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com> <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 16 Jul 2024 12:32:31 +0100
Message-ID: <CAFEAcA9trFnYaZbVehHhxET68QF=+X6GRsEh+zcavL-1DxDB4w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] target/arm: Always add pmu property
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 09:28, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
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
> index 9e1d15701468..32508644aee7 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1781,9 +1781,10 @@ void arm_cpu_post_init(Object *obj)
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>          cpu->has_pmu = true;
> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>      }
>
> +    object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> +
>      /*
>       * Allow user to turn off VFP and Neon support, but only for TCG --
>       * KVM does not currently allow us to lie to the guest about its

Before we do this we need to do something to forbid setting
the pmu property to true on CPUs which don't have it. That is:

 * for CPUs which do have a PMU, we should default to present, and
   allow the user to turn it on and off with pmu=on/off
 * for CPUs which do not have a PMU, we should not let the user
   turn it on and off (either by not providing the property, or
   else by making the property-set method raise an error, or by
   having realize detect the discrepancy and raise an error)

thanks
-- PMM

