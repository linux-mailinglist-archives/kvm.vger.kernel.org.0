Return-Path: <kvm+bounces-22463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1795693E5DB
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 17:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D8661F215A3
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 15:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D8456B81;
	Sun, 28 Jul 2024 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="rD9C27cS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04D047F6B
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722180470; cv=none; b=ZaNqLM5mUh+p+1p5M/Jr68kf5nl587lqX8OtEd0AV/gN179uEsdZ5X5Z/2fAt+yKxfy6sihNB/oTD1sZafZaPzICJpR2dh4PB7Rs9aA94FM+rUialvHgCpUVkvYZlwZ61bfa/VjTs9ZNLS/rlbYFKFwxsFwJ5wvhzszOtMYQQX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722180470; c=relaxed/simple;
	bh=4ZHhvY1pzbs+Da7L0O/ii6TZaV0p/rp5WSzgkr33w8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9KUXM2zuV6s7Uro7wJAROU0P2wakMErEgG2q7IWte1IylHwHGsznVNw+iVMuwcayIDcc9KHiImZo2uwrgk/GkGKrKwWjLOD+E6eMhXPetH6GSAlT+jP6n6DL9U8CINoYEzETYcgLn2VWBcn2qXeTX2Vv5vKX5xj07nWqqtOZvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=rD9C27cS; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70aec66c936so1750498b3a.0
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1722180468; x=1722785268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLNZtX5NhiWjh8pTpiHyCLdAqm/MusJQss3pc8cjtvA=;
        b=rD9C27cStL2+GyLlP9lYQF7geGII1r1AjeURzplqxbS/J/T5Z25qwdBkaqgIsnBfgV
         TKi4xJVg57xJIXuOW65yyynZrl0Qo2I2JPfDKgJKfEBMARRWACZT6uxbVckhdRQoVrLi
         7Kjnt4RynI5UjKpl/QnAEhGyvE/eWi0h60cshUMDj+z5Ru48O224tVdMJx9zf1Pn9RZK
         ICsW8diiRbCpyjRRphCYFsnmNbqRqy1DwtjkbTr1unyzEZc/2SOsTMRcQk1SF6uA10k3
         /bhT8MPOO0mlJLlNwPo/kzc4sZqyHOSiiXTbs8bCOH84vEesyq9WBzEu5Hvm5Zl74yWW
         1uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722180468; x=1722785268;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLNZtX5NhiWjh8pTpiHyCLdAqm/MusJQss3pc8cjtvA=;
        b=m2wroIC84ECKzDBT53Mq2el6sLSa2VqdWTjFEdf0xihgFMBCZNkhj18PjLia3CI+xk
         8oS78DqpSnY2xpIS5K/wi0ZmU9u1Dvdy06feId9aWjPLUSt1cIsjTpwseuKh3BHl+d+D
         Xeu5AIf0K1dzWc8Ha671OSbImMjL9NCmWOpW2v2FPyCZ9mPdrGWXBBLHk+XGzHZ7Ms72
         cu26SML1OwkuyQJ13BMM2RLlHDspIxTl86fVzLWRvM38yE5j9fOo5JxiXfqEmOQ2cvJE
         eyoic7i7F66Nxhby1CnMuYA+c34OPi9S8qtFJ4m4eZdx20jEKjjuQ8Y5xhhTRRfMReNn
         dUVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvLptAWChz41LOLu8+ZV/Mq87XGf4Ck2waRIKW468tW7KvJ1E5u6A/4ka68uPdXlkzZipExB5vPSgbMiw3v4ChXIFR
X-Gm-Message-State: AOJu0YzEt7JuGkHoVP/XhWgbiWIX4Wx0Prn4GTNYCGHQEWmYnBn/AUs7
	bAs5CQyOQaQHqcUHcL3EeJ9a7E/LB9g1rFkzObw/o6HBbrIUR48kBmUUKCXX7pU=
X-Google-Smtp-Source: AGHT+IF3ctAx7D4BmK/J3K8ksZbvsUjXa+3JPF7azc14f59vwyWxf75VXj4f3Ql1F8QaYpsSFuIiqQ==
X-Received: by 2002:a05:6a00:4fd2:b0:70b:3175:1f4f with SMTP id d2e1a72fcca58-70ecea40e8amr3771492b3a.16.1722180468007;
        Sun, 28 Jul 2024 08:27:48 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:32ed:25ae:21b1:72d6? ([2400:4050:a840:1e00:32ed:25ae:21b1:72d6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead814233sm5419684b3a.124.2024.07.28.08.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jul 2024 08:27:47 -0700 (PDT)
Message-ID: <27dda662-baef-4f09-86e0-168ab1d47a87@daynix.com>
Date: Mon, 29 Jul 2024 00:27:43 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] Bump Avocado to 103.0 LTS and update tests for
 compatibility and new features
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240726134438.14720-1-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/26 22:44, Cleber Rosa wrote:
> This is a *long* overdue update of the Avocado version used in QEMU.
> It comes a time where the role of the runner and the libraries are
> being discussed and questioned.
> 
> These exact commits have been staging on my side for over 30 days now,
> and I was exceeding what I should in terms of testing before posting.
> I apologize for the miscalculation.
> 
> Nevertheless, as pointed out, on the ML, these changes are needed NOW.
> 
> Some examples of runs in the CI can be seen below:
> 
> * Serial with 103.0 LTS (https://gitlab.com/cleber.gnu/qemu/-/jobs/7074346143#L220):
>     RESULTS    : PASS 46 | ERROR 0 | FAIL 0 | SKIP 2 | WARN 0 | INTERRUPT 0 | CANCEL 0
>     JOB TIME   : 432.63 s
> 
> * Parallel with 103.0 LTS (https://gitlab.com/cleber.gnu/qemu/-/jobs/7085879478#L222)
>     RESULTS    : PASS 46 | ERROR 0 | FAIL 0 | SKIP 2 | WARN 0 | INTERRUPT 0 | CANCEL 0
>     JOB TIME   : 148.99 s
> 
> Cleber Rosa (13):
>    tests/avocado: mips: fallback to HTTP given certificate expiration
>    tests/avocado: mips: add hint for fetchasset plugin
>    tests/avocado/intel_iommu.py: increase timeout
>    tests/avocado: add cdrom permission related tests
>    tests/avocado: machine aarch64: standardize location and RO access
>    tests/avocado: use more distinct names for assets
>    tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
>    testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
>    tests/avocado/boot_xen.py: fetch kernel during test setUp()
>    tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
>    tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
>    Bump avocado to 103.0
>    Avocado tests: allow for parallel execution of tests
> 
>   docs/devel/testing.rst                   | 12 +++++++
>   pythondeps.toml                          |  2 +-
>   tests/Makefile.include                   |  6 +++-
>   tests/avocado/boot_linux_console.py      | 24 ++++++++------
>   tests/avocado/boot_xen.py                | 13 ++++----
>   tests/avocado/cdrom.py                   | 41 ++++++++++++++++++++++++
>   tests/avocado/intel_iommu.py             |  2 ++
>   tests/avocado/kvm_xen_guest.py           | 30 +++++++++++------
>   tests/avocado/machine_aarch64_sbsaref.py | 11 +++++--
>   tests/avocado/machine_aarch64_virt.py    | 14 ++++----
>   tests/avocado/netdev-ethtool.py          |  3 +-
>   tests/avocado/tuxrun_baselines.py        | 16 ++++-----
>   12 files changed, 125 insertions(+), 49 deletions(-)
>   create mode 100644 tests/avocado/cdrom.py
> 

Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>

