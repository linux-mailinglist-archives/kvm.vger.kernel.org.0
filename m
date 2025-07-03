Return-Path: <kvm+bounces-51490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21135AF760C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 295754A6473
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4842E612A;
	Thu,  3 Jul 2025 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LOQ7eAi8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD112B17C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550406; cv=none; b=n3TZC0RBUs7y/WfhP1+k4vcILk/Ftzm7NNAkkiiHe1BAOQUIgY0Tsj3+ylXyas2VSU7KvYUJk9U8GrU7Y40VlRH97rw2Zob4tE/CwaFMh1u1XjvDCy2f+6069WluHMqcAwNe8E6+1WMA4Rpel5pU/GXbpP56cBJr0XOdCJuvqCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550406; c=relaxed/simple;
	bh=qZ63aL+2lKAgYqRLRoqzWvaJUN9hKJQVEJ8qxOLnbBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TQF+dEb2wF+e5ODrWs1uVI+HLhBouCq3DgO05PmZROTXHUrwGsv4dYRMYEnDBB8ug2BsoZapUG7sjhoG71DF8edvXQw0XimeDfdI3ogMxkinIJnJ/IZ1rew6QWU7rdSOpf1Tz5KPMahND2HvBLJWqSMSlJW1hUxY9eIdr6IH42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LOQ7eAi8; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e818a572828so5585189276.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 06:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751550404; x=1752155204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flS6TFeOZvoyt/ARcs3LNzYAUhneQXJ5kq+dG0ggD4s=;
        b=LOQ7eAi854Y4O17umwGjQtW60R6T2PggXgi07d1TnNRjOQRLodvXD5XXPKWPSi+3lS
         rpqrM7onDOeIes0ckSL2m4/cO4hph0DvEHyd8Upyr4S2kD11d4ggsKTnY2xR3hcLh9va
         CVcHT/c52PXRWKd5TVD52OGkX0fN6idC0ZizigKYmgzeUniXo8xdoTe6QhWQvn5HUHXl
         XARuZE/OOUeazn3AGQGrnW2yXDTWw/ZIaOn02JnDa35x+m+sfUfQWLdpdNrk5hOtQqDq
         Lvp9gWUnj4h33/FjLehAyNY1anOsj27De6n9ewoGB816lVbIl48wZD0OJ0c+Hcdx/8Rz
         QwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751550404; x=1752155204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=flS6TFeOZvoyt/ARcs3LNzYAUhneQXJ5kq+dG0ggD4s=;
        b=WSmOuFmvtmXIfOoS6StLMSIxDMYaqKLh5rcJW4GCWcBwZDWg1I+kT0upPLjvtXHITF
         rigxTBW0bo3nciuwD5IevgAcQ+ZqgBTeMtyTX9FIRiGijBDRyRAvAOtNeyEVW+m7tqXt
         TGkLF8VJvtKgwmQF2KIdL37FkiIZBDNw0bi3Hpp+I8x6dYsqhprpfNHk8Z3nr9laM/JG
         wMYsRHr2QSmQeETxwtw/nf8D/1UgR2WD4li83ERUncxyqt4DWf5XlaT5s5BKE45iBpGI
         5TezPWklUU03gmNRtk7tEWPnEqMc9woLoUybcx57cDYjip3iM3Bgt6nOEAzRr7w6oLH8
         oHhg==
X-Forwarded-Encrypted: i=1; AJvYcCUOxdutrHjJgwwa7flirivNt/M+NQNLQeCyBueZuUafuxa2/tOlcnAgzUo0TCvliCb0xws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3ohSTEjLJJ9bfs72P8Z8IOdcK0s+bhH3kNTrng1/s1M3Tcnn0
	LRB9NuTgnrCK3UlzQNfPS/PyiFqj5QoPv3WOkRYJEjC7gvMBrIc4hA3bpRN7Ice8QmI1Qd4AzkI
	I/JwZuIG48koHYYWbaC6Ctk+tp+OJ6/m8oeysfrARKQ==
X-Gm-Gg: ASbGncvFJqwbLlfkKIxa7Z402ch1HZCuP67LINjrt2z6rF3j017Hmnh4aDZhC1zXwPi
	rAwDb3b4c7Yv95M4qXFc7mqkR14Tg4fi6zEImVqx3JFs9IFDkA/H5ZaqmSy1dX6pslBKMYDnRGp
	oPAWnWBtcR5EIGzvpfY313wafprXXN9Q3sD6P4GgxSD1yV
X-Google-Smtp-Source: AGHT+IEMZm719qroFCgdt+NB/P2u1+uK5R7VzorJ6VDNhLe45GJPibffuoP2EDxqdgaryg7WVzX7vUG/Kw6HwGwMdcM=
X-Received: by 2002:a05:690c:60c3:b0:70f:751c:2d8a with SMTP id
 00721157ae682-71658fbc2f8mr48735757b3.3.1751550403709; Thu, 03 Jul 2025
 06:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703105540.67664-1-philmd@linaro.org> <20250703105540.67664-48-philmd@linaro.org>
 <364dc354-ba78-47c6-ac65-2c0282e28733@linaro.org>
In-Reply-To: <364dc354-ba78-47c6-ac65-2c0282e28733@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 3 Jul 2025 14:46:32 +0100
X-Gm-Features: Ac12FXyjoUMUshc9DoTiWVwetwZ0Q9yjCJVVjro3qKCKC9YYLxR5jkB-AbTrEyo
Message-ID: <CAFEAcA8-ucEJPgVLpBfNyMo8ax-sR6iYr5Zk4DJavYaOkQnfDA@mail.gmail.com>
Subject: Re: [PATCH v5 47/69] target/arm: Use generic hwaccel_enabled() to
 check 'host' cpu type
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, qemu-arm@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Jul 2025 at 14:45, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org=
> wrote:
>
> On 3/7/25 12:55, Philippe Mathieu-Daud=C3=A9 wrote:
> > We should be able to use the 'host' CPU with any hardware accelerator.
> >
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> > ---
> >   target/arm/arm-qmp-cmds.c | 5 +++--
> >   target/arm/cpu.c          | 5 +++--
> >   2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> > index cefd2352638..ee5eb1bac9f 100644
> > --- a/target/arm/arm-qmp-cmds.c
> > +++ b/target/arm/arm-qmp-cmds.c
> > @@ -30,6 +30,7 @@
> >   #include "qapi/qapi-commands-misc-arm.h"
> >   #include "qobject/qdict.h"
> >   #include "qom/qom-qobject.h"
> > +#include "system/hw_accel.h"
> >   #include "cpu.h"
> >
> >   static GICCapability *gic_cap_new(int version)
> > @@ -116,8 +117,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansio=
n(CpuModelExpansionType type,
> >           return NULL;
> >       }
> >
> > -    if (!kvm_enabled() && !strcmp(model->name, "host")) {
> > -        error_setg(errp, "The CPU type '%s' requires KVM", model->name=
);
> > +    if (!hwaccel_enabled() && !strcmp(model->name, "host")) {
> > +        error_setg(errp, "The CPU type 'host' requires hardware accele=
rator");
> >           return NULL;
> >       }
>
> Consider the following hunk squashed:
>
> -- >8 --
> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-feature=
s.c
> index eb8ddebffbf..bdd37cafecd 100644
> --- a/tests/qtest/arm-cpu-features.c
> +++ b/tests/qtest/arm-cpu-features.c
> @@ -456,7 +456,8 @@ static void test_query_cpu_model_expansion(const
> void *data)
>                    "ARM CPU type", NULL);
>       assert_error(qts, "max", "Parameter 'model.props.not-a-prop' is
> unexpected",
>                    "{ 'not-a-prop': false }");
> -    assert_error(qts, "host", "The CPU type 'host' requires KVM", NULL);
> +    assert_error(qts, "host",
> +                 "The CPU type 'host' requires hardware accelerator",
> NULL);

Grammar nit: either "a hardware accelerator" or "hardware acceleration".

-- PMM

