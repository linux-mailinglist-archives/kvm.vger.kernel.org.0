Return-Path: <kvm+bounces-4088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E61980D463
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01BE51F21A09
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041514EB31;
	Mon, 11 Dec 2023 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Len579ea"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2E59B
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:48:01 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40c32df9174so39386625e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702316880; x=1702921680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GyIfzmIozQp2p6r6Dz0e+oD9SE+AcfjjewTE6Log7o=;
        b=Len579eajhL1VI41CDxeZsrbeIwUFgEVjTrdhpyoPMWVtCN+X1oDgUYwmFrLlgKECM
         EEbK1q+yLwHEYJHkq1HhBHjfWHdQUJ2B4eHLOWEifPh6wuEwe4/7llACkEKbMEQoRxgF
         v07xj156C/rdSK/58RnNTdBfzTHTTvqsTTMe++Psgsi7QT99FDfVYk+tTNm5SnsC1zx4
         XCnVBOnjT7wuBP10SH9km4CMTwgw49urvHYoQWyXjRmKCjjn/D+dCnxKrvV8ruIpa7Px
         Q4T+rQIaq/hmaDR2uvRQvNYX+AL0vlzXabhw+zjcE6aEAgEK5JDw2B5zMAzwjnsFZkFE
         AKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702316880; x=1702921680;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6GyIfzmIozQp2p6r6Dz0e+oD9SE+AcfjjewTE6Log7o=;
        b=LdzmQ3Eopg67wlMGqXW8KyNfCN3A1dqxV6UpaCGpOGbVueINHg39amI/if6AwRxT+U
         GxE8fMj1dBAh/XDayeM+5JdixNOZmY4gORttB6LOb7HUuvNsr0dom48y+LHrE+C/eCYK
         feurdLskkBelx5/Y+4RuHS+Uuw3d2U0NYyOyaAGF9dBjXWHPRzhK6gfhXAmS6fYkvX5/
         JuSt4QDOZRavJ7jEtOT3PQUb5CPuZsGlphahHvDwK+J1sjjAuXEk52wR75hADMEcpWBo
         hHtWKY/GclkXfcw1PlutTpBDrYi0FvLLTyxrwyaGwiQVtFkdL7B8aSh3o3uvUI/Ml0YY
         XxrQ==
X-Gm-Message-State: AOJu0YzY7G9DzmFuSM1e/Uds7pYlLTeopuIjuNuhvt4IJTf2R3LSWIbg
	rcolzODsJ3pFYZCeFGYoAsrX5Q==
X-Google-Smtp-Source: AGHT+IG+1JJM7gVsvYVGmWwS9/xIxKeFKXGWkKen1e5v6kRMvEYri/9mxircEIok9/mWKo+AklmsMw==
X-Received: by 2002:a05:600c:3794:b0:40c:32b3:f297 with SMTP id o20-20020a05600c379400b0040c32b3f297mr1722285wmr.55.1702316879810;
        Mon, 11 Dec 2023 09:47:59 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h2-20020a05600c350200b0040c44b4a282sm5859487wmq.43.2023.12.11.09.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 09:47:59 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 17ED45FBC6;
	Mon, 11 Dec 2023 17:47:59 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Radoslaw
 Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>,  Leif Lindholm <quic_llindhol@quicinc.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Beraldo Leal
 <bleal@redhat.com>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Sriram Yagnaraman <sriram.yagnaraman@est.tech>,  Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>,  David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 04/10] tests/avocado: machine aarch64: standardize
 location and RO/RW access
In-Reply-To: <20231208190911.102879-5-crosa@redhat.com> (Cleber Rosa's message
	of "Fri, 8 Dec 2023 14:09:05 -0500")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-5-crosa@redhat.com>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Mon, 11 Dec 2023 17:47:59 +0000
Message-ID: <87wmtkeils.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> The tests under machine_aarch64_virt.py do not need read-write access
> to the ISOs.  The ones under machine_aarch64_sbsaref.py, on the other
> hand, will need read-write access, so let's give each test an unique
> file.

I think we are making two separate changes here so probably best split
the patch.

> And while at it, let's use a single code style and hash for the ISO
> url.
>
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/machine_aarch64_sbsaref.py |  9 +++++++--
>  tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
>  2 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/mac=
hine_aarch64_sbsaref.py
> index 528c7d2934..6ae84d77ac 100644
> --- a/tests/avocado/machine_aarch64_sbsaref.py
> +++ b/tests/avocado/machine_aarch64_sbsaref.py
> @@ -7,6 +7,7 @@
>  # SPDX-License-Identifier: GPL-2.0-or-later
>=20=20
>  import os
> +import shutil
>=20=20
>  from avocado import skipUnless
>  from avocado.utils import archive
> @@ -123,13 +124,15 @@ def boot_alpine_linux(self, cpu):
>=20=20
>          iso_hash =3D "5a36304ecf039292082d92b48152a9ec21009d3a62f459de62=
3e19c4bd9dc027"
>          iso_path =3D self.fetch_asset(iso_url, algorithm=3D"sha256", ass=
et_hash=3Diso_hash)
> +        iso_path_rw =3D os.path.join(self.workdir, os.path.basename(iso_=
path))
> +        shutil.copy(iso_path, iso_path_rw)
>=20=20
>          self.vm.set_console()
>          self.vm.add_args(
>              "-cpu",
>              cpu,
>              "-drive",
> -            f"file=3D{iso_path},format=3Draw",
> +            f"file=3D{iso_path_rw},format=3Draw",

Instead of copying why not add ",snapshot=3Don" to preserve the original
image. We don't want to persist data between tests.

>              "-device",
>              "virtio-rng-pci,rng=3Drng0",
>              "-object",
> @@ -170,13 +173,15 @@ def boot_openbsd73(self, cpu):
>=20=20
>          img_hash =3D "7fc2c75401d6f01fbfa25f4953f72ad7d7c18650056d30755c=
44b9c129b707e5"
>          img_path =3D self.fetch_asset(img_url, algorithm=3D"sha256", ass=
et_hash=3Dimg_hash)
> +        img_path_rw =3D os.path.join(self.workdir, os.path.basename(img_=
path))
> +        shutil.copy(img_path, img_path_rw)
>=20=20
>          self.vm.set_console()
>          self.vm.add_args(
>              "-cpu",
>              cpu,
>              "-drive",
> -            f"file=3D{img_path},format=3Draw",
> +            f"file=3D{img_path_rw},format=3Draw",

ditto.


>              "-device",
>              "virtio-rng-pci,rng=3Drng0",
>              "-object",
> diff --git a/tests/avocado/machine_aarch64_virt.py b/tests/avocado/machin=
e_aarch64_virt.py
> index a90dc6ff4b..093d68f837 100644
> --- a/tests/avocado/machine_aarch64_virt.py
> +++ b/tests/avocado/machine_aarch64_virt.py
> @@ -37,13 +37,13 @@ def test_alpine_virt_tcg_gic_max(self):
>          :avocado: tags=3Dmachine:virt
>          :avocado: tags=3Daccel:tcg
>          """
> -        iso_url =3D ('https://dl-cdn.alpinelinux.org/'
> -                   'alpine/v3.17/releases/aarch64/'
> -                   'alpine-standard-3.17.2-aarch64.iso')
> +        iso_url =3D (
> +            "https://dl-cdn.alpinelinux.org/"
> +            "alpine/v3.17/releases/aarch64/alpine-standard-3.17.2-aarch6=
4.iso"
> +        )
>=20=20
> -        # Alpine use sha256 so I recalculated this myself
> -        iso_sha1 =3D '76284fcd7b41fe899b0c2375ceb8470803eea839'
> -        iso_path =3D self.fetch_asset(iso_url, asset_hash=3Diso_sha1)
> +        iso_hash =3D "5a36304ecf039292082d92b48152a9ec21009d3a62f459de62=
3e19c4bd9dc027"
> +        iso_path =3D self.fetch_asset(iso_url, algorithm=3D"sha256", ass=
et_hash=3Diso_hash)
>=20=20
>          self.vm.set_console()
>          kernel_command_line =3D (self.KERNEL_COMMON_COMMAND_LINE +
> @@ -60,7 +60,7 @@ def test_alpine_virt_tcg_gic_max(self):
>          self.vm.add_args("-smp", "2", "-m", "1024")
>          self.vm.add_args('-bios', os.path.join(BUILD_DIR, 'pc-bios',
>                                                 'edk2-aarch64-code.fd'))
> -        self.vm.add_args("-drive", f"file=3D{iso_path},format=3Draw")
> +        self.vm.add_args("-drive",
>          f"file=3D{iso_path},readonly=3Don,format=3Draw")

Perhaps we can set ",media=3Dcdrom" here.

>          self.vm.add_args('-device', 'virtio-rng-pci,rng=3Drng0')
>          self.vm.add_args('-object', 'rng-random,id=3Drng0,filename=3D/de=
v/urandom')

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

