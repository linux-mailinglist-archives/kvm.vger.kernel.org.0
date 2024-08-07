Return-Path: <kvm+bounces-23571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0912F94AEDC
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5E911F21617
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0590813CFA3;
	Wed,  7 Aug 2024 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XtArFQE2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9813C9A7
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723051620; cv=none; b=eZqrJBANwit75rv71QCXiRGwJSTz4yLSsIFenHiwogJ5yK7WGH38qBbiCTbNmkpBAzvyhToEAQ7vUibsTiOuG1VCFSQdXIVlu0L5ArjwRsJv/FPkatNrDZWn++e+jAozwcbPf9QeHgLVv1VGR0Fths06y6updQG+DydzeSkiE1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723051620; c=relaxed/simple;
	bh=8OH3fz/BQGuREwQEmX+9DIEL05cmvOBEUjxbayWAbGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bPNJK2A+bUyFcHN6e48xfenh7XQ7zIicqbFpKwDMQcPnwBDHqITJGlUWnB/6GXH1/0f00GRvsre9+nppyEMefhP6AFdQNG8pMBb21+qVhfLxHK1GnMe7w6+zbi7b9H5d4y1JkJBZNNEtO1ayibWa78XeGuWeErbSbzQoYLDeUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XtArFQE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723051617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHdSG8iEg4uS+0Sz/s3n8vWpM9yi4XCN7sVewjdqnp8=;
	b=XtArFQE2xh3G6CxexC0I/CMKtmow4wQ/pafsYs0iCx+1gmiIV0UK/OQsAUy1VS9+y3O8fQ
	u6etZ4g1hFIJY0PhhlYvzGaFZegPlXX58Y2jcYxCx2tSaDrTEUWTXrBivT9cpL64mL8x0r
	dT+2e4W8Jq8dIVe9BHknUuSU/S4HAtE=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-QKIA6bWJPFupQ5Q2SGmVJQ-1; Wed, 07 Aug 2024 13:26:55 -0400
X-MC-Unique: QKIA6bWJPFupQ5Q2SGmVJQ-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e0be2fa8f68so69846276.3
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 10:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723051614; x=1723656414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHdSG8iEg4uS+0Sz/s3n8vWpM9yi4XCN7sVewjdqnp8=;
        b=PFpLbFhCfnuSIDxLEOZgnTvZHwPGI3WcuKhwHsKLnM8c1w9ecaDZcpibR439zXaWkP
         BB/jEkukSm7FzSGFyjn0A9OiVXuSZ2trDYbVcvLf35UUaVYxstHBvNLHhCGnyLpYpch9
         05cSkD1IIxYgBRikdnkuj8v3BH93wZntO5GjUI2stHxDD6++cSPKIkl+iDMxOSCeOBpU
         BahCzHFX6aQZ7ElNghIbrS/HJGLPAbz+mCxLczsZFJ6XNp3FPiO2uiYVcE7PXhw8JOtA
         OUSMHuMhwBvjDUvBs6yvq+OIy+JVCqqEwqmfCdHdXEzMn6gHftt0xUhhyjFY1HuegNXi
         2l8w==
X-Forwarded-Encrypted: i=1; AJvYcCX+ieTOt3ZPgJxFYLLk9iH35rm03/2SYoMV/4CRow3yWTlP6aw8RPwZKRnlMS6YIUJ+0sGBDEXJ7ViTAhiaLwQROYW9
X-Gm-Message-State: AOJu0YxfZXVfpZDV+SWyATB1dNICVR/F3SAev85oMoW+as3hkrX+pYns
	O7wi7PlMBslNSojfYW/4SZWTuSoa9WE3zwn+Q7YdE/gG4M4jPSDaz+XyQsZ4rdtzd2TmNY86NYT
	O5DJEUAMxJskBrfn7FXvMHw99eZi+jdPzeNYcMgzOpr94KUUjO8zu61wYP8WggoUNin9GE/KM6G
	y2rJAeDB3kO/Kh6mZDsiXbqie6
X-Received: by 2002:a05:6902:1404:b0:e0b:6583:7900 with SMTP id 3f1490d57ef6-e0bde4caae9mr21061829276.44.1723051614776;
        Wed, 07 Aug 2024 10:26:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgVrS/gCmLskzoiySIAmIZmLty/hsAj4tce1KtsahwCZ1aWkzssq3u3XvD457tbYYRwRRDNR0kf8SbckRKCwE=
X-Received: by 2002:a05:6902:1404:b0:e0b:6583:7900 with SMTP id
 3f1490d57ef6-e0bde4caae9mr21061793276.44.1723051614380; Wed, 07 Aug 2024
 10:26:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806173119.582857-1-crosa@redhat.com> <20240806173119.582857-8-crosa@redhat.com>
 <540fafc7-9044-4e9a-b2c8-2f2f04412b88@linaro.org>
In-Reply-To: <540fafc7-9044-4e9a-b2c8-2f2f04412b88@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 7 Aug 2024 13:26:41 -0400
Message-ID: <CA+bd_6Ls00k4Wb9cfHZ87oNxb=y2AaRv+ibpR-bY9XPVg3SBiw@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Cc: qemu-devel@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, 
	Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>, kvm@vger.kernel.org, 
	Joel Stanley <joel@jms.id.au>, Paolo Bonzini <pbonzini@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant <paul@xen.org>, 
	Eric Auger <eric.auger@redhat.com>, David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	Steven Lee <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 2:20=E2=80=AFPM Marcin Juszkiewicz
<marcin.juszkiewicz@linaro.org> wrote:
>
> On 6.08.2024 19:31, Cleber Rosa wrote:
> > +    @skipUnless(archive._probe_zstd_cmd(),
> > +                'Could not find "zstd", or it is not able to properly =
'
> > +                'decompress decompress the rootfs')
>
> One "decompress" would be enough.
>

True! Thanks for spotting that.

Regards,
- Cleber.


