Return-Path: <kvm+bounces-51171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AD5AEF3F1
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8966D444507
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D5026E701;
	Tue,  1 Jul 2025 09:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GP2yPyka"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54357264F9B
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 09:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363610; cv=none; b=Vj+uYzmgqaVu5cjpgUHtITUo6dixKPHi+7Fv0U0XuvAuIU0ppJneeuaNqI85OrhC7li1CXuaNkExG7qscT4qKyQehHYnzHWHNdsPHFWKxLXUeDZ5prH+JTfEH5+I6RzQkFgcFpdQrdGkTxX4TY3VyWBnuj6mJaOP369n5QXz4xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363610; c=relaxed/simple;
	bh=wImLPadQucP6avEWGXXDkRvaaePghLhR5MvhokcUgVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XmXG6oL4fVAmFK5FjLddNUUiQQm2kMwbfm6Vye45ibAB+qUrg9QRL5HzrPhpb8CvHqQdibVR7kTUJYd0jxu5qzlGgy8uypcwr29+g45IiEiq2YD+ouryNRoxhQqVwyJNi7YP45EmKs64uZG+cnQUgPZPekBGOYsdMyr1BIdxiMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GP2yPyka; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70f94fe1e40so70074397b3.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 02:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751363608; x=1751968408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wImLPadQucP6avEWGXXDkRvaaePghLhR5MvhokcUgVY=;
        b=GP2yPykajCwY/S91jbwKdg3N4dPhpOGmNa8pp1tDyeGaDhVB/p0Zor7ihBMu9Yux6L
         7TM+6jy0pEQdabpF4nnZfVd2zc+RCYWSV/pE4jwFpPm3GO05U2cFqSmrDtcT01mJsCTz
         z8OZT4pLOT0iuwGvdLXl5r+Vb/WlEeB7RnPl+1s8ZOQbbTckiTCBD6TEu/owi5a6VTyR
         XdANIRSBG6Osw6o9F/nWA1TEb/8G943x7kDHRlWMnw7zxmkZcoBzoAthDIZBfZ5xL7QH
         e2c4DIn0z5YFS5aCB5yp+cTYTUJnzA1qrpkLrgJVJqnpewnurJwK9kf46LjRUxPwU880
         BAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751363608; x=1751968408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wImLPadQucP6avEWGXXDkRvaaePghLhR5MvhokcUgVY=;
        b=NmcVC5+4rXLA/jR2855SM+e0zoeV8258If91r8aiCgZLD+0IcQsEBfCfewARvygb2k
         qfOd87gc4KfuwPqG4KZgBYugaYZo6eHjsOUm0dujfHvxm5D+aSMNDlTuxc5gf72U3G1D
         iz9PNr6lzTREoArgh1EstOwaOYXbjDR4iDWNOHn5/l4h0PsPliEwv6op/7iCD8rmZiVy
         esOe8JpqWCwkGQnUuG7+I3Pd31VRIaRwpy6UYUKzmb7pyzqvm7ATAFYMsFhy9RRPM8/n
         cUvQafi5iq4UduJx8S/6dA4nrrSGNcXwZmGzOlI+y2xbmATro73GXaRElqbybe+xpGVL
         wUjw==
X-Forwarded-Encrypted: i=1; AJvYcCV3kPe/gWemY1mlzvQd09AXUKiOukjNxwQABQCRA2N4GyVClM/5sY8mEp7Fv4iVhzuV0z4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAwHBBzSDv1Ezf9mM4zHWeqYBc582akYrA5KCafG0d7rD21JL4
	2r+Okf9Jtr//4VUyqj/s5OGG+Y3CuGQZvLsJqSJk5uFMBm6Xo0aLrSIweX7iOVZcFZy+D9Ss30i
	nUwmbtlpMNSpEkApctIzaDo+n5mbq8Ga2aKSThz81+w==
X-Gm-Gg: ASbGnctxv0Hx66pPpP2LSVx3EPpeJczUeoIksoCFom2MhjPG3jyJ0hqPuHyV1OIPMo5
	7QdJSedDGV9wCe5Ws3bwbj+XBNSNDI/3oJtB32PBDdi6wurh2LrelvhY6oFj10zV+WHUdVZP9ZF
	pue1M0EExJGIaryOvsD8bK8rf2b6FpFll8rSu26eGZSTJ/
X-Google-Smtp-Source: AGHT+IFJCoy+BaAXpqIPg7zTDLzhyK8miq/1Dpx45qGcw9+XUoph9itQWahKy4dHJ12+vXIQx6+RnOzACS932yqoIig=
X-Received: by 2002:a05:690c:6602:b0:712:c295:d012 with SMTP id
 00721157ae682-7163eeb32c8mr39248687b3.13.1751363608216; Tue, 01 Jul 2025
 02:53:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-12-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-12-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 10:53:17 +0100
X-Gm-Features: Ac12FXww9a1Do6eGY4OGmuJAIl3RWIp53XrSRbJt38wyQKMH3BAQVzfhsdW1Nmw
Message-ID: <CAFEAcA95pGrwhv7DwmjayhHoPvdmYbYBHnHUmCpHSMzLz_YE_A@mail.gmail.com>
Subject: Re: [PATCH v3 11/26] target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>, 
	qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 at 13:19, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> In preparation of raising exceptions at EL2, add the 'target_el'
> argument to hvf_raise_exception().
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---

I'm taking this patch, but note that caution is required here:
part of the analysis that says we're OK to call into the
TCG GICv3 implementation includes "we will only do this
for EL0 or EL1, not EL2 or EL3".

-- PMM

