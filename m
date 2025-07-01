Return-Path: <kvm+bounces-51207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38779AEFF9C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 18:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BB8D4A7D1B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E7D279355;
	Tue,  1 Jul 2025 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MTRRw6Hx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF18B125B9
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386927; cv=none; b=ZapFVPbUGXqzB0QMQNXgm7d2hs/O/UFkHOKHvUrA2e60akx9IMoAQBLTX/Y7YYxJOnHy7CyMgIftvV0pY57uMCDLvMA+G7I1R53Byye9JW8A5XsIKHi0u94ItYYHSMsYiudRz8j+Tyab9eV/FSTH2CNB4GMijySjRjvNliAYmow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386927; c=relaxed/simple;
	bh=LP6UetK0n+prjhVv4ua2z7uGhDyRWlKw2zAam61FffE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LYli6JLOQW/ewASlbgSQm9wTBczKvR/Iu8sUiB7qlOJYhCGd4v4Dmxg+2I0N4w0XWcA+4uJVK9EXUL+V0fraIVD7719dt75Aw+SlEXb2Sq6c2orryO2mlf8XUG2LLSAVbcgOHqOktCR+1HBXHk+eFWh1017Gy6sLtZ8a2rrCdM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MTRRw6Hx; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-70e3e0415a7so56520827b3.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 09:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751386925; x=1751991725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ExA9I6n9mEFV/h0Xvk4Dw216G4bffe2efKYjgHrqHg=;
        b=MTRRw6HxNFEvTRRJhLXwmfR8MgAsC06AZ9q7BfS2szAltLQFJaOHe2kGh3iSCHO/Ds
         c09Hh0kS2wY35TQ/7c3y1vIBYYsOqKsLFc1bQWQBJmmkqus2d1ukrgfqVAh3Iuq/choq
         PR5A0as+BG3iWr4pWt9ZW5qBSApClfXeev7GQkBrvcVZb1vNoE3NrecDWOeYy2RDYmfZ
         h5ZlAutal3v33UxTNAdUKzNd3+hG/ODWJQWfPDY8oOA8P3vwhoYihGL+QD4DpLbzkdci
         vsRJQjdN+dcATKMmHbQ3slxMAcyv7azRuBNy9hjZANi8nWv/OwbIon6g+u3Bs5fJ8PhK
         fceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751386925; x=1751991725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ExA9I6n9mEFV/h0Xvk4Dw216G4bffe2efKYjgHrqHg=;
        b=kCasehPBesrR1iZngB048QAJ1UjsreyvBPN9ywujwMMAatAfdAwEvCT1P7ZZ3SbO82
         CqWNv3BUZhW9LmfvDZjDaiDm7J6/VhFvuWCzncnNvWWmDj55G7323E6P+e9A5rk4gVpu
         u76YG5mx+Z9rzslpSeADxCDbNmETu7yAd/kyjvz4NrdoEjjeIeSXGztcumeefwh8s4us
         FYn4g/+iku+BzJFm0J3CZXM/8oclh0MyB8C0ZAMUafAfe7N2XOylG1NqkbzykJXIaZ3A
         RfS/0n9c/9BJC7elwT26wcJ8SWynd80flLW3DzBEb+DnPPTnGMZFJi5AkcGjopqF1R1A
         yK1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD1gWgdIm1doUpxv8SrJl5KiJ2RpuQvDbHCyCSgmg4NBlviuoGsRJ8LSoW5DvnER1BIrM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywas8xwRen+JkBIV1DOYsMJll2XpIXePj1kNtA21U9J4siH39C7
	IpXks09WjbHKQxlsJ/kIdjPNw6LVdQWt/gamHYtVW8FqxL+xhq3limkPoxpfyaO6VasZNXe1g75
	3pyiPvXHBv3PRRlE+xN8EjxmOGQaS3P6UsGea1wv/mg==
X-Gm-Gg: ASbGncu0ZyF7gXLfhPkEEUPJEqey4fqgK9l42sH/eBTBJfOWR7zCuIch43CiZu2D/3e
	BJrkzwKbjUPBo7pxmhJb3osDTIcbj+Si02Ibjy/C3/F+B4a6RPXzrBlmdCJNqxb/5qDxK/QvkYn
	J4unbP2t6aov/l+PLDHkPg5qoBQN7f6XGKwJUWrENlawFd
X-Google-Smtp-Source: AGHT+IGIclKVjViD0WW3iV4YwGI3dhj48xyfWmiyY3aBzOAs9kfGDc0yU1Ej0pH1/RrI6013XX48ffAzkmY9zk2fHf0=
X-Received: by 2002:a05:690c:700e:b0:70f:8830:809c with SMTP id
 00721157ae682-7163ee96597mr60163237b3.12.1751386924710; Tue, 01 Jul 2025
 09:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-26-philmd@linaro.org>
 <CAFEAcA9MLMJBFk+PQCJT8Bd+6R+vaho9_vXmDCjPU5cp6B7LfQ@mail.gmail.com>
In-Reply-To: <CAFEAcA9MLMJBFk+PQCJT8Bd+6R+vaho9_vXmDCjPU5cp6B7LfQ@mail.gmail.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 17:21:53 +0100
X-Gm-Features: Ac12FXzEimJKLq31uljceBjRMKAA4MUmsh56mOzsO1SwCyld8EJ-MmtJd7PAg0s
Message-ID: <CAFEAcA_=Jo5aDsKHjNwz7DNAqoS7iGDudSEvbjYVhcEZ9P+keQ@mail.gmail.com>
Subject: Re: [PATCH v3 25/26] tests/functional: Add hvf_available() helper
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

On Tue, 1 Jul 2025 at 16:50, Peter Maydell <peter.maydell@linaro.org> wrote=
:
>
> On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.=
org> wrote:
> >
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > ---
> >  python/qemu/utils/__init__.py          | 2 +-
> >  python/qemu/utils/accel.py             | 8 ++++++++
> >  tests/functional/qemu_test/testcase.py | 6 ++++--
> >  3 files changed, 13 insertions(+), 3 deletions(-)
>
> This seems to trigger errors in the check-python-minreqs job:
> https://gitlab.com/pm215/qemu/-/jobs/10529051338
>
> Log file "stdout" content for test "01-tests/flake8.sh" (FAIL):
> qemu/utils/__init__.py:26:1: F401 '.accel.hvf_available' imported but unu=
sed
> qemu/utils/accel.py:86:1: E302 expected 2 blank lines, found 1
> Log file "stderr" content for test "01-tests/flake8.sh" (FAIL):
> Log file "stdout" content for test "04-tests/isort.sh" (FAIL):
> ERROR: /builds/pm215/qemu/python/qemu/utils/__init__.py Imports are
> incorrectly sorted and/or formatted.
>
> I'll see if I can fix this up locally. (The missing blank line
> is easy; I think probably hvf_available needs to be in the
> __all__ =3D () list in __init__.py like kvm_available and
> tcg_available. Not sure about the incorrectly-sorted warning.)

Squashing this in fixed things. I guess that going from three
imports to four makes the linter want you to list them one
per line...

diff --git a/python/qemu/utils/__init__.py b/python/qemu/utils/__init__.py
index d2fe5db223c..be5daa83634 100644
--- a/python/qemu/utils/__init__.py
+++ b/python/qemu/utils/__init__.py
@@ -23,13 +23,19 @@
 from typing import Optional

 # pylint: disable=3Dimport-error
-from .accel import hvf_available, kvm_available, list_accel, tcg_available
+from .accel import (
+    hvf_available,
+    kvm_available,
+    list_accel,
+    tcg_available,
+)


 __all__ =3D (
     'VerboseProcessError',
     'add_visual_margin',
     'get_info_usernet_hostfwd_port',
+    'hvf_available',
     'kvm_available',
     'list_accel',
     'tcg_available',
diff --git a/python/qemu/utils/accel.py b/python/qemu/utils/accel.py
index 376d1e30005..f915b646692 100644
--- a/python/qemu/utils/accel.py
+++ b/python/qemu/utils/accel.py
@@ -83,6 +83,7 @@ def tcg_available(qemu_bin: str) -> bool:
     """
     return 'tcg' in list_accel(qemu_bin)

+
 def hvf_available(qemu_bin: str) -> bool:
     """
     Check if HVF is available.


-- PMM

