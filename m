Return-Path: <kvm+bounces-61199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4491CC0F8A5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B202400499
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8065D313552;
	Mon, 27 Oct 2025 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dCWMGFx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CF92745E
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761584849; cv=none; b=eR1iTFglD14qv1ed6SqCa0rG37NPedtU0B25GIFf1sX0G8HJjLX57NLYd8u7J0PDaxNkuDDzYHWGBDWNv9sna5qMiO+52WFtxwaL1ZH7DdDuoiBVlCJYFq8hSMmRDZBw1D/djPnTu5eK9KoIxMWgq4J1glmplshq202Nc44Kgbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761584849; c=relaxed/simple;
	bh=9a3+v5SSQm9CFNXUiTCelKARraMR9+J5h+medQHzgkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czqU4CNtwEN3cA3XXELw/Y66bHQL8QoBJg4CG+WPDQ8NyZ5lA4KqpJ8Ai2rg8/o925/VifB4J+w/HK7t6/62GjMWJJ6k1vsRjZOCnU9Ugst1Vokpzn3aAGAk6VNHa4SXmWwHVaIroqe384uRtbu4+GqDiyacxu+Qk4ggRiD2ubg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dCWMGFx3; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-63e393c4a8aso5870329d50.2
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761584846; x=1762189646; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9a3+v5SSQm9CFNXUiTCelKARraMR9+J5h+medQHzgkI=;
        b=dCWMGFx32wpjsXFX6hS318deWHwzY/2KXq/PHvQmPqHPCz17NxkzLjlHD/3da0/bKM
         FGTPqWGhuE7hwTfAa6YbZinjWIYP/YpijU9EDgEtyYFlA9WgCncRkNBgGMkY6D0SGnZ5
         O2CgmJgoK6yFCHUnIjxabzQRix667NqH6/Z/oGXEx9/F26SjQ5lmEN4lc90UTBb1BYUi
         Vj7+gT6X2EPm2/z663mmytqpuEwEsfM8UY3Z7beMMjkrMQIOTckwufe0OTaVjPgV6Z73
         bse0eyY0ACURbMrKhNht24/nLeOOLU3DbNKyiLWihgo+PGccSUByYGAq8pk1gXu69W/X
         ht6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761584846; x=1762189646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9a3+v5SSQm9CFNXUiTCelKARraMR9+J5h+medQHzgkI=;
        b=UOkLgNoGiiHRegLp469rPKN+3sWWXn6BawwhXmabBmJxgsWleq/CoNvYxUlOubp/Gw
         LC14NbFtHy8R4aLQHY7+dN8IjCemaWEv6tJuxALGtR8QjuxeOFJiGnGRExCuQNF40BG1
         mSsD5soDewLZ2gfGyYfsdzMCzGGY1R6Lj6CY6bBxK2GL8BIU51/cJyZWHGvX0/ON6tH4
         t8mmoZ+zpPSZU3eQk9pr2GuPOhwTELb9h1DrOkAYeP0SzbnPv9ZLCe9kiNs+1t0aNKDC
         jMACrcav/82e02dBW8M1QhzPHZ2hCS1c5CcoF7V8waERIcIkl4wgxBXsRYfHCWgD9bUV
         nHFw==
X-Forwarded-Encrypted: i=1; AJvYcCWZvA95MoiH0q7AXOOhuEO6HfnsXdfaYIl5CqeFHcSY2xxjKAcHMuM8tvcvOcyJh5mew7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwLUwe8yXIgjJUmgaDD86xDvwQEacBS2E53nwaqgCHLfqJn8a2
	5FrHVR6dmUoLQG+aPvhYjcWJvoRQI/b8YYVMeOi00E43UfnZJVcyALqphcbWIaWU4H3wcj6fXtP
	St3medRCB16DIQK8U7P3JX+bBql7m5hfO7VXRAlZNvQ==
X-Gm-Gg: ASbGncsLUGfStSj7K0RFQ+ffES5tw683WvYIpxBX5fUJQRY8+U6/EgoqipY/ViSmJXJ
	KcsEWwpAr5mH8quzys1emY4C+q2iOecDmBcDSEG5LbAjWKR6rD7yzpB6eW4RR8FDhSOxR0ycCXK
	Y5bBxoUE6jSakxNKMEQ+9dVWLC2XO1GtSt+swPiSVxvR991l/BV3vu18zeDSAfWliOhoLZUqsQj
	12NJq0UanJ7fE6aMBgS6E601MGlXpWDLBhlMXqWqWLitD1ngFF9VT5qUr8fgg==
X-Google-Smtp-Source: AGHT+IGaTaPWC/WOrfEqNVYhpfV9r0OjkR1NtUO5NaJbkPQpnMmVRGjIDGUpgnQjORUQZ+ZZt7Q98zHS0ED+M4U4bI0=
X-Received: by 2002:a05:690e:2c7:b0:63e:1031:9a2b with SMTP id
 956f58d0204a3-63f6ba40150mr496652d50.40.1761584844928; Mon, 27 Oct 2025
 10:07:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-4-mohamed@unpredictable.fr> <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
 <29E39B1C-40D3-4BBA-8B0B-C39594BA9B29@unpredictable.fr> <CAFEAcA93e6GL9agaCBZ2AabB21JrS6KS6MsbRHGPwdc_vj7xDQ@mail.gmail.com>
 <890B1091-0ADB-459F-B1C9-173EC32DDADA@unpredictable.fr>
In-Reply-To: <890B1091-0ADB-459F-B1C9-173EC32DDADA@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2025 17:07:13 +0000
X-Gm-Features: AWmQ_bkJ5wc1isPc1iZpVsJRHdyiMm-ivEfqxZwcgJGUfHx4zKryr8V0lPngkKg
Message-ID: <CAFEAcA85m9FPGfm_tqfM6zsLC2C2+0fi+VWSBk-bojtaP_LYTA@mail.gmail.com>
Subject: Re: [PATCH v6 03/23] hw/arm: virt: add GICv2m for the case when ITS
 is not available
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Shannon Zhao <shannon.zhaosl@gmail.com>, 
	Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Mads Ynddal <mads@ynddal.dk>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Pedro Barbuda <pbarbuda@microsoft.com>, 
	Alexander Graf <agraf@csgraf.de>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Oct 2025 at 16:53, Mohamed Mediouni <mohamed@unpredictable.fr> wrote:
> > On 27. Oct 2025, at 17:03, Peter Maydell <peter.maydell@linaro.org> wrote:
> > I guess that would be an argument for the "give the property
> > the right name so we can say "msi=(off,its,gicv2m,auto)". Then
> > you could say
> > -accel tcg -machine gic-version=3,msi=gicv2m
> >
> > to test that setup.
>
> Is there guidance around renaming properties?

I'm not sure if there is. So the below is just my
initial suggestion.

> Would it be proper to do:
> - if its=auto, consider the new msi property
> - otherwise, use the its property

I think we should write the code in a way that looks ahead
to marking the its property as deprecated and eventually
removing it. So the handling for the new "msi" property
should be done in a way that doesn't need changes if/when we
drop the "its" property.

We don't currently attempt to detect oddball user
commandlines like "-M virt,its=on,its=off", so I don't
think we need to go to any particular effort to diagnose
the equivalently odd "-M virt,its=on,msi=off" etc.

We can implement the two options as essentially
independent, where "its=on" is equivalent to "msi=auto"
and "its=off" is equivalent to "msi=off" (i.e. what
we currently have as a bool turns into an enum, and the
set/get functions for "its" and "msi" both operate on
the same underlying struct field.)

thanks
-- PMM

