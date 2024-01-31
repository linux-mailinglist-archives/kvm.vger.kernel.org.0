Return-Path: <kvm+bounces-7597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F19038446FF
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 19:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5B301F2237C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 18:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FDB130E31;
	Wed, 31 Jan 2024 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G28eJ3xU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E884A12CDB8
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706725251; cv=none; b=SajwGEm5B37jLkwfe4Mv212m8Gm13MksggNMAJftiMrUB+TapR4f9MxHyDQj2d9CJd9gVOsw7kXLNtTQAy1axA+2WOhdks5Q463vA3iOZQwldaZwMmJ4EtmE1L42T46J2gSzvwZEyEjVIwpmzeXuwSi/Fftvf+uLTI8kjx8Rvm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706725251; c=relaxed/simple;
	bh=BQ8gjiQ4pW3QLd5SlI2kujyplyxtS85Ic7rheVOqnQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uunM6KxjJRpr/ZCrwr/kefas5NhW+cOOxoqmcvlgAVyUInaxkrmUMVPL6fgRomrePVlRayvgh8IcH7u9iIXfTayuY9z/zMorKMwak1A0q3dTxptwrzxZiyDyn2FTbutNedbzJDRzkZuKLWN2yuOXgghr6a87GpNun0IgNIrUYVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G28eJ3xU; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59a45d8ec91so30669eaf.3
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706725249; x=1707330049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5nzSUsGtwDOpa5mVgavX+vD5ccBHZ1+xybNzom9gkDM=;
        b=G28eJ3xU11e9iLNSJ2YG+Tr8hg8S4KJJSqoIdlXALeKBv1TYKHjwhJNJlGWhSFj5Er
         /BkM6hqnMX/eTql9dKOdiCCOeCuAWSRMk4QDCN/yZ+Zhq2+HxT/GHkpBH0PccE8idOz4
         tPcz1k6Y1PqJyRw0NRD2o1Bh0HNw2dvnCILARPTFhBg4zEgA/PE3TvGwV1fICXmES6+9
         sfQC5nrsEs9+p7oRKwf1ZbPPwiHMqx7zfKEHWn5qOv2RHe3FeMPsrYT1MzmaD/rzJuoF
         C4Jpl2KY0CsMW0KK4vg+aYOhbeEbI486Vr30C5YwXyjmePWN5AjEtOSPPvLK9uYFveBJ
         xOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706725249; x=1707330049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5nzSUsGtwDOpa5mVgavX+vD5ccBHZ1+xybNzom9gkDM=;
        b=aiEDxUqtBd4HJKS1ONm3I/EQrLs/DTLtknx6+SqBFodDJax2Y9uzsHSpnd12HxwjvT
         QaJfCatCjdKrZqlGcx7ePPHo8e/LeAnvJOW5siplQAO1Q4RTsc25FAHANLI+vlshSWkS
         ntT1E4J3Hzvo9jJqeODLSnwmGA6tzjrV1W9d2V2jQH8CeYsb1KUR9PLDz3vGXEVWkIr9
         PIqCaQ8D6VebOj8TO9haCDWjUwOdeMr2jCIhyxb8KWRKe7sp907/ymEHKjuu/b8+76X3
         CK1H2ca0aev7Pm7yc9u84z42YZCv3HE+RUjypnhPdl51hfIFTbz/eBGFw5T+QSCJ8DyT
         u9aw==
X-Gm-Message-State: AOJu0Yx4Y2tZoFJzkD3R/GsNRvJWeyWekiakp+uoNRfxRZgS9MjEyeYY
	iJjYfASR+42cQmbH7W1Dww/JKlxpygKbQO5ZX1jje3WLQ1Dm00Ub0vzWkj5UEybsd8uxz55J68l
	/Rfu2Zjh26mQJcBUMHJ94Rd8DBbU=
X-Google-Smtp-Source: AGHT+IHPFDaL5R0u4JVoG0cJRFQ7IuSEn5SqHC7WVPA7Bzuf/ThSIeBbOqrKSRxz+u0Q4VWFrMbLHfJVpBlzcRr+qOg=
X-Received: by 2002:a4a:d018:0:b0:59a:e23:2831 with SMTP id
 h24-20020a4ad018000000b0059a0e232831mr2276572oor.2.1706725248860; Wed, 31 Jan
 2024 10:20:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QWE8P-GTNmFPbHvvDLstBZgTZA7sFg0qz4u28kUFiCAHg@mail.gmail.com>
 <mhng-125f45c7-5a14-4c91-af16-197a4ad2f517@palmer-ri-x1c9a>
In-Reply-To: <mhng-125f45c7-5a14-4c91-af16-197a4ad2f517@palmer-ri-x1c9a>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 31 Jan 2024 13:20:36 -0500
Message-ID: <CAJSP0QU8d6UdNgk25+BZoOy6OXFMAR9Ux=T445O8Ehir_UsTew@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, 
	alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, 
	marcandre.lureau@redhat.com, rjones@redhat.com, sgarzare@redhat.com, 
	imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com, 
	danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, 
	shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jan 2024 at 10:59, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Wed, 31 Jan 2024 06:39:25 PST (-0800), stefanha@gmail.com wrote:
> > On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
> >> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
> >> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
> >> might have some tricky parts.  That said it's tripping some people up
> >> and as far as I know nobody's started looking at it, so I figrued I'd
> >> write something up.
> >
> > Hi Palmer,
> > Your idea has been added:
> > https://wiki.qemu.org/Google_Summer_of_Code_2024#RISC-V_Vector_TCG_Frontend_Optimization
> >
> > I added links to the vector extension specification and the RISC-V TCG
> > frontend source code.
> >
> > Please add concrete tasks (e.g. specific optimizations the intern
> > should implement and benchmark) by Feb 21st. Thank you!
>
> OK.  We've got a few examples starting to filter in, I'll keep updating
> the bug until we get some nice concrete reproducers for slowdows of
> decent vectorized code.  Then I'll take a look and what's inside them,
> with any luck it'll be simple to figure out which vector instructions
> are commonly used and slow -- there's a bunch of stuff in the RVV
> translation that doesn't map cleanly, so I'm guessing it'll be in there.
>
> If that all goes smoothly then I think we should have a reasonably
> actionable intern project, but LMK if you were thinking of something
> else?

That's great!

Thanks,
Stefan

