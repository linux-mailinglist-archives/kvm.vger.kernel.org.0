Return-Path: <kvm+bounces-10652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C3486E327
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 15:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B105B22D6A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378C06F069;
	Fri,  1 Mar 2024 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cRjw51WL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B46EF16
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709302650; cv=none; b=tS9D8MUokiJzLIFrzyx40HEpZOollAo1wIeIICubW2EqswDtPfZiE/DMJ4eW7O/9iRjAgKM11BITHYjYNVybnUU7kAyMD1dObgF1ER9phqOF+XNZmzNTbM7zT/lOff0zwoTpSk4TfI5bxUdQ6RM2Xm4j6wzfCJ5l2A5DNmc7BuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709302650; c=relaxed/simple;
	bh=Ztkom19pCAZHVqWszjHoKU89VmzVueUiZKhec6ViPF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CebUDIK1ytU59KP3NDqroJnN6/PkAt7eBmhOgNehbSbi8i8TFDxIfOrHl3xZXDnLTfMgI9sGMM88dsgqCiDv8VFKv1QJhCqDNqh/PrfjmntrfZNc66wHSndp0qomcF7kBXx9GPxt6+0EyMku5uAEgqRGobwuBLqzezkC/X/E/EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cRjw51WL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709302647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XdQRoYuLB946J0e/mSqK86GZ+TUT5MWy9cpEWLnkJE0=;
	b=cRjw51WLB8hFjxyYPB1RnJa+yeIACAT23CpdqDcUq05ooRB6fZoh4X6A3PWW+f/u97IWCj
	VEf38edFvFuKLZ2NEFvE8EbzcnD/3vWy2XcAyBHjUsjp1LwfEORm7NyGSD1P6onAIJJJYd
	dH3HwAaWDbtT4TX0Cqpg9W/siv5TkrY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-GoxmtpdLMk-Qa4PmONUvRQ-1; Fri, 01 Mar 2024 09:17:26 -0500
X-MC-Unique: GoxmtpdLMk-Qa4PmONUvRQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-42ed2deb055so1508601cf.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 06:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709302624; x=1709907424;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XdQRoYuLB946J0e/mSqK86GZ+TUT5MWy9cpEWLnkJE0=;
        b=Y/kQ7+55N0m3HJktMMUcPfam+9sD2EuBBXHA9pxeysDHKJnpUOZOHT8e+wCiPwgOAJ
         x+18B/5C0tSfdyy2Z8d2wJYUEAN2JlOJ3aXDy5K94jWHw9b8dm5ZGswq6e8u2nDguMrC
         WgGayOrhv7sS6G6f+hW3xSi5ViYAHkQqDV3DIak3kuXGLGyGnCcLhvPK6vnSStpJyces
         wgN7rep8zjlIHwxjoXgBunN0tBf4RSEWJUTnWQFxe4pQZMTpZeTLOEsyx+iE715a3s1E
         hQEKX/L7nmEnYa3ivBgj5QzMMV+qcPWh7wGndhxHKn8U+/FvrmvNCbvt6gHjNZtQ8H1a
         ZZIA==
X-Gm-Message-State: AOJu0YwyuAHRGM9jLcVQtcIPFrHr0+9lrWnrsx0l1lILICsOHE3qaPP9
	agLCAOCuGSi0vLRIEBVEwXGqBdPFrkuDrEKqHMCxBkhMX1JcHmU7/GW5T4enVGeiGeNh45756b7
	FzkhjP5lfdlzKHt6gMwMf92slmeY4b2EiNPSAr/bBWNUs6HvarQ==
X-Received: by 2002:ac8:58d4:0:b0:42e:5ca9:2523 with SMTP id u20-20020ac858d4000000b0042e5ca92523mr2162811qta.14.1709302624133;
        Fri, 01 Mar 2024 06:17:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHd1p4x+eIknKnCjYBxDqw76/dMFzvB9PlIFhReZzffFgOlMi9dq+iai/fH1zysfbXulhw3Zg==
X-Received: by 2002:ac8:58d4:0:b0:42e:5ca9:2523 with SMTP id u20-20020ac858d4000000b0042e5ca92523mr2162786qta.14.1709302623858;
        Fri, 01 Mar 2024 06:17:03 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05620a134c00b00787ae919d02sm1676317qkl.17.2024.03.01.06.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 06:17:03 -0800 (PST)
Message-ID: <7783977b-69ea-4831-a8f2-55de26d7bfd4@redhat.com>
Date: Fri, 1 Mar 2024 15:16:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 6/7] gitlab-ci: Run migration selftest on
 s390x and powerpc
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-7-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226093832.1468383-7-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 10.38, Nicholas Piggin wrote:
> The migration harness is complicated and easy to break so CI will
> be helpful.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   .gitlab-ci.yml | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 71d986e98..61f196d5d 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -64,26 +64,28 @@ build-arm:
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
> @@ -107,7 +109,7 @@ build-riscv64:
>   build-s390x:
>    extends: .outoftree_template
>    script:
> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>    - mkdir build
>    - cd build
>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
> @@ -133,6 +135,8 @@ build-s390x:
>         sclp-1g
>         sclp-3g
>         selftest-setup
> +      selftest-migration
> +      selftest-migration-skip
>         sieve
>         smp
>         stsi

While I can update the qemu binary for the s390x-kvm job, the build-* jobs 
run in a container with a normal QEMU from the corresponding distros, so I 
think this has to wait 'til we get distros that contain your QEMU TCG 
migration fix.

  Thomas


