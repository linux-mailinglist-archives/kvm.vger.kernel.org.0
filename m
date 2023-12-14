Return-Path: <kvm+bounces-4467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C7F4812D0A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6FADB2118E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FE03BB2A;
	Thu, 14 Dec 2023 10:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BMd62n8G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9EE10E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:34:43 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3333074512bso236850f8f.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702550082; x=1703154882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTIMG9FJoGMyoT9rRoj2x7tqQ0Gr6d1LxVablCR6iy8=;
        b=BMd62n8Gm/Z9NL+2zqIdSEPhX9+DBCHsD6GAfNYwKnsWhBHUF6p86UgkMhJlqsHA9+
         sWC4hpBNQLaChhDfX9+fZIJHnDvX1PNRhDav47FgVkFYsqu8ViTPVOWHV1lp/vkqQmu1
         Q10rf0dqSRDC5gKEOd3N0uz8fIp7vrDkUkXVC/kHdeavGXzGt+JsovnFssRVjhmt820x
         yjtf3GW6+8OyImoOefDdZEfqvdzGer3uTbOAmYMso4Bnqd1C/o+UzDOtWeKPDMKy5bMb
         iXa1bx1uW1yXLIaG9Cpp+GKBiXrqtGUfC8g3lXv1VVCJv8i6WSnHK8iJ4KhfxbckS/y/
         sN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702550082; x=1703154882;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VTIMG9FJoGMyoT9rRoj2x7tqQ0Gr6d1LxVablCR6iy8=;
        b=Ur62KrtORngLPdGjjXIqTsNzl/1TlPoFryo8Zw2YoS9s/xGI766xdj4N7ZjZM1Yyhn
         c7pjvlDM1Z3Kj0ceVeARoIkbYk/QQPYBopUaOcMTGRfnVfeptpDzmCTNPxDDSecZtODi
         IVdsC5NEkKgc/VktK4EKmSIhTELWp0u7myjnt3TCNxy6KOaFDLDFW5ENFtpyvhEC+29N
         gw9TvX1A6VK2l4Y7qqkrGAwUaeiZUTHHCzklPNn7IjHVWsXypps37PwYZzlLA0LvXBig
         ZzKUx4gr6XW+piRKD81zWc0nKT4FBSuSCSLhfq8RQ46MHZJIPrsImC4DU+0GycFN+ViN
         0I+w==
X-Gm-Message-State: AOJu0YyxV9skvP/Es19KygeaERSZL7juOUKzYKYtwirEHxOX+EgeVPfF
	zuwyV0XMQNJTYroHG0qWspC1qQ==
X-Google-Smtp-Source: AGHT+IEnzdfsAufZfsYDDmCA8IJHdokLbFAltymI6snKzyOYYZjuz900q/taMvC1Zuz+SQEW3V/P3g==
X-Received: by 2002:a1c:7906:0:b0:40b:5e4a:235b with SMTP id l6-20020a1c7906000000b0040b5e4a235bmr4708868wme.93.1702550082208;
        Thu, 14 Dec 2023 02:34:42 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b0040c2963e5f3sm23970057wmb.38.2023.12.14.02.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:34:41 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 758725F7D3;
	Thu, 14 Dec 2023 10:34:41 +0000 (GMT)
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
In-Reply-To: <87h6klvm90.fsf@p1.localdomain> (Cleber Rosa's message of "Wed,
	13 Dec 2023 16:14:03 -0500")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-5-crosa@redhat.com>
	<87wmtkeils.fsf@draig.linaro.org> <87h6klvm90.fsf@p1.localdomain>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Thu, 14 Dec 2023 10:34:41 +0000
Message-ID: <87le9x843i.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:
>
>> Cleber Rosa <crosa@redhat.com> writes:
>>
>>> The tests under machine_aarch64_virt.py do not need read-write access
>>> to the ISOs.  The ones under machine_aarch64_sbsaref.py, on the other
>>> hand, will need read-write access, so let's give each test an unique
>>> file.
>>
>> I think we are making two separate changes here so probably best split
>> the patch.
>>
>
> Sure, but, do you mean separating the "readonly=3Don" and the "writable
> file" changes?  Or separating those two from the ISO url code style
> change?

I was thinking about splitting the sbsaref and virt patches, but
actually they are fairly related as they all use the alpine image so
maybe no need.

>
>>> And while at it, let's use a single code style and hash for the ISO
>>> url.
>>>
>>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>>> ---
>>>  tests/avocado/machine_aarch64_sbsaref.py |  9 +++++++--
>>>  tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
>>>  2 files changed, 14 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/m=
achine_aarch64_sbsaref.py
>>> index 528c7d2934..6ae84d77ac 100644
>>> --- a/tests/avocado/machine_aarch64_sbsaref.py
>>> +++ b/tests/avocado/machine_aarch64_sbsaref.py
>>> @@ -7,6 +7,7 @@
>>>  # SPDX-License-Identifier: GPL-2.0-or-later
>>>=20=20
>>>  import os
>>> +import shutil
>>>=20=20
>>>  from avocado import skipUnless
>>>  from avocado.utils import archive
>>> @@ -123,13 +124,15 @@ def boot_alpine_linux(self, cpu):
>>>=20=20
>>>          iso_hash =3D "5a36304ecf039292082d92b48152a9ec21009d3a62f459de=
623e19c4bd9dc027"
>>>          iso_path =3D self.fetch_asset(iso_url, algorithm=3D"sha256", a=
sset_hash=3Diso_hash)
>>> +        iso_path_rw =3D os.path.join(self.workdir, os.path.basename(is=
o_path))
>>> +        shutil.copy(iso_path, iso_path_rw)
>>>=20=20
>>>          self.vm.set_console()
>>>          self.vm.add_args(
>>>              "-cpu",
>>>              cpu,
>>>              "-drive",
>>> -            f"file=3D{iso_path},format=3Draw",
>>> +            f"file=3D{iso_path_rw},format=3Draw",
>>
>> Instead of copying why not add ",snapshot=3Don" to preserve the original
>> image. We don't want to persist data between tests.

Ahh yes these are isos so snapshot isn't needed.

>>
>>>              "-device",
>>>              "virtio-rng-pci,rng=3Drng0",
>>>              "-object",
>>> @@ -170,13 +173,15 @@ def boot_openbsd73(self, cpu):
>>>=20=20
>>>          img_hash =3D "7fc2c75401d6f01fbfa25f4953f72ad7d7c18650056d3075=
5c44b9c129b707e5"
>>>          img_path =3D self.fetch_asset(img_url, algorithm=3D"sha256", a=
sset_hash=3Dimg_hash)
>>> +        img_path_rw =3D os.path.join(self.workdir, os.path.basename(im=
g_path))
>>> +        shutil.copy(img_path, img_path_rw)
>>>=20=20
>>>          self.vm.set_console()
>>>          self.vm.add_args(
>>>              "-cpu",
>>>              cpu,
>>>              "-drive",
>>> -            f"file=3D{img_path},format=3Draw",
>>> +            f"file=3D{img_path_rw},format=3Draw",
>>
>> ditto.
>>
>>
>>>              "-device",
>>>              "virtio-rng-pci,rng=3Drng0",
>>>              "-object",
>>> diff --git a/tests/avocado/machine_aarch64_virt.py b/tests/avocado/mach=
ine_aarch64_virt.py
>>> index a90dc6ff4b..093d68f837 100644
>>> --- a/tests/avocado/machine_aarch64_virt.py
>>> +++ b/tests/avocado/machine_aarch64_virt.py
>>> @@ -37,13 +37,13 @@ def test_alpine_virt_tcg_gic_max(self):
>>>          :avocado: tags=3Dmachine:virt
>>>          :avocado: tags=3Daccel:tcg
>>>          """
>>> -        iso_url =3D ('https://dl-cdn.alpinelinux.org/'
>>> -                   'alpine/v3.17/releases/aarch64/'
>>> -                   'alpine-standard-3.17.2-aarch64.iso')
>>> +        iso_url =3D (
>>> +            "https://dl-cdn.alpinelinux.org/"
>>> +            "alpine/v3.17/releases/aarch64/alpine-standard-3.17.2-aarc=
h64.iso"
>>> +        )
>>>=20=20
>>> -        # Alpine use sha256 so I recalculated this myself
>>> -        iso_sha1 =3D '76284fcd7b41fe899b0c2375ceb8470803eea839'
>>> -        iso_path =3D self.fetch_asset(iso_url, asset_hash=3Diso_sha1)
>>> +        iso_hash =3D "5a36304ecf039292082d92b48152a9ec21009d3a62f459de=
623e19c4bd9dc027"
>>> +        iso_path =3D self.fetch_asset(iso_url, algorithm=3D"sha256", a=
sset_hash=3Diso_hash)
>>>=20=20
>>>          self.vm.set_console()
>>>          kernel_command_line =3D (self.KERNEL_COMMON_COMMAND_LINE +
>>> @@ -60,7 +60,7 @@ def test_alpine_virt_tcg_gic_max(self):
>>>          self.vm.add_args("-smp", "2", "-m", "1024")
>>>          self.vm.add_args('-bios', os.path.join(BUILD_DIR, 'pc-bios',
>>>                                                 'edk2-aarch64-code.fd'))
>>> -        self.vm.add_args("-drive", f"file=3D{iso_path},format=3Draw")
>>> +        self.vm.add_args("-drive",
>>>          f"file=3D{iso_path},readonly=3Don,format=3Draw")
>>
>> Perhaps we can set ",media=3Dcdrom" here.
>>
>
> Yes, but more importantly, adding both "readonly=3Don" and "media=3Dcdrom"
> to the tests under machine_aarch64_sbsaref.py do the trick.  Now, the
> behavior explained in my previous response still warrants investigation
> IMO.
>
> Thanks
> - Cleber.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

