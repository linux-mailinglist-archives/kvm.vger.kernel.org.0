Return-Path: <kvm+bounces-21696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE169322F5
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 11:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84DFAB20C71
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 09:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531781974F4;
	Tue, 16 Jul 2024 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KoYKZkwA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94256FB8
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721122603; cv=none; b=i1JhN1g0GGQqwvcN0mL0GeWSPVLhO02rfGQDimkOoWUGyo9iMCbO1PJGTICICDnPBuONyrmhPpQKKTJAfi0aORXssrzAD0bR0/6SFg0IZ5HHjzAyUKv54GG5PLBoqzBMm4zNH1URbQ2wrCW3nDKh/bdHrwC5rSgWN8wPyrqzanc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721122603; c=relaxed/simple;
	bh=TGuE0Csw2AYqDEukFLo4+DbbSxjFnqKhzFKK13SgBwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6JNjD3Uxd7zMm79NyfBOTwcjdhTsQ2y1bzyskl5nKFQUu7Vmv5sjcjD0d6Jyyoov0h+145Talp00YDnDFYfpjHZ6XQpJ9Lg88BRJhYYN3WfVWuAKtmQo91T0NAUoWdsvDjx40zoqZgIvPWltdnaZKHzS/FyaD3cjNj3R2tyF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KoYKZkwA; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so363421a12.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721122600; x=1721727400; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc/GStB3d5Kj1Bf0cTf6aqXmkTcJcXLB485vy4LOdzc=;
        b=KoYKZkwAJBYHyMKhq0EPQ40nY09cQ1RYsUUDemrGK1mnoMV5zDyXnZiERWcRetsM+X
         8YB3Dk9e0Kzdo46v61rgDucJ65pVBIxrPhpKXfWE7vLwVmICZT/9eJFTOwwOuY40U1Lx
         Yx/RVAz9TGoFVx4gzQt43Oiqhjd6X2Y1ZvAeBSO1FNbpI02I0tQfLlfy3dwaJw+PtTty
         r+x4E6F2ExONtd4FooYxcZMe0loVB8ARy/+VWcJl9NACCfWPMSlp/3wgdhOo3UGt3eyY
         BjICBg7p4UmfFR1q9p6ixeZ7clXUnb51TvRetVX59144LWhiIix9QTGhhneO8uJYzAUv
         hb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721122600; x=1721727400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dc/GStB3d5Kj1Bf0cTf6aqXmkTcJcXLB485vy4LOdzc=;
        b=dUagTbjaUBxWGtfxr6iBO6bQhyvw6Gp9oHsV7XMokKfJbJ0fgVaM2z7Bow/F3L35Cx
         zH68I2WdxXl7ukjCU6wjnyYkFt7bcjO87UKaW4z3beBevJXhQ4sOBNCj6Nm+voro+9pO
         p+I2D7cF7L6Om4OLfD5Dkxd4HGadS1gszqwSqEkKHXFh8+/7afRF72zT02V6qYRVDFiZ
         03z9CYJex9KWJiFczXj8NrxSPAsQobN2CDGbwHqL4O+iSvuH5jt/NMMQrLbfopCkwNAJ
         IZsf54803Cc8BECkh3CFvpP2nKbE1P6eeR8xTuyevr54IWcAlAb50/XRv6NuhA882g1H
         Td6g==
X-Forwarded-Encrypted: i=1; AJvYcCV3FWv7ODyMXotDOtnC7DedTz9T/l5uWbr8jTLIPxdmTzjy9gc8LwVAURPPeLFwh4UgfLFM1Y0MWiplL9hlUNAZ+KNE
X-Gm-Message-State: AOJu0YzjMuu8CX6cb6Pzzawjmd9PBTwlWkTPR0TgkkxWAnhJC7a7RpS2
	dH11c9L9SSdzHckALwuDCQd8CAmitA9bSH4QHg9rCGs0WCbmeqVe1AQ3pa4huWtm5KNthvG1o95
	8pBVA47Ylxe6BeUYVxaP4khsYA5k6i4xKVO47IQ==
X-Google-Smtp-Source: AGHT+IGaN+Ei2ULusap6WGT3oe08l2+JpHlHRDgnm+JkMuCHt9oh4QsPoWK0iHggAtS+dEd5b/8Ac+xbNNu3GwpoJIo=
X-Received: by 2002:a50:cd19:0:b0:57c:70b0:d541 with SMTP id
 4fb4d7f45d1cf-59eef158729mr846034a12.20.1721122599935; Tue, 16 Jul 2024
 02:36:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com> <20240716-pmu-v2-2-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-2-f3e3e4b2d3d5@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 16 Jul 2024 10:36:28 +0100
Message-ID: <CAFEAcA_Rw9ceo6D1mXUhzAim6FmGKvLJOmOFLdCpgbTnYYiLMw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] target/arm: Allow setting 'pmu' only for host and max
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 09:28, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> Setting 'pmu' does not make sense for CPU types emulating physical
> CPUs.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/arm/cpu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 14d4eca12740..8c180c679ce2 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1594,6 +1594,13 @@ static bool arm_get_pmu(Object *obj, Error **errp)
>  static void arm_set_pmu(Object *obj, bool value, Error **errp)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    const char *typename = object_get_typename(obj);
> +
> +    if (strcmp(typename, ARM_CPU_TYPE_NAME("host")) &&
> +        strcmp(typename, ARM_CPU_TYPE_NAME("max"))) {
> +        error_setg(errp, "Setting 'pmu' is only supported by host and max");
> +        return;
> +    }

This doesn't seem right. In general where we provide a
user-facing -cpu foo,bar=off option we allow the user to
use it to disable the bar feature on named CPUs too.
So you can use it to say "give me a neoverse-v1 without the PMU".

thanks
-- PMM

