Return-Path: <kvm+bounces-32769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA4D9DC273
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 12:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AC7C164B68
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 11:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEF11990C5;
	Fri, 29 Nov 2024 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AnDLIa5F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170BF1990AE
	for <kvm@vger.kernel.org>; Fri, 29 Nov 2024 10:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732877995; cv=none; b=mY0WZNhTFO3a949uqHlteaHabAGdYE8QBYB1gRIeu/CVcDAgan2qUE88yxTkZUL8F7OSsQh+7oHLWOgjJv9XMp58UyfcYY1bGYO8ISdNc9k8Mn9JAgXWCHVi3rA1YxIKUr7Xhki92l+C6IgEj2/n2Qj8o+eQFr1AQVa0oylVfn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732877995; c=relaxed/simple;
	bh=SNwRW3SjXKY1ZFWnJjDyfaG1goB/a/ehfVChjwT+XJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7Dc1FlgDIPH+kcmuTrPCDMIYQWq43xcXlPgONMIVUoZjQgGORpimb5jw2xy/2gv1Vo7UQm8tIz+VOn/yXdlRp3a/Vk7FgLc0YG9iG8+o8U7ERJisOqxiaDJUM/g/vKKqGJv5FOC4D09HuTCBFxIw0Yu8Fimr7jt32iBLZhpudM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AnDLIa5F; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434aafd68e9so15903005e9.0
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2024 02:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732877990; x=1733482790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SJf5XdQbXEL1Sgw2WOEw0Ahz9e21x47iqJyxEyLC4FA=;
        b=AnDLIa5Fooi3uexGRAK0msF0cH9vRegMjJizxo44RUXjyb6ZJphOMDRukwrlpXzaYh
         HcbqysTx+u9Bw55bGPxKxTOXa5ybVnIPoWfM8Flu+Jv1tEa7KypnNkUHLLPNqwB5gqxZ
         zm25mdkGnKGO6ao5OF4Nu8VtLK+xT2qiJWFWK+OJEW413YVxER1Tc3TH5bjldGmS4wLY
         WOHL77xXL+FqYvNW8H6IuZtECnrt5imgfy3caqUmIwP7BEp7c8z4dP8/A4tolq3Fg8my
         dR8rqVlObvaCDkMUzregrucYxRb1Ndo9pU7SiVYVEUftOoQyg7lwVxQbwXJOY/2ac8tu
         Cgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732877990; x=1733482790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJf5XdQbXEL1Sgw2WOEw0Ahz9e21x47iqJyxEyLC4FA=;
        b=MxI7jIYcrRCKyE4f/VyUaMYSMemewEU45wuJ9Oo0jUSHFM4Q9BXu8lKNVh4rzBWTEP
         mxTefA7qvd4pWKRCFkKpEszNmad+YMfhUXO1gxY/sL1Ty/87b3WqBVoIKkxAOaEHIufW
         EbVZUsrB2AlwutmTJt17SY0PruhPcJ6ZxWM3WQG2lEXqSaSnwgurb6oCzZc85ETGsL0v
         hUer7PKOOxB2LjNqMsTjeDWNOmYJuMqVxWtGT5Hu6iQUl8A62wPREgdbo1lHuVHwv0ID
         ERzVVTAgIMKIf3Swc0wINcZg/NOPeTgS+WaVYi0dGsa/P8cbxLPWTaYftjKM/Be2H5sv
         1Auw==
X-Forwarded-Encrypted: i=1; AJvYcCWnjfU8SynOLUoLvVXOhRO0ZGD6WTwnTihlFws/gIX4FkeQXqthTV/A5dLr9PIZYUrnaII=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGIJ4ed9alvj2TsbC1Cy8SKsra6gpIKOdvy2Ohf4NWqmGDX6r4
	qPuUIHtWQBxGJz6CYX9O7Stz0vuiEICZq5AwwyB0zuUheKsWbKiDt6zxkwtM308=
X-Gm-Gg: ASbGncvZs1Si6GaKqgbrnAfRUIvUJiRp6BaADSqLyROFCkOtKEp0OdFiCJ2i1EmPXc3
	nt31NwdGZ3I4AVpr01+k7/moaUP9pjYHEeQ/qYcb2L8sX3YG/PpBLuxsHofFracyIW49cBaMf3N
	CaabCYu/AvGQnSBt/NnIe1mIfdngRhGj+xrBqKPrNlwqsxp2BdUE65mruxnv/A42/bz48TxX3S4
	mQ6i9n63MLBue3iYefLH9Mf6cFBlRiVyUACxWKNlp/WFlGWzcjtBBVjLqIiQvJMxhrWSm2NBv3p
	BiAH1OFxmmgvWBELhWBi
X-Google-Smtp-Source: AGHT+IEFvlBaAGrXmQ1f53t1gNO9ZXDjgXJ7+Z1T1Y6D6ANh0a3wVCJfUlsp51urZAZYyjm84XXQSg==
X-Received: by 2002:a05:600c:1988:b0:434:9f78:17d2 with SMTP id 5b1f17b1804b1-434a9df09bfmr91315735e9.29.1732877990325;
        Fri, 29 Nov 2024 02:59:50 -0800 (PST)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434aa74f18bsm83023605e9.4.2024.11.29.02.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 02:59:49 -0800 (PST)
Message-ID: <b89c0b9c-e12a-4915-b657-16d9ba297a86@linaro.org>
Date: Fri, 29 Nov 2024 11:59:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM
 builds
To: Phil Dennis-Jordan <lists@philjordan.eu>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "Shukla, Santosh" <santosh.shukla@amd.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, mtosatti@redhat.com, suravee.suthikulpanit@amd.com
References: <20241113144923.41225-1-phil@philjordan.eu>
 <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
 <ed2246ca-3ede-918c-d18d-f47cf8758d8c@amd.com>
 <CABgObfYhQDmjh4MJOaqeAv0=cFUR=iaoLeSoGYh9iMnjDKM2aA@mail.gmail.com>
 <CAGCz3vtTgo6YdgBxO+5b-W04m3k1WhdiaqH1_ojgj_ywjZmV7A@mail.gmail.com>
 <e9404dd2-56d2-4c6d-81f2-76060c4b4067@linaro.org>
 <CAGCz3vtxjKH0H8BL4ES_phNK8=Dy4Jzg3d7dLyNxuBQaSjTPQA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAGCz3vtxjKH0H8BL4ES_phNK8=Dy4Jzg3d7dLyNxuBQaSjTPQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28/11/24 20:06, Phil Dennis-Jordan wrote:
> On Thu, 28 Nov 2024 at 17:46, Philippe Mathieu-Daudé <philmd@linaro.org 
> <mailto:philmd@linaro.org>> wrote:
> 
>     On 28/11/24 17:38, Phil Dennis-Jordan wrote:
>      > Paolo, could we please apply either Sairaj and Santosh's fix at
>      > https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/
>     <https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/>
>      >
>     <https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/
>     <https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/>>
>      > or mine to fix this link error? As neither patch has so far been
>     merged,
>      > 9.2.0-rc2 still fails to build on macOS, at least on my local
>     systems.
>      > I'm not sure why CI builds aren't jumping up and down about this,
>     but
>      > neither the Xcode 15.2 nor 16.1 toolchains are happy on macOS
>     14.7/arm64.
> 
>     Just curious, is your build configured with --enable-hvf --enable-tcg?
> 
> 
> It's my understanding that both HVF and TCG are enabled by default when 
> building on macOS - they both show up as "YES" in the ./configure 
> output, and the relevant -accel works; at any rate, specifying them 
> explicitly made no difference with regard to this link error. Your 
> question did however prompt me to dig a little deeper and check which of 
> my test configurations was affected.
> 
> It looks like the critical setting is --enable-debug. I think that 
> changes the exact optimisation level (not -O0 but less aggressive than 
> the default), so it's not unreasonable that this would change the 
> compiler pass(es) for eliminating constant conditional branches.
> 
> So yeah, when I build latest master/staging with --enable-debug on macOS 
> and my --target-list includes x86_64, QEMU fails to link with an 
> undefined symbol error for _kvm_enable_x2apic. This happens on both 
> arm64 and x86-64 hosts, and with various Xcode 15.x and 16.y toolchains.

Indeed:

C compiler for the host machine: clang (clang 16.0.0 "Apple clang 
version 16.0.0 (clang-1600.0.26.4)")
C linker for the host machine: clang ld64 1115.7.3
Host machine cpu family: aarch64
Host machine cpu: aarch64
   Compilation
     host CPU                        : aarch64
     host endianness                 : little
     C compiler                      : clang
     Host C compiler                 : clang
     C++ compiler                    : NO
     Objective-C compiler            : clang
     Rust support                    : NO
     CFLAGS                          : -g -O0
   User defined options
     optimization                    : 0

Undefined symbols for architecture arm64:
   "_kvm_enable_x2apic", referenced from:
       _amdvi_sysbus_realize in hw_i386_amd_iommu.c.o
ld: symbol(s) not found for architecture arm64


> I have to admit I'm personally not a big fan of relying on the optimiser 
> for removing references to these symbols, but restructuring the 
> conditional expression like in Sairaj and Santosh's patch seems to allow 
> even the optimisation level used for debug builds to do it, so I guess I 
> can't argue with the result. :-)

See related commit 9926cf34de5 ("target/i386: Allow elision of 
kvm_enable_x2apic()").


