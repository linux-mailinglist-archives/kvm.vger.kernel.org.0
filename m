Return-Path: <kvm+bounces-51172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9C2AEF3F6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F316A3AAB52
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1A326E6E4;
	Tue,  1 Jul 2025 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D0NzyV9r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCE325EFBD
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363759; cv=none; b=dCEe3qeHTM12XfyU+HBDBjOdPgGUleFcI/Bipb5xQY878RGfk2TswFlxehrxZdbFoL0KfdFbal2eD1r9Twsf2RsXuxUSZRl646HweXDQY5wRTAXi+2tojLwtJOIadmnB9tR8Fz9qU0l0a7qR32WonQkqEpmqIMGuSILdh8SeCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363759; c=relaxed/simple;
	bh=afv89fmUIRlZo0BHE9yAFjMvJAu0qxRKCIl7b8dX23U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZntTuQDE6HxzXJKf5g+2yZzJBGPmwNBr1YxRfdS3oHwhxUaxXl+WGU833XbuaKSQ9eDLgAOeSKGONimevd+MzpteKS78PntUxIP7hJeARHkuJT3PEdSzIoLRjDAPfFUL1hxt3OiBcdjIWYx2ddoa4tqZ4nZ3CvMSmY3CZCFC6KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D0NzyV9r; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-708d90aa8f9so55525607b3.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751363757; x=1751968557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8z0G846kkv98HmmpTnG8gyqbySyckwlmkhjrgs/A22U=;
        b=D0NzyV9rUjrFiK3Dd6yqcg2GoCv7XUDu0Ksa2Q6lHQEsYsSVK/gPyHS3+xEgXAzb02
         Z9yL12iZ44R3Y1e8Vd8A1q/tPLnz4GTYmdwOdjK2vQ/d8yA7XbPyGGOvHSfQE1jz8eV9
         mk2DGshBDAfJaRszv8HNcUakPnyM0gWxoinajlrbk/nNfPnN3eekR35db0IcVK+OZHcO
         /c4YktJi6aF9ZtIcnM3pM9FG5wSbOGf2ULCiyavzxxSrJbsyL/mTnH4JbKNE+3a0Psya
         61U+aXyqH/Tb/0iDfEQ+IMfU6ye2uSZaHn7l637vc3+mTKAWKVLgtHIenJDWL9kBxxg+
         E2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751363757; x=1751968557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8z0G846kkv98HmmpTnG8gyqbySyckwlmkhjrgs/A22U=;
        b=tLqhpqu3fx5e0qH0HDD1kFD8e9hg/UCffKVhl4q5aWKG5qT8Ty7F+xHUcMHv54o7rf
         +gQzkn7GADsT6Z/zvreqrnBj382/VzI4ObuHbWULjE+/RHhwCnqhPgVQlEb+GZmpL5vU
         7nuyA3BPWiMqWzIlTU6k+2xR1oT89s9iK1m/BnSGoTFYgjATTWaGMro1RayJWy7FUk6R
         3qOMjGhnX0FJIM95tQv+0ItJAgiDvKwmx1xtYz9IVYXwnt4APbF668mBcLejM3QKVE2J
         w3dQYdTgqH6BflBJCu9RMYBz4Pcn+D2wLColENyXQ/lyUNH6+l06MeOvWKglzr5sNLy2
         k5EA==
X-Forwarded-Encrypted: i=1; AJvYcCUtB/F65cx4DbWfocXoTxNB7jr3ozW3uuxK0kfvuYUcQeQ3BpBTOfW/izx+/X3cVvjOqXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YznMp68xmaqARpSspsBIJbNCBgCAbzhEifbNNgONDVwgC2pp4lV
	PoLaJq1Co6FuS3lOPFq6m60oyw4l+pB+3k3uQCk8WLpnfhS49A+MdkZez86uyn0SknsfSY3/QCp
	eM0Z4W/3mQ5aP2o5b1zW7ioSEQqhIUnqKxA+GureXSA==
X-Gm-Gg: ASbGncvRtKpaYnJdEwyN8/GyM8VseAbYvsEMPCeolYp7mZtm7BLugTcjCrlP+JSOjs9
	yFxXyBeBpwDDAHvAXNFQqN+yiae9p94qPEjV89YGJtXJdYpbSuaYa0b6FDkBWdM1hvZXcQzOLRP
	KDGtFfVAydIsoupcCSP/izPtzZQNrGjfAFUP5miYfeym8Y
X-Google-Smtp-Source: AGHT+IEhKDbR82dp5Cfu/vp4vMY89S4AyhtdRYjU0RTVi8X7AVMwT9nqLWzOCbUd1tBRmTqUP3fTj9xQpyq+Su3kito=
X-Received: by 2002:a05:690c:7401:b0:712:e22d:a235 with SMTP id
 00721157ae682-715171af91amr251415377b3.17.1751363757070; Tue, 01 Jul 2025
 02:55:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-13-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-13-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 10:55:44 +0100
X-Gm-Features: Ac12FXxZuvpkYlYeLubDALCRe9b49Ny7Qj6d2gQPpOSrpzaCFQmZmZpMM8bnYto
Message-ID: <CAFEAcA87+SMWdSOGBaGuNDzynaLzoFMKv3PJmbfTyd3mN_TwzQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/26] target/arm: Restrict system register properties
 to system binary
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
> Do not expose the following system-specific properties on user-mode
> binaries:
>
>  - psci-conduit
>  - cntfrq (ARM_FEATURE_GENERIC_TIMER)
>  - rvbar (ARM_FEATURE_V8)
>  - has-mpu (ARM_FEATURE_PMSA)
>  - pmsav7-dregion (ARM_FEATURE_PMSA)
>  - reset-cbar (ARM_FEATURE_CBAR)
>  - reset-hivecs (ARM_FEATURE_M)
>  - init-nsvtor (ARM_FEATURE_M)
>  - init-svtor (ARM_FEATURE_M_SECURITY)
>  - idau (ARM_FEATURE_M_SECURITY)

I guess these are user-accessible via "qemu-arm -cpu max,cntfrq=3D ..."
syntax? Makes sense to not expose them, they won't do anything
sensible.

thanks
-- PMM

