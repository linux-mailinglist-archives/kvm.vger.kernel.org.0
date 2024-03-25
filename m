Return-Path: <kvm+bounces-12607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FC088AB70
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17F751F65E30
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795372F2A;
	Mon, 25 Mar 2024 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxwIjSVS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CCA56740
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711382898; cv=none; b=tfqxda4EAjbnRS7R9+wltDK5WK0wBgomSVLSpXC9wUTbUIxBfOhuvMkRH+GvJLPvV3mJA51VYvyHooepDzSD2stI1iS7bHduFcFFVyi/bwYgaaT+aBtW8Dw7qpv7ZHpAjT/MGZDwOHFGh/kldMUzu4aNcllDSJS6Qj7FbpvB9MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711382898; c=relaxed/simple;
	bh=bro9yIvN/CnmoxCWG2nJPogne44LeL1u4Zm02ATXaYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfCtW1OBiLas3e9jLIGNT+XzWNFs43h45JjqSHXGOd7zu/Ev/3RMda0V3Wsz+z/RNdJ4xfjlcJYaJjxrqklMpkvPj5bk9EEDOQNv6dHtzisdz3fZIZPj2l0qN/N4r/9iOZ0jS63+tp3yqqLJxqkpcnKKWUW/wKPjTtjsU5FirJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxwIjSVS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711382895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+3LtywVA7NTQFz0RoMpqZgRH+FCq4yAPsqKSgNMKI1A=;
	b=LxwIjSVSl3TUy5BjkQU+uZQyk+W5P8JG7HSmsRdQ7zPjgTTheZbqIwg7TN2m3PIGURHslp
	BlOSyU90UWP3UKY0ULjMSGFHuuc8412q3qGdnP6dnuoiZtRaaw527sbTIg71rLcIKLVG2/
	I/2rodsUK1i9GsRVC1AsebjzIMwqN18=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-NkaS34HwPd2_tpx24v24SA-1; Mon, 25 Mar 2024 12:08:14 -0400
X-MC-Unique: NkaS34HwPd2_tpx24v24SA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4140f58ac00so24779345e9.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 09:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711382893; x=1711987693;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3LtywVA7NTQFz0RoMpqZgRH+FCq4yAPsqKSgNMKI1A=;
        b=rh86TinHz7y4WpCpO9wkdEdXOz4ZQ1Xjck+LXt2uZCSNMel85j2tNxhrK9fAKOrFHc
         R+IZsfu/lXJIvjqj4x4WR9SILTimyBVeVJleckLmeTG1QXeus7bFYqvuHyiVOyH+y3rn
         69wrvCJnBehKFaG2oVQa1R3zYmUS0NQLWeexdMOGa4VbvKatUa20e7a6E7qQRRJPGqfU
         dCmYrKbMTqVEuuF1uB+mD68RnKw1BkkZkA79UNeQ6mXe9VLq3jiH2txsi4g2CNbmnz5k
         ry5+ck8hiPOAsi0iEQC2OZdeQpJMbAQnr5qp4YXPfPY8qnWL3grNkJ80zfWDrtBUhIWf
         GgSA==
X-Forwarded-Encrypted: i=1; AJvYcCVbrDEepo/6m0wlyrahR9bm0bjJRDr0YxJEOJxRW95FVVFaehWjhcKmECirCgTi3foJU9l0DhDGr9ziDFvdbV5/Es46
X-Gm-Message-State: AOJu0Yw7FUKE6lgZSB8q31dLRjUhpQtg2sYQUvPOVEOAjttAY9UArXi+
	djg8qOWjaw/tATyXUhHKjGJU9Z7Jmpm7joD2rI4QKOlqulzZOgGuZDbM106qt8NgBo0PlM5TIt4
	2+On8+Hy7Imgqc93PpE2+ppr89wG4JMdM3JPk5r02ZxqPGfHrsQ==
X-Received: by 2002:a05:600c:1f84:b0:414:887f:6167 with SMTP id je4-20020a05600c1f8400b00414887f6167mr3382729wmb.7.1711382893047;
        Mon, 25 Mar 2024 09:08:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRDyTWIfUX3BkdmHTwqnjITCdrXKqdGGiggbkYvcUs2c0ghfvn9MeU2N4y9nE9g5vUn9I2/w==
X-Received: by 2002:a05:600c:1f84:b0:414:887f:6167 with SMTP id je4-20020a05600c1f8400b00414887f6167mr3382716wmb.7.1711382892704;
        Mon, 25 Mar 2024 09:08:12 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-176-158.web.vodafone.de. [109.43.176.158])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b00414808dea22sm2387686wmq.0.2024.03.25.09.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:08:12 -0700 (PDT)
Message-ID: <91a6724d-5247-4f43-9400-1b8c03cb6cb3@redhat.com>
Date: Mon, 25 Mar 2024 17:08:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 06/35] gitlab-ci: Run migration selftest
 on s390x and powerpc
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240319075926.2422707-1-npiggin@gmail.com>
 <20240319075926.2422707-7-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240319075926.2422707-7-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/03/2024 08.58, Nicholas Piggin wrote:
> The migration harness is complicated and easy to break so CI will
> be helpful.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   .gitlab-ci.yml      | 18 +++++++++++-------
>   s390x/unittests.cfg |  8 ++++++++
>   2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ff34b1f50..bd34da04f 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -92,26 +92,28 @@ build-arm:
>   build-ppc64be:
>    extends: .outoftree_template
>    script:
> - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>    - mkdir build
>    - cd build
>    - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>    - make -j2
>    - ACCEL=tcg ./run_tests.sh
> -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
> -     rtas-set-time-of-day emulator
> +     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
> +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day

I used to squash as much as possible into one line in the past, but nowadays 
I rather prefer one test per line (like it is done for s390x below), so that 
it is easier to identify the changes ...
So if you like, I think you could also put each test on a separate line here 
now (since you're touching all lines with tests here anyway).

> +     emulator
>        | tee results.txt
>    - if grep -q FAIL results.txt ; then exit 1 ; fi
>   
>   build-ppc64le:
>    extends: .intree_template
>    script:
> - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>    - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
>    - make -j2
>    - ACCEL=tcg ./run_tests.sh
> -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
> -     rtas-set-time-of-day emulator
> +     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
> +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
> +     emulator
>        | tee results.txt
>    - if grep -q FAIL results.txt ; then exit 1 ; fi
>   
> @@ -135,7 +137,7 @@ build-riscv64:
>   build-s390x:
>    extends: .outoftree_template
>    script:
> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>    - mkdir build
>    - cd build
>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
> @@ -161,6 +163,8 @@ build-s390x:
>         sclp-1g
>         sclp-3g
>         selftest-setup
> +      selftest-migration-kvm
> +      selftest-migration-skip
>         sieve
>         smp
>         stsi
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 49e3e4608..b79b99416 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -31,6 +31,14 @@ groups = selftest migration
>   # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
>   accel = kvm
>   
> +[selftest-migration-kvm]
> +file = selftest-migration.elf
> +groups = nodefault
> +accel = kvm
> +# This is a special test for gitlab-ci that can must not use TCG until the

"can" or "must"?

> +# TCG migration fix has made its way into CI environment's QEMU.
> +# https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
> +
>   [selftest-migration-skip]
>   file = selftest-migration.elf
>   groups = selftest migration

  Thomas


