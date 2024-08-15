Return-Path: <kvm+bounces-24264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8179532DC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C6901F217AF
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579C01B1517;
	Thu, 15 Aug 2024 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="beqbAlls"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B5819F471
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730907; cv=none; b=NmAyZFRZtgqtOQiBecbzOwtZUhsRLTnSjehtyfcCO8A7nwhGiY/ru302s5gk7Hqwc3X7k2HyVy5KOlKCvuDHbA+n4EnHSGN4XUJvylFa2JVvZXfUM9f72N8HpIOdQehWsP81XE177noBi+L5m3UnMyGoZesKxNRjAqcEJWIQGXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730907; c=relaxed/simple;
	bh=1WCwi3zf8B7UjUYMn2Mg/MGq3dt4hzBwK2exA2fG0ZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jhh2C62QxE26x5cDelRtEs6g26eCWVbPFD2e3yVdhKZ152tnqMcBN9D5WeTQVnXMCYNYy1KrvnulJcjkqKt64nsR+yoS43wMvk8HX+KrzfledtFbzmkeKaWaAzlvMsQoKooCz5zr+TMzpqfZjwYEfxdqcVNyaKrhXOW4bOoAC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=beqbAlls; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723730904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzr3KYLk8750O7gOgaxuZ0lSzVhIlcuDGPfj02xRDb8=;
	b=beqbAllsONlaYSmNgsWKgLSD6EkFW8TqzVinJB1sLZTjZrd3zDWKTkCNojkApIkO2NwehW
	JSkLMfSMDndHk+T0Hac3Nl4eZXzkP4bQyAGeHC7RPoeWFETL+OOgiE3abWO/6HyAuIkIu0
	PqQuxsHiM/dD6SiD7bb5+QtDeiVslug=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-oeX9ux-dMBqIi0iUNZzbDg-1; Thu, 15 Aug 2024 10:08:23 -0400
X-MC-Unique: oeX9ux-dMBqIi0iUNZzbDg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6ad97b9a0fbso20140927b3.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723730903; x=1724335703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzr3KYLk8750O7gOgaxuZ0lSzVhIlcuDGPfj02xRDb8=;
        b=uPveyeYNiKWR8HOaUD34fR28mPzdcsRW2DRNbqxjNDSFRGuDv6FMyvWELvxyK1+Gkz
         Dc6b5hyRu6X/l7WP5LxXNfKBV0Dej5EdolH0zKUDUo7y2dTOhnqL+e4bv2vMOICaXBB3
         OWl+ySS44DOUYLd2hQdDJ1GfAE6K1yjUCC3c2ngNtgX9lrRj6rTdZ5oPqy8EGk3HoMl5
         1T/eiX2OPYqmP4XZTLLVww+tcR7fStMOi8dLK8vqJWVh7ZP+le6bsKnVk10pb+a6yz5q
         YZ6BqE+TmNp7lAeueipYNKw7Oa3XYqUGTjD4klXZSzIuPbZsIfZLGbSuSDyASRFStdPR
         NuYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHqMdq2n4iL/wUX2PurrMkBcriOG6BizJJ/1VUldAIKb9Mt28rw+6PD1sRBzcbRt9jhtqNmdHMipLrWLubIYgAPuIw
X-Gm-Message-State: AOJu0Yz/DI4TQbJRDq01i+smGUfzEreYynBFbDHg43O05wcv5P+kgnh3
	oz6zETN5LdHuACTM93AKqgKUomJJy0X37mpyYPHHZIOutS8b9k4d1iQ8lQdfcU+lguONQaZ1w7N
	ATw5axhhxSv68b/WLx2PpSRCd5HSp3ZKFgyJwRZ2hsovTLdchO5nB5/qb8yq0bHtEBi3APYxu0O
	qrt7U0rSdqtjj0H+/ATTQUH/f3
X-Received: by 2002:a05:690c:4710:b0:651:6e6f:32d2 with SMTP id 00721157ae682-6ac9a4787c2mr61877257b3.43.1723730902726;
        Thu, 15 Aug 2024 07:08:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT7vDXefVC4Et5zdVF0bwaa4s7FPKN+0th/aIjv2bWaCiNvtKshmdfN94YlL0srm5N1LZPSBnK/+GCQt+WDjs=
X-Received: by 2002:a05:690c:4710:b0:651:6e6f:32d2 with SMTP id
 00721157ae682-6ac9a4787c2mr61876777b3.43.1723730902291; Thu, 15 Aug 2024
 07:08:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806173119.582857-1-crosa@redhat.com> <20240806173119.582857-10-crosa@redhat.com>
 <1f645137-c621-4fa3-ace0-415087267a7b@redhat.com>
In-Reply-To: <1f645137-c621-4fa3-ace0-415087267a7b@redhat.com>
From: Cleber Rosa <crosa@redhat.com>
Date: Thu, 15 Aug 2024 10:08:11 -0400
Message-ID: <CA+bd_6LTqGbx2+GOyYHyJ4d5gpg4v8Ddx5apjghiB0vjt8Abhg@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] Avocado tests: allow for parallel execution of tests
To: Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org, Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Radoslaw Biernacki <rad@semihalf.com>, 
	Troy Lee <leetroy@gmail.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, 
	Beraldo Leal <bleal@redhat.com>, kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant <paul@xen.org>, 
	Eric Auger <eric.auger@redhat.com>, David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	Steven Lee <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 6:17=E2=80=AFAM Thomas Huth <thuth@redhat.com> wrot=
e:
> ...
> > diff --git a/tests/Makefile.include b/tests/Makefile.include
> > index 537804d101..545b5155f9 100644
> > --- a/tests/Makefile.include
> > +++ b/tests/Makefile.include
> > @@ -94,6 +94,9 @@ TESTS_RESULTS_DIR=3D$(BUILD_DIR)/tests/results
> >   ifndef AVOCADO_TESTS
> >       AVOCADO_TESTS=3Dtests/avocado
> >   endif
> > +ifndef AVOCADO_PARALLEL
> > +     AVOCADO_PARALLEL=3D1
> > +endif
> >   # Controls the output generated by Avocado when running tests.
> >   # Any number of command separated loggers are accepted.  For more
> >   # information please refer to "avocado --help".
> > @@ -141,7 +144,8 @@ check-avocado: check-venv $(TESTS_RESULTS_DIR) get-=
vm-images
> >               --show=3D$(AVOCADO_SHOW) run --job-results-dir=3D$(TESTS_=
RESULTS_DIR) \
> >               $(if $(AVOCADO_TAGS),, --filter-by-tags-include-empty \
> >                       --filter-by-tags-include-empty-key) \
> > -            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=3D1 \
> > +            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=3D$(AVOCADO_P=
ARALLEL) \
> > +                     -p timeout_factor=3D$(AVOCADO_PARALLEL) \
> >               $(if $(GITLAB_CI),,--failfast) $(AVOCADO_TESTS), \
> >               "AVOCADO", "tests/avocado")
>
> I think it was nicer in the previous attempt to bump the avocado version:
>
> https://gitlab.com/qemu-project/qemu/-/commit/ec5ffa0056389c3c10ea2de1e78=
3
>
> This re-used the "-j" option from "make", so you could do "make -j$(nproc=
)
> check-avocado" just like with the other "check" targets.
>

Hi Thomas,

I can see why it looks better, but in practice, I'm not getting the
best behavior with such a change.

First, the fact that it enables the parallelization by default, while
there still seems to be issues with test timeout issues, and even
existing races between tests (which this series tried to address as
much as possible) will not result in the best experience IMO.  On my
12 core machine, and also on GitLab CI, having 4 tests running in
parallel gets a nice speed up (as others have reported) while still
being very stable.

I'd say making the number of parallel tests equal to `nproc` is best
kept for a future round.

Let me know if this sounds reasonable to you.

Regards,
- Cleber.

>   Thomas
>


