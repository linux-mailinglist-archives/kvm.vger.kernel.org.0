Return-Path: <kvm+bounces-26441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E49BE974759
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66CF61F21AA1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE9AB665;
	Wed, 11 Sep 2024 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S4IEmZM4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727AE5680;
	Wed, 11 Sep 2024 00:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014374; cv=none; b=OlyHoWqKsGWdEYZ2M2mmstacTrHBDH+rQd9NCKthd+9g3rdMFbmusA7eXf5MAbhArTh9Pu9Sq+ovDT+ZV5hNuoRfViFxNhIpNrvzULKfjvds0dY8UKAXvyUxxqYqFAJEKBZ9vE1g/6he1mFi2tj9nVyM66Lfpl/rQ12Dnpx4F/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014374; c=relaxed/simple;
	bh=itxfKfmbD/zsCr0etIDjn7Mvr1MVTsWI0y9iTbmeGSc=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=DiWrQmZSq6IvVTB9OVH6suG9yjOxaMb6o+G7Z5WVPhiaLDrTqJYg5KAsSvIQm/RRi95Fg8cMvIIxJ55m3xPAhMxnbahWoIBVlWckicr3dloi4vf5hNIwV7XXyj4MfTIYyUF+/ED7FGRJ+I/xfnYRK7ji26dzsot+5Sc36qJEFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S4IEmZM4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-205909af9b5so48910815ad.3;
        Tue, 10 Sep 2024 17:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726014373; x=1726619173; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEyXAdKeEJQoAHfFQf1BZ5A9dLRXujoz25bWx+9TXyc=;
        b=S4IEmZM45+9j4pErZTCfIB1GGrkCOUEuYMobEB9Eu+AljwyaaDm7MAp4R7hd4IPaP2
         XVbG1kUHcxJKGIuhwrGtnJ/kUf+R1M6DXD0OgJQ4YeCsn8OeumDtMF0QGTs6bbSZTW/l
         e0lImpbWZdm64yLqHChC3ozwBlsRFxAAM0TCt1R2gux+w+m6iBATMg7kWmA1Bw9HzFrE
         PVEUoWvXb3cJNQHxEVHuGMg9d3azMtWu0dVKv0P0eVjHeK5bsOegCDFpqHNtwn2LOtD2
         quyzyV9NoJJK5N3/2+Y4ZLooih2W0QQ+DpPcu4mzoOYWX9zI/KKZxFdIriGPy8rj/KaX
         dnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726014373; x=1726619173;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cEyXAdKeEJQoAHfFQf1BZ5A9dLRXujoz25bWx+9TXyc=;
        b=GLK1PcFdK2yb2Enigjnn3nfxzDs3XHmrxuS77wbGM2QffCT/4Lb0s12JtkCWiY21qF
         Jt4iGK9yYCDerUWSkzlSQ3VSFUcZhVvlk6NbHDeHECtwrXTZmytsLEyHENHJu243bwdI
         yBNA/Zs6iUJ/sz5nML/uDOFWn5gPUVRoa/e6201yGQ/aYeVkJtApEbZFyka2sqyyxSyW
         KWYLNgn1BKyHSocdZJi4jIqYHCLDYxt0n9Mb8wF92h48q/DL2HWsnTFcAq5uBsUcIVnW
         Vo6WLmmOIcyCHko5kEvijr2ffufG+dKVwHf5T+9WE1XOxn2/ZApS0CR1Vpr7t8h1babg
         ZoOg==
X-Forwarded-Encrypted: i=1; AJvYcCV2qM+tM1D9PsYCykkD4EA01QAvjN9zl+qKk7ffxsKETHdKAoCqx/btMtWsDBC5Poh2Ry8KC8JIWi7Y0A==@vger.kernel.org, AJvYcCVoE1pIZNhoRMw9bgAsa6fIHjYawDZdqtez0jmc+4VTncwYJNFoMmcaoB04iAyPh31Me1I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6SWeLW9Vx1PECy6c3aeluc7ND/cGIOYemgJ9nigbItjj0WRdY
	9oRw6bRuAKdaL20ci9XEs2O81bNkOIoWNYzQiD6UdTvX2wPP6WIS
X-Google-Smtp-Source: AGHT+IHdupOZtZNvqV8Jq+ivzEDY7SaRBw9l5Q5S/ff1gCan8RdbB7OhqPF/t1bFYOvCzz+LolCTIQ==
X-Received: by 2002:a17:902:ce11:b0:206:c486:4c33 with SMTP id d9443c01a7336-2074c631b1amr37647145ad.30.1726014372538;
        Tue, 10 Sep 2024 17:26:12 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710eea95esm53895415ad.161.2024.09.10.17.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:26:03 +1000
Message-Id: <D431108K19Z2.3EDZQCSG5RC4X@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] riscv: gitlab-ci: Add clang build
 tests
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-10-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-10-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> Test building 32 and 64-bit with clang. Throw a test of in- and out-
> of-tree building in too by swapping which is done to which (32-bit
> vs. 64-bit) with respect to the gcc build tests.
>
Acked-by: Nicholas Piggin <npiggin@gmail.com>

> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  .gitlab-ci.yml | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 67a9a15733f1..b7ad99870e5a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -176,6 +176,49 @@ build-riscv64-efi:
>        | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> =20
> +build-riscv32-clang:
> + extends: .intree_template
> + script:
> + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
> + - ./configure --arch=3Driscv32 --cc=3Dclang --cflags=3D'--target=3Drisc=
v32' --cross-prefix=3Driscv64-linux-gnu-
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-riscv64-clang:
> + extends: .outoftree_template
> + script:
> + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
> + - mkdir build
> + - cd build
> + - ../configure --arch=3Driscv64 --cc=3Dclang --cflags=3D'--target=3Dris=
cv64' --cross-prefix=3Driscv64-linux-gnu-
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-riscv64-clang-efi:
> + extends: .intree_template
> + script:
> + - dnf install -y edk2-riscv64 qemu-system-riscv gcc-riscv64-linux-gnu c=
lang
> + - cp /usr/share/edk2/riscv/RISCV_VIRT_CODE.fd .
> + - truncate -s 32M RISCV_VIRT_CODE.fd
> + - ./configure --arch=3Driscv64 --cc=3Dclang --cflags=3D'--target=3Drisc=
v64' --cross-prefix=3Driscv64-linux-gnu- --enable-efi
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
>  build-s390x:
>   extends: .outoftree_template
>   script:


